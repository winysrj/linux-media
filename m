Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:53562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752128Ab0KQCSc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 21:18:32 -0500
Message-ID: <4CE33B74.6020304@redhat.com>
Date: Wed, 17 Nov 2010 00:18:28 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Manu Abraham <abraham.manu@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: hg pull http://202.88.242.108:8000/hg/var/www/hg/v4l-dvb/
References: <AANLkTi=ptdBfOm1qaj5EvYfc4ipzdS4PTVsBpW03vdNp@mail.gmail.com>
In-Reply-To: <AANLkTi=ptdBfOm1qaj5EvYfc4ipzdS4PTVsBpW03vdNp@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 14-11-2010 18:48, Manu Abraham escreveu:
> Mauro,
> 
> Please pull from http://202.88.242.108:8000/hg/var/www/hg/v4l-dvb/
> 
> for the following changes.
> 
> 
> changeset 15168:baa4e8008db5 Mantis, hopper: use MODULE_DEVICE_TABLE
> http://202.88.242.108:8000/hg/var/www/hg/v4l-dvb/rev/baa4e8008db5
> 
> changeset 15169:f04605948fdc Mantis: append tasklet maintenance for
> DVB stream delivery
> http://202.88.242.108:8000/hg/var/www/hg/v4l-dvb/rev/f04605948fdc
> 
> changeset 15170:ee7a63d70f94 Mantis: use dvb_attach to avoid double
> dereferencing on module removal
> http://202.88.242.108:8000/hg/var/www/hg/v4l-dvb/rev/ee7a63d70f94
> 
> changeset 15171:3a2ece3bf184 Mantis: Rename gpio_set_bits to
> mantis_gpio_set_bits
> http://202.88.242.108:8000/hg/var/www/hg/v4l-dvb/rev/3a2ece3bf184
> 
> changeset 15172:56c20de4f697 stb6100: Improve tuner performance
> http://202.88.242.108:8000/hg/var/www/hg/v4l-dvb/rev/56c20de4f697
> 
> changeset 15173:5cc010e3a803 stb0899: fix diseqc messages getting lost
> http://202.88.242.108:8000/hg/var/www/hg/v4l-dvb/rev/5cc010e3a803

Applied, thanks.

A new warning appeared:

drivers/media/dvb/frontends/stb6100.c:120: warning: ëstb6100_normalise_regsí defined but not used

I tried to remove the applied patches from the patchwork queue. There are still a few patches
pending there. Not sure if they got obsoleted by the applied ones, or if they are still
relevant:

Jun,20 2010: [2/2] DVB/V4L: mantis: remove unused files                             http://patchwork.kernel.org/patch/107062  Bj√∏rn Mork <bjorn@mork.no>
Jul,10 2010: Mantis driver patch: use interrupt for I2C traffic instead of busy reg http://patchwork.kernel.org/patch/111245  Marko Ristola <marko.ristola@kolumbus.fi>
Jul,19 2010: Twinhan DTV Ter-CI (3030 mantis)                                       http://patchwork.kernel.org/patch/112708  Niklas Claesson <nicke.claesson@gmail.com>
Aug, 7 2010: Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt     http://patchwork.kernel.org/patch/118173  Marko Ristola <marko.ristola@kolumbus.fi>
Oct,10 2010: [v2] V4L/DVB: faster DVB-S lock for mantis cards using stb0899 demod   http://patchwork.kernel.org/patch/244201  Tuxoholic <tuxoholic@hotmail.de>

Please take a look and give us some feedback.

Thanks,
Mauro.
