Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57266 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754922AbcDFMBB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Apr 2016 08:01:01 -0400
Date: Wed, 6 Apr 2016 15:00:22 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, niklas.soderlund+renesas@ragnatech.se,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 1/2] v4l2-rect.h: new header with struct v4l2_rect helper
 functions.
Message-ID: <20160406120022.GL32125@valkosipuli.retiisi.org.uk>
References: <1459712563-8796-1-git-send-email-hverkuil@xs4all.nl>
 <1459712563-8796-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1459712563-8796-2-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Sun, Apr 03, 2016 at 12:42:42PM -0700, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This makes it easier to share this code with any driver that needs to
> manipulate the v4l2_rect datastructure.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/DocBook/device-drivers.tmpl |   1 +
>  include/media/v4l2-rect.h                 | 175 ++++++++++++++++++++++++++++++
>  2 files changed, 176 insertions(+)
>  create mode 100644 include/media/v4l2-rect.h
> 
> diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
> index 184f3c7..893b2ca 100644
> --- a/Documentation/DocBook/device-drivers.tmpl
> +++ b/Documentation/DocBook/device-drivers.tmpl
> @@ -233,6 +233,7 @@ X!Isound/sound_firmware.c
>  !Iinclude/media/v4l2-mediabus.h
>  !Iinclude/media/v4l2-mem2mem.h
>  !Iinclude/media/v4l2-of.h
> +!Iinclude/media/v4l2-rect.h
>  !Iinclude/media/v4l2-subdev.h
>  !Iinclude/media/videobuf2-core.h
>  !Iinclude/media/videobuf2-v4l2.h
> diff --git a/include/media/v4l2-rect.h b/include/media/v4l2-rect.h
> new file mode 100644
> index 0000000..c138557
> --- /dev/null
> +++ b/include/media/v4l2-rect.h
> @@ -0,0 +1,175 @@
> +/*
> + * v4l2-rect.h - v4l2_rect helper functions
> + *
> + * Copyright 2014 Cisco Systems, Inc. and/or its affiliates. All rights reserved.
> + *
> + * This program is free software; you may redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; version 2 of the License.
> + *
> + * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> + * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> + * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
> + * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
> + * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
> + * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
> + * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
> + * SOFTWARE.
> + */
> +
> +#ifndef _V4L2_RECT_H_
> +#define _V4L2_RECT_H_
> +
> +#include <linux/videodev2.h>
> +
> +/**
> + * v4l2_rect_set_size_to() - copy the width/height values.
> + * @r: rect whose width and height fields will be set
> + * @size: rect containing the width and height fields you need.
> + */
> +static inline void v4l2_rect_set_size_to(struct v4l2_rect *r,
> +					 const struct v4l2_rect *size)
> +{
> +	r->width = size->width;
> +	r->height = size->height;
> +}
> +
> +/**
> + * v4l2_rect_set_min_size() - width and height of r should be >= min_size.
> + * @r: rect whose width and height will be modified
> + * @min_size: rect containing the minimal width and height
> + */
> +static inline void v4l2_rect_set_min_size(struct v4l2_rect *r,
> +					  const struct v4l2_rect *min_size)
> +{
> +	if (r->width < min_size->width)
> +		r->width = min_size->width;
> +	if (r->height < min_size->height)
> +		r->height = min_size->height;
> +}
> +
> +/**
> + * v4l2_rect_set_max_size() - width and height of r should be <= max_size
> + * @r: rect whose width and height will be modified
> + * @max_size: rect containing the maximum width and height
> + */
> +static inline void v4l2_rect_set_max_size(struct v4l2_rect *r,
> +					  const struct v4l2_rect *max_size)
> +{
> +	if (r->width > max_size->width)
> +		r->width = max_size->width;
> +	if (r->height > max_size->height)
> +		r->height = max_size->height;
> +}
> +
> +/**
> + * v4l2_rect_map_inside()- r should be inside boundary.
> + * @r: rect that will be modified
> + * @boundary: rect containing the boundary for @r
> + */
> +static inline void v4l2_rect_map_inside(struct v4l2_rect *r,
> +					const struct v4l2_rect *boundary)
> +{
> +	v4l2_rect_set_max_size(r, boundary);

This approach favours size over position. I'm not sure if that's the best
approach in all cases. Well, it's up to the user in the end to set correct
parameters.

> +	if (r->left < boundary->left)
> +		r->left = boundary->left;
> +	if (r->top < boundary->top)
> +		r->top = boundary->top;
> +	if (r->left + r->width > boundary->width)
> +		r->left = boundary->width - r->width;
> +	if (r->top + r->height > boundary->height)
> +		r->top = boundary->height - r->height;
> +}
> +
> +/**
> + * v4l2_rect_same_size() - return true if r1 has the same size as r2
> + * @r1: rectangle.
> + * @r2: rectangle.
> + *
> + * Return true if both rectangles have the same size.
> + */
> +static inline bool v4l2_rect_same_size(const struct v4l2_rect *r1,
> +				       const struct v4l2_rect *r2)
> +{
> +	return r1->width == r2->width && r1->height == r2->height;
> +}
> +
> +/**
> + * v4l2_rect_intersect() - calculate the intersection of two rects.
> + * @r1: rectangle.
> + * @r2: rectangle.
> + *
> + * Returns the intersection of @r1 and @r2.
> + */
> +static inline struct v4l2_rect v4l2_rect_intersect(const struct v4l2_rect *r1,
> +						   const struct v4l2_rect *r2)
> +{
> +	struct v4l2_rect r;
> +	int right, bottom;
> +
> +	r.top = max(r1->top, r2->top);
> +	r.left = max(r1->left, r2->left);
> +	bottom = min(r1->top + r1->height, r2->top + r2->height);
> +	right = min(r1->left + r1->width, r2->left + r2->width);
> +	r.height = max(0, bottom - r.top);
> +	r.width = max(0, right - r.left);
> +	return r;
> +}

API-wise it'd be nicer to add a result argument in front of the other two,
as v4l2_rect_scale() does already.

With that,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

> +
> +/**
> + * v4l2_rect_scale() - scale rect r by to/from
> + * @r: rect to be scaled.
> + * @from: from rectangle.
> + * @to: to rectangle.
> + *
> + * This scales rectangle @r horizontally by @to->width / @from->width and
> + * vertically by @to->height / @from->height.
> + *
> + * Typically @r is a rectangle inside @from and you want the rectangle as
> + * it would appear after scaling @from to @to. So the resulting @r will
> + * be the scaled rectangle inside @to.
> + */
> +static inline void v4l2_rect_scale(struct v4l2_rect *r,
> +				   const struct v4l2_rect *from,
> +				   const struct v4l2_rect *to)
> +{
> +	if (from->width == 0 || from->height == 0) {
> +		r->left = r->top = r->width = r->height = 0;
> +		return;
> +	}
> +	r->left = (((r->left - from->left) * to->width) / from->width) & ~1;
> +	r->width = ((r->width * to->width) / from->width) & ~1;
> +	r->top = ((r->top - from->top) * to->height) / from->height;
> +	r->height = (r->height * to->height) / from->height;
> +}
> +
> +/**
> + * v4l2_rect_overlap() - do r1 and r2 overlap?
> + * @r1: rectangle.
> + * @r2: rectangle.
> + *
> + * Returns true if @r1 and @r2 overlap.
> + */
> +static inline bool v4l2_rect_overlap(const struct v4l2_rect *r1,
> +				     const struct v4l2_rect *r2)
> +{
> +	/*
> +	 * IF the left side of r1 is to the right of the right side of r2 OR
> +	 *    the left side of r2 is to the right of the right side of r1 THEN
> +	 * they do not overlap.
> +	 */
> +	if (r1->left >= r2->left + r2->width ||
> +	    r2->left >= r1->left + r1->width)
> +		return false;
> +	/*
> +	 * IF the top side of r1 is below the bottom of r2 OR
> +	 *    the top side of r2 is below the bottom of r1 THEN
> +	 * they do not overlap.
> +	 */
> +	if (r1->top >= r2->top + r2->height ||
> +	    r2->top >= r1->top + r1->height)
> +		return false;
> +	return true;
> +}
> +
> +#endif

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
