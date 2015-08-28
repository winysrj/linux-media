Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:54380 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751737AbbH1Lte (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 07:49:34 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, ricardo.ribalda@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 3/8] saa7164: fix poll bugs
Date: Fri, 28 Aug 2015 13:48:28 +0200
Message-Id: <1440762513-30457-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1440762513-30457-1-git-send-email-hverkuil@xs4all.nl>
References: <1440762513-30457-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

- poll doesn't return negative values, so you can't return -EINVAL.
  Instead return POLLERR.
- poll can't be called if !video_is_registered(), so this test can
  be dropped.
- poll can never do a blocking wait, so remove that check.
- poll shouldn't attempt to start streaming if the caller isn't interested
  in read events.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7164/saa7164-encoder.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 96dd1e4..fd32fa0 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -915,6 +915,7 @@ err:
 
 static unsigned int fops_poll(struct file *file, poll_table *wait)
 {
+	unsigned long req_events = poll_requested_events(wait);
 	struct saa7164_encoder_fh *fh =
 		(struct saa7164_encoder_fh *)file->private_data;
 	struct saa7164_port *port = fh->port;
@@ -928,26 +929,18 @@ static unsigned int fops_poll(struct file *file, poll_table *wait)
 	saa7164_histogram_update(&port->poll_interval,
 		port->last_poll_msecs_diff);
 
-	if (!video_is_registered(port->v4l_device))
-		return -EIO;
+	if (!(req_events & (POLLIN | POLLRDNORM)))
+		return mask;
 
 	if (atomic_cmpxchg(&fh->v4l_reading, 0, 1) == 0) {
 		if (atomic_inc_return(&port->v4l_reader_count) == 1) {
 			if (saa7164_encoder_initialize(port) < 0)
-				return -EINVAL;
+				return POLLERR;
 			saa7164_encoder_start_streaming(port);
 			msleep(200);
 		}
 	}
 
-	/* blocking wait for buffer */
-	if ((file->f_flags & O_NONBLOCK) == 0) {
-		if (wait_event_interruptible(port->wait_read,
-			saa7164_enc_next_buf(port))) {
-				return -ERESTARTSYS;
-		}
-	}
-
 	/* Pull the first buffer from the used list */
 	if (!list_empty(&port->list_buf_used.list))
 		mask |= POLLIN | POLLRDNORM;
-- 
2.1.4

