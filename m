Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5O37l3o004113
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 23:07:47 -0400
Received: from web51510.mail.re2.yahoo.com (web51510.mail.re2.yahoo.com
	[206.190.38.202])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m5O37Sc0001848
	for <video4linux-list@redhat.com>; Mon, 23 Jun 2008 23:07:29 -0400
Date: Mon, 23 Jun 2008 20:07:22 -0700 (PDT)
From: "Diego V. Martinez" <dvm2810@yahoo.com.ar>
To: hermann pitton <hermann-pitton@arcor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <933060.96127.qm@web51510.mail.re2.yahoo.com>
Content-Transfer-Encoding: 8bit
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

Hi Hermann,

Here is my history: I bought the Asus MyCinema P7131/FM/P-ATX/A (analog) some months ago. I was using Fedora Core 6 with kernel 2.6.24.2. This kernel version recognized the TV card as number 53 (ASUS TV-FM 7135).

The TV input was working great (here in Argentina we use PAL-Nc TV norm). S-Video input (audio and video) and IR control were not working. I found in Internet a kernel patch to support the PC-39 remote control that comes with my board (modifying the saa7134-cards.c and saa7134-input.c kernel source files). After that the IR starts working.

Now I'm trying the "saa7134_asus-p7134-analog-tvfm7135-device-detection-fix.patch" that makes the same source code changes to support the IR control that I was doing before plus some code lines to associate a new Asus MyCinema P7131 Analog profile to the Asus MyCinema P7131 Dual (card 78).

Now the kernel autodetects the new P7131 Analog board but the S-Video input stills with no video (I have sound now). I'm making the tests with the S-Video/Composite cable that comes with the board. I plug my NTSC camera and I hear sound but only a black screen appears on the Composite1, Composite2 and S-Video modes of "tvtime". TV mode stills working fine.

Forcing to card 78 (Asus P7131 Dual) has same results for the S-Video input (audio yes, video no). TV mode stills working fine.

What any information should I check and/or collect?


Thanks in advance!,
Diego




----- Mensaje original ----
De: hermann pitton <hermann-pitton@arcor.de>
Para: Diego V. Martinez <dvm2810@yahoo.com.ar>
CC: video4linux-list@redhat.com
Enviado: lunes 23 de junio de 2008, 19:07:21
Asunto: Re: [linux-dvb] ASUS My-Cinema remote patch

Hi Diego,

Am Montag, den 23.06.2008, 08:52 -0700 schrieb Diego V. Martinez:
> Hi Hermann,
> 
> I've the Asus MyCinema P7131 Analog TV Card (the one that has the green box in http://www.bttv-gallery.de) and I after I applied the patch "saa7134_asus-p7134-analog-tvfm7135-device-detection-fix.patch" the IR control starts working but the S-Video input still fails (black screen on tvtime as before applying the patch).
> 
> My linux distribution is Fedora Core 6.
> 
> My kernel version is 2.6.25.5.
> 
> I use "tvtime" to make the tests.
> 
> Do you know what could be wrong?
> 

I'm getting slightly confusing reports on this modest attempt to improve
it for that card.

Did you apply the patch to 2.6.25.5 or recent mercurial v4l-dvb?
Only since yesterday, after an improvement for enum standard by Hans
after the ioctl2 conversion, all kind of subnorms are selectable again,
but this does not necessarily reflect what a driver is internally
capable to do.

To come back to the remote, do you mean the remote is working with that
patch after auto detection or do you force the new card number?

For s-video, which kind of s-video you try to use?

IIRC, PAL_N, which you should have on FreeToAir broadcasts, is still not
supported, but PAL_Nc on cable is known to work since long.

If you force card=78, still no s-video?

Cheers,
Hermann


      ____________________________________________________________________________________
¡Buscá desde tu celular!

Yahoo! oneSEARCH ahora está en Claro

http://ar.mobile.yahoo.com/onesearch

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
