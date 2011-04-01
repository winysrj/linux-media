Return-path: <mchehab@pedra>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37979 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab1DAWrA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Apr 2011 18:47:00 -0400
Received: by gxk21 with SMTP id 21so1596886gxk.19
        for <linux-media@vger.kernel.org>; Fri, 01 Apr 2011 15:46:59 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 2 Apr 2011 04:16:59 +0530
Message-ID: <AANLkTindZpWzw_PTRvAcckqiUzfAeN0031DjyN+8b-=3@mail.gmail.com>
Subject: Updat em28xx driver for the Gadmei USB 382 F tv tuner card?
From: Vishal Rao <vishalrao@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

I just got a Gadmei 382 model tv tuner card and tried it with Ubuntu
11.04 beta 1 with no luck.

Grepping through the em28xx driver sources I see potential areas where
this device can be added:

vishal@thunderbird:/media/data/SRC/linux-media-2011-04-01/drivers/media/video/em28xx$
grep -i gadmei *
em28xx-cards.c:	[EM2820_BOARD_GADMEI_TVR200] = {
em28xx-cards.c:		.name         = "Gadmei TVR200",
em28xx-cards.c:	[EM2820_BOARD_GADMEI_UTV310] = {
em28xx-cards.c:		.name         = "Gadmei UTV310",
em28xx-cards.c:	[EM2860_BOARD_GADMEI_UTV330] = {
em28xx-cards.c:		.name         = "Gadmei UTV330",
em28xx-cards.c:	[EM2861_BOARD_GADMEI_UTV330PLUS] = {
em28xx-cards.c:		.name         = "Gadmei UTV330+",
em28xx-cards.c:		.ir_codes     = RC_MAP_GADMEI_RM008Z,
em28xx-cards.c:			.driver_info = EM2860_BOARD_GADMEI_UTV330 },
em28xx-cards.c:	{0xc51200e3, EM2820_BOARD_GADMEI_TVR200, TUNER_LG_PAL_NEW_TAPC},
em28xx-cards.c:	{0x4ba50080, EM2861_BOARD_GADMEI_UTV330PLUS, TUNER_TNF_5335MF},
em28xx-cards.c:	case EM2820_BOARD_GADMEI_UTV310:
em28xx.h:#define EM2820_BOARD_GADMEI_UTV310		  25
em28xx.h:#define EM2860_BOARD_GADMEI_UTV330		  37
em28xx.h:#define EM2820_BOARD_GADMEI_TVR200		  62
em28xx.h:#define EM2861_BOARD_GADMEI_UTV330PLUS           72

vishal@thunderbird:/media/data/SRC/linux-media-2011-04-01/drivers/media/video/em28xx$
grep 382 *
vishal@thunderbird:/media/data/SRC/linux-media-2011-04-01/drivers/media/video/em28xx$


My question is, how do I go about enabling this device to work with
the kernel? Any pointers on how/where to
patch the source? I don't know the card number to use in em28xx.h nor
the hex numbers used in em28xx-cards.c.

Any pointers would be appreciated - and I can test any code that is
out there on my Ubuntu installed laptop.

Thanks!
Vishal

-- 
"The World is a book, and those who do not travel read only a page." -
St. Augustine.
