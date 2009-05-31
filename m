Return-path: <linux-media-owner@vger.kernel.org>
Received: from triton5.vsb.cz ([158.196.149.75]:50594 "EHLO triton5.vsb.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbZEaThz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 31 May 2009 15:37:55 -0400
Subject: Re: [PATCH] Leadtek WinFast DTV-1800H support
From: Miroslav =?UTF-8?Q?=C5=A0ustek?= <sustmidown@centrum.cz>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org
In-Reply-To: <Pine.LNX.4.58.0905310536500.32713@shell2.speakeasy.net>
References: <200905291638.9584@centrum.cz> <200905291639.30476@centrum.cz>
	 <Pine.LNX.4.58.0905310536500.32713@shell2.speakeasy.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 May 2009 21:28:03 +0200
Message-Id: <1243798083.6400.25.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Trent Piepho píše v Ne 31. 05. 2009 v 06:34 -0700:
> Instead of raising the reset line here, why not change the gpio settings in
> the card definition to have it high?  Change gpio1 for television to 0x7050
> and radio to 0x7010.
Personally, I don't know when these .gpioX members are used (before firmware loads or after...).
But I assume that adding the high on reset pin shouldn't break anything, so we can do this.

> Then the reset can be done with:
> 
> 	case XC2028_TUNER_RESET:
> 		/* GPIO 12 (xc3028 tuner reset) */
> 		cx_write(MO_GP1_IO, 0x101000);
> 		mdelay(50);
> 		cx_write(MO_GP1_IO, 0x101010);
> 		mdelay(50);
> 		return 0;
> 
> Though I have to wonder why each card needs its own xc2028 reset function.
> Shouldn't they all be the same other than what gpio they change?
> 
> 
> @@ -2882,6 +2946,16 @@
>                 cx_set(MO_GP0_IO, 0x00000080); /* 702 out of reset */
>                 udelay(1000);
>                 break;
> +
> +       case CX88_BOARD_WINFAST_DTV1800H:
> +               /* GPIO 12 (xc3028 tuner reset) */
> +               cx_set(MO_GP1_IO, 0x1010);
> +               mdelay(50);
> +               cx_clear(MO_GP1_IO, 0x10);
> +               mdelay(50);
> +               cx_set(MO_GP1_IO, 0x10);
> +               mdelay(50);
> +               break;
>         }
>  }
> 
> Couldn't you replace this with:
> 
> 	case CX88_BOARD_WINFAST_DTV1800H:
> 		cx88_xc3028_winfast1800h_callback(code, XC2028_TUNER_RESET, 0);
> 		break;
> 

