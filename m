Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:47306 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386Ab0E0Qz0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 12:55:26 -0400
Received: by ey-out-2122.google.com with SMTP id d26so17807eyd.19
        for <linux-media@vger.kernel.org>; Thu, 27 May 2010 09:55:24 -0700 (PDT)
Date: Thu, 27 May 2010 18:55:21 +0200
From: Davor Emard <davoremard@gmail.com>
To: Samuel =?utf-8?Q?Rakitni=C4=8Dan?= <samuel.rakitnican@gmail.com>
Cc: semiRocket <semirocket@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Compro Videomate T750F Vista digital+analog support
Message-ID: <20100527165520.GA9987@emard.lan>
References: <20100508160628.GA6050@z60m>
 <op.vceiu5q13xmt7q@crni>
 <AANLkTinMYcgG6Ac73Vgdx8NMYocW8Net6_-dMC3yEflQ@mail.gmail.com>
 <AANLkTikbpZ0LM5rK70abVuJS27j0lT7iZs12DrSKB9wI@mail.gmail.com>
 <op.vcfoxwnq3xmt7q@crni>
 <20100509173243.GA8227@z60m>
 <op.vcga9rw2ndeod6@crni>
 <20100509231535.GA6334@z60m>
 <op.vcsntos43xmt7q@crni>
 <op.vc551isrndeod6@crni>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.vc551isrndeod6@crni>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

HI

This code is responsible to prepare the card to load the firmware
I have no true clue what it actually does, possible it is a
reset sequence for onboard tuner chips or just a matter of 
enabling some power to them. 

I have googled for compro 750 related discussions and seen various posts 
so I narrowed to this. Feel free to either comment out the code or
try slightly different values to see if they leat to more reliable
loading of the firmware at your hardware

+               case SAA7134_BOARD_VIDEOMATE_T750:
+                       saa7134_set_gpio(dev, 20, 0);
+                       msleep(10);
+                       saa7134_set_gpio(dev, 20, 1);
+               break;

+       case SAA7134_BOARD_VIDEOMATE_T750:
+               dev->has_remote = SAA7134_REMOTE_GPIO;
+               saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x00008000, 0x00008000);
+               saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x00008000, 0x00008000);
+               break;

some similar cards use instead of 0x00008000 use 0x0000C000
also it's possible to try other values if they can help on
your hardware (I tried a lots of them, some work, some don't 
but with not obvious improvement for my card so I left the 
minimum that works)

Emard
