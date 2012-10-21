Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:58116 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932353Ab2JURw5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Oct 2012 13:52:57 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so1066703wey.19
        for <linux-media@vger.kernel.org>; Sun, 21 Oct 2012 10:52:56 -0700 (PDT)
From: =?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
To: mchehab@redhat.com
Cc: linux-media@vger.kernel.org,
	=?UTF-8?q?Frank=20Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: [PATCH 01/23] em28xx: fix wrong data offset for non-interlaced mode in em28xx_copy_video
Date: Sun, 21 Oct 2012 19:52:06 +0300
Message-Id: <1350838349-14763-2-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
References: <1350838349-14763-1-git-send-email-fschaefer.oss@googlemail.com>
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

