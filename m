Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:26217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab0I2R25 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Sep 2010 13:28:57 -0400
Message-ID: <4CA37755.5060608@redhat.com>
Date: Wed, 29 Sep 2010 14:28:53 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Giorgio <mywing81@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: ASUS My Cinema-P7131 Hybrid (saa7134) and slow IR
References: <AANLkTik4NpV5C=Ct_8u=awZ-tthDC=ORJj8u1DHTNu+q@mail.gmail.com>
In-Reply-To: <AANLkTik4NpV5C=Ct_8u=awZ-tthDC=ORJj8u1DHTNu+q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 29-09-2010 14:06, Giorgio escreveu:
> Hello,
> 
> I have an Asus P7131 Hybrid card, and it works like a charm with
> Ubuntu 8.04 and stock kernel 2.6.24. But, after upgrading my system to
> Ubuntu 10.04 x86-64, I noticed that the remote control was quite slow
> to respond. Sometimes the keypresses aren't recognized, and you have
> to keep pressing the same button two or three times until it works.
> The remote feels slow, not very responsive.
> So, to investigate the issue, I loaded the ir-common module with
> debug=1 and looked at the logs. They report lots of "ir-common:
> spurious timer_end". The funny thing is, I have tried the Ubuntu 10.04
> i386 livecd (with the same kernel) and the problem is not present
> there.

> Sep 27 15:48:59 holden-desktop kernel: [  256.770031] ir-common: spurious timer_end
> Sep 27 15:48:59 holden-desktop kernel: [  256.880030] ir-common: spurious timer_end

It is using the old RC support. This support will be removed soon, so, the
better is to convert it to use the new IR core, and fix a bug there, if is
there any.

Please apply the attached patch (it is against my -git tree, but it will probably
apply fine if you have a new kernel).

You should notice that the RC_MAP_ASUS_PC39 table is not ready for the new IR
infrastructure. So, you'll need to enable ir-core debug, and check what scancodes are
detected there. Probably, all we need is to add the RC5 address to all codes at the table.

Cheers,
Mauro

---
saa7134: port Asus P7131 Hybrid to use the new rc-core

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 52a1ee5..1bb813e 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -772,8 +772,10 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
 	case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
 		ir_codes     = RC_MAP_ASUS_PC39;
-		mask_keydown = 0x0040000;
-		rc5_gpio = 1;
+		mask_keydown = 0x0040000;	/* Enable GPIO18 line on both edges */
+		mask_keyup   = 0x0040000;
+		mask_keycode = 0xffff;
+		raw_decode   = 1;
 		break;
 	case SAA7134_BOARD_ENCORE_ENLTV:
 	case SAA7134_BOARD_ENCORE_ENLTV_FM:
