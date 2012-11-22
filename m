Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:38616 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab2KVS3H (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 13:29:07 -0500
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout1.freenet.de with esmtpa (ID buzz768@freenet.de) (port 25) (Exim 4.76 #1)
	id 1TbUzK-0000Lf-OZ
	for linux-media@vger.kernel.org; Thu, 22 Nov 2012 12:30:34 +0100
Received: from localhost ([::1]:50773 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID buzz768@freenet.de) (Exim 4.76 #1)
	id 1TbUzK-0007PI-Jp
	for linux-media@vger.kernel.org; Thu, 22 Nov 2012 12:30:34 +0100
Received: from [195.4.92.19] (port=38159 helo=9.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID buzz768@freenet.de) (Exim 4.76 #1)
	id 1TbUxA-0006TS-Hm
	for linux-media@vger.kernel.org; Thu, 22 Nov 2012 12:28:20 +0100
Received: from p54902e9d.dip.t-dialin.net ([84.144.46.157]:52045 helo=localhost.localdomain)
	by 9.mx.freenet.de with esmtpsa (ID buzz768@freenet.de) (SSLv3:AES128-SHA:128) (port 465) (Exim 4.76 #1)
	id 1TbUx9-00019V-Mg
	for linux-media@vger.kernel.org; Thu, 22 Nov 2012 12:28:20 +0100
Date: Thu, 22 Nov 2012 12:26:31 +0100
From: Olaf Bauer <olafbauer@freenet.de>
To: linux-media@vger.kernel.org
Subject: [PATCH] bttv: Filter debugging messages
Message-ID: <20121122122631.78340fc7@freenet.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/9dQvyyZ93XXqz.c3t9Iv0R4"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--MP_/9dQvyyZ93XXqz.c3t9Iv0R4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

My logfiles and dmesg output have become almost unreadable due to
repeated, almost empty lines.

[ 3606.212316] >
[ 3606.212738] >
...
[ 3627.177280] >
[ 3627.177775] >
...

They start one hour after vdr daemon is launched. Each section contains
13 lines and is repeated every 21 seconds. Kernel driver for my
AverMedia DVB-T 771 is bttv, kernel is 3.6.6-1-ARCH (Arch Linux). I
installed v4l-dvb from git and get the same result but with one line
appended to each section

[ 3688.860166] >
[ 3688.860570] >
[ 3691.188200] dvb_frontend_poll: 8 callbacks suppressed

The attached patch suppresses at least the useless ">" output.


--MP_/9dQvyyZ93XXqz.c3t9Iv0R4
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=bttv-i2c.patch

diff -ur a/drivers/media/pci/bt8xx/bttv-i2c.c b/drivers/media/pci/bt8xx/bttv-i2c.c
--- a/drivers/media/pci/bt8xx/bttv-i2c.c	2012-11-22 09:56:25.817307254 +0100
+++ b/drivers/media/pci/bt8xx/bttv-i2c.c	2012-11-22 10:01:46.014371997 +0100
@@ -174,7 +174,7 @@
 		if (i2c_debug)
 			pr_cont(" %02x", msg->buf[cnt]);
 	}
-	if (!(xmit & BT878_I2C_NOSTOP))
+	if (i2c_debug && !(xmit & BT878_I2C_NOSTOP))
 		pr_cont(">\n");
 	return msg->len;
 

--MP_/9dQvyyZ93XXqz.c3t9Iv0R4--
