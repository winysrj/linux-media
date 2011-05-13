Return-path: <mchehab@gaivota>
Received: from casper.infradead.org ([85.118.1.10]:48590 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756660Ab1EMHIE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2011 03:08:04 -0400
Message-ID: <4DCCD8D3.5060104@infradead.org>
Date: Fri, 13 May 2011 09:08:03 +0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Manoel PN <pinusdtv@hotmail.com>
CC: linux-media@vger.kernel.org, lgspn@hotmail.com
Subject: Re: [PATCH 2/4] Modifications to the driver mb86a20s
References: <BLU157-w5E482944CB2AA4A90A5E5D8880@phx.gbl>
In-Reply-To: <BLU157-w5E482944CB2AA4A90A5E5D8880@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 13-05-2011 04:08, Manoel PN escreveu:
> This patch implements mb86a20s_read_snr and adds mb86a20s_read_ber and mb86a20s_read_ucblocks both without practical utility but that programs as dvbsnoop need.

Same as the prev. patch: break into 75 columns max, and you don't need
to use "This patch".
> 
> Signed-off-by: Manoel Pinheiro <pinusdtv@hotmail.com>
> 
 
> diff --git a/drivers/media/dvb/frontends/mb86a20s.c b/drivers/media/dvb/frontends/mb86a20s.c
> index 0f867a5..0de4abf 100644
> --- a/drivers/media/dvb/frontends/mb86a20s.c
> +++ b/drivers/media/dvb/frontends/mb86a20s.c
> @@ -411,6 +411,56 @@ err:
>  	return rc;
>  }
>  
> +static int mb86a20s_read_snr(struct dvb_frontend *fe, u16 *snr)
> +{
> +	struct mb86a20s_state *state = fe->demodulator_priv;
> +	int i, cnr, val, val2;
> +
> +	for (i = 0; i < 30; i++) {
> +		if (mb86a20s_readreg(state, 0x0a) >= 2)
> +			val = mb86a20s_readreg(state, 0x45); /* read cnr_flag */
> +		else
> +			val = -1;
> +		if (val > 0 && ((val >> 6) & 1) != 0) {
> +			val2 = mb86a20s_readreg(state, 0x46);
> +			val = mb86a20s_readreg(state, 0x47);
> +			if (val2 >=0 && val >= 0) {
> +				cnr = (val2 << 0x08) | val;
> +				if (cnr > 0x4cc0) cnr = 0x4cc0;
> +				val = ((0x4cc0 - cnr) * 10000) / 0x4cc0;
> +				val2 = (65535 * val) / 10000;
> +				*snr = (u16)val2;
> +				dprintk("snr=%i, cnr=%i, val=%i\n", val2, cnr, val);
> +				/* reset cnr_counter */
> +				val = mb86a20s_readreg(state, 0x45);
> +				if (val >= 0)
> +				{
> +					mb86a20s_writereg(state, 0x45, val | 0x10);
> +					msleep(5);
> +					mb86a20s_writereg(state, 0x45, val & 0x6f); /* FIXME: or 0xef ? */
> +				}
> +				return 0;
> +			}
> +		}
> +		msleep(30);
> +	}
> +	*snr = 0;
> +	dprintk("no signal!\n");
> +	return 0;
> +}



> +static int mb86a20s_read_ber(struct dvb_frontend *fe, u32 *ber)
> +{
> +	*ber = 0;
> +	return 0;
> +}
> +
> +static int mb86a20s_read_ucblocks(struct dvb_frontend *fe, u32 *ucblocks)
> +{
> +	*ucblocks = 0;
> +	return 0;
> +}

As you're providing just a stub function there, without an actual implementation,
the better is to add a FIXME note about that, explaining why you had to add such
function, like:

/*
 * FIXME: read_ucblocks callback is needed, as dvbsnoop uses it.
 * However, we currently don't know how to actually implement it.
 * So add a function that just returns 0 instead.
 */

This way, somebody else with enough information may later implement.

I don't like very much the idea of adding those two stub functions just to
play with dvbsnoop. If dvbsnoop should be working fine without this function,
a patch to dvbsnoop should be sending instead, to proper handle the error
messages generated when a function is not enabled.  If otherwise it doesn't
work properly, then you have no choice but to add a real code for it into the
Kernel driver.

> +
>  static int mb86a20s_read_signal_strength(struct dvb_frontend *fe, u16 *strength)
>  {
>  	struct mb86a20s_state *state = fe->demodulator_priv;
> @@ -627,6 +677,9 @@ static struct dvb_frontend_ops mb86a20s_ops = {
>  	.release = mb86a20s_release,
>  
>  	.init = mb86a20s_initfe,
> +	.read_snr = mb86a20s_read_snr,
> +	.read_ber = mb86a20s_read_ber,
> +	.read_ucblocks = mb86a20s_read_ucblocks,
>  	.set_frontend = mb86a20s_set_frontend,
>  	.get_frontend = mb86a20s_get_frontend,
>  	.read_status = mb86a20s_read_status,

