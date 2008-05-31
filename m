Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4VIi5R6027003
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 14:44:05 -0400
Received: from rv-out-0506.google.com (rv-out-0506.google.com [209.85.198.232])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4VIhs4F026329
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 14:43:54 -0400
Received: by rv-out-0506.google.com with SMTP id f6so368663rvb.51
	for <video4linux-list@redhat.com>; Sat, 31 May 2008 11:43:54 -0700 (PDT)
Message-ID: <d9def9db0805311143o3023c0dah1079e9c40d81fe6f@mail.gmail.com>
Date: Sat, 31 May 2008 20:43:54 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: stef <stef.dev@free.fr>
In-Reply-To: <200805311455.15669.stef.dev@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805311455.15669.stef.dev@free.fr>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
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

On Sat, May 31, 2008 at 2:55 PM, stef <stef.dev@free.fr> wrote:
>        Hello,
>
>        I have Pinnacle PCTV 310c hybrid card:
>
> 02:00.0 0400: 14f1:8800 (rev 05)
>        Subsystem: 12ab:1788
>        Flags: bus master, medium devsel, latency 64, IRQ 11
>        Memory at 60000000 (32-bit, non-prefetchable) [size=16M]
>        Capabilities: [44] Vital Product Data <?>
>        Capabilities: [4c] Power Management version 2
>        Kernel driver in use: cx8800
>        Kernel modules: cx8800
>
> 02:00.1 0480: 14f1:8801 (rev 05)
>        Subsystem: 12ab:1788
>        Flags: bus master, medium devsel, latency 64, IRQ 11
>        Memory at 61000000 (32-bit, non-prefetchable) [size=16M]
>        Capabilities: [4c] Power Management version 2
>        Kernel driver in use: cx88_audio
>        Kernel modules: cx88-alsa
>
> 02:00.2 0480: 14f1:8802 (rev 05)
>        Subsystem: 12ab:1788
>        Flags: bus master, medium devsel, latency 64, IRQ 11
>        Memory at 62000000 (32-bit, non-prefetchable) [size=16M]
>        Capabilities: [4c] Power Management version 2
>        Kernel driver in use: cx88-mpeg driver manager
>        Kernel modules: cx8802
>
>        With latest mercurial, I can capture video with good quality from Composite1,
> but I don't get sound. I checked that the alsa device exists and is unmuted.
> I'm capturing with:
> mplayer tv:// -tv
> driver=v4l2:norm=PAL-BG:input=1:device=/dev/video1:alsa:adevice=hw.2:volume=60
> -vo xv -ao alsa
>        where I double checked that hw.2 is really the Conexant CX8801 Playback.
>
>        Another problem I have is that after scanning french tv channels (with
> tvtime-scanner), the detected channels are garbled when I try to watch them
> with tvtime. It looks like that SECAM isn't taken into account, and that the
> signal is decoded as if it was another norm.
>
>        Looking at the sources I noted a comment about some GPIO work needed for the
> DVB subsystem. I have a windows partition on the same machine where the card
> is working fine, and I installed DScaler's regspy. So I may provide any data
> needed.
>
>        Last, I believe there should also be an entry for the  cx8802 in the card
> description.
>

we only got analog TV working with that device for now, DVB-T might
need a little more work. I'll check the current status next week when
I find some more time.

Markus

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
