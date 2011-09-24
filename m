Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm3.bt.bullet.mail.ird.yahoo.com ([212.82.108.234]:35021 "HELO
	nm3.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751596Ab1IXPAe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 11:00:34 -0400
Message-ID: <4E7DF08C.70207@yahoo.com>
Date: Sat, 24 Sep 2011 16:00:28 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: [PATCH 1/2] use atomic bit operations for devices-in-use mask
Content-Type: multipart/mixed;
 boundary="------------010000090709020900070405"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010000090709020900070405
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

This line was probably missed in the merge.

Signed-off-by: Chris Rankin <rankincj@yahoo.com>

--------------010000090709020900070405
Content-Type: text/x-patch;
 name="EM28xx-more-devunused-bits.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="EM28xx-more-devunused-bits.diff"

--- linux/drivers/media/video/em28xx/em28xx-cards.c.orig.0	2011-09-24 15:30:02.000000000 +0100
+++ linux/drivers/media/video/em28xx/em28xx-cards.c	2011-09-24 15:19:28.000000000 +0100
@@ -3114,7 +3114,6 @@
 				em28xx_err(DRIVER_NAME " This is an anciliary "
 					"interface not used by the driver\n");
 
-				em28xx_devused &= ~(1<<nr);
 				retval = -ENODEV;
 				goto err;
 			}

--------------010000090709020900070405--
