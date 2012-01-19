Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752127Ab2ASOm2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 09:42:28 -0500
Message-ID: <4F182BCF.60303@redhat.com>
Date: Thu, 19 Jan 2012 12:42:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGVuaWxzb24gRmlndWVpcmVkbyBkZSBTw6E=?=
	<denilsonsa@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: Siano DVB USB device called "Smart Plus"
References: <CACGt9y=8FzimyQPx7gJQ=gVqDp7cRUojT53gJq2+TNKhH37Wpg@mail.gmail.com>
In-Reply-To: <CACGt9y=8FzimyQPx7gJQ=gVqDp7cRUojT53gJq2+TNKhH37Wpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Denilson,

Em 19-01-2012 11:31, Denilson Figueiredo de Sá escreveu:
> I bought a USB DVB device in Brazil, but it doesn't work yet on my Linux system.
> 
> I've already documented it at:
> http://linuxtv.org/wiki/index.php/Smart_Plus
> 
> The device works if I try to use it inside a VirtualBox virtual
> machine running Windows.
> 
> I believe the kernel driver that claims this device does not actually
> support it.
> 
> 
> The device is called "USB 2.0 ISDB-T Stick", model UTV926 (according
> to the manual), but I've also seen it mentioned as YS-926TV. USB
> vendor:product is 187f:0202.
> 
> 
> What can I do in order to make it work?

>From the product page, it is a 1-seg device. So, it likely uses a sms1xxx
chip. The SMS1XXX_BOARD_HAUPPAUGE_WINDHAM board is likely close to this
one. From drivers/media/dvb/siano/sms-cards.c:

	[SMS1XXX_BOARD_HAUPPAUGE_WINDHAM] = {
		.name	= "Hauppauge WinTV MiniStick",
		.type	= SMS_NOVA_B0,
		.fw[DEVICE_MODE_ISDBT_BDA] = "sms1xxx-hcw-55xxx-isdbt-02.fw",
		.fw[DEVICE_MODE_DVBT_BDA] = "sms1xxx-hcw-55xxx-dvbt-02.fw",
		.rc_codes = RC_MAP_HAUPPAUGE,
		.board_cfg.leds_power = 26,
		.board_cfg.led0 = 27,
		.board_cfg.led1 = 28,
		.board_cfg.ir = 9,
		.led_power = 26,
		.led_lo    = 27,
		.led_hi    = 28,
	},

I wrote the ISDB-T support for it, and it works properly.

You'll likely need to add a new board entry there for it, and discover
the GPIO pins linked to the leds and infrared (the numbers for .board_cfg
and .led* on the above data structure). You can do it by either sniffing
the USB board traffic or by opening the device and carefully examining the
board tracks.

After you have a patch adding support for it, please submit us the patch.

Regards,
Mauro

