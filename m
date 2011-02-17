Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65196 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1BQWLd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Feb 2011 17:11:33 -0500
Received: by fxm20 with SMTP id 20so3111973fxm.19
        for <linux-media@vger.kernel.org>; Thu, 17 Feb 2011 14:11:32 -0800 (PST)
Message-ID: <4D5D9D10.2060709@gmail.com>
Date: Thu, 17 Feb 2011 23:11:28 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
	andrew.williams@joratech.com, lindsay.mathieson@gmail.com,
	skandalfo@gmail.com, news004@upsilon.org.uk
Subject: Re: Afatech AF9015 & dual tuner - dual_mode B.R.O.K.E.N.
References: <4D5B5FE2.5000302@gmail.com> <4D5CE929.4050102@gmail.com>
In-Reply-To: <4D5CE929.4050102@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------040504060607060302010405"
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multi-part message in MIME format.
--------------040504060607060302010405
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

poma wrote:
> poma wrote:
>> To num_adapters = 2, or num_adapters = 1: that is the question!
> 
> In dual tuner mode, after a while device become unrensponsive,
> eventually after S5 aka 'Soft Off' system doesn't even boot!
> Didn't even mention all sorts of 'mumbo-jumbo' with S3 aka 'Suspend to 
> RAM'.
> Antti, please consider adding 'dual_mode' parameter back.
> 
> "dvb_usb_af9015 dual_mode=0"
> 
> Devices to consider:
> 
> Not Only TV/LifeView DUAL DVB-T USB LV52T
> (equivalent to TerraTec Cinergy T Stick Dual RC)
> Afatech AF9013/AF9015 & 2x MaxLinear MxL5007T
> http://www.notonlytv.net/p_lv52t.html
> 
> KWorld USB Dual DVB-T TV Stick (DVB-T 399U)
> Afatech AF9013/AF9015 & 2x MaxLinear MxL5003S
> http://www.kworld-global.com/main/prod_in.aspx?mnuid=1248&modid=6&prodid=73
> 
> DigitalNow TinyTwin DVB-T Receiver
> Afatech AF9013/AF9015 & 2x MaxLinear MxL5005S
> http://www.digitalnow.com.au/product_pages/TinyTwin.html
> 
> http://www.spinics.net/lists/linux-dvb/msg31616.html
> http://www.spinics.net/lists/linux-dvb/msg31621.html

This patch restore dvb_usb_af9015 'dual mode' parameter - "disable dual 
mode by default because it is buggy".
Enabled mode:
options dvb_usb_af9015 dual_mode=1
in modprobe referent file.

..
--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	2011-01-10 
16:24:45.000000000 +0100
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	2011-02-17 
21:58:42.099040739 +0100
@@ -40,6 +40,9 @@
  static int dvb_usb_af9015_remote;
  module_param_named(remote, dvb_usb_af9015_remote, int, 0644);
  MODULE_PARM_DESC(remote, "select remote");
+static int dvb_usb_af9015_dual_mode;
+module_param_named(dual_mode, dvb_usb_af9015_dual_mode, int, 0644);
+MODULE_PARM_DESC(dual_mode, "enable dual mode");
  DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);

  static DEFINE_MUTEX(af9015_usb_mutex);
@@ -841,6 +844,9 @@
  		goto error;
  	af9015_config.dual_mode = val;
  	deb_info("%s: TS mode:%d\n", __func__, af9015_config.dual_mode);
+	/* disable dual mode by default because it is buggy */
+	if (!dvb_usb_af9015_dual_mode)
+		af9015_config.dual_mode = 0;

  	/* Set adapter0 buffer size according to USB port speed, adapter1 buffer
  	   size can be static because it is enabled only USB2.0 */
..

rgds,
poma


--------------040504060607060302010405
Content-Type: text/x-patch;
 name="af9015.c_param-dual_mode.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="af9015.c_param-dual_mode.patch"

--- a/linux/drivers/media/dvb/dvb-usb/af9015.c	2011-01-10 16:24:45.000000000 +0100
+++ b/linux/drivers/media/dvb/dvb-usb/af9015.c	2011-02-17 21:58:42.099040739 +0100
@@ -40,6 +40,9 @@
 static int dvb_usb_af9015_remote;
 module_param_named(remote, dvb_usb_af9015_remote, int, 0644);
 MODULE_PARM_DESC(remote, "select remote");
+static int dvb_usb_af9015_dual_mode;
+module_param_named(dual_mode, dvb_usb_af9015_dual_mode, int, 0644);
+MODULE_PARM_DESC(dual_mode, "enable dual mode");
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
 static DEFINE_MUTEX(af9015_usb_mutex);
@@ -841,6 +844,9 @@
 		goto error;
 	af9015_config.dual_mode = val;
 	deb_info("%s: TS mode:%d\n", __func__, af9015_config.dual_mode);
+	/* disable dual mode by default because it is buggy */
+	if (!dvb_usb_af9015_dual_mode)
+		af9015_config.dual_mode = 0;
 
 	/* Set adapter0 buffer size according to USB port speed, adapter1 buffer
 	   size can be static because it is enabled only USB2.0 */

--------------040504060607060302010405--
