Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:27911 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbZA1QTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 11:19:35 -0500
Received: by fg-out-1718.google.com with SMTP id 13so611949fge.17
        for <linux-media@vger.kernel.org>; Wed, 28 Jan 2009 08:19:33 -0800 (PST)
Date: Wed, 28 Jan 2009 12:19:24 -0400
From: Manu <eallaud@gmail.com>
Subject: Re : [linux-dvb] Technotrend Budget S2-3200 Digital artefacts on
 HDchannels
To: linux-media@vger.kernel.org
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>
	<157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>
	<c74595dc0901260819g22f690d1qe809808eacb829da@mail.gmail.com>
	<1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com>
	<c74595dc0901261107i66125bfdpe35cb7b89144ab11@mail.gmail.com>
	<497F6B2E.6010305@gmail.com>
	<c74595dc0901271240i2008cacdp565fe69f3269ea55@mail.gmail.com>
	<497F7C40.6030300@gmail.com>
	<c74595dc0901271402g5a44fe05pecae642570e54e0f@mail.gmail.com>
	<497F927E.8050009@gmail.com>
	<b1dab3a10901280303s62a5afd8oe906ce93f05614dd@mail.gmail.com>
In-Reply-To: <b1dab3a10901280303s62a5afd8oe906ce93f05614dd@mail.gmail.com>
	(from n37lkml@gmail.com on Wed Jan 28 07:03:00 2009)
Message-Id: <1233159564.8255.0@manu-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Le 28.01.2009 07:03:00, n37 a écrit :
> On Wed, Jan 28, 2009 at 1:02 AM, Manu Abraham 
> <abraham.manu@gmail.com>
> wrote:
> > Alex Betis wrote:
> >> On Tue, Jan 27, 2009 at 11:27 PM, Manu Abraham
> <abraham.manu@gmail.com>wrote:
> >>
> >>> Alex Betis wrote:
> >>>> On Tue, Jan 27, 2009 at 10:14 PM, Manu Abraham
> <abraham.manu@gmail.com
> >>>> wrote:
> >>>>
> >>>>> Alex Betis wrote:
> >>>>>>> It won't. All you will manage to do is burn your demodulator,
> if you
> >>>>> happen
> >>>>>>> to
> >>>>>>> be that lucky one, with that change. At least a few people
> have burned
> >>>>>>> demodulators by now, from what i do see.
> >>>>>>>
> >>>>>> What are the symptoms of burned demodulator? How can someone
> know if
> >>> its
> >>>>>> still ok?
> >>>>> The first time i saw it was that the DVB-S2 demod was returning
> no
> >>>>> carrier. After some time it was stating timing error for DVB-S
> as
> >>>>> well. Finally it all ended up with demodulator I2C ACK failure,
> and
> >>>>> eventually a frozen machine after a week (my test boxes run
> throughout)
> >>>>>
> >>>>> Touching the demodulator, i happened to have almost a burned
> finger.
> >>>>> I wanted to know whether this was a single case. During the
> >>>>> development phase, i did mention it to Julian about this, since
> he
> >>>>> was the very first person to test for the stb0899 driver. He
> >>>>> jovially laughed about a burned demodulator and a finger, left
> his
> >>>>> machine on after i did some tests on it. Eventually he too had
> the
> >>>>> same results. Finally we changed cards.
> >>>> What frequency did you use to burn it?
> >>>
> >>> It was a long time back, don't remember. It has nothing to do 
> with
> >>> the frequency of the transponder, but just the master clock. You
> can
> >>> run it to a maximum of 108Mhz overclocked, 99Mhz to be safe and
> >>> sufficient.
> >>>
> >>>
> >>>> I didn't see anyone here on the list that reported a hardware
> failure so
> >>>> far.
> >>> May god help you. I didn't know that you knew more than the
> >>> demodulator manufacturer !
> >>
> >> Please speak for yourself, I never said I know more than a
> manufacturer.
> >> I wrote a fact.
> >> Intel also rate their chips and everybody overclocks them to crazy
> ratings.
> >>
> >>
> >>>
> >>>
> >>>> By the way, Igor returned the chip frequency for 27.5 channels 
> to
> 99MHz
> >>> and
> >>>> raised it a bit for higher SR channels, so there is no danger 
> for
> >>> majority
> >>>> of the users.
> >>> Ok, be happy with his change and keep quiet. 135Mhz is out of
> bounds
> >>> of the hardware specification. You are on your own. Raising the
> >>> master clock, doesn't bring you any advantage.
> >>
> >> Did someone overclock you as well?
> >> Chill out!
> >> It would be better if you'll be more productive instead of 
> quieting
> people
> >> who try to help.
> >>
> >> Again, I'm commenting facts. As I saw from the reports the
> overclock seems
> >> to help with the problem.
> >>
> >>
> >>> From your statement (and the patch), it is clearly evident that
> you
> >>> don't understand head or tail what you are stating or patched the
> >>> code for:
> >>
> >> So be so kind, and add comments to the code you write so everybody
> could
> >> find its head and tail when trying to fix bugs.
> >> It is clearly evident that you don't really want that someone else
> will
> >> understand your code.
> >>
> >> Again, facts are that the patch help and make the device more
> stable for
> >> DVB-S channels.
> >>
> >>
> >>
> >> Oh well, I hate that I had to get so low with my message, but
> that's that
> >> happen when someone try to align with your expressions.
> >> In case you didn't know, you're not alone in the universe, get 
> used
> to it.
> >
> > I should be the one who should be kicked for trying to help you.
> >
> > _______________________________________________
> > linux-dvb users mailing list
> > For V4L/DVB development, please use instead
> linux-media@vger.kernel.org
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
> 
> I am writing just to share my experience with tt3200 drivers. The
> following are just observations about the behavior of my card:
> 
> 1. The card has never tuned reliably with the v4l-dvb s2api driver or
> the multiproto driver. This concerns not just high rate dvb-s2
> transponders but also some plain dvb-s transponders as well. And this
> is not just random hiccups but consistent behavior. German Eurosport 
> @
> 19.2e is a prime example.
> 2. When Igor first increased the high clock to 135MHz, there was a
> marked improvement. All of the tuning issues were gone. However I am
> using a rotor and the higher clock rate somehow broke rotor control.
> 3. Next Igor backed down the high clock to 99MHz and introduced a
> "very high clock" of 135MHz. Tuning went back to unreliable. Rotor
> control was ok.
> 4. I bought a hvr4000. And now all of my issues are gone.

I am thinking about it also :(
Does it work reliably with dvb-s/s2 and CAM?
Thx
Bye
Manu


