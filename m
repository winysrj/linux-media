Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1HJF1Uv009365
	for <video4linux-list@redhat.com>; Sun, 17 Feb 2008 14:15:01 -0500
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.178])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1HJEdmH007814
	for <video4linux-list@redhat.com>; Sun, 17 Feb 2008 14:14:39 -0500
Received: by wa-out-1112.google.com with SMTP id j37so2342703waf.7
	for <video4linux-list@redhat.com>; Sun, 17 Feb 2008 11:14:34 -0800 (PST)
Message-ID: <aedf12640802171114j227d1b5dmbbc7d1c9760171c@mail.gmail.com>
Date: Sun, 17 Feb 2008 16:14:33 -0300
From: "Alexandro Silva" <alexsilvasc@gmail.com>
To: "Linux and Kernel Video" <video4linux-list@redhat.com>
In-Reply-To: <aedf12640802170818m56e754fav14e16f80affcf98a@mail.gmail.com>
MIME-Version: 1.0
References: <aedf12640802151146i1c02547ct7cc1671285fb95cf@mail.gmail.com>
	<200802152303.55257.eugene@horn.dyndns.biz>
	<aedf12640802151409y2f66df99m97b5ddd5c833032@mail.gmail.com>
	<200802160226.59338.roginovicci@nm.ru>
	<aedf12640802170818m56e754fav14e16f80affcf98a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Subject: Encore ENLTV-FM (TV tuner Pro)
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

I am resending this answer. Soon I send it without CC ML.

Sorry,

Alexandro Silva

---------- Forwarded message ----------
From: Alexandro Silva <alexsilvasc@gmail.com>
Date: 17/02/2008 13:18
Subject: Re: Encore ENLTV-FM (TV tuner Pro)
To: Eugene <roginovicci@nm.ru>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>

I already did all of this. For the last 3 months. I'he tried to put sound at
my files. All sort of alsamixer configs was tested.
I insist: The sound was not going out from tv card at all. The system just
worked when I set up a different type of card.
I'd like was my personal mistake, but it's not. It seems to be a card with
same name but another specs.

Cheers.

Alexandro

2008/2/15, Eugene <roginovicci@nm.ru>:
>
> Are you saying you use saa7134-alsa sound device? If it is really needed
> saa7134-alsa to be loaded then try to play with alsamixer -c0 or
> alsamixer -c1 (and so on) parameters.
>
> On Saturday 16 February 2008 01:09:12 Alexandro Silva wrote:
> > My apologies.
> >
> > Let me explain better this detail. Using the litle cable to connect tv
> card
> > and sound card I have no audio at my headset or speakers. So to
> eliminate
> > the problem possibilite I connect the headset directly to audio out of
> tv
> > card. No sound until I select the card FlyVIDEO2000 (card=3).
> > After this reconfiguration, then sound flows from tv card to my sound
> card.
> > Unfortunally it's not a question of alsa configuration. This encore
> seems
> > to be quite different from that listed at CARDLIST.saa7134.
> >
> >
> > Cheers.
> >
> > 2008/2/15, eugene <eugene@horn.dyndns.biz>:
> > > Hola Alexandro!
> > >
> > > On Friday 15 February 2008 22:46:49 Alexandro Silva wrote:
> > > >. The only remaining problem is that
> > > > audio out is up even after close de screen, until I shutdown my
> machine
> > >
> > > and
> > >
> > > > when I start pc the tv sound gets up again during de boot process.
> > > >
> > > > I attached too the dmesg080215-ful.txt file with entire dmesg out
> and
> > > > dmesg080215.txt file with just saa grep.
> > >
> > > As far as I know SAA7130 based cards have no sound through pci
> > > functionality.
> > > Thus I came into conclusion that there is a wipe connecting the tuner
> and
> > > audio card. I think you should adjust the sound card through alsamixer
> > > and alsactl ( with "store" option) to turnoff line input by default.
> > >
> > > Cheers.
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
