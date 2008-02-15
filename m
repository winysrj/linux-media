Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1FM9e2a021798
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 17:09:41 -0500
Received: from wx-out-0506.google.com (wx-out-0506.google.com [66.249.82.224])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1FM9J3g003302
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 17:09:19 -0500
Received: by wx-out-0506.google.com with SMTP id t16so829240wxc.6
	for <video4linux-list@redhat.com>; Fri, 15 Feb 2008 14:09:14 -0800 (PST)
Message-ID: <aedf12640802151409y2f66df99m97b5ddd5c833032@mail.gmail.com>
Date: Fri, 15 Feb 2008 20:09:12 -0200
From: "Alexandro Silva" <alexsilvasc@gmail.com>
To: eugene <eugene@horn.dyndns.biz>
In-Reply-To: <200802152303.55257.eugene@horn.dyndns.biz>
MIME-Version: 1.0
References: <aedf12640802151146i1c02547ct7cc1671285fb95cf@mail.gmail.com>
	<200802152303.55257.eugene@horn.dyndns.biz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: Encore ENLTV-FM (TV tuner Pro)
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

My apologies.

Let me explain better this detail. Using the litle cable to connect tv card
and sound card I have no audio at my headset or speakers. So to eliminate
the problem possibilite I connect the headset directly to audio out of tv
card. No sound until I select the card FlyVIDEO2000 (card=3).
After this reconfiguration, then sound flows from tv card to my sound card.
Unfortunally it's not a question of alsa configuration. This encore seems to
be quite different from that listed at CARDLIST.saa7134.


Cheers.



2008/2/15, eugene <eugene@horn.dyndns.biz>:
>
> Hola Alexandro!
> On Friday 15 February 2008 22:46:49 Alexandro Silva wrote:
> >. The only remaining problem is that
> > audio out is up even after close de screen, until I shutdown my machine
> and
> > when I start pc the tv sound gets up again during de boot process.
> >
> > I attached too the dmesg080215-ful.txt file with entire dmesg out and
> > dmesg080215.txt file with just saa grep.
> As far as I know SAA7130 based cards have no sound through pci
> functionality.
> Thus I came into conclusion that there is a wipe connecting the tuner and
> audio card. I think you should adjust the sound card through alsamixer and
> alsactl ( with "store" option) to turnoff line input by default.
>
> Cheers.
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
