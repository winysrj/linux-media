Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43577 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727531AbeGPOhv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jul 2018 10:37:51 -0400
Message-ID: <1531750212.18173.19.camel@pengutronix.de>
Subject: Re: [PATCH 00/16] i.MX media mem2mem scaler
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-media@vger.kernel.org
Cc: kernel@pengutronix.de, Steve Longerbeam <slongerbeam@gmail.com>
Date: Mon, 16 Jul 2018 16:10:12 +0200
In-Reply-To: <828c3de1-0afd-d128-7e1d-f735e7a2f4f9@mentor.com>
References: <20180622155217.29302-1-p.zabel@pengutronix.de>
         <828c3de1-0afd-d128-7e1d-f735e7a2f4f9@mentor.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Thu, 2018-07-05 at 14:55 -0700, Steve Longerbeam wrote:
> Hi Philipp,
> 
> Thanks for this great patchset! Finally we have improved seams
> with tiled conversions, and relaxed width alignment requirements.
> 
> Unfortunately this patchset isn't working correctly yet. It breaks tiled
> conversions with rotation.
>
> Trying the following conversion:
> 
> input: 720x480, UYVY
> output: 1280x768, UYVY, rotation=90 degrees
>
> causes non-8-byte aligned tile buffers at the output:
> 
> [  129.578210] imx-ipuv3 2400000.ipu: task 2: ctx 8955dec9: Input@[0,0]: 
> phys 00000000
> [  129.585980] imx-ipuv3 2400000.ipu: task 2: ctx 8955dec9: Input@[1,0]: 
> phys 00051360
> [  129.593736] imx-ipuv3 2400000.ipu: task 2: ctx 8955dec9: 
> Output@[0,0]: phys 00000000
> [  129.601556] imx-ipuv3 2400000.ipu: task 2: ctx 8955dec9: 
> Output@[0,1]: phys 0000052e
> 
> resulting in hung conversion and abort timeout:
> 
> [  147.689220] imx-ipuv3 2400000.ipu: ipu_image_convert_abort: timeout
> 
> Note that when converting to a planar format, the final (rotated) chroma 
> tile
> buffers are also mis-aligned, in addition to the Y buffers.

Ouch, thanks. Calculation of the allow_overshoot parameter to
find_best_seam() is inverted and the seam alignment does not
properly switch output width/height in the IRT case.

I'll fix this in v2:

----------8<----------
diff --git a/drivers/gpu/ipu-v3/ipu-image-convert.c b/drivers/gpu/ipu-v3/ipu-image-convert.c
index 4eb76714505a..8e125def4f5c 100644
--- a/drivers/gpu/ipu-v3/ipu-image-convert.c
+++ b/drivers/gpu/ipu-v3/ipu-image-convert.c
@@ -683,6 +683,11 @@ static void find_seams(struct ipu_image_convert_ctx *ctx,
 	if (ipu_rot_mode_is_irt(ctx->rot_mode)) {
 		resized_width = out->base.rect.height;
 		resized_height = out->base.rect.width;
+		out_left_align = tile_top_align(out->fmt);
+		out_top_align = tile_left_align(out->fmt);
+		out_width_align = tile_height_align(out->type,
+						    ctx->rot_mode);
+		out_height_align = tile_width_align(out->fmt);
 		out_right = out->base.rect.height;
 		out_bottom = out->base.rect.width;
 	}
@@ -732,7 +737,7 @@ static void find_seams(struct ipu_image_convert_ctx *ctx,
 	}
 
 	for (col = in->num_cols - 1; col > 0; col--) {
-		bool allow_overshoot = (col == in->num_cols - 1) &&
+		bool allow_overshoot = (col < in->num_cols - 1) &&
 				       !(ctx->rot_mode & IPU_ROT_BIT_HFLIP);
 		unsigned int out_start;
 		unsigned int out_end;
@@ -775,6 +780,7 @@ static void find_seams(struct ipu_image_convert_ctx *ctx,
 		in_right, flipped_out_left, out_right);
 
 	for (row = in->num_rows - 1; row > 0; row--) {
+		bool allow_overshoot = row < in->num_rows - 1;
 		unsigned int out_start;
 		unsigned int out_end;
 		unsigned int in_top;
@@ -788,8 +794,7 @@ static void find_seams(struct ipu_image_convert_ctx *ctx,
 		find_best_seam(ctx, out_start, out_end,
 			       in_top_align, out_top_align, out_height_align,
 			       ctx->downsize_coeff_v, ctx->image_resize_coeff_v,
-			       row == in->num_rows - 1,
-			       &in_top, &out_top);
+			       allow_overshoot, &in_top, &out_top);
 
 		if ((ctx->rot_mode & IPU_ROT_BIT_VFLIP) ^
 		    ipu_rot_mode_is_irt(ctx->rot_mode))
---------->8----------

regards
Philipp
