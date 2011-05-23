Return-path: <mchehab@pedra>
Received: from mailfe04.c2i.net ([212.247.154.98]:57214 "EHLO swip.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755387Ab1EWPMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 11:12:46 -0400
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: [PATCH] Add missing include guard to header file.
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 17:11:34 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105231711.34254.hselasky@c2i.net>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

>From 30f6407c5eb67ac8ebf7da169c1f8e500e221db6 Mon Sep 17 00:00:00 2001
From: Hans Petter Selasky <hselasky@c2i.net>
Date: Mon, 23 May 2011 17:10:40 +0200
Subject: [PATCH] Add missing include guard to header file.

Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
---
 include/media/videobuf-dvb.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/media/videobuf-dvb.h b/include/media/videobuf-dvb.h
index 07cf4b9..bf36572 100644
--- a/include/media/videobuf-dvb.h
+++ b/include/media/videobuf-dvb.h
@@ -4,6 +4,9 @@
 #include <dvb_net.h>
 #include <dvb_frontend.h>
 
+#ifndef _VIDEOBUF_DVB_H_
+#define	_VIDEOBUF_DVB_H_
+
 struct videobuf_dvb {
 	/* filling that the job of the driver */
 	char                       *name;
@@ -54,6 +57,7 @@ void videobuf_dvb_dealloc_frontends(struct videobuf_dvb_frontends *f);
 struct videobuf_dvb_frontend * videobuf_dvb_get_frontend(struct videobuf_dvb_frontends *f, int id);
 int videobuf_dvb_find_frontend(struct videobuf_dvb_frontends *f, struct dvb_frontend *p);
 
+#endif			/* _VIDEOBUF_DVB_H_ */
 
 /*
  * Local variables:
-- 
1.7.1.1


