Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:35610 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755797AbZDTO3R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 10:29:17 -0400
Subject: Re: [PATCH] Enabling of the Winfast TV2000 XP Global TV capture
	card  remote control
From: hermann pitton <hermann-pitton@arcor.de>
To: Pieter Van Schaik <vansterpc@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <faf98b150904200047v4ec3f977h578a5f5ad3d725c5@mail.gmail.com>
References: <faf98b150904200047v4ec3f977h578a5f5ad3d725c5@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-6s1wBEciaIXyvkBTyDbP"
Date: Mon, 20 Apr 2009 16:27:27 +0200
Message-Id: <1240237647.4250.10.camel@pc07.localdom.local>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-6s1wBEciaIXyvkBTyDbP
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Pieter,

Am Montag, den 20.04.2009, 09:47 +0200 schrieb Pieter Van Schaik:
> The Winfast TV2000 XP Global video capture card IR remote keys were
> not initialized and handled in cx88-input.c; added two corresponding
> case statements, where this card's remote works exactly the same as
> the DTV1000's.
> 
> Signed-off-by: Pieter C van Schaik <vansterpc@gmail.com>
> ---
> --- linux-2.6.29/drivers/media/video/cx88/cx88-input.c.orig
> 2009-04-01 12:38:34.000000000 +0200
> +++ linux-2.6.29/drivers/media/video/cx88/cx88-input.c  2009-04-01
> 12:39:07.000000000 +0200
> @@ -92,6 +92,7 @@ static void cx88_ir_handle_key(struct cx
>  		gpio=(gpio & 0x7fd) + (auxgpio & 0xef);
>  		break;
>  	case CX88_BOARD_WINFAST_DTV1000:
> + 	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
>  		gpio = (gpio & 0x6ff) | ((cx_read(MO_GP1_IO) << 8) & 0x900);
>  		auxgpio = gpio;
>  		break;
> @@ -239,6 +240,7 @@ int cx88_ir_init(struct cx88_core *core,
>  		break;
>  	case CX88_BOARD_WINFAST2000XP_EXPERT:
>  	case CX88_BOARD_WINFAST_DTV1000:
> + 	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
>  		ir_codes = ir_codes_winfast;
>  		ir->gpio_addr = MO_GP0_IO;
>  		ir->mask_keycode = 0x8f8;

this is at least your third try on it, but it doesn't make it into
http://patchwork.kernel.org/project/linux-media/list

Broken lines and indentation with spaces instead of tabs for what I get.

Also it has an offset of four lines for the second hunk on recent
mercurial v4l-dvb. Use "hg diff" to create it on that and don't send
patches against 2.6.29. Try README.patches and run at least "make
checkpatch" once. This gives an ERROR for wrong indentation and so on.

Else try to tweak your mailer or also send as .patch attachment like the
one below for testing.

Cheers,
Hermann


--=-6s1wBEciaIXyvkBTyDbP
Content-Description: 
Content-Disposition: inline; filename=cx88_support_the_remote_of_WINFAST_TV2000_XP_GLOBAL.patch
Content-Type: text/x-patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -r ac3865b16886 linux/drivers/media/video/cx88/cx88-input.c
--- a/linux/drivers/media/video/cx88/cx88-input.c	Mon Apr 20 08:47:22 2009 -0300
+++ b/linux/drivers/media/video/cx88/cx88-input.c	Mon Apr 20 15:25:19 2009 +0200
@@ -92,6 +92,7 @@
 		gpio=(gpio & 0x7fd) + (auxgpio & 0xef);
 		break;
 	case CX88_BOARD_WINFAST_DTV1000:
+	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
 		gpio = (gpio & 0x6ff) | ((cx_read(MO_GP1_IO) << 8) & 0x900);
 		auxgpio = gpio;
 		break;
@@ -243,6 +244,7 @@
 		break;
 	case CX88_BOARD_WINFAST2000XP_EXPERT:
 	case CX88_BOARD_WINFAST_DTV1000:
+	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
 		ir_codes = ir_codes_winfast;
 		ir->gpio_addr = MO_GP0_IO;
 		ir->mask_keycode = 0x8f8;

--=-6s1wBEciaIXyvkBTyDbP--

