Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:56546 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab2I3LUK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Sep 2012 07:20:10 -0400
Received: from localhost (localhost [127.0.0.1])
	by rock.ko0l.a (Postfix) with ESMTP id 8DBEB4C41038
	for <linux-media@vger.kernel.org>; Sun, 30 Sep 2012 13:20:08 +0200 (CEST)
Received: from rock.ko0l.a ([127.0.0.1])
	by localhost (rock.ko0l.a [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ygg7jc4YdzM8 for <linux-media@vger.kernel.org>;
	Sun, 30 Sep 2012 13:20:06 +0200 (CEST)
Received: from [192.168.1.11] (x11.ko0l.a [192.168.1.11])
	by rock.ko0l.a (Postfix) with ESMTP id EA45C4C41037
	for <linux-media@vger.kernel.org>; Sun, 30 Sep 2012 13:20:05 +0200 (CEST)
Date: Sun, 30 Sep 2012 13:20:05 +0200
From: Andreas Kool <akool@akool.de>
To: linux-media@vger.kernel.org
Subject: bttv-i2c.c wrong printk() fix
Message-ID: <3731E90DC23C0BA24C9E88BF@x11>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

since i am using Linux 3.x my syslog gets flooded with tons of

[67819.884660] >
[67819.885062] >
[67819.885466] >
...

Please add these patch to v4l:

--- v4l-dvb/drivers/media/pci/bt8xx/bttv-i2c.c.orig	2012-09-30 
12:54:09.611095929 +0200
+++ v4l-dvb/drivers/media/pci/bt8xx/bttv-i2c.c	2012-09-30 
12:59:40.797318140 +0200
@@ -173,7 +173,7 @@
 		if (i2c_debug)
 			pr_cont(" %02x", msg->buf[cnt]);
 	}
-	if (!(xmit & BT878_I2C_NOSTOP))
+	if (i2c_debug && !(xmit & BT878_I2C_NOSTOP))
 		pr_cont(">\n");
 	return msg->len;

Thanks and
Ciao,
Andreas
-- 
Andreas Kool (Dont send mail to: ubecacher@akool.de)
Transmission of this message via the Microsoft Network is prohibited

"Das Wort WINDOWS stammt aus einem alten Sioux-Dialekt und bedeutet:
 Weisser Mann starrt durch Glasscheibe auf Sanduhr." (anonym)
