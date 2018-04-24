Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:45710 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751555AbeDXRVQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 13:21:16 -0400
Date: Tue, 24 Apr 2018 19:21:13 +0200
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] media: mxl5xx: fix get_algo()'s return type
Message-ID: <20180424192113.57f38207@lt530>
In-Reply-To: <20180424131932.6170-1-luc.vanoostenryck@gmail.com>
References: <20180424131932.6170-1-luc.vanoostenryck@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Tue, 24 Apr 2018 15:19:31 +0200
schrieb Luc Van Oostenryck <luc.vanoostenryck@gmail.com>:

> The method dvb_frontend_ops::get_frontend_algo() is defined as
> returning an 'enum dvbfe_algo', but the implementation in this
> driver returns an 'int'.
> 
> Fix this by returning 'enum dvbfe_algo' in this driver too.
> 
> Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
> ---
>  drivers/media/dvb-frontends/mxl5xx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
> index 483ee7d61..274d8fca0 100644
> --- a/drivers/media/dvb-frontends/mxl5xx.c
> +++ b/drivers/media/dvb-frontends/mxl5xx.c
> @@ -375,7 +375,7 @@ static void release(struct dvb_frontend *fe)
>  	kfree(state);
>  }
>  
> -static int get_algo(struct dvb_frontend *fe)
> +static enum dvbfe_algo get_algo(struct dvb_frontend *fe)
>  {
>  	return DVBFE_ALGO_HW;
>  }

Acked-by: Daniel Scheller <d.scheller@gmx.net>

Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
