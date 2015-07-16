Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39855 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498AbbGPHFb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 03:05:31 -0400
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2 2/9] v4l2: add RF gain control
Date: Thu, 16 Jul 2015 10:04:51 +0300
Message-Id: <1437030298-20944-3-git-send-email-crope@iki.fi>
In-Reply-To: <1437030298-20944-1-git-send-email-crope@iki.fi>
References: <1437030298-20944-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add new RF tuner gain control named RF Gain. That is aimed for first
amplifier chip right after antenna connector.
There is existing LNA Gain control, which is quite same, but it is
aimed for cases amplifier is integrated to tuner chip. Some designs
have both, as almost all recent tuner silicons has integrated LNA/RF
amplifier in any case.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 2 ++
 include/uapi/linux/v4l2-controls.h   | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index b6b7dcc..d18462c 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -888,6 +888,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_TUNE_DEEMPHASIS:		return "De-Emphasis";
 	case V4L2_CID_RDS_RECEPTION:		return "RDS Reception";
 	case V4L2_CID_RF_TUNER_CLASS:		return "RF Tuner Controls";
+	case V4L2_CID_RF_TUNER_RF_GAIN:		return "RF Gain";
 	case V4L2_CID_RF_TUNER_LNA_GAIN_AUTO:	return "LNA Gain, Auto";
 	case V4L2_CID_RF_TUNER_LNA_GAIN:	return "LNA Gain";
 	case V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO:	return "Mixer Gain, Auto";
@@ -1161,6 +1162,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_PILOT_TONE_FREQUENCY:
 	case V4L2_CID_TUNE_POWER_LEVEL:
 	case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
+	case V4L2_CID_RF_TUNER_RF_GAIN:
 	case V4L2_CID_RF_TUNER_LNA_GAIN:
 	case V4L2_CID_RF_TUNER_MIXER_GAIN:
 	case V4L2_CID_RF_TUNER_IF_GAIN:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 9f6e108..efb47cd 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -932,6 +932,7 @@ enum v4l2_deemphasis {
 
 #define V4L2_CID_RF_TUNER_BANDWIDTH_AUTO	(V4L2_CID_RF_TUNER_CLASS_BASE + 11)
 #define V4L2_CID_RF_TUNER_BANDWIDTH		(V4L2_CID_RF_TUNER_CLASS_BASE + 12)
+#define V4L2_CID_RF_TUNER_RF_GAIN		(V4L2_CID_RF_TUNER_CLASS_BASE + 32)
 #define V4L2_CID_RF_TUNER_LNA_GAIN_AUTO		(V4L2_CID_RF_TUNER_CLASS_BASE + 41)
 #define V4L2_CID_RF_TUNER_LNA_GAIN		(V4L2_CID_RF_TUNER_CLASS_BASE + 42)
 #define V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO	(V4L2_CID_RF_TUNER_CLASS_BASE + 51)
-- 
http://palosaari.fi/

