Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2527 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab3FVKHJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 Jun 2013 06:07:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Manjunatha Halli <manjunatha_halli@ti.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 2/6] wl128x: querycap: set device_caps field.
Date: Sat, 22 Jun 2013 12:06:51 +0200
Message-Id: <1371895615-14162-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1371895615-14162-1-git-send-email-hverkuil@xs4all.nl>
References: <1371895615-14162-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Also prefix bus_info with 'platform:' and something more specific
than 'UART'.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/radio/wl128x/fmdrv_v4l2.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index b55012c..1d8fa30 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -197,11 +197,13 @@ static int fm_v4l2_vidioc_querycap(struct file *file, void *priv,
 	strlcpy(capability->driver, FM_DRV_NAME, sizeof(capability->driver));
 	strlcpy(capability->card, FM_DRV_CARD_SHORT_NAME,
 			sizeof(capability->card));
-	sprintf(capability->bus_info, "UART");
-	capability->capabilities = V4L2_CAP_HW_FREQ_SEEK | V4L2_CAP_TUNER |
+	snprintf(capability->bus_info, sizeof(capability->bus_info),
+			"platform:%s", FM_DRV_NAME);
+	capability->device_caps = V4L2_CAP_HW_FREQ_SEEK | V4L2_CAP_TUNER |
 		V4L2_CAP_RADIO | V4L2_CAP_MODULATOR |
 		V4L2_CAP_AUDIO | V4L2_CAP_READWRITE |
 		V4L2_CAP_RDS_CAPTURE;
+	capability->capabilities = capability->device_caps | V4L2_CAP_DEVICE_CAPS;
 
 	return 0;
 }
-- 
1.8.3.1

