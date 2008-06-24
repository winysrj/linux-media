Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5OLcsUw018880
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 17:38:54 -0400
Received: from mail-in-01.arcor-online.net (mail-in-01.arcor-online.net
	[151.189.21.41])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5OLcfCZ023830
	for <video4linux-list@redhat.com>; Tue, 24 Jun 2008 17:38:41 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: "Diego V. Martinez" <dvm2810@yahoo.com.ar>
In-Reply-To: <933060.96127.qm@web51510.mail.re2.yahoo.com>
References: <933060.96127.qm@web51510.mail.re2.yahoo.com>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 23:35:58 +0200
Message-Id: <1214343358.2636.58.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [linux-dvb] ASUS My-Cinema remote patch
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>


Hi Diego,

Am Montag, den 23.06.2008, 20:07 -0700 schrieb Diego V. Martinez:
> Hi Hermann,
> 
> Here is my history: I bought the Asus MyCinema P7131/FM/P-ATX/A (analog) some months ago. I was using Fedora Core 6 with kernel 2.6.24.2. This kernel version recognized the TV card as number 53 (ASUS TV-FM 7135).
> 
> The TV input was working great (here in Argentina we use PAL-Nc TV norm). S-Video input (audio and video) and IR control were not working. I found in Internet a kernel patch to support the PC-39 remote control that comes with my board (modifying the saa7134-cards.c and saa7134-input.c kernel source files). After that the IR starts working.
> 
> Now I'm trying the "saa7134_asus-p7134-analog-tvfm7135-device-detection-fix.patch" that makes the same source code changes to support the IR control that I was doing before plus some code lines to associate a new Asus MyCinema P7131 Analog profile to the Asus MyCinema P7131 Dual (card 78).
> 
> Now the kernel autodetects the new P7131 Analog board but the S-Video input stills with no video (I have sound now). I'm making the tests with the S-Video/Composite cable that comes with the board. I plug my NTSC camera and I hear sound but only a black screen appears on the Composite1, Composite2 and S-Video modes of "tvtime". TV mode stills working fine.
> 
> Forcing to card 78 (Asus P7131 Dual) has same results for the S-Video input (audio yes, video no). TV mode stills working fine.
> 
> What any information should I check and/or collect?
> 

hm, card=78 doesn't work either.

No idea yet and I don't want to send you around for testing other vmuxes
or such without any.

Are you sure your camera doesn't output some unusual or proprietary
stuff? No other such reports yet.

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
