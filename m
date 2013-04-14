Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:4848 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab3DNP1l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:27:41 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, stable@vger.kernel.org
Subject: [REVIEW PATCH 01/30] cx25821: do not expose broken video output streams.
Date: Sun, 14 Apr 2013 17:26:57 +0200
Message-Id: <1365953246-8972-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The cx25821 driver has support for one audio output channel and two video
output channels.

This is implemented in a very ugly and very evil way through a custom ioctl
that passes the filename of a file containing the video data, which is then
read by the driver itself using vfs.

There are a number of problems with this:

1) it's very ugly and very evil (I can't say that often enough).
2) V4L2 supports video output, so why not use that?
3) it's very buggy, closing the filehandle through which you passed the ioctl
   will oops the kernel.
4) it's a nasty security leak since this allows you to load any file in the
   system as a video or audio source, so in theory you can output /etc/passwd
   to audio or video out and record & decode it on another device.

Because of all these issues we no longer register those output video nodes.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Cc: stable@vger.kernel.org
---
 drivers/media/pci/cx25821/cx25821-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index 1465591..6b18320 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -461,7 +461,7 @@ int cx25821_video_register(struct cx25821_dev *dev)
 
 	spin_lock_init(&dev->slock);
 
-	for (i = 0; i < MAX_VID_CHANNEL_NUM - 1; ++i) {
+	for (i = 0; i < VID_CHANNEL_NUM; ++i) {
 		cx25821_init_controls(dev, i);
 
 		cx25821_risc_stopper(dev->pci, &dev->channels[i].vidq.stopper,
-- 
1.7.10.4

