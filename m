Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1915 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3CKLrI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:47:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 32/42] go7007: set up the saa7115 audio clock correctly.
Date: Mon, 11 Mar 2013 12:46:10 +0100
Message-Id: <9960fcafa966666e3e982370dd64ea5600b3ff1b.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The s_crystal_freq operation has to be called for the saa7115 to
set up the audio clock correctly.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-priv.h |    1 +
 drivers/staging/media/go7007/go7007-usb.c  |    5 ++++-
 drivers/staging/media/go7007/go7007-v4l2.c |    7 +++++++
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index a6ef67b..7f79cc1 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -60,6 +60,7 @@ struct go7007;
 #define GO7007_SENSOR_TV		(1<<7)
 #define GO7007_SENSOR_VBI		(1<<8)
 #define GO7007_SENSOR_SCALING		(1<<9)
+#define GO7007_SENSOR_SAA7115		(1<<10)
 
 /* Characteristics of audio sensor devices */
 #define GO7007_AUDIO_I2S_MODE_1		(1)
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 53c5b16..5c7a19e6 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -88,6 +88,7 @@ static struct go7007_usb_board board_matrix_ii = {
 		.sensor_flags	 = GO7007_SENSOR_656 |
 					GO7007_SENSOR_VALID_ENABLE |
 					GO7007_SENSOR_TV |
+					GO7007_SENSOR_SAA7115 |
 					GO7007_SENSOR_VBI |
 					GO7007_SENSOR_SCALING,
 		.num_i2c_devs	 = 1,
@@ -131,7 +132,7 @@ static struct go7007_usb_board board_matrix_reload = {
 		.num_i2c_devs	 = 1,
 		.i2c_devs	 = {
 			{
-				.type	= "saa7115",
+				.type	= "saa7113",
 				.addr	= 0x25,
 				.is_video = 1,
 			},
@@ -160,6 +161,7 @@ static struct go7007_usb_board board_star_trek = {
 		.sensor_flags	 = GO7007_SENSOR_656 |
 					GO7007_SENSOR_VALID_ENABLE |
 					GO7007_SENSOR_TV |
+					GO7007_SENSOR_SAA7115 |
 					GO7007_SENSOR_VBI |
 					GO7007_SENSOR_SCALING,
 		.audio_flags	 = GO7007_AUDIO_I2S_MODE_1 |
@@ -207,6 +209,7 @@ static struct go7007_usb_board board_px_tv402u = {
 		.sensor_flags	 = GO7007_SENSOR_656 |
 					GO7007_SENSOR_VALID_ENABLE |
 					GO7007_SENSOR_TV |
+					GO7007_SENSOR_SAA7115 |
 					GO7007_SENSOR_VBI |
 					GO7007_SENSOR_SCALING,
 		.audio_flags	 = GO7007_AUDIO_I2S_MODE_1 |
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index fd6cae0..972f8a5 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -35,6 +35,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-subdev.h>
 #include <media/v4l2-event.h>
+#include <media/saa7115.h>
 
 #include "go7007.h"
 #include "go7007-priv.h"
@@ -1461,6 +1462,12 @@ int go7007_v4l2_init(struct go7007 *go)
 		v4l2_disable_ioctl(go->video_dev, VIDIOC_S_AUDIO);
 		v4l2_disable_ioctl(go->video_dev, VIDIOC_ENUMAUDIO);
 	}
+	/* Setup correct crystal frequency on this board */
+	if (go->board_info->sensor_flags & GO7007_SENSOR_SAA7115)
+		v4l2_subdev_call(go->sd_video, video, s_crystal_freq,
+				SAA7115_FREQ_24_576_MHZ,
+				SAA7115_FREQ_FL_APLL | SAA7115_FREQ_FL_UCGC |
+				SAA7115_FREQ_FL_DOUBLE_ASCLK);
 	go7007_s_input(go);
 	if (go->board_info->sensor_flags & GO7007_SENSOR_TV)
 		go7007_s_std(go);
-- 
1.7.10.4

