Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:35237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab1DSVXD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 17:23:03 -0400
Message-ID: <4DADFD31.1010200@redhat.com>
Date: Tue, 19 Apr 2011 18:22:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: stefan.ringel@arcor.de
CC: linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH 2/5] tm6000: add dtv78 parameter
References: <1301948324-27186-1-git-send-email-stefan.ringel@arcor.de> <1301948324-27186-2-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1301948324-27186-2-git-send-email-stefan.ringel@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 04-04-2011 17:18, stefan.ringel@arcor.de escreveu:
> From: Stefan Ringel <stefan.ringel@arcor.de>
> 
> add dtv78 parameter

The dtv78 entry is a hack meant for card usage in Australia, that
speeds up channel detection there. Again, it should be specified
only when needed, and at per-board basis.
> 
> 
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> ---
>  drivers/staging/tm6000/tm6000-cards.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/tm6000/tm6000-cards.c b/drivers/staging/tm6000/tm6000-cards.c
> index eef58da..cf2e76c 100644
> --- a/drivers/staging/tm6000/tm6000-cards.c
> +++ b/drivers/staging/tm6000/tm6000-cards.c
> @@ -65,6 +65,9 @@ static unsigned int xc2028_mts;
>  module_param(xc2028_mts, int, 0644);
>  MODULE_PARM_DESC(xc2028_mts, "enable mts firmware (xc2028/3028 only)");
>  
> +static unsigned int xc2028_dtv78;
> +module_param(xc2028_dtv78, int, 0644);
> +MODULE_PARM_DESC(xc2028_dtv78, "enable dualband config (xc2028/3028 only)");
>  
>  struct tm6000_board {
>  	char            *name;
> @@ -687,8 +690,12 @@ static void tm6000_config_tuner(struct tm6000_core *dev)
>  		ctl.read_not_reliable = 0;
>  		ctl.msleep = 10;
>  		ctl.demod = XC3028_FE_ZARLINK456;
> -		ctl.vhfbw7 = 1;
> -		ctl.uhfbw8 = 1;
> +
> +		if (xc2028_dtv78) {
> +			ctl.vhfbw7 = 1;
> +			ctl.uhfbw8 = 1;
> +		}
> +
>  		if (xc2028_mts)
>  			ctl.mts = 1;
>  

