Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53125 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab2EHXfw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 19:35:52 -0400
Received: by wibhn19 with SMTP id hn19so701099wib.1
        for <linux-media@vger.kernel.org>; Tue, 08 May 2012 16:35:51 -0700 (PDT)
Message-ID: <1336520140.3125.3.camel@router7789>
Subject: Re: [PATCH 2/2] TeVii DVB-S s421 and s632 cards support, rs2000 part
From: Malcolm Priestley <tvboxspy@gmail.com>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Wed, 09 May 2012 00:35:40 +0100
In-Reply-To: <11624830.SAH8sWiIMs@useri>
References: <11624830.SAH8sWiIMs@useri>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2012-05-08 at 11:08 +0300, Igor M. Liplianin wrote:
> One register needs to be changed to TS to work. So we use separate inittab.
> 
> Signed-off-by: Igor M. Liplianin <liplianin@me.by>
Acked-by: Malcolm Priestley <tvboxspy@gmail.com>

differences between files attachment (rs2000dw2102.patch)
> diff --git a/drivers/media/dvb/frontends/m88rs2000.c b/drivers/media/dvb/frontends/m88rs2000.c
> index 045ee5a..547230d 100644
> --- a/drivers/media/dvb/frontends/m88rs2000.c
> +++ b/drivers/media/dvb/frontends/m88rs2000.c
> @@ -442,7 +442,11 @@ static int m88rs2000_init(struct dvb_frontend *fe)
>  
>  	deb_info("m88rs2000: init chip\n");
>  	/* Setup frontend from shutdown/cold */
> -	ret = m88rs2000_tab_set(state, m88rs2000_setup);
> +	if (state->config->inittab)
> +		ret = m88rs2000_tab_set(state,
> +				(struct inittab *)state->config->inittab);
> +	else
> +		ret = m88rs2000_tab_set(state, m88rs2000_setup);
>  
>  	return ret;
>  }
Regards


Malcolm


