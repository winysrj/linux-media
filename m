Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.sissa.it ([147.122.11.135]:54966 "EHLO smtp.sissa.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbZAONL3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 08:11:29 -0500
Received: from ozzy.localnet (dhpc-2-04.sissa.it [147.122.2.184])
	by smtp.sissa.it (Postfix) with ESMTP id 9966D1B4804C
	for <linux-media@vger.kernel.org>; Thu, 15 Jan 2009 14:11:26 +0100 (CET)
From: Nicola Soranzo <nsoranzo@tiscali.it>
To: linux-media@vger.kernel.org
Subject: [PATCH] Fix em28xx compilation warnings
Date: Thu, 15 Jan 2009 14:11:34 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901151411.35128.nsoranzo@tiscali.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix em28xx compilation warnings.

From: Nicola Soranzo <nsoranzo@tiscali.it>

Inline ac97_return_record_select() function to fix compilation warnings like:

  CC [M]  /home/nicola/v4l-dvb-11a5eb383205/v4l/em28xx-audio.o
/home/nicola/v4l-dvb-11a5eb383205/v4l/em28xx.h:326: warning: 
'ac97_return_record_select' defined but not used
  CC [M]  /home/nicola/v4l-dvb-11a5eb383205/v4l/em28xx-video.o
/home/nicola/v4l-dvb-11a5eb383205/v4l/em28xx.h:326: warning: 
'ac97_return_record_select' defined but not used
...

introduced by changeset 10228.

Priority: normal

Signed-off-by: Nicola Soranzo <nsoranzo@tiscali.it>

diff -ur v4l-dvb-11a5eb383205/linux/drivers/media/video/em28xx/em28xx.h v4l-
dvb-new/linux/drivers/media/video/em28xx/em28xx.h
--- v4l-dvb-11a5eb383205/linux/drivers/media/video/em28xx/em28xx.h	2009-01-14 
08:58:36.000000000 +0100
+++ v4l-dvb-new/linux/drivers/media/video/em28xx/em28xx.h	2009-01-15 
12:54:11.000000000 +0100
@@ -322,7 +322,7 @@
 	EM28XX_AOUT_PCM_PHONE	= 7 << 8,
 };
 
-static int ac97_return_record_select(int a_out)
+static inline int ac97_return_record_select(int a_out)
 {
 	return (a_out & 0x700) >> 8;
 }

