Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab0BHL1e (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 8 Feb 2010 06:27:34 -0500
Message-ID: <4B6FF51F.9080507@redhat.com>
Date: Mon, 08 Feb 2010 09:27:27 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: stefan.ringel@arcor.de
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 11/12] tm6000: bugfix firmware xc3028L-v36.fw used with
 Zarlink and DTV78 or DTV8 no shift
References: <1265411214-12231-10-git-send-email-stefan.ringel@arcor.de> <1265411214-12231-11-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1265411214-12231-11-git-send-email-stefan.ringel@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

stefan.ringel@arcor.de wrote:
> From: Stefan Ringel <stefan.ringel@arcor.de>
> 
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> ---
>  drivers/media/common/tuners/tuner-xc2028.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
> index ed50168..fcf19cc 100644
> --- a/drivers/media/common/tuners/tuner-xc2028.c
> +++ b/drivers/media/common/tuners/tuner-xc2028.c
> @@ -1114,7 +1114,12 @@ static int xc2028_set_params(struct dvb_frontend *fe,
>  
>  	/* All S-code tables need a 200kHz shift */
>  	if (priv->ctrl.demod) {
> -		demod = priv->ctrl.demod + 200;
> +		if ((strcmp (priv->ctrl.fname, "xc3028L-v36.fw") == 0) && 
> +			(priv->ctrl.demod == XC3028_FE_ZARLINK456) &&
> +				((type & DTV78) || (type & DTV8)))
> +			demod = priv->ctrl.demod;
> +		else
> +			demod = priv->ctrl.demod + 200;
>  		/*
>  		 * The DTV7 S-code table needs a 700 kHz shift.
>  		 * Thanks to Terry Wu <terrywu2009@gmail.com> for reporting this

The idea behind this patch is right, but you should be testing it against
priv->firm_version, instead comparing with a file name.

Also, this will likely cause regressions on other drivers, since the offsets for
v3.6 firmwares were handled on a different way on other drivers. I prefer to postpone
this patch and the discussion behind it after having tm6000 driver ready, since
it makes no sense to cause regressions or request changes on existing drivers due
to a driver that is not ready yet.

So, please hold your patch on your queue for now.

My suggestion is that you should use git and have this patch on a separate branch where you
do your tests, having a branch without this patch for upstream submission.

-- 

Cheers,
Mauro
