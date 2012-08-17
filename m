Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33322 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753657Ab2HQU7j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 16:59:39 -0400
Received: by lagy9 with SMTP id y9so2344190lag.19
        for <linux-media@vger.kernel.org>; Fri, 17 Aug 2012 13:59:37 -0700 (PDT)
Message-ID: <502EB0A9.4090501@iki.fi>
Date: Fri, 17 Aug 2012 23:59:21 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Petter Selasky <hselasky@c2i.net>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Strong pairing cam doesn't work with CT-3650 driver (ttusb2)
References: <201208172135.17623.hselasky@c2i.net>
In-Reply-To: <201208172135.17623.hselasky@c2i.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/17/2012 10:35 PM, Hans Petter Selasky wrote:
> Hi,
>
> Have anyone out there tested the CT-3650 USB driver in the Linux kernel with a
> "strong pairing cam".

Likely that means CI+ with some pairing features enabled.

> According to some web-forums, the hardware should support that given using the
> vendor provided DVB WinXXX software.
>
> drivers/media/dvb/dvb-usb/ttusb2.c
>
> Any clues how to debug or what can be wrong?

Take USB traffic capture from working Windows setup and analyze what is 
done differently.

> When inserting the CAM, VDR says that a CAM is present, but then after a while
> no CAM is present.
>
> Log:
>
> ttusb2: tt3650_ci_slot_reset 0
> ttusb2: tt3650_ci_read_attribute_mem 0000 -> 0 0x00
> ttusb2: tt3650_ci_read_attribute_mem 0002 -> 0 0x00
> TUPLE type:0x0 length:0
> dvb_ca adapter 0: Invalid PC card inserted :(
> dvb_ca_en50221_io_open
> dvb_ca_en50221_thread_wakeup
> dvb_ca_en50221_io_do_ioctl
> dvb_ca_en50221_io_do_ioctl
> dvb_ca_en50221_slot_shutdown
> ttusb2: tt3650_ci_set_video_port 0 0
> Slot 0 shutdown
> dvb_ca_en50221_thread_wakeup
> dvb_ca_en50221_io_poll
> ttusb2: tt3650_ci_slot_reset 0
> dvb_ca_en50221_io_do_ioctl
> dvb_ca_en50221_io_poll
> dvb_ca_en50221_io_poll
> dvb_ca_en50221_io_poll
> dvb_ca_en50221_io_poll
> dvb_ca_en50221_io_poll
> dvb_ca_en50221_io_poll
> dvb_ca_en50221_io_poll
> dvb_ca_en50221_io_poll
> dvb_ca_en50221_io_poll
> dvb_ca_en50221_io_poll
> ttusb2: tt3650_ci_read_attribute_mem 0000 -> 0 0x1d
> ttusb2: tt3650_ci_read_attribute_mem 0002 -> 0 0x04
> TUPLE type:0x1d length:4
> ttusb2: tt3650_ci_read_attribute_mem 0004 -> 0 0x00
>    0x00: 0x00 .
> ttusb2: tt3650_ci_read_attribute_mem 0006 -> 0 0xdb
>    0x01: 0xdb .
> ttusb2: tt3650_ci_read_attribute_mem 0008 -> 0 0x08
>    0x02: 0x08 .
> ttusb2: tt3650_ci_read_attribute_mem 000a -> 0 0xff
>    0x03: 0xff .
> dvb_ca adapter 0: Invalid PC card inserted :(
> dvb_ca_en50221_io_do_ioctl

regards
Antti

-- 
http://palosaari.fi/
