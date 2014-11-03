Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:8554 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbaKCOjM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Nov 2014 09:39:12 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NEG00MUAWPADT30@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Mon, 03 Nov 2014 09:39:10 -0500 (EST)
Date: Mon, 03 Nov 2014 12:39:07 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: tskd08@gmail.com
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] dvb:tc90522: fix stats report
Message-id: <20141103123907.61a0e2fc.m.chehab@samsung.com>
In-reply-to: <1414325424-16706-1-git-send-email-tskd08@gmail.com>
References: <1414325424-16706-1-git-send-email-tskd08@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 26 Oct 2014 21:10:24 +0900
tskd08@gmail.com escreveu:

> From: Akihiro Tsukada <tskd08@gmail.com>
> 
> * report per-transponder symbolrate instead of per-TS one (moved to dvb-core)
> * add output TS-ID report, which might be useful if an user did not specify
>   stream id or set a wrong one, and the demod chose the first TS_ID found.

Signed-off-by: is also missing here.

> ---
>  drivers/media/dvb-frontends/tc90522.c | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
> index bca81ef..b35d65c 100644
> --- a/drivers/media/dvb-frontends/tc90522.c
> +++ b/drivers/media/dvb-frontends/tc90522.c
> @@ -216,32 +216,30 @@ static int tc90522s_get_frontend(struct dvb_frontend *fe)
>  	c->delivery_system = SYS_ISDBS;
>  
>  	layers = 0;
> -	ret = reg_read(state, 0xe8, val, 3);
> +	ret = reg_read(state, 0xe6, val, 5);
>  	if (ret == 0) {
> -		int slots;
>  		u8 v;
>  
> +		c->stream_id = val[0] << 8 | val[1];
> +
>  		/* high/single layer */
> -		v = (val[0] & 0x70) >> 4;
> +		v = (val[2] & 0x70) >> 4;
>  		c->modulation = (v == 7) ? PSK_8 : QPSK;
>  		c->fec_inner = fec_conv_sat[v];
>  		c->layer[0].fec = c->fec_inner;
>  		c->layer[0].modulation = c->modulation;
> -		c->layer[0].segment_count = val[1] & 0x3f; /* slots */
> +		c->layer[0].segment_count = val[3] & 0x3f; /* slots */
>  
>  		/* low layer */
> -		v = (val[0] & 0x07);
> +		v = (val[2] & 0x07);
>  		c->layer[1].fec = fec_conv_sat[v];
>  		if (v == 0)  /* no low layer */
>  			c->layer[1].segment_count = 0;
>  		else
> -			c->layer[1].segment_count = val[2] & 0x3f; /* slots */
> +			c->layer[1].segment_count = val[4] & 0x3f; /* slots */
>  		/* actually, BPSK if v==1, but not defined in fe_modulation_t */
>  		c->layer[1].modulation = QPSK;
>  		layers = (v > 0) ? 2 : 1;
> -
> -		slots =  c->layer[0].segment_count +  c->layer[1].segment_count;
> -		c->symbol_rate = 28860000 * slots / 48;
>  	}
>  
>  	/* statistics */
