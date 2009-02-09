Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:41116 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756179AbZBITvk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Feb 2009 14:51:40 -0500
Received: by yx-out-2324.google.com with SMTP id 8so71318yxm.1
        for <linux-media@vger.kernel.org>; Mon, 09 Feb 2009 11:51:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <499086BC.4080605@free.fr>
References: <484A72D3.7070500@free.fr> <4974E4BE.2060107@free.fr>
	 <20090129074735.76e07d47@caramujo.chehab.org>
	 <alpine.LRH.1.10.0901291117110.15700@pub6.ifh.de>
	 <49820C26.5090309@free.fr> <498215A8.3020203@free.fr>
	 <499086BC.4080605@free.fr>
Date: Mon, 9 Feb 2009 14:51:39 -0500
Message-ID: <412bdbff0902091151u667d7482mce0a45c44011e9c5@mail.gmail.com>
Subject: Re: [linux-dvb] [PATCH] Support faulty USB IDs on DIBUSB_MC
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: linux-media@vger.kernel.org
Cc: Patrick Boettcher <patrick.boettcher@desy.de>,
	DVB list <linux-dvb@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Feb 9, 2009 at 2:40 PM, matthieu castet
>> BTW dibusb_i2c_xfer seems to do things very dangerous :
>> it assumes that it get only write/read request or write request.
>>
>> That means that read can be understood as write. For example a program
>> doing
>> file = open("/dev/i2c-x", O_RDWR);
>> ioctl(file, I2C_SLAVE, 0x50)
>>  read(file, data, 10)
>> will corrupt the eeprom as it will be understood as a write.
>>
> Patrick, any info about that.
>
> I attach a possible (untested) patch.
>
>
> Matthieu
>
> Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
> Index: linux-2.6/drivers/media/dvb/dvb-usb/dibusb-common.c
> ===================================================================
> --- linux-2.6.orig/drivers/media/dvb/dvb-usb/dibusb-common.c    2009-02-09
> 20:36:03.000000000 +0100
> +++ linux-2.6/drivers/media/dvb/dvb-usb/dibusb-common.c 2009-02-09
> 20:38:21.000000000 +0100
> @@ -133,14 +133,18 @@
>
>        for (i = 0; i < num; i++) {
>                /* write/read request */
> -               if (i+1 < num && (msg[i+1].flags & I2C_M_RD)) {
> +               if (i+1 < num && (msg[i].flags & I2C_M_RD) == 0
> +                                         && (msg[i+1].flags & I2C_M_RD)) {
>                        if (dibusb_i2c_msg(d, msg[i].addr,
> msg[i].buf,msg[i].len,
>                                                msg[i+1].buf,msg[i+1].len) <
> 0)
>                                break;
>                        i++;
> -               } else
> +               } else if ((msg[i].flags & I2C_M_RD) == 0) {
>                        if (dibusb_i2c_msg(d, msg[i].addr,
> msg[i].buf,msg[i].len,NULL,0) < 0)
>                                break;
> +               }
> +               else
> +                       break;
>        }
>
>        mutex_unlock(&d->i2c_mutex);
>

Regarding the patch itself, it looks ok at face value, but I would
rather see it scream loudly that you're trying to do this rather just
silently not performing the read.  This would help catch cases where
the calling driver is doing something the i2c implementation doesn't
support (so that the developer knows to either change his i2c code or
use the 1.20 version of the function).

I'm just speaking as a developer who got bit by this making the
dib0700 work with the xc5000, where I didn't realize the xc5000 driver
was doing something that the dib0700 i2c didn't support and it failed
silently.

Devin


-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
