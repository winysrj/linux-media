Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1533 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab0KNNXE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 08:23:04 -0500
Message-Id: <4bc7398f52b0a8cb0e8147fe9e2443772fe7d199.1289740431.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1289740431.git.hverkuil@xs4all.nl>
References: <cover.1289740431.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 14 Nov 2010 14:23:04 +0100
Subject: [RFC PATCH 7/8] dsbr100: convert to unlocked_ioctl.
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Trivial conversion to unlocked_ioctl.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/dsbr100.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index ed9cd7a..c3e952f 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -605,7 +605,7 @@ static void usb_dsbr100_video_device_release(struct video_device *videodev)
 /* File system interface */
 static const struct v4l2_file_operations usb_dsbr100_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 static const struct v4l2_ioctl_ops usb_dsbr100_ioctl_ops = {
-- 
1.7.0.4

