Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:37115 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZJEVzf (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2009 17:55:35 -0400
Message-ID: <4ACA6B25.9090605@free.fr>
Date: Mon, 05 Oct 2009 23:54:45 +0200
From: matthieu castet <castet.matthieu@free.fr>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?D=EAnis_Goes?= <denishark@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: tm6010 status
References: <4AC8C44E.4050103@free.fr> <f326ee1a0910040910p3400a8a7idd91a280e638bec5@mail.gmail.com>
In-Reply-To: <f326ee1a0910040910p3400a8a7idd91a280e638bec5@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Dênis Goes wrote:
> Hi Matthieu...
> I made the same answer yesterday... I want to help in development for use my
> PixelView 405 USB.
> 
> Do you have the correct tridvid.sys file to extract the firmware ?
> 
No, I took the firmware (for the tuner) somewhere on internet.

Some time ago I have done some usb sniffing on Windows for my HVR900H, study the linux driver and start
some analysis [2].

I found some strange thing on i2c bus [1]. Then I figure out what should be done to make
work the digital part.
But because of lack of time and motivation (like everybody ;) ), I stopped working on this.

Matthieu

[1] 
http://www.mail-archive.com/linux-media@vger.kernel.org/msg00987.html

[2]
== i2c ==
0x1f zl
0xa0 eeprom
0xa2 ??? (0xff)
0xa4
0xa6->0xac ??? (0xff)
0xae 
0xc2 (tuner)
== gpio ==
0 (WP eeprom ?? )
1 ZL RESET
2 tuner_reset_gpio
4 input sel ???
5 (led green)
7 (led blue)
== eeprom format ==
0x0-0x3 : magic ???
0x4-0x15 : GetDescriptor device
0xc VID
0xE PID
0x10 DID
0x12 iManufacturer
0x13 Product string
0x14 SerialNumber

0x40 string size (10 03) ???
0x42-0x4f (Product string @32)
0x94 string size (16 03)
0x96-0xa9 (SerialNumber @64)
0x16 string size (02 03)
0x18-     (iManufacturer @16)

0x60 : iConfiguration index ???
0x6a string size (0a 03)
0x6c (iConfiguration @48)

where is mac address and rev ???
