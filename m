Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx10.extmail.prod.ext.phx2.redhat.com
	[10.5.110.14])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n9KIinQG022901
	for <video4linux-list@redhat.com>; Tue, 20 Oct 2009 14:44:49 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n9KIiYRl023129
	for <video4linux-list@redhat.com>; Tue, 20 Oct 2009 14:44:35 -0400
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 20 Oct 2009 20:44:30 +0200
From: "Oleksandr Naumenko" <o.naumenko@gmx.de>
In-Reply-To: <4ADD7333.4040309@lfarkas.org>
Message-ID: <20091020184430.98440@gmx.net>
MIME-Version: 1.0
References: <20091019235613.7680@gmx.net> <4ADD7333.4040309@lfarkas.org>
To: video4linux-list@redhat.com
Content-Transfer-Encoding: 7bit
Subject: Re: AverTV GO 007 FM Plus
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

> Hi again!
> 
> Are you sure that /dev/dsp1 is the sound device of your tv tuner, on
> my old laptop /dev/dsp1 actually is my modems sound device (I think so
> atleast), so my tv tuners gets /dev/dsp2 there...
> 
> /Magnus
> 
> 2009/10/20 Magnus Alm :
> > Hi!
> >
> > Try: sox -r 48000 -c 2 -t ossdsp /dev/dsp1 -t ossdsp /dev/dsp
> >
> > You need to have "libsox-fmt-oss" installed for the "ossdsp" to work.
> >
> > I cant get any sound with "cat /dev/dsp1 | aplay -r 32000" either...
> >
> > /Magnus
> >


So far a real big "thank you" to you people!

I'll sum up what i did so far:

1. "cat /dev/dsp1 | aplay -r 8000"  worked, but the sound quallity was really bad and i had a delay of about 1 sec (with -r 16000 and -r 32000 i had this buffering problem "Pufferunterlauf" so it didn't work for me).

2. Installed "libsox-fmt-oss" and got sound with "sox -r 32000 -c 2 -t ossdsp /dev/dsp1 -t ossdsp /dev/dsp"

3. about
> add to modprobe.conf:
> ---------------------------
> options snd cards_limit=8
> alias snd-card-0 snd-hda-intel
> options snd-card-0 index=0
> options snd-hda-intel index=0
> alias snd-card-1 saa7134-alsa
> options saa7134 card=57 tuner=54 alsa=1
> install saa7134 /sbin/modprobe --ignore-install saa7134; /sbin/modprobe
> saa7134-alsa
> options saa7134-alsa index=1

I actually didn't have modprobe.conf, even tho as far as i have understood from other forums it should have been created. So i went and created one myself and pasted the modifications, don't know if it's the right thing to do, but i didn't come up with a better solution.

> and play with:
> gst-launch-0.10 alsasrc device=hw:1,0 ! capsfilter
> "caps=audio/x-raw-int,rate=32000" ! alsasink
> or:
> sox -r 32000 -w -t alsa hw:1,0 -t alsa hw:0,0 2>/dev/null
> or:
> arecord -D hw:1,0 -r 32000 -c 2 -f S16_LE | aplay -

the "arecord -D hw:1,0 -r 32000 -c 2 -f S16_LE | aplay -" works!

so i've got sound and it works wonderfully, thanks to everyone!

P.S.: about the question if its the dev1... i'm afraid i'm not really quallified to give you a certain answer, but it seems to.
-- 
Jetzt kostenlos herunterladen: Internet Explorer 8 und Mozilla Firefox 3.5 -
sicherer, schneller und einfacher! http://portal.gmx.net/de/go/chbrowser

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
