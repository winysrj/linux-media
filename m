Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42887 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933215AbaBAOYt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 1 Feb 2014 09:24:49 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 15/17] v4l: add RF tuner channel bandwidth control
Date: Sat,  1 Feb 2014 16:24:32 +0200
Message-Id: <1391264674-4395-16-git-send-email-crope@iki.fi>
In-Reply-To: <1391264674-4395-1-git-send-email-crope@iki.fi>
References: <1391264674-4395-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Modern silicon RF tuners has one or more adjustable filters on
signal path, in order to filter noise from desired radio channel.

Add channel bandwidth control to tell the driver which is radio
channel width we want receive. Filters could be then adjusted by
the driver or hardware, using RF frequency and channel bandwidth
as a base of filter calculations.

On automatic mode (normal mode), bandwidth is calculated from sampling
rate or tuning info got from userspace. That new control gives
possibility to set manual mode and let user have more control for
filters.

Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 4 ++++
 include/uapi/linux/v4l2-controls.h   | 2 ++
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index d201f61..e44722b 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -865,6 +865,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MIXER_GAIN:		return "Mixer Gain";
 	case V4L2_CID_IF_GAIN_AUTO:		return "IF Gain, Auto";
 	case V4L2_CID_IF_GAIN:			return "IF Gain";
+	case V4L2_CID_BANDWIDTH_AUTO:		return "Channel Bandwidth, Auto";
+	case V4L2_CID_BANDWIDTH:		return "Channel Bandwidth";
 	default:
 		return NULL;
 	}
@@ -917,6 +919,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_LNA_GAIN_AUTO:
 	case V4L2_CID_MIXER_GAIN_AUTO:
 	case V4L2_CID_IF_GAIN_AUTO:
+	case V4L2_CID_BANDWIDTH_AUTO:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
@@ -1078,6 +1081,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_LNA_GAIN:
 	case V4L2_CID_MIXER_GAIN:
 	case V4L2_CID_IF_GAIN:
+	case V4L2_CID_BANDWIDTH:
 		*flags |= V4L2_CTRL_FLAG_SLIDER;
 		break;
 	case V4L2_CID_PAN_RELATIVE:
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 076fa34..3cf68a6 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -905,5 +905,7 @@ enum v4l2_deemphasis {
 #define V4L2_CID_MIXER_GAIN			(V4L2_CID_RF_TUNER_CLASS_BASE + 4)
 #define V4L2_CID_IF_GAIN_AUTO			(V4L2_CID_RF_TUNER_CLASS_BASE + 5)
 #define V4L2_CID_IF_GAIN			(V4L2_CID_RF_TUNER_CLASS_BASE + 6)
+#define V4L2_CID_BANDWIDTH_AUTO			(V4L2_CID_RF_TUNER_CLASS_BASE + 7)
+#define V4L2_CID_BANDWIDTH			(V4L2_CID_RF_TUNER_CLASS_BASE + 8)
 
 #endif
-- 
1.8.5.3

