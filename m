Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:53177 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638AbZKVVDF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Nov 2009 16:03:05 -0500
Message-ID: <4B09A709.7070505@freemail.hu>
Date: Sun, 22 Nov 2009 22:03:05 +0100
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [cron job] v4l-dvb daily build 2.6.22 and up: ERRORS, 2.6.16-2.6.21:
 ERRORS
References: <200911221953.nAMJrnWU075450@smtp-vbr1.xs4all.nl>
In-Reply-To: <200911221953.nAMJrnWU075450@smtp-vbr1.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil worte:
> linux-2.6.22.19-armv5: WARNINGS

/marune/build/v4l-dvb-master/v4l/videobuf-core.c: In function 'videobuf_reqbufs':
/marune/build/v4l-dvb-master/v4l/videobuf-core.c:434: warning: format '%d' expects type 'int', but argument 4 has type 'long unsigned int'

I think this can be solved by explicit casting the result.

---
Subject: [PATCH] explicitly cast page count
From: Márton Németh <nm127@freemail.hu>

Explicitly cast page count in the debug message.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -r bc16afd1e7a4 linux/drivers/media/video/videobuf-core.c
--- a/linux/drivers/media/video/videobuf-core.c	Sat Nov 21 12:01:36 2009 +0100
+++ b/linux/drivers/media/video/videobuf-core.c	Sun Nov 22 21:56:20 2009 +0100
@@ -431,8 +431,9 @@
 		count = VIDEO_MAX_FRAME;
 	size = 0;
 	q->ops->buf_setup(q, &count, &size);
-	dprintk(1, "reqbufs: bufs=%d, size=0x%x [%d pages total]\n",
-		count, size, (count*PAGE_ALIGN(size))>>PAGE_SHIFT);
+	dprintk(1, "reqbufs: bufs=%d, size=0x%x [%u pages total]\n",
+		count, size,
+		(unsigned int)((count*PAGE_ALIGN(size))>>PAGE_SHIFT) );

 	retval = __videobuf_mmap_setup(q, count, size, req->memory);
 	if (retval < 0) {
