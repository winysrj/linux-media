Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36819 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752974AbdFUQmk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Jun 2017 12:42:40 -0400
Received: by mail-wr0-f194.google.com with SMTP id 77so27895418wrb.3
        for <linux-media@vger.kernel.org>; Wed, 21 Jun 2017 09:42:39 -0700 (PDT)
Date: Wed, 21 Jun 2017 17:45:04 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com, liplianin@netup.ru, rjkm@metzlerbros.de
Subject: Re: [PATCH 1/4] [media] dvb-frontends/stv0367: initial DDB DVBv5
 stats, implement ucblocks
Message-ID: <20170621174504.3f7d57a6@audiostation.wuest.de>
In-Reply-To: <9bb7bcdd-60ec-c411-ff2c-9fe3a2d751df@iki.fi>
References: <20170620174506.7593-1-d.scheller.oss@gmail.com>
        <20170620174506.7593-2-d.scheller.oss@gmail.com>
        <9bb7bcdd-60ec-c411-ff2c-9fe3a2d751df@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Wed, 21 Jun 2017 09:06:22 +0300
schrieb Antti Palosaari <crope@iki.fi>:

> On 06/20/2017 08:45 PM, Daniel Scheller wrote:
> > From: Daniel Scheller <d.scheller@gmx.net>
> > 
> > This adds the basics to stv0367ddb_get_frontend() to be able to properly
> > provide signal statistics in DVBv5 format. Also adds UCB readout and
> > provides those values.
> > 
> > Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> > ---
> >   drivers/media/dvb-frontends/stv0367.c | 59 ++++++++++++++++++++++++++++++++---
> >   1 file changed, 55 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/media/dvb-frontends/stv0367.c b/drivers/media/dvb-frontends/stv0367.c
> > index e726c2e00460..5374d4eaabd6 100644
> > --- a/drivers/media/dvb-frontends/stv0367.c
> > +++ b/drivers/media/dvb-frontends/stv0367.c
> > @@ -2997,21 +2997,64 @@ static int stv0367ddb_read_status(struct dvb_frontend *fe,
> >   	return -EINVAL;
> >   }
> >   
> > +static void stv0367ddb_read_ucblocks(struct dvb_frontend *fe)
> > +{
> > +	struct stv0367_state *state = fe->demodulator_priv;
> > +	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
> > +	u32 ucblocks = 0;
> > +
> > +	switch (state->activedemod) {
> > +	case demod_ter:
> > +		stv0367ter_read_ucblocks(fe, &ucblocks);
> > +		break;
> > +	case demod_cab:
> > +		stv0367cab_read_ucblcks(fe, &ucblocks);
> > +		break;
> > +	default:
> > +		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> > +		return;
> > +	}
> > +
> > +	p->block_error.stat[0].scale = FE_SCALE_COUNTER;
> > +	p->block_error.stat[0].uvalue = ucblocks;
> > +}
> > +
> >   static int stv0367ddb_get_frontend(struct dvb_frontend *fe,
> >   				   struct dtv_frontend_properties *p)
> >   {
> >   	struct stv0367_state *state = fe->demodulator_priv;
> > +	int ret = -EINVAL;
> > +	enum fe_status status = 0;
> >   
> >   	switch (state->activedemod) {
> >   	case demod_ter:
> > -		return stv0367ter_get_frontend(fe, p);
> > +		ret = stv0367ter_get_frontend(fe, p);
> > +		break;
> >   	case demod_cab:
> > -		return stv0367cab_get_frontend(fe, p);
> > -	default:
> > +		ret = stv0367cab_get_frontend(fe, p);
> >   		break;
> > +	default:
> > +		p->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> > +		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> > +		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> > +		return ret;
> >   	}
> >   
> > -	return -EINVAL;
> > +	/* read fe lock status */
> > +	if (!ret)
> > +		ret = stv0367ddb_read_status(fe, &status);
> > +
> > +	/* stop if get_frontend failed or if demod isn't locked */
> > +	if (ret || !(status & FE_HAS_LOCK)) {
> > +		p->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> > +		p->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> > +		p->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> > +		return ret;
> > +	}  
> 
> Requiring LOCK for strength and cnr sounds wrong. Demod usually 
> calculates strength from IF and RF AGC and those are available even 
> there is no signal at all (demod set those gains to max on that case). 
> CNR is pretty often available when inner FEC (viterbi, LDPC) is on sync.
> 
> And for ber and per you need outer fec (reed-solomon, bch) too which is 
> FE_HAS_SYNC flag on api. ber is error bit and count after inner fec, per 
> is error packet and count after outer fec. Usually ber is counted as a 
> bits and per is counted as a 204 ts packets.

Re ber/per, note that I don't have any register documentation available, everything has been gathered from this and from DD's stv0367dd driver. That said, the same applies to FE_HAS_SYNC. This driver currently only reports FE_HAS_LOCK for both OFDM and QAM operation modes, see L1503 (OFDM) and L2152. In stv0367dd, lock state acquisition is a bit more detailed. For the ddb-parts though, I even had to implement a var which carries the register which tells us in QAM mode where to acquire the lockstate from, so I don't want to blindly carry over that code since this will risk breakage of all other consumers of the stv0367 demod driver and thus the card support, neither do I want to additionally port over the read_status code since this will result in unneeded duplication of things. So atm things won't improve unless someone with some other hardware using this demod pops up, willing to experiment.

Of course I can do snr/cnr readout regardless of FE_HAS_LOCK - no strong opinion on this (needs a quick test though). Depending on if you make this a strong change requirement - please elaborate.
 
> Also having that statistics stuff updated inside a get_frontend() sounds 
> wrong. I think that callback is optional and is not called unless 
> userspace polls it.

I oriented myself on other drivers (cxd2841er for example also does this stuff in get_frontend). In your af9033 I saw you're doing this in read_status though. Would that be preferred?

-- 
Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
