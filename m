Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:57966 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbaK3XrO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Nov 2014 18:47:14 -0500
Received: from [192.168.1.22] (92-244-23-216.customers.ownit.se [92.244.23.216])
	(Authenticated sender: ed8153)
	by smtp.bredband2.com (Postfix) with ESMTPA id 3D8672D07B
	for <linux-media@vger.kernel.org>; Mon,  1 Dec 2014 00:47:06 +0100 (CET)
Message-ID: <547BAC79.50702@southpole.se>
Date: Mon, 01 Dec 2014 00:47:05 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Random memory corruption of fe[1]->dvb pointer
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While working on a driver I noticed that I had trouble unloading the 
module after testing, it crashed while running
dvb_usbv2_adapter_frontend_exit. So I added a print out of some pointers 
and got this:

Init:
usb 1-1: dvb_usbv2_adapter_frontend_init: adap=fe[0] ffff88006afa6818
usb 1-1: dvb_usbv2_adapter_frontend_init: adap=fe[0]->dvb ffff880078cba580
usb 1-1: dvb_usbv2_adapter_frontend_init: adap=fe[1] ffff88003698e830
usb 1-1: dvb_usbv2_adapter_frontend_init: adap=fe[1]->dvb ffff880078cba580

ok looking 64bit pointers

Deinit:
usb 1-1: dvb_usbv2_exit:
usb 1-1: dvb_usbv2_remote_exit:
usb 1-1: dvb_usbv2_adapter_exit:
usb 1-1: dvb_usbv2_adapter_exit: fe0[0]= ffff88006afa6818
usb 1-1: dvb_usbv2_adapter_exit: fe0[0]->dvb= ffff880078cba580
usb 1-1: dvb_usbv2_adapter_exit: fe1[0]= ffff88003698e830
usb 1-1: dvb_usbv2_adapter_exit: fe1[0]->dvb= 003a746165733a3d
usb 1-1: dvb_usbv2_adapter_frontend_exit: adap=0
usb 1-1: dvb_usbv2_adapter_frontend_exit: fe[1]= ffff88003698e830
usb 1-1: dvb_usbv2_adapter_frontend_exit: fe[1]->dvb= 003a746165733a3d

Later on in dvb_usbv2_adapter_frontend_exit() fe[1]->dvb is dereferenced 
and thus causes a kernel crash.

So for some reason fe[1]->dvb gets corrupted. It doesn't happen all the 
time but after max 3 times I get this crash. I have reproduced this on 
my main machine running Ubuntu 14.04, 14.10 and a VM running Ubuntu 
14.04 all running stock kernel (3.13 and 3.16) and the media_build back 
port code.

After some investigation I saw that fe[1]->demodulator_priv also gets 
corrupted. Something is overwriting the pointers.

So with that knowledge I wrote the following patch and now I can freely 
reload the driver without a crash. This of course doesn't fix the issue 
but just corrupts unused dummy memory.

So does anyone have any hunch on what might be causing this issue or how 
to track it down ?
Keep in mind that this could be caused by me running the media_build 
code or some bug in the driver. Or it could also affect the regular tree 
when unplugging devices with more then 1 frontend.

MvH
Benjamin Larsson


diff --git a/drivers/media/dvb-core/dvb_frontend.h 
b/drivers/media/dvb-core/dvb_frontend.h
index 816269e..e0ba434 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -413,19 +413,30 @@ struct dtv_frontend_properties {
  #define DVB_FE_DEVICE_RESUME    3

  struct dvb_frontend {
-       struct dvb_frontend_ops ops;
-       struct dvb_adapter *dvb;
         void *demodulator_priv;
+       int dummy1[16000];
         void *tuner_priv;
+       int dummy2[16000];
         void *frontend_priv;
+       int dummy3[16000];
         void *sec_priv;
+       int dummy4[16000];
         void *analog_demod_priv;
+       int dummy5[16000];
         struct dtv_frontend_properties dtv_property_cache;
+       int dummy6[16000];
  #define DVB_FRONTEND_COMPONENT_TUNER 0
  #define DVB_FRONTEND_COMPONENT_DEMOD 1
         int (*callback)(void *adapter_priv, int component, int cmd, int 
arg);
+       int dummy7[16000];
         int id;
+       int dummy8[16000];
         unsigned int exit;
+       int dummy9[16000];
+       struct dvb_frontend_ops ops;
+       int dummy10[16000];
+       struct dvb_adapter *dvb;
+       int dummy11[16000];
  };

