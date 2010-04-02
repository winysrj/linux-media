Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57]:52629 "EHLO
	mail-in-17.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752912Ab0DBArS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 20:47:18 -0400
Message-ID: <20537285.1270169235912.JavaMail.ngmail@webmail09.arcor-online.net>
Date: Fri, 2 Apr 2010 02:47:15 +0200 (CEST)
From: hermann-pitton@arcor.de
To: mchehab@redhat.com, dheitmueller@kernellabs.com
Subject: Aw: Re: V4L-DVB drivers and BKL
Cc: hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 
Hi!

----- Original Nachricht ----
Von:     Mauro Carvalho Chehab <mchehab@redhat.com>
An:      Devin Heitmueller <dheitmueller@kernellabs.com>
Datum:   02.04.2010 01:10
Betreff: Re: V4L-DVB drivers and BKL

> Devin Heitmueller wrote:
> > On Thu, Apr 1, 2010 at 5:07 PM, Mauro Carvalho Chehab
> > <mchehab@redhat.com> wrote:
> >>> Most i2c locks typically are only held for the duration of a single
> >>> i2c transaction.  What you are proposing would likely result in just
> >>> about every function having to explicitly lock/unlock, which just
> >>> seems bound to be error prone.
> >> The i2c open/close should be part of the transaction. Of course, there's
> no
> >> need to send a command to open an already opened gate (yet, from some
> sniff
> >> dumps, it seems that some drivers for other OS's do it for every single
> i2c
> >> access).
> > 
> > I'm not even talking about i2c gate control, which is a whole separate
> > case where it is applied inconsistently across drivers.  Even under
> > Linux, we have lots of cases where there are double opens and double
> > closes of the i2c gate, depending on whether the developer is
> > controlling the gate from the tuner driver or the demodulator.
> > 
> > What I'm getting at though is that the lock granularity today is
> > typically at the i2c transaction level, so something like an demod
> > driver attempting to set two disparate registers is likely to be two
> > i2c transactions.  Without moving the locking into the caller, the
> > other half of the driver can take control between those two
> > transactions.  And moving the logic into the caller means we will have
> > to litter the code all over the place with lock/unlock calls.
> 
> I agree with a caller logic.
> 
> Yet, even moving to the caller, an i2c lock is still needed. For example,
> i2c IR
> events are polling at interrupt time, so, they can happen anytime,
> including
> in the middle of one i2c transaction (by transaction, I mean gate
> control+i2c
> read/write ops go get/set a single register).
> 
> >>> We've got enough power management problems as it is without adding
> >>> lots additional complexity with little benefit and only increasing the
> >>> likelihood of buggy code.
> >> For sure a lock at the open() is simple, but I suspect that this may
> >> cause some troubles with applications that may just open everything
> >> on startup (even letting the device unused). Just as one example of
> >> such apps, kmix, pulseaudio and other alsa mixers love to keep the
> >> mixer node opened, even if nobody is using it.
> > 
> > I'm frankly far less worried about the ALSA devices than I am about
> > DVB versus V4L Vdeo/VBI, based on all the feedback I see from real
> > users.
> 
> Ok, but alsa driver may also try to access things like i2c. For example,
> msp34xx audio controls are reached via I2C.
> 
> > The cases where we are getting continuously burned are MythTV
> > users who don't have their "input groups" properly defined and as a
> > result MythTV attempts to use both digital and analog at the same time
> > (input groups themselves are really a hack to deal with the fact that
> > the Linux kernel doesn't have any way to inform userland of the
> > relationships).

We see the same on other OSs as well.

In fact, to use digital and analog at once is totally valid.

It is much too short to think about a device with a single hybrid tuner,
best known meanwhile for causing troubles.

The Medion Quad (md8080) on the saa713x with two hybrid tuners, 
two DVB-S tuners, four digital and two analog demodulators with two dedicated PCI 
bridges, with its restrictions too, is already ancient stuff.

> > And the more I think about it, we can probably even implement the
> > locking itself in the V4L and DVB core (further reducing the risk of
> > some bridge maintainer screwing it up).  All the bridge driver would
> > have to do is declare the relationship between the DVB and V4L devices
> > (both video and vbi), and the enforcement of the locking could be
> > abstracted out.

On older dual tuner, triple and quad stuff it needs granularity through each driver 
down to the physically existing device.

No app on any OS seems to have it right. In best case they have some framework 
around to ask the user about his knowledge for what is a go and what a no go.

Newer hardware can really do triple stuff at once for example.
Nothing much left to configure wrong from the user and the app.

But, to start simple, if a single bridge can pass DVB-T and DVB-S at once is as important to know these days 
as all details about tuners, demodulators and SECs on a given device. 

That mixture of old and new will continue over years anyway 
and to escape with some easy rules doesn't look simple.

Some either digital or analog does not exist, except for a single hybrid tuner.

Even then, on such a simplest hybrid device, the tuner can be in digital mode and without 
any problems you can have analog video from external inputs at once.

> I agree on having some sort of resource locking in core, but this type
> of lock between radio/audio/analog/analog mpeg-encoded/digital/vbi/...
> is different than a mere mutex-type of locking from what we've discussed
> so far. It has nothing to do with BKL.
> 
> -- 
> 
> Cheers,
> Mauro

Just some thoughts again.

Cheers,
Hermann


Frohe Ostern! Alles für's Fest der Hasen und Lämmer jetzt im Osterspecial auf Arcor.de: http://www.arcor.de/rd/footer.ostern
