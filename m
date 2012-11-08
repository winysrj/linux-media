Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33191 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702Ab2KHTML (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Nov 2012 14:12:11 -0500
Received: by mail-ea0-f174.google.com with SMTP id c13so1190326eaa.19
        for <linux-media@vger.kernel.org>; Thu, 08 Nov 2012 11:12:10 -0800 (PST)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH v2 01/21] em28xx: fix wrong data offset for non-interlaced mode in em28xx_copy_video
Date: Thu,  8 Nov 2012 20:11:33 +0200
Message-Id: <1352398313-3698-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1352398313-3698-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

em28xx_copy_video uses a wrong offset for the target buffer
when copying the data from an USB isoc packet. This happens
only for the second and all following lines in the packet.

The reason why this bug doesn't cause image corruption with
my test device (SilverCrest Webcam 1.3 MPix) is, that this
device never sends any packets that cross the end of a line.
I don't know if all devices behave like this, so this patch
should be considered for stable.

With the upcoming patches to add support for USB bulk transfers,
em28xx_copy_video will be called once per URB, which will
always trigger this bug.

Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   16 +++++++---------
 1 Datei geändert, 7 Zeilen hinzugefügt(+), 9 Zeilen entfernt(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 1e553d3..7c88a40 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -207,15 +207,10 @@ static void em28xx_copy_video(struct em28xx *dev,
 	startread = p;
 	remain = len;
 
-	if (dev->progressive)
+	if (dev->progressive || buf->top_field)
 		fieldstart = outp;
-	else {
-		/* Interlaces two half frames */
-		if (buf->top_field)
-			fieldstart = outp;
-		else
-			fieldstart = outp + bytesperline;
-	}
+	else /* interlaced mode, even nr. of lines */
+		fieldstart = outp + bytesperline;
 
 	linesdone = dma_q->pos / bytesperline;
 	currlinedone = dma_q->pos % bytesperline;
@@ -243,7 +238,10 @@ static void em28xx_copy_video(struct em28xx *dev,
 	remain -= lencopy;
 
 	while (remain > 0) {
-		startwrite += lencopy + bytesperline;
+		if (dev->progressive)
+			startwrite += lencopy;
+		else
+			startwrite += lencopy + bytesperline;
 		startread += lencopy;
 		if (bytesperline > remain)
 			lencopy = remain;
-- 
1.7.10.4

