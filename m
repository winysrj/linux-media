Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f168.google.com ([209.85.219.168]:41550 "EHLO
	mail-ew0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab0E0Rcn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 13:32:43 -0400
Received: by ewy8 with SMTP id 8so16424ewy.8
        for <linux-media@vger.kernel.org>; Thu, 27 May 2010 10:32:40 -0700 (PDT)
Date: Thu, 27 May 2010 19:15:51 +0200
From: Davor Emard <davoremard@gmail.com>
To: Samuel =?utf-8?Q?Rakitni=C4=8Dan?= <samuel.rakitnican@gmail.com>
Cc: semiRocket <semirocket@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Compro Videomate T750F Vista digital+analog support
Message-ID: <20100527171551.GA11832@emard.lan>
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

Another idea:

compare syslog line 
May 27 14:33:42 emard kernel: saa7133[0]: board init: gpio is 84bf00

when trying to load firmware without preparing with windows and
after windows - see if there's a difference between bits of the hex
value (0x84bf00 in my case)

that's a probable clue to modify this 0x0008000 value to either
include the missing bits or remove the excess ones

Emard
