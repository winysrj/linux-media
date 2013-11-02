Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60718 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab3KBQdj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:39 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [PATCHv2 11/29] uvc/lirc_serial: Fix some warnings on parisc arch
Date: Sat,  2 Nov 2013 11:31:19 -0200
Message-Id: <1383399097-11615-12-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On this arch, usec is not unsigned long. So, we need to typecast,
in order to remove those warnings:

	drivers/media/usb/uvc/uvc_video.c: In function 'uvc_video_clock_update':
	drivers/media/usb/uvc/uvc_video.c:678:2: warning: format '%lu' expects argument of type 'long unsigned int', but argument 9 has type '__kernel_suseconds_t' [-Wformat]
	drivers/staging/media/lirc/lirc_serial.c: In function 'irq_handler':
	drivers/staging/media/lirc/lirc_serial.c:707:5: warning: format '%lx' expects argument of type 'long unsigned int', but argument 6 has type '__kernel_suseconds_t' [-Wformat]
	drivers/staging/media/lirc/lirc_serial.c:707:5: warning: format '%lx' expects argument of type 'long unsigned int', but argument 7 has type '__kernel_suseconds_t' [-Wformat]
	drivers/staging/media/lirc/lirc_serial.c:719:5: warning: format '%lx' expects argument of type 'long unsigned int', but argument 6 has type '__kernel_suseconds_t' [-Wformat]
	drivers/staging/media/lirc/lirc_serial.c:719:5: warning: format '%lx' expects argument of type 'long unsigned int', but argument 7 has type '__kernel_suseconds_t' [-Wformat]
	drivers/staging/media/lirc/lirc_serial.c:728:6: warning: format '%lx' expects argument of type 'long unsigned int', but argument 6 has type '__kernel_suseconds_t' [-Wformat]
	drivers/staging/media/lirc/lirc_serial.c:728:6: warning: format '%lx' expects argument of type 'long unsigned int', but argument 7 has type '__kernel_suseconds_t' [-Wformat]

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 drivers/media/usb/uvc/uvc_video.c        | 3 ++-
 drivers/staging/media/lirc/lirc_serial.c | 9 ++++++---
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 3394c3432011..899cb6d1c4a4 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -680,7 +680,8 @@ void uvc_video_clock_update(struct uvc_streaming *stream,
 		  stream->dev->name,
 		  sof >> 16, div_u64(((u64)sof & 0xffff) * 1000000LLU, 65536),
 		  y, ts.tv_sec, ts.tv_nsec / NSEC_PER_USEC,
-		  v4l2_buf->timestamp.tv_sec, v4l2_buf->timestamp.tv_usec,
+		  v4l2_buf->timestamp.tv_sec,
+		  (unsigned long)v4l2_buf->timestamp.tv_usec,
 		  x1, first->host_sof, first->dev_sof,
 		  x2, last->host_sof, last->dev_sof, y1, y2);
 
diff --git a/drivers/staging/media/lirc/lirc_serial.c b/drivers/staging/media/lirc/lirc_serial.c
index af08e677b60f..7b3be2346b4b 100644
--- a/drivers/staging/media/lirc/lirc_serial.c
+++ b/drivers/staging/media/lirc/lirc_serial.c
@@ -707,7 +707,8 @@ static irqreturn_t irq_handler(int i, void *blah)
 				pr_warn("ignoring spike: %d %d %lx %lx %lx %lx\n",
 					dcd, sense,
 					tv.tv_sec, lasttv.tv_sec,
-					tv.tv_usec, lasttv.tv_usec);
+					(unsigned long)tv.tv_usec,
+					(unsigned long)lasttv.tv_usec);
 				continue;
 			}
 
@@ -719,7 +720,8 @@ static irqreturn_t irq_handler(int i, void *blah)
 				pr_warn("%d %d %lx %lx %lx %lx\n",
 					dcd, sense,
 					tv.tv_sec, lasttv.tv_sec,
-					tv.tv_usec, lasttv.tv_usec);
+					(unsigned long)tv.tv_usec,
+					(unsigned long)lasttv.tv_usec);
 				data = PULSE_MASK;
 			} else if (deltv > 15) {
 				data = PULSE_MASK; /* really long time */
@@ -728,7 +730,8 @@ static irqreturn_t irq_handler(int i, void *blah)
 					pr_warn("AIEEEE: %d %d %lx %lx %lx %lx\n",
 						dcd, sense,
 						tv.tv_sec, lasttv.tv_sec,
-						tv.tv_usec, lasttv.tv_usec);
+						(unsigned long)tv.tv_usec,
+						(unsigned long)lasttv.tv_usec);
 					/*
 					 * detecting pulse while this
 					 * MUST be a space!
-- 
1.8.3.1

