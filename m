Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:47753 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574AbbD1Akb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 20:40:31 -0400
Date: Mon, 27 Apr 2015 21:40:22 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Patrick Boettcher <patrick.boettcher@posteo.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jemma Denson <jdenson@gmail.com>
Subject: Re: [PULL] For 4.2 (or even 4.1?) add support for cx24120/Technisat
 SkyStar S2
Message-ID: <20150427214022.1ff9f61f@recife.lan>
In-Reply-To: <20150427232523.08c1c8f1@lappi3.parrot.biz>
References: <20150420092720.3cb092ba@dibcom294.coe.adi.dibcom.com>
	<20150427171628.5ba22752@recife.lan>
	<20150427232523.08c1c8f1@lappi3.parrot.biz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 27 Apr 2015 23:25:23 +0200
Patrick Boettcher <patrick.boettcher@posteo.de> escreveu:

> Thank you for your review Mauro.
> 
> In total there are about 3-4 (it's a guess) users of this driver and
> this, written-once read-never, code is for a hardware which is very
> unlikely to be ever reused again ever. Sometimes I regret that there is
> no carpet in OpenSource where you could hide the dirt under ;-).

:)
 
> This driver has been reverse-engineered from a binary-only release - so
> looking for logic is not really useful - there will be sections which
> are not understandable or would require a certain amount of
> investigation and reverse-engineering (I'm thinking of the UNC and BER
> reporting, maybe SNR too).

SNR can be reported in relative mode, if you're unable to figure out
what it means in dB. I don't see much problem for UNC, as, on both DVBv3
and DVBv5, this is a counter.

BER is the only measure that could be more problematic, as, on DVBv5,
it requires the scale of the BER measure, e. g. if BER reports "1",
does that mean an error of 10^-12, 10^-9, 10^-7, 10^-6 or some other
bit rate? In other words, what's the denominator for BER?

> Tough not sure if it is worth the time. Anyone there to convince me?
> 
> I'm really surprised that checkpatch.pl hasn't seen any of the
> coding-style problems you pointed out, except the printk-usage. I ran
> it on the .c-file and not on the patch, is that the problem?

No. People complained that checkpatch was too pedantic. So, some
checks are now optional. A more pedantic test would be to run it
as:

	$ checkpatch.pl --strict

There are other parameters that could also used, like --codespell,
in order to identify spelling errors.

Checkpatch can even correct some common errors, using the --fix
parameter.

If you run checkpatch in strict mode, you'll see a lot more errors,
like:

CHECK: spaces preferred around that '/' (ctx:VxV)
#1330: FILE: drivers/media/dvb-frontends/cx24120.c:1131:
+	cmd.arg[4]  = ((state->dcur.symbol_rate/1000) & 0xff00) >> 8;
...

CHECK: Alignment should match open parenthesis
#1486: FILE: drivers/media/dvb-frontends/cx24120.c:1287:
+		err("Could not load firmware (%s): %d\n",
+			CX24120_FIRMWARE, ret);
...
CHECK: Prefer kzalloc(sizeof(*state)...) over kzalloc(sizeof(struct cx24120_state)...)
#466: FILE: drivers/media/dvb-frontends/cx24120.c:267:
+       state = kzalloc(sizeof(struct cx24120_state),
...

total: 2 errors, 5 warnings, 107 checks, 1755 lines checked

E. g., 107 additional reports will pop up. Ok, not all of them are
relevant. That's why this is disabled by default. For example, it
works for me if you don't fix this warning:

CHECK: Avoid CamelCase: <skystarS2_rev33_attach>
#106: FILE: drivers/media/common/b2c2/flexcop-fe-tuner.c:635:
+static int skystarS2_rev33_attach(struct flexcop_device *fc,

It is probably worth to run checkpatch in strict mode for new drivers,
in order to see if something relevant pops up.

I generally don't run it in strict mode when reviewing patches,
as it would generate too much overhead on my review process, as
it would take me more time reviewing those things, and I may
miss something more relevant.

> Could we send an additional patch for coding-style or would you prefer
> a new patch which has everything inside? This would maintain the
> author-attribution of the initial commit.

An additional patch is fine.

> Sorry for the top-posting.
> 
> best regards,
> --
> Patrick.
> 
> 
> On Mon, 27 Apr 2015 17:16:28 -0300
> Mauro Carvalho Chehab <mchehab@osg.samsung.com> wrote:
> 
> > Em Mon, 20 Apr 2015 09:27:20 +0200
> > Patrick Boettcher <patrick.boettcher@posteo.de> escreveu:
> > 
> > > Hi Mauro,
> > > 
> > > Would you please pull the following two patches for finally
> > > mainlining the Technisat SkyStar S2 (and its frontend cx24120).
> > > 
> > > Ideally for 4.1, but I assume it is too late. So for 4.2.
> > 
> > Hi Patrick,
> > 
> > It was too late for 4.1. We typically close the merge for the next
> > Kernel one week before the open of a merge window.
> > 
> > > Please also tell whether a pull-request is OK for you or whether you
> > > prefer patches.
> > 
> > Pull requests work best for me, as it warrants that the patches
> > will be applied in order. Also, I priorize pull requests over usual
> > patches.
> > 
> > However, if you send a pull request, don't forget to also post the
> > patch series, as it helps people to review and comment about the code.
> > 
> > > I'm based on the current media-tree's master. But can rebase myself
> > > on anything you wish for your convenience.
> > 
> > That's fine. You can base on it or on any tag at the Linus tree.
> > 
> > My script will actually convert the pull request into a quilt series
> > of patches, getting only the patches between the range specified at
> > the pull request e-mail.
> > 
> > It is slow, however, if the origin branch is not here, as it needs to
> > download a larger amount of objects, and then use a somewhat complex
> > heuristics to detect the origin branch. 
> > 
> > That's why the best is to either base on media-tree master or on a 
> > Linus tag.
> > 
> > > 
> > > Thanks,
> > > --
> > > Patrick.
> > > 
> > > 
> > > The following changes since commit
> > > e183201b9e917daf2530b637b2f34f1d5afb934d:
> > > 
> > >   [media] uvcvideo: add support for VIDIOC_QUERY_EXT_CTRL
> > > (2015-04-10 10:29:27 -0300)
> > > 
> > > are available in the git repository at:
> > > 
> > >   https://github.com/pboettch/linux.git cx24120-v2
> > > 
> > > for you to fetch changes up to
> > > 3a6500da369a632c9fd405b1191dcbf5e5e07504:
> > > 
> > >   [media] cx24120: minor checkpatch fixes (2015-04-17 11:11:40
> > > +0200)
> > 
> > As complained by checkpatch:
> > 
> > WARNING: added, moved or deleted file(s), does MAINTAINERS need
> > updating? #195: 
> > new file mode 100644
> > 
> > Please add an entry at MAINTAINERS for the one that will be
> > maintaining it.
> > 
> > Other comments follow.
> > 
> > > From c6c7a0454adacfda1ecbd62ae46b23d8af857539 Mon Sep 17 00:00:00
> > > 2001 From: Jemma Denson <jdenson@gmail.com>
> > > Date: Tue, 14 Apr 2015 14:04:50 +0200
> > > Subject: [media] Add support for TechniSat Skystar S2
> > > To: Linux Media Mailing List <linux-media@vger.kernel.org>
> > > Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> > > 
> > > This patch adds support for the Technisat Skystar S2 - this
> > > has been tried before but the cx24120 driver was a bit out of shape
> > > and it didn't got any further:
> > > 
> > > https://patchwork.linuxtv.org/patch/10575/
> > > 
> > > It is an old card, but currently being sold off for next to nothing,
> > > so it's proving quite popular of late. Noticing it's quite similar
> > > to the cx24116 and cx24117 I've rewritten the driver in a similar
> > > way.
> > > 
> > > There were a few registers and commands from those drivers
> > > missing from this one I've tested out and found they do something so
> > > they've been added in to speed up tuning and to make get_frontend
> > > return something useful.
> > > 
> > > Signed-off-by: Jemma Denson <jdenson@gmail.com>
> > > Signed-off-by: Patrick.Boettcher <patrick.boettcher@posteo.de>
> > > ---
> > >  drivers/media/common/b2c2/Kconfig            |    1 +
> > >  drivers/media/common/b2c2/flexcop-fe-tuner.c |   51 +-
> > >  drivers/media/common/b2c2/flexcop-misc.c     |    1 +
> > >  drivers/media/common/b2c2/flexcop-reg.h      |    1 +
> > >  drivers/media/dvb-frontends/Kconfig          |    7 +
> > >  drivers/media/dvb-frontends/Makefile         |    1 +
> > >  drivers/media/dvb-frontends/cx24120.c        | 1577
> > > ++++++++++++++++++++++++++
> > > drivers/media/dvb-frontends/cx24120.h        |   56 + 8 files
> > > changed, 1688 insertions(+), 7 deletions(-) create mode 100644
> > > drivers/media/dvb-frontends/cx24120.c create mode 100644
> > > drivers/media/dvb-frontends/cx24120.h
> > > 
> > > diff --git a/drivers/media/common/b2c2/Kconfig
> > > b/drivers/media/common/b2c2/Kconfig index
> > > a8c6cdfaa2f5..e5936380b1e5 100644 ---
> > > a/drivers/media/common/b2c2/Kconfig +++
> > > b/drivers/media/common/b2c2/Kconfig @@ -14,6 +14,7 @@ config
> > > DVB_B2C2_FLEXCOP select DVB_S5H1420 if MEDIA_SUBDRV_AUTOSELECT
> > >  	select DVB_TUNER_ITD1000 if MEDIA_SUBDRV_AUTOSELECT
> > >  	select DVB_ISL6421 if MEDIA_SUBDRV_AUTOSELECT
> > > +	select DVB_CX24120 if MEDIA_SUBDRV_AUTOSELECT
> > >  	select DVB_CX24123 if MEDIA_SUBDRV_AUTOSELECT
> > >  	select MEDIA_TUNER_SIMPLE if MEDIA_SUBDRV_AUTOSELECT
> > >  	select DVB_TUNER_CX24113 if MEDIA_SUBDRV_AUTOSELECT
> > > diff --git a/drivers/media/common/b2c2/flexcop-fe-tuner.c
> > > b/drivers/media/common/b2c2/flexcop-fe-tuner.c index
> > > 7e14e90d2922..66f6910a1810 100644 ---
> > > a/drivers/media/common/b2c2/flexcop-fe-tuner.c +++
> > > b/drivers/media/common/b2c2/flexcop-fe-tuner.c @@ -12,6 +12,7 @@
> > >  #include "cx24113.h"
> > >  #include "cx24123.h"
> > >  #include "isl6421.h"
> > > +#include "cx24120.h"
> > >  #include "mt352.h"
> > >  #include "bcm3510.h"
> > >  #include "nxt200x.h"
> > > @@ -26,6 +27,16 @@
> > >  #define FE_SUPPORTED(fe) (defined(CONFIG_DVB_##fe) || \
> > >  	(defined(CONFIG_DVB_##fe##_MODULE) && defined(MODULE)))
> > >  
> > > +#if FE_SUPPORTED(BCM3510) || FE_SUPPORTED(CX24120)
> > > +static int flexcop_fe_request_firmware(struct dvb_frontend *fe,
> > > +	const struct firmware **fw, char *name)
> > > +{
> > > +	struct flexcop_device *fc = fe->dvb->priv;
> > > +
> > > +	return request_firmware(fw, name, fc->dev);
> > > +}
> > > +#endif
> > > +
> > >  /* lnb control */
> > >  #if FE_SUPPORTED(MT312) || FE_SUPPORTED(STV0299)
> > >  static int flexcop_set_voltage(struct dvb_frontend *fe,
> > > fe_sec_voltage_t voltage) @@ -445,13 +456,6 @@ static int
> > > airstar_dvbt_attach(struct flexcop_device *fc, 
> > >  /* AirStar ATSC 1st generation */
> > >  #if FE_SUPPORTED(BCM3510)
> > > -static int flexcop_fe_request_firmware(struct dvb_frontend *fe,
> > > -	const struct firmware **fw, char* name)
> > > -{
> > > -	struct flexcop_device *fc = fe->dvb->priv;
> > > -	return request_firmware(fw, name, fc->dev);
> > > -}
> > > -
> > >  static struct bcm3510_config air2pc_atsc_first_gen_config = {
> > >  	.demod_address    = 0x0f,
> > >  	.request_firmware = flexcop_fe_request_firmware,
> > > @@ -619,6 +623,38 @@ fail:
> > >  #define cablestar2_attach NULL
> > >  #endif
> > >  
> > > +/* SkyStar S2 PCI DVB-S/S2 card based on Conexant cx24120/cx24118
> > > */ +#if FE_SUPPORTED(CX24120) && FE_SUPPORTED(ISL6421)
> > > +static const struct cx24120_config skystar2_rev3_3_cx24120_config
> > > = {
> > > +	.i2c_addr = 0x55,
> > > +	.xtal_khz = 10111,
> > > +	.initial_mpeg_config = { 0xa1, 0x76, 0x07 },
> > > +	.request_firmware = flexcop_fe_request_firmware,
> > > +};
> > > +
> > > +static int skystarS2_rev33_attach(struct flexcop_device *fc,
> > > +	struct i2c_adapter *i2c)
> > > +{
> > > +	fc->fe = dvb_attach(cx24120_attach,
> > > +		&skystar2_rev3_3_cx24120_config, i2c);
> > > +	if (fc->fe == NULL)
> > > +		return 0;
> > > +
> > > +	fc->dev_type = FC_SKYS2_REV33;
> > > +	fc->fc_i2c_adap[2].no_base_addr = 1;
> > > +	if ((dvb_attach(isl6421_attach, fc->fe,
> > > +		&fc->fc_i2c_adap[2].i2c_adap, 0x08, 0, 0, false)
> > > == NULL)) {
> > > +		err("ISL6421 could NOT be attached!");
> > > +		return 0;
> > > +	}
> > > +	info("ISL6421 successfully attached.");
> > > +
> > > +	return 1;
> > > +}
> > > +#else
> > > +#define skystarS2_rev33_attach NULL
> > > +#endif
> > > +
> > >  static struct {
> > >  	flexcop_device_type_t type;
> > >  	int (*attach)(struct flexcop_device *, struct i2c_adapter
> > > *); @@ -632,6 +668,7 @@ static struct {
> > >  	{ FC_AIR_ATSC1, airstar_atsc1_attach },
> > >  	{ FC_CABLE, cablestar2_attach },
> > >  	{ FC_SKY_REV23, skystar2_rev23_attach },
> > > +	{ FC_SKYS2_REV33, skystarS2_rev33_attach },
> > >  };
> > >  
> > >  /* try to figure out the frontend */
> > > diff --git a/drivers/media/common/b2c2/flexcop-misc.c
> > > b/drivers/media/common/b2c2/flexcop-misc.c index
> > > f06f3a9070f5..b8eff235367d 100644 ---
> > > a/drivers/media/common/b2c2/flexcop-misc.c +++
> > > b/drivers/media/common/b2c2/flexcop-misc.c @@ -56,6 +56,7 @@ static
> > > const char *flexcop_device_names[] = { [FC_SKY_REV26]	=
> > > "Sky2PC/SkyStar 2 DVB-S rev 2.6", [FC_SKY_REV27]	=
> > > "Sky2PC/SkyStar 2 DVB-S rev 2.7a/u", [FC_SKY_REV28]	=
> > > "Sky2PC/SkyStar 2 DVB-S rev 2.8",
> > > +	[FC_SKYS2_REV33] = "Sky2PC/SkyStar S2 DVB-S/S2 rev 3.3",
> > >  };
> > >  
> > >  static const char *flexcop_bus_names[] = {
> > > diff --git a/drivers/media/common/b2c2/flexcop-reg.h
> > > b/drivers/media/common/b2c2/flexcop-reg.h index
> > > dc4528dcbb98..835c54d60e74 100644 ---
> > > a/drivers/media/common/b2c2/flexcop-reg.h +++
> > > b/drivers/media/common/b2c2/flexcop-reg.h @@ -24,6 +24,7 @@ typedef
> > > enum { FC_SKY_REV26,
> > >  	FC_SKY_REV27,
> > >  	FC_SKY_REV28,
> > > +	FC_SKYS2_REV33,
> > >  } flexcop_device_type_t;
> > >  
> > >  typedef enum {
> > > diff --git a/drivers/media/dvb-frontends/Kconfig
> > > b/drivers/media/dvb-frontends/Kconfig index
> > > 97c151d5b2e1..7ff3ec4d8ab6 100644 ---
> > > a/drivers/media/dvb-frontends/Kconfig +++
> > > b/drivers/media/dvb-frontends/Kconfig @@ -223,6 +223,13 @@ config
> > > DVB_CX24117 help
> > >  	  A Dual DVB-S/S2 tuner module. Say Y when you want to
> > > support this frontend. 
> > > +config DVB_CX24120
> > > +	tristate "Conexant CX24120 based"
> > > +	depends on DVB_CORE && I2C
> > > +	default m if !MEDIA_SUBDRV_AUTOSELECT
> > > +	help
> > > +	  A DVB-S/DVB-S2 tuner module. Say Y when you want to
> > > support this frontend. +
> > >  config DVB_SI21XX
> > >  	tristate "Silicon Labs SI21XX based"
> > >  	depends on DVB_CORE && I2C
> > > diff --git a/drivers/media/dvb-frontends/Makefile
> > > b/drivers/media/dvb-frontends/Makefile index
> > > 23d399bec804..ebab1b83e1fc 100644 ---
> > > a/drivers/media/dvb-frontends/Makefile +++
> > > b/drivers/media/dvb-frontends/Makefile @@ -83,6 +83,7 @@
> > > obj-$(CONFIG_DVB_DUMMY_FE) += dvb_dummy_fe.o
> > > obj-$(CONFIG_DVB_AF9013) += af9013.o obj-$(CONFIG_DVB_CX24116) +=
> > > cx24116.o obj-$(CONFIG_DVB_CX24117) += cx24117.o
> > > +obj-$(CONFIG_DVB_CX24120) += cx24120.o
> > >  obj-$(CONFIG_DVB_SI21XX) += si21xx.o
> > >  obj-$(CONFIG_DVB_SI2168) += si2168.o
> > >  obj-$(CONFIG_DVB_STV0288) += stv0288.o
> > > diff --git a/drivers/media/dvb-frontends/cx24120.c
> > > b/drivers/media/dvb-frontends/cx24120.c new file mode 100644
> > > index 000000000000..344d8b8e37e5
> > > --- /dev/null
> > > +++ b/drivers/media/dvb-frontends/cx24120.c
> > > @@ -0,0 +1,1577 @@
> > > +/*
> > > +    Conexant cx24120/cx24118 - DVBS/S2 Satellite demod/tuner driver
> > > +
> > > +    Copyright (C) 2008 Patrick Boettcher <pb@linuxtv.org>
> > > +    Copyright (C) 2009 Sergey Tyurin <forum.free-x.de>
> > > +    Updated 2012 by Jannis Achstetter <jannis_achstetter@web.de>
> > > +    Copyright (C) 2015 Jemma Denson <jdenson@gmail.com>
> > > +	April 2015
> > > +	    Refactored & simplified driver
> > > +	    Updated to work with delivery system supplied by DVBv5
> > > +	    Add frequency, fec & pilot to get_frontend
> > > +
> > > +	Cards supported: Technisat Skystar S2
> > > +
> > > +    This program is free software; you can redistribute it and/or
> > > modify
> > > +    it under the terms of the GNU General Public License as
> > > published by
> > > +    the Free Software Foundation; either version 2 of the License,
> > > or
> > > +    (at your option) any later version.
> > > +
> > > +    This program is distributed in the hope that it will be useful,
> > > +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > +    GNU General Public License for more details.
> > > +*/
> > > +
> > > +#include <linux/slab.h>
> > > +#include <linux/kernel.h>
> > > +#include <linux/module.h>
> > > +#include <linux/moduleparam.h>
> > > +#include <linux/init.h>
> > > +#include <linux/firmware.h>
> > > +#include "dvb_frontend.h"
> > > +#include "cx24120.h"
> > > +
> > > +#define CX24120_SEARCH_RANGE_KHZ 5000
> > > +#define CX24120_FIRMWARE "dvb-fe-cx24120-1.20.58.2.fw"
> > > +
> > > +/* cx24120 i2c registers  */
> > > +#define CX24120_REG_CMD_START	(0x00)		/*
> > > write cmd_id */ +#define CX24120_REG_CMD_ARGS
> > > (0x01)		/* write command arguments */ +#define
> > > CX24120_REG_CMD_END	(0x1f)		/* write 0x01 for
> > > end */ + +#define CX24120_REG_MAILBOX	(0x33)
> > > +#define CX24120_REG_FREQ3	(0x34)		/*
> > > frequency */ +#define CX24120_REG_FREQ2	(0x35)
> > > +#define CX24120_REG_FREQ1	(0x36)
> > > +
> > > +#define CX24120_REG_FECMODE	(0x39)		/* FEC
> > > status */ +#define CX24120_REG_STATUS
> > > (0x3a)		/* Tuner status */ +#define
> > > CX24120_REG_SIGSTR_H	(0x3a)		/* Signal
> > > strength high */ +#define CX24120_REG_SIGSTR_L
> > > (0x3b)		/* Signal strength low byte */ +#define
> > > CX24120_REG_QUALITY_H	(0x40)		/* SNR high byte
> > > */ +#define CX24120_REG_QUALITY_L	(0x41)		/*
> > > SNR low byte */ + +#define CX24120_REG_BER_HH
> > > (0x47)		/* BER high byte of high word */ +#define
> > > CX24120_REG_BER_HL	(0x48)		/* BER low byte of
> > > high word */ +#define CX24120_REG_BER_LH
> > > (0x49)		/* BER high byte of low word */ +#define
> > > CX24120_REG_BER_LL	(0x4a)		/* BER low byte of
> > > low word */ + +#define CX24120_REG_UCB_H
> > > (0x50)		/* UCB high byte */ +#define
> > > CX24120_REG_UCB_L	(0x51)		/* UCB low byte  */
> > > + +#define CX24120_REG_CLKDIV	(0xe6) +#define
> > > CX24120_REG_RATEDIV	(0xf0) + +#define
> > > CX24120_REG_REVISION	(0xff)		/* Chip revision
> > > (ro) */
> > 
> > I don't see any need for parenthesis on the above defines.
> > 
> > > +
> > > +
> > > +/* Command messages */
> > > +enum command_message_id {
> > > +	CMD_VCO_SET		= 0x10,		/*
> > > cmd.len = 12; */
> > > +	CMD_TUNEREQUEST		= 0x11,		/*
> > > cmd.len = 15; */ +
> > > +	CMD_MPEG_ONOFF		= 0x13,		/*
> > > cmd.len = 4; */
> > > +	CMD_MPEG_INIT		= 0x14,		/*
> > > cmd.len = 7; */
> > > +	CMD_BANDWIDTH		= 0x15,		/*
> > > cmd.len = 12; */
> > > +	CMD_CLOCK_READ		= 0x16,		/*
> > > read clock */
> > > +	CMD_CLOCK_SET		= 0x17,		/*
> > > cmd.len = 10; */ +
> > > +	CMD_DISEQC_MSG1		= 0x20,		/*
> > > cmd.len = 11; */
> > > +	CMD_DISEQC_MSG2		= 0x21,		/*
> > > cmd.len = d->msg_len + 6; */
> > > +	CMD_SETVOLTAGE		= 0x22,		/*
> > > cmd.len = 2; */
> > > +	CMD_SETTONE		= 0x23,		/*
> > > cmd.len = 4; */
> > > +	CMD_DISEQC_BURST	= 0x24,		/* cmd.len
> > > not used !!! */ +
> > > +	CMD_READ_SNR		= 0x1a,		/* Read
> > > signal strength */
> > > +	CMD_START_TUNER		=
> > > 0x1b,		/* ??? */ +
> > > +	CMD_FWVERSION		= 0x35,
> > > +
> > > +	CMD_TUNER_INIT		= 0x3c,		/*
> > > cmd.len = 0x03; */ +};
> > > +
> > > +#define CX24120_MAX_CMD_LEN	30
> > > +
> > > +/* pilot mask */
> > > +#define CX24120_PILOT_OFF	(0x00)
> > > +#define CX24120_PILOT_ON	(0x40)
> > > +#define CX24120_PILOT_AUTO	(0x80)
> > > +
> > > +/* signal status */
> > > +#define CX24120_HAS_SIGNAL	(0x01)
> > > +#define CX24120_HAS_CARRIER	(0x02)
> > > +#define CX24120_HAS_VITERBI	(0x04)
> > > +#define CX24120_HAS_LOCK	(0x08)
> > > +#define CX24120_HAS_UNK1	(0x10)
> > > +#define CX24120_HAS_UNK2	(0x20)
> > > +#define CX24120_STATUS_MASK	(0x0f)
> > > +#define CX24120_SIGNAL_MASK	(0xc0)
> > 
> > Same as the above.
> > 
> > > +
> > > +#define info(args...) do { printk(KERN_INFO "cx24120: "); \
> > > +			printk(args); } while (0)
> > > +#define err(args...) do {  printk(KERN_ERR "cx24120: ### ERROR:
> > > "); \
> > > +			printk(args); } while (0)
> > 
> > We're also not defining printk macros anymore on newer drivers.
> > For I2C drivers, the best is to use the dev_info/dev_err macros,
> > as it provides the information about the I2C bus too at dmesg.
> > 
> > Also, it makes easier for the Kernel janitors to use their tools to
> > check/improve the debug/info/error code.
> > 
> > > +
> > > +
> > > +/* The Demod/Tuner can't easily provide these, we cache them */
> > > +struct cx24120_tuning {
> > > +	u32 frequency;
> > > +	u32 symbol_rate;
> > > +	fe_spectral_inversion_t inversion;
> > > +	fe_code_rate_t fec;
> > > +
> > > +	fe_delivery_system_t delsys;
> > > +	fe_modulation_t modulation;
> > > +	fe_pilot_t pilot;
> > > +
> > > +	/* Demod values */
> > > +	u8 fec_val;
> > > +	u8 fec_mask;
> > > +	u8 clkdiv;
> > > +	u8 ratediv;
> > > +	u8 inversion_val;
> > > +	u8 pilot_val;
> > > +};
> > > +
> > > +
> > > +/* Private state */
> > > +struct cx24120_state {
> > > +	struct i2c_adapter *i2c;
> > > +	const struct cx24120_config *config;
> > > +	struct dvb_frontend frontend;
> > > +
> > > +	u8 cold_init;
> > > +	u8 mpeg_enabled;
> > > +
> > > +	/* current and next tuning parameters */
> > > +	struct cx24120_tuning dcur;
> > > +	struct cx24120_tuning dnxt;
> > > +};
> > > +
> > > +
> > > +/* Command message to firmware */
> > > +struct cx24120_cmd {
> > > +	u8 id;
> > > +	u8 len;
> > > +	u8 arg[CX24120_MAX_CMD_LEN];
> > > +};
> > > +
> > > +
> > > +/* Read single register */
> > > +static int cx24120_readreg(struct cx24120_state *state, u8 reg)
> > > +{
> > > +	int ret;
> > > +	u8 buf = 0;
> > > +	struct i2c_msg msg[] = {
> > > +		{	.addr = state->config->i2c_addr,
> > > +			.flags = 0,
> > > +			.len = 1,
> > > +			.buf = &reg	},
> > > +
> > > +		{	.addr = state->config->i2c_addr,
> > > +			.flags = I2C_M_RD,
> > > +			.len = 1,
> > > +			.buf = &buf	}
> > > +	};
> > 
> > The CodingStyle should actually be:
> > 
> > 	struct i2c_msg msg[] = {
> > 		{
> > 			.addr = state->config->i2c_addr,
> > 			.flags = 0,
> > 			.len = 1,
> > 			.buf = &reg
> > 		}, {
> > 			.addr = state->config->i2c_addr,
> > 			.flags = I2C_M_RD,
> > 			.len = 1,
> > 			.buf = &buf
> > 		}
> > 	};
> > 
> > Please check similar places on the code to fix the CodingStyle.
> > 
> > > +	ret = i2c_transfer(state->i2c, msg, 2);
> > > +	if (ret != 2) {
> > > +		err("Read error: reg=0x%02x, ret=0x%02x)\n", reg,
> > > ret);
> > 
> > It doesn't make sense to print error code (ret var) in hexadecimal.
> > 
> > > +		return ret;
> > > +	}
> > > +
> > > +	dev_dbg(&state->i2c->dev, "%s: reg=0x%02x; data=0x%02x\n",
> > > +		__func__, reg, buf);
> > > +
> > > +	return buf;
> > > +}
> > > +
> > > +
> > > +/* Write single register */
> > > +static int cx24120_writereg(struct cx24120_state *state, u8 reg,
> > > u8 data) +{
> > > +	u8 buf[] = { reg, data };
> > > +	struct i2c_msg msg = {
> > > +		.addr = state->config->i2c_addr,
> > > +		.flags = 0,
> > > +		.buf = buf,
> > > +		.len = 2 };
> > > +	int ret;
> > > +
> > > +	ret = i2c_transfer(state->i2c, &msg, 1);
> > > +	if (ret != 1) {
> > > +		err("Write error: i2c_write error(err == %i,
> > > 0x%02x: 0x%02x)\n",
> > > +				 ret, reg, data);
> > 
> > It doesn't make sense to print error code (ret var) in hexadecimal.
> > 
> > > +		return ret;
> > > +	}
> > > +
> > > +	dev_dbg(&state->i2c->dev, "%s: reg=0x%02x; data=0x%02x\n",
> > > +		__func__, reg, data);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +
> > > +/* Write multiple registers */
> > > +static int cx24120_writeregN(struct cx24120_state *state,
> > > +			u8 reg, const u8 *values, u16 len, u8 incr)
> > > +{
> > > +	int ret;
> > > +	u8 buf[5]; /* maximum 4 data bytes at once - flexcop
> > > limitation
> > > +			(very limited i2c-interface this one) */
> > 
> > Hmm... if the limit is at flexcop, then the best is to not be add such
> > restriction here, but at the flexcop code, and passing the max limit
> > that used for the I2C transfer as a parameter at the attach
> > structure, just like other frontend and tuner drivers do.
> > 
> > Also, this limit is hardcoded here. Please use a define instead.
> > 
> > > +
> > > +	struct i2c_msg msg = {
> > > +		.addr = state->config->i2c_addr,
> > > +		.flags = 0,
> > > +		.buf = buf,
> > > +		.len = len };
> > > +
> > > +	while (len) {
> > > +		buf[0] = reg;
> > > +		msg.len = len > 4 ? 4 : len;
> > 
> > Again, don't hardcode the max buf size here.
> > 
> > > +		memcpy(&buf[1], values, msg.len);
> > > +
> > > +		len  -= msg.len;		/* data length
> > > revers counter */
> > > +		values += msg.len;		/* incr data
> > > pointer */ +
> > > +		if (incr)
> > > +			reg += msg.len;
> > > +		msg.len++;			/* don't forget
> > > the addr byte */ +
> > > +		ret = i2c_transfer(state->i2c, &msg, 1);
> > > +		if (ret != 1) {
> > > +			err("i2c_write error(err == %i,
> > > 0x%02x)\n", ret, reg);
> > > +			return ret;
> > > +		}
> > > +
> > > +		dev_dbg(&state->i2c->dev,
> > > +			"%s: reg=0x%02x;
> > > data=0x%02x,0x%02x,0x%02x,0x%02x\n",
> > > +			__func__, reg,
> > > +			buf[1], buf[2], buf[3], buf[4]);
> > 
> > Please, use the %*ph macro instead (%*ph is likely the best here),
> > for the data, as documented at Documentation/printk-formats.txt.
> > 
> > This allows you to pass msg.len, printing only the elements of the
> > buffer that were actually filled.
> > 
> > > +
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +
> > > +static struct dvb_frontend_ops cx24120_ops;
> > > +
> > > +struct dvb_frontend *cx24120_attach(const struct cx24120_config
> > > *config,
> > > +			struct i2c_adapter *i2c)
> > > +{
> > > +	struct cx24120_state *state = NULL;
> > > +	int demod_rev;
> > > +
> > > +	info("Conexant cx24120/cx24118 - DVBS/S2 Satellite
> > > demod/tuner\n");
> > > +	state = kzalloc(sizeof(struct cx24120_state),
> > > +						GFP_KERNEL);
> > 
> > The above likely can be put into just one line. Only break on multiple
> > lines when need. In such case, we align on a different way, like:
> > 
> > 	state =
> > kzalloc(....................................................,
> > GFP_KERNEL);
> > 
> > 
> > > +	if (state == NULL) {
> > > +		err("Unable to allocate memory for
> > > cx24120_state\n");
> > > +		goto error;
> > > +	}
> > > +
> > > +	/* setup the state */
> > > +	state->config = config;
> > > +	state->i2c = i2c;
> > > +
> > > +	/* check if the demod is present and has proper type */
> > > +	demod_rev = cx24120_readreg(state, CX24120_REG_REVISION);
> > > +	switch (demod_rev) {
> > > +	case 0x07:
> > > +		info("Demod cx24120 rev. 0x07 detected.\n");
> > > +		break;
> > > +	case 0x05:
> > > +		info("Demod cx24120 rev. 0x05 detected.\n");
> > > +		break;
> > > +	default:
> > > +		err("Unsupported demod revision: 0x%x detected.\n",
> > > +			demod_rev);
> > > +		goto error;
> > > +	}
> > > +
> > > +	/* create dvb_frontend */
> > > +	state->cold_init = 0;
> > > +	memcpy(&state->frontend.ops, &cx24120_ops,
> > > +			sizeof(struct dvb_frontend_ops));
> > 
> > Also, either put on one line (if it fits on 80-column) or align the
> > second parameter of the function.
> > 
> > 
> > > +	state->frontend.demodulator_priv = state;
> > > +
> > > +	info("Conexant cx24120/cx24118 attached.\n");
> > > +	return &state->frontend;
> > > +
> > > +error:
> > > +	kfree(state);
> > > +	return NULL;
> > > +}
> > > +EXPORT_SYMBOL(cx24120_attach);
> > > +
> > > +static int cx24120_test_rom(struct cx24120_state *state)
> > > +{
> > > +	int err, ret;
> > > +
> > > +	err = cx24120_readreg(state, 0xfd);
> > > +	if (err & 4) {
> > > +		ret = cx24120_readreg(state, 0xdf) & 0xfe;
> > > +		err = cx24120_writereg(state, 0xdf, ret);
> > > +	}
> > > +	return err;
> > > +}
> > > +
> > > +
> > > +static int cx24120_read_snr(struct dvb_frontend *fe, u16 *snr)
> > > +{
> > > +	struct cx24120_state *state = fe->demodulator_priv;
> > > +
> > > +	*snr =  (cx24120_readreg(state, CX24120_REG_QUALITY_H)<<8)
> > > |
> > > +		(cx24120_readreg(state, CX24120_REG_QUALITY_L));
> > > +	dev_dbg(&state->i2c->dev, "%s: read SNR index = %d\n",
> > > +			__func__, *snr);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +
> > > +static int cx24120_read_ber(struct dvb_frontend *fe, u32 *ber)
> > > +{
> > > +	struct cx24120_state *state = fe->demodulator_priv;
> > > +
> > > +	*ber =  (cx24120_readreg(state, CX24120_REG_BER_HH) <<
> > > 24)	|
> > > +		(cx24120_readreg(state, CX24120_REG_BER_HL) <<
> > > 16)	|
> > > +		(cx24120_readreg(state, CX24120_REG_BER_LH)  <<
> > > 8)	|
> > > +		 cx24120_readreg(state, CX24120_REG_BER_LL);
> > > +	dev_dbg(&state->i2c->dev, "%s: read BER index = %d\n",
> > > +			__func__, *ber);
> > > +
> > > +	return 0;
> > > +}
> > 
> > Please implement it using DVBv5 way. You can still provide a DVBv3
> > fallback, but the best is to use the already cached value.
> > 
> > > +
> > > +static int cx24120_msg_mpeg_output_global_config(struct
> > > cx24120_state *state,
> > > +			u8 flag);
> > > +
> > > +/* Check if we're running a command that needs to disable mpeg out
> > > */ +static void cx24120_check_cmd(struct cx24120_state *state, u8
> > > id) +{
> > > +	switch (id) {
> > > +	case CMD_TUNEREQUEST:
> > > +	case CMD_CLOCK_READ:
> > > +	case CMD_DISEQC_MSG1:
> > > +	case CMD_DISEQC_MSG2:
> > > +	case CMD_SETVOLTAGE:
> > > +	case CMD_SETTONE:
> > > +		cx24120_msg_mpeg_output_global_config(state, 0);
> > > +		/* Old driver would do a msleep(100) here */
> > > +	default:
> > > +		return;
> > > +	}
> > > +}
> > > +
> > > +
> > > +/* Send a message to the firmware */
> > > +static int cx24120_message_send(struct cx24120_state *state,
> > > +			struct cx24120_cmd *cmd)
> > > +{
> > > +	int ret, ficus;
> > > +
> > > +	if (state->mpeg_enabled) {
> > > +		/* Disable mpeg out on certain commands */
> > > +		cx24120_check_cmd(state, cmd->id);
> > > +	}
> > > +
> > > +	ret = cx24120_writereg(state, CX24120_REG_CMD_START,
> > > cmd->id);
> > > +	ret = cx24120_writeregN(state, CX24120_REG_CMD_ARGS,
> > > &cmd->arg[0],
> > > +				cmd->len, 1);
> > > +	ret = cx24120_writereg(state, CX24120_REG_CMD_END, 0x01);
> > > +
> > > +	ficus = 1000;
> > > +	while (cx24120_readreg(state, CX24120_REG_CMD_END)) {
> > > +		msleep(20);
> > > +		ficus -= 20;
> > > +		if (ficus == 0) {
> > > +			err("Error sending message to firmware\n");
> > > +			return -EREMOTEIO;
> > > +		}
> > > +	}
> > > +	dev_dbg(&state->i2c->dev, "%s: Successfully send message
> > > 0x%02x\n",
> > > +		__func__, cmd->id);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/* Send a message and fill arg[] with the results */
> > > +static int cx24120_message_sendrcv(struct cx24120_state *state,
> > > +			struct cx24120_cmd *cmd, u8 numreg)
> > > +{
> > > +	int ret, i;
> > > +
> > > +	if (numreg > CX24120_MAX_CMD_LEN) {
> > > +		err("Too many registers to read. cmd->reg = %d",
> > > numreg);
> > > +		return -EREMOTEIO;
> > > +	}
> > > +
> > > +	ret = cx24120_message_send(state, cmd);
> > > +	if (ret != 0)
> > > +		return ret;
> > > +
> > > +	if (!numreg)
> > > +		return 0;
> > > +
> > > +	/* Read numreg registers starting from register cmd->len */
> > > +	for (i = 0; i < numreg; i++)
> > > +		cmd->arg[i] = cx24120_readreg(state,
> > > (cmd->len+i+1)); +
> > > +	return 0;
> > > +}
> > > +
> > > +
> > > +
> > > +static int cx24120_read_signal_strength(struct dvb_frontend *fe,
> > > +			u16 *signal_strength)
> > > +{
> > > +	struct cx24120_state *state = fe->demodulator_priv;
> > > +	struct cx24120_cmd cmd;
> > > +	int ret, sigstr_h, sigstr_l;
> > > +
> > > +	cmd.id = CMD_READ_SNR;
> > > +	cmd.len = 1;
> > > +	cmd.arg[0] = 0x00;
> > > +
> > > +	ret = cx24120_message_send(state, &cmd);
> > > +	if (ret != 0) {
> > > +		err("error reading signal strength\n");
> > > +		return -EREMOTEIO;
> > > +	}
> > > +
> > > +	/* raw */
> > > +	sigstr_h = (cx24120_readreg(state, CX24120_REG_SIGSTR_H)
> > > >> 6) << 8;
> > > +	sigstr_l = cx24120_readreg(state, CX24120_REG_SIGSTR_L);
> > > +	dev_dbg(&state->i2c->dev, "%s: Signal strength from
> > > firmware= 0x%x\n",
> > > +			__func__, (sigstr_h | sigstr_l));
> > > +
> > > +	/* cooked */
> > > +	*signal_strength = ((sigstr_h | sigstr_l)  << 5) &
> > > 0x0000ffff;
> > > +	dev_dbg(&state->i2c->dev, "%s: Signal strength= 0x%x\n",
> > > +			__func__, *signal_strength);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +
> > > +static int cx24120_msg_mpeg_output_global_config(struct
> > > cx24120_state *state,
> > > +			u8 enable)
> > > +{
> > > +	struct cx24120_cmd cmd;
> > > +	int ret;
> > > +
> > > +	cmd.id = CMD_MPEG_ONOFF;
> > > +	cmd.len = 4;
> > > +	cmd.arg[0] = 0x01;
> > > +	cmd.arg[1] = 0x00;
> > > +	cmd.arg[2] = enable ? 0 : (u8)(-1);
> > > +	cmd.arg[3] = 0x01;
> > > +
> > > +	ret = cx24120_message_send(state, &cmd);
> > > +	if (ret != 0) {
> > > +		dev_dbg(&state->i2c->dev,
> > > +			"%s: Failed to set MPEG output to %s\n",
> > > +			__func__,
> > > +			(enable)?"enabled":"disabled");
> > > +		return ret;
> > > +	}
> > > +
> > > +	state->mpeg_enabled = enable;
> > > +	dev_dbg(&state->i2c->dev, "%s: MPEG output %s\n",
> > > +		__func__,
> > > +		(enable)?"enabled":"disabled");
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +
> > > +static int cx24120_msg_mpeg_output_config(struct cx24120_state
> > > *state, u8 seq) +{
> > > +	struct cx24120_cmd cmd;
> > > +	struct cx24120_initial_mpeg_config i =
> > > +			state->config->initial_mpeg_config;
> > > +
> > > +	cmd.id = CMD_MPEG_INIT;
> > > +	cmd.len = 7;
> > > +	cmd.arg[0] = seq;		/* sequental number - can
> > > be 0,1,2 */
> > > +	cmd.arg[1] = ((i.x1 & 0x01) << 1) | ((i.x1 >> 1) & 0x01);
> > > +	cmd.arg[2] = 0x05;
> > > +	cmd.arg[3] = 0x02;
> > > +	cmd.arg[4] = ((i.x2 >> 1) & 0x01);
> > > +	cmd.arg[5] = (i.x2 & 0xf0) | (i.x3 & 0x0f);
> > > +	cmd.arg[6] = 0x10;
> > > +
> > > +	return cx24120_message_send(state, &cmd);
> > > +}
> > > +
> > > +
> > > +static int cx24120_diseqc_send_burst(struct dvb_frontend *fe,
> > > +			fe_sec_mini_cmd_t burst)
> > > +{
> > > +	struct cx24120_state *state = fe->demodulator_priv;
> > > +	struct cx24120_cmd cmd;
> > > +
> > > +	/* Yes, cmd.len is set to zero. The old driver
> > > +	 * didn't specify any len, but also had a
> > > +	 * memset 0 before every use of the cmd struct
> > > +	 * which would have set it to zero.
> > > +	 * This quite probably needs looking into.
> > > +	 */
> > > +	cmd.id = CMD_DISEQC_BURST;
> > > +	cmd.len = 0;
> > > +	cmd.arg[0] = 0x00;
> > > +	if (burst)
> > > +		cmd.arg[1] = 0x01;
> > > +	dev_dbg(&state->i2c->dev, "%s: burst sent.\n", __func__);
> > > +
> > > +	return cx24120_message_send(state, &cmd);
> > > +}
> > > +
> > > +
> > > +static int cx24120_set_tone(struct dvb_frontend *fe,
> > > fe_sec_tone_mode_t tone) +{
> > > +	struct cx24120_state *state = fe->demodulator_priv;
> > > +	struct cx24120_cmd cmd;
> > > +
> > > +	dev_dbg(&state->i2c->dev, "%s(%d)\n",
> > > +			__func__, tone);
> > > +
> > > +	if ((tone != SEC_TONE_ON) && (tone != SEC_TONE_OFF)) {
> > > +		err("Invalid tone=%d\n", tone);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	cmd.id = CMD_SETTONE;
> > > +	cmd.len = 4;
> > > +	cmd.arg[0] = 0x00;
> > > +	cmd.arg[1] = 0x00;
> > > +	cmd.arg[2] = 0x00;
> > > +	cmd.arg[3] = (tone == SEC_TONE_ON)?0x01:0x00;
> > > +
> > > +	return cx24120_message_send(state, &cmd);
> > > +}
> > > +
> > > +
> > > +static int cx24120_set_voltage(struct dvb_frontend *fe,
> > > +			fe_sec_voltage_t voltage)
> > > +{
> > > +	struct cx24120_state *state = fe->demodulator_priv;
> > > +	struct cx24120_cmd cmd;
> > > +
> > > +	dev_dbg(&state->i2c->dev, "%s(%d)\n",
> > > +			__func__, voltage);
> > > +
> > > +	cmd.id = CMD_SETVOLTAGE;
> > > +	cmd.len = 2;
> > > +	cmd.arg[0] = 0x00;
> > > +	cmd.arg[1] = (voltage == SEC_VOLTAGE_18)?0x01:0x00;
> > > +
> > > +	return cx24120_message_send(state, &cmd);
> > > +}
> > > +
> > > +
> > > +static int cx24120_send_diseqc_msg(struct dvb_frontend *fe,
> > > +			struct dvb_diseqc_master_cmd *d)
> > > +{
> > > +	struct cx24120_state *state = fe->demodulator_priv;
> > > +	struct cx24120_cmd cmd;
> > > +	int back_count;
> > > +
> > > +	dev_dbg(&state->i2c->dev, "%s()\n", __func__);
> > > +
> > > +	cmd.id = CMD_DISEQC_MSG1;
> > > +	cmd.len = 11;
> > > +	cmd.arg[0] = 0x00;
> > > +	cmd.arg[1] = 0x00;
> > > +	cmd.arg[2] = 0x03;
> > > +	cmd.arg[3] = 0x16;
> > > +	cmd.arg[4] = 0x28;
> > > +	cmd.arg[5] = 0x01;
> > > +	cmd.arg[6] = 0x01;
> > > +	cmd.arg[7] = 0x14;
> > > +	cmd.arg[8] = 0x19;
> > > +	cmd.arg[9] = 0x14;
> > > +	cmd.arg[10] = 0x1e;
> > > +
> > > +	if (cx24120_message_send(state, &cmd)) {
> > > +		err("send 1st message(0x%x) failed\n", cmd.id);
> > > +		return -EREMOTEIO;
> > > +	}
> > > +
> > > +	cmd.id = CMD_DISEQC_MSG2;
> > > +	cmd.len = d->msg_len + 6;
> > > +	cmd.arg[0] = 0x00;
> > > +	cmd.arg[1] = 0x01;
> > > +	cmd.arg[2] = 0x02;
> > > +	cmd.arg[3] = 0x00;
> > > +	cmd.arg[4] = 0x00;
> > > +	cmd.arg[5] = d->msg_len;
> > > +
> > > +	memcpy(&cmd.arg[6], &d->msg, d->msg_len);
> > > +
> > > +	if (cx24120_message_send(state, &cmd)) {
> > > +		err("send 2nd message(0x%x) failed\n", cmd.id);
> > > +		return -EREMOTEIO;
> > > +	}
> > > +
> > > +	back_count = 500;
> > > +	do {
> > > +		if (!(cx24120_readreg(state, 0x93) & 0x01)) {
> > > +			dev_dbg(&state->i2c->dev,
> > > +				"%s: diseqc sequence sent
> > > success\n",
> > > +				__func__);
> > > +			return 0;
> > > +		}
> > > +		msleep(20);
> > > +		back_count -= 20;
> > > +	} while (back_count);
> > > +
> > > +	err("Too long waiting for diseqc.\n");
> > > +	return -ETIMEDOUT;
> > > +}
> > > +
> > > +
> > > +/* Read current tuning status */
> > > +static int cx24120_read_status(struct dvb_frontend *fe,
> > > fe_status_t *status) +{
> > > +	struct cx24120_state *state = fe->demodulator_priv;
> > > +	int lock;
> > > +
> > > +	lock = cx24120_readreg(state, CX24120_REG_STATUS);
> > > +
> > > +	dev_dbg(&state->i2c->dev, "%s() status = 0x%02x\n",
> > > +		__func__, lock);
> > > +
> > > +	*status = 0;
> > > +
> > > +	if (lock & CX24120_HAS_SIGNAL)
> > > +		*status = FE_HAS_SIGNAL;
> > > +	if (lock & CX24120_HAS_CARRIER)
> > > +		*status |= FE_HAS_CARRIER;
> > > +	if (lock & CX24120_HAS_VITERBI)
> > > +		*status |= FE_HAS_VITERBI | FE_HAS_SYNC;
> > > +	if (lock & CX24120_HAS_LOCK)
> > > +		*status |= FE_HAS_LOCK;
> > > +
> > > +	/* TODO: is FE_HAS_SYNC in the right place?
> > > +	 * Other cx241xx drivers have this slightly
> > > +	 * different */
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +
> > > +/* FEC & modulation lookup table
> > > + * Used for decoding the REG_FECMODE register
> > > + * once tuned in.
> > > + */
> > > +static struct cx24120_modfec {
> > > +	fe_delivery_system_t delsys;
> > > +	fe_modulation_t mod;
> > > +	fe_code_rate_t fec;
> > > +	u8 val;
> > > +} modfec_lookup_table[] = {
> > > +/*delsys	mod	fec		val */
> > > +{ SYS_DVBS,	QPSK,	FEC_1_2,	0x01 },
> > > +{ SYS_DVBS,	QPSK,	FEC_2_3,	0x02 },
> > > +{ SYS_DVBS,	QPSK,	FEC_3_4,	0x03 },
> > > +{ SYS_DVBS,	QPSK,	FEC_4_5,	0x04 },
> > > +{ SYS_DVBS,	QPSK,	FEC_5_6,	0x05 },
> > > +{ SYS_DVBS,	QPSK,	FEC_6_7,	0x06 },
> > > +{ SYS_DVBS,	QPSK,	FEC_7_8,	0x07 },
> > > +
> > > +{ SYS_DVBS2,	QPSK,	FEC_1_2,	0x04 },
> > > +{ SYS_DVBS2,	QPSK,	FEC_3_5,	0x05 },
> > > +{ SYS_DVBS2,	QPSK,	FEC_2_3,	0x06 },
> > > +{ SYS_DVBS2,	QPSK,	FEC_3_4,	0x07 },
> > > +{ SYS_DVBS2,	QPSK,	FEC_4_5,	0x08 },
> > > +{ SYS_DVBS2,	QPSK,	FEC_5_6,	0x09 },
> > > +{ SYS_DVBS2,	QPSK,	FEC_8_9,	0x0a },
> > > +{ SYS_DVBS2,	QPSK,	FEC_9_10,	0x0b },
> > > +
> > > +{ SYS_DVBS2,	PSK_8,	FEC_3_5,	0x0c },
> > > +{ SYS_DVBS2,	PSK_8,	FEC_2_3,	0x0d },
> > > +{ SYS_DVBS2,	PSK_8,	FEC_3_4,	0x0e },
> > > +{ SYS_DVBS2,	PSK_8,	FEC_5_6,	0x0f },
> > > +{ SYS_DVBS2,	PSK_8,	FEC_8_9,	0x10 },
> > > +{ SYS_DVBS2,	PSK_8,	FEC_9_10,	0x11 },
> > > +};
> > 
> > 
> > This table is badly aligned.
> > 
> > > +
> > > +
> > > +/* Retrieve current fec, modulation & pilot values */
> > > +static int cx24120_get_fec(struct dvb_frontend *fe)
> > > +{
> > > +	struct dtv_frontend_properties *c =
> > > &fe->dtv_property_cache;
> > > +	struct cx24120_state *state = fe->demodulator_priv;
> > > +	int idx;
> > > +	int ret;
> > > +	int GettedFEC;
> > > +
> > > +	dev_dbg(&state->i2c->dev, "%s()\n", __func__);
> > > +
> > > +	ret = cx24120_readreg(state, CX24120_REG_FECMODE);
> > > +	GettedFEC = ret & 0x3f;		/* Lower 6 bits */
> > > +
> > > +	dev_dbg(&state->i2c->dev, "%s: Get FEC: %d\n", __func__,
> > > GettedFEC); +
> > > +	for (idx = 0; idx < ARRAY_SIZE(modfec_lookup_table);
> > > idx++) {
> > > +		if (modfec_lookup_table[idx].delsys !=
> > > state->dcur.delsys)
> > > +			continue;
> > > +		if (modfec_lookup_table[idx].val != GettedFEC)
> > > +			continue;
> > > +
> > > +		break;	/* found */
> > > +	}
> > > +
> > > +	if (idx >= ARRAY_SIZE(modfec_lookup_table)) {
> > > +		dev_dbg(&state->i2c->dev, "%s: Couldn't find
> > > fec!\n",
> > > +			__func__);
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	/* save values back to cache */
> > > +	c->modulation = modfec_lookup_table[idx].mod;
> > > +	c->fec_inner = modfec_lookup_table[idx].fec;
> > > +	c->pilot = (ret & 0x80) ? PILOT_ON : PILOT_OFF;
> > > +
> > > +	dev_dbg(&state->i2c->dev,
> > > +		"%s: mod(%d), fec(%d), pilot(%d)\n",
> > > +		__func__,
> > > +		c->modulation, c->fec_inner, c->pilot);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +
> > > +/* Clock ratios lookup table
> > > + *
> > > + * Values obtained from much larger table in old driver
> > > + * which had numerous entries which would never match.
> > > + *
> > > + * There's probably some way of calculating these but I
> > > + * can't determine the pattern
> > > +*/
> > > +static struct cx24120_clock_ratios_table {
> > > +	fe_delivery_system_t delsys;
> > > +	fe_pilot_t pilot;
> > > +	fe_modulation_t mod;
> > > +	fe_code_rate_t fec;
> > > +	u32 m_rat;
> > > +	u32 n_rat;
> > > +	u32 rate;
> > > +} clock_ratios_table[] = {
> > > +/*delsys	pilot		mod	fec
> > > m_rat	n_rat	rate */ +{ SYS_DVBS2,
> > > PILOT_OFF,	QPSK,	FEC_1_2,	273088,
> > > 254505,	274 }, +{ SYS_DVBS2,	PILOT_OFF,
> > > QPSK,	FEC_3_5,	17272,	13395,	330 },
> > > +{ SYS_DVBS2,	PILOT_OFF,	QPSK,	FEC_2_3,
> > > 24344,	16967,	367 }, +{ SYS_DVBS2,
> > > PILOT_OFF,	QPSK,	FEC_3_4,	410788,
> > > 254505,	413 }, +{ SYS_DVBS2,	PILOT_OFF,
> > > QPSK,	FEC_4_5,	438328,	254505,	440 },
> > > +{ SYS_DVBS2,	PILOT_OFF,	QPSK,	FEC_5_6,
> > > 30464,	16967,	459 }, +{ SYS_DVBS2,
> > > PILOT_OFF,	QPSK,	FEC_8_9,	487832,
> > > 254505,	490 }, +{ SYS_DVBS2,	PILOT_OFF,
> > > QPSK,	FEC_9_10,	493952,	254505,	496 },
> > > +{ SYS_DVBS2,	PILOT_OFF,	PSK_8,
> > > FEC_3_5,	328168,	169905,	494 },
> > > +{ SYS_DVBS2,	PILOT_OFF,	PSK_8,
> > > FEC_2_3,	24344,	11327,	550 },
> > > +{ SYS_DVBS2,	PILOT_OFF,	PSK_8,
> > > FEC_3_4,	410788,	169905,	618 },
> > > +{ SYS_DVBS2,	PILOT_OFF,	PSK_8,
> > > FEC_5_6,	30464,	11327,	688 },
> > > +{ SYS_DVBS2,	PILOT_OFF,	PSK_8,
> > > FEC_8_9,	487832,	169905,	735 },
> > > +{ SYS_DVBS2,	PILOT_OFF,	PSK_8,
> > > FEC_9_10,	493952,	169905,	744 },
> > > +{ SYS_DVBS2,	PILOT_ON,	QPSK,	FEC_1_2,
> > > 273088,	260709,	268 }, +{ SYS_DVBS2,
> > > PILOT_ON,	QPSK,	FEC_3_5,	328168,
> > > 260709,	322 }, +{ SYS_DVBS2,	PILOT_ON,
> > > QPSK,	FEC_2_3,	121720,	86903,	358 },
> > > +{ SYS_DVBS2,	PILOT_ON,	QPSK,	FEC_3_4,
> > > 410788,	260709,	403 }, +{ SYS_DVBS2,
> > > PILOT_ON,	QPSK,	FEC_4_5,	438328,
> > > 260709,	430 }, +{ SYS_DVBS2,	PILOT_ON,
> > > QPSK,	FEC_5_6,	152320,	86903,	448 },
> > > +{ SYS_DVBS2,	PILOT_ON,	QPSK,	FEC_8_9,
> > > 487832,	260709,	479 }, +{ SYS_DVBS2,
> > > PILOT_ON,	QPSK,	FEC_9_10,	493952,
> > > 260709,	485 }, +{ SYS_DVBS2,	PILOT_ON,
> > > PSK_8,	FEC_3_5,	328168,	173853,	483 },
> > > +{ SYS_DVBS2,	PILOT_ON,	PSK_8,	FEC_2_3,
> > > 121720,	57951,	537 }, +{ SYS_DVBS2,
> > > PILOT_ON,	PSK_8,	FEC_3_4,	410788,
> > > 173853,	604 }, +{ SYS_DVBS2,	PILOT_ON,
> > > PSK_8,	FEC_5_6,	152320,	57951,	672 },
> > > +{ SYS_DVBS2,	PILOT_ON,	PSK_8,	FEC_8_9,
> > > 487832,	173853,	718 }, +{ SYS_DVBS2,
> > > PILOT_ON,	PSK_8,	FEC_9_10,	493952,
> > > 173853,	727 }, +{ SYS_DVBS,	PILOT_OFF,
> > > QPSK,	FEC_1_2,	152592,	152592,	256 },
> > > +{ SYS_DVBS,	PILOT_OFF,	QPSK,	FEC_2_3,
> > > 305184,	228888,	341 }, +{ SYS_DVBS,
> > > PILOT_OFF,	QPSK,	FEC_3_4,	457776,
> > > 305184,	384 }, +{ SYS_DVBS,	PILOT_OFF,
> > > QPSK,	FEC_5_6,	762960,	457776,	427 },
> > > +{ SYS_DVBS,	PILOT_OFF,	QPSK,	FEC_7_8,
> > > 1068144, 610368, 448 }, +};
> > 
> > This table is badly aligned.
> > 
> > > +
> > > +
> > > +/* Set clock ratio from lookup table */
> > > +static void cx24120_set_clock_ratios(struct dvb_frontend *fe)
> > > +{
> > > +	struct dtv_frontend_properties *c =
> > > &fe->dtv_property_cache;
> > > +	struct cx24120_state *state = fe->demodulator_priv;
> > > +	struct cx24120_cmd cmd;
> > > +	int ret, idx;
> > > +
> > > +	/* Find fec, modulation, pilot */
> > > +	ret = cx24120_get_fec(fe);
> > > +	if (ret != 0)
> > > +		return;
> > > +
> > > +	/* Find the clock ratios in the lookup table */
> > > +	for (idx = 0; idx < ARRAY_SIZE(clock_ratios_table); idx++)
> > > {
> > > +		if (clock_ratios_table[idx].delsys !=
> > > state->dcur.delsys)
> > > +			continue;
> > > +		if (clock_ratios_table[idx].mod != c->modulation)
> > > +			continue;
> > > +		if (clock_ratios_table[idx].fec != c->fec_inner)
> > > +			continue;
> > > +		if (clock_ratios_table[idx].pilot != c->pilot)
> > > +			continue;
> > > +
> > > +		break;		/* found */
> > > +	}
> > > +
> > > +	if (idx >= ARRAY_SIZE(clock_ratios_table)) {
> > > +		info("Clock ratio not found - data reception in
> > > danger\n");
> > > +		return;
> > > +	}
> > > +
> > > +
> > > +	/* Read current values? */
> > > +	cmd.id = CMD_CLOCK_READ;
> > > +	cmd.len = 1;
> > > +	cmd.arg[0] = 0x00;
> > > +	ret = cx24120_message_sendrcv(state, &cmd, 6);
> > > +	if (ret != 0)
> > > +		return;
> > > +	/* in cmd[0]-[5] - result */
> > > +
> > > +	dev_dbg(&state->i2c->dev,
> > > +		"%s: m=%d, n=%d; idx: %d m=%d, n=%d, rate=%d\n",
> > > +		__func__,
> > > +		cmd.arg[2] | (cmd.arg[1] << 8) | (cmd.arg[0] <<
> > > 16),
> > > +		cmd.arg[5] | (cmd.arg[4] << 8) | (cmd.arg[3] <<
> > > 16),
> > > +		idx,
> > > +		clock_ratios_table[idx].m_rat,
> > > +		clock_ratios_table[idx].n_rat,
> > > +		clock_ratios_table[idx].rate);
> > > +
> > > +
> > > +
> > > +	/* Set the clock */
> > > +	cmd.id = CMD_CLOCK_SET;
> > > +	cmd.len = 10;
> > > +	cmd.arg[0] = 0;
> > > +	cmd.arg[1] = 0x10;
> > > +	cmd.arg[2] = (clock_ratios_table[idx].m_rat >> 16) & 0xff;
> > > +	cmd.arg[3] = (clock_ratios_table[idx].m_rat >>  8) & 0xff;
> > > +	cmd.arg[4] = (clock_ratios_table[idx].m_rat >>  0) & 0xff;
> > > +	cmd.arg[5] = (clock_ratios_table[idx].n_rat >> 16) & 0xff;
> > > +	cmd.arg[6] = (clock_ratios_table[idx].n_rat >>  8) & 0xff;
> > > +	cmd.arg[7] = (clock_ratios_table[idx].n_rat >>  0) & 0xff;
> > > +	cmd.arg[8] = (clock_ratios_table[idx].rate >> 8) & 0xff;
> > > +	cmd.arg[9] = (clock_ratios_table[idx].rate >> 0) & 0xff;
> > > +
> > > +	cx24120_message_send(state, &cmd);
> > > +
> > > +}
> > > +
> > > +
> > > +/* Set inversion value */
> > > +static int cx24120_set_inversion(struct cx24120_state *state,
> > > +	fe_spectral_inversion_t inversion)
> > > +{
> > > +	dev_dbg(&state->i2c->dev, "%s(%d)\n",
> > > +		__func__, inversion);
> > > +
> > > +	switch (inversion) {
> > > +	case INVERSION_OFF:
> > > +		state->dnxt.inversion_val = 0x00;
> > > +		break;
> > > +	case INVERSION_ON:
> > > +		state->dnxt.inversion_val = 0x04;
> > > +		break;
> > > +	case INVERSION_AUTO:
> > > +		state->dnxt.inversion_val = 0x0c;
> > > +		break;
> > > +	default:
> > > +		return -EINVAL;
> > > +	}
> > > +
> > > +	state->dnxt.inversion = inversion;
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/* FEC lookup table for tuning
> > > + * Some DVB-S2 val's have been found by trial
> > > + * and error. Sofar it seems to match up with
> > > + * the contents of the REG_FECMODE after tuning
> > > + * The rest will probably be the same but would
> > > + * need testing.
> > > + * Anything not in the table will run with
> > > + * FEC_AUTO and take a while longer to tune in
> > > + * ( c.500ms instead of 30ms )
> > > + */
> > 
> > Multi-line comments should be like:
> > 	/*
> > 	 * comment line 1
> > 	 * comment line 2
> > 	 */
> > 
> > > +static struct cx24120_modfec_table {
> > > +	fe_delivery_system_t delsys;
> > > +	fe_modulation_t mod;
> > > +	fe_code_rate_t fec;
> > > +	u8 val;
> > > +} modfec_table[] = {
> > > +/*delsys	mod	fec	 val */
> > > +{ SYS_DVBS,	QPSK,	FEC_1_2, 0x2e },
> > > +{ SYS_DVBS,	QPSK,	FEC_2_3, 0x2f },
> > > +{ SYS_DVBS,	QPSK,	FEC_3_4, 0x30 },
> > > +{ SYS_DVBS,	QPSK,	FEC_5_6, 0x31 },
> > > +{ SYS_DVBS,	QPSK,	FEC_6_7, 0x32 },
> > > +{ SYS_DVBS,	QPSK,	FEC_7_8, 0x33 },
> > > +
> > > +{ SYS_DVBS2,	QPSK,	FEC_3_4, 0x07 },
> > > +
> > > +{ SYS_DVBS2,	PSK_8,	FEC_2_3, 0x0d },
> > > +{ SYS_DVBS2,	PSK_8,	FEC_3_4, 0x0e },
> > > +};
> > > +
> > 
> > This table is badly aligned.
> > 
> > > +/* Set fec_val & fec_mask values from delsys, modulation & fec */
> > > +static int cx24120_set_fec(struct cx24120_state *state,
> > > +	fe_modulation_t mod, fe_code_rate_t fec)
> > > +{
> > > +	int idx;
> > > +
> > > +	dev_dbg(&state->i2c->dev,
> > > +		"%s(0x%02x,0x%02x)\n", __func__, mod, fec);
> > > +
> > > +	state->dnxt.fec = fec;
> > > +
> > > +	/* Lookup fec_val from modfec table */
> > > +	for (idx = 0; idx < ARRAY_SIZE(modfec_table); idx++) {
> > > +		if (modfec_table[idx].delsys != state->dnxt.delsys)
> > > +			continue;
> > > +		if (modfec_table[idx].mod != mod)
> > > +			continue;
> > > +		if (modfec_table[idx].fec != fec)
> > > +			continue;
> > > +
> > > +		/* found */
> > > +		state->dnxt.fec_mask = 0x00;
> > > +		state->dnxt.fec_val = modfec_table[idx].val;
> > > +		return 0;
> > > +	}
> > > +
> > > +
> > > +	if (state->dnxt.delsys == SYS_DVBS2) {
> > > +		/* DVBS2 auto is 0x00/0x00 */
> > > +		state->dnxt.fec_mask = 0x00;
> > > +		state->dnxt.fec_val  = 0x00;
> > > +	} else {
> > > +		/* Set DVB-S to auto */
> > > +		state->dnxt.fec_val  = 0x2e;
> > > +		state->dnxt.fec_mask = 0xac;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +
> > > +/* Set pilot */
> > > +static int cx24120_set_pilot(struct cx24120_state *state,
> > > +		fe_pilot_t pilot) {
> > > +
> > > +	dev_dbg(&state->i2c->dev,
> > > +		"%s(%d)\n", __func__, pilot);
> > > +
> > > +	/* Pilot only valid in DVBS2 */
> > > +	if (state->dnxt.delsys != SYS_DVBS2) {
> > > +		state->dnxt.pilot_val = CX24120_PILOT_OFF;
> > > +		return 0;
> > > +	}
> > > +
> > > +
> > 
> > Just one blank line seems enough here.
> > 
> > > +	switch (pilot) {
> > > +	case PILOT_OFF:
> > > +		state->dnxt.pilot_val = CX24120_PILOT_OFF;
> > > +		break;
> > > +	case PILOT_ON:
> > > +		state->dnxt.pilot_val = CX24120_PILOT_ON;
> > > +		break;
> > > +	case PILOT_AUTO:
> > > +	default:
> > > +		state->dnxt.pilot_val = CX24120_PILOT_AUTO;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +/* Set symbol rate */
> > > +static int cx24120_set_symbolrate(struct cx24120_state *state, u32
> > > rate) +{
> > > +	dev_dbg(&state->i2c->dev, "%s(%d)\n",
> > > +		__func__, rate);
> > > +
> > > +	state->dnxt.symbol_rate = rate;
> > > +
> > > +	/* Check symbol rate */
> > > +	if (rate  > 31000000) {
> > > +		state->dnxt.clkdiv  = (-(rate < 31000001) & 3) + 2;
> > > +		state->dnxt.ratediv = (-(rate < 31000001) & 6) + 4;
> > > +	} else {
> > > +		state->dnxt.clkdiv  = 3;
> > > +		state->dnxt.ratediv = 6;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +
> > > +/* Overwrite the current tuning params, we are about to tune */
> > > +static void cx24120_clone_params(struct dvb_frontend *fe)
> > > +{
> > > +	struct cx24120_state *state = fe->demodulator_priv;
> > > +
> > > +	state->dcur = state->dnxt;
> > > +}
> > > +
> > > +
> > > +/* Table of time to tune for different symrates */
> > > +static struct cx24120_symrate_delay {
> > > +	fe_delivery_system_t delsys;
> > > +	u32 symrate;		/* Check for >= this symrate */
> > > +	u32 delay;		/* Timeout in ms */
> > > +} symrates_delay_table[] = {
> > > +{ SYS_DVBS,	10000000,	400   },
> > > +{ SYS_DVBS,	8000000,	2000  },
> > > +{ SYS_DVBS,	6000000,	5000  },
> > > +{ SYS_DVBS,	3000000,	10000 },
> > > +{ SYS_DVBS,	0,		15000 },
> > > +{ SYS_DVBS2,	10000000,	600   }, /* DVBS2 needs a
> > > little longer */ +{ SYS_DVBS2,	8000000,	2000  }, /*
> > > (so these might need bumping too) */ +{ SYS_DVBS2,
> > > 6000000,	5000  }, +{ SYS_DVBS2,	3000000,
> > > 10000 }, +{ SYS_DVBS2,	0,		15000 },
> > > +};
> > > +
> > 
> > This table is badly aligned.
> > 
> > > +
> > > +static int cx24120_set_frontend(struct dvb_frontend *fe)
> > > +{
> > > +	struct dtv_frontend_properties *c =
> > > &fe->dtv_property_cache;
> > > +	struct cx24120_state *state = fe->demodulator_priv;
> > > +	struct cx24120_cmd cmd;
> > > +	int ret;
> > > +	int delay_cnt, sd_idx = 0;
> > > +	fe_status_t status;
> > > +
> > > +	switch (c->delivery_system) {
> > > +	case SYS_DVBS2:
> > > +		dev_dbg(&state->i2c->dev, "%s() DVB-S2\n",
> > > +			__func__);
> > > +		break;
> > > +	case SYS_DVBS:
> > > +		dev_dbg(&state->i2c->dev, "%s() DVB-S\n",
> > > +			__func__);
> > > +		break;
> > > +	default:
> > > +		dev_dbg(&state->i2c->dev,
> > > +			"%s() Delivery system(%d) not supported\n",
> > > +			__func__, c->delivery_system);
> > > +		ret = -EINVAL;
> > > +		break;
> > > +	}
> > > +
> > > +
> > > +	state->dnxt.delsys = c->delivery_system;
> > > +	state->dnxt.modulation = c->modulation;
> > > +	state->dnxt.frequency = c->frequency;
> > > +	state->dnxt.pilot = c->pilot;
> > > +
> > > +	ret = cx24120_set_inversion(state, c->inversion);
> > > +	if (ret !=  0)
> > > +		return ret;
> > > +
> > > +	ret = cx24120_set_fec(state, c->modulation, c->fec_inner);
> > > +	if (ret !=  0)
> > > +		return ret;
> > > +
> > > +	ret = cx24120_set_pilot(state, c->pilot);
> > > +	if (ret != 0)
> > > +		return ret;
> > > +
> > > +	ret = cx24120_set_symbolrate(state, c->symbol_rate);
> > > +	if (ret !=  0)
> > > +		return ret;
> > > +
> > > +
> > > +	/* discard the 'current' tuning parameters and prepare to
> > > tune */
> > > +	cx24120_clone_params(fe);
> > > +
> > > +	dev_dbg(&state->i2c->dev,
> > > +		"%s: delsys      = %d\n", __func__,
> > > state->dcur.delsys);
> > > +	dev_dbg(&state->i2c->dev,
> > > +		"%s: modulation  = %d\n", __func__,
> > > state->dcur.modulation);
> > > +	dev_dbg(&state->i2c->dev,
> > > +		"%s: frequency   = %d\n", __func__,
> > > state->dcur.frequency);
> > > +	dev_dbg(&state->i2c->dev,
> > > +		"%s: pilot       = %d (val = 0x%02x)\n", __func__,
> > > +		state->dcur.pilot, state->dcur.pilot_val);
> > > +	dev_dbg(&state->i2c->dev,
> > > +		"%s: symbol_rate = %d (clkdiv/ratediv =
> > > 0x%02x/0x%02x)\n",
> > > +		 __func__, state->dcur.symbol_rate,
> > > +		 state->dcur.clkdiv, state->dcur.ratediv);
> > > +	dev_dbg(&state->i2c->dev,
> > > +		"%s: FEC         = %d (mask/val =
> > > 0x%02x/0x%02x)\n", __func__,
> > > +		state->dcur.fec, state->dcur.fec_mask,
> > > state->dcur.fec_val);
> > > +	dev_dbg(&state->i2c->dev,
> > > +		"%s: Inversion   = %d (val = 0x%02x)\n", __func__,
> > > +		state->dcur.inversion, state->dcur.inversion_val);
> > > +
> > > +
> > > +
> > > +	/* Tune in */
> > > +	cmd.id = CMD_TUNEREQUEST;
> > > +	cmd.len = 15;
> > > +	cmd.arg[0] = 0;
> > > +	cmd.arg[1]  = (state->dcur.frequency & 0xff0000) >> 16;
> > > +	cmd.arg[2]  = (state->dcur.frequency & 0x00ff00) >> 8;
> > > +	cmd.arg[3]  = (state->dcur.frequency & 0x0000ff);
> > > +	cmd.arg[4]  = ((state->dcur.symbol_rate/1000) & 0xff00) >>
> > > 8;
> > > +	cmd.arg[5]  = ((state->dcur.symbol_rate/1000) & 0x00ff);
> > > +	cmd.arg[6]  = state->dcur.inversion;
> > > +	cmd.arg[7]  = state->dcur.fec_val | state->dcur.pilot_val;
> > > +	cmd.arg[8]  = CX24120_SEARCH_RANGE_KHZ >> 8;
> > > +	cmd.arg[9]  = CX24120_SEARCH_RANGE_KHZ & 0xff;
> > > +	cmd.arg[10] = 0;		/* maybe rolloff? */
> > > +	cmd.arg[11] = state->dcur.fec_mask;
> > > +	cmd.arg[12] = state->dcur.ratediv;
> > > +	cmd.arg[13] = state->dcur.clkdiv;
> > > +	cmd.arg[14] = 0;
> > > +
> > > +
> > > +	/* Send tune command */
> > > +	ret = cx24120_message_send(state, &cmd);
> > > +	if (ret != 0)
> > > +		return ret;
> > > +
> > > +	/* Write symbol rate values */
> > > +	ret = cx24120_writereg(state, CX24120_REG_CLKDIV,
> > > state->dcur.clkdiv);
> > > +	ret = cx24120_readreg(state, CX24120_REG_RATEDIV);
> > > +	ret &= 0xfffffff0;
> > > +	ret |= state->dcur.ratediv;
> > > +	ret = cx24120_writereg(state, CX24120_REG_RATEDIV, ret);
> > > +
> > > +	/* Default time to tune */
> > > +	delay_cnt = 500;
> > > +
> > > +	/* Establish time to tune from symrates_delay_table */
> > > +	for (sd_idx = 0; sd_idx <
> > > ARRAY_SIZE(symrates_delay_table); sd_idx++) {
> > > +		if (state->dcur.delsys !=
> > > symrates_delay_table[sd_idx].delsys)
> > > +			continue;
> > > +		if (c->symbol_rate <
> > > symrates_delay_table[sd_idx].symrate)
> > > +			continue;
> > > +
> > > +		/* found */
> > > +		delay_cnt = symrates_delay_table[sd_idx].delay;
> > > +		dev_dbg(&state->i2c->dev, "%s: Found symrate delay
> > > = %d\n",
> > > +			__func__, delay_cnt);
> > > +		break;
> > > +	}
> > > +
> > > +	/* Wait for tuning */
> > > +	while (delay_cnt >= 0) {
> > > +		cx24120_read_status(fe, &status);
> > > +		if (status & FE_HAS_LOCK)
> > > +			goto tuned;
> > > +		msleep(20);
> > > +		delay_cnt -= 20;
> > > +	}
> > 
> > I don't see any need for waiting for tune here. This is generally
> > done in userspace and at the kthread inside dvb_frontend.c.
> > 
> > Any reason why this has to be done here?
> > 
> > > +
> > > +
> > > +	/* Fail to tune */
> > > +	dev_dbg(&state->i2c->dev, "%s: Tuning failed\n",
> > > +		__func__);
> > > +
> > > +	return -EINVAL;
> > > +
> > > +
> > > +tuned:
> > > +	dev_dbg(&state->i2c->dev, "%s: Tuning successful\n",
> > > +		__func__);
> > > +
> > > +	/* Set clock ratios */
> > > +	cx24120_set_clock_ratios(fe);
> > > +
> > > +	/* Old driver would do a msleep(200) here */
> > > +
> > > +	/* Renable mpeg output */
> > > +	if (!state->mpeg_enabled)
> > > +		cx24120_msg_mpeg_output_global_config(state, 1);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +
> > > +/* Calculate vco from config */
> > > +static u64 cx24120_calculate_vco(struct cx24120_state *state)
> > > +{
> > > +	u32 vco;
> > > +	u64 inv_vco, res, xxyyzz;
> > > +	u32 xtal_khz = state->config->xtal_khz;
> > > +
> > > +	xxyyzz = 0x400000000ULL;
> > 
> > xxyyzz? Weird name for a var.
> > 
> > > +	vco = xtal_khz * 10 * 4;
> > > +	inv_vco = xxyyzz / vco;
> > > +	res = xxyyzz % vco;
> > > +
> > > +	if (inv_vco > xtal_khz * 10 * 2)
> > > +		++inv_vco;
> > > +
> > > +	dev_dbg(&state->i2c->dev,
> > > +		"%s: xtal=%d, vco=%d, inv_vco=%lld, res=%lld\n",
> > > +		__func__, xtal_khz, vco, inv_vco, res);
> > > +
> > > +	return inv_vco;
> > > +}
> > > +
> > > +
> > > +int cx24120_init(struct dvb_frontend *fe)
> > > +{
> > > +	const struct firmware *fw;
> > > +	struct cx24120_state *state = fe->demodulator_priv;
> > > +	struct cx24120_cmd cmd;
> > > +	u8 ret, ret_EA, reg1;
> > > +	u64 inv_vco;
> > > +	int reset_result;
> > > +
> > > +	int i;
> > > +	unsigned char vers[4];
> > > +
> > > +	if (state->cold_init)
> > > +		return 0;
> > > +
> > > +	/* ???? */
> > > +	ret = cx24120_writereg(state, 0xea, 0x00);
> > > +	ret = cx24120_test_rom(state);
> > > +	ret = cx24120_readreg(state, 0xfb) & 0xfe;
> > > +	ret = cx24120_writereg(state, 0xfb, ret);
> > > +	ret = cx24120_readreg(state, 0xfc) & 0xfe;
> > > +	ret = cx24120_writereg(state, 0xfc, ret);
> > > +	ret = cx24120_writereg(state, 0xc3, 0x04);
> > > +	ret = cx24120_writereg(state, 0xc4, 0x04);
> > > +	ret = cx24120_writereg(state, 0xce, 0x00);
> > > +	ret = cx24120_writereg(state, 0xcf, 0x00);
> > > +	ret_EA = cx24120_readreg(state, 0xea) & 0xfe;
> > > +	ret = cx24120_writereg(state, 0xea, ret_EA);
> > > +	ret = cx24120_writereg(state, 0xeb, 0x0c);
> > > +	ret = cx24120_writereg(state, 0xec, 0x06);
> > > +	ret = cx24120_writereg(state, 0xed, 0x05);
> > > +	ret = cx24120_writereg(state, 0xee, 0x03);
> > > +	ret = cx24120_writereg(state, 0xef, 0x05);
> > > +	ret = cx24120_writereg(state, 0xf3, 0x03);
> > > +	ret = cx24120_writereg(state, 0xf4, 0x44);
> > > +
> > > +	for (reg1 = 0xf0; reg1 < 0xf3; reg1++) {
> > > +		cx24120_writereg(state, reg1, 0x04);
> > > +		cx24120_writereg(state, reg1 - 10, 0x02);
> > > +	}
> > > +
> > > +	ret = cx24120_writereg(state, 0xea, (ret_EA | 0x01));
> > > +	for (reg1 = 0xc5; reg1 < 0xcb; reg1 += 2) {
> > > +		ret = cx24120_writereg(state, reg1, 0x00);
> > > +		ret = cx24120_writereg(state, reg1 + 1, 0x00);
> > > +	}
> > > +
> > > +	ret = cx24120_writereg(state, 0xe4, 0x03);
> > > +	ret = cx24120_writereg(state, 0xeb, 0x0a);
> > > +
> > > +	dev_dbg(&state->i2c->dev,
> > > +		"%s: Requesting firmware (%s) to download...\n",
> > > +		__func__, CX24120_FIRMWARE);
> > > +
> > > +	ret = state->config->request_firmware(fe, &fw,
> > > CX24120_FIRMWARE);
> > > +	if (ret) {
> > > +		err("Could not load firmware (%s): %d\n",
> > > +			CX24120_FIRMWARE, ret);
> > > +		return ret;
> > > +	}
> > > +
> > > +	dev_dbg(&state->i2c->dev,
> > > +		"%s: Firmware found, size %d bytes (%02x %02x ..
> > > %02x %02x)\n",
> > > +		__func__,
> > > +		(int)fw->size,			/*
> > > firmware_size in bytes */
> > > +		fw->data[0],			/* fw 1st byte
> > > */
> > > +		fw->data[1],			/* fw 2d byte
> > > */
> > > +		fw->data[fw->size - 2],		/* fw
> > > before last byte */
> > > +		fw->data[fw->size - 1]);	/* fw last byte */
> > > +
> > > +	ret = cx24120_test_rom(state);
> > > +	ret = cx24120_readreg(state, 0xfb) & 0xfe;
> > > +	ret = cx24120_writereg(state, 0xfb, ret);
> > > +	ret = cx24120_writereg(state, 0xe0, 0x76);
> > > +	ret = cx24120_writereg(state, 0xf7, 0x81);
> > > +	ret = cx24120_writereg(state, 0xf8, 0x00);
> > > +	ret = cx24120_writereg(state, 0xf9, 0x00);
> > > +	ret = cx24120_writeregN(state, 0xfa, fw->data, (fw->size -
> > > 1), 0x00);
> > > +	ret = cx24120_writereg(state, 0xf7, 0xc0);
> > > +	ret = cx24120_writereg(state, 0xe0, 0x00);
> > > +	ret = (fw->size - 2) & 0x00ff;
> > > +	ret = cx24120_writereg(state, 0xf8, ret);
> > > +	ret = ((fw->size - 2) >> 8) & 0x00ff;
> > > +	ret = cx24120_writereg(state, 0xf9, ret);
> > > +	ret = cx24120_writereg(state, 0xf7, 0x00);
> > > +	ret = cx24120_writereg(state, 0xdc, 0x00);
> > > +	ret = cx24120_writereg(state, 0xdc, 0x07);
> > > +	msleep(500);
> > > +
> > > +	/* Check final byte matches final byte of firmware */
> > > +	ret = cx24120_readreg(state, 0xe1);
> > > +	if (ret == fw->data[fw->size - 1]) {
> > > +		dev_dbg(&state->i2c->dev,
> > > +			"%s: Firmware uploaded successfully\n",
> > > +			__func__);
> > > +		reset_result = 0;
> > > +	} else {
> > > +		err("Firmware upload failed. Last byte
> > > returned=0x%x\n", ret);
> > > +		reset_result = -EREMOTEIO;
> > > +	}
> > > +	ret = cx24120_writereg(state, 0xdc, 0x00);
> > > +	release_firmware(fw);
> > > +	if (reset_result != 0)
> > > +		return reset_result;
> > > +
> > > +
> > > +	/* Start tuner */
> > > +	cmd.id = CMD_START_TUNER;
> > > +	cmd.len = 3;
> > > +	cmd.arg[0] = 0x00;
> > > +	cmd.arg[1] = 0x00;
> > > +	cmd.arg[2] = 0x00;
> > > +
> > > +	if (cx24120_message_send(state, &cmd) != 0) {
> > > +		err("Error tuner start! :(\n");
> > > +		return -EREMOTEIO;
> > > +	}
> > > +
> > > +	/* Set VCO */
> > > +	inv_vco = cx24120_calculate_vco(state);
> > > +
> > > +	cmd.id = CMD_VCO_SET;
> > > +	cmd.len = 12;
> > > +	cmd.arg[0] = 0x06;
> > > +	cmd.arg[1] = 0x2b;
> > > +	cmd.arg[2] = 0xd8;
> > > +	cmd.arg[3] = (inv_vco >> 8) & 0xff;
> > > +	cmd.arg[4] = (inv_vco) & 0xff;
> > > +	cmd.arg[5] = 0x03;
> > > +	cmd.arg[6] = 0x9d;
> > > +	cmd.arg[7] = 0xfc;
> > > +	cmd.arg[8] = 0x06;
> > > +	cmd.arg[9] = 0x03;
> > > +	cmd.arg[10] = 0x27;
> > > +	cmd.arg[11] = 0x7f;
> > > +
> > > +	if (cx24120_message_send(state, &cmd)) {
> > > +		err("Error set VCO! :(\n");
> > > +		return -EREMOTEIO;
> > > +	}
> > > +
> > > +
> > > +	/* set bandwidth */
> > > +	cmd.id = CMD_BANDWIDTH;
> > > +	cmd.len = 12;
> > > +	cmd.arg[0] = 0x00;
> > > +	cmd.arg[1] = 0x00;
> > > +	cmd.arg[2] = 0x00;
> > > +	cmd.arg[3] = 0x00;
> > > +	cmd.arg[4] = 0x05;
> > > +	cmd.arg[5] = 0x02;
> > > +	cmd.arg[6] = 0x02;
> > > +	cmd.arg[7] = 0x00;
> > > +	cmd.arg[8] = 0x05;
> > > +	cmd.arg[9] = 0x02;
> > > +	cmd.arg[10] = 0x02;
> > > +	cmd.arg[11] = 0x00;
> > > +
> > > +	if (cx24120_message_send(state, &cmd)) {
> > > +		err("Error set bandwidth!\n");
> > > +		return -EREMOTEIO;
> > > +	}
> > > +
> > > +	ret = cx24120_readreg(state, 0xba);
> > > +	if (ret > 3) {
> > > +		dev_dbg(&state->i2c->dev, "%s: Reset-readreg 0xba:
> > > %x\n",
> > > +			__func__, ret);
> > > +		err("Error initialising tuner!\n");
> > > +		return -EREMOTEIO;
> > > +	}
> > > +
> > > +	dev_dbg(&state->i2c->dev, "%s: Tuner initialised
> > > correctly.\n",
> > > +			__func__);
> > > +
> > > +
> > > +	/* Initialise mpeg outputs */
> > > +	ret = cx24120_writereg(state, 0xeb, 0x0a);
> > > +	if (cx24120_msg_mpeg_output_global_config(state, 0) ||
> > > +	    cx24120_msg_mpeg_output_config(state, 0) ||
> > > +	    cx24120_msg_mpeg_output_config(state, 1) ||
> > > +	    cx24120_msg_mpeg_output_config(state, 2)) {
> > > +		err("Error initialising mpeg output. :(\n");
> > > +		return -EREMOTEIO;
> > > +	}
> > > +
> > > +
> > > +	/* ???? */
> > > +	cmd.id = CMD_TUNER_INIT;
> > > +	cmd.len = 3;
> > > +	cmd.arg[0] = 0x00;
> > > +	cmd.arg[1] = 0x10;
> > > +	cmd.arg[2] = 0x10;
> > > +	if (cx24120_message_send(state, &cmd)) {
> > > +		err("Error sending final init message. :(\n");
> > > +		return -EREMOTEIO;
> > > +	}
> > > +
> > > +
> > > +	/* Firmware CMD 35: Get firmware version */
> > > +	cmd.id = CMD_FWVERSION;
> > > +	cmd.len = 1;
> > > +	for (i = 0; i < 4; i++) {
> > > +		cmd.arg[0] = i;
> > > +		ret = cx24120_message_send(state, &cmd);
> > > +		if (ret != 0)
> > > +			return ret;
> > > +		vers[i] = cx24120_readreg(state,
> > > CX24120_REG_MAILBOX);
> > > +	}
> > > +	info("FW version %i.%i.%i.%i\n", vers[0], vers[1],
> > > vers[2], vers[3]); +
> > > +
> > > +	state->cold_init = 1;
> > > +	return 0;
> > > +}
> > > +
> > > +
> > > +static int cx24120_tune(struct dvb_frontend *fe, bool re_tune,
> > > +	unsigned int mode_flags, unsigned int *delay, fe_status_t
> > > *status) +{
> > > +	struct cx24120_state *state = fe->demodulator_priv;
> > > +	int ret;
> > > +
> > > +	dev_dbg(&state->i2c->dev, "%s(%d)\n", __func__, re_tune);
> > > +
> > > +	/* TODO: Do we need to set delay? */
> > > +
> > > +	if (re_tune) {
> > > +		ret = cx24120_set_frontend(fe);
> > > +		if (ret)
> > > +			return ret;
> > > +	}
> > > +
> > > +	return cx24120_read_status(fe, status);
> > > +}
> > > +
> > > +
> > > +
> > > +static int cx24120_get_algo(struct dvb_frontend *fe)
> > > +{
> > > +	return DVBFE_ALGO_HW;
> > > +}
> > > +
> > > +
> > > +static int cx24120_sleep(struct dvb_frontend *fe)
> > > +{
> > > +	return 0;
> > > +}
> > > +
> > > +
> > > +/*static int cx24120_wakeup(struct dvb_frontend *fe)
> > > + * {
> > > + *   return 0;
> > > + * }
> > > +*/
> > > +
> > > +
> > > +static int cx24120_get_frontend(struct dvb_frontend *fe)
> > > +{
> > > +	struct dtv_frontend_properties *c =
> > > &fe->dtv_property_cache;
> > > +	struct cx24120_state *state = fe->demodulator_priv;
> > > +	u8 freq1, freq2, freq3;
> > > +
> > > +	dev_dbg(&state->i2c->dev, "%s()", __func__);
> > > +
> > > +	/* don't return empty data if we're not tuned in */
> > > +	if (state->mpeg_enabled)
> > > +		return 0;
> > > +
> > > +	/* Get frequency */
> > > +	freq1 = cx24120_readreg(state, CX24120_REG_FREQ1);
> > > +	freq2 = cx24120_readreg(state, CX24120_REG_FREQ2);
> > > +	freq3 = cx24120_readreg(state, CX24120_REG_FREQ3);
> > > +	c->frequency = (freq3 << 16) | (freq2 << 8) | freq1;
> > > +	dev_dbg(&state->i2c->dev, "%s frequency = %d\n", __func__,
> > > +		c->frequency);
> > > +
> > > +	/* Get modulation, fec, pilot */
> > > +	cx24120_get_fec(fe);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +
> > > +static void cx24120_release(struct dvb_frontend *fe)
> > > +{
> > > +	struct cx24120_state *state = fe->demodulator_priv;
> > > +
> > > +	dev_dbg(&state->i2c->dev, "%s: Clear state structure\n",
> > > __func__);
> > > +	kfree(state);
> > > +}
> > > +
> > > +
> > > +static int cx24120_read_ucblocks(struct dvb_frontend *fe, u32
> > > *ucblocks) +{
> > > +	struct cx24120_state *state = fe->demodulator_priv;
> > > +
> > > +	*ucblocks = (cx24120_readreg(state, CX24120_REG_UCB_H) <<
> > > 8) |
> > > +		     cx24120_readreg(state, CX24120_REG_UCB_L);
> > > +
> > > +	dev_dbg(&state->i2c->dev, "%s: Blocks = %d\n",
> > > +			__func__, *ucblocks);
> > > +	return 0;
> > > +}
> > 
> > Again, use DVBv5 for stats.
> > 
> > > +
> > > +
> > > +static struct dvb_frontend_ops cx24120_ops = {
> > > +	.delsys = { SYS_DVBS, SYS_DVBS2 },
> > > +	.info = {
> > > +		.name = "Conexant CX24120/CX24118",
> > > +		.frequency_min = 950000,
> > > +		.frequency_max = 2150000,
> > > +		.frequency_stepsize = 1011, /* kHz for QPSK
> > > frontends */
> > > +		.frequency_tolerance = 5000,
> > > +		.symbol_rate_min = 1000000,
> > > +		.symbol_rate_max = 45000000,
> > > +		.caps =	FE_CAN_INVERSION_AUTO |
> > > +			FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 |
> > > FE_CAN_FEC_3_4 |
> > > +			FE_CAN_FEC_4_5 | FE_CAN_FEC_5_6 |
> > > FE_CAN_FEC_6_7 |
> > > +			FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO |
> > > +			FE_CAN_2G_MODULATION |
> > > +			FE_CAN_QPSK | FE_CAN_RECOVER
> > > +	},
> > > +	.release =			cx24120_release,
> > > +
> > > +	.init =				cx24120_init,
> > > +	.sleep =			cx24120_sleep,
> > > +
> > > +	.tune =				cx24120_tune,
> > > +	.get_frontend_algo =		cx24120_get_algo,
> > > +	.set_frontend =
> > > cx24120_set_frontend, +
> > > +	.get_frontend =
> > > cx24120_get_frontend,
> > > +	.read_status =			cx24120_read_status,
> > > +	.read_ber =			cx24120_read_ber,
> > > +	.read_signal_strength =
> > > cx24120_read_signal_strength,
> > > +	.read_snr =			cx24120_read_snr,
> > > +	.read_ucblocks =		cx24120_read_ucblocks,
> > > +
> > > +	.diseqc_send_master_cmd =	cx24120_send_diseqc_msg,
> > > +
> > > +	.diseqc_send_burst =
> > > cx24120_diseqc_send_burst,
> > > +	.set_tone =			cx24120_set_tone,
> > > +	.set_voltage =			cx24120_set_voltage,
> > > +};
> > > +
> > > +MODULE_DESCRIPTION("DVB Frontend module for Conexant
> > > CX24120/CX24118 hardware"); +MODULE_AUTHOR("Jemma Denson");
> > > +MODULE_LICENSE("GPL");
> > > diff --git a/drivers/media/dvb-frontends/cx24120.h
> > > b/drivers/media/dvb-frontends/cx24120.h new file mode 100644
> > > index 000000000000..9a394d4c70e4
> > > --- /dev/null
> > > +++ b/drivers/media/dvb-frontends/cx24120.h
> > > @@ -0,0 +1,56 @@
> > > +/*
> > > + * Conexant CX24120/CX24118 - DVB-S/S2 demod/tuner driver
> > > + *
> > > + * Copyright (C) 2008 Patrick Boettcher <pb@linuxtv.org>
> > > + * Copyright (C) 2009 Sergey Tyurin <forum.free-x.de>
> > > + * Updated 2012 by Jannis Achstetter <jannis_achstetter@web.de>
> > > + * Copyright (C) 2015 Jemma Denson <jdenson@gmail.com>
> > > + *
> > > + * This program is free software; you can redistribute it and/or
> > > modify
> > > + * it under the terms of the GNU General Public License as
> > > published by
> > > + * the Free Software Foundation; either version 2 of the License,
> > > or
> > > + * (at your option) any later version.
> > > + *
> > > + * This program is distributed in the hope that it will be useful,
> > > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > > + * GNU General Public License for more details.
> > > + */
> > > +
> > > +#ifndef CX24120_H
> > > +#define CX24120_H
> > > +
> > > +#include <linux/kconfig.h>
> > > +#include <linux/dvb/frontend.h>
> > > +#include <linux/firmware.h>
> > > +
> > > +struct cx24120_initial_mpeg_config {
> > > +	u8 x1;
> > > +	u8 x2;
> > > +	u8 x3;
> > > +};
> > > +
> > > +struct cx24120_config {
> > > +	u8 i2c_addr;
> > > +	u32 xtal_khz;
> > > +	struct cx24120_initial_mpeg_config initial_mpeg_config;
> > > +
> > > +	int (*request_firmware)(struct dvb_frontend *fe,
> > > +				const struct firmware **fw, char
> > > *name); +};
> > > +
> > > +#if IS_REACHABLE(CONFIG_DVB_CX24120)
> > > +extern struct dvb_frontend *cx24120_attach(
> > > +	const struct cx24120_config *config,
> > > +	struct i2c_adapter *i2c);
> > > +#else
> > > +static inline struct dvb_frontend *cx24120_attach(
> > > +	const struct cx24120_config *config,
> > > +	struct i2c_adapter *i2c)
> > > +{
> > > +	printk(KERN_WARNING "%s: driver disabled by Kconfig\n",
> > > __func__);
> > > +	return NULL;
> > > +}
> > > +#endif
> > > +
> > > +#endif /* CX24120_H */
> > > -- 
> > > 2.1.0
> > > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-media" in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
