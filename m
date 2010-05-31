Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61953 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab0EaBVX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 May 2010 21:21:23 -0400
Received: by fxm10 with SMTP id 10so2047672fxm.19
        for <linux-media@vger.kernel.org>; Sun, 30 May 2010 18:21:22 -0700 (PDT)
Date: Mon, 31 May 2010 03:21:18 +0200
From: Davor Emard <davoremard@gmail.com>
To: Samuel =?utf-8?Q?Rakitni=C4=8Dan?= <samuel.rakitnican@gmail.com>
Cc: semiRocket <semirocket@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Compro Videomate T750F Vista digital+analog support
Message-ID: <20100531012117.GA15601@emard.lan>
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

HI!

Can you also try this GPIO settings? It's my try to use last summer's
registers dump to setup gpio mask and value

	case SAA7134_BOARD_VIDEOMATE_T750:
		dev->has_remote = SAA7134_REMOTE_GPIO;
		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x8082c000, 0x8082c000);
		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x8082c000, 0x0080c000);
		break;
