Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:54821 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbaHUCGF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Aug 2014 22:06:05 -0400
Received: from epcpsbgm2.samsung.com (epcpsbgm2 [203.254.230.27])
 by mailout1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NAM00AM3WHX4KB0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 21 Aug 2014 11:05:57 +0900 (KST)
From: Changbing Xiong <cb.xiong@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, crope@iki.fi
Subject: [PATCH 3/3] media: check status of dmxdev->exit in poll functions of
 demux&dvr
Date: Thu, 21 Aug 2014 10:05:40 +0800
Message-id: <1408586740-2169-1-git-send-email-cb.xiong@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

when usb-type tuner is pulled out, user applications did not close device's FD,
and go on polling the device, we should return POLLERR directly.

Signed-off-by: Changbing Xiong <cb.xiong@samsung.com>
---
 drivers/media/dvb-core/dmxdev.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index 7a5c070..42b5e70 100755
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -1085,9 +1085,10 @@ static long dvb_demux_ioctl(struct file *file, unsigned int cmd,
 static unsigned int dvb_demux_poll(struct file *file, poll_table *wait)
 {
 	struct dmxdev_filter *dmxdevfilter = file->private_data;
+	struct dmxdev *dmxdev = dmxdevfilter->dev;
 	unsigned int mask = 0;

-	if (!dmxdevfilter)
+	if ((!dmxdevfilter) || (dmxdev->exit))
 		return POLLERR;

 	poll_wait(file, &dmxdevfilter->buffer.queue, wait);
@@ -1181,6 +1182,9 @@ static unsigned int dvb_dvr_poll(struct file *file, poll_table *wait)

 	dprintk("function : %s\n", __func__);

+	if (dmxdev->exit)
+		return POLLERR;
+
 	poll_wait(file, &dmxdev->dvr_buffer.queue, wait);

 	if ((file->f_flags & O_ACCMODE) == O_RDONLY) {
--
1.7.9.5

