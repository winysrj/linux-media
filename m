Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab1LUNyi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Dec 2011 08:54:38 -0500
Message-ID: <4EF1E519.1010600@redhat.com>
Date: Wed, 21 Dec 2011 11:54:33 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Gareth Williams <gareth@garethwilliams.me.uk>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] Fixed detection of EMP202 audio chip. Some versions
 have an id of 0x83847650 instead of 0xffffffff.
References: <3535794.dt3qgLM7n9@kubuntu>
In-Reply-To: <3535794.dt3qgLM7n9@kubuntu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20-12-2011 19:45, Gareth Williams wrote:
> Signed-off-by: Gareth Williams <gareth@garethwilliams.me.uk>
> 
> Honestech Vidbox NW03 has a EMP202 audio chip with a different Vendor ID.
> 
> Apparently, it is the same with the Gadmei ITV380:
> http://linuxtv.org/wiki/index.php/Gadmei_USB_TVBox_UTV380
> 
> ---
>  linux/drivers/media/video/em28xx/em28xx-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/linux/drivers/media/video/em28xx/em28xx-core.c b/linux/drivers/media/video/em28xx/em28xx-core.c
> index 804a4ab..2982a06 100644
> --- a/linux/drivers/media/video/em28xx/em28xx-core.c
> +++ b/linux/drivers/media/video/em28xx/em28xx-core.c
> @@ -568,7 +568,7 @@ int em28xx_audio_setup(struct em28xx *dev)
>  	em28xx_warn("AC97 features = 0x%04x\n", feat);
>  
>  	/* Try to identify what audio processor we have */
> -	if ((vid == 0xffffffff) && (feat == 0x6a90))
> +	if (((vid == 0xffffffff) || (vid == 0x83847650)) && (feat == 0x6a90))

Are you sure you don't have, instead a STAC9750? 0x83647650 is the code
for this chip. Did you open your device to be sure it is really an em202?

Vendors are free to put whatever AC97 chip they want. Each of them have 
their own differences (different sample rate, different volume controls,
etc).

While miss-identifying it may work for your usecase, it will fail for
other usecases. The good news is that, in general, the datasheets for
AC97 mixers are generally easy to find on Google. Most vendors release them
publicly.

Regards,
Mauro
