Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48449 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750864AbdLVTCY (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 22 Dec 2017 14:02:24 -0500
Date: Fri, 22 Dec 2017 17:02:17 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Hans Verkuil <hansverk@cisco.com>,
        Colin Ian King <colin.king@canonical.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] dvb-frontends: remove self assignments
Message-ID: <20171219110817.5979d60c@vento.lan>
In-Reply-To: <20171218171454.139245-1-ndesaulniers@google.com>
References: <20171218171454.139245-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 18 Dec 2017 09:14:50 -0800
Nick Desaulniers <ndesaulniers@google.com> escreveu:

> These were leftover from:
> commit 469ffe083665 ("[media] tda18271c2dd: Remove the CHK_ERROR macro")
> and
> commit 58d5eaec9f87 ("[media] drxd: Don't use a macro for CHK_ERROR ...")
> that programmatically removed the CHK_ERROR macro, which left behind a
> few self assignments that Clang warns about.  These instances aren't
> errors.
> 
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>

Thanks for the patch, but a similar one was already merged:

commit 2ddc125de832f4d8e1820dc923cb2029170beea0
Author: Colin Ian King <colin.king@canonical.com>
Date:   Thu Nov 23 05:19:19 2017 -0500

    media: dvb_frontend: remove redundant status self assignment
    
    The assignment status to itself is redundant and can be removed.
    Detected with Coccinelle.
    
    Signed-off-by: Colin Ian King <colin.king@canonical.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>


> ---
>  drivers/media/dvb-frontends/drxd_hard.c    | 3 ---
>  drivers/media/dvb-frontends/tda18271c2dd.c | 1 -
>  2 files changed, 4 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/drxd_hard.c b/drivers/media/dvb-frontends/drxd_hard.c
> index 0696bc62dcc9..ff18a0f7dc41 100644
> --- a/drivers/media/dvb-frontends/drxd_hard.c
> +++ b/drivers/media/dvb-frontends/drxd_hard.c
> @@ -2140,7 +2140,6 @@ static int DRX_Start(struct drxd_state *state, s32 off)
>  			}
>  			break;
>  		}
> -		status = status;
>  		if (status < 0)
>  			break;
>  
> @@ -2251,7 +2250,6 @@ static int DRX_Start(struct drxd_state *state, s32 off)
>  			break;
>  
>  		}
> -		status = status;
>  		if (status < 0)
>  			break;
>  
> @@ -2318,7 +2316,6 @@ static int DRX_Start(struct drxd_state *state, s32 off)
>  			}
>  			break;
>  		}
> -		status = status;
>  		if (status < 0)
>  			break;
>  
> diff --git a/drivers/media/dvb-frontends/tda18271c2dd.c b/drivers/media/dvb-frontends/tda18271c2dd.c
> index 2d2778be2d2f..45cd5ba0cf8a 100644
> --- a/drivers/media/dvb-frontends/tda18271c2dd.c
> +++ b/drivers/media/dvb-frontends/tda18271c2dd.c
> @@ -674,7 +674,6 @@ static int PowerScan(struct tda_state *state,
>  			Count = 200000;
>  			wait = true;
>  		}
> -		status = status;
>  		if (status < 0)
>  			break;
>  		if (CID_Gain >= CID_Target) {



Thanks,
Mauro
