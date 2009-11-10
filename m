Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:62032 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZKJPNm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Nov 2009 10:13:42 -0500
Received: by qyk32 with SMTP id 32so45994qyk.4
        for <linux-media@vger.kernel.org>; Tue, 10 Nov 2009 07:13:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091110134837.207bb92a.ospite@studenti.unina.it>
References: <1257266734-28673-1-git-send-email-ospite@studenti.unina.it>
	<1257266734-28673-2-git-send-email-ospite@studenti.unina.it>
	<f17812d70911032238i3ae6fa19g24720662b9079f24@mail.gmail.com>
	<20091110134837.207bb92a.ospite@studenti.unina.it>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 10 Nov 2009 23:13:28 +0800
Message-ID: <f17812d70911100713p3b51aac8k4e59c5df0b58a680@mail.gmail.com>
Subject: Re: [PATCH 1/3] ezx: Add camera support for A780 and A910 EZX phones
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-arm-kernel@lists.infradead.org,
	openezx-devel@lists.openezx.org, Bart Visscher <bartv@thisnet.nl>,
	linux-media@vger.kernel.org,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 10, 2009 at 8:48 PM, Antonio Ospite
<ospite@studenti.unina.it> wrote:
> On Wed, 4 Nov 2009 14:38:40 +0800
> Eric Miao <eric.y.miao@gmail.com> wrote:
>
>> Hi Antonio,
>>
>> Patch looks generally OK except for the MFP/GPIO usage...
>
> Eric,
>
> while I was at it I also checked the original code Motorola released.
>
> It has:
>     PGSR(GPIO_CAM_EN) |= GPIO_bit(GPIO_CAM_EN);
>     PGSR(GPIO_CAM_RST)|= GPIO_bit(GPIO_CAM_RST);
>
> After checking PXA manual and arch/arm/mach-pxa/mfp-pxa2xx.c,
> I'd translate this to:
>
> diff --git a/arch/arm/mach-pxa/ezx.c b/arch/arm/mach-pxa/ezx.c
> index 77286a2..6a47a9d 100644
> --- a/arch/arm/mach-pxa/ezx.c
> +++ b/arch/arm/mach-pxa/ezx.c
> @@ -281,8 +281,8 @@ static unsigned long gen1_pin_config[] __initdata = {
>        GPIO94_CIF_DD_5,
>        GPIO17_CIF_DD_6,
>        GPIO108_CIF_DD_7,
> -       GPIO50_GPIO,                            /* CAM_EN */
> -       GPIO19_GPIO,                            /* CAM_RST */
> +       GPIO50_GPIO | MFP_LPM_DRIVE_HIGH,       /* CAM_EN */
> +       GPIO19_GPIO | MFP_LPM_DRIVE_HIGH,       /* CAM_RST */
>
>        /* EMU */
>        GPIO120_GPIO,                           /* EMU_MUX1 */
> @@ -338,8 +338,8 @@ static unsigned long gen2_pin_config[] __initdata = {
>        GPIO48_CIF_DD_5,
>        GPIO93_CIF_DD_6,
>        GPIO12_CIF_DD_7,
> -       GPIO50_GPIO,                            /* CAM_EN */
> -       GPIO28_GPIO,                            /* CAM_RST */
> +       GPIO50_GPIO | MFP_LPM_DRIVE_HIGH,       /* CAM_EN */
> +       GPIO28_GPIO | MFP_LPM_DRIVE_HIGH,       /* CAM_RST */
>        GPIO17_GPIO,                            /* CAM_FLASH */
>  };
>  #endif
>
>
> Is that right?

That's right.

> I am putting also this into the next version I am going to send for
> submission, if you don't object.

No I won't, feel free to.
