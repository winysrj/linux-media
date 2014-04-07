Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:48507 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753301AbaDGPJN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 11:09:13 -0400
Date: Mon, 7 Apr 2014 12:08:46 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] [media] stk1160: warrant a NUL terminated string
Message-ID: <20140407150846.GA1122@arch.cereza>
References: <1396878140-22084-1-git-send-email-m.chehab@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396878140-22084-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Apr 07, Mauro Carvalho Chehab wrote:
> strncpy() doesn't warrant a NUL terminated string. Use
> strlcpy() instead.
> 
> Fixes Coverity bug CID#1195195.
> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
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

Shame on me.

Acked-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
