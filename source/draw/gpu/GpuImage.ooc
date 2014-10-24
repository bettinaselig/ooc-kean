//
// Copyright (c) 2011-2014 Simon Mika <simon@mika.se>
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.

use ooc-draw
use ooc-math
use ooc-base
import GpuCanvas, GpuContext

GpuImageType: enum {
	monochrome
	rgba
	rgb
	bgr
	bgra
	uv
	yuvSemiplanar
	yuvPlanar
}

GpuImage: abstract class extends Image {
	canvas: GpuCanvas { get {
		if (this _canvas == null)
			this _canvas = this _createCanvas()
		this _canvas } }
	_canvas: GpuCanvas
	_backend: Pointer
	_context: GpuContext
	init: func (=size, =_context)
	bind: abstract func (unit: UInt)
	recycle: func {
		this _context recycle(this)
	}
	dispose: abstract func
	generateMipmap: func

	//TODO: Implement abstract functions
	create: func (size: IntSize2D) -> This {
		raise("Unimplemented")
	}
	resizeTo: func (size: IntSize2D) -> This {
		raise("Using unimplemented function reSizeTo in GpuImage class")
	}
	copy: func -> This {
		raise("Using unimplemented function copy in GpuImage class")
	}
	copy: func ~fromParams (size: IntSize2D, transform: FloatTransform2D) -> This {
		raise("Using unimplemented function copy ~fromParams in GpuImage class")
	}
	shift: func (offset: IntSize2D) -> This {
		raise("Using unimplemented function shift in GpuImage class")
	}
	distance: func (other: This) -> Float {
		raise("Using unimplemented function distance in GpuImage class")
	}
	toRaster: func -> RasterImage {
		this _context toRaster(this)
	}
	toRasterDefault: abstract func -> RasterImage
	_createCanvas: abstract func -> GpuCanvas

}
