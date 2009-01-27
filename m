Return-path: <linux-media-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:45889 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547AbZA0ShA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 13:37:00 -0500
Received: by ug-out-1314.google.com with SMTP id 39so245776ugf.37
        for <linux-media@vger.kernel.org>; Tue, 27 Jan 2009 10:36:58 -0800 (PST)
Date: Tue, 27 Jan 2009 19:36:52 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Daniel Dalton <d.dalton@iinet.net.au>
cc: linux-media@vger.kernel.org,
	DVB mailin' list thingy <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] getting started with msi tv card
In-Reply-To: <20090127114045.GB10439@debian-hp.lan>
Message-ID: <alpine.DEB.2.00.0901271809580.15738@ybpnyubfg.ybpnyqbznva>
References: <20090120091952.GB6792@debian-hp.lan> <4975B5F1.7000306@iki.fi> <20090120220701.GB4150@debian-hp.lan> <49765448.8060108@iki.fi> <20090121003915.GA6120@debian-hp.lan> <4977088F.5080505@iki.fi> <20090122092844.GB14123@debian-hp.lan>
 <alpine.DEB.2.00.0901222327370.13623@ybpnyubfg.ybpnyqbznva> <20090127114045.GB10439@debian-hp.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 27 Jan 2009, Daniel Dalton wrote:

> > > I'm connecting it to a co-axle point in my home; I lost the original
> > > antenna.
> > > I'm reasonably sure that point should work fine.

> > In place of the original antenna, you can try a short
> > length of wire, say, 5cm long for the UHF frequency, to
> > about half a metre for the other frequencies.  This will,
> 
> What kind of wire? Ear phone? and how do I hook this up to the receiver
> since it has a co-axle input plug on it.

The type of wire should not matter.  In fact, you may not
even need to make contact between the metal of the coaxial
connector and the wire conductor for a very strong signal --
although ideally you would make this contact.

The idea behind this is that Antti has suggested that your
tuner may not work well with strong signals, so we are
wanting to get a somewhat weaker signal.  It could be,
though, that you will not get enough of a signal.  This
all will depend on the distance you are from the transmitter
site, the power it sends, and what sort of terrain exists
between you and the sender.

One thing has popped into my mind -- there are different
standards for coaxial connectors used in different parts
of the world for the same function, so I may have a totally
different idea of what you have...

Anyway, you are connected to your wall by a cable that
connects to your device.  Perhaps that cable is connected
to some sort of push-on or screw-on connector, or maybe
it is firmly attached to the wall without a connector.

The part of the connector of interest will be the centre
conductor.  Through europe, this exists on TV-type tuners
as an outer ring, somewhat over 1cm diametre, and a smaller
ring inside with a couple millimetre diametre.  I can actually
take a length of bell wire or thin electrical wire, fold about
1cm of it over on itself, and stick this into that centre
conductor to make a simple antenna that receives strong
signals.

If you have a screw-on type of F connector, that was common
for cable TV in america when I was there, but in europe is
found primarily on satellite equipment, then the part that
connects to the wall will have a centre conductor which
extends somewhat, if you are lucky.  This can be a bit
tricky, but a clip lead, with small alligator clip can be
of help, particularly if the F connector cannot be readily
screwed off.

Now, for the other type of F connector -- the female type,
one can simply stick in the end of some bell wire, after
removing a cm of insulation.

The problem is that I personally can't imagine myself
doing this without sight, because it's too easy to cause
a short-circuit between the outer and inner conductors,
which means your reception will drop to zero, and I rely
on visual feedback to see this.  So if you have some
technically-minded friend who can help you with this, it
may be easiest.

(There are no dangerous voltages to be found on these sort
of antenna connectors.  In strong signal areas, I can get
a good signal simply with my finger on the inner conductor,
possibly moistened for better conductivity.  This is not to
say that your equipment will be at earth potential, as all
this depends on the presence of and quality of your earth
ground, and in fact whether all your devices make use of it,
as I'm often zapped lightly when connecting USB devices to
an earthed computer, due to the lack of earthing on said
devices.  At worst, your tuner may deliver 5v to power an
active antenna, but nothing to throw you across the room.)

Actually, 5cm wire for the UHF frequency in use might be a bit
short, so you may be better with 20 to 100cm overall.


Another thing to keep in mind, though it won't be as important
as it is with a rooftop-mounted antenna, is the polarisation
of the radio signals from the transmitter; the scanfiles I
see here don't give any hints to that for your area, and my
internet connection presently is too poor for me to look
online.


Anyway, good luck; it could be that with this you are
unable to receive any signal whatsoever, in which case all
the time I spent writing this will have been for nought,
and, unless some other brilliant idea reveals itself, you
will be forced to go the path of obtaining a different
tuner and hoping that one works out-of-the-box...

barry bouwsma
