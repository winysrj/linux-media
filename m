Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:35699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755888Ab1DSVV3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 17:21:29 -0400
Message-ID: <4DADFCD2.1090401@redhat.com>
Date: Tue, 19 Apr 2011 18:21:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: stefan.ringel@arcor.de
CC: linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH 1/5] tm6000: add mts parameter
References: <1301948324-27186-1-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1301948324-27186-1-git-send-email-stefan.ringel@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 04-04-2011 17:18, stefan.ringel@arcor.de escreveu:
> From: Stefan Ringel <stefan.ringel@arcor.de>
> 
> add mts parameter

Stefan,

The MTS config depends on the specific board design (generally present on
mono NTSC cards). So, it should be inside the cards struct, and not 
provided as an userspace parameter.

Mauro.
> 
> 
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> ---
>  drivers/staging/tm6000/tm6000-cards.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
> index 146c7e8..eef58da 100644
> --- a/drivers/staging/tm6000/tm6000-cards.c
> +++ b/drivers/staging/tm6000/tm6000-cards.c
> @@ -61,6 +61,10 @@ module_param_array(card,  int, NULL, 0444);
>  
>  static unsigned long tm6000_devused;
>  
> +static unsigned int xc2028_mts;
> +module_param(xc2028_mts, int, 0644);
> +MODULE_PARM_DESC(xc2028_mts, "enable mts firmware (xc2028/3028 only)");
> +
>  
>  struct tm6000_board {
>  	char            *name;
> @@ -685,6 +689,9 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
>  		ctl.demod = XC3028_FE_ZARLINK456;
>  		ctl.vhfbw7 = 1;
>  		ctl.uhfbw8 = 1;
> +		if (xc2028_mts)
> +			ctl.mts = 1;
> +
>  		xc2028_cfg.tuner = TUNER_XC2028;
>  		xc2028_cfg.priv  = &ctl;
>  

