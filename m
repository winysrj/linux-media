Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab2HLPbB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Aug 2012 11:31:01 -0400
Message-ID: <5027CC2A.1060608@redhat.com>
Date: Sun, 12 Aug 2012 12:30:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH RFC 2/3] dvb_frontend: return -ENOTTY for unimplement
 IOCTL
References: <1344551101-16700-1-git-send-email-crope@iki.fi> <1344551101-16700-3-git-send-email-crope@iki.fi>
In-Reply-To: <1344551101-16700-3-git-send-email-crope@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 09-08-2012 19:25, Antti Palosaari escreveu:
> Earlier it was returning -EOPNOTSUPP.

This change makes all sense to me. We just need to be sure that this won't
cause any regressions on userspace apps.

Regards,
Mauro
> 
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> ---
>  drivers/media/dvb/dvb-core/dvb_frontend.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index 4548fc9..4fc11eb 100644
> --- a/drivers/media/dvb/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb/dvb-core/dvb_frontend.c
> @@ -1830,7 +1830,7 @@ static int dvb_frontend_ioctl(struct file *file,
>  	struct dvb_frontend *fe = dvbdev->priv;
>  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
>  	struct dvb_frontend_private *fepriv = fe->frontend_priv;
> -	int err = -EOPNOTSUPP;
> +	int err = -ENOTTY;
>  
>  	dev_dbg(fe->dvb->device, "%s: (%d)\n", __func__, _IOC_NR(cmd));
>  	if (fepriv->exit != DVB_FE_NO_EXIT)
> @@ -1948,7 +1948,7 @@ static int dvb_frontend_ioctl_properties(struct file *file,
>  		}
>  
>  	} else
> -		err = -EOPNOTSUPP;
> +		err = -ENOTTY;
>  
>  out:
>  	kfree(tvp);
> @@ -2081,7 +2081,7 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>  	struct dvb_frontend *fe = dvbdev->priv;
>  	struct dvb_frontend_private *fepriv = fe->frontend_priv;
>  	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
> -	int cb_err, err = -EOPNOTSUPP;
> +	int cb_err, err = -ENOTTY;
>  
>  	if (fe->dvb->fe_ioctl_override) {
>  		cb_err = fe->dvb->fe_ioctl_override(fe, cmd, parg,
> 

