Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48554 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbeIKUue (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Sep 2018 16:50:34 -0400
Date: Tue, 11 Sep 2018 12:50:31 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Paul Kocialkowski <contact@paulk.fr>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devel@driverdev.osuosl.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v9 5/9] media: platform: Add Cedrus VPU decoder driver
Message-ID: <20180911124625.6759e429@coco.lan>
In-Reply-To: <20180906222442.14825-6-contact@paulk.fr>
References: <20180906222442.14825-1-contact@paulk.fr>
        <20180906222442.14825-6-contact@paulk.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri,  7 Sep 2018 00:24:38 +0200
Paul Kocialkowski <contact@paulk.fr> escreveu:

> From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> 
> This introduces the Cedrus VPU driver that supports the VPU found in
> Allwinner SoCs, also known as Video Engine. It is implemented through
> a V4L2 M2M decoder device and a media device (used for media requests).
> So far, it only supports MPEG-2 decoding.
> 
> Since this VPU is stateless, synchronization with media requests is
> required in order to ensure consistency between frame headers that
> contain metadata about the frame to process and the raw slice data that
> is used to generate the frame.
> 
> This driver was made possible thanks to the long-standing effort
> carried out by the linux-sunxi community in the interest of reverse
> engineering, documenting and implementing support for the Allwinner VPU.
> 
> Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
> Acked-by: Maxime Ripard <maxime.ripard@bootlin.com>

There are several checkpatch issues here. Ok, some can be
ignored, but there are at least some of them that sounds relevant.

Please address them.

In particular, see https://lkml.org/lkml/2017/11/21/384.

Also, for new drivers, please use --strict parameter on checkpatch,
as it will give more insights about possible bad coding styles.

This is what checkpatch currently complains:


CHECK: Comparison to NULL could be written "ctx->ctrls[i]"
#214: FILE: drivers/staging/media/sunxi/cedrus/cedrus.c:51:
+	for (i = 0; ctx->ctrls[i] != NULL; i++)

CHECK: Alignment should match open parenthesis
#304: FILE: drivers/staging/media/sunxi/cedrus/cedrus.c:141:
+		ctrl_test = v4l2_ctrl_request_hdl_ctrl_find(hdl,
+			cedrus_controls[i].id);

CHECK: Alignment should match open parenthesis
#468: FILE: drivers/staging/media/sunxi/cedrus/cedrus.c:305:
+	ret = v4l2_m2m_register_media_controller(dev->m2m_dev,
+			vfd, MEDIA_ENT_F_PROC_VIDEO_DECODER);

CHECK: Avoid using bool structure members because of possible alignment issues - see: https://lkml.org/lkml/2017/11/21/384
#638: FILE: drivers/staging/media/sunxi/cedrus/cedrus.h:47:
+	bool			required;

WARNING: line over 80 characters
#744: FILE: drivers/staging/media/sunxi/cedrus/cedrus.h:153:
+static inline struct cedrus_buffer *vb2_v4l2_to_cedrus_buffer(const struct vb2_v4l2_buffer *p)

WARNING: line over 80 characters
#749: FILE: drivers/staging/media/sunxi/cedrus/cedrus.h:158:
+static inline struct cedrus_buffer *vb2_to_cedrus_buffer(const struct vb2_buffer *p)

CHECK: Alignment should match open parenthesis
#809: FILE: drivers/staging/media/sunxi/cedrus/cedrus_dec.c:47:
+		run.mpeg2.slice_params = cedrus_find_control_data(ctx,
+			V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_PARAMS);

CHECK: Alignment should match open parenthesis
#811: FILE: drivers/staging/media/sunxi/cedrus/cedrus_dec.c:49:
+		run.mpeg2.quantization = cedrus_find_control_data(ctx,
+			V4L2_CID_MPEG_VIDEO_MPEG2_QUANTIZATION);

WARNING: line over 80 characters
#1368: FILE: drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c:133:
+	reg |= VE_DEC_MPEG_MP12HDR_INTRA_DC_PRECISION(picture->intra_dc_precision);

WARNING: line over 80 characters
#1369: FILE: drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c:134:
+	reg |= VE_DEC_MPEG_MP12HDR_INTRA_PICTURE_STRUCTURE(picture->picture_structure);

WARNING: line over 80 characters
#1371: FILE: drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c:136:
+	reg |= VE_DEC_MPEG_MP12HDR_FRAME_PRED_FRAME_DCT(picture->frame_pred_frame_dct);

WARNING: line over 80 characters
#1372: FILE: drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c:137:
+	reg |= VE_DEC_MPEG_MP12HDR_CONCEALMENT_MOTION_VECTORS(picture->concealment_motion_vectors);

WARNING: line over 80 characters
#1395: FILE: drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c:160:
+	fwd_luma_addr = cedrus_dst_buf_addr(ctx, slice_params->forward_ref_index, 0);

WARNING: line over 80 characters
#1396: FILE: drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c:161:
+	fwd_chroma_addr = cedrus_dst_buf_addr(ctx, slice_params->forward_ref_index, 1);

WARNING: line over 80 characters
#1401: FILE: drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c:166:
+	bwd_luma_addr = cedrus_dst_buf_addr(ctx, slice_params->backward_ref_index, 0);

WARNING: line over 80 characters
#1402: FILE: drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c:167:
+	bwd_chroma_addr = cedrus_dst_buf_addr(ctx, slice_params->backward_ref_index, 1);

WARNING: line over 80 characters
#1417: FILE: drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c:182:
+	cedrus_write(dev, VE_DEC_MPEG_VLD_OFFSET, slice_params->data_bit_offset);

CHECK: Macro argument reuse 'x' - possible side-effects?
#1552: FILE: drivers/staging/media/sunxi/cedrus/cedrus_regs.h:74:
+#define VE_DEC_MPEG_MP12HDR_F_CODE_MASK(x, y) \
+	GENMASK(VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y) + 3, \
+		VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y))

CHECK: Macro argument reuse 'y' - possible side-effects?
#1552: FILE: drivers/staging/media/sunxi/cedrus/cedrus_regs.h:74:
+#define VE_DEC_MPEG_MP12HDR_F_CODE_MASK(x, y) \
+	GENMASK(VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y) + 3, \
+		VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y))

CHECK: Macro argument reuse 'x' - possible side-effects?
#1555: FILE: drivers/staging/media/sunxi/cedrus/cedrus_regs.h:77:
+#define VE_DEC_MPEG_MP12HDR_F_CODE(x, y, v) \
+	(((v) << VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y)) & \
+	 VE_DEC_MPEG_MP12HDR_F_CODE_MASK(x, y))

CHECK: Macro argument reuse 'y' - possible side-effects?
#1555: FILE: drivers/staging/media/sunxi/cedrus/cedrus_regs.h:77:
+#define VE_DEC_MPEG_MP12HDR_F_CODE(x, y, v) \
+	(((v) << VE_DEC_MPEG_MP12HDR_F_CODE_SHIFT(x, y)) & \
+	 VE_DEC_MPEG_MP12HDR_F_CODE_MASK(x, y))

CHECK: Macro argument reuse 'a' - possible side-effects?
#1685: FILE: drivers/staging/media/sunxi/cedrus/cedrus_regs.h:207:
+#define VE_DEC_MPEG_VLD_ADDR_BASE(a) \
+	(((a) & GENMASK(27, 4)) | (((a) >> 28) & GENMASK(3, 0)))

CHECK: Comparison to NULL could be written "fmt"
#1805: FILE: drivers/staging/media/sunxi/cedrus/cedrus_video.c:88:
+	return fmt != NULL;

CHECK: Please use a blank line after function/struct/union/enum declarations
#2214: FILE: drivers/staging/media/sunxi/cedrus/cedrus_video.c:497:
+}
+static struct vb2_ops cedrus_qops = {

total: 0 errors, 11 warnings, 13 checks, 2139 lines checked


Thanks,
Mauro
