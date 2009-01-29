Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53485 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbZA2JUO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 04:20:14 -0500
Date: Thu, 29 Jan 2009 07:19:58 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-media@vger.kernel.org, video4linux-list@redhat.com
Subject: Re: [PATCH] V4L/DVB: make card signed
Message-ID: <20090129071958.41c8349d@caramujo.chehab.org>
In-Reply-To: <497342D3.7050903@gmail.com>
References: <497342D3.7050903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Sun, 18 Jan 2009 15:55:15 +0100
Roel Kluin <roel.kluin@gmail.com> wrote:

> Is this correct?

No, it isn't. There's no sense on a negative value for a card.

> --------------->8----------8<----------------
> make card signed
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
> index ef9bf00..7c7a96c 100644
> --- a/drivers/media/video/em28xx/em28xx-cards.c
> +++ b/drivers/media/video/em28xx/em28xx-cards.c
> @@ -47,7 +47,7 @@ static unsigned int disable_ir;
>  module_param(disable_ir, int, 0444);
>  MODULE_PARM_DESC(disable_ir, "disable infrared remote support");
>  
> -static unsigned int card[]     = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
> +static int card[]     = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
>  module_param_array(card,  int, NULL, 0444);
>  MODULE_PARM_DESC(card,     "card type");
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
