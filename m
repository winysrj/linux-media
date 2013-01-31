Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:4110 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab3AaKZq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 05:25:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Huang Shijie <shijie8@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFC PATCH 03/18] tlg2300: switch to unlocked_ioctl.
Date: Thu, 31 Jan 2013 11:25:21 +0100
Message-Id: <d1b82f78da6c96ca5d0bd8608af7060192342513.1359627298.git.hans.verkuil@cisco.com>
In-Reply-To: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
References: <1359627936-14918-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
References: <608a45800f829b97fcc5c00b1decc64c829d71cb.1359627298.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The driver already does locking, so it is safe to switch to unlocked_ioctl.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/tlg2300/pd-radio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/tlg2300/pd-radio.c b/drivers/media/usb/tlg2300/pd-radio.c
index 90dc1d1..c4feffb 100644
--- a/drivers/media/usb/tlg2300/pd-radio.c
+++ b/drivers/media/usb/tlg2300/pd-radio.c
@@ -156,7 +156,7 @@ static const struct v4l2_file_operations poseidon_fm_fops = {
 	.owner         = THIS_MODULE,
 	.open          = poseidon_fm_open,
 	.release       = poseidon_fm_close,
-	.ioctl	       = video_ioctl2,
+	.unlocked_ioctl = video_ioctl2,
 };
 
 static int tlg_fm_vidioc_g_tuner(struct file *file, void *priv,
-- 
1.7.10.4

