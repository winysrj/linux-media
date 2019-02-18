Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9ED1C10F03
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 917572177E
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 19:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550518166;
	bh=8c3EcFsS/22yBBO7ZE0R7E3RlO+dZ3rdNV9Bb8Ulbk8=;
	h=From:Cc:Subject:Date:In-Reply-To:References:To:List-ID:From;
	b=OBnF/b+okWIKcWjgDaKKFyltoID0551hs+6DvwW5yW12KeBzCuY5jYucYcT8Is5mD
	 DvM5U1EorY9M01UcBYasqLxfB9W1JWd0TDqQPGSo7BYsuQDUDkgv5CP4JDBu/iqe2a
	 zf7NuCHaff0H+KxhWRvWl8+JKwb6AFXWw149xzO8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfBRT3Z (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 14:29:25 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34226 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbfBRT3O (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 14:29:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8HEGMC/MKPUNvOfE2tnSNq7i9J8T7bR7siHImQT7GvE=; b=tyttzRJcs5iBIgJ+TFdn0FnY0Y
        +NyWc8IaVHs2OttwbUn5wv+XmaYURgZM74h53E45bCE39eXDdqt1cgyUdZ7bSRP2Z6E+AKXyANV88
        Su34v637wXyA2yupg4+MejQdy6NMRmEjkE5RKq27diHbGUN2XQw8TIYAsrMnlNRV5lIxgsLf8UrOa
        M1MAF9MkrFpW/TO6Tb3hTlv/oO3jyuIbWuWefhUZRxb1/G4q3kjHIVedZ9/QGvnrlYdtQf6XgMlSj
        kwCWLSUzQOvv210MiKl/b68j+Bf4b2blk5jR849hkJCaxzDNPVr5QEhDvU38r1GCEX5y13ra6K8WX
        GuMmQwmA==;
Received: from 177.96.194.24.dynamic.adsl.gvt.net.br ([177.96.194.24] helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gvobJ-0002Uq-9O; Mon, 18 Feb 2019 19:29:13 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.91)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1gvobG-0006gd-HD; Mon, 18 Feb 2019 14:29:10 -0500
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        devel@driverdev.osuosl.org, mjpeg-users@lists.sourceforge.net
Subject: [PATCH 14/14] media: staging: fix several typos
Date:   Mon, 18 Feb 2019 14:29:08 -0500
Message-Id: <7d95c2031acef1b5ad665311d5399fc05d7ad4ff.1550518128.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <f235ba60b2b7e5fba09d3c6b0d5dbbd8a86ea9b9.1550518128.git.mchehab+samsung@kernel.org>
References: <f235ba60b2b7e5fba09d3c6b0d5dbbd8a86ea9b9.1550518128.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Use codespell to fix lots of typos over frontends.

Manually verified to avoid false-positives.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c  | 2 +-
 drivers/staging/media/davinci_vpfe/dm365_isif.c      | 4 ++--
 drivers/staging/media/davinci_vpfe/dm365_resizer.c   | 4 ++--
 drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c | 2 +-
 drivers/staging/media/ipu3/include/intel-ipu3.h      | 4 ++--
 drivers/staging/media/ipu3/ipu3-abi.h                | 2 +-
 drivers/staging/media/ipu3/ipu3.h                    | 2 +-
 drivers/staging/media/omap4iss/iss_csi2.c            | 2 +-
 drivers/staging/media/soc_camera/soc_camera.c        | 4 ++--
 drivers/staging/media/zoran/zoran_card.c             | 2 +-
 drivers/staging/media/zoran/zoran_device.c           | 2 +-
 11 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
index 5618c804c7e4..565a3dc5bed1 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe_hw.c
@@ -781,7 +781,7 @@ ipipe_set_3d_lut_regs(void __iomem *base_addr, void __iomem *isp5_base_addr,
 	if (!lut_3d->en)
 		return;
 
-	/* valied table */
+	/* valid table */
 	tbl = lut_3d->table;
 	for (i = 0; i < VPFE_IPIPE_MAX_SIZE_3D_LUT; i++) {
 		/*
diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index 625d0aa8367f..0a6d038fcec9 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -675,7 +675,7 @@ static void isif_config_bclamp(struct vpfe_isif_device *isif,
 	val = (bc->bc_mode_color & ISIF_BC_MODE_COLOR_MASK) <<
 		ISIF_BC_MODE_COLOR_SHIFT;
 
-	/* Enable BC and horizontal clamp calculation paramaters */
+	/* Enable BC and horizontal clamp calculation parameters */
 	val = val | 1 | ((bc->horz.mode & ISIF_HORZ_BC_MODE_MASK) <<
 	      ISIF_HORZ_BC_MODE_SHIFT);
 
@@ -712,7 +712,7 @@ static void isif_config_bclamp(struct vpfe_isif_device *isif,
 		isif_write(isif->isif_cfg.base_addr, val, CLHWIN2);
 	}
 
-	/* vertical clamp calculation paramaters */
+	/* vertical clamp calculation parameters */
 	/* OB H Valid */
 	val = bc->vert.ob_h_sz_calc & ISIF_VERT_BC_OB_H_SZ_MASK;
 
diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 6098f43ac51b..9d726298b406 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1284,7 +1284,7 @@ static int resizer_set_stream(struct v4l2_subdev *sd, int enable)
  * @cfg: V4L2 subdev pad config
  * @pad: pad number.
  * @which: wanted subdev format.
- * Retun wanted mbus frame format.
+ * Return wanted mbus frame format.
  */
 static struct v4l2_mbus_framefmt *
 __resizer_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
@@ -1785,7 +1785,7 @@ void vpfe_resizer_unregister_entities(struct vpfe_resizer_device *vpfe_rsz)
 
 /*
  * vpfe_resizer_register_entities() - Register entity
- * @resizer - pointer to resizer devive.
+ * @resizer - pointer to resizer device.
  * @vdev: pointer to v4l2 device structure.
  */
 int vpfe_resizer_register_entities(struct vpfe_resizer_device *resizer,
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
index 34d63c2e9199..57b93605bc58 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_mc_capture.c
@@ -528,7 +528,7 @@ static void vpfe_cleanup_modules(struct vpfe_device *vpfe_dev,
  * @vpfe_dev - ptr to vpfe capture device
  * @pdev - pointer to platform device
  *
- * intialize all v4l2 subdevs and media entities
+ * initialize all v4l2 subdevs and media entities
  */
 static int vpfe_initialize_modules(struct vpfe_device *vpfe_dev,
 				   struct platform_device *pdev)
diff --git a/drivers/staging/media/ipu3/include/intel-ipu3.h b/drivers/staging/media/ipu3/include/intel-ipu3.h
index eb6f52aca992..1e7184e4311d 100644
--- a/drivers/staging/media/ipu3/include/intel-ipu3.h
+++ b/drivers/staging/media/ipu3/include/intel-ipu3.h
@@ -432,11 +432,11 @@ struct ipu3_uapi_awb_fr_raw_buffer {
  *
  * @grid_cfg:	grid config, default 16x16.
  * @bayer_coeff:	1D Filter 1x11 center symmetry/anti-symmetry.
- *			coeffcients defaults { 0, 0, 0, 0, 0, 128 }.
+ *			coefficients defaults { 0, 0, 0, 0, 0, 128 }.
  *			Applied on whole image for each Bayer channel separately
  *			by a weighted sum of its 11x1 neighbors.
  * @reserved1:	reserved
- * @bayer_sign:	sign of filter coeffcients, default 0.
+ * @bayer_sign:	sign of filter coefficients, default 0.
  * @bayer_nf:	normalization factor for the convolution coeffs, to make sure
  *		total memory needed is within pre-determined range.
  *		NF should be the log2 of the sum of the abs values of the
diff --git a/drivers/staging/media/ipu3/ipu3-abi.h b/drivers/staging/media/ipu3/ipu3-abi.h
index 25be56ff01c8..e1185602c7fd 100644
--- a/drivers/staging/media/ipu3/ipu3-abi.h
+++ b/drivers/staging/media/ipu3/ipu3-abi.h
@@ -1510,7 +1510,7 @@ struct imgu_abi_blob_info {
 					/* offset wrt hdr in bytes */
 	u32 prog_name_offset;		/* offset wrt hdr in bytes */
 	u32 size;			/* Size of blob */
-	u32 padding_size;		/* total cummulative of bytes added
+	u32 padding_size;		/* total cumulative of bytes added
 					 * due to section alignment
 					 */
 	u32 icache_source;		/* Position of icache in blob */
diff --git a/drivers/staging/media/ipu3/ipu3.h b/drivers/staging/media/ipu3/ipu3.h
index 6b408f726667..73b123b2b8a2 100644
--- a/drivers/staging/media/ipu3/ipu3.h
+++ b/drivers/staging/media/ipu3/ipu3.h
@@ -146,7 +146,7 @@ struct imgu_device {
 	 * vid_buf.list and css->queue
 	 */
 	struct mutex lock;
-	/* Forbit streaming and buffer queuing during system suspend. */
+	/* Forbid streaming and buffer queuing during system suspend. */
 	atomic_t qbuf_barrier;
 	/* Indicate if system suspend take place while imgu is streaming. */
 	bool suspend_in_stream;
diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index 059cf5bd3c36..a6dc2d2b1228 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -712,7 +712,7 @@ static void csi2_isr_ctx(struct iss_csi2_device *csi2,
 
 	/* Skip interrupts until we reach the frame skip count. The CSI2 will be
 	 * automatically disabled, as the frame skip count has been programmed
-	 * in the CSI2_CTx_CTRL1::COUNT field, so reenable it.
+	 * in the CSI2_CTx_CTRL1::COUNT field, so re-enable it.
 	 *
 	 * It would have been nice to rely on the FRAME_NUMBER interrupt instead
 	 * but it turned out that the interrupt is only generated when the CSI2
diff --git a/drivers/staging/media/soc_camera/soc_camera.c b/drivers/staging/media/soc_camera/soc_camera.c
index 21034339cdcb..1ab86a7499b9 100644
--- a/drivers/staging/media/soc_camera/soc_camera.c
+++ b/drivers/staging/media/soc_camera/soc_camera.c
@@ -4,11 +4,11 @@
  * Copyright (C) 2008, Guennadi Liakhovetski <kernel@pengutronix.de>
  *
  * This driver provides an interface between platform-specific camera
- * busses and camera devices. It should be used if the camera is
+ * buses and camera devices. It should be used if the camera is
  * connected not over a "proper" bus like PCI or USB, but over a
  * special bus, like, for example, the Quick Capture interface on PXA270
  * SoCs. Later it should also be used for i.MX31 SoCs from Freescale.
- * It can handle multiple cameras and / or multiple busses, which can
+ * It can handle multiple cameras and / or multiple buses, which can
  * be used, e.g., in stereo-vision applications.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/media/zoran/zoran_card.c b/drivers/staging/media/zoran/zoran_card.c
index 94dadbba7cd5..ea10523194e8 100644
--- a/drivers/staging/media/zoran/zoran_card.c
+++ b/drivers/staging/media/zoran/zoran_card.c
@@ -1470,7 +1470,7 @@ static int __init zoran_init(void)
 		v4l_nbufs = 2;
 	if (v4l_nbufs > VIDEO_MAX_FRAME)
 		v4l_nbufs = VIDEO_MAX_FRAME;
-	/* The user specfies the in KB, we want them in byte
+	/* The user specifies the in KB, we want them in byte
 	 * (and page aligned) */
 	v4l_bufsize = PAGE_ALIGN(v4l_bufsize * 1024);
 	if (v4l_bufsize < 32768)
diff --git a/drivers/staging/media/zoran/zoran_device.c b/drivers/staging/media/zoran/zoran_device.c
index d393e7b8aeda..22b27632762d 100644
--- a/drivers/staging/media/zoran/zoran_device.c
+++ b/drivers/staging/media/zoran/zoran_device.c
@@ -612,7 +612,7 @@ zr36057_set_memgrab (struct zoran *zr,
 		zr->v4l_memgrab_active = 0;
 		zr->v4l_grab_frame = NO_GRAB_ACTIVE;
 
-		/* reenable grabbing to screen if it was running */
+		/* re-enable grabbing to screen if it was running */
 		if (zr->v4l_overlay_active) {
 			zr36057_overlay(zr, 1);
 		} else {
-- 
2.20.1

