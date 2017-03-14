Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33434 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdCNV3n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 17:29:43 -0400
Received: by mail-wr0-f195.google.com with SMTP id g10so25470004wrg.0
        for <linux-media@vger.kernel.org>; Tue, 14 Mar 2017 14:29:42 -0700 (PDT)
Date: Tue, 14 Mar 2017 22:29:37 +0100
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 12/13] [media] tuners/tda18212: add flag for retrying
 tuner init on failure
Message-ID: <20170314222937.55b4dbee@macbox>
In-Reply-To: <23db3ab6-b35d-350b-bb8e-2885ac03b5c7@iki.fi>
References: <20170307185727.564-1-d.scheller.oss@gmail.com>
        <20170307185727.564-13-d.scheller.oss@gmail.com>
        <23db3ab6-b35d-350b-bb8e-2885ac03b5c7@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Mon, 13 Mar 2017 16:16:29 +0200
schrieb Antti Palosaari <crope@iki.fi>:

> On 03/07/2017 08:57 PM, Daniel Scheller wrote:
> > From: Daniel Scheller <d.scheller@gmx.net>
> >
> > Taken from tda18212dd, first read after cold reset sometimes fails
> > on some cards, trying twice shall do the trick. This is the case
> > with the STV0367 demods soldered on the CineCTv6 bridge boards and
> > older DuoFlex CT modules.
> >
> > All other users (configs) of the tda18212 are updated as well to be
> > sure they won't be affected at all by this change.  
> 
> That sounds like a i2c adapter problem and fix should be there, no
> hack on a tuner driver.
> 
> Antti

This indeed is due to some HW issue. Patch has been removed though and
the retry logic put into ddbridge-core.c:tuner_attach_tda18212() for
the STV demod type with explaining comments, will be in a V2 of the
patch series.

Thanks,
Daniel

> >
> > Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> > ---
> >  drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c | 1 +
> >  drivers/media/tuners/tda18212.c                      | 5 +++++
> >  drivers/media/tuners/tda18212.h                      | 7 +++++++
> >  drivers/media/usb/dvb-usb-v2/anysee.c                | 2 ++
> >  drivers/media/usb/em28xx/em28xx-dvb.c                | 1 +
> >  5 files changed, 16 insertions(+)
> >
> > diff --git a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c
> > b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c index
> > 2c0015b..03688ee 100644 ---
> > a/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c +++
> > b/drivers/media/platform/sti/c8sectpfe/c8sectpfe-dvb.c @@ -111,6
> > +111,7 @@ static struct tda18212_config tda18212_conf =
> > { .if_dvbt_7 = 4150, .if_dvbt_8 = 4500,
> >  	.if_dvbc = 5000,
> > +	.init_flags = 0,
> >  };
> >
> >  int c8sectpfe_frontend_attach(struct dvb_frontend **fe,
> > diff --git a/drivers/media/tuners/tda18212.c
> > b/drivers/media/tuners/tda18212.c index 7b80683..2488537 100644
> > --- a/drivers/media/tuners/tda18212.c
> > +++ b/drivers/media/tuners/tda18212.c
> > @@ -220,6 +220,11 @@ static int tda18212_probe(struct i2c_client
> > *client, fe->ops.i2c_gate_ctrl(fe, 1); /* open I2C-gate */
> >
> >  	ret = regmap_read(dev->regmap, 0x00, &chip_id);
> > +
> > +	/* retry probe if desired */
> > +	if (ret && (cfg->init_flags & TDA18212_INIT_RETRY))
> > +		ret = regmap_read(dev->regmap, 0x00, &chip_id);
> > +
> >  	dev_dbg(&dev->client->dev, "chip_id=%02x\n", chip_id);
> >
> >  	if (fe->ops.i2c_gate_ctrl)
> > diff --git a/drivers/media/tuners/tda18212.h
> > b/drivers/media/tuners/tda18212.h index 6391daf..717aa2c 100644
> > --- a/drivers/media/tuners/tda18212.h
> > +++ b/drivers/media/tuners/tda18212.h
> > @@ -23,6 +23,8 @@
> >
> >  #include "dvb_frontend.h"
> >
> > +#define TDA18212_INIT_RETRY	(1 << 0)
> > +
> >  struct tda18212_config {
> >  	u16 if_dvbt_6;
> >  	u16 if_dvbt_7;
> > @@ -36,6 +38,11 @@ struct tda18212_config {
> >  	u16 if_atsc_qam;
> >
> >  	/*
> > +	 * flags for tuner init control
> > +	 */
> > +	u32 init_flags;
> > +
> > +	/*
> >  	 * pointer to DVB frontend
> >  	 */
> >  	struct dvb_frontend *fe;
> > diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c
> > b/drivers/media/usb/dvb-usb-v2/anysee.c index 6795c0c..c35b66e
> > 100644 --- a/drivers/media/usb/dvb-usb-v2/anysee.c
> > +++ b/drivers/media/usb/dvb-usb-v2/anysee.c
> > @@ -332,6 +332,7 @@ static struct tda18212_config
> > anysee_tda18212_config = { .if_dvbt_7 = 4150,
> >  	.if_dvbt_8 = 4150,
> >  	.if_dvbc = 5000,
> > +	.init_flags = 0,
> >  };
> >
> >  static struct tda18212_config anysee_tda18212_config2 = {
> > @@ -342,6 +343,7 @@ static struct tda18212_config
> > anysee_tda18212_config2 = { .if_dvbt2_7 = 4000,
> >  	.if_dvbt2_8 = 4000,
> >  	.if_dvbc = 5000,
> > +	.init_flags = 0,
> >  };
> >
> >  static struct cx24116_config anysee_cx24116_config = {
> > diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c
> > b/drivers/media/usb/em28xx/em28xx-dvb.c index 82edd37..143efb0
> > 100644 --- a/drivers/media/usb/em28xx/em28xx-dvb.c
> > +++ b/drivers/media/usb/em28xx/em28xx-dvb.c
> > @@ -380,6 +380,7 @@ static struct tda18271_config
> > kworld_ub435q_v2_config = { static struct tda18212_config
> > kworld_ub435q_v3_config = { .if_atsc_vsb	= 3600,
> >  	.if_atsc_qam	= 3600,
> > +	.init_flags	= 0,
> >  };
> >
> >  static struct zl10353_config em28xx_zl10353_xc3028_no_i2c_gate = {
> >  
> 
