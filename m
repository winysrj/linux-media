Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:58380 "HELO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751034Ab2HIGeV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 02:34:21 -0400
Received: by wgbdq11 with SMTP id dq11so91422wgb.29
        for <linux-media@vger.kernel.org>; Wed, 08 Aug 2012 23:34:19 -0700 (PDT)
From: Dror Cohen <dror@liveu.tv>
To: linux-media@vger.kernel.org
Cc: mchehab@infradead.org, nsekhar@ti.com,
	davinci-linux-open-source@linux.davincidsp.com,
	Dror Cohen <dror@liveu.tv>
Subject: [PATCH 1/1 v2] media/video: vpif: fixing function name start to vpif_config_params
Date: Thu,  9 Aug 2012 09:33:37 +0300
Message-Id: <1344494017-18099-2-git-send-email-dror@liveu.tv>
In-Reply-To: <1344494017-18099-1-git-send-email-dror@liveu.tv>
References: <1344494017-18099-1-git-send-email-dror@liveu.tv>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

diff --git a/drivers/media/video/davinci/vpif.c b/drivers/media/video/davinci/vpif.c
index af96802..04dd8fa 100644
--- a/drivers/media/video/davinci/vpif.c
+++ b/drivers/media/video/davinci/vpif.c
@@ -301,12 +301,12 @@ static void vpif_set_mode_info(const struct vpif_channel_config_params *config,
 	regw(value, vpifregs[channel_id].v_cfg);
 }
 
-/* config_vpif_params
+/* vpif_config_params
  * Function to set the parameters of a channel
  * Mainly modifies the channel ciontrol register
  * It sets frame format, yc mux mode
  */
-static void config_vpif_params(struct vpif_params *vpifparams,
+static void vpif_config_params(struct vpif_params *vpifparams,
 				u8 channel_id, u8 found)
 {
 	const struct vpif_channel_config_params *config = &vpifparams->std_info;
@@ -374,7 +374,7 @@ int vpif_set_video_params(struct vpif_params *vpifparams, u8 channel_id)
 		found = 2;
 	}
 
-	config_vpif_params(vpifparams, channel_id, found);
+	vpif_config_params(vpifparams, channel_id, found);
 
 	regw(0x80, VPIF_REQ_SIZE);
 	regw(0x01, VPIF_EMULATION_CTRL);
diff --git a/drivers/media/video/davinci/vpif_capture.c b/drivers/media/video/davinci/vpif_capture.c
index 9604695..59104e6 100644
--- a/drivers/media/video/davinci/vpif_capture.c
+++ b/drivers/media/video/davinci/vpif_capture.c
@@ -67,7 +67,7 @@ MODULE_PARM_DESC(ch3_numbuffers, "Channel1 buffer count (default:3)");
 MODULE_PARM_DESC(ch2_bufsize, "Channel0 buffer size (default:1920 x 1080 x 2)");
 MODULE_PARM_DESC(ch3_bufsize, "Channel1 buffer size (default:720 x 576 x 2)");
 
-static struct vpif_config_params config_params = {
+static struct config_vpif_params config_params = {
 	.min_numbuffers = 3,
 	.numbuffers[0] = 3,
 	.numbuffers[1] = 3,
diff --git a/drivers/media/video/davinci/vpif_capture.h b/drivers/media/video/davinci/vpif_capture.h
index a693d4e..8863de1 100644
--- a/drivers/media/video/davinci/vpif_capture.h
+++ b/drivers/media/video/davinci/vpif_capture.h
@@ -144,7 +144,7 @@ struct vpif_device {
 	struct v4l2_subdev **sd;
 };
 
-struct vpif_config_params {
+struct config_vpif_params {
 	u8 min_numbuffers;
 	u8 numbuffers[VPIF_CAPTURE_NUM_CHANNELS];
 	s8 device_type;
diff --git a/drivers/media/video/davinci/vpif_display.c b/drivers/media/video/davinci/vpif_display.c
index e6488ee..652440d 100644
--- a/drivers/media/video/davinci/vpif_display.c
+++ b/drivers/media/video/davinci/vpif_display.c
@@ -70,7 +70,7 @@ MODULE_PARM_DESC(ch3_numbuffers, "Channel3 buffer count (default:3)");
 MODULE_PARM_DESC(ch2_bufsize, "Channel2 buffer size (default:1920 x 1080 x 2)");
 MODULE_PARM_DESC(ch3_bufsize, "Channel3 buffer size (default:720 x 576 x 2)");
 
-static struct vpif_config_params config_params = {
+static struct config_vpif_params config_params = {
 	.min_numbuffers		= 3,
 	.numbuffers[0]		= 3,
 	.numbuffers[1]		= 3,
diff --git a/drivers/media/video/davinci/vpif_display.h b/drivers/media/video/davinci/vpif_display.h
index 56879d1..3e14807 100644
--- a/drivers/media/video/davinci/vpif_display.h
+++ b/drivers/media/video/davinci/vpif_display.h
@@ -154,7 +154,7 @@ struct vpif_device {
 
 };
 
-struct vpif_config_params {
+struct config_vpif_params {
 	u32 min_bufsize[VPIF_DISPLAY_NUM_CHANNELS];
 	u32 channel_bufsize[VPIF_DISPLAY_NUM_CHANNELS];
 	u8 numbuffers[VPIF_DISPLAY_NUM_CHANNELS];
-- 
1.7.5.4

