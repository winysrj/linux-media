Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37217 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbZDFLwx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 07:52:53 -0400
Received: by fxm2 with SMTP id 2so1842205fxm.37
        for <linux-media@vger.kernel.org>; Mon, 06 Apr 2009 04:52:50 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 6 Apr 2009 13:52:50 +0200
Message-ID: <faf98b150904060452m35b4ef58m94cfb02ca8bd1334@mail.gmail.com>
Subject: [PATCH] Enabling of the Winfast TV2000 XP Global TV capture card
	remote control
From: Pieter Van Schaik <vansterpc@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pieter C van Schaik <vansterpc@gmail.com>

The Winfast TV2000 XP Global video capture card IR remote keys were
not initialized and handled in cx88-input.c; added two corresponding
case statements, where this card's remote works exactly the same as
the DTV1000's.

Signed-off-by: Pieter C van Schaik <vansterpc@gmail.com>
---
--- linux-2.6.29/drivers/media/video/cx88/cx88-input.c.orig
2009-04-01 12:38:34.000000000 +0200
+++ linux-2.6.29/drivers/media/video/cx88/cx88-input.c  2009-04-01
12:39:07.000000000 +0200
@@ -92,6 +92,7 @@ static void cx88_ir_handle_key(struct cx
 		gpio=(gpio & 0x7fd) + (auxgpio & 0xef);
 		break;
 	case CX88_BOARD_WINFAST_DTV1000:
+ 	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
 		gpio = (gpio & 0x6ff) | ((cx_read(MO_GP1_IO) << 8) & 0x900);
 		auxgpio = gpio;
 		break;
@@ -239,6 +240,7 @@ int cx88_ir_init(struct cx88_core *core,
 		break;
 	case CX88_BOARD_WINFAST2000XP_EXPERT:
 	case CX88_BOARD_WINFAST_DTV1000:
+ 	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
 		ir_codes = ir_codes_winfast;
 		ir->gpio_addr = MO_GP0_IO;
 		ir->mask_keycode = 0x8f8;
