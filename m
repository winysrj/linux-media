Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1183 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaDGNqr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 09:46:47 -0400
Message-ID: <5342AC0E.4050203@xs4all.nl>
Date: Mon, 07 Apr 2014 15:45:50 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] stk1160: warrant a NUL terminated string
References: <1396878140-22084-1-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1396878140-22084-1-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/07/2014 03:42 PM, Mauro Carvalho Chehab wrote:
> strncpy() doesn't warrant a NUL terminated string. Use
> strlcpy() instead.
> 
> Fixes Coverity bug CID#1195195.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>

My good deed for the day:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/media/usb/stk1160/stk1160-ac97.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/usb/stk1160/stk1160-ac97.c
> index c46c8be89602..2dd308f9541f 100644
> --- a/drivers/media/usb/stk1160/stk1160-ac97.c
> +++ b/drivers/media/usb/stk1160/stk1160-ac97.c
> @@ -108,7 +108,7 @@ int stk1160_ac97_register(struct stk1160 *dev)
>  		 "stk1160-mixer");
>  	snprintf(card->longname, sizeof(card->longname),
>  		 "stk1160 ac97 codec mixer control");
> -	strncpy(card->driver, dev->dev->driver->name, sizeof(card->driver));
> +	strlcpy(card->driver, dev->dev->driver->name, sizeof(card->driver));
>  
>  	rc = snd_ac97_bus(card, 0, &stk1160_ac97_ops, NULL, &ac97_bus);
>  	if (rc)
> 

