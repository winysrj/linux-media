Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.185])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jan.paesmans@gmail.com>) id 1Jo1Ya-00071V-W6
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 21:20:07 +0200
Received: by fk-out-0910.google.com with SMTP id z22so2806019fkz.1
	for <linux-dvb@linuxtv.org>; Mon, 21 Apr 2008 12:19:50 -0700 (PDT)
Message-ID: <480CE8D3.6080000@gmail.com>
Date: Mon, 21 Apr 2008 21:19:47 +0200
From: Jan Paesmans <jan.paesmans@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------060505070206050401000300"
Subject: [linux-dvb] compile error fix
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------060505070206050401000300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I fixed a compile problem I got in mchehab's tree for the tm6010.
Also added check on the return value of dvb_register_adapter.

Regards,

Jan

--------------060505070206050401000300
Content-Type: text/x-patch;
 name="tm6010_compile_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tm6010_compile_fix.patch"

diff --git a/linux/drivers/media/video/tm6000/tm6000-dvb.c b/linux/drivers/media/video/tm6000/tm6000-dvb.c
--- a/linux/drivers/media/video/tm6000/tm6000-dvb.c
+++ b/linux/drivers/media/video/tm6000/tm6000-dvb.c
@@ -229,7 +229,13 @@ int tm6000_dvb_register(struct tm6000_co
 	}
 
 	ret = dvb_register_adapter(&dvb->adapter, "Trident TVMaster 6000 DVB-T",
-							  THIS_MODULE, &dev->udev->dev);
+							  THIS_MODULE, &dev->udev->dev, -1);
+	if (ret < 0) {
+		printk(KERN_ERR
+			"tm6000: couldn't register adapter\n");
+		goto adapter_err;
+	}
+
 	dvb->adapter.priv = dev;
 
 	if (dvb->frontend) {

--------------060505070206050401000300
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------060505070206050401000300--
