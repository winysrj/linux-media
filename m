Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49958 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab2BNWgC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Feb 2012 17:36:02 -0500
Received: by wgbdt10 with SMTP id dt10so339082wgb.1
        for <linux-media@vger.kernel.org>; Tue, 14 Feb 2012 14:36:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKdnbx4BJ6PN5TEUBiueF9Q7gscRDSPAObzPFUFsbKK0HmbyZg@mail.gmail.com>
References: <CAKdnbx4BJ6PN5TEUBiueF9Q7gscRDSPAObzPFUFsbKK0HmbyZg@mail.gmail.com>
From: Eddi De Pieri <eddi@depieri.net>
Date: Tue, 14 Feb 2012 23:35:41 +0100
Message-ID: <CAKdnbx7FFd0WaCSrD+6MCoX5_Vy=gy-D0aNk+cXs5x67-s1W6g@mail.gmail.com>
Subject: Re: [PATCH] smsdvb - fix UNDEFINED delivery on driver hotplug
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Someone can confirm my changes?

Regards,

Eddi

On Thu, Feb 2, 2012 at 10:13 AM, Eddi De Pieri <eddi@depieri.net> wrote:
> #dvb-fe-tool -a 1 -d DVBT
>
> Device Siano Mobile Digital MDTV Receiver (/dev/dvb/adapter1/frontend0)
> capabilities:
>
>         CAN_FEC_1_2 CAN_FEC_2_3 CAN_FEC_3_4 CAN_FEC_5_6 CAN_FEC_7_8
> CAN_FEC_AUTO CAN_GUARD_INTERVAL_AUTO CAN_HIERARCHY_AUTO CAN_INVERSION_AUTO
> CAN_QAM_16 CAN_QAM_64 CAN_QAM_AUTO CAN_QPSK CAN_RECOVER
> CAN_TRANSMISSION_MODE_AUTO
>
> DVB API Version 5.5, Current v5 delivery system: UNDEFINED
>
>
> Signed-off-by: Eddi De Pieri <eddi@depieri.net>
> ---
>  drivers/media/dvb/siano/smsdvb.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/dvb/siano/smsdvb.c
> b/drivers/media/dvb/siano/smsdvb.c
> index 654685c..7b584cb 100644
> --- a/drivers/media/dvb/siano/smsdvb.c
> +++ b/drivers/media/dvb/siano/smsdvb.c
> @@ -866,9 +866,6 @@ static int smsdvb_hotplug(struct smscore_device_t
> *coredev,
>         }
>
>         /* init and register frontend */
> -       memcpy(&client->frontend.ops, &smsdvb_fe_ops,
> -              sizeof(struct dvb_frontend_ops));
> -
>         switch (smscore_get_device_mode(coredev)) {
>         case DEVICE_MODE_DVBT:
>         case DEVICE_MODE_DVBT_BDA:
> @@ -880,6 +877,9 @@ static int smsdvb_hotplug(struct smscore_device_t
> *coredev,
>                 break;
>         }
>
> +       memcpy(&client->frontend.ops, &smsdvb_fe_ops,
> +              sizeof(struct dvb_frontend_ops));
> +
>         rc = dvb_register_frontend(&client->adapter, &client->frontend);
>         if (rc < 0) {
>                 sms_err("frontend registration failed %d", rc);
> --
> 1.7.2.5
>
>
