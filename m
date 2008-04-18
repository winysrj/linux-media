Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.158])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jan.paesmans@gmail.com>) id 1JmuXW-0001l6-1g
	for linux-dvb@linuxtv.org; Fri, 18 Apr 2008 19:38:25 +0200
Received: by fg-out-1718.google.com with SMTP id 22so489560fge.25
	for <linux-dvb@linuxtv.org>; Fri, 18 Apr 2008 10:38:15 -0700 (PDT)
Message-ID: <4808DC83.1050205@gmail.com>
Date: Fri, 18 Apr 2008 19:38:11 +0200
From: Jan Paesmans <jan.paesmans@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Content-Type: multipart/mixed; boundary="------------020208030008020200090800"
Subject: [linux-dvb] fix tm6010 compile error
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
--------------020208030008020200090800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

Seems there is a problem compiling mchehab's tree of tm6010 against 
linux kernel 2.6.24.3
It appears to be an argument missing in dvb_register_adapter. Added -1 
as the requested number and added error checking code.
Just a quick and dirty fix, but now at least it compiles.

Regards,

Jan

--------------020208030008020200090800
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

--------------020208030008020200090800
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------020208030008020200090800--
