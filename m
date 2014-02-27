Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:47297 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbaB0AWW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Feb 2014 19:22:22 -0500
From: Antti Palosaari <crope@iki.fi>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [REVIEW PATCH 06/13] v4l: add control for RF tuner PLL lock flag
Date: Thu, 27 Feb 2014 02:22:01 +0200
Message-Id: <1393460528-11684-7-git-send-email-crope@iki.fi>
In-Reply-To: <1393460528-11684-1-git-send-email-crope@iki.fi>
References: <1393460528-11684-1-git-send-email-crope@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add volatile boolean control to indicate if tuner frequency synthesizer
is locked to requested frequency. That means tuner is able to receive
given frequency. Control is named as "PLL lock", since frequency
synthesizers are based of phase-locked-loop. Maybe more general name
could be wise still?

Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Antti Palosaari <crope@iki.fi>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 5 +++++
 include/uapi/linux/v4l2-controls.h   | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 07400dc..7f1bcab 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -867,6 +867,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_RF_TUNER_IF_GAIN:		return "IF Gain";
 	case V4L2_CID_RF_TUNER_BANDWIDTH_AUTO:	return "Bandwidth, Auto";
 	case V4L2_CID_RF_TUNER_BANDWIDTH:	return "Bandwidth";
+	case V4L2_CID_RF_TUNER_PLL_LOCK:	return "PLL Lock";
 	default:
 		return NULL;
 	}
@@ -920,6 +921,7 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RF_TUNER_MIXER_GAIN_AUTO:
 	case V4L2_CID_RF_TUNER_IF_GAIN_AUTO:
 	case V4L2_CID_RF_TUNER_BANDWIDTH_AUTO:
+	case V4L2_CID_RF_TUNER_PLL_LOCK:
 		*type = V4L2_CTRL_TYPE_BOOLEAN;
 		*min = 0;
 		*max = *step = 1;
@@ -1100,6 +1102,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_DV_RX_POWER_PRESENT:
 		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
 		break;
+	case V4L2_CID_RF_TUNER_PLL_LOCK:
+		*flags |= V4L2_CTRL_FLAG_VOLATILE;
+		break;
 	}
 }
 EXPORT_SYMBOL(v4l2_ctrl_fill);
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index b7d4bb8..363a092 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -907,5 +907,6 @@ enum v4l2_deemphasis {
 #define V4L2_CID_RF_TUNER_MIXER_GAIN		(V4L2_CID_RF_TUNER_CLASS_BASE + 52)
 #define V4L2_CID_RF_TUNER_IF_GAIN_AUTO		(V4L2_CID_RF_TUNER_CLASS_BASE + 61)
 #define V4L2_CID_RF_TUNER_IF_GAIN		(V4L2_CID_RF_TUNER_CLASS_BASE + 62)
+#define V4L2_CID_RF_TUNER_PLL_LOCK			(V4L2_CID_RF_TUNER_CLASS_BASE + 91)
 
 #endif
-- 
1.8.5.3

