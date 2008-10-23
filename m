Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vds2011.yellis.net ([79.170.233.11])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <frederic.cand@anevia.com>) id 1KsxdH-00082u-JB
	for linux-dvb@linuxtv.org; Thu, 23 Oct 2008 12:41:38 +0200
Received: from goliath.anevia.com (cac94-10-88-170-236-224.fbx.proxad.net
	[88.170.236.224])
	by vds2011.yellis.net (Postfix) with ESMTP id E31DB2FA899
	for <linux-dvb@linuxtv.org>; Thu, 23 Oct 2008 12:41:34 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by goliath.anevia.com (Postfix) with ESMTP id 91410130028E
	for <linux-dvb@linuxtv.org>; Thu, 23 Oct 2008 12:41:30 +0200 (CEST)
Received: from goliath.anevia.com ([127.0.0.1])
	by localhost (goliath.anevia.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SjaMeQ1FG33E for <linux-dvb@linuxtv.org>;
	Thu, 23 Oct 2008 12:41:22 +0200 (CEST)
Received: from [10.0.1.25] (fcand.anevia.com [10.0.1.25])
	by goliath.anevia.com (Postfix) with ESMTP id 503A6130028A
	for <linux-dvb@linuxtv.org>; Thu, 23 Oct 2008 12:41:22 +0200 (CEST)
Message-ID: <490054D1.8090103@anevia.com>
Date: Thu, 23 Oct 2008 12:41:21 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Content-Type: multipart/mixed; boundary="------------060400080904000700060107"
Subject: [linux-dvb] [GSPCA] kconfig patch
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
--------------060400080904000700060107
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Dear all,

I'm proposing this patch, because I wanted to compile latest snapshot 
for a 2.6.22 while running a 2.6.16, and v4l/scripts/make_kconfig.pl 
adds (wrongly) a warning with two spaces after the tab in the 
v4l/Kconfig file regarding my two old kernel version (it takes the 
2.6.16 into account instead of the 2.6.22); in the gspca Kconfig file, 
there are not these two spaces after the tab, making my 2.6.22 
scripts/kconfig/mconf die badly, seeing first words after the tab as 
options ...


-- 
CAND Frederic
Product Manager
ANEVIA

--------------060400080904000700060107
Content-Type: text/plain;
 name="gspca_kconfig.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gspca_kconfig.patch"

--- a/linux/drivers/media/video/gspca/Kconfig	2008-10-23 12:23:57.000000000 +0200
+++ b/linux/drivers/media/video/gspca/Kconfig	2008-10-23 12:27:07.000000000 +0200
@@ -3,16 +3,16 @@ menuconfig USB_GSPCA
 	depends on VIDEO_V4L2
 	default m
 	---help---
-	Say Y here if you want to enable selecting webcams based
-	on the GSPCA framework.
+	  Say Y here if you want to enable selecting webcams based
+	  on the GSPCA framework.
 
-	See <file:Documentation/video4linux/gspca.txt> for more info.
+	  See <file:Documentation/video4linux/gspca.txt> for more info.
 
-	This driver uses the Video For Linux API. You must say Y or M to
-	"Video For Linux" to use this driver.
+	  This driver uses the Video For Linux API. You must say Y or M to
+	  "Video For Linux" to use this driver.
 
-	To compile this driver as modules, choose M here: the
-	modules will be called gspca_main.
+	  To compile this driver as modules, choose M here: the
+	  modules will be called gspca_main.
 
 
 if USB_GSPCA && VIDEO_V4L2
@@ -23,190 +23,190 @@ config USB_GSPCA_CONEX
 	tristate "Conexant Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the Conexant chip.
+	  Say Y here if you want support for cameras based on the Conexant chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_conex.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_conex.
 
 config USB_GSPCA_ETOMS
 	tristate "Etoms USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the Etoms chip.
+	  Say Y here if you want support for cameras based on the Etoms chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_etoms.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_etoms.
 
 config USB_GSPCA_FINEPIX
 	tristate "Fujifilm FinePix USB V4L2 driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the FinePix chip.
+	  Say Y here if you want support for cameras based on the FinePix chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_finepix.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_finepix.
 
 config USB_GSPCA_MARS
 	tristate "Mars USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the Mars chip.
+	  Say Y here if you want support for cameras based on the Mars chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_mars.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_mars.
 
 config USB_GSPCA_OV519
 	tristate "OV519 USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the OV519 chip.
+	  Say Y here if you want support for cameras based on the OV519 chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_ov519.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_ov519.
 
 config USB_GSPCA_PAC207
 	tristate "Pixart PAC207 USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the PAC207 chip.
+	  Say Y here if you want support for cameras based on the PAC207 chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_pac207.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_pac207.
 
 config USB_GSPCA_PAC7311
 	tristate "Pixart PAC7311 USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the PAC7311 chip.
+	  Say Y here if you want support for cameras based on the PAC7311 chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_pac7311.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_pac7311.
 
 config USB_GSPCA_SONIXB
 	tristate "SN9C102 USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the SONIXB chip.
+	  Say Y here if you want support for cameras based on the SONIXB chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_sonixb.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_sonixb.
 
 config USB_GSPCA_SONIXJ
 	tristate "SONIX JPEG USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the SONIXJ chip.
+	  Say Y here if you want support for cameras based on the SONIXJ chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_sonixj
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_sonixj
 
 config USB_GSPCA_SPCA500
 	tristate "SPCA500 USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the SPCA500 chip.
+	  Say Y here if you want support for cameras based on the SPCA500 chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_spca500.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_spca500.
 
 config USB_GSPCA_SPCA501
 	tristate "SPCA501 USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the SPCA501 chip.
+	  Say Y here if you want support for cameras based on the SPCA501 chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_spca501.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_spca501.
 
 config USB_GSPCA_SPCA505
 	tristate "SPCA505 USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the SPCA505 chip.
+	  Say Y here if you want support for cameras based on the SPCA505 chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_spca505.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_spca505.
 
 config USB_GSPCA_SPCA506
 	tristate "SPCA506 USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the SPCA506 chip.
+	  Say Y here if you want support for cameras based on the SPCA506 chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_spca506.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_spca506.
 
 config USB_GSPCA_SPCA508
 	tristate "SPCA508 USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the SPCA508 chip.
+	  Say Y here if you want support for cameras based on the SPCA508 chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_spca508.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_spca508.
 
 config USB_GSPCA_SPCA561
 	tristate "SPCA561 USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the SPCA561 chip.
+	  Say Y here if you want support for cameras based on the SPCA561 chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_spca561.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_spca561.
 
 config USB_GSPCA_STK014
 	tristate "Syntek DV4000 (STK014) USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the STK014 chip.
+	  Say Y here if you want support for cameras based on the STK014 chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_stk014.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_stk014.
 
 config USB_GSPCA_SUNPLUS
 	tristate "SUNPLUS USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the Sunplus
-	SPCA504(abc) SPCA533 SPCA536 chips.
+	  Say Y here if you want support for cameras based on the Sunplus
+	  SPCA504(abc) SPCA533 SPCA536 chips.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_spca5xx.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_spca5xx.
 
 config USB_GSPCA_T613
 	tristate "T613 (JPEG Compliance) USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the T613 chip.
+	  Say Y here if you want support for cameras based on the T613 chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_t613.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_t613.
 
 config USB_GSPCA_TV8532
 	tristate "TV8532 USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the TV8531 chip.
+	  Say Y here if you want support for cameras based on the TV8531 chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_tv8532.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_tv8532.
 
 config USB_GSPCA_VC032X
 	tristate "VC032X USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the VC032X chip.
+	  Say Y here if you want support for cameras based on the VC032X chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_vc032x.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_vc032x.
 
 config USB_GSPCA_ZC3XX
 	tristate "VC3xx USB Camera Driver"
 	depends on VIDEO_V4L2 && USB_GSPCA
 	help
-	Say Y here if you want support for cameras based on the ZC3XX chip.
+	  Say Y here if you want support for cameras based on the ZC3XX chip.
 
-	To compile this driver as a module, choose M here: the
-	module will be called gspca_zc3xx.
+	  To compile this driver as a module, choose M here: the
+	  module will be called gspca_zc3xx.
 
 endif

--------------060400080904000700060107
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------060400080904000700060107--
