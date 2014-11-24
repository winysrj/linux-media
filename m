Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:47359 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752965AbaKXJiL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Nov 2014 04:38:11 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/6] media/radio: fix querycap
Date: Mon, 24 Nov 2014 10:37:24 +0100
Message-Id: <1416821846-7677-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1416821846-7677-1-git-send-email-hverkuil@xs4all.nl>
References: <1416821846-7677-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Querycap should set the device_caps field.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/radio-wl1273.c      | 4 +++-
 drivers/media/radio/wl128x/fmdrv_v4l2.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 9cf6731..284f789 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1279,10 +1279,12 @@ static int wl1273_fm_vidioc_querycap(struct file *file, void *priv,
 	strlcpy(capability->bus_info, radio->bus_type,
 		sizeof(capability->bus_info));
 
-	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK |
+	capability->device_caps = V4L2_CAP_HW_FREQ_SEEK |
 		V4L2_CAP_TUNER | V4L2_CAP_RADIO | V4L2_CAP_AUDIO |
 		V4L2_CAP_RDS_CAPTURE | V4L2_CAP_MODULATOR |
 		V4L2_CAP_RDS_OUTPUT;
+	capability->capabilities = capability->device_caps |
+		V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index b55012c..a5bd3f6 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -198,10 +198,12 @@ static int fm_v4l2_vidioc_querycap(struct file *file, void *priv,
 	strlcpy(capability->card, FM_DRV_CARD_SHORT_NAME,
 			sizeof(capability->card));
 	sprintf(capability->bus_info, "UART");
-	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK | V4L2_CAP_TUNER |
+	capability->device_caps = V4L2_CAP_HW_FREQ_SEEK | V4L2_CAP_TUNER |
 		V4L2_CAP_RADIO | V4L2_CAP_MODULATOR |
 		V4L2_CAP_AUDIO | V4L2_CAP_READWRITE |
 		V4L2_CAP_RDS_CAPTURE;
+	capability->capabilities = capability->device_caps |
+		V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
-- 
2.1.3

