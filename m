Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381Ab3BEXAv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 5 Feb 2013 18:00:51 -0500
Date: Tue, 5 Feb 2013 21:00:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Michael Krufky <mkrufky@kernellabs.com>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [media] tuners/xc5000: fix MODE_AIR in xc5000_set_params()
Message-ID: <20130205210034.59034ed2@redhat.com>
In-Reply-To: <20130113193133.GA5907@elgon.mountain>
References: <20130113193133.GA5907@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 13 Jan 2013 22:31:33 +0300
Dan Carpenter <dan.carpenter@oracle.com> escreveu:

> There is a missing break so we use XC_RF_MODE_CABLE instead of
> XC_RF_MODE_AIR.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Static checker stuff.  Untested.
> 
> diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
> index dc93cf3..d6be1b6 100644
> --- a/drivers/media/tuners/xc5000.c
> +++ b/drivers/media/tuners/xc5000.c
> @@ -785,6 +785,7 @@ static int xc5000_set_params(struct dvb_frontend *fe)
>  			return -EINVAL;
>  		}
>  		priv->rf_mode = XC_RF_MODE_AIR;
> +		break;

There one small change with this patch. On this part of the code:

static int xc_SetSignalSource(struct xc5000_priv *priv, u16 rf_mode)
{
        dprintk(1, "%s(%d) Source = %s\n", __func__, rf_mode,
                rf_mode == XC_RF_MODE_AIR ? "ANTENNA" : "CABLE");

        if ((rf_mode != XC_RF_MODE_AIR) && (rf_mode != XC_RF_MODE_CABLE)) {
                rf_mode = XC_RF_MODE_CABLE;
                printk(KERN_ERR
                        "%s(), Invalid mode, defaulting to CABLE",
                        __func__);
        }
        return xc_write_reg(priv, XREG_SIGNALSOURCE, rf_mode);
}

It will set the value for XREG_SIGNALSOURCE with a different value.

While I didn't test it, such change makes sense, by looking at xc5000
"open source" datasheet.

So, it looks correct on my eyes.

While the datasheet doesn't give any glue, my guess is that changing from
"cable" to "air" will just optimize the tuner's sensibility for either
air (where signals can be weaker) or cable, so I bet that the effects of
a change like that won't be easily noticed.

I'll apply it, in order to give people some chance to test it.

Cheers,
Mauro
