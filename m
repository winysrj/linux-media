Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:21595 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab0FCOEM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Jun 2010 10:04:12 -0400
Received: by ey-out-2122.google.com with SMTP id 25so59585eya.19
        for <linux-media@vger.kernel.org>; Thu, 03 Jun 2010 07:04:10 -0700 (PDT)
Date: Thu, 3 Jun 2010 16:04:07 +0200
From: Davor Emard <davoremard@gmail.com>
To: Samuel =?utf-8?Q?Rakitni=C4=8Dan?= <samuel.rakitnican@gmail.com>
Cc: semiRocket <semirocket@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Compro Videomate T750F Vista digital+analog support
Message-ID: <20100603140403.GA22382@emard.lan>
References: <20100509173243.GA8227@z60m>
 <op.vcga9rw2ndeod6@crni>
 <20100509231535.GA6334@z60m>
 <op.vcsntos43xmt7q@crni>
 <op.vc551isrndeod6@crni>
 <20100530234817.GA17135@emard.lan>
 <20100531075214.GA17456@lipa.lan>
 <op.vdn7g9nj3xmt7q@crni>
 <20100602182757.GA22171@emard.lan>
 <op.vdo22vmundeod6@crni>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.vdo22vmundeod6@crni>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Didn't have time to look for gpios, tomorrow I will have. But I can
> tell that this change is not working for me:
> 
> 	case SAA7134_BOARD_VIDEOMATE_T750:
> 		dev->has_remote = SAA7134_REMOTE_GPIO;
> 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0x8082c000, 0x8082c000);
> 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0x8082c000, 0x0080c000);
> 		break;

Thanx for testing it out, If it doesn't work, try this:

saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   /* keep */ 0x8082c000, /* keep */   0x8082c000);
saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, /* keep */ 0x8082c000, /* modify */ 0x0080c000);

modify only the indicated number, try 0, try 0x8082c000 and if
you have time try all combinations of bits 0x8082c000 optionally set to 0
e.g. 0x8002c000, 0x8080c000, 0x80828000, 0x0080c000 etc...

It is possible that you and I don't have same revision of the
card and you need a slightly different initialization procedure.
If you get something to work for your card then I can try it back at
mine there's a changes that we get a common setup which works for both.

> OK, I'm not having any personal opinion about the keys nor a
> application which I'm using, I'm just noticed that the keys differ
> against standard keys defined at linuxtv wiki. But if the keys at
> wiki are not correct, then perhaps should we change them there and
> let all use the same keys.
> 
> If we have standard keys, than userspace applications programmers
> can make a use of it and assign the keys to their applications and
> to have just work experience to their users. But maybe I'm terrible
> wrong...

Yeah I know, almost every remote has its own logic so it seems my version
is yet-another-bla... I'm hoping for upcoming X11 xinput2 layer hopefully 
get full support of MCE remotes and nicely integrate with X applications
therefore I produced MCE stuff here for a challenge to the xinput2

For integrated TV and PC to work well we need all remote keys be different 
than any other existing key used by keyboard.

Without this, when X11 based TV view application gets "out of input focus"
means it becomes irresponsive to ambiguity keys on the remote controller 
(in this example cursor keys) and we need to first use mouse to click on 
TV application and then continue using cursors on remote control 
(imagine how practical it is to make mouse click when watching TV from sofa) 

best regards, d.
