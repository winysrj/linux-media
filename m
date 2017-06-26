Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38490
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751798AbdFZBYm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 21:24:42 -0400
Date: Sun, 25 Jun 2017 22:24:32 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "tbird20d@gmail.com" <tbird20d@gmail.com>,
        "frowand.list@gmail.com" <frowand.list@gmail.com>,
        "Yamamoto, Masayuki" <Masayuki.Yamamoto@sony.com>,
        "Nozawa, Hideki (STWN)" <Hideki.Nozawa@sony.com>,
        "Yonezawa, Kota" <Kota.Yonezawa@sony.com>,
        "Matsumoto, Toshihiko" <Toshihiko.Matsumoto@sony.com>,
        "Watanabe, Satoshi (SSS)" <Satoshi.C.Watanabe@sony.com>
Subject: Re: [PATCH v2 08/15] [media] cxd2880: Add top level of the driver
Message-ID: <20170625222432.4f266b1e@vento.lan>
In-Reply-To: <20170625091506.1f591fcb@vento.lan>
References: <20170414015043.16731-1-Yasunari.Takiguchi@sony.com>
        <20170414023150.17685-1-Yasunari.Takiguchi@sony.com>
        <20170613103014.3443406b@vento.lan>
        <84b4b9d6-5b91-897f-378f-4851f0d1e313@sony.com>
        <20170623100239.2a4bf8bb@vento.lan>
        <20170625091506.1f591fcb@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 25 Jun 2017 09:15:06 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Em Fri, 23 Jun 2017 10:02:39 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:
> 
> > Em Mon, 19 Jun 2017 16:56:13 +0900
> > "Takiguchi, Yasunari" <Yasunari.Takiguchi@sony.com> escreveu:
> >   
> > > >> +static int cxd2880_get_frontend_t(struct dvb_frontend *fe,
> > > >> +				struct dtv_frontend_properties *c)
> > > >> +{
> > > >> +	enum cxd2880_ret ret = CXD2880_RESULT_OK;
> > > >> +	int result = 0;
> > > >> +	struct cxd2880_priv *priv = NULL;
> > > >> +	enum cxd2880_dvbt_mode mode = CXD2880_DVBT_MODE_2K;
> > > >> +	enum cxd2880_dvbt_guard guard = CXD2880_DVBT_GUARD_1_32;
> > > >> +	struct cxd2880_dvbt_tpsinfo tps;
> > > >> +	enum cxd2880_tnrdmd_spectrum_sense sense;
> > > >> +	u16 snr = 0;
> > > >> +	int strength = 0;
> > > >> +	u32 pre_bit_err = 0, pre_bit_count = 0;
> > > >> +	u32 post_bit_err = 0, post_bit_count = 0;
> > > >> +	u32 block_err = 0, block_count = 0;
> > > >> +
> > > >> +	if ((!fe) || (!c)) {
> > > >> +		pr_err("%s: invalid arg\n", __func__);
> > > >> +		return -EINVAL;
> > > >> +	}
> > > >> +
> > > >> +	priv = (struct cxd2880_priv *)fe->demodulator_priv;
> > > >> +
> > > >> +	mutex_lock(priv->spi_mutex);
> > > >> +	ret = cxd2880_tnrdmd_dvbt_mon_mode_guard(&priv->tnrdmd,
> > > >> +						 &mode, &guard);
> > > >> +	mutex_unlock(priv->spi_mutex);
> > > >> +	if (ret == CXD2880_RESULT_OK) {
> > > >> +		switch (mode) {
> > > >> +		case CXD2880_DVBT_MODE_2K:
> > > >> +			c->transmission_mode = TRANSMISSION_MODE_2K;
> > > >> +			break;
> > > >> +		case CXD2880_DVBT_MODE_8K:
> > > >> +			c->transmission_mode = TRANSMISSION_MODE_8K;
> > > >> +			break;
> > > >> +		default:
> > > >> +			c->transmission_mode = TRANSMISSION_MODE_2K;
> > > >> +			dev_err(&priv->spi->dev, "%s: get invalid mode %d\n",
> > > >> +					__func__, mode);
> > > >> +			break;
> > > >> +		}
> > > >> +		switch (guard) {
> > > >> +		case CXD2880_DVBT_GUARD_1_32:
> > > >> +			c->guard_interval = GUARD_INTERVAL_1_32;
> > > >> +			break;
> > > >> +		case CXD2880_DVBT_GUARD_1_16:
> > > >> +			c->guard_interval = GUARD_INTERVAL_1_16;
> > > >> +			break;
> > > >> +		case CXD2880_DVBT_GUARD_1_8:
> > > >> +			c->guard_interval = GUARD_INTERVAL_1_8;
> > > >> +			break;
> > > >> +		case CXD2880_DVBT_GUARD_1_4:
> > > >> +			c->guard_interval = GUARD_INTERVAL_1_4;
> > > >> +			break;
> > > >> +		default:
> > > >> +			c->guard_interval = GUARD_INTERVAL_1_32;
> > > >> +			dev_err(&priv->spi->dev, "%s: get invalid guard %d\n",
> > > >> +					__func__, guard);
> > > >> +			break;
> > > >> +		}
> > > >> +	} else {
> > > >> +		c->transmission_mode = TRANSMISSION_MODE_2K;
> > > >> +		c->guard_interval = GUARD_INTERVAL_1_32;
> > > >> +		dev_dbg(&priv->spi->dev,
> > > >> +			"%s: ModeGuard err %d\n", __func__, ret);
> > > >> +	}
> > > >> +
> > > >> +	mutex_lock(priv->spi_mutex);
> > > >> +	ret = cxd2880_tnrdmd_dvbt_mon_tps_info(&priv->tnrdmd, &tps);
> > > >> +	mutex_unlock(priv->spi_mutex);
> > > >> +	if (ret == CXD2880_RESULT_OK) {
> > > >> +		switch (tps.hierarchy) {
> > > >> +		case CXD2880_DVBT_HIERARCHY_NON:
> > > >> +			c->hierarchy = HIERARCHY_NONE;
> > > >> +			break;
> > > >> +		case CXD2880_DVBT_HIERARCHY_1:
> > > >> +			c->hierarchy = HIERARCHY_1;
> > > >> +			break;
> > > >> +		case CXD2880_DVBT_HIERARCHY_2:
> > > >> +			c->hierarchy = HIERARCHY_2;
> > > >> +			break;
> > > >> +		case CXD2880_DVBT_HIERARCHY_4:
> > > >> +			c->hierarchy = HIERARCHY_4;
> > > >> +			break;
> > > >> +		default:
> > > >> +			c->hierarchy = HIERARCHY_NONE;
> > > >> +			dev_err(&priv->spi->dev,
> > > >> +				"%s: TPSInfo hierarchy invalid %d\n",
> > > >> +				__func__, tps.hierarchy);
> > > >> +			break;
> > > >> +		}
> > > >> +
> > > >> +		switch (tps.rate_hp) {
> > > >> +		case CXD2880_DVBT_CODERATE_1_2:
> > > >> +			c->code_rate_HP = FEC_1_2;
> > > >> +			break;
> > > >> +		case CXD2880_DVBT_CODERATE_2_3:
> > > >> +			c->code_rate_HP = FEC_2_3;
> > > >> +			break;
> > > >> +		case CXD2880_DVBT_CODERATE_3_4:
> > > >> +			c->code_rate_HP = FEC_3_4;
> > > >> +			break;
> > > >> +		case CXD2880_DVBT_CODERATE_5_6:
> > > >> +			c->code_rate_HP = FEC_5_6;
> > > >> +			break;
> > > >> +		case CXD2880_DVBT_CODERATE_7_8:
> > > >> +			c->code_rate_HP = FEC_7_8;
> > > >> +			break;
> > > >> +		default:
> > > >> +			c->code_rate_HP = FEC_NONE;
> > > >> +			dev_err(&priv->spi->dev,
> > > >> +				"%s: TPSInfo rateHP invalid %d\n",
> > > >> +				__func__, tps.rate_hp);
> > > >> +			break;
> > > >> +		}
> > > >> +		switch (tps.rate_lp) {
> > > >> +		case CXD2880_DVBT_CODERATE_1_2:
> > > >> +			c->code_rate_LP = FEC_1_2;
> > > >> +			break;
> > > >> +		case CXD2880_DVBT_CODERATE_2_3:
> > > >> +			c->code_rate_LP = FEC_2_3;
> > > >> +			break;
> > > >> +		case CXD2880_DVBT_CODERATE_3_4:
> > > >> +			c->code_rate_LP = FEC_3_4;
> > > >> +			break;
> > > >> +		case CXD2880_DVBT_CODERATE_5_6:
> > > >> +			c->code_rate_LP = FEC_5_6;
> > > >> +			break;
> > > >> +		case CXD2880_DVBT_CODERATE_7_8:
> > > >> +			c->code_rate_LP = FEC_7_8;
> > > >> +			break;
> > > >> +		default:
> > > >> +			c->code_rate_LP = FEC_NONE;
> > > >> +			dev_err(&priv->spi->dev,
> > > >> +				"%s: TPSInfo rateLP invalid %d\n",
> > > >> +				__func__, tps.rate_lp);
> > > >> +			break;
> > > >> +		}
> > > >> +		switch (tps.constellation) {
> > > >> +		case CXD2880_DVBT_CONSTELLATION_QPSK:
> > > >> +			c->modulation = QPSK;
> > > >> +			break;
> > > >> +		case CXD2880_DVBT_CONSTELLATION_16QAM:
> > > >> +			c->modulation = QAM_16;
> > > >> +			break;
> > > >> +		case CXD2880_DVBT_CONSTELLATION_64QAM:
> > > >> +			c->modulation = QAM_64;
> > > >> +			break;
> > > >> +		default:
> > > >> +			c->modulation = QPSK;
> > > >> +			dev_err(&priv->spi->dev,
> > > >> +				"%s: TPSInfo constellation invalid %d\n",
> > > >> +				__func__, tps.constellation);
> > > >> +			break;
> > > >> +		}
> > > >> +	} else {
> > > >> +		c->hierarchy = HIERARCHY_NONE;
> > > >> +		c->code_rate_HP = FEC_NONE;
> > > >> +		c->code_rate_LP = FEC_NONE;
> > > >> +		c->modulation = QPSK;
> > > >> +		dev_dbg(&priv->spi->dev,
> > > >> +			"%s: TPS info err %d\n", __func__, ret);
> > > >> +	}
> > > >> +
> > > >> +	mutex_lock(priv->spi_mutex);
> > > >> +	ret = cxd2880_tnrdmd_dvbt_mon_spectrum_sense(&priv->tnrdmd, &sense);
> > > >> +	mutex_unlock(priv->spi_mutex);
> > > >> +	if (ret == CXD2880_RESULT_OK) {
> > > >> +		switch (sense) {
> > > >> +		case CXD2880_TNRDMD_SPECTRUM_NORMAL:
> > > >> +			c->inversion = INVERSION_OFF;
> > > >> +			break;
> > > >> +		case CXD2880_TNRDMD_SPECTRUM_INV:
> > > >> +			c->inversion = INVERSION_ON;
> > > >> +			break;
> > > >> +		default:
> > > >> +			c->inversion = INVERSION_OFF;
> > > >> +			dev_err(&priv->spi->dev,
> > > >> +				"%s: spectrum sense invalid %d\n",
> > > >> +				__func__, sense);
> > > >> +			break;
> > > >> +		}
> > > >> +	} else {
> > > >> +		c->inversion = INVERSION_OFF;
> > > >> +		dev_dbg(&priv->spi->dev,
> > > >> +			"%s: spectrum_sense %d\n", __func__, ret);
> > > >> +	}
> > > >> +
> > > >> +	mutex_lock(priv->spi_mutex);
> > > >> +	ret = cxd2880_tnrdmd_mon_rf_lvl(&priv->tnrdmd, &strength);
> > > >> +	mutex_unlock(priv->spi_mutex);
> > > >> +	if (ret == CXD2880_RESULT_OK) {
> > > >> +		c->strength.len = 1;
> > > >> +		c->strength.stat[0].scale = FE_SCALE_DECIBEL;
> > > >> +		c->strength.stat[0].svalue = strength;
> > > >> +	} else {
> > > >> +		c->strength.len = 1;
> > > >> +		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> > > >> +		dev_dbg(&priv->spi->dev, "%s: mon_rf_lvl %d\n",
> > > >> +			__func__, result);
> > > >> +	}
> > > >> +
> > > >> +	result = cxd2880_read_snr(fe, &snr);
> > > >> +	if (!result) {
> > > >> +		c->cnr.len = 1;
> > > >> +		c->cnr.stat[0].scale = FE_SCALE_DECIBEL;
> > > >> +		c->cnr.stat[0].svalue = snr;
> > > >> +	} else {
> > > >> +		c->cnr.len = 1;
> > > >> +		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> > > >> +		dev_dbg(&priv->spi->dev, "%s: read_snr %d\n", __func__, result);
> > > >> +	}
> > > >> +
> > > >> +	mutex_lock(priv->spi_mutex);
> > > >> +	ret = cxd2880_pre_bit_err_t(&priv->tnrdmd, &pre_bit_err,
> > > >> +					&pre_bit_count);      
> > > > 
> > > > Hmm... reading BER-based measures at get_frontend() may not be
> > > > the best idea, depending on how the hardware works.
> > > > 
> > > > I mean, you need to be sure that, if userspace is calling it too
> > > > often, it won't affect the hardware or the measurement.
> > > > 
> > > > On other drivers, where each call generates an I2C access,
> > > > we do that by moving the code that actually call the hardware
> > > > at get status, and we use jiffies to be sure that it won't be
> > > > called too often.
> > > > 
> > > > I dunno if, on your SPI design, this would be an issue or not.      
> > > 
> > > CXD2880 IC can accept frequently counter register access by SPI.
> > > Even if such access occurred, it will not affect to IC behavior.
> > > We checked Sony demodulator IC driver code, dvb_frontends/cxd2841er.c and it reads register information
> > > when get_frontend called.
> > > 
> > > In fact, CXD2880 IC do NOT have bit error/packet error counter function to achieve DVB framework API completely.
> > > Sorry for long explanation, but I'll write in detail.
> > > 
> > > DTV_STAT_PRE_ERROR_BIT_COUNT
> > > DTV_STAT_PRE_TOTAL_BIT_COUNT
> > > DTV_STAT_POST_ERROR_BIT_COUNT
> > > DTV_STAT_POST_TOTAL_BIT_COUNT
> > > DTV_STAT_ERROR_BLOCK_COUNT
> > > DTV_STAT_TOTAL_BLOCK_COUNT
> > > 
> > > From DVB framework documentation, it seems that the demodulator hardware should have counter
> > > to accumulate total bit/packet count to decode, and bit/packet error corrected by FEC.
> > > But unfortunately, CXD2880 demodulator does not have such function.    
> > 
> > No, this is not a requirement. What actually happens is that userspace
> > expect those values to be monotonically incremented, as new data is
> > made available.
> >   
> > > 
> > > Instead of it, Sony demodulator has bit/packet error counter for BER, PER calculation.
> > > The user should configure total bit/packet count (denominator) for BER/PER measurement by some register setting.    
> > 
> > Yeah, that's a common practice: usually, the counters are initialized
> > by some registers (on a few hardware, it is hardcoded).
> >   
> > > The IC hardware will update the error counter automatically in period determined by
> > > configured total bit/packet count (denominator).    
> > 
> > So, the driver need to be sure that it won't read the register too
> > early, e. g. it should either be reading some register bits to know
> > when to read the data, or it needs a logic that will estimate when
> > the data will be ready, not updating the values to early.
> > 
> > An example of the first case is the mb86a20s. There, you can see at:
> > mb86a20s_get_pre_ber():
> > 
> > 	/* Check if the BER measures are already available */
> > 	rc = mb86a20s_readreg(state, 0x54);
> > 	if (rc < 0)
> > 		return rc;
> > 
> > 	/* Check if data is available for that layer */
> > 	if (!(rc & (1 << layer))) {
> > 		dev_dbg(&state->i2c->dev,
> > 			"%s: preBER for layer %c is not available yet.\n",
> > 			__func__, 'A' + layer);
> > 		return -EBUSY;
> > 	}
> > 
> > An example of the second case is dib8000. There, you can see at:
> > dib8000_get_stats():
> > 
> > 
> > 	/* Check if time for stats was elapsed */
> > 	if (time_after(jiffies, state->per_jiffies_stats)) {
> > 		state->per_jiffies_stats = jiffies + msecs_to_jiffies(1000);
> > 
> > ...
> > 		/* Get UCB measures */
> > 		dib8000_read_unc_blocks(fe, &val);
> > 		if (val < state->init_ucb)
> > 			state->init_ucb += 0x100000000LL;
> > 
> > 		c->block_error.stat[0].scale = FE_SCALE_COUNTER;
> > 		c->block_error.stat[0].uvalue = val + state->init_ucb;
> > 
> > 		/* Estimate the number of packets based on bitrate */
> > 		if (!time_us)
> > 			time_us = dib8000_get_time_us(fe, -1);
> > 
> > 		if (time_us) {
> > 			blocks = 1250000ULL * 1000000ULL;
> > 			do_div(blocks, time_us * 8 * 204);
> > 			c->block_count.stat[0].scale = FE_SCALE_COUNTER;
> > 			c->block_count.stat[0].uvalue += blocks;
> > 		}
> > 
> > 		show_per_stats = 1;
> > 	}
> > 
> > At the above, the hardware is set to provide the number of uncorrected
> > blocks on every second, and the logic there calculates the number of
> > blocks based on the bitrate. It shouldn't be hard to do the opposite
> > (e. g. set the hardware for a given number of blocks and calculate
> > the time - I remember I coded it already - just don't remember on
> > what driver - perhaps on an earlier implementation at mb86a20s).
> > 
> > In any case, as the code will require periodic pulls, in order
> > to provide monotonic counters, we implement it via get_stats(), as
> > the DVB core will ensure that it will be called periodically
> > (typically 3 times per second).
> >   
> > > 
> > > So, we implemented like as follows.
> > > 
> > > DTV_STAT_PRE_ERROR_BIT_COUNT
> > > DTV_STAT_POST_ERROR_BIT_COUNT
> > > DTV_STAT_ERROR_BLOCK_COUNT    
> > > => Return bit/packet error counter value in period determined by configured total bit/packet count (numerator).      
> > > 
> > > DTV_STAT_PRE_TOTAL_BIT_COUNT
> > > DTV_STAT_POST_TOTAL_BIT_COUNT
> > > DTV_STAT_TOTAL_BLOCK_COUNT    
> > > => Return currently configured total bit/packet count (denominator).      
> > > 
> > > By this implementation, the user can calculate BER, PER by following calculation.
> > > 
> > > DTV_STAT_PRE_ERROR_BIT_COUNT / DTV_STAT_PRE_TOTAL_BIT_COUNT
> > > DTV_STAT_POST_ERROR_BIT_COUNT / DTV_STAT_POST_TOTAL_BIT_COUNT
> > > DTV_STAT_ERROR_BLOCK_COUNT / DTV_STAT_TOTAL_BLOCK_COUNT
> > > 
> > > But instead, DTV_STAT_XXX_ERROR_XXX_COUNT values are not monotonically increased,
> > > and DTV_STAT_XXX_TOTAL_XX_COUNT will return fixed value.    
> > 
> > That's wrong. you should be doing:
> > 
> > 	DTV_STAT_TOTAL_BLOCK_COUNT += number_of_blocks
> > 
> > every time the block counter registers are updated (and the
> > same for the total bit counter).  
> 
> Btw, as we had another developer with some doubts about stats
> implementation, I wrote a chapter at the documentation in
> order to explain how to properly implement it:
> 
> 	https://linuxtv.org/downloads/v4l-dvb-apis-new/kapi/dtv-core.html#digital-tv-frontend-statistics

I added a few more patches today, improving the docs. They're not
yet upstream, but you can see the documentation at this link:

	https://www.infradead.org/~mchehab/kernel_docs/media/kapi/dtv-core.html#digital-tv-frontend-kabi

> 
> > 
> > Thanks,
> > Mauro  
> 
> 
> 
> Thanks,
> Mauro



Thanks,
Mauro
