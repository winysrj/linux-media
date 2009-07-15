Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:49684 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbZGOI6w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jul 2009 04:58:52 -0400
Date: Wed, 15 Jul 2009 05:58:42 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: =?utf-8?B?T2xkxZlpY2ggSmVkbGnEjWth?= <oldium.pro@seznam.cz>
Cc: Hartmut Hackmann <hartmut.hackmann@t-online.de>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Ricardo Cerqueira <v4l@cerqueira.org>,
	LMML <linux-media@vger.kernel.org>,
	hermann pitton <hermann-pitton@arcor.de>
Subject: Re: [RFC] SAA713x setting audio capture frequency (ALSA)
Message-ID: <20090715055842.42ba195e@pedra.chehab.org>
In-Reply-To: <200907150857.13784.oldium.pro@seznam.cz>
References: <200907121948.39944.oldium.pro@seznam.cz>
	<1247447201.3235.38.camel@pc07.localdom.local>
	<200907132120.38971.oldium.pro@seznam.cz>
	<200907150857.13784.oldium.pro@seznam.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 15 Jul 2009 08:57:13 +0200
Oldřich Jedlička <oldium.pro@seznam.cz> escreveu:

> Hi Hartmut, Ricardo, Dmitri,
> 
> (hopefully I have the right addresses, if not - sorry for bothering :-))
> 
> Hermann recommended me to contact you for this issue. I would like to ask you 
> if any of you (or any other reader!) is working on saa7134-alsa or 
> saa7134-tvaudio or have any plans to do so. Also if you find any section 
> below interresting, please comment it. I'm seeking for opinions from anybody 
> who has more knowledge in saa713x audio programming than me :-)
> 
> My main concern is that ALSA reports wrong frequency for TV (48kHz) while it 
> can use only 32kHz, second is the correct setting up of 48kHz for LINE1/LINE2 
> (doesn't work at the moment). There are possibly also other concerns - ALSA 
> controls update for example.

I think it is a little worse than that, since it seems that 48 kHz could be
supported by a few video standards (datasheet is not clear about it).

The issue of dynamically updating ALSA is basically what would happen if you
start alsa with, for example line1 @ 48 kHz and change it to TV. I'm not sure
if alsa aplications like arecord/aplay, sox or even mplayer would behave
correctly.

So, maybe the right thing to do is to report just 32 kHz.

> 
> My plan is to come up with few patches after the discussion for another 
> discussion.


> 
> On Monday 13 of July 2009 at 21:20:38, Oldrich Jedlicka wrote:
> > Hi Hermann,
> >
> > On Monday 13 of July 2009 at 03:06:41, hermann pitton wrote:
> > > Hi Oldřich,
> > >
> > > this needs to be looked up during day time, preferably with the register
> > > settings for all involved saa713x devices, which I do not have ...
> >
> > You can respond the next day, no need to stay awake :-)
> >
> > > Am Sonntag, den 12.07.2009, 19:48 +0200 schrieb Oldřich Jedlička:
> > > > Hi all,
> > > >
> > > > I had a look at the audio code in saa7134 directory once again
> > > > (saa7134-alsa.c and saa7134-tvaudio.c). It has one major problem - the
> > > > frequency for SAA7134 isn't set during startup, only during the capture
> > > > source change (that is another problem). But let's start from
> > > > beginning, please comment what you find interresting, I will create a
> > > > patch after the discussion for another discussion :-).
> > >
> > > ;)
> > >
> > > > 1. SAA7133/SAA7135
> > > >
> > > > SAA7133/SAA7135 always use DDEP (DemDec Easy Programming) mode which
> > > > runs on 32kHz only. There is no need to change the frequency at all, so
> > > > everything works except that the info coming from ALSA reports both
> > > > frequencies 32kHz and 48kHz as available for recording. This can be
> > > > easily changed in snd_card_saa7134_hw_params to report only 32kHz for
> > > > SAA7133/SAA7135.
> > >
> > > So, for now, agreed. But you should try to talk to Ricardo and Hartmut
> > > in this case. I can tell you about the three years it did not work.
> >
> > Do you mean Ricardo Carrillo Cruz and Hartmut Hackmann? I've found them via
> > Google (Google knows everyone :-)) I can add them to CC. Do you know if
> > they are still working on the code (saa7134-tvaudio, saa7134-alsa)?
> >
> > > > 2. SAA7134
> > > >
> > > > SAA7134 is special in the way it programs the frequency by hand. It
> > > > uses 32kHz DemDec mode for TV (DemDec works only in 32kHz mode), 32kHz
> > > > for radio (this is locked), and 32kHz/48kHz for S-Video and Composite
> > > > inputs. ALSA again reports both frequencies 32kHz and 48kHz as
> > > > available for recording - this can be changed accordingly.
> > >
> > > Agreed.
> > >
> > > > The problem is that the frequency is never changed during
> > > > inicialization like it was in OSS code (see 2.6.24 kernel,
> > > > saa7134_oss_init1 calls mixer_recsrc). I think that this responsibility
> > > > is now on the
> > > > snd_card_saa7134_capture_prepare method - it should set the frequency
> > > > in SAA7134_SIF_SAMPLE_FREQ register correctly, possibly also
> > > > SAA7134_ANALOG_IO_SELECT. Note that the tvaudio's mute_input_7134 sets
> > > > the frequency to 32kHz, this can be thrown away I think.
> > >
> > > Agreed. If any, that is the only "regression" to report compared to
> > > saa7134-oss.
> > >
> > > > I tried to set SAA7134_SIF_SAMPLE_FREQ in
> > > > snd_card_saa7134_capture_prepare and the capturing works correctly with
> > > > 48kHz from my digital camera (Composite input).
> > >
> > > OK, that should be previous behaviour then.
> > >
> > > > 3. Changing the capture source
> > > >
> > > > The ALSA interface has three capture sources, all of them have left and
> > > > right channels (boolean values) - LINE1, LINE2 and TV. The user can
> > > > select any source - ALSA calls snd_saa7134_capsrc_put.
> > >
> > > Note, without looking any further, LINE1 and LINE2 are left/right
> > > _pairs_ of stereo inputs. In saa7134-oss it was needed to select them
> > > card specific.
> >
> > I understand that they are left/right pairs. The saa7134-oss code knew
> > about TV, LINE1, LINE2 and LINE2_LEFT possibilities. The LINE2_LEFT worked
> > only on SAA7134 chip, because it programmed the OCS (output crossbar
> > select) to record LINE2's left channel only. I don't see anything special
> > in 2.6.24 kernel in saa7134-oss.c for setting the LINE1/LINE2/LINE2_LEFT in
> > a card specific manner (other than SAA7133/34/35). Moreover, the _correct_
> > output channel selection for LINE2_LEFT wasn't done in saa7134-oss code,
> > but in saa7134-tvaudio (which is a little bit strange).
> >
> > The biggest problem - when I read the specification that I've found years
> > ago - is that I don't know which registers can be changed in the DDEP mode.
> > Maybe it would be possible to enable the _real_ left/right-only channel
> > selection for all SAA713x chips.
> >
> > > > The ALSA controls are not updated, so it is possible to select both
> > > > LINE1 and LINE2 at the same time, but recording will use only one of
> > > > them - the last changed control wins. Moreover the left/right selection
> > > > doesn't make any difference, the code ignores it.
> > >
> > > For saa7133/35/31e that was exactly Hartmut's plan. You don't have to
> > > care to select the right inputs anymore. And with Ricardo exporting the
> > > mute symbol from saa7134-tvaudio to saa7134-alsa, you don't have to care
> > > for this either. (mythtv v4l1, except you do ambiguous stuff from user
> > > side)
> >
> > The just-works is good and it would be good to automatically update the
> > ALSA capture source (the control) when the application opens/selects the
> > corresponding v4l device. I actually don't know how, but I can learn
> > (Google is our friend) :-)
> >
> > > > Here comes also the frequency problem of SAA7134. If the user starts
> > > > with LINE1 and 48kHz and tries to switch to TV, the frequency will
> > > > change to 32kHz (DemDec mode) - the application will not know, I guess
> > > > there will be some buffer underruns.
> > >
> > > Anyway, to switch to 32kHz for TV is right currently, but it doesn't
> > > stop since years, that it is claimed, more is possible. No proof for any
> > > standard yet and A2 and NICAM won't do at least.
> >
> > When the driver switches to different frequency, the application will still
> > play in the original rate. This means that the 32kHz data will be played at
> > 48kHz, so the application will play each captured block at higher frequency
> > with pauses in between. This doesn't sound good, this should be disallowed
> > somehow when the recording is ongoing. Or is it possible to send
> > configuration update to ALSA system about the fact that the source
> > frequency has changed?
> >
> > Another thing is which frequencies the driver should report to ALSA? When
> > you change the capture source (either by the v4l interface or by the mixer
> > controls), the capabilities change too. This is another argument agains the
> > 48kHz I think.
> >
> > > > Note that any change of capture source control is overriden by the call
> > > > to snd_card_saa7134_capture_prepare (called by ALSA before the capture
> > > > source is opened) that takes the current input as set by
> > > > saa7134_tvaudio_setinput (called by v4l interface). I think this is
> > > > actually expected behaviour and can stay as it is now.
> > >
> > > There are also cards with mpeg encoders and you can't just mute or do
> > > what you want.
> > >
> > > > The easiest solution would be to throw away the capture source control
> > > > and let the capture source initialization on the
> > > > snd_card_saa7134_capture_prepare method (the source would be controlled
> > > > by saa7134_tvaudio_setinput only - through v4l interface only), or
> > > > limit the frequency to 32kHz only so that any source can be freely
> > > > selected on any SAA713x hardware.
> > >
> > > I'm not sure, in case we are talking about all sources, talk about the
> > > same things already. Also, you might have noticed or not, there are also
> > > mute calls depending on having a signal.
> >
> > That's right, the saa7134-tvaudio has a thread to check the signal/stereo
> > (when the TV source is selected) and it also has a more complete source
> > channel control (than the one found in saa7134-alsa/oss). It also changes
> > the frequency to 32kHz when the LINE1/LINE2 are used... I think this should
> > be changed somehow to have the channel configuration at one place (not in
> > both saa7134-tvaudio's mute methods and in saa7134-alsa).
> >
> > > > Any other ideas, comments, corrections (I could be wrong in what I
> > > > wrote, I'm not the SAA713x programming expert!), suggestions?
> > > >
> > > > Cheers,
> > > > Oldrich.
> > >
> > > Given the problems we had previously, I'm not right sure, if we really
> > > have some now at all, hm, 02:52 am ;)
> > >
> > :-)
> > :
> > > But you have at least some reaction ...
> > >
> > > Cheers,
> > > Hermann
> >
> > Thanks for your comments, Hermann.
> >
> > Cheers,
> > Oldřich.
> 
> Cheers,
> Oldřich.




Cheers,
Mauro
