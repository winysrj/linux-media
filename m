Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48710 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726782AbeG3Swa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 14:52:30 -0400
Date: Mon, 30 Jul 2018 14:16:27 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: mchehab@kernel.org, mchehab@s-opensource.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] dvb-frontends/tda18271c2dd: silence sparse fall
 through warning
Message-ID: <20180730141627.5d9f889e@coco.lan>
In-Reply-To: <20180624134250.8321-1-d.scheller.oss@gmail.com>
References: <20180624134250.8321-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 24 Jun 2018 15:42:50 +0200
Daniel Scheller <d.scheller.oss@gmail.com> escreveu:

> From: Daniel Scheller <d.scheller@gmx.net>
> 
> Add a break statement in set_params() for the SYS_DVBT(2) case to silence
> this sparse warning:
> 
>     drivers/media/dvb-frontends/tda18271c2dd.c:1144:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
> 
> as reported in Hans' daily media_tree builds.
> 
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/tda18271c2dd.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/dvb-frontends/tda18271c2dd.c b/drivers/media/dvb-frontends/tda18271c2dd.c
> index 2e1d36ae943b..fcffc7b4acf7 100644
> --- a/drivers/media/dvb-frontends/tda18271c2dd.c
> +++ b/drivers/media/dvb-frontends/tda18271c2dd.c
> @@ -1154,6 +1154,7 @@ static int set_params(struct dvb_frontend *fe)
>  		default:
>  			return -EINVAL;
>  		}
> +		break;

This actually seems to be a bug. Did you test this patch with
an actual hardware?

Regards,
Mauro

Thanks,
Mauro
