Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:50222 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024AbZIPDXS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 23:23:18 -0400
Subject: Re: tuner, code for discuss
From: Andy Walls <awalls@radix.net>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	video4linux-list@redhat.com,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <303a8ee30909142155n36bdf40fpb5675361bce69a62@mail.gmail.com>
References: <20090819160700.049985b5@glory.loctelecom.ru>
	 <37219a840908250940m3393f73ftbaa28639ca0f93cd@mail.gmail.com>
	 <20090910152510.6970f8ab@glory.loctelecom.ru>
	 <303a8ee30909140555y32d86999x5b4aaf7417fba293@mail.gmail.com>
	 <20090915140715.2b9ea890@glory.loctelecom.ru>
	 <303a8ee30909142118h6808a249o2cb22570fca8dfd4@mail.gmail.com>
	 <1252989796.3250.72.camel@pc07.localdom.local>
	 <303a8ee30909142155n36bdf40fpb5675361bce69a62@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 23:25:33 -0400
Message-Id: <1253071533.7816.35.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2009-09-15 at 00:55 -0400, Michael Krufky wrote:
> On Tue, Sep 15, 2009 at 12:43 AM, hermann pitton
> <hermann-pitton@arcor.de> wrote:
> >
> > Am Dienstag, den 15.09.2009, 00:18 -0400 schrieb Michael Krufky:
> >> On Tue, Sep 15, 2009 at 12:07 AM, Dmitri Belimov <d.belimov@gmail.com> wrote:
> >> > On Mon, 14 Sep 2009 08:55:22 -0400
> >> > Michael Krufky <mkrufky@kernellabs.com> wrote:
> >> >
> >> >> On Thu, Sep 10, 2009 at 1:25 AM, Dmitri Belimov <d.belimov@gmail.com>
> >> >> wrote:
> >> >> > Hi All
> >> >> >
> >> >> > This is my next patch.
> >> >> >
> >> >> > Changes:
> >> >> > 1. By default charge pump is ON
> >> >> > 2. For radio mode charge pump set to OFF
> >> >> > 3. Set correct AGC value in radio mode
> >> >> > 4. Add control gain of AGC.
> >> >> > 5. New function simple_get_tv_gain and simple_set_tv_gain for
> >> >> > read/write gain of AGC. 6. Add some code for control gain from
> >> >> > saa7134 part. By default this control is OFF 7. When TV card can
> >> >> > manipulate this control, enable it.
> >> >> >
> >> >> > Main changes is control value of AGC TOP in .initdata =
> >> >> > tua603x_agc112 array. Use this value for set AGC TOP after set freq
> >> >> > of TV.
> >> >> >
> >> >> > I don't understand how to correct call new function for read/write
> >> >> > value of AGC TOP.
> >> >> >
> >> >> > What you think about it??
> >> >> >
> >> >>
> >> >> [patch snipped]
> >> >>
> >> >> >
> >> >> >
> >> >> > With my best regards, Dmitry.
> >> >>
> >> >> Dmitry,
> >> >>
> >> >> The direct usage of .initdata and .sleepdata is probably unnecessary
> >> >> here --  If you trace how the tuner-simple driver works, you'll find
> >> >> that simply having these fields defined will cause these bytes to be
> >> >> written at the appropriate moment.
> >> >>
> >> >> However, for the actual sake of setting this gain value, I'm not sure
> >> >> that initdata / sleep data is the right place for it either.  (I know
> >> >> that I recommended something like this at first, but at the time I
> >> >> didn't realize that there is a range of six acceptable values for this
> >> >> field)
> >> >>
> >> >> What I would still like to understand is:  Who will be changing this
> >> >> value?  I see that you've added a control to the saa7134 driver -- is
> >> >> this to be manipulated from userspace?
> >> >
> >> > Yes
> >> >
> >> >> Under what conditions will somebody want to change this value?
> >> >
> >> > for SECAM with strong signal we have wide white crap on the screen.
> >> > Need reduce value of AGC TOP.
> >> >
> >> > For weak signal need increase value of AGC TOP
> >> > Ajust value of AGC TOP can get more better image quality.
> >> >
> >> >> How will users know that they need to alter this gain value?
> >> >
> >> > By default use value from .initdata
> >> > v4l2-ctl can modify this value or via some plugins for TV wach programm.
> >> >
> >> > End-user programm for watch TV IMHO now is very poor.
> >> >
> >> > With my best regards, Dmitry.
> >> >
> >>
> >> I have to admit that I am not familiar enough with SECAM myself to see
> >> this kind of trouble.  For NTSC and PAL, tvtime is a great application
> >> -- the only shortcoming that bothers me about tvtime is lack of audio
> >> support.  One must rely on a separate mechanism to hear audio, whether
> >> it's a patch cable from the tv tuner to the sound board, or a separate
> >> application decoding DMA audio.  ...but that is not what this email
> >> thread is about.
> >>
> >> As far as simple tuning and analog television viewing goes, tvtime
> >> rocks.  Is it really that difficult for SECAM users?
> >>
> >> In summary, you are telling us that we need to add userspace controls
> >> to handle gain control, for tuning SECAM.  I am going to have to ask
> >> for help on this topic from those cc'd on this email.  (Adding Hans
> >> Verkuil, as I value his opinion for controls and dealing with video
> >> standards in high regard)
> >>
> >> Personally, I don't quite understand why we would need to add such
> >> controls NOW, while we've supported this video standard for years
> >> already.  I am not arguing against this in any way, but I dont feel
> >> like I'm qualified to accept this addition without hearing the
> >> opinions of others first.
> >>
> >> Can somebody help to shed some light?
> >>
> >> Cheers,
> >>
> >> Mike
> >
> > Mike,
> >
> > i did discuss this with Dmitri a lot on the list previously.
> >
> > I destroyed one of my FM1216ME/I MK3 tuners, searched all websites in
> > China, to convince him not to do that for the original Philips tuners.
> >
> > Andy was also pretty active on it, thanks for your help.
> >
> > However, it is for now only about that TCL MK3, using different filters
> > than the original Philips stuff, and their labs have clear results, that
> > they can improve SECAM-DK this way for their users.
> 
> Thanks for the comment, Hermann.
> 
> Do you think there is any way that we can automate this without having
> to expose an additional user control?

We should automate this.

1. The user will generally be incapable of setting it properly for a
number of reasons.

2. The tuner modules/subdevs are aware of the standards changes
via .s_std calls, so they should be able to set the TOP when needed.

3. The TOP also needs to be set for FM radio mode on tuners that support
FM.


Problems with proper automation of this feature:

1. We have many overloaded tuner definitions: a single definition is
used for multiple tuner models of varying types.  These tuners *may*
need slightly different TOP settings; thus requiring splitting out to
separate tuner definitions.  Maybe many won't.

2. Only the manufacturer has the engineering design data to say what the
proper TOP should be.  That's hard to get for Leading suppliers.  I have
no idea how much harder it would be for the knockoffs and clones.
Forget getting the proper values for counterfits.

3. A manufacturer like Dmitry's company can take measurments on
specimens that have been opened up, but it requires going through a
range of video input signal levels and a test on a single device from a
production run may not be representative of the worst case in that tuner
assembly's design.

4. Analog OTA is DEAD in the US; cable will follow in 2 years or so.  My
personal level of caring about analog RF tuners is low.


> If you believe that it's necessary, I am fine with adding this, but I
> will need Mauro to agree on it as well -- that's why I'm asking for
> some argument points.



> Some questions that he might ask -- why do we need this in the saa7134
> driver but not the other drivers?  Is this specific to this TCL MK3
> only?  Could doing this help to improve SECAM support for users of
> other tuners?

This is about optimizing receiver system nosie figure under a range of
RF signal levels.  The losses before the first gain stage dominate the
noise figure, and the gain of the first stage mitigates the noise
contributions of the components behind it.  The higher the gain you can
maintain in the first stage without clipping/distortion, the better your
overall receiver noise figure, and the better your SNR.   The worst
thing that can happen is a strong signal coming in and the TOP being set
to high (I think - I'm tired), so that the signal experiences non-linear
distortion in the first stage (Osc/Mixer and IF amplifier). 

Here's a quick tutorial on the concept:
http://www.comsec.com/usrp/microtune/NF_tutorial.pdf

This is sometimes a problem that's *not* solvable with TOP settings for
some tuners, as the AGC signal from the sencond stage (IF demodulator)
is not fed to the first stage's AGC.  It all depends on how the
manufacturer wired up the tuner internals.

Regards,
Andy

> Cheers,
> 
> Mike
> --

