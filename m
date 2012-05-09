Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58939 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab2EIVCy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 May 2012 17:02:54 -0400
Received: by wibhn19 with SMTP id hn19so768561wib.1
        for <linux-media@vger.kernel.org>; Wed, 09 May 2012 14:02:53 -0700 (PDT)
Message-ID: <1336597364.16044.15.camel@router7789>
Subject: Re: [PATCH] [TEST] Regarding m88rc2000 i2c gate operation, SNR, BER
 and others
From: Malcolm Priestley <tvboxspy@gmail.com>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org
Date: Wed, 09 May 2012 22:02:44 +0100
In-Reply-To: <1682436.JdK20qceHM@useri>
References: <1682436.JdK20qceHM@useri>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2012-05-09 at 04:54 -0700, Igor M. Liplianin wrote:
> Malcolm,
> 
> I made SNR, BER, UCB and signal level code for m88rc2000, but my cards show 
> them correctly only if I made changes in m88rs2000_tuner_read function.
> Analyzing USB logs I found that register 0x81 never set to 0x85 value.
> It is always set to 0x84 regardless of read or write operation to tuner.
> I was wondering is this my hardware specific? Can you test you cards with 
> attached patch?
> 
> Igor
Hi Igor

I have been testing the patch this evening and have found no problems.

I just need to create in lmedm04 callbacks for m88rs2000_read_snr and
m88rs2000_read_ber as these cannot be called while the device is
streaming. It looks like they are present in the interrupt callback.

Register 0x81 works with either 0x84 or 0x85 on read. What I did notice
if 0x85 is used on writes the device becomes completely unresponsive and
needs to be replugged. So it is safer to use 0x84.

I will try and get the patch for lmedm04 ready in the next few days.

Regards


Malcolm
  
> differences between files attachment (snrber.patch)
> diff --git a/drivers/media/dvb/frontends/m88rs2000.c b/drivers/media/dvb/frontends/m88rs2000.c
> index f6d6e39..f5ece59 100644
> --- a/drivers/media/dvb/frontends/m88rs2000.c
> +++ b/drivers/media/dvb/frontends/m88rs2000.c
> @@ -143,7 +143,7 @@ static u8 m88rs2000_demod_read(struct m88rs2000_state *state, u8 reg)
>  
>  static u8 m88rs2000_tuner_read(struct m88rs2000_state *state, u8 reg)
>  {
> -	m88rs2000_demod_write(state, 0x81, 0x85);
> +	m88rs2000_demod_write(state, 0x81, 0x84);
>  	udelay(10);
>  	return m88rs2000_readreg(state, 0, reg);
>  }
> @@ -492,33 +492,81 @@ static int m88rs2000_read_status(struct dvb_frontend *fe, fe_status_t *status)
>  	return 0;
>  }
>  
> -/* Extact code for these unknown but lmedm04 driver uses interupt callbacks */
> -
>  static int m88rs2000_read_ber(struct dvb_frontend *fe, u32 *ber)
>  {
> -	deb_info("m88rs2000_read_ber %d\n", *ber);
> -	*ber = 0;
> +	struct m88rs2000_state *state = fe->demodulator_priv;
> +	u8 tmp0, tmp1;
> +
> +	m88rs2000_demod_write(state, 0x9a, 0x30);
> +	tmp0 = m88rs2000_demod_read(state, 0xd8);
> +	if ((tmp0 & 0x10) != 0) {
> +		m88rs2000_demod_write(state, 0x9a, 0xb0);
> +		*ber = 0xffffffff;
> +		return 0;
> +	}
> +
> +	*ber = (m88rs2000_demod_read(state, 0xd7) << 8) |
> +		m88rs2000_demod_read(state, 0xd6);
> +
> +	tmp1 = m88rs2000_demod_read(state, 0xd9);
> +	m88rs2000_demod_write(state, 0xd9, (tmp1 & ~7) | 4);
> +	/* needs twice */
> +	m88rs2000_demod_write(state, 0xd8, (tmp0 & ~8) | 0x30);
> +	m88rs2000_demod_write(state, 0xd8, (tmp0 & ~8) | 0x30);
> +	m88rs2000_demod_write(state, 0x9a, 0xb0);
> +
>  	return 0;
>  }
>  
>  static int m88rs2000_read_signal_strength(struct dvb_frontend *fe,
> -	u16 *strength)
> +						u16 *signal_strength)
>  {
> -	*strength = 0;
> +	struct m88rs2000_state *state = fe->demodulator_priv;
> +	u8 rfg, bbg, gain, strength;
> +
> +	rfg = m88rs2000_tuner_read(state, 0x3d) & 0x1f;
> +	bbg = m88rs2000_tuner_read(state, 0x21) & 0x1f;
> +	gain = rfg * 2 + bbg * 3;
> +
> +	if (gain > 80)
> +		strength = 0;
> +	else if (gain > 65)
> +		strength = 4 * (80 - gain);
> +	else if (gain > 50)
> +		strength = 65 + 4 * (65 - gain) / 3;
> +	else
> +		strength = 85 + 2 * (50 - gain) / 3;
> +
> +	*signal_strength = strength * 655;
> +
> +	deb_info("%s: rfg, bbg / gain = %d, %d, %d\n",
> +		__func__, rfg, bbg, gain);
> +
>  	return 0;
>  }
>  
>  static int m88rs2000_read_snr(struct dvb_frontend *fe, u16 *snr)
>  {
> -	deb_info("m88rs2000_read_snr %d\n", *snr);
> -	*snr = 0;
> +	struct m88rs2000_state *state = fe->demodulator_priv;
> +
> +	*snr = 512 * m88rs2000_demod_read(state, 0x65);
> +
>  	return 0;
>  }
>  
>  static int m88rs2000_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
>  {
> -	deb_info("m88rs2000_read_ber %d\n", *ucblocks);
> -	*ucblocks = 0;
> +	struct m88rs2000_state *state = fe->demodulator_priv;
> +	u8 tmp;
> +
> +	*ucblocks = (m88rs2000_demod_read(state, 0xd5) << 8) |
> +			m88rs2000_demod_read(state, 0xd4);
> +	tmp = m88rs2000_demod_read(state, 0xd8);
> +	m88rs2000_demod_write(state, 0xd8, tmp & ~0x20);
> +	/* needs two times */
> +	m88rs2000_demod_write(state, 0xd8, tmp | 0x20);
> +	m88rs2000_demod_write(state, 0xd8, tmp | 0x20);
> +
>  	return 0;
>  }
>  


