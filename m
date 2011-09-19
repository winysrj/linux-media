Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:58138 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab1ISFfj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 01:35:39 -0400
Received: from dbdp20.itg.ti.com ([172.24.170.38])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p8J5ZZAm030236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 19 Sep 2011 00:35:38 -0500
From: Manjunath Hadli <manjunath.hadli@ti.com>
To: LMML <linux-media@vger.kernel.org>
CC: dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Manjunath Hadli <manjunath.hadli@ti.com>
Subject: [PATCH RESEND 4/4] davinci vpbe: add VENC block changes to enable dm365 and dm355
Date: Mon, 19 Sep 2011 11:05:29 +0530
Message-ID: <1316410529-14744-5-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1316410529-14744-1-git-send-email-manjunath.hadli@ti.com>
References: <1316410529-14744-1-git-send-email-manjunath.hadli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch implements necessary changes for enabling  dm365 and
dm355 hardware for vpbe. The patch contains additional HD mode
support for dm365 (720p60, 1080i30) and appropriate register
modifications based on version numbers.

VPBE_VERSION_2 = dm365 specific
VPBE_VERSION_3 = dm355 specific

Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
---
 drivers/media/video/davinci/vpbe_venc.c |  205 +++++++++++++++++++++++++++----
 include/media/davinci/vpbe_venc.h       |    4 +
 2 files changed, 185 insertions(+), 24 deletions(-)

diff --git a/drivers/media/video/davinci/vpbe_venc.c b/drivers/media/video/davinci/vpbe_venc.c
index 03a3e5c..53c2994 100644
--- a/drivers/media/video/davinci/vpbe_venc.c
+++ b/drivers/media/video/davinci/vpbe_venc.c
@@ -99,6 +99,8 @@ static inline u32 vdaccfg_write(struct v4l2_subdev *sd, u32 val)
 	return val;
 }
 
+#define VDAC_COMPONENT	0x543
+#define VDAC_S_VIDEO	0x210
 /* This function sets the dac of the VPBE for various outputs
  */
 static int venc_set_dac(struct v4l2_subdev *sd, u32 out_index)
@@ -109,11 +111,12 @@ static int venc_set_dac(struct v4l2_subdev *sd, u32 out_index)
 		venc_write(sd, VENC_DACSEL, 0);
 		break;
 	case 1:
-		v4l2_dbg(debug, 1, sd, "Setting output to S-Video\n");
-		venc_write(sd, VENC_DACSEL, 0x210);
+		v4l2_dbg(debug, 1, sd, "Setting output to Component\n");
+		venc_write(sd, VENC_DACSEL, VDAC_COMPONENT);
 		break;
-	case  2:
-		venc_write(sd, VENC_DACSEL, 0x543);
+	case 2:
+		v4l2_dbg(debug, 1, sd, "Setting output to S-video\n");
+		venc_write(sd, VENC_DACSEL, VDAC_S_VIDEO);
 		break;
 	default:
 		return -EINVAL;
@@ -124,6 +127,8 @@ static int venc_set_dac(struct v4l2_subdev *sd, u32 out_index)
 
 static void venc_enabledigitaloutput(struct v4l2_subdev *sd, int benable)
 {
+	struct venc_state *venc = to_state(sd);
+	struct venc_platform_data *pdata = venc->pdata;
 	v4l2_dbg(debug, 2, sd, "venc_enabledigitaloutput\n");
 
 	if (benable) {
@@ -155,7 +160,8 @@ static void venc_enabledigitaloutput(struct v4l2_subdev *sd, int benable)
 
 		/* Disable LCD output control (accepting default polarity) */
 		venc_write(sd, VENC_LCDOUT, 0);
-		venc_write(sd, VENC_CMPNT, 0x100);
+		if (pdata->venc_type != VPBE_VERSION_3)
+			venc_write(sd, VENC_CMPNT, 0x100);
 		venc_write(sd, VENC_HSPLS, 0);
 		venc_write(sd, VENC_HINT, 0);
 		venc_write(sd, VENC_HSTART, 0);
@@ -178,11 +184,14 @@ static void venc_enabledigitaloutput(struct v4l2_subdev *sd, int benable)
 	}
 }
 
+#define VDAC_CONFIG_SD_V3	0x0E21A6B6
+#define VDAC_CONFIG_SD_V2	0x081141CF
 /*
  * setting NTSC mode
  */
 static int venc_set_ntsc(struct v4l2_subdev *sd)
 {
+	u32 val;
 	struct venc_state *venc = to_state(sd);
 	struct venc_platform_data *pdata = venc->pdata;
 
@@ -195,12 +204,22 @@ static int venc_set_ntsc(struct v4l2_subdev *sd)
 
 	venc_enabledigitaloutput(sd, 0);
 
-	/* to set VENC CLK DIV to 1 - final clock is 54 MHz */
-	venc_modify(sd, VENC_VIDCTL, 0, 1 << 1);
-	/* Set REC656 Mode */
-	venc_write(sd, VENC_YCCCTL, 0x1);
-	venc_modify(sd, VENC_VDPRO, 0, VENC_VDPRO_DAFRQ);
-	venc_modify(sd, VENC_VDPRO, 0, VENC_VDPRO_DAUPS);
+	if (pdata->venc_type == VPBE_VERSION_3) {
+		venc_write(sd, VENC_CLKCTL, 0x01);
+		venc_write(sd, VENC_VIDCTL, 0);
+		val = vdaccfg_write(sd, VDAC_CONFIG_SD_V3);
+	} else if (pdata->venc_type == VPBE_VERSION_2) {
+		venc_write(sd, VENC_CLKCTL, 0x01);
+		venc_write(sd, VENC_VIDCTL, 0);
+		vdaccfg_write(sd, VDAC_CONFIG_SD_V2);
+	} else {
+		/* to set VENC CLK DIV to 1 - final clock is 54 MHz */
+		venc_modify(sd, VENC_VIDCTL, 0, 1 << 1);
+		/* Set REC656 Mode */
+		venc_write(sd, VENC_YCCCTL, 0x1);
+		venc_modify(sd, VENC_VDPRO, 0, VENC_VDPRO_DAFRQ);
+		venc_modify(sd, VENC_VDPRO, 0, VENC_VDPRO_DAUPS);
+	}
 
 	venc_write(sd, VENC_VMOD, 0);
 	venc_modify(sd, VENC_VMOD, (1 << VENC_VMOD_VIE_SHIFT),
@@ -220,6 +239,7 @@ static int venc_set_ntsc(struct v4l2_subdev *sd)
 static int venc_set_pal(struct v4l2_subdev *sd)
 {
 	struct venc_state *venc = to_state(sd);
+	struct venc_platform_data *pdata = venc->pdata;
 
 	v4l2_dbg(debug, 2, sd, "venc_set_pal\n");
 
@@ -230,10 +250,20 @@ static int venc_set_pal(struct v4l2_subdev *sd)
 
 	venc_enabledigitaloutput(sd, 0);
 
-	/* to set VENC CLK DIV to 1 - final clock is 54 MHz */
-	venc_modify(sd, VENC_VIDCTL, 0, 1 << 1);
-	/* Set REC656 Mode */
-	venc_write(sd, VENC_YCCCTL, 0x1);
+	if (pdata->venc_type == VPBE_VERSION_3) {
+		venc_write(sd, VENC_CLKCTL, 0x1);
+		venc_write(sd, VENC_VIDCTL, 0);
+		vdaccfg_write(sd, VDAC_CONFIG_SD_V3);
+	} else if (pdata->venc_type == VPBE_VERSION_2) {
+		venc_write(sd, VENC_CLKCTL, 0x1);
+		venc_write(sd, VENC_VIDCTL, 0);
+		vdaccfg_write(sd, VDAC_CONFIG_SD_V2);
+	} else {
+		/* to set VENC CLK DIV to 1 - final clock is 54 MHz */
+		venc_modify(sd, VENC_VIDCTL, 0, 1 << 1);
+		/* Set REC656 Mode */
+		venc_write(sd, VENC_YCCCTL, 0x1);
+	}
 
 	venc_modify(sd, VENC_SYNCCTL, 1 << VENC_SYNCCTL_OVD_SHIFT,
 			VENC_SYNCCTL_OVD);
@@ -252,6 +282,7 @@ static int venc_set_pal(struct v4l2_subdev *sd)
 	return 0;
 }
 
+#define VDAC_CONFIG_HD_V2	0x081141EF
 /*
  * venc_set_480p59_94
  *
@@ -263,6 +294,9 @@ static int venc_set_480p59_94(struct v4l2_subdev *sd)
 	struct venc_platform_data *pdata = venc->pdata;
 
 	v4l2_dbg(debug, 2, sd, "venc_set_480p59_94\n");
+	if ((pdata->venc_type != VPBE_VERSION_1) &&
+	    (pdata->venc_type != VPBE_VERSION_2))
+		return -EINVAL;
 
 	/* Setup clock at VPSS & VENC for SD */
 	if (pdata->setup_clock(VPBE_ENC_DV_PRESET, V4L2_DV_480P59_94) < 0)
@@ -270,12 +304,18 @@ static int venc_set_480p59_94(struct v4l2_subdev *sd)
 
 	venc_enabledigitaloutput(sd, 0);
 
+	if (pdata->venc_type == VPBE_VERSION_2)
+		vdaccfg_write(sd, VDAC_CONFIG_HD_V2);
 	venc_write(sd, VENC_OSDCLK0, 0);
 	venc_write(sd, VENC_OSDCLK1, 1);
-	venc_modify(sd, VENC_VDPRO, VENC_VDPRO_DAFRQ,
-		    VENC_VDPRO_DAFRQ);
-	venc_modify(sd, VENC_VDPRO, VENC_VDPRO_DAUPS,
-		    VENC_VDPRO_DAUPS);
+
+	if (pdata->venc_type == VPBE_VERSION_1) {
+		venc_modify(sd, VENC_VDPRO, VENC_VDPRO_DAFRQ,
+			    VENC_VDPRO_DAFRQ);
+		venc_modify(sd, VENC_VDPRO, VENC_VDPRO_DAUPS,
+			    VENC_VDPRO_DAUPS);
+	}
+
 	venc_write(sd, VENC_VMOD, 0);
 	venc_modify(sd, VENC_VMOD, (1 << VENC_VMOD_VIE_SHIFT),
 		    VENC_VMOD_VIE);
@@ -302,19 +342,27 @@ static int venc_set_576p50(struct v4l2_subdev *sd)
 
 	v4l2_dbg(debug, 2, sd, "venc_set_576p50\n");
 
+	if ((pdata->venc_type != VPBE_VERSION_1) &&
+	  (pdata->venc_type != VPBE_VERSION_2))
+		return -EINVAL;
 	/* Setup clock at VPSS & VENC for SD */
 	if (pdata->setup_clock(VPBE_ENC_DV_PRESET, V4L2_DV_576P50) < 0)
 		return -EINVAL;
 
 	venc_enabledigitaloutput(sd, 0);
 
+	if (pdata->venc_type == VPBE_VERSION_2)
+		vdaccfg_write(sd, VDAC_CONFIG_HD_V2);
+
 	venc_write(sd, VENC_OSDCLK0, 0);
 	venc_write(sd, VENC_OSDCLK1, 1);
 
-	venc_modify(sd, VENC_VDPRO, VENC_VDPRO_DAFRQ,
-		    VENC_VDPRO_DAFRQ);
-	venc_modify(sd, VENC_VDPRO, VENC_VDPRO_DAUPS,
-		    VENC_VDPRO_DAUPS);
+	if (pdata->venc_type == VPBE_VERSION_1) {
+		venc_modify(sd, VENC_VDPRO, VENC_VDPRO_DAFRQ,
+			    VENC_VDPRO_DAFRQ);
+		venc_modify(sd, VENC_VDPRO, VENC_VDPRO_DAUPS,
+			    VENC_VDPRO_DAUPS);
+	}
 
 	venc_write(sd, VENC_VMOD, 0);
 	venc_modify(sd, VENC_VMOD, (1 << VENC_VMOD_VIE_SHIFT),
@@ -330,6 +378,63 @@ static int venc_set_576p50(struct v4l2_subdev *sd)
 	return 0;
 }
 
+/*
+ * venc_set_720p60_internal - Setup 720p60 in venc for dm365 only
+ */
+static int venc_set_720p60_internal(struct v4l2_subdev *sd)
+{
+	struct venc_state *venc = to_state(sd);
+	struct venc_platform_data *pdata = venc->pdata;
+
+	if (pdata->setup_clock(VPBE_ENC_DV_PRESET, V4L2_DV_720P60) < 0)
+		return -EINVAL;
+
+	venc_enabledigitaloutput(sd, 0);
+
+	venc_write(sd, VENC_OSDCLK0, 0);
+	venc_write(sd, VENC_OSDCLK1, 1);
+
+	venc_write(sd, VENC_VMOD, 0);
+	/* DM365 component HD mode */
+	venc_modify(sd, VENC_VMOD, (1 << VENC_VMOD_VIE_SHIFT),
+	    VENC_VMOD_VIE);
+	venc_modify(sd, VENC_VMOD, VENC_VMOD_HDMD, VENC_VMOD_HDMD);
+	venc_modify(sd, VENC_VMOD, (HDTV_720P << VENC_VMOD_TVTYP_SHIFT),
+		    VENC_VMOD_TVTYP);
+	venc_modify(sd, VENC_VMOD, VENC_VMOD_VENC, VENC_VMOD_VENC);
+	venc_write(sd, VENC_XHINTVL, 0);
+	return 0;
+}
+
+/*
+ * venc_set_1080i30_internal - Setup 1080i30 in venc for dm365 only
+ */
+static int venc_set_1080i30_internal(struct v4l2_subdev *sd)
+{
+	struct venc_state *venc = to_state(sd);
+	struct venc_platform_data *pdata = venc->pdata;
+
+	if (pdata->setup_clock(VPBE_ENC_DV_PRESET, V4L2_DV_1080P30) < 0)
+		return -EINVAL;
+
+	venc_enabledigitaloutput(sd, 0);
+
+	venc_write(sd, VENC_OSDCLK0, 0);
+	venc_write(sd, VENC_OSDCLK1, 1);
+
+
+	venc_write(sd, VENC_VMOD, 0);
+	/* DM365 component HD mode */
+	venc_modify(sd, VENC_VMOD, (1 << VENC_VMOD_VIE_SHIFT),
+		    VENC_VMOD_VIE);
+	venc_modify(sd, VENC_VMOD, VENC_VMOD_HDMD, VENC_VMOD_HDMD);
+	venc_modify(sd, VENC_VMOD, (HDTV_1080I << VENC_VMOD_TVTYP_SHIFT),
+		    VENC_VMOD_TVTYP);
+	venc_modify(sd, VENC_VMOD, VENC_VMOD_VENC, VENC_VMOD_VENC);
+	venc_write(sd, VENC_XHINTVL, 0);
+	return 0;
+}
+
 static int venc_s_std_output(struct v4l2_subdev *sd, v4l2_std_id norm)
 {
 	v4l2_dbg(debug, 1, sd, "venc_s_std_output\n");
@@ -345,13 +450,30 @@ static int venc_s_std_output(struct v4l2_subdev *sd, v4l2_std_id norm)
 static int venc_s_dv_preset(struct v4l2_subdev *sd,
 			    struct v4l2_dv_preset *dv_preset)
 {
+	struct venc_state *venc = to_state(sd);
+	int ret;
+
 	v4l2_dbg(debug, 1, sd, "venc_s_dv_preset\n");
 
 	if (dv_preset->preset == V4L2_DV_576P50)
 		return venc_set_576p50(sd);
 	else if (dv_preset->preset == V4L2_DV_480P59_94)
 		return venc_set_480p59_94(sd);
-
+	else if ((dv_preset->preset == V4L2_DV_720P60) &&
+			(venc->pdata->venc_type == VPBE_VERSION_2)) {
+		/* TBD setup internal 720p mode here */
+		ret = venc_set_720p60_internal(sd);
+		/* for DM365 VPBE, there is DAC inside */
+		vdaccfg_write(sd, VDAC_CONFIG_HD_V2);
+		return ret;
+	} else if ((dv_preset->preset == V4L2_DV_1080I30) &&
+		(venc->pdata->venc_type == VPBE_VERSION_2)) {
+		/* TBD setup internal 1080i mode here */
+		ret = venc_set_1080i30_internal(sd);
+		/* for DM365 VPBE, there is DAC inside */
+		vdaccfg_write(sd, VDAC_CONFIG_HD_V2);
+		return ret;
+	}
 	return -EINVAL;
 }
 
@@ -508,11 +630,41 @@ static int venc_probe(struct platform_device *pdev)
 		goto release_venc_mem_region;
 	}
 
+	if (venc->pdata->venc_type != VPBE_VERSION_1) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		if (!res) {
+			dev_err(venc->pdev,
+				"Unable to get VDAC_CONFIG address map\n");
+			ret = -ENODEV;
+			goto unmap_venc_io;
+		}
+
+		if (!request_mem_region(res->start,
+					resource_size(res), "venc")) {
+			dev_err(venc->pdev,
+				"Unable to reserve VDAC_CONFIG  MMIO region\n");
+			ret = -ENODEV;
+			goto unmap_venc_io;
+		}
+
+		venc->vdaccfg_reg = ioremap_nocache(res->start,
+						    resource_size(res));
+		if (!venc->vdaccfg_reg) {
+			dev_err(venc->pdev,
+				"Unable to map VDAC_CONFIG IO space\n");
+			ret = -ENODEV;
+			goto release_vdaccfg_mem_region;
+		}
+	}
 	spin_lock_init(&venc->lock);
 	platform_set_drvdata(pdev, venc);
 	dev_notice(venc->pdev, "VENC sub device probe success\n");
 	return 0;
 
+release_vdaccfg_mem_region:
+	release_mem_region(res->start, resource_size(res));
+unmap_venc_io:
+	iounmap(venc->venc_base);
 release_venc_mem_region:
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	release_mem_region(res->start, resource_size(res));
@@ -529,6 +681,11 @@ static int venc_remove(struct platform_device *pdev)
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	iounmap((void *)venc->venc_base);
 	release_mem_region(res->start, resource_size(res));
+	if (venc->pdata->venc_type != VPBE_VERSION_1) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		iounmap((void *)venc->vdaccfg_reg);
+		release_mem_region(res->start, resource_size(res));
+	}
 	kfree(venc);
 
 	return 0;
diff --git a/include/media/davinci/vpbe_venc.h b/include/media/davinci/vpbe_venc.h
index 426c205..6b57334 100644
--- a/include/media/davinci/vpbe_venc.h
+++ b/include/media/davinci/vpbe_venc.h
@@ -29,10 +29,14 @@
 
 struct venc_platform_data {
 	enum vpbe_version venc_type;
+	int (*setup_pinmux)(enum v4l2_mbus_pixelcode if_type,
+			    int field);
 	int (*setup_clock)(enum vpbe_enc_timings_type type,
 			   unsigned int mode);
+	int (*setup_if_config)(enum v4l2_mbus_pixelcode pixcode);
 	/* Number of LCD outputs supported */
 	int num_lcd_outputs;
+	struct vpbe_if_params *lcd_if_params;
 };
 
 enum venc_ioctls {
-- 
1.6.2.4

