Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58893 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab0CFRPJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Mar 2010 12:15:09 -0500
Received: by vws9 with SMTP id 9so2228315vws.19
        for <linux-media@vger.kernel.org>; Sat, 06 Mar 2010 09:15:06 -0800 (PST)
Date: Sat, 6 Mar 2010 09:15:02 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [git:v4l-dvb/master] Input: lifebook - add another Lifebook DMI
 signature
Message-ID: <20100306171501.GB24836@core.coreip.homeip.net>
References: <E1Nnuz1-0001ZP-DD@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Nnuz1-0001ZP-DD@www.linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guys,

Please fix your scripts, While it is useful to know if you applied
something to your tree that might affect input I am not really interested
in patches that are coming from mainline.

Thanks.

On Sat, Mar 06, 2010 at 03:27:59PM +0100, Patch from Jon Dodgson wrote:
> From: Jon Dodgson <crayzeejon@gmail.com>
> 
> There are many many ways one can capitalize "Lifebook B Series"...
> 
> Signed-off-by: Jon Dodgson <crayzeejon@gmail.com>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> 
>  drivers/input/mouse/lifebook.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> ---
> 
> http://git.linuxtv.org/v4l-dvb.git?a=commitdiff;h=57b5e2ae5b5f6b687ef2c644b1cb06bd217cdbe7
> 
> diff --git a/drivers/input/mouse/lifebook.c b/drivers/input/mouse/lifebook.c
> index 6d7aa10..7c1d7d4 100644
> --- a/drivers/input/mouse/lifebook.c
> +++ b/drivers/input/mouse/lifebook.c
> @@ -53,6 +53,12 @@ static const struct dmi_system_id __initconst lifebook_dmi_table[] = {
>  	{
>  		/* LifeBook B */
>  		.matches = {
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Lifebook B Series"),
> +		},
> +	},
> +	{
> +		/* LifeBook B */
> +		.matches = {
>  			DMI_MATCH(DMI_PRODUCT_NAME, "LifeBook B Series"),
>  		},
>  	},
> 

-- 
Dmitry
