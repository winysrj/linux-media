Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.bredband2.com ([83.219.192.166]:47818 "EHLO
	smtp.bredband2.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbaLAXaH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Dec 2014 18:30:07 -0500
Message-ID: <547CF9FC.5010101@southpole.se>
Date: Tue, 02 Dec 2014 00:30:04 +0100
From: Benjamin Larsson <benjamin@southpole.se>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>
Subject: Re: Random memory corruption of fe[1]->dvb pointer
References: <547BAC79.50702@southpole.se>
In-Reply-To: <547BAC79.50702@southpole.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think I have found the issue for this error and it looks like a use 
after free that affects multiple drivers. The effect is that the driver 
crashes on unload.

I added the following code to the mn88472 driver, it should behave as a nop:

diff --git a/drivers/staging/media/mn88472/mn88472.c 
b/drivers/staging/media/mn88472/mn88472.c
index 52de8f8..58af319 100644
--- a/drivers/staging/media/mn88472/mn88472.c
+++ b/drivers/staging/media/mn88472/mn88472.c
@@ -494,6 +494,7 @@ static int mn88472_remove(struct i2c_client *client)

         regmap_exit(dev->regmap[0]);

+       memset(dev, 0, sizeof(*dev));
         kfree(dev);


When I now unload the driver I get the following code flow:

usb 1-1: rtl28xxu_exit:
mn88472 2-0018: mn88472_remove:  <-- this call will actually free the 
fe[1] pointer, I added the memset to make sure they where null
usb 1-1: dvb_usbv2_exit:
usb 1-1: dvb_usbv2_remote_exit:
usb 1-1: dvb_usbv2_adapter_exit:
usb 1-1: dvb_usbv2_adapter_exit: fe0[0]=0xffff88007a8b0018
usb 1-1: dvb_usbv2_adapter_exit: fe0[0]->dvb=0xffff88007a142580
usb 1-1: dvb_usbv2_adapter_exit: fe0[0]->demodulator_priv=0xffff88007a8b0000
usb 1-1: dvb_usbv2_adapter_exit: fe1[0]=0xffff88007a8d0030
usb 1-1: dvb_usbv2_adapter_exit: fe1[0]->dvb=0x          (null)
usb 1-1: dvb_usbv2_adapter_exit: fe1[0]->demodulator_priv=0x          (null)
BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
IP: [<ffffffffa021f3de>] dvb_unregister_frontend+0x2a/0xf1 [dvb_core]

dvb_unregister_frontend() is sent the fe[1] pointer which now is null 
and thus crashes with a null pointer dereference. A use after free issue.

I looked for similar code and found it in:
si2168.c
af9033.c
tc90522.c

sp2.c has the same structure but I think it is fine.

So at first it would be nice if someone could confirm my findings. 
Applying the same kind of code like my patch and unplug something that 
uses the affected frontend should be enough.

MvH
Benjamin Larsson
