Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:42325 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752548AbcJJGjT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Oct 2016 02:39:19 -0400
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id 88AC420B36
        for <linux-media@vger.kernel.org>; Mon, 10 Oct 2016 08:39:17 +0200 (CEST)
Date: Mon, 10 Oct 2016 08:39:15 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Johannes Stezenbach <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>
Subject: Re: [PATCH 05/26] cinergyT2-fe: don't do DMA on stack
Message-ID: <20161010083915.392a6d95@posteo.de>
In-Reply-To: <9d415b35135ba2d457df12859b64eacbc05bc2e4.1475860773.git.mchehab@s-opensource.com>
References: <cover.1475860773.git.mchehab@s-opensource.com>
        <9d415b35135ba2d457df12859b64eacbc05bc2e4.1475860773.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri,  7 Oct 2016 14:24:15 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> The USB control messages require DMA to work. We cannot pass
> a stack-allocated buffer, as it is not warranted that the
> stack would be into a DMA enabled area.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/usb/dvb-usb/cinergyT2-fe.c | 45
> ++++++++++++++++---------------- 1 file changed, 23 insertions(+), 22
> deletions(-)
> 
> diff --git a/drivers/media/usb/dvb-usb/cinergyT2-fe.c
> b/drivers/media/usb/dvb-usb/cinergyT2-fe.c index
> fd8edcb56e61..03ba66ef1f28 100644 ---
> a/drivers/media/usb/dvb-usb/cinergyT2-fe.c +++
> b/drivers/media/usb/dvb-usb/cinergyT2-fe.c @@ -139,6 +139,9 @@ static
> uint16_t compute_tps(struct dtv_frontend_properties *op) struct
> cinergyt2_fe_state { struct dvb_frontend fe;
>  	struct dvb_usb_device *d;
> +
> +	unsigned char data[64];
> +
>  	struct dvbt_get_status_msg status;
>  };
>  
> @@ -146,28 +149,28 @@ static int cinergyt2_fe_read_status(struct
> dvb_frontend *fe, enum fe_status *status)
>  {
>  	struct cinergyt2_fe_state *state = fe->demodulator_priv;
> -	struct dvbt_get_status_msg result;
> -	u8 cmd[] = { CINERGYT2_EP1_GET_TUNER_STATUS };
>  	int ret;
>  
> -	ret = dvb_usb_generic_rw(state->d, cmd, sizeof(cmd), (u8
> *)&result,
> -			sizeof(result), 0);
> +	state->data[0] = CINERGYT2_EP1_GET_TUNER_STATUS;
> +
> +	ret = dvb_usb_generic_rw(state->d, state->data, 1,
> +				 state->data, sizeof(state->status),
> 0); if (ret < 0)
>  		return ret;
>  
> -	state->status = result;
> +	memcpy(&state->status, state->data, sizeof(state->status));
>  
>  	*status = 0;
>  
> -	if (0xffff - le16_to_cpu(result.gain) > 30)
> +	if (0xffff - le16_to_cpu(state->status.gain) > 30)
>  		*status |= FE_HAS_SIGNAL;
> -	if (result.lock_bits & (1 << 6))
> +	if (state->status.lock_bits & (1 << 6))
>  		*status |= FE_HAS_LOCK;
> -	if (result.lock_bits & (1 << 5))
> +	if (state->status.lock_bits & (1 << 5))
>  		*status |= FE_HAS_SYNC;
> -	if (result.lock_bits & (1 << 4))
> +	if (state->status.lock_bits & (1 << 4))
>  		*status |= FE_HAS_CARRIER;
> -	if (result.lock_bits & (1 << 1))
> +	if (state->status.lock_bits & (1 << 1))
>  		*status |= FE_HAS_VITERBI;
>  
>  	if ((*status & (FE_HAS_CARRIER | FE_HAS_VITERBI |
> FE_HAS_SYNC)) != @@ -232,31 +235,29 @@ static int
> cinergyt2_fe_set_frontend(struct dvb_frontend *fe) {
>  	struct dtv_frontend_properties *fep =
> &fe->dtv_property_cache; struct cinergyt2_fe_state *state =
> fe->demodulator_priv;
> -	struct dvbt_set_parameters_msg param;
> -	char result[2];
> +	struct dvbt_set_parameters_msg *param = (void *)state->data;
>  	int err;
>  
> -	param.cmd = CINERGYT2_EP1_SET_TUNER_PARAMETERS;
> -	param.tps = cpu_to_le16(compute_tps(fep));
> -	param.freq = cpu_to_le32(fep->frequency / 1000);
> -	param.flags = 0;
> +	param->cmd = CINERGYT2_EP1_SET_TUNER_PARAMETERS;
> +	param->tps = cpu_to_le16(compute_tps(fep));
> +	param->freq = cpu_to_le32(fep->frequency / 1000);
> +	param->flags = 0;
>  
>  	switch (fep->bandwidth_hz) {
>  	default:
>  	case 8000000:
> -		param.bandwidth = 8;
> +		param->bandwidth = 8;
>  		break;
>  	case 7000000:
> -		param.bandwidth = 7;
> +		param->bandwidth = 7;
>  		break;
>  	case 6000000:
> -		param.bandwidth = 6;
> +		param->bandwidth = 6;
>  		break;
>  	}
>  
> -	err = dvb_usb_generic_rw(state->d,
> -			(char *)&param, sizeof(param),
> -			result, sizeof(result), 0);
> +	err = dvb_usb_generic_rw(state->d, state->data,
> sizeof(*param),
> +				 state->data, 2, 0);
>  	if (err < 0)
>  		err("cinergyt2_fe_set_frontend() Failed! err=%d\n",
> err); 

Reviewed-By: Patrick Boettcher <patrick.boettcher@posteo.de>
