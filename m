Return-path: <linux-media-owner@vger.kernel.org>
Received: from claranet-outbound-smtp05.uk.clara.net ([195.8.89.38]:46504 "EHLO
	claranet-outbound-smtp05.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735Ab2LJOOM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Dec 2012 09:14:12 -0500
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: linux-media@vger.kernel.org
Cc: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
Subject: [PATCHv2] saa7134: Add pm_qos_request to fix video corruption
Date: Mon, 10 Dec 2012 12:35:09 +0000
Message-Id: <1355142909-25644-1-git-send-email-simon.farnsworth@onelan.co.uk>
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

v2 changes: Reduced the latency further, based on a functional block level
datasheet. Comment updated to match.

As noted in the comment, I can't check this in detail.

My SandyBridge systems convert any value less than about 80 usec into 0
usec, as that's the hardware latency from the lightest deep sleep state, and
I'm not aware of any hardware that would let me set the latency directly.

If someone has register-level documentation for the SAA7134, checking our
FIFO configuration and matching the DMA latency to it would be useful.

 drivers/media/pci/saa7134/saa7134-video.c | 13 +++++++++++++
 drivers/media/pci/saa7134/saa7134.h       |  2 ++
 2 files changed, 15 insertions(+)

diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 4a77124..3f4a2a6 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -2248,6 +2248,17 @@ static int saa7134_streamon(struct file *file, void *priv,
 	if (!res_get(dev, fh, res))
 		return -EBUSY;
 
+	/* The SAA7134 has a 1K FIFO; the datasheet suggests that when
+	 * configured conservatively, there's 22 usec of buffering for video.
+         * We therefore request a DMA latency of 20 usec, giving us 2 usec of
+         * margin in case the FIFO is configured differently to the datasheet.
+         * Unfortunately, I lack register-level documentation to check the
+         * Linux FIFO setup and confirm the perfect value.
+	 */
+	pm_qos_add_request(&fh->qos_request,
+			   PM_QOS_CPU_DMA_LATENCY,
+			   20);
+
 	return videobuf_streamon(saa7134_queue(fh));
 }
 
@@ -2259,6 +2270,8 @@ static int saa7134_streamoff(struct file *file, void *priv,
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
1.7.11.7

