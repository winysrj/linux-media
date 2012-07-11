Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:63315 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101Ab2GKPfH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Jul 2012 11:35:07 -0400
Date: Wed, 11 Jul 2012 17:34:54 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCH v6] media: mx2_camera: Fix mbus format handling
Message-ID: <Pine.LNX.4.64.1207111652370.18999@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

From: Javier Martin <javier.martin@vista-silicon.com>

Do not use MX2_CAMERA_SWAP16 and MX2_CAMERA_PACK_DIR_MSB flags. The driver 
must negotiate with the attached sensor whether the mbus format is UYUV or 
YUYV and set CSICR1 configuration accordingly.

This is needed for the video function on mach-imx27_visstrim_m10.c to 
perform properly, since an earlier version of this patch has been proven 
wrong and has been reverted and a commit, depending on it: "[media] 
i.MX27: visstrim_m10: Remove use of MX2_CAMERA_SWAP16" is in the mainline.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
Reviewed-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
[g.liakhovetski@gmx.de: move a macro definition to a more logical place]
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
- ---

Hi Linus

Please, apply this patch to 3.5. Normally it would go via Mauro's media 
tree, but he is on a holiday atm. and might not return in time for the 3.5 
final release. Mauro has reviewed an earlier version of this patch and 
confirmed, that the breakage risk is sufficiently low, so, he agreed to me 
sending this patch directly to you with an ack from one more active V4L2 
maintainer (Laurent).

Thanks
Guennadi

 drivers/media/video/mx2_camera.c |   27 ++++++++++++++++++++++-----
 1 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
index 41f9a25..637bde8 100644
- --- a/drivers/media/video/mx2_camera.c
+++ b/drivers/media/video/mx2_camera.c
@@ -83,6 +83,7 @@
 #define CSICR1_INV_DATA		(1 << 3)
 #define CSICR1_INV_PCLK		(1 << 2)
 #define CSICR1_REDGE		(1 << 1)
+#define CSICR1_FMT_MASK		(CSICR1_PACK_DIR | CSICR1_SWAP16_EN)
 
 #define SHIFT_STATFF_LEVEL	22
 #define SHIFT_RXFF_LEVEL	19
@@ -230,6 +231,7 @@ struct mx2_prp_cfg {
 	u32 src_pixel;
 	u32 ch1_pixel;
 	u32 irq_flags;
+	u32 csicr1;
 };
 
 /* prp resizing parameters */
@@ -330,6 +332,7 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
 			.ch1_pixel	= 0x2ca00565, /* RGB565 */
 			.irq_flags	= PRP_INTR_RDERR | PRP_INTR_CH1WERR |
 						PRP_INTR_CH1FC | PRP_INTR_LBOVF,
+			.csicr1		= 0,
 		}
 	},
 	{
@@ -343,6 +346,21 @@ static struct mx2_fmt_cfg mx27_emma_prp_table[] = {
 			.irq_flags	= PRP_INTR_RDERR | PRP_INTR_CH2WERR |
 					PRP_INTR_CH2FC | PRP_INTR_LBOVF |
 					PRP_INTR_CH2OVF,
+			.csicr1		= CSICR1_PACK_DIR,
+		}
+	},
+	{
+		.in_fmt		= V4L2_MBUS_FMT_UYVY8_2X8,
+		.out_fmt	= V4L2_PIX_FMT_YUV420,
+		.cfg		= {
+			.channel	= 2,
+			.in_fmt		= PRP_CNTL_DATA_IN_YUV422,
+			.out_fmt	= PRP_CNTL_CH2_OUT_YUV420,
+			.src_pixel	= 0x22000888, /* YUV422 (YUYV) */
+			.irq_flags	= PRP_INTR_RDERR | PRP_INTR_CH2WERR |
+					PRP_INTR_CH2FC | PRP_INTR_LBOVF |
+					PRP_INTR_CH2OVF,
+			.csicr1		= CSICR1_SWAP16_EN,
 		}
 	},
 };
@@ -1015,14 +1033,14 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
 		return ret;
 	}
 
+	csicr1 = (csicr1 & ~CSICR1_FMT_MASK) | pcdev->emma_prp->cfg.csicr1;
+
 	if (common_flags & V4L2_MBUS_PCLK_SAMPLE_RISING)
 		csicr1 |= CSICR1_REDGE;
 	if (common_flags & V4L2_MBUS_VSYNC_ACTIVE_HIGH)
 		csicr1 |= CSICR1_SOF_POL;
 	if (common_flags & V4L2_MBUS_HSYNC_ACTIVE_HIGH)
 		csicr1 |= CSICR1_HSYNC_POL;
- -	if (pcdev->platform_flags & MX2_CAMERA_SWAP16)
- -		csicr1 |= CSICR1_SWAP16_EN;
 	if (pcdev->platform_flags & MX2_CAMERA_EXT_VSYNC)
 		csicr1 |= CSICR1_EXT_VSYNC;
 	if (pcdev->platform_flags & MX2_CAMERA_CCIR)
@@ -1033,8 +1051,6 @@ static int mx2_camera_set_bus_param(struct soc_camera_device *icd)
 		csicr1 |= CSICR1_GCLK_MODE;
 	if (pcdev->platform_flags & MX2_CAMERA_INV_DATA)
 		csicr1 |= CSICR1_INV_DATA;
- -	if (pcdev->platform_flags & MX2_CAMERA_PACK_DIR_MSB)
- -		csicr1 |= CSICR1_PACK_DIR;
 
 	pcdev->csicr1 = csicr1;
 
@@ -1109,7 +1125,8 @@ static int mx2_camera_get_formats(struct soc_camera_device *icd,
 		return 0;
 	}
 
- -	if (code == V4L2_MBUS_FMT_YUYV8_2X8) {
+	if (code == V4L2_MBUS_FMT_YUYV8_2X8 ||
+	    code == V4L2_MBUS_FMT_UYVY8_2X8) {
 		formats++;
 		if (xlate) {
 			/*
- -- 
1.7.2.5

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk/9nR4ACgkQU6Nrc+zHHwhaJgCdHhGpfTJRl98dVtdNTQ3qCQto
a80AoImxMJCcQQbwpWMnu1+fKNDk60xA
=iSea
-----END PGP SIGNATURE-----
