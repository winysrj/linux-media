Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:42105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab1EHQHE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 8 May 2011 12:07:04 -0400
Message-ID: <4DC6BF99.4030408@redhat.com>
Date: Sun, 08 May 2011 13:06:49 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org,
	Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH 2/6] cxd2820r: Remove temporary T2 API hack
References: <4DC417DA.5030107@redhat.com> <1304869873-9974-3-git-send-email-steve@stevekerrison.com>
In-Reply-To: <1304869873-9974-3-git-send-email-steve@stevekerrison.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Em 08-05-2011 12:51, Steve Kerrison escreveu:
> Unimplemented delivery system and modes were #define'd to
> arbitrary values for internal use. API now includes these values
> so we can remove this hack.
> 
> Signed-off-by: Steve Kerrison <steve@stevekerrison.com>
> ---
>  drivers/media/dvb/frontends/cxd2820r_priv.h |   12 ------------
>  1 files changed, 0 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/dvb/frontends/cxd2820r_priv.h b/drivers/media/dvb/frontends/cxd2820r_priv.h
> index d4e2e0b..25adbee 100644
> --- a/drivers/media/dvb/frontends/cxd2820r_priv.h
> +++ b/drivers/media/dvb/frontends/cxd2820r_priv.h
> @@ -40,18 +40,6 @@
>  #undef warn
>  #define warn(f, arg...) printk(KERN_WARNING LOG_PREFIX": " f "\n" , ## arg)
>  
> -/*
> - * FIXME: These are totally wrong and must be added properly to the API.
> - * Only temporary solution in order to get driver compile.
> - */
> -#define SYS_DVBT2             SYS_DAB
> -#define TRANSMISSION_MODE_1K  0
> -#define TRANSMISSION_MODE_16K 0
> -#define TRANSMISSION_MODE_32K 0
> -#define GUARD_INTERVAL_1_128  0
> -#define GUARD_INTERVAL_19_128 0
> -#define GUARD_INTERVAL_19_256 0
> -

Please, just fold this patch with Andreas one, adding a small note like:
[steve@...: removed the priv definitions from cxd2820r]

Otherwise, you'll be breaking git disect.

Thanks,
Mauro
