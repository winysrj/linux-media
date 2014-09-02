Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:24519 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776AbaIBTAE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Sep 2014 15:00:04 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBA00CO0FG111A0@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 02 Sep 2014 15:00:01 -0400 (EDT)
Date: Tue, 02 Sep 2014 15:59:56 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, Nibble Max <nibble.max@gmail.com>,
	Olli Salonen <olli.salonen@iki.fi>,
	Evgeny Plehov <EvgenyPlehov@ukr.net>
Subject: Re: [GIT PULL FINAL 00/21] misc DTV stuff for 3.18
Message-id: <20140902155956.0198467c.m.chehab@samsung.com>
In-reply-to: <1408705093-5167-1-git-send-email-crope@iki.fi>
References: <1408705093-5167-1-git-send-email-crope@iki.fi>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 22 Aug 2014 13:57:52 +0300
Antti Palosaari <crope@iki.fi> escreveu:

> Moikka
> I picked these from patchwork and this is just final review before
> PULL request I will send very shortly. I don't expect any change
> requests at this late, without a very good reason :)
> 
> However, I could add some tags until Mauro PULLs to master.
> 
> regards
> Antti
> 
> Antti Palosaari (10):
>   dvb-usb-v2: remove dvb_usb_device NULL check
>   msi2500: remove unneeded local pointer on msi2500_isoc_init()
>   m88ts2022: fix 32bit overflow on filter calc
>   m88ts2022: fix coding style issues
>   m88ts2022: rename device state (priv => s)

As I didn't apply the above patch...

>   m88ts2022: clean up logging
>   m88ts2022: convert to RegMap I2C API
>   m88ts2022: change parameter type of m88ts2022_cmd

Those tree patches also didn't apply.

>   m88ds3103: change .set_voltage() implementation
>   m88ds3103: fix coding style issues
> 
> CrazyCat (1):
>   si2168: DVB-T2 PLP selection implemented
> 
> Olli Salonen (9):
>   si2168: clean logging
>   si2157: clean logging
>   si2168: add ts_mode setting and move to si2168_init
>   em28xx: add ts mode setting for PCTV 292e
>   cxusb: add ts mode setting for TechnoTrend CT2-4400
>   sp2: Add I2C driver for CIMaX SP2 common interface module
>   cxusb: Add support for TechnoTrend TT-connect CT2-4650 CI
>   cxusb: Add read_mac_address for TT CT2-4400 and CT2-4650
>   si2157: Add support for delivery system SYS_ATSC
> 
> nibble.max (1):
>   m88ds3103: implement set voltage and TS clock
> 
>  drivers/media/dvb-core/dvb-usb-ids.h       |   1 +
>  drivers/media/dvb-frontends/Kconfig        |   7 +
>  drivers/media/dvb-frontends/Makefile       |   1 +
>  drivers/media/dvb-frontends/m88ds3103.c    | 101 +++++--
>  drivers/media/dvb-frontends/m88ds3103.h    |  35 ++-
>  drivers/media/dvb-frontends/si2168.c       | 101 ++++---
>  drivers/media/dvb-frontends/si2168.h       |   6 +
>  drivers/media/dvb-frontends/si2168_priv.h  |   1 +
>  drivers/media/dvb-frontends/sp2.c          | 441 +++++++++++++++++++++++++++++
>  drivers/media/dvb-frontends/sp2.h          |  53 ++++
>  drivers/media/dvb-frontends/sp2_priv.h     |  50 ++++
>  drivers/media/tuners/Kconfig               |   1 +
>  drivers/media/tuners/m88ts2022.c           | 355 +++++++++--------------
>  drivers/media/tuners/m88ts2022_priv.h      |   5 +-
>  drivers/media/tuners/si2157.c              |  55 ++--
>  drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c |   2 +-
>  drivers/media/usb/dvb-usb/Kconfig          |   2 +-
>  drivers/media/usb/dvb-usb/cxusb.c          | 128 ++++++++-
>  drivers/media/usb/dvb-usb/cxusb.h          |   4 +
>  drivers/media/usb/em28xx/em28xx-dvb.c      |   5 +-
>  drivers/media/usb/msi2500/msi2500.c        |   9 +-
>  21 files changed, 1022 insertions(+), 341 deletions(-)
>  create mode 100644 drivers/media/dvb-frontends/sp2.c
>  create mode 100644 drivers/media/dvb-frontends/sp2.h
>  create mode 100644 drivers/media/dvb-frontends/sp2_priv.h
> 
