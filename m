Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm4.bt.bullet.mail.ukl.yahoo.com ([217.146.183.202]:37896 "HELO
	nm4.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752566Ab1HTLOo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Aug 2011 07:14:44 -0400
Message-ID: <4E4F971F.5070902@yahoo.com>
Date: Sat, 20 Aug 2011 12:14:39 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: [PATCH 2/6] Fix memory leak on disconnect or error.
References: <4E4D5157.2080406@yahoo.com> <CAGoCfiwk4vy1V7T=Hdz1CsywgWVpWEis0eDoh2Aqju3LYqcHfA@mail.gmail.com> <CAGoCfiw4v-ZsUPmVgOhARwNqjCVK458EV79djD625Sf+8Oghag@mail.gmail.com> <4E4D8DFD.5060800@yahoo.com> <4E4DFA65.4090508@redhat.com>
In-Reply-To: <4E4DFA65.4090508@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------060602020005060702040206"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060602020005060702040206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Release the dev->alt_max_pkt_size buffer in all cases.

Signed-off-by: Chris Rankin <rankincj@yahoo.com>


--------------060602020005060702040206
Content-Type: text/x-patch;
 name="EM28xx-video-leak.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-video-leak.diff"

--- linux-3.0/drivers/media/video/em28xx/em28xx-video.c.orig	2011-08-18 17:20:10.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-video.c	2011-08-18 17:20:33.000000000 +0100
@@ -2202,6 +2202,7 @@
 		   free the remaining resources */
 		if (dev->state & DEV_DISCONNECTED) {
 			em28xx_release_resources(dev);
+			kfree(dev->alt_max_pkt_size);
 			kfree(dev);
 			return 0;
 		}
--- linux-3.0/drivers/media/video/em28xx/em28xx-cards.c.orig	2011-08-17 08:52:19.000000000 +0100
+++ linux-3.0/drivers/media/video/em28xx/em28xx-cards.c	2011-08-18 22:09:32.000000000 +0100
@@ -3128,6 +3128,7 @@
 	retval = em28xx_init_dev(&dev, udev, interface, nr);
 	if (retval) {
 		em28xx_devused &= ~(1<<dev->devno);
+		kfree(dev->alt_max_pkt_size);
 		mutex_unlock(&dev->lock);
 		kfree(dev);
 		goto err;

--------------060602020005060702040206--
