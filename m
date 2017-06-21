Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:36020 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752866AbdFUQ5d (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 12:57:33 -0400
Received: by mail-wr0-f169.google.com with SMTP id c11so87455721wrc.3
        for <linux-media@vger.kernel.org>; Wed, 21 Jun 2017 09:57:32 -0700 (PDT)
Date: Wed, 21 Jun 2017 17:50:53 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, liplianin@netup.ru, rjkm@metzlerbros.de
Subject: Re: [PATCH 3/4] [media] dvb-frontends/stv0367: SNR DVBv5 statistics
 for DVB-C and T
Message-ID: <20170621175053.2d1d26f2@audiostation.wuest.de>
In-Reply-To: <ee554f8e-b533-4b8b-5710-83e7ff40a3c2@iki.fi>
References: <20170620174506.7593-1-d.scheller.oss@gmail.com>
        <20170620174506.7593-4-d.scheller.oss@gmail.com>
        <ee554f8e-b533-4b8b-5710-83e7ff40a3c2@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Wed, 21 Jun 2017 09:30:27 +0300
schrieb Antti Palosaari <crope@iki.fi>:

> On 06/20/2017 08:45 PM, Daniel Scheller wrote:
> > From: Daniel Scheller <d.scheller@gmx.net>
> > 
> > Add signal-to-noise-ratio as provided by the demodulator in decibel scale.
> > QAM/DVB-C needs some intlog calculation to have usable dB values, OFDM/
> > DVB-T values from the demod look alright already and are provided as-is.
> > 
> > Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> > ---
> >   drivers/media/dvb-frontends/stv0367.c | 33 +++++++++++++++++++++++++++++++++
> >   1 file changed, 33 insertions(+)
> > 
> > diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
> > index bb498f942ebd..0b13a407df23 100644
> > --- a/drivers/media/dvb-frontends/stv0367.c
> > +++ b/drivers/media/dvb-frontends/stv0367.c
> > @@ -25,6 +25,8 @@
> >   #include <linux/slab.h>
> >   #include <linux/i2c.h>
> >   
> > +#include "dvb_math.h"
> > +
> >   #include "stv0367.h"
> >   #include "stv0367_defs.h"
> >   #include "stv0367_regs.h"
> > @@ -33,6 +35,9 @@
> >   /* Max transfer size done by I2C transfer functions */
> >   #define MAX_XFER_SIZE  64
> >   
> > +/* snr logarithmic calc */
> > +#define INTLOG10X100(x) ((u32) (((u64) intlog10(x) * 100) >> 24))
> > +
> >   static int stvdebug;
> >   module_param_named(debug, stvdebug, int, 0644);
> >   
> > @@ -3013,6 +3018,33 @@ static int stv0367ddb_read_status(struct dvb_frontend *fe,
> >   	return -EINVAL;
> >   }
> >   
> > +static void stv0367ddb_read_snr(struct dvb_frontend *fe)
> > +{
> > +	struct stv0367_state *state = fe->demodulator_priv;
> > +	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> > +	int cab_pwr;
> > +	u32 regval, tmpval, snrval = 0;
> > +
> > +	switch (state->activedemod) {
> > +	case demod_ter:
> > +		snrval = stv0367ter_snr_readreg(fe);
> > +		break;
> > +	case demod_cab:
> > +		cab_pwr = stv0367cab_snr_power(fe);
> > +		regval = stv0367cab_snr_readreg(fe, 0);
> > +
> > +		tmpval = (cab_pwr * 320) / regval;
> > +		snrval = ((tmpval != 0) ? INTLOG10X100(tmpval) : 0) * 100;  
> 
> How much there will be rounding errors due to that signal/noise 
> division? I would convert it to calculation of sums (tip logarithm 
> calculation rules).

This is taken from stv0367dd aswell, the reported and calculated values are in 0.1dB precision. This and to not diverge any more from the "source" driver, I'd prefer to keep it how it is. These are just simple tuner cards anyway and by no means professional measurement gear, and should only give a more or less rough estimate on reception quality. E.g. my stv0367 cards report around 36dB SNR, whereas the cxd2841er reports ~37dB, compared to my DOCSIS modem, which reports 34dB on DOCSIS channels (another variant I had earlier even reported 39dB on the same channels), so... Even, we get way more precision than on the relative scale calc on the cab_read_snr functions which is in 10%-steps...

> Also, that INTLOG10X100 is pretty much useless. Use just what 
> intlog10/intlog2 offers without yet again another conversion.

Will check and experiment. Again, taken from stv0367dd :-)

-- 
Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
