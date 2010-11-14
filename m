Return-path: <mchehab@pedra>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:3711 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab0KNNWs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Nov 2010 08:22:48 -0500
Message-Id: <5b6c5e0878e66b50bb06290a9a52afccd1d922ec.1289740431.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1289740431.git.hverkuil@xs4all.nl>
References: <cover.1289740431.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 14 Nov 2010 14:22:42 +0100
Subject: [RFC PATCH 5/8] si4713: convert to unlocked_ioctl
To: linux-media@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Convert ioctl to unlocked_ioctl. Note that for this driver the locking
is done inside the sub-device.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/radio/radio-si4713.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 6a43578..3a84c3d 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -53,7 +53,8 @@ struct radio_si4713_device {
 /* radio_si4713_fops - file operations interface */
 static const struct v4l2_file_operations radio_si4713_fops = {
 	.owner		= THIS_MODULE,
-	.ioctl		= video_ioctl2,
+	/* Note: locking is done at the subdev level in the i2c driver. */
+	.unlocked_ioctl	= video_ioctl2,
 };
 
 /* Video4Linux Interface */
-- 
1.7.0.4

