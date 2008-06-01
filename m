Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m51IZPbn025246
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 14:35:25 -0400
Received: from smtp5-g19.free.fr (smtp5-g19.free.fr [212.27.42.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m51IZDUt001721
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 14:35:13 -0400
Received: from smtp5-g19.free.fr (localhost.localdomain [127.0.0.1])
	by smtp5-g19.free.fr (Postfix) with ESMTP id 8C4D23F63AC
	for <video4linux-list@redhat.com>;
	Sun,  1 Jun 2008 20:35:12 +0200 (CEST)
Received: from sidero.numenor.net (lac49-1-82-245-43-74.fbx.proxad.net
	[82.245.43.74])
	by smtp5-g19.free.fr (Postfix) with ESMTP id 6636D3F63AE
	for <video4linux-list@redhat.com>;
	Sun,  1 Jun 2008 20:35:12 +0200 (CEST)
From: stef <stef.dev@free.fr>
To: video4linux-list@redhat.com
Date: Sun, 1 Jun 2008 20:34:28 +0200
References: <200805311455.15669.stef.dev@free.fr>
In-Reply-To: <200805311455.15669.stef.dev@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200806012034.28591.stef.dev@free.fr>
Content-Transfer-Encoding: 8bit
Subject: Re: Trouble making PCTV 310c working
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

Le Saturday 31 May 2008 14:55:15 stef, vous avez écrit :
> 	Hello,
>
> 	I have Pinnacle PCTV 310c hybrid card:
>
> 02:00.0 0400: 14f1:8800 (rev 05)
> 	Subsystem: 12ab:1788
> 	Flags: bus master, medium devsel, latency 64, IRQ 11
> 	Memory at 60000000 (32-bit, non-prefetchable) [size=16M]
> 	Capabilities: [44] Vital Product Data <?>
> 	Capabilities: [4c] Power Management version 2
> 	Kernel driver in use: cx8800
> 	Kernel modules: cx8800
>
> 02:00.1 0480: 14f1:8801 (rev 05)
> 	Subsystem: 12ab:1788
> 	Flags: bus master, medium devsel, latency 64, IRQ 11
> 	Memory at 61000000 (32-bit, non-prefetchable) [size=16M]
> 	Capabilities: [4c] Power Management version 2
> 	Kernel driver in use: cx88_audio
> 	Kernel modules: cx88-alsa
>
> 02:00.2 0480: 14f1:8802 (rev 05)
> 	Subsystem: 12ab:1788
> 	Flags: bus master, medium devsel, latency 64, IRQ 11
> 	Memory at 62000000 (32-bit, non-prefetchable) [size=16M]
> 	Capabilities: [4c] Power Management version 2
> 	Kernel driver in use: cx88-mpeg driver manager
> 	Kernel modules: cx8802
>
> 	With latest mercurial, I can capture video with good quality from
> Composite1, but I don't get sound. I checked that the alsa device exists
> and is unmuted. I'm capturing with:
> mplayer tv:// -tv
> driver=v4l2:norm=PAL-BG:input=1:device=/dev/video1:alsa:adevice=hw.2:volume
>=60 -vo xv -ao alsa
> 	where I double checked that hw.2 is really the Conexant CX8801 Playback.
>
> 	Another problem I have is that after scanning french tv channels (with
> tvtime-scanner), the detected channels are garbled when I try to watch them
> with tvtime. It looks like that SECAM isn't taken into account, and that
> the signal is decoded as if it was another norm.
>
> 	Looking at the sources I noted a comment about some GPIO work needed for
> the DVB subsystem. I have a windows partition on the same machine where the
> card is working fine, and I installed DScaler's regspy. So I may provide
> any data needed.
>
> 	Last, I believe there should also be an entry for the  cx8802 in the card
> description.
>
> Regards,
> 	Stef
>
> --

	Hello,

	I was able to get sound from Composite1 by adding the following fields to the 
composite entry in cx88-cards:

                        .gpio0  = 0x04fb,
                        .gpio1  = 0x10ff,
                        .gpio2  = 0x0ff,
                        .audioroute = 1,

	The gpio values were fetched under windows using regspy. I didn't have enough 
time to test with audioroute=1 only, which may have been enough to get sound 
working.

Regards,
	Stef



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
