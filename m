Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42047 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbbFFMDV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 08:03:21 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/9] v4l2: add RF gain control
Date: Sat,  6 Jun 2015 15:03:01 +0300
Message-Id: <1433592188-31748-2-git-send-email-crope@iki.fi>
In-Reply-To: <1433592188-31748-1-git-send-email-crope@iki.fi>
References: <1433592188-31748-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new RF tuner gain control named RF gain. That is aimed for
external LNA (amplifier) chip just right after antenna connector.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 4 ++++
 include/uapi/linux/v4l2-controls.h   | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index e3a3468..0fc34b8 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -888,6 +888,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
 	case V4L2_CID_RDS_RECEPTION:		return "RDS Reception";
 	case V4L2_CID_RF_TUNER_CLASS:		return "RF Tuner Controls";
+	case V4L2_CID_RF_TUNER_RF_GAIN_AUTO:	return "RF Gain, Auto";
+	case V4L2_CID_RF_TUNER_RF_GAIN:		return "RF Gain";
 	case V4L2_CID_RF_TUNER_LNA_GAIN_AUTO:	return "LNA Gain, Auto";
 	case V4L2_CID_RF_TUNER_LNA_GAIN:	return "LNA Gain";
 	case V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO:	return "Mixer Gain, Auto";
@@ -960,6 +962,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_WIDE_DYNAMIC_RANGE:
 	case V4L2_CID_IMAGE_STABILIZATION:
 	case V4L2_CID_RDS_RECEPTION:
+	case V4L2_CID_RF_TUNER_RF_GAIN_AUTO:
 	case V4L2_CID_RF_TUNER_LNA_GAIN_AUTO:
 	case V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO:
 	case V4L2_CID_RF_TUNER_IF_GAIN_AUTO:
@@ -1161,6 +1164,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_PILOT_TONE_FREQUENCY:
 	case V4L2_CID_TUNE_POWER_LEVEL:
 	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
+	case V4L2_CID_RF_TUNER_RF_GAIN:
 	case V4L2_CID_RF_TUNER_LNA_GAIN:
 	case V4L2_CID_RF_TUNER_MIXER_GAIN:
 	case V4L2_CID_RF_TUNER_IF_GAIN:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 9f6e108..87539be 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -932,6 +932,8 @@ enum v4l2_deemphasis {
 
 #define V4L2_CID_RF_TUNER_BANDWIDTH_AUTO	(V4L2_CID_RF_TUNER_CLASS_BASE + 11)
 #define V4L2_CID_RF_TUNER_BANDWIDTH		(V4L2_CID_RF_TUNER_CLASS_BASE + 12)
+#define V4L2_CID_RF_TUNER_RF_GAIN_AUTO		(V4L2_CID_RF_TUNER_CLASS_BASE + 31)
+#define V4L2_CID_RF_TUNER_RF_GAIN		(V4L2_CID_RF_TUNER_CLASS_BASE + 32)
 #define V4L2_CID_RF_TUNER_LNA_GAIN_AUTO		(V4L2_CID_RF_TUNER_CLASS_BASE + 41)
 #define V4L2_CID_RF_TUNER_LNA_GAIN		(V4L2_CID_RF_TUNER_CLASS_BASE + 42)
 #define V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO	(V4L2_CID_RF_TUNER_CLASS_BASE + 51)
-- 
http://palosaari.fi/

