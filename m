Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57653 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754586Ab0G2Vke (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jul 2010 17:40:34 -0400
Message-ID: <4C51F54A.7030201@iki.fi>
Date: Fri, 30 Jul 2010 00:40:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: hmd <tambatux@gmail.com>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: DVBT +AF9015 +MXL5007t
References: <1280324442.6066.5.camel@HDtv>
In-Reply-To: <1280324442.6066.5.camel@HDtv>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/28/2010 04:40 PM, hmd wrote:
> HI all
> I have a usb dvbt module with af9015 +mx5007t
> both drivers exist in kernel but af9015.c needs to be patched
>
> lsusb:
> Bus 002 Device 003: ID 15a4:9016 Afatech Technologies, Inc. AF9015 DVB-T
> USB2.0 stick
>
> dmesg | grep 9015
> [ 3407.599086] dvb_usb_af9015 2-4:1.0: usb_probe_interface
> [ 3407.599095] dvb_usb_af9015 2-4:1.0: usb_probe_interface - got id
> [ 3407.967209] af9015: tuner id:177 not supported, please report!
> [ 3407.967270] dvb_usb_af9015 2-4:1.1: usb_probe_interface
> [ 3407.967277] dvb_usb_af9015 2-4:1.1: usb_probe_interface - got id
> [ 3407.968049] usbcore: registered new interface driver dvb_usb_af9015
>
> driver adress:
> v4l-dvb/linux/drivers/media/dvb/dvb-usb/af9015.c
> v4l-dvb/linux/drivers/media/common/tuners/mxl5007.c
>
>
> I dont know how do it
> can any one help?
> thanks

I can put it working rather easily if you donate the stick.

Antti
-- 
http://palosaari.fi/
