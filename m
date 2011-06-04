Return-path: <mchehab@pedra>
Received: from mail.juropnet.hu ([212.24.188.131]:55729 "EHLO mail.juropnet.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756694Ab1FDOsZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Jun 2011 10:48:25 -0400
Received: from [94.248.226.52]
	by mail.juropnet.hu with esmtps (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <istvan_v@mailbox.hu>)
	id 1QSs9B-0001uy-Hv
	for linux-media@vger.kernel.org; Sat, 04 Jun 2011 16:48:22 +0200
Message-ID: <4DEA45B0.6090007@mailbox.hu>
Date: Sat, 04 Jun 2011 16:48:16 +0200
From: "istvan_v@mailbox.hu" <istvan_v@mailbox.hu>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: XC4000: added firmware_name parameter
References: <4D764337.6050109@email.cz>	<20110531124843.377a2a80@glory.local>	<BANLkTi=Lq+FF++yGhRmOa4NCigSt6ZurHg@mail.gmail.com>	<20110531174323.0f0c45c0@glory.local> <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
In-Reply-To: <BANLkTimEEGsMP6PDXf5W5p9wW7wdWEEOiA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050109080500020406040308"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------050109080500020406040308
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

The firmware_name module parameter makes it possible to set the firmware
file name. It defaults to "xc4000.fw" if not specified.

Signed-off-by: Istvan Varga <istvan_v@mailbox.hu>


--------------050109080500020406040308
Content-Type: text/x-patch;
 name="xc4000_fwname.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="xc4000_fwname.patch"

diff -uNr xc4000_orig/drivers/media/common/tuners/xc4000.c xc4000/drivers/media/common/tuners/xc4000.c
--- xc4000_orig/drivers/media/common/tuners/xc4000.c	2011-06-03 17:14:59.000000000 +0200
+++ xc4000/drivers/media/common/tuners/xc4000.c	2011-06-04 12:29:31.000000000 +0200
@@ -47,16 +47,20 @@
 	"\t\t1 keep device energized and with tuner ready all the times.\n"
 	"\t\tFaster, but consumes more power and keeps the device hotter");
 
+#define XC4000_DEFAULT_FIRMWARE "xc4000.fw"
+
+static char firmware_name[30];
+module_param_string(firmware_name, firmware_name, sizeof(firmware_name), 0);
+MODULE_PARM_DESC(firmware_name, "\n\t\tFirmware file name. Allows overriding "
+	"the default firmware\n"
+	"\t\tname.");
+
 static DEFINE_MUTEX(xc4000_list_mutex);
 static LIST_HEAD(hybrid_tuner_instance_list);
 
 #define dprintk(level, fmt, arg...) if (debug >= level) \
 	printk(KERN_INFO "%s: " fmt, "xc4000", ## arg)
 
-/* Note that the last version digit is my internal build number (so I can
-   rev the firmware even if the core Xceive firmware was unchanged) */
-#define XC4000_DEFAULT_FIRMWARE "dvb-fe-xc4000-1.4.1.fw"
-
 /* struct for storing firmware table */
 struct firmware_description {
 	unsigned int  type;
@@ -714,7 +718,10 @@
 	char		      name[33];
 	const char	      *fname;
 
-	fname = XC4000_DEFAULT_FIRMWARE;
+	if (firmware_name[0] != '\0')
+		fname = firmware_name;
+	else
+		fname = XC4000_DEFAULT_FIRMWARE;
 
 	printk("Reading firmware %s\n",  fname);
 	rc = request_firmware(&fw, fname, priv->i2c_props.adap->dev.parent);

--------------050109080500020406040308--
