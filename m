Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:45561 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaGGXeZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jul 2014 19:34:25 -0400
Received: from uscpsbgex4.samsung.com
 (u125.gpu85.samsung.co.kr [203.254.195.125]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N8D00E1O85C8380@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Mon, 07 Jul 2014 19:34:24 -0400 (EDT)
Message-id: <53BB2E7D.30300@samsung.com>
Date: Mon, 07 Jul 2014 17:34:21 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
MIME-version: 1.0
To: "Mauro Carvalho Chehab (m.chehab@samsung.com)" <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	crope@iki.fi
Cc: Shuah Khan <shuah.kh@samsung.com>
Subject: fix PCTV 461e tuner I2C binding
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro/Antti,

I have been looking at the following commit to

drivers/media/usb/em28xx/em28xx-dvb.c

a83b93a7480441a47856dc9104bea970e84cda87

+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1630,6 +1630,7 @@ static int em28xx_dvb_resume(struct em28xx *dev)
         em28xx_info("Resuming DVB extension");
         if (dev->dvb) {
                 struct em28xx_dvb *dvb = dev->dvb;
+               struct i2c_client *client = dvb->i2c_client_tuner;

                 if (dvb->fe[0]) {
                         ret = dvb_frontend_resume(dvb->fe[0]);
@@ -1640,6 +1641,15 @@ static int em28xx_dvb_resume(struct em28xx *dev)
                         ret = dvb_frontend_resume(dvb->fe[1]);
                         em28xx_info("fe1 resume %d", ret);
                 }
+               /* remove I2C tuner */
+               if (client) {
+                       module_put(client->dev.driver->owner);
+                       i2c_unregister_device(client);
+               }
+
+               em28xx_unregister_dvb(dvb);
+               kfree(dvb);
+               dev->dvb = NULL;
         }

Why are we unregistering i2c devices and dvb in this resume path?
Looks incorrect to me.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
