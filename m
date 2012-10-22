Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp01.uk.clara.net ([195.8.89.34]:40761 "EHLO
	claranet-outbound-smtp01.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752948Ab2JVLuS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Oct 2012 07:50:18 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: linux-media@vger.kernel.org
Cc: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Subject: [PATCH] saa7134: Add pm_qos_request to fix video corruption
Date: Mon, 22 Oct 2012 12:50:11 +0100
Message-Id: <1350906611-17498-1-git-send-email-simon.farnsworth@onelan.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The SAA7134 appears to have trouble buffering more than one line of video
when doing DMA. Rather than try to fix the driver to cope (as has been done
by Andy Walls for the cx18 driver), put in a pm_qos_request to limit deep
sleep exit latencies.

The visible effect of not having this is that seemingly random lines are
only partly transferred - if you feed in a static image, you see a portion
of the image "flicker" into place.

Signed-off-by: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
---

As per the comment, note that I've not been able to nail down the maximum
latency the SAA7134 can cope with. I know that the chip has a 1KiB FIFO
buffer, so I'm assuming that it can store half a line of video at a time, on
the basis of 720 luma, 360 Cb, 360 Cr samples, totalling 1440 bytes per
line. If this is a bad assumption (I've not been able to find register-level
documentation for the chip, so I don't know what
saa_writel(SAA7134_FIFO_SIZE, 0x08070503) does in saa7134_hw_enable1() in
saa7134-core.c), that value will need adjusting to match the real FIFO
latency.

 drivers/media/pci/saa7134/saa7134-video.c | 12 ++++++++++++
 drivers/media/pci/saa7134/saa7134.h       |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 4a77124..dbc0b5d 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2248,6 +2248,15 @@ static int saa7134_streamon(struct file *file, void *priv,
 	if (!res_get(dev, fh, res))
 		return -EBUSY;
 
+	/* The SAA7134 has a 1K FIFO; the assumption here is that that's
+	 * enough for half a line of video in the configuration Linux uses.
+	 * If it isn't, reduce the 31 usec down to the maximum FIFO time
+	 * allowance.
+	 */
+	pm_qos_add_request(&fh->qos_request,
+			   PM_QOS_CPU_DMA_LATENCY,
+			   31);
+
 	return videobuf_streamon(saa7134_queue(fh));
 }
 
@@ -2259,6 +2269,8 @@ static int saa7134_streamoff(struct file *file, void *priv,
 	struct saa7134_dev *dev = fh->dev;
 	int res = saa7134_resource(fh);
 
+	pm_qos_remove_request(&fh->qos_request);
+
 	err = videobuf_streamoff(saa7134_queue(fh));
 	if (err < 0)
 		return err;
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index c24b651..d09393b 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -29,6 +29,7 @@
 #include <linux/notifier.h>
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/pm_qos_params.h>
 
 #include <asm/io.h>
 
@@ -469,6 +470,7 @@ struct saa7134_fh {
 	enum v4l2_buf_type         type;
 	unsigned int               resources;
 	enum v4l2_priority	   prio;
+	struct pm_qos_request_list qos_request;
 
 	/* video overlay */
 	struct v4l2_window         win;
-- 
1.7.11.2

