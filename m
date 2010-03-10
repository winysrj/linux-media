Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65071 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab0CJK5V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Mar 2010 05:57:21 -0500
Date: Wed, 10 Mar 2010 13:57:03 +0300
From: Dan Carpenter <error27@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Trent Piepho <xyzzy@speakeasy.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	kernel-janitors@vger.kernel.org, sakari.ailus@nokia.com
Subject: [patch] omap24xxcam: potential buffer overflow
Message-ID: <20100310105703.GD6321@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The previous loop goes until last == VIDEO_MAX_FRAME, so this could 
potentially go one past the end of the loop.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
index 142c327..bedbee9 100644
--- a/drivers/media/video/omap24xxcam.c
+++ b/drivers/media/video/omap24xxcam.c
@@ -1404,7 +1404,7 @@ static int omap24xxcam_mmap_buffers(struct file *file,
 	}
 
 	size = 0;
-	for (i = first; i <= last; i++) {
+	for (i = first; i <= last && i < VIDEO_MAX_FRAME; i++) {
 		struct videobuf_dmabuf *dma = videobuf_to_dma(vbq->bufs[i]);
 
 		for (j = 0; j < dma->sglen; j++) {
