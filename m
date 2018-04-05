Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:41498 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751714AbeDEUaA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Apr 2018 16:30:00 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 14/19] media: davinci: get rid of lots of kernel-doc warnings
Date: Thu,  5 Apr 2018 16:29:41 -0400
Message-Id: <409eaab1b74ddd1385319b4083056323bb895584.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1522959716.git.mchehab@s-opensource.com>
References: <cover.1522959716.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Driver build produce lots of warnings due to wrong kernel-doc markups:

    drivers/media/platform/davinci/vpbe.c:60: warning: Function parameter or member 'vpbe_dev' not described in 'vpbe_current_encoder_info'
    drivers/media/platform/davinci/vpbe.c:78: warning: Function parameter or member 'cfg' not described in 'vpbe_find_encoder_sd_index'
    drivers/media/platform/davinci/vpbe.c:78: warning: Function parameter or member 'index' not described in 'vpbe_find_encoder_sd_index'
    drivers/media/platform/davinci/vpbe.c:105: warning: Function parameter or member 'vpbe_dev' not described in 'vpbe_g_cropcap'
    drivers/media/platform/davinci/vpbe.c:105: warning: Function parameter or member 'cropcap' not described in 'vpbe_g_cropcap'
    drivers/media/platform/davinci/vpbe.c:127: warning: Function parameter or member 'vpbe_dev' not described in 'vpbe_enum_outputs'
    drivers/media/platform/davinci/vpbe.c:127: warning: Function parameter or member 'output' not described in 'vpbe_enum_outputs'
    drivers/media/platform/davinci/vpbe.c:221: warning: Function parameter or member 'vpbe_dev' not described in 'vpbe_set_output'
    drivers/media/platform/davinci/vpbe.c:221: warning: Function parameter or member 'index' not described in 'vpbe_set_output'
    drivers/media/platform/davinci/vpbe.c:316: warning: Function parameter or member 'vpbe_dev' not described in 'vpbe_get_output'
    drivers/media/platform/davinci/vpbe.c:328: warning: Function parameter or member 'vpbe_dev' not described in 'vpbe_s_dv_timings'
    drivers/media/platform/davinci/vpbe.c:328: warning: Function parameter or member 'dv_timings' not described in 'vpbe_s_dv_timings'
    drivers/media/platform/davinci/vpbe.c:380: warning: Function parameter or member 'vpbe_dev' not described in 'vpbe_g_dv_timings'
    drivers/media/platform/davinci/vpbe.c:380: warning: Function parameter or member 'dv_timings' not described in 'vpbe_g_dv_timings'
    drivers/media/platform/davinci/vpbe.c:405: warning: Function parameter or member 'vpbe_dev' not described in 'vpbe_enum_dv_timings'
    drivers/media/platform/davinci/vpbe.c:405: warning: Function parameter or member 'timings' not described in 'vpbe_enum_dv_timings'
    drivers/media/platform/davinci/vpbe.c:436: warning: Function parameter or member 'vpbe_dev' not described in 'vpbe_s_std'
    drivers/media/platform/davinci/vpbe.c:436: warning: Function parameter or member 'std_id' not described in 'vpbe_s_std'
    drivers/media/platform/davinci/vpbe.c:475: warning: Function parameter or member 'vpbe_dev' not described in 'vpbe_g_std'
    drivers/media/platform/davinci/vpbe.c:475: warning: Function parameter or member 'std_id' not described in 'vpbe_g_std'
    drivers/media/platform/davinci/vpbe.c:500: warning: Function parameter or member 'vpbe_dev' not described in 'vpbe_set_mode'
    drivers/media/platform/davinci/vpbe.c:500: warning: Function parameter or member 'mode_info' not described in 'vpbe_set_mode'
    drivers/media/platform/davinci/vpbe.c:585: warning: Function parameter or member 'dev' not described in 'vpbe_initialize'
    drivers/media/platform/davinci/vpbe.c:585: warning: Function parameter or member 'vpbe_dev' not described in 'vpbe_initialize'
    drivers/media/platform/davinci/vpbe.c:779: warning: Function parameter or member 'dev' not described in 'vpbe_deinitialize'
    drivers/media/platform/davinci/vpbe.c:779: warning: Function parameter or member 'vpbe_dev' not described in 'vpbe_deinitialize'
    drivers/media/platform/davinci/vpbe_osd.c:144: warning: Function parameter or member 'sd' not described in '_osd_dm6446_vid0_pingpong'
    drivers/media/platform/davinci/vpbe_osd.c:144: warning: Function parameter or member 'field_inversion' not described in '_osd_dm6446_vid0_pingpong'
    drivers/media/platform/davinci/vpbe_osd.c:144: warning: Function parameter or member 'fb_base_phys' not described in '_osd_dm6446_vid0_pingpong'
    drivers/media/platform/davinci/vpbe_osd.c:144: warning: Function parameter or member 'lconfig' not described in '_osd_dm6446_vid0_pingpong'
    drivers/media/platform/davinci/vpbe_osd.c:799: warning: Function parameter or member 'sd' not described in 'try_layer_config'
    drivers/media/platform/davinci/vpbe_osd.c:799: warning: Function parameter or member 'layer' not described in 'try_layer_config'
    drivers/media/platform/davinci/vpbe_osd.c:799: warning: Function parameter or member 'lconfig' not described in 'try_layer_config'
    drivers/media/platform/davinci/vpbe_display.c:578: warning: Function parameter or member 'disp_dev' not described in 'vpbe_try_format'
    drivers/media/platform/davinci/vpbe_display.c:578: warning: Function parameter or member 'pixfmt' not described in 'vpbe_try_format'
    drivers/media/platform/davinci/vpbe_display.c:578: warning: Function parameter or member 'check' not described in 'vpbe_try_format'
    drivers/media/platform/davinci/vpbe_display.c:943: warning: Function parameter or member 'file' not described in 'vpbe_display_s_std'
    drivers/media/platform/davinci/vpbe_display.c:943: warning: Function parameter or member 'priv' not described in 'vpbe_display_s_std'
    drivers/media/platform/davinci/vpbe_display.c:943: warning: Function parameter or member 'std_id' not described in 'vpbe_display_s_std'
    drivers/media/platform/davinci/vpbe_display.c:975: warning: Function parameter or member 'file' not described in 'vpbe_display_g_std'
    drivers/media/platform/davinci/vpbe_display.c:975: warning: Function parameter or member 'priv' not described in 'vpbe_display_g_std'
    drivers/media/platform/davinci/vpbe_display.c:975: warning: Function parameter or member 'std_id' not described in 'vpbe_display_g_std'
    drivers/media/platform/davinci/vpbe_display.c:998: warning: Function parameter or member 'file' not described in 'vpbe_display_enum_output'
    drivers/media/platform/davinci/vpbe_display.c:998: warning: Function parameter or member 'priv' not described in 'vpbe_display_enum_output'
    drivers/media/platform/davinci/vpbe_display.c:998: warning: Function parameter or member 'output' not described in 'vpbe_display_enum_output'
    drivers/media/platform/davinci/vpbe_display.c:1025: warning: Function parameter or member 'file' not described in 'vpbe_display_s_output'
    drivers/media/platform/davinci/vpbe_display.c:1025: warning: Function parameter or member 'priv' not described in 'vpbe_display_s_output'
    drivers/media/platform/davinci/vpbe_display.c:1025: warning: Function parameter or member 'i' not described in 'vpbe_display_s_output'
    drivers/media/platform/davinci/vpbe_display.c:1054: warning: Function parameter or member 'file' not described in 'vpbe_display_g_output'
    drivers/media/platform/davinci/vpbe_display.c:1054: warning: Function parameter or member 'priv' not described in 'vpbe_display_g_output'
    drivers/media/platform/davinci/vpbe_display.c:1054: warning: Function parameter or member 'i' not described in 'vpbe_display_g_output'
    drivers/media/platform/davinci/vpbe_display.c:1074: warning: Function parameter or member 'file' not described in 'vpbe_display_enum_dv_timings'
    drivers/media/platform/davinci/vpbe_display.c:1074: warning: Function parameter or member 'priv' not described in 'vpbe_display_enum_dv_timings'
    drivers/media/platform/davinci/vpbe_display.c:1074: warning: Function parameter or member 'timings' not described in 'vpbe_display_enum_dv_timings'
    drivers/media/platform/davinci/vpbe_display.c:1104: warning: Function parameter or member 'file' not described in 'vpbe_display_s_dv_timings'
    drivers/media/platform/davinci/vpbe_display.c:1104: warning: Function parameter or member 'priv' not described in 'vpbe_display_s_dv_timings'
    drivers/media/platform/davinci/vpbe_display.c:1104: warning: Function parameter or member 'timings' not described in 'vpbe_display_s_dv_timings'
    drivers/media/platform/davinci/vpbe_display.c:1137: warning: Function parameter or member 'file' not described in 'vpbe_display_g_dv_timings'
    drivers/media/platform/davinci/vpbe_display.c:1137: warning: Function parameter or member 'priv' not described in 'vpbe_display_g_dv_timings'
    drivers/media/platform/davinci/vpbe_display.c:1137: warning: Function parameter or member 'dv_timings' not described in 'vpbe_display_g_dv_timings'

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/platform/davinci/vpbe.c         | 38 ++++++++++++++-------------
 drivers/media/platform/davinci/vpbe_display.c | 18 ++++++-------
 drivers/media/platform/davinci/vpbe_osd.c     | 14 +++++-----
 3 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 7f6462562579..18c035ef84cf 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -51,7 +51,7 @@ MODULE_AUTHOR("Texas Instruments");
 
 /**
  * vpbe_current_encoder_info - Get config info for current encoder
- * @vpbe_dev - vpbe device ptr
+ * @vpbe_dev: vpbe device ptr
  *
  * Return ptr to current encoder config info
  */
@@ -68,8 +68,8 @@ vpbe_current_encoder_info(struct vpbe_device *vpbe_dev)
 /**
  * vpbe_find_encoder_sd_index - Given a name find encoder sd index
  *
- * @vpbe_config - ptr to vpbe cfg
- * @output_index - index used by application
+ * @cfg: ptr to vpbe cfg
+ * @index: index used by application
  *
  * Return sd index of the encoder
  */
@@ -94,8 +94,8 @@ static int vpbe_find_encoder_sd_index(struct vpbe_config *cfg,
 
 /**
  * vpbe_g_cropcap - Get crop capabilities of the display
- * @vpbe_dev - vpbe device ptr
- * @cropcap - cropcap is a ptr to struct v4l2_cropcap
+ * @vpbe_dev: vpbe device ptr
+ * @cropcap: cropcap is a ptr to struct v4l2_cropcap
  *
  * Update the crop capabilities in crop cap for current
  * mode
@@ -116,8 +116,8 @@ static int vpbe_g_cropcap(struct vpbe_device *vpbe_dev,
 
 /**
  * vpbe_enum_outputs - enumerate outputs
- * @vpbe_dev - vpbe device ptr
- * @output - ptr to v4l2_output structure
+ * @vpbe_dev: vpbe device ptr
+ * @output: ptr to v4l2_output structure
  *
  * Enumerates the outputs available at the vpbe display
  * returns the status, -EINVAL if end of output list
@@ -212,8 +212,8 @@ static int vpbe_get_std_info_by_name(struct vpbe_device *vpbe_dev,
 
 /**
  * vpbe_set_output - Set output
- * @vpbe_dev - vpbe device ptr
- * @index - index of output
+ * @vpbe_dev: vpbe device ptr
+ * @index: index of output
  *
  * Set vpbe output to the output specified by the index
  */
@@ -308,7 +308,7 @@ static int vpbe_set_default_output(struct vpbe_device *vpbe_dev)
 
 /**
  * vpbe_get_output - Get output
- * @vpbe_dev - vpbe device ptr
+ * @vpbe_dev: vpbe device ptr
  *
  * return current vpbe output to the the index
  */
@@ -317,7 +317,7 @@ static unsigned int vpbe_get_output(struct vpbe_device *vpbe_dev)
 	return vpbe_dev->current_out_index;
 }
 
-/**
+/*
  * vpbe_s_dv_timings - Set the given preset timings in the encoder
  *
  * Sets the timings if supported by the current encoder. Return the status.
@@ -369,7 +369,7 @@ static int vpbe_s_dv_timings(struct vpbe_device *vpbe_dev,
 	return ret;
 }
 
-/**
+/*
  * vpbe_g_dv_timings - Get the timings in the current encoder
  *
  * Get the timings in the current encoder. Return the status. 0 - success
@@ -394,7 +394,7 @@ static int vpbe_g_dv_timings(struct vpbe_device *vpbe_dev,
 	return -EINVAL;
 }
 
-/**
+/*
  * vpbe_enum_dv_timings - Enumerate the dv timings in the current encoder
  *
  * Get the timings in the current encoder. Return the status. 0 - success
@@ -426,7 +426,7 @@ static int vpbe_enum_dv_timings(struct vpbe_device *vpbe_dev,
 	return 0;
 }
 
-/**
+/*
  * vpbe_s_std - Set the given standard in the encoder
  *
  * Sets the standard if supported by the current encoder. Return the status.
@@ -465,7 +465,7 @@ static int vpbe_s_std(struct vpbe_device *vpbe_dev, v4l2_std_id std_id)
 	return ret;
 }
 
-/**
+/*
  * vpbe_g_std - Get the standard in the current encoder
  *
  * Get the standard in the current encoder. Return the status. 0 - success
@@ -488,7 +488,7 @@ static int vpbe_g_std(struct vpbe_device *vpbe_dev, v4l2_std_id *std_id)
 	return -EINVAL;
 }
 
-/**
+/*
  * vpbe_set_mode - Set mode in the current encoder using mode info
  *
  * Use the mode string to decide what timings to set in the encoder
@@ -572,7 +572,8 @@ static int platform_device_get(struct device *dev, void *data)
 
 /**
  * vpbe_initialize() - Initialize the vpbe display controller
- * @vpbe_dev - vpbe device ptr
+ * @dev: Master and slave device ptr
+ * @vpbe_dev: vpbe device ptr
  *
  * Master frame buffer device drivers calls this to initialize vpbe
  * display controller. This will then registers v4l2 device and the sub
@@ -769,7 +770,8 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 
 /**
  * vpbe_deinitialize() - de-initialize the vpbe display controller
- * @dev - Master and slave device ptr
+ * @dev: Master and slave device ptr
+ * @vpbe_dev: vpbe device ptr
  *
  * vpbe_master and slave frame buffer devices calls this to de-initialize
  * the display controller. It is called when master and slave device
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 7b6cd4b3ccc4..9849e4405a6a 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -567,7 +567,7 @@ static void vpbe_disp_check_window_params(struct vpbe_display *disp_dev,
 
 }
 
-/**
+/*
  * vpbe_try_format()
  * If user application provides width and height, and have bytesperline set
  * to zero, driver calculates bytesperline and sizeimage based on hardware
@@ -932,7 +932,7 @@ static int vpbe_display_try_fmt(struct file *file, void *priv,
 
 }
 
-/**
+/*
  * vpbe_display_s_std - Set the given standard in the encoder
  *
  * Sets the standard if supported by the current encoder. Return the status.
@@ -964,7 +964,7 @@ static int vpbe_display_s_std(struct file *file, void *priv,
 	return 0;
 }
 
-/**
+/*
  * vpbe_display_g_std - Get the standard in the current encoder
  *
  * Get the standard in the current encoder. Return the status. 0 - success
@@ -987,7 +987,7 @@ static int vpbe_display_g_std(struct file *file, void *priv,
 	return -EINVAL;
 }
 
-/**
+/*
  * vpbe_display_enum_output - enumerate outputs
  *
  * Enumerates the outputs available at the vpbe display
@@ -1016,7 +1016,7 @@ static int vpbe_display_enum_output(struct file *file, void *priv,
 	return 0;
 }
 
-/**
+/*
  * vpbe_display_s_output - Set output to
  * the output specified by the index
  */
@@ -1045,7 +1045,7 @@ static int vpbe_display_s_output(struct file *file, void *priv,
 	return 0;
 }
 
-/**
+/*
  * vpbe_display_g_output - Get output from subdevice
  * for a given by the index
  */
@@ -1062,7 +1062,7 @@ static int vpbe_display_g_output(struct file *file, void *priv,
 	return 0;
 }
 
-/**
+/*
  * vpbe_display_enum_dv_timings - Enumerate the dv timings
  *
  * enum the timings in the current encoder. Return the status. 0 - success
@@ -1092,7 +1092,7 @@ vpbe_display_enum_dv_timings(struct file *file, void *priv,
 	return 0;
 }
 
-/**
+/*
  * vpbe_display_s_dv_timings - Set the dv timings
  *
  * Set the timings in the current encoder. Return the status. 0 - success
@@ -1125,7 +1125,7 @@ vpbe_display_s_dv_timings(struct file *file, void *priv,
 	return 0;
 }
 
-/**
+/*
  * vpbe_display_g_dv_timings - Set the dv timings
  *
  * Get the timings in the current encoder. Return the status. 0 - success
diff --git a/drivers/media/platform/davinci/vpbe_osd.c b/drivers/media/platform/davinci/vpbe_osd.c
index 10f2bf11edf3..99a4ec183ba9 100644
--- a/drivers/media/platform/davinci/vpbe_osd.c
+++ b/drivers/media/platform/davinci/vpbe_osd.c
@@ -124,10 +124,10 @@ static inline u32 osd_modify(struct osd_state *sd, u32 mask, u32 val,
 
 /**
  * _osd_dm6446_vid0_pingpong() - field inversion fix for DM6446
- * @sd - ptr to struct osd_state
- * @field_inversion - inversion flag
- * @fb_base_phys - frame buffer address
- * @lconfig - ptr to layer config
+ * @sd: ptr to struct osd_state
+ * @field_inversion: inversion flag
+ * @fb_base_phys: frame buffer address
+ * @lconfig: ptr to layer config
  *
  * This routine implements a workaround for the field signal inversion silicon
  * erratum described in Advisory 1.3.8 for the DM6446.  The fb_base_phys and
@@ -784,9 +784,9 @@ static void osd_get_layer_config(struct osd_state *sd, enum osd_layer layer,
 
 /**
  * try_layer_config() - Try a specific configuration for the layer
- * @sd  - ptr to struct osd_state
- * @layer - layer to configure
- * @lconfig - layer configuration to try
+ * @sd: ptr to struct osd_state
+ * @layer: layer to configure
+ * @lconfig: layer configuration to try
  *
  * If the requested lconfig is completely rejected and the value of lconfig on
  * exit is the current lconfig, then try_layer_config() returns 1.  Otherwise,
-- 
2.14.3
