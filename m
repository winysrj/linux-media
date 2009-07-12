Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:59256 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbZGLVhh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2009 17:37:37 -0400
From: =?utf-8?q?Old=C5=99ich_Jedli=C4=8Dka?= <oldium.pro@seznam.cz>
To: LMML <linux-media@vger.kernel.org>,
	hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [RFC] SAA713x setting audio capture frequency (ALSA)
Date: Sun, 12 Jul 2009 19:48:39 +0200
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200907121948.39944.oldium.pro@seznam.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I had a look at the audio code in saa7134 directory once again 
(saa7134-alsa.c and saa7134-tvaudio.c). It has one major problem - the 
frequency for SAA7134 isn't set during startup, only during the capture 
source change (that is another problem). But let's start from beginning, 
please comment what you find interresting, I will create a patch after the 
discussion for another discussion :-).

1. SAA7133/SAA7135

SAA7133/SAA7135 always use DDEP (DemDec Easy Programming) mode which runs 
on 32kHz only. There is no need to change the frequency at all, so 
everything works except that the info coming from ALSA reports both 
frequencies 32kHz and 48kHz as available for recording. This can be easily 
changed in snd_card_saa7134_hw_params to report only 32kHz for 
SAA7133/SAA7135.

2. SAA7134

SAA7134 is special in the way it programs the frequency by hand. It uses 32kHz 
DemDec mode for TV (DemDec works only in 32kHz mode), 32kHz for radio (this 
is locked), and 32kHz/48kHz for S-Video and Composite inputs. ALSA again 
reports both frequencies 32kHz and 48kHz as available for recording - this 
can be changed accordingly.

The problem is that the frequency is never changed during inicialization like 
it was in OSS code (see 2.6.24 kernel, saa7134_oss_init1 calls mixer_recsrc). 
I think that this responsibility is now on the 
snd_card_saa7134_capture_prepare method - it should set the frequency in 
SAA7134_SIF_SAMPLE_FREQ register correctly, possibly also 
SAA7134_ANALOG_IO_SELECT. Note that the tvaudio's mute_input_7134 sets the 
frequency to 32kHz, this can be thrown away I think.

I tried to set SAA7134_SIF_SAMPLE_FREQ in snd_card_saa7134_capture_prepare  
and the capturing works correctly with 48kHz from my digital camera (Composite 
input).

3. Changing the capture source

The ALSA interface has three capture sources, all of them have left and right 
channels (boolean values) - LINE1, LINE2 and TV. The user can select any 
source - ALSA calls snd_saa7134_capsrc_put.

The ALSA controls are not updated, so it is possible to select both LINE1 and 
LINE2 at the same time, but recording will use only one of them - the last 
changed control wins. Moreover the left/right selection doesn't make any 
difference, the code ignores it.

Here comes also the frequency problem of SAA7134. If the user starts with 
LINE1 and 48kHz and tries to switch to TV, the frequency will change to 32kHz 
(DemDec mode) - the application will not know, I guess there will be some 
buffer underruns.

Note that any change of capture source control is overriden by the call to 
snd_card_saa7134_capture_prepare (called by ALSA before the capture source is 
opened) that takes the current input as set by saa7134_tvaudio_setinput 
(called by v4l interface). I think this is actually expected behaviour and 
can stay as it is now.

---

The easiest solution would be to throw away the capture source control and let 
the capture source initialization on the snd_card_saa7134_capture_prepare 
method (the source would be controlled by saa7134_tvaudio_setinput only - 
through v4l interface only), or limit the frequency to 32kHz only so that any 
source can be freely selected on any SAA713x hardware.

Any other ideas, comments, corrections (I could be wrong in what I wrote, I'm 
not the SAA713x programming expert!), suggestions?

Cheers,
Oldrich.
