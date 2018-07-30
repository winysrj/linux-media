Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:43076 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726629AbeG3Qk4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jul 2018 12:40:56 -0400
Date: Mon, 30 Jul 2018 12:05:28 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: mchehab@kernel.org, mchehab@s-opensource.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 01/19] [media] dvb-frontends/mxl5xx: add break to case
 DVBS2 in get_frontend()
Message-ID: <20180730120528.689c231a@coco.lan>
In-Reply-To: <20180623153615.27630-2-d.scheller.oss@gmail.com>
References: <20180623153615.27630-1-d.scheller.oss@gmail.com>
        <20180623153615.27630-2-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 23 Jun 2018 17:35:57 +0200
Daniel Scheller <d.scheller.oss@gmail.com> escreveu:

> From: Daniel Scheller <d.scheller@gmx.net>
> 
> Fix one sparse warning:
> 
>     drivers/media/dvb-frontends/mxl5xx.c:731:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
> 
> as seen in Hans' daily media_tree builds.
> 
> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
>  drivers/media/dvb-frontends/mxl5xx.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
> index 274d8fca0763..a7d08ace11ba 100644
> --- a/drivers/media/dvb-frontends/mxl5xx.c
> +++ b/drivers/media/dvb-frontends/mxl5xx.c
> @@ -739,6 +739,7 @@ static int get_frontend(struct dvb_frontend *fe,
>  		default:
>  			break;
>  		}
> +		break;
>  	case SYS_DVBS:
>  		switch ((enum MXL_HYDRA_MODULATION_E)
>  			reg_data[DMD_MODULATION_SCHEME_ADDR]) {

Are you sure this is the right thing to do here? looking at the
code, I suspect that it should, instead, just adding a comment, as
the stuff below the SYS_DVBS case seem to be needed also for DVB-S2.



Thanks,
Mauro
