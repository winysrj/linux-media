Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37265 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbbFHUTw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2015 16:19:52 -0400
Received: by wifx6 with SMTP id x6so1521915wif.0
        for <linux-media@vger.kernel.org>; Mon, 08 Jun 2015 13:19:51 -0700 (PDT)
Received: from [192.168.1.103] (188.30.130.168.threembb.co.uk. [188.30.130.168])
        by mx.google.com with ESMTPSA id fb3sm2704466wib.21.2015.06.08.13.19.49
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jun 2015 13:19:50 -0700 (PDT)
Message-ID: <5575F8DC.4010608@gmail.com>
Date: Mon, 08 Jun 2015 21:19:40 +0100
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] lmedm04: implement dvb v5 statistics
References: <1433794008-5084-1-git-send-email-tvboxspy@gmail.com>
In-Reply-To: <1433794008-5084-1-git-send-email-tvboxspy@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/06/15 21:06, Malcolm Priestley wrote:
> Indroduce function lme2510_update_stats to update
> statistics directly from usb interrupt.
>
> Provide signal and snr wrap rounds for dvb v3 functions.
>
> Block and post bit are not available.
>
> When i2c_talk_onoff is on no statistics are available,
> with possible future hand over to the relevant frontend/tuner.
>
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> ---
>   drivers/media/usb/dvb-usb-v2/lmedm04.c | 104 ++++++++++++++++++++++++---------
>   1 file changed, 77 insertions(+), 27 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> index f1983f2..1717102 100644
> --- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
> +++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
> @@ -257,6 +257,65 @@ static int lme2510_enable_pid(struct dvb_usb_device *d, u8 index, u16 pid_out)
>   	return ret;
>   }
>
> +static void lme2510_update_stats(struct dvb_usb_adapter *adap)
> +{
> +	struct lme2510_state *st = adap_to_priv(adap);
> +	struct dvb_frontend *fe = adap->fe[0];
> +	struct dtv_frontend_properties *c;
> +	u64 s_tmp = 0, c_tmp = 0;
> +
> +	if (!fe)
> +		return;
> +
> +	c = &fe->dtv_property_cache;
> +
> +	c->block_count.len = 1;
> +	c->block_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> +	c->block_error.len = 1;
> +	c->block_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> +	c->post_bit_count.len = 1;
> +	c->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> +	c->post_bit_error.len = 1;
> +	c->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> +
> +	if (st->i2c_talk_onoff) {
> +		c->strength.len = 1;
> +		c->strength.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> +		c->cnr.len = 1;
> +		c->cnr.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
> +		return;
> +	}
> +
> +	switch (st->tuner_config) {
> +	case TUNER_LG:
> +		s_tmp = 0xff - st->signal_level;
> +		s_tmp |= s_tmp << 8;
> +
> +		c_tmp = 0xff - st->signal_sn;
> +		c_tmp |= c_tmp << 8;
> +		break;
> +	/* fall through */
> +	case TUNER_S7395:
> +	case TUNER_S0194:
> +		s_tmp = 0xffff - (((st->signal_level * 2) << 8) * 5 / 4);
> +
> +		c_tmp = (u16)((0xff - st->signal_sn - 0xa1) * 3) << 8;
> +		break;
> +	case TUNER_RS2000:
> +		s_tmp = (u16)((u32)st->signal_level * 0xffff / 0xff);
> +
> +		c_tmp = (u16)((u32)st->signal_sn * 0xffff / 0x7f);
> +	}
I have notice a couple of mistakes with variable sizes.

Will repost

