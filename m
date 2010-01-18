Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f182.google.com ([209.85.216.182]:40656 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab0ARHwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 02:52:38 -0500
Received: by pxi12 with SMTP id 12so3160675pxi.33
        for <linux-media@vger.kernel.org>; Sun, 17 Jan 2010 23:52:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1263733066.2031.15.camel@Core2Duo>
References: <1263733066.2031.15.camel@Core2Duo>
Date: Mon, 18 Jan 2010 09:52:37 +0200
Message-ID: <23582ca1001172352k21d5ceua2067b7eba020369@mail.gmail.com>
Subject: Re: [PATCH] Compro S350 GPIO change
From: Theunis Potgieter <theunis.potgieter@gmail.com>
To: JD Louw <jd.louw@mweb.co.za>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/1/17 JD Louw <jd.louw@mweb.co.za>:
> Hi,
>
> This patch enables LNB power on newer revision d1 Compro S350 and S300
> DVB-S cards. While I don't have these cards to test with I'm confident
> that this works. See
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/7471 and http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/14296
> and new windows driver as reference.
>
> Signed-off-by: JD Louw <jd.louw@mweb.co.za>
>
> diff -r 59e746a1c5d1 linux/drivers/media/video/saa7134/saa7134-cards.c
> --- a/linux/drivers/media/video/saa7134/saa7134-cards.c Wed Dec 30
> 09:10:33 2009 -0200
> +++ b/linux/drivers/media/video/saa7134/saa7134-cards.c Sun Jan 17
> 14:51:07 2010 +0200
> @@ -7037,8 +7037,8 @@ int saa7134_board_init1(struct saa7134_d
>                break;
>        case SAA7134_BOARD_VIDEOMATE_S350:
>                dev->has_remote = SAA7134_REMOTE_GPIO;
> -               saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
> -               saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
> +               saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x0000C000, 0x0000C000);
> +               saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x0000C000, 0x0000C000);
>                break;
>        }
>        return 0;
>
>
> --
Hi Jan,

This does not fix the problem where the card is suppose to suspend and
the Voltage drops to 0V? Do you still require the windows registry
reference for this part?
