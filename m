Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:34072 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751588Ab0BBUTy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Feb 2010 15:19:54 -0500
Message-ID: <4B6888C9.40400@arcor.de>
Date: Tue, 02 Feb 2010 21:19:21 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [PATCH] -  tm6000 DVB support
References: <4B673790.3030706@arcor.de> <4B673B2D.6040507@arcor.de> <4B675B19.3080705@redhat.com> <4B685FB9.1010805@arcor.de> <4B688507.606@redhat.com>
In-Reply-To: <4B688507.606@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 02.02.2010 21:03, schrieb Mauro Carvalho Chehab:
>
>>> Those tuner callback initializations are board-specific. So, it is better to test
>>> for your board model, if you need something different than what's currently done.
>>>
>>>   
>>>       
>> This tuner reset works with my stick, but I think that can test with
>> other tm6000 based sticks and if it not works then I can say this as a
>> board-specific.
>>     
> It won't work on my boards. The GPIO pin used by each board is different.
>
>   
Have you the right gpio pin in the card struct. I have the
".gpio_addr_tun_reset" the correct gpio pin

   [TM6010_BOARD_TERRATEC_CINERGY_HYBRID_XE] = {
+        .name         = "Terratec Cinergy Hybrid XE",
+        .tuner_type   = TUNER_XC2028, /* has a XC3028 */
+        .tuner_addr   = 0xc2 >> 1,
+        .demod_addr   = 0x1e >> 1,
+        .type         = TM6010,
+        .caps = {
+            .has_tuner    = 1,
+            .has_dvb      = 1,
+            .has_zl10353  = 1,
+            .has_eeprom   = 1,
+            .has_remote   = 1,
+        },
+        .gpio_addr_tun_reset = TM6010_GPIO_2, /* here */
+    }
 };
 


