Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:26585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab1DSV0Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 17:26:16 -0400
Message-ID: <4DADFDF1.9020108@redhat.com>
Date: Tue, 19 Apr 2011 18:26:09 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: stefan.ringel@arcor.de
CC: linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH 3/5] tm6000: add audio mode parameter
References: <1301948324-27186-1-git-send-email-stefan.ringel@arcor.de> <1301948324-27186-3-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1301948324-27186-3-git-send-email-stefan.ringel@arcor.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 04-04-2011 17:18, stefan.ringel@arcor.de escreveu:
> From: Stefan Ringel <stefan.ringel@arcor.de>
> 
> add audio mode parameter

Why we need a parameter for it? It should be determined based on
the standard.

> 
> Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
> ---
>  drivers/staging/tm6000/tm6000-stds.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/tm6000/tm6000-stds.c b/drivers/staging/tm6000/tm6000-stds.c
> index da3e51b..a9e1921 100644
> --- a/drivers/staging/tm6000/tm6000-stds.c
> +++ b/drivers/staging/tm6000/tm6000-stds.c
> @@ -22,12 +22,17 @@
>  #include "tm6000.h"
>  #include "tm6000-regs.h"
>  
> +static unsigned int tm6010_a_mode;
> +module_param(tm6010_a_mode, int, 0644);
> +MODULE_PARM_DESC(tm6010_a_mode, "set sif audio mode (tm6010 only)");
> +
>  struct tm6000_reg_settings {
>  	unsigned char req;
>  	unsigned char reg;
>  	unsigned char value;
>  };
>  
> +/* must be updated */
>  enum tm6000_audio_std {
>  	BG_NICAM,
>  	BTSC,

