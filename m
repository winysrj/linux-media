Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:46861 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932445Ab3E3P1K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 May 2013 11:27:10 -0400
Received: by mail-bk0-f52.google.com with SMTP id mz10so225306bkb.39
        for <linux-media@vger.kernel.org>; Thu, 30 May 2013 08:27:08 -0700 (PDT)
Message-ID: <51A76FCA.3010803@gmail.com>
Date: Thu, 30 May 2013 17:27:06 +0200
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: Torsten Seyffarth <t.seyffarth@gmx.de>
CC: linux-media@vger.kernel.org
Subject: Re: Cinergy TStick RC rev.3 (rtl2832u) only 4 programs
References: <51A73A88.9000601@gmx.de>
In-Reply-To: <51A73A88.9000601@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 30.05.2013 13:39, Torsten Seyffarth wrote:
…

> After a hard disk crash I had to install my system anyway so I switched
> to OpenSUSE 12.3 with a 3.7 Kernel, because this should support the
> rtl2832u directly.
> Basically this is working. The Stick is detected:
…

> These kernel moduls are loaded:
> rtl2832                18542  1
> dvb_usb_rtl28xxu       28608  0
> dvb_usb_v2             34564  2 dvb_usb_af9015,dvb_usb_rtl28xxu
> rc_core                30555  4 dvb_usb_af9015,dvb_usb_rtl28xxu,dvb_usb_v2
> rtl2830                18316  1 dvb_usb_rtl28xxu
> dvb_core              109206  3 rtl2832,dvb_usb_v2,rtl2830

e4000!? :)

> The problem is, that only four DVB-T programs on one transponder can be
> received, but these in a very good quality. It should be around 20
> programs. I tested this with MythTV and Kaffeine and both only find the
> same 4 programs. With a Windows 7 PC and the antenna on the same
> position I get all programs in good quality. So I do not think the stick
> is broken or the quality of the antenna signal is the problem.
> 
> Has anyone an idea?

http://www.spinics.net/lists/linux-media/msg58249.html
Besides for testing purposes, it is recommended to use at least the last
stable stable kernel[1] e.g. 3.9.4-200.fc18.x86_64. :)
In addition, you can update the media modules via instructions - readme
at linuxtv.org[2].


poma


[1] https://www.kernel.org/
[1] http://git.linuxtv.org/media_build.git


