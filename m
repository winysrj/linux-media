Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:53524 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbZBITk4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Feb 2009 14:40:56 -0500
Message-ID: <499086BC.4080605@free.fr>
Date: Mon, 09 Feb 2009 20:40:44 +0100
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: Patrick Boettcher <patrick.boettcher@desy.de>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, DVB list <linux-dvb@linuxtv.org>
Subject: Re: [PATCH] Support faulty USB IDs on DIBUSB_MC
References: <484A72D3.7070500@free.fr> <4974E4BE.2060107@free.fr> <20090129074735.76e07d47@caramujo.chehab.org> <alpine.LRH.1.10.0901291117110.15700@pub6.ifh.de> <49820C26.5090309@free.fr> <498215A8.3020203@free.fr>
In-Reply-To: <498215A8.3020203@free.fr>
Content-Type: multipart/mixed;
 boundary="------------070106040200020905010004"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070106040200020905010004
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

matthieu castet wrote:
> matthieu castet wrote:
>> Hi Patrick,
>>
>> Patrick Boettcher wrote:
>>> Hi,
>>>
>>> sorry for not answering ealier, recently I became the master of 
>>> postponing things. :(
>>>
>>> On Thu, 29 Jan 2009, Mauro Carvalho Chehab wrote:
>>>
>>>>> +/* 14 */    { USB_DEVICE(USB_VID_CYPRESS,        
>>>>> USB_PID_ULTIMA_TVBOX_USB2_FX_COLD) },
>>>>> +#endif
>>>>
>>>> It doesn't sound a very good approach the need of recompiling the 
>>>> driver to
>>>> allow it to work with a broken card. The better would be to have 
>>>> some modprobe
>>>> option to force it to accept a certain USB ID as a valid ID for the 
>>>> card.
>>>
>>> The most correct way would be to reprogram the eeprom, by simply 
>>> writing to 0xa0 (0x50 << 1) I2C address... There was a thread on the 
>>> linux-dvb some time ago.
>>>
> BTW dibusb_i2c_xfer seems to do things very dangerous :
> it assumes that it get only write/read request or write request.
> 
> That means that read can be understood as write. For example a program 
> doing
> file = open("/dev/i2c-x", O_RDWR);
> ioctl(file, I2C_SLAVE, 0x50)
>  read(file, data, 10)
> will corrupt the eeprom as it will be understood as a write.
> 
Patrick, any info about that.

I attach a possible (untested) patch.


Matthieu

--------------070106040200020905010004
Content-Type: text/plain;
 name="dibusb_i2c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dibusb_i2c"

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
Index: linux-2.6/drivers/media/dvb/dvb-usb/dibusb-common.c
===================================================================
--- linux-2.6.orig/drivers/media/dvb/dvb-usb/dibusb-common.c	2009-02-09 20:36:03.000000000 +0100
+++ linux-2.6/drivers/media/dvb/dvb-usb/dibusb-common.c	2009-02-09 20:38:21.000000000 +0100
@@ -133,14 +133,18 @@
 
 	for (i = 0; i < num; i++) {
 		/* write/read request */
-		if (i+1 < num && (msg[i+1].flags & I2C_M_RD)) {
+		if (i+1 < num && (msg[i].flags & I2C_M_RD) == 0
+					  && (msg[i+1].flags & I2C_M_RD)) {
 			if (dibusb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,
 						msg[i+1].buf,msg[i+1].len) < 0)
 				break;
 			i++;
-		} else
+		} else if ((msg[i].flags & I2C_M_RD) == 0) {
 			if (dibusb_i2c_msg(d, msg[i].addr, msg[i].buf,msg[i].len,NULL,0) < 0)
 				break;
+		}
+		else
+			break;
 	}
 
 	mutex_unlock(&d->i2c_mutex);

--------------070106040200020905010004--
