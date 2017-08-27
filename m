Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55352
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751152AbdH0MSP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 27 Aug 2017 08:18:15 -0400
Date: Sun, 27 Aug 2017 09:18:07 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Daniel Scheller <d.scheller.oss@gmail.com>
Cc: linux-media@vger.kernel.org, mchehab@kernel.org, jasmin@anw.at,
        rjkm@metzlerbros.de
Subject: Re: [PATCH] [media] dvb-frontends/mxl5xx: fix lock check order
Message-ID: <20170827091807.404a9907@vento.lan>
In-Reply-To: <20170820104545.6596-1-d.scheller.oss@gmail.com>
References: <20170820104545.6596-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 20 Aug 2017 12:45:45 +0200
Daniel Scheller <d.scheller.oss@gmail.com> escreveu:

> From: Daniel Scheller <d.scheller@gmx.net>
> 

Always add a description at the patch.


> Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
> ---
> When the mxl5xx driver together with the ddbridge glue gets merged ([1]),
> this one should go in aswell - this fix is part of the dddvb-0.9.31
> release.
> 
>  drivers/media/dvb-frontends/mxl5xx.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
> index 676c96c216c3..d9136d67f5d4 100644
> --- a/drivers/media/dvb-frontends/mxl5xx.c
> +++ b/drivers/media/dvb-frontends/mxl5xx.c
> @@ -638,13 +638,14 @@ static int tune(struct dvb_frontend *fe, bool re_tune,
>  		state->tune_time = jiffies;
>  		return 0;
>  	}
> -	if (*status & FE_HAS_LOCK)
> -		return 0;
>  
>  	r = read_status(fe, status);
>  	if (r)
>  		return r;
>  
> +	if (*status & FE_HAS_LOCK)
> +		return 0;
> +
>  	return 0;

That's stupid! it will return 0 on all situations, no matter if FE_HAS_LOCK
or not. So, no need for the if.

Anyway, IMHO, either the original code is right and it needs to
use a previously cached value (with sounds weird to me, although
it is possible), or the logic is utterly broken, and we should,
instead, apply the enclosed patch.

>  	if (r)
>  		return r;

>  }
>  

Thanks,
Mauro

[PATCH RFC] media: mxl5xx: fix tuning logic

The tuning logic is broken with regards to status report:
it relies on a previously-cached value that may not be valid
if retuned.

Change the logic to always read the status.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>


diff --git a/drivers/media/dvb-frontends/mxl5xx.c b/drivers/media/dvb-frontends/mxl5xx.c
index 676c96c216c3..4b449a6943c5 100644
--- a/drivers/media/dvb-frontends/mxl5xx.c
+++ b/drivers/media/dvb-frontends/mxl5xx.c
@@ -636,16 +636,9 @@ static int tune(struct dvb_frontend *fe, bool re_tune,
 		if (r)
 			return r;
 		state->tune_time = jiffies;
-		return 0;
 	}
-	if (*status & FE_HAS_LOCK)
-		return 0;
 
-	r = read_status(fe, status);
-	if (r)
-		return r;
-
-	return 0;
+	return read_status(fe, status);
 }
 
 static enum fe_code_rate conv_fec(enum MXL_HYDRA_FEC_E fec)
