Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56311 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab0GWKJs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jul 2010 06:09:48 -0400
Date: Fri, 23 Jul 2010 12:09:20 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [patch -next] V4L: au0828: move dereference below sanity checks
Message-ID: <20100723100920.GC26313@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function has sanity checks to make sure that "dev" is non-null.  I
moved the dereference down below the checks.  In the current code "dev"
is never actually null.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index d97e0a2..7989a7b 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -441,7 +441,7 @@ static void au0828_copy_vbi(struct au0828_dev *dev,
 			      unsigned char *outp, unsigned long len)
 {
 	unsigned char *startwrite, *startread;
-	int bytesperline = dev->vbi_width;
+	int bytesperline;
 	int i, j = 0;
 
 	if (dev == NULL) {
@@ -464,6 +464,8 @@ static void au0828_copy_vbi(struct au0828_dev *dev,
 		return;
 	}
 
+	bytesperline = dev->vbi_width;
+
 	if (dma_q->pos + len > buf->vb.size)
 		len = buf->vb.size - dma_q->pos;
 
