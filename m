Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49533 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755561Ab3FFB07 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Jun 2013 21:26:59 -0400
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: smoch@web.de, <stable@vger.kernel.org>
Subject: [RESEND PATCH 1/1] media: dmxdev: remove dvb_ringbuffer_flush() on writer side
Date: Thu,  6 Jun 2013 04:26:23 +0300
Message-Id: <1370481983-8336-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Soeren Moch <smoch@web.de>

In dvb_ringbuffer lock-less synchronizationof reader and writer threads is done
with separateread and write pointers. Sincedvb_ringbuffer_flush() modifies the
read pointer, this function must not be called from the writer thread.

This patch removes the dvb_ringbuffer_flush() calls in the dmxdev ringbuffer
write functions, this fixes Oopses "Unable to handle kernel paging request"
I could observe for the call chaindvb_demux_read ->dvb_dmxdev_buffer_read ->
dvb_ringbuffer_read_user -> __copy_to_user (the reader side of the ringbuffer).

The flush calls at the write side are not necessary anyway since ringbuffer_flush
is also called in dvb_dmxdev_buffer_read() when an error condition is set in the
ringbuffer.

This patch should also be applied to stable kernels.

Signed-off-by: Soeren Moch <smoch@web.de>
CC: <stable@vger.kernel.org>
Reviewed-by: Sakari Ailus <sakari.ailus@iki.fi>
---
Same as Soeren's original; just resolved conflicts likely caused by non-git
send-email MUA.

 drivers/media/dvb-core/dmxdev.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index a1a3a51..0b4616b 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -377,10 +377,8 @@ static int dvb_dmxdev_section_callback(const u8 *buffer1, size_t buffer1_len,
 		ret = dvb_dmxdev_buffer_write(&dmxdevfilter->buffer, buffer2,
 					      buffer2_len);
 	}
-	if (ret < 0) {
-		dvb_ringbuffer_flush(&dmxdevfilter->buffer);
+	if (ret < 0)
 		dmxdevfilter->buffer.error = ret;
-	}
 	if (dmxdevfilter->params.sec.flags & DMX_ONESHOT)
 		dmxdevfilter->state = DMXDEV_STATE_DONE;
 	spin_unlock(&dmxdevfilter->dev->lock);
@@ -416,10 +414,8 @@ static int dvb_dmxdev_ts_callback(const u8 *buffer1, size_t buffer1_len,
 	ret = dvb_dmxdev_buffer_write(buffer, buffer1, buffer1_len);
 	if (ret == buffer1_len)
 		ret = dvb_dmxdev_buffer_write(buffer, buffer2, buffer2_len);
-	if (ret < 0) {
-		dvb_ringbuffer_flush(buffer);
+	if (ret < 0)
 		buffer->error = ret;
-	}
 	spin_unlock(&dmxdevfilter->dev->lock);
 	wake_up(&buffer->queue);
 	return 0;
-- 
1.7.10.4

