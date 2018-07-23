Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43369 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388080AbeGWK3t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Jul 2018 06:29:49 -0400
Message-ID: <1532338170.3501.4.camel@pengutronix.de>
Subject: Re: [PATCH v2 00/16] i.MX media mem2mem scaler
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <slongerbeam@gmail.com>,
        linux-media@vger.kernel.org
Cc: Nicolas Dufresne <nicolas@ndufresne.ca>, kernel@pengutronix.de
Date: Mon, 23 Jul 2018 11:29:30 +0200
In-Reply-To: <38565a74-7c79-1af6-6ed6-b44a20c9266c@gmail.com>
References: <20180719153042.533-1-p.zabel@pengutronix.de>
         <38565a74-7c79-1af6-6ed6-b44a20c9266c@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Sun, 2018-07-22 at 11:30 -0700, Steve Longerbeam wrote:
> Hi Philipp,
> 
> On 07/19/2018 08:30 AM, Philipp Zabel wrote:
> > Hi,
> > 
> > this is the second version of the i.MX mem2mem scaler series.
> > Patches 8 and 16 have been modified.
> > 
> > Changes since v1:
> >   - Fix inverted allow_overshoot logic
> >   - Correctly switch horizontal / vertical tile alignment when
> >     determining seam positions with the 90° rotator active.
> 
> Yes, this fixes the specific rotation test that was broken
> (720x480, UYVY --> 1280x768, UYVY, rotate 90).
> 
> But running more tests on this v2 reveals more issues. I chose a
> somewhat random upscaling-only example as a first try:
> 
> 640x480, YV12 --> full HD 2560x1600, YV12 (no rotation or flip).
>
> This produces division by zero backtraces and the conversion hangs:
> 
> 
> [  131.079978] Division by zero in kernel.
[...]

Thanks, find_best_seam() breaks because it is fed the wrong bottom edge:

----------8<----------
diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 726e3b7390c7..0c47d39adf03 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -806,7 +801,7 @@ static void find_seams(struct ipu_image_convert_ctx *ctx,
                /* Start within 1024 lines of the bottom edge */
                out_start = max_t(int, 0, out_bottom - 1024);
                /* End before having to add more rows above */
-               out_end = min_t(unsigned int, out_right, row * 1024);
+               out_end = min_t(unsigned int, out_bottom, row * 1024);
 
                find_best_seam(ctx, out_start, out_end,
                               in_top_align, out_top_align, out_height_align,
---------->8----------

Also we unnecessarily use four tile columns instead of three:

----------8<----------
diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 726e3b7390c7..0c47d39adf03 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -380,12 +380,7 @@ static int alloc_dma_buf(struct ipu_image_convert_priv *priv,
 
 static inline int num_stripes(int dim)
 {
-       if (dim <= 1024)
-               return 1;
-       else if (dim <= 2048)
-               return 2;
-       else
-               return 4;
+       return (dim - 1) / 1024 + 1;
 }
 
 /*
---------->8----------

With that fixed, your test case succeeds.

Unfortunately, just adding rotate=90 makes it hang again. I'll
investigate.

> To aid in debugging this I created branch 'imx-mem2mem.stevel' in my
> mediatree fork on github. I moved the mem2mem driver to the beginning
> and added a few patches:
> 
> d317a7771c ("gpu: ipu-cpmem: add WARN_ON_ONCE() for unaligned dma buffers")
> b4362162c0 ("media: imx: mem2mem: Use ipu_image_convert_adjust in try 
> format")
> 4758be0cf8 ("gpu: ipu-v3: image-convert: Fix width/height alignment")
> d069163c7f ("gpu: ipu-v3: image-convert: Fix input bytesperline clamp in 
> adjust")
> 
> (feel free to squash some of those if you agree with them for v3).
>
> By moving the mem2mem driver before the seam avoidance patches, and making
> it independent of the image converter implementation, the driver can be 
> tested with
> and without the seam avoidance changes.

Yes, this makes sense to me. If we merge the mem2mem driver before the
image-convert changes go in, it should be limited to 1024x1024 output,
but if we manage to merge both parts in the same cycle, this should be
fine.

[...]
> Also, I'm trying to parse the functions find_best_seam() and 
> find_seams(). Can
> you provide some more background on the behavior of those functions?

The hardware limits us to restart linear sampling at zero with each
tile, so find_seams() tries to find the (horizontal and vertical) output
positions where the corresponding input sampling positions are closest
to integer values.
The distance between the ideal fractional input sampling position and
the actual integer sampling position that can be achieved is the amount
of distortion we have to introduce (by slightly stretching one input
tile and slightly shrinking the other) to completely hide the visible
seams.

find_best_seam() contains the code to find the left (or top) edge for a
single column (or row) that minimizes this distortion, given the right
(or bottom) edge, scaling factor, alignment restrictions, and allowed
range. The range is limited by the maximum tile width (or height).

find_seams() first iterates over all columns, right to left, and calls
find_best_seam() for each column. Each found seam then serves as the
right edge of the next column. Then it iterates over all rows, bottom to
top, again calling find_best_seam() for each row.

The reason we start at the bottom/right edges is that we have to make
sure that burst size / rotator block size align with the bottom/right
edge of the output frame.

regards
Philipp
