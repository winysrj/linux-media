Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:47802 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304AbZJGHmQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 Oct 2009 03:42:16 -0400
Message-ID: <4ACC4631.3040002@linuxtv.org>
Date: Wed, 07 Oct 2009 09:41:37 +0200
From: Michael Hunold <hunold@linuxtv.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	johann.friedrichs@web.de
Subject: [PATCH] saa7146 memory leakage in pagetable-handling, v2
Content-Type: multipart/mixed;
 boundary="------------020306070100070003050203"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020306070100070003050203
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello Mauro,

on Mon, 28 Sep 2009 Johann Friedrichs sent a patch to linux-media in
order to fix a memory leak in my saa7146 driver.

He contacted me and together we have come up with a new patch that fixes
the problem more explicitely.

Would you please be so kind and manually pick up this patch and provide
it upstream?

All kudos belong to Johann Friedrich for finding the bug and providing
the initial fix.

Best regards
Michael Hunold.



--------------020306070100070003050203
Content-Type: text/plain;
 name="saa7146_fix_pagetables_memory_leak.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="saa7146_fix_pagetables_memory_leak.diff"

V4L: saa7146: fix memory leak when buffer properties change or buffer
              is released

From: Johann Friedrichs <johann.friedrichs@web.de>

In buffer_release() the previously allocated pagetables are not
freed,  which might result in a memory leak in certain application
use-cases, where the frame format is changed from planar format to
non-planar format. The fix explicitely frees the page tables when a
format change is done and when buffer_release() is called.

Signed-off-by: Johann Friedrichs <johann.friedrichs@web.de>
Signed-off-by: Michael Hunold <hunold@linuxtv.org>

diff --git a/drivers/media/common/saa7146_video.c b/drivers/media/common/saa7146_video.c
index 552dab4..becbaad 100644
--- a/drivers/media/common/saa7146_video.c
+++ b/drivers/media/common/saa7146_video.c
@@ -1205,6 +1205,13 @@ static int buffer_activate (struct saa7146_dev *dev,
 	return 0;
 }
 
+static void release_all_pagetables(struct saa7146_dev *dev, struct saa7146_buf *buf)
+{
+	saa7146_pgtable_free(dev->pci, &buf->pt[0]);
+	saa7146_pgtable_free(dev->pci, &buf->pt[1]);
+	saa7146_pgtable_free(dev->pci, &buf->pt[2]);
+}
+
 static int buffer_prepare(struct videobuf_queue *q,
 			  struct videobuf_buffer *vb, enum v4l2_field field)
 {
@@ -1257,16 +1264,12 @@ static int buffer_prepare(struct videobuf_queue *q,
 
 		sfmt = format_by_fourcc(dev,buf->fmt->pixelformat);
 
+		release_all_pagetables(dev, buf);
 		if( 0 != IS_PLANAR(sfmt->trans)) {
-			saa7146_pgtable_free(dev->pci, &buf->pt[0]);
-			saa7146_pgtable_free(dev->pci, &buf->pt[1]);
-			saa7146_pgtable_free(dev->pci, &buf->pt[2]);
-
 			saa7146_pgtable_alloc(dev->pci, &buf->pt[0]);
 			saa7146_pgtable_alloc(dev->pci, &buf->pt[1]);
 			saa7146_pgtable_alloc(dev->pci, &buf->pt[2]);
 		} else {
-			saa7146_pgtable_free(dev->pci, &buf->pt[0]);
 			saa7146_pgtable_alloc(dev->pci, &buf->pt[0]);
 		}
 
@@ -1329,6 +1332,9 @@ static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
 	struct saa7146_buf *buf = (struct saa7146_buf *)vb;
 
 	DEB_CAP(("vbuf:%p\n",vb));
+
+	release_all_pagetables(dev, buf);
+
 	saa7146_dma_free(dev,q,buf);
 }
 

--------------020306070100070003050203--
