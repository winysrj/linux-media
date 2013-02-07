Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-4.cisco.com ([144.254.224.147]:59048 "EHLO
	ams-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757921Ab3BGLFq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Feb 2013 06:05:46 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] tm6000: fix an uninitialized variable.
Date: Thu, 7 Feb 2013 12:05:43 +0100
Cc: Dan Carpenter <dan.carpenter@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201302071205.43543.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

tm6000_poll could use an uninitialized buf pointer. Move the buf-handling
code inside the 'if' that initializes the buf pointer.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/media/usb/tm6000/tm6000-video.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index eab2341..1a68579 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -1455,14 +1455,14 @@ __tm6000_poll(struct file *file, struct poll_table_struct *wait)
 		if (list_empty(&fh->vb_vidq.stream))
 			return res | POLLERR;
 		buf = list_entry(fh->vb_vidq.stream.next, struct tm6000_buffer, vb.stream);
+		poll_wait(file, &buf->vb.done, wait);
+		if (buf->vb.state == VIDEOBUF_DONE ||
+		    buf->vb.state == VIDEOBUF_ERROR)
+			return res | POLLIN | POLLRDNORM;
 	} else if (req_events & (POLLIN | POLLRDNORM)) {
 		/* read() capture */
 		return res | videobuf_poll_stream(file, &fh->vb_vidq, wait);
 	}
-	poll_wait(file, &buf->vb.done, wait);
-	if (buf->vb.state == VIDEOBUF_DONE ||
-	    buf->vb.state == VIDEOBUF_ERROR)
-		return res | POLLIN | POLLRDNORM;
 	return res;
 }
 
-- 
1.7.10.4

