Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333Ab2IOQeU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 12:34:20 -0400
Date: Sat, 15 Sep 2012 13:34:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Anders Thomson <aeriksson2@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: tda8290 regression fix
Message-ID: <20120915133417.27cb82a1@redhat.com>
In-Reply-To: <503F4E19.1050700@gmail.com>
References: <503F4E19.1050700@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 30 Aug 2012 13:27:21 +0200
Anders Thomson <aeriksson2@gmail.com> escreveu:

> Hi,
> 
> Ever since 2.6.26 or so (where there was a code reorg) I had to carry 
> this patch.
> Without it the received signal is noisy, and the card worked fine prior 
> to the code
> reorg. This patch is a hack, mostly as a result of my inability to 
> follow the code
> paths (and bisect failing). I'd be more than willing to test whatever 
> the proper
> patch might be prior to any mainlining.
> 
> Thanks,
> /Anders
> 
> 
> 
> $ cat /TV_CARD.diff
> diff --git a/drivers/media/common/tuners/tda8290.c 
> b/drivers/media/common/tuners/tda8290.c
> index 064d14c..498cc7b 100644
> --- a/drivers/media/common/tuners/tda8290.c
> +++ b/drivers/media/common/tuners/tda8290.c
> @@ -635,7 +635,11 @@ static int tda829x_find_tuner(struct dvb_frontend *fe)
> 
>                  dvb_attach(tda827x_attach, fe, priv->tda827x_addr,
>                             priv->i2c_props.adap, &priv->cfg);
> +               tuner_info("ANDERS: setting switch_addr. was 0x%02x, new 
> 0x%02x\n",priv->cfg.switch_addr,priv->i2c_props.addr);
>                  priv->cfg.switch_addr = priv->i2c_props.addr;
> +               priv->cfg.switch_addr = 0xc2 / 2;

No, this is wrong. The I2C address is passed by the bridge driver or by
the tuner_core attachment, being stored at priv->i2c_props.addr.

What's the driver and card you're using?

> +               tuner_info("ANDERS: new 0x%02x\n",priv->cfg.switch_addr);
> +
>          }
>          if (fe->ops.tuner_ops.init)
>                  fe->ops.tuner_ops.init(fe);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Regards,
Mauro
