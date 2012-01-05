Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:52964 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757613Ab2AEQTJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 11:19:09 -0500
Received: by eekc4 with SMTP id c4so472427eek.19
        for <linux-media@vger.kernel.org>; Thu, 05 Jan 2012 08:19:08 -0800 (PST)
Message-ID: <4F05CD76.3080404@googlemail.com>
Date: Thu, 05 Jan 2012 17:19:02 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 4/9] [media] dvb_frontend: Don't use ops->info.type anymore
References: <1325448678-13001-1-git-send-email-mchehab@redhat.com> <1325448678-13001-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1325448678-13001-5-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 01.01.2012 21:11, schrieb Mauro Carvalho Chehab:
> Get rid of using ops->info.type defined on DVB drivers,
> as it doesn't apply anymore.
....
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/dvb/dvb-core/dvb_frontend.c |  541 ++++++++++++++---------------
>  1 files changed, 266 insertions(+), 275 deletions(-)
....
> diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.c b/drivers/media/dvb/dvb-core/dvb_frontend.c
> index eefcb7f..7f6ce06 100644
> @@ -1902,6 +1850,37 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>  		memcpy(info, &fe->ops.info, sizeof(struct dvb_frontend_info));
>  		dvb_frontend_get_frequency_limits(fe, &info->frequency_min, &info->frequency_max);
>  
> +		/*
> +		 * Associate the 4 delivery systems supported by DVBv3
> +		 * API with their DVBv5 counterpart. For the other standards,
> +		 * use the closest type, assuming that it would hopefully
> +		 * work with a DVBv3 application.
> +		 * It should be noticed that, on multi-frontend devices with
> +		 * different types (terrestrial and cable, for example),
> +		 * a pure DVBv3 application won't be able to use all delivery
> +		 * systems. Yet, changing the DVBv5 cache to the other delivery
> +		 * system should be enough for making it work.
> +		 */
> +		switch (dvbv3_type(c->delivery_system)) {
> +		case DVBV3_QPSK:
> +			fe->ops.info.type = FE_QPSK;
> +			break;
> +		case DVBV3_ATSC:
> +			fe->ops.info.type = FE_ATSC;
> +			break;
> +		case DVBV3_QAM:
> +			fe->ops.info.type = FE_QAM;
> +			break;
> +		case DVBV3_OFDM:
> +			fe->ops.info.type = FE_OFDM;
> +			break;
> +		default:
> +			printk(KERN_ERR
> +			       "%s: doesn't know how to handle a DVBv3 call to delivery system %i\n",
> +			       __func__, c->delivery_system);
> +			fe->ops.info.type = FE_OFDM;
> +		}
> +

Hi,

I think this is partly wrong. The old delivery system values must be set in the given data
structure from caller:

fe->ops.info.type = FE_QAM;

must be replace by

info->type = FE_QAM;

Regards,
Hartmut
