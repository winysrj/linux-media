Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3474 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab3AaKZv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 05:25:51 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Huang Shijie <shijie8@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 08/18] tlg2300: fix radio querycap
Date: Thu, 31 Jan 2013 11:25:26 +0100
Message-Id: <e745ec830817f4eab48445b0e205a7b568a0e2b0.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
References: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tlg2300/pd-radio.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
index 854ffa0..80307d3 100644
--- a/drivers/media/usb/tlg2300/pd-radio.c
+++ b/drivers/media/usb/tlg2300/pd-radio.c
@@ -147,7 +147,12 @@ static int vidioc_querycap(struct file *file, void *priv,
 	strlcpy(v->driver, "tele-radio", sizeof(v->driver));
 	strlcpy(v->card, "Telegent Poseidon", sizeof(v->card));
 	usb_make_path(p->udev, v->bus_info, sizeof(v->bus_info));
-	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
+	/* Report all capabilities of the USB device */
+	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS |
+			V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VBI_CAPTURE |
+			V4L2_CAP_AUDIO | V4L2_CAP_STREAMING |
+			V4L2_CAP_READWRITE;
 	return 0;
 }
 
-- 
1.7.10.4

