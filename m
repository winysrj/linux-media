Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:46618 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbZGMBML (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2009 21:12:11 -0400
Subject: Re: [RFC] SAA713x setting audio capture frequency (ALSA)
From: hermann pitton <hermann-pitton@arcor.de>
To: =?UTF-8?Q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@seznam.cz>
Cc: LMML <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <200907121948.39944.oldium.pro@seznam.cz>
References: <200907121948.39944.oldium.pro@seznam.cz>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 Jul 2009 03:06:41 +0200
Message-Id: <1247447201.3235.38.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Oldřich,

this needs to be looked up during day time, preferably with the register
settings for all involved saa713x devices, which I do not have ...

Am Sonntag, den 12.07.2009, 19:48 +0200 schrieb Oldřich Jedlička:
> Hi all,
> 
> I had a look at the audio code in saa7134 directory once again 
> (saa7134-alsa.c and saa7134-tvaudio.c). It has one major problem - the 
> frequency for SAA7134 isn't set during startup, only during the capture 
> source change (that is another problem). But let's start from beginning, 
> please comment what you find interresting, I will create a patch after the 
> discussion for another discussion :-).

;)

> 1. SAA7133/SAA7135
> 
> SAA7133/SAA7135 always use DDEP (DemDec Easy Programming) mode which runs 
> on 32kHz only. There is no need to change the frequency at all, so 
> everything works except that the info coming from ALSA reports both 
> frequencies 32kHz and 48kHz as available for recording. This can be easily 
> changed in snd_card_saa7134_hw_params to report only 32kHz for 
> SAA7133/SAA7135.

So, for now, agreed. But you should try to talk to Ricardo and Hartmut
in this case. I can tell you about the three years it did not work.

> 2. SAA7134
> 
> SAA7134 is special in the way it programs the frequency by hand. It uses 32kHz 
> DemDec mode for TV (DemDec works only in 32kHz mode), 32kHz for radio (this 
> is locked), and 32kHz/48kHz for S-Video and Composite inputs. ALSA again 
> reports both frequencies 32kHz and 48kHz as available for recording - this 
> can be changed accordingly.

Agreed.

> The problem is that the frequency is never changed during inicialization like 
> it was in OSS code (see 2.6.24 kernel, saa7134_oss_init1 calls mixer_recsrc). 
> I think that this responsibility is now on the 
> snd_card_saa7134_capture_prepare method - it should set the frequency in 
> SAA7134_SIF_SAMPLE_FREQ register correctly, possibly also 
> SAA7134_ANALOG_IO_SELECT. Note that the tvaudio's mute_input_7134 sets the 
> frequency to 32kHz, this can be thrown away I think.

Agreed. If any, that is the only "regression" to report compared to
saa7134-oss.

> I tried to set SAA7134_SIF_SAMPLE_FREQ in snd_card_saa7134_capture_prepare  
> and the capturing works correctly with 48kHz from my digital camera (Composite 
> input).

OK, that should be previous behaviour then.

> 3. Changing the capture source
> 
> The ALSA interface has three capture sources, all of them have left and right 
> channels (boolean values) - LINE1, LINE2 and TV. The user can select any 
> source - ALSA calls snd_saa7134_capsrc_put.

Note, without looking any further, LINE1 and LINE2 are left/right
_pairs_ of stereo inputs. In saa7134-oss it was needed to select them
card specific.

> The ALSA controls are not updated, so it is possible to select both LINE1 and 
> LINE2 at the same time, but recording will use only one of them - the last 
> changed control wins. Moreover the left/right selection doesn't make any 
> difference, the code ignores it.

For saa7133/35/31e that was exactly Hartmut's plan. You don't have to
care to select the right inputs anymore. And with Ricardo exporting the
mute symbol from saa7134-tvaudio to saa7134-alsa, you don't have to care
for this either. (mythtv v4l1, except you do ambiguous stuff from user
side)

> Here comes also the frequency problem of SAA7134. If the user starts with 
> LINE1 and 48kHz and tries to switch to TV, the frequency will change to 32kHz 
> (DemDec mode) - the application will not know, I guess there will be some 
> buffer underruns.

Anyway, to switch to 32kHz for TV is right currently, but it doesn't
stop since years, that it is claimed, more is possible. No proof for any
standard yet and A2 and NICAM won't do at least.

> Note that any change of capture source control is overriden by the call to 
> snd_card_saa7134_capture_prepare (called by ALSA before the capture source is 
> opened) that takes the current input as set by saa7134_tvaudio_setinput 
> (called by v4l interface). I think this is actually expected behaviour and 
> can stay as it is now.

There are also cards with mpeg encoders and you can't just mute or do
what you want.

> 
> The easiest solution would be to throw away the capture source control and let 
> the capture source initialization on the snd_card_saa7134_capture_prepare 
> method (the source would be controlled by saa7134_tvaudio_setinput only - 
> through v4l interface only), or limit the frequency to 32kHz only so that any 
> source can be freely selected on any SAA713x hardware.

I'm not sure, in case we are talking about all sources, talk about the
same things already. Also, you might have noticed or not, there are also
mute calls depending on having a signal.

> Any other ideas, comments, corrections (I could be wrong in what I wrote, I'm 
> not the SAA713x programming expert!), suggestions?
> 
> Cheers,
> Oldrich.

Given the problems we had previously, I'm not right sure, if we really
have some now at all, hm, 02:52 am ;)

But you have at least some reaction ...

Cheers,
Hermann




