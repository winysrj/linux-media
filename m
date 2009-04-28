Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:28783 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbZD1XqJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Apr 2009 19:46:09 -0400
Received: by ey-out-2122.google.com with SMTP id 9so233745eyd.37
        for <linux-media@vger.kernel.org>; Tue, 28 Apr 2009 16:46:06 -0700 (PDT)
Date: Tue, 28 Apr 2009 19:46:15 +1000
From: Dmitri Belimov <d.belimov@gmail.com>
To: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: [PATCH 2/3 ] remove hw reset of MPEG encoder when lost/found seq.
Message-ID: <20090428194615.64a302c2@glory.loctelecom.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/pT=iAlJBSK1/JK8owBeVuVK"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/pT=iAlJBSK1/JK8owBeVuVK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi All

When we capture signal from composite input offen lost and found syncro sequence.
In this case the MPEG coder hardware reset after each lost/found event. The image has
a lot of artefactes. This patch remove hardware reset of MPEG encoder.

This is patch from our customer. I checked this.

diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134-empress.c
--- a/linux/drivers/media/video/saa7134/saa7134-empress.c	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-empress.c	Tue Apr 28 05:26:09 2009 +1000
@@ -499,11 +499,8 @@
 
 	if (dev->nosignal) {
 		dprintk("no video signal\n");
-		ts_reset_encoder(dev);
 	} else {
 		dprintk("video signal acquired\n");
-		if (atomic_read(&dev->empress_users))
-			ts_init_encoder(dev);
 	}
 }
 

Signed-off-by: Alexey Osipov <lion-simba@pridelands.ru>


With my best regards, Dmitry.
--MP_/pT=iAlJBSK1/JK8owBeVuVK
Content-Type: text/x-patch; name=empress_lost_singal_fix.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=empress_lost_singal_fix.patch

diff -r b40d628f830d linux/drivers/media/video/saa7134/saa7134-empress.c
--- a/linux/drivers/media/video/saa7134/saa7134-empress.c	Fri Apr 24 01:46:41 2009 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-empress.c	Tue Apr 28 05:26:09 2009 +1000
@@ -499,11 +499,8 @@
 
 	if (dev->nosignal) {
 		dprintk("no video signal\n");
-		ts_reset_encoder(dev);
 	} else {
 		dprintk("video signal acquired\n");
-		if (atomic_read(&dev->empress_users))
-			ts_init_encoder(dev);
 	}
 }
 

Signed-off-by: Alexey Osipov <lion-simba@pridelands.ru>

--MP_/pT=iAlJBSK1/JK8owBeVuVK--
