Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:33158 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaDWNLJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Apr 2014 09:11:09 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N4H00DHFJAK4Z90@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Apr 2014 09:11:08 -0400 (EDT)
Date: Wed, 23 Apr 2014 10:11:03 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL 3.16] 2013:025f PCTV tripleStick (292e)
Message-id: <20140423101103.534da391@samsung.com>
In-reply-to: <535721C7.7030807@iki.fi>
References: <535721C7.7030807@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 23 Apr 2014 05:13:27 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Hardware is Empia EM28178, Silicon Labs Si2168, Silicon Labs Si2157. 
> There is on/off external LNA too. Two new drivers for Silicon Labs DTV 
> chipset.
> 
> Demod needs firmware, which could be found from driver CD version 6.4.8.984.
> /TVC 6.4.8/Driver/PCTV Empia/emOEM.sys
> dd if=emOEM.sys ibs=1 skip=1089416 count=2720 of=dvb-demod-si2168-01.fw
> md5sum dvb-demod-si2168-01.fw
> 87c317e0b75ad49c2f2cbf35572a8093  dvb-demod-si2168-01.fw

Not sure if you did it already, but could you please put the above
instructions on our Wiki page?

It would be better to add it at the DVB get firmware script, but it seems
that PCTV didn't put the driver yet on their website.

> Demod and tuner power-management is broken - chips are not put sleep at 
> all. It is same for windows driver too. Fortunately device eats only 
> around 200mA from USB when active. Will be fixed if and when windows 
> drivers are fixed.
> 
> Here is some internals from device.
> http://blog.palosaari.fi/2014/04/naked-hardware-15-pctv-triplestick-292e.html
> 
> 
> 
> The following changes since commit a83b93a7480441a47856dc9104bea970e84cda87:
> 
>    [media] em28xx-dvb: fix PCTV 461e tuner I2C binding (2014-03-31 
> 08:02:16 -0300)
> 
> are available in the git repository at:
> 
>    git://linuxtv.org/anttip/media_tree.git pctv_292e
> 
> for you to fetch changes up to 11c59dbb8a399558a2450a1cf64ff7b7e4157c45:
> 
>    em28xx: PCTV tripleStick (292e) LNA support (2014-04-23 04:56:54 +0300)
> 
> ----------------------------------------------------------------
> Antti Palosaari (12):
>        si2157: Silicon Labs Si2157 silicon tuner driver
>        si2168: Silicon Labs Si2168 DVB-T/T2/C demod driver
>        em28xx: add [2013:025f] PCTV tripleStick (292e)
>        si2168: add support for DVB-T2
>        si2157: extend frequency range for DVB-C
>        si2168: add support for DVB-C (annex A version)
>        si2157: add copyright and license
>        si2168: add copyright and license
>        MAINTAINERS: add si2168 driver
>        MAINTAINERS: add si2157 driver
>        si2168: relax demod lock checks a little
>        em28xx: PCTV tripleStick (292e) LNA support
> 
>   MAINTAINERS                               |  20 ++++
>   drivers/media/dvb-frontends/Kconfig       |   7 ++
>   drivers/media/dvb-frontends/Makefile      |   1 +
>   drivers/media/dvb-frontends/si2168.c      | 760 
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>   drivers/media/dvb-frontends/si2168.h      |  39 +++++++
>   drivers/media/dvb-frontends/si2168_priv.h |  46 +++++++++
>   drivers/media/tuners/Kconfig              |   7 ++
>   drivers/media/tuners/Makefile             |   1 +
>   drivers/media/tuners/si2157.c             | 260 
> ++++++++++++++++++++++++++++++++++++++++++++++
>   drivers/media/tuners/si2157.h             |  34 ++++++
>   drivers/media/tuners/si2157_priv.h        |  37 +++++++
>   drivers/media/usb/em28xx/Kconfig          |   2 +
>   drivers/media/usb/em28xx/em28xx-cards.c   |  25 +++++
>   drivers/media/usb/em28xx/em28xx-dvb.c     |  89 ++++++++++++++++
>   drivers/media/usb/em28xx/em28xx.h         |   1 +
>   15 files changed, 1329 insertions(+)
>   create mode 100644 drivers/media/dvb-frontends/si2168.c
>   create mode 100644 drivers/media/dvb-frontends/si2168.h
>   create mode 100644 drivers/media/dvb-frontends/si2168_priv.h
>   create mode 100644 drivers/media/tuners/si2157.c
>   create mode 100644 drivers/media/tuners/si2157.h
>   create mode 100644 drivers/media/tuners/si2157_priv.h
> 


-- 

Regards,
Mauro
