Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6GNqOF7002867
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 19:52:24 -0400
Received: from mail-in-03.arcor-online.net (mail-in-03.arcor-online.net
	[151.189.21.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6GNqB2q025985
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 19:52:12 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Per Baekgaard <baekgaard@b4net.dk>
In-Reply-To: <487E7238.7030003@b4net.dk>
References: <487E7238.7030003@b4net.dk>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 01:47:51 +0200
Message-Id: <1216252071.2669.56.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Seeking help for a 713x based card
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

Hi Per,

Am Donnerstag, den 17.07.2008, 00:12 +0200 schrieb Per Baekgaard:
> I have a card of unknown (to me) brand that identifies itself as a 
> 1131:7133 (chipset) with 1a7f:2004 rev d1 as the subsystem ID/revision.

1131:7133 in .dk means a saa7135 or more likely a recent saa7131e.
The subvendor 1a7f seems to be seen the first time here, subdevice 2004
is only known on some Philips reference designs.

> The card is unfortunately glued (!) inside a LCD enclosure, and I am not 
> able to see any further identifications on it.

;) what to say.

> Google'ing the SVID/SSID hints that it could be a PAL derivative of an 
> Encore ENLTV-FM card. When asked, Encore basically just said that the 
> closest match would appear to be ENLTV-FM and that there is no support 
> for linux and asked me to look at sourceforge.net ;-)

They are likely right to send you out into the deserts.

> I am able to get it partially running by using "options saa7134 card=107 
> tuner=54" (or card 3), but it appears that changing channel via tvtime 
> or myth  fails roughly half the time and simply causes it to return an 
> invalid (or empty) video stream. Indeed, in myth, it sometimes crashes 
> the application.

If channel change sometimes works it is some tuner=54, but might need
some card specific calibration or your signal is weak.

Is DVB-T or DVB-S announced too or only analog TV?

> I am also not able to capture any sound from the card, although 
> saa7134_alsa gets loaded as expected.

Most of the recent cards don't have analog sound output to the sound
card anymore. The chips do provide it, but manufacturers decide against
to provide the connector.

The saa7134-alsa must be properly used and does not work automagically,
also if a gpio switched sound mux chip is on the card, it needs to be
configured correctly for sound switching. This is not visible in the
logs.

> How do I debug this, and get the driver to recognise the card properly?
> 
> Or any good hints at what the card may be? Would the i2c reveal any 
> further hints?

To set up an invisible device is a bit odd,
but copy and paste "dmesg" output after loading the driver with
i2c_scan=1 enabled ("modinfo saa7134") might help on some further
guessing.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
