Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:32779 "EHLO
	mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbcGGOoX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2016 10:44:23 -0400
Received: by mail-io0-f175.google.com with SMTP id t74so23934707ioi.0
        for <linux-media@vger.kernel.org>; Thu, 07 Jul 2016 07:44:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1467846004-12731-2-git-send-email-steve_longerbeam@mentor.com>
References: <1467846004-12731-1-git-send-email-steve_longerbeam@mentor.com> <1467846004-12731-2-git-send-email-steve_longerbeam@mentor.com>
From: Tim Harvey <tharvey@gateworks.com>
Date: Thu, 7 Jul 2016 07:44:22 -0700
Message-ID: <CAJ+vNU1uKZ_KSg-kArVQvNgg6+A0RkigsL6Oj4pX-4dVAwKnwA@mail.gmail.com>
Subject: Re: [PATCH 01/11] media: adv7180: Fix broken interrupt register access
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Federico Vaga <federico.vaga@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	=?UTF-8?Q?Niklas_S=C3=B6derlund?=
	<niklas.soderlund+renesas@ragnatech.se>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 6, 2016 at 3:59 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:
> Access to the interrupt page registers has been broken since
> at least 3999e5d01da74f1a22afbb0b61b3992fea301478. That commit
> forgot to add the inerrupt page number to the register defines.
>
> Signed-off-by: Steve Longerbeam <steve_longerbeam@mentor.com>
> ---
>  drivers/media/i2c/adv7180.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index b77b0a4..95cbc85 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -100,7 +100,7 @@
>  #define ADV7180_REG_IDENT 0x0011
>  #define ADV7180_ID_7180 0x18
>
> -#define ADV7180_REG_ICONF1             0x0040
> +#define ADV7180_REG_ICONF1             0x2040
>  #define ADV7180_ICONF1_ACTIVE_LOW      0x01
>  #define ADV7180_ICONF1_PSYNC_ONLY      0x10
>  #define ADV7180_ICONF1_ACTIVE_TO_CLR   0xC0
> @@ -113,15 +113,15 @@
>
>  #define ADV7180_IRQ1_LOCK      0x01
>  #define ADV7180_IRQ1_UNLOCK    0x02
> -#define ADV7180_REG_ISR1       0x0042
> -#define ADV7180_REG_ICR1       0x0043
> -#define ADV7180_REG_IMR1       0x0044
> -#define ADV7180_REG_IMR2       0x0048
> +#define ADV7180_REG_ISR1       0x2042
> +#define ADV7180_REG_ICR1       0x2043
> +#define ADV7180_REG_IMR1       0x2044
> +#define ADV7180_REG_IMR2       0x2048
>  #define ADV7180_IRQ3_AD_CHANGE 0x08
> -#define ADV7180_REG_ISR3       0x004A
> -#define ADV7180_REG_ICR3       0x004B
> -#define ADV7180_REG_IMR3       0x004C
> -#define ADV7180_REG_IMR4       0x50
> +#define ADV7180_REG_ISR3       0x204A
> +#define ADV7180_REG_ICR3       0x204B
> +#define ADV7180_REG_IMR3       0x204C
> +#define ADV7180_REG_IMR4       0x2050
>
>  #define ADV7180_REG_NTSC_V_BIT_END     0x00E6
>  #define ADV7180_NTSC_V_BIT_END_MANUAL_NVEND    0x4F
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Tested on an IMX6 Gateworks Ventana with IMX6 capture drivers from Steve [1]

Tested-by: Tim Harvey <tharvey@gateworks.com>
Acked-by: Tim Harvey <tharvey@gateworks.com>

Added to Cc list those who signed-off and acked
3999e5d01da74f1a22afbb0b61b3992fea301478

[1] - http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/102914
