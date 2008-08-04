Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-17.arcor-online.net ([151.189.21.57])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1KQ4Zg-0000s7-I1
	for linux-dvb@linuxtv.org; Mon, 04 Aug 2008 20:14:30 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Andy Walls <awalls@radix.net>
In-Reply-To: <1217817352.23133.64.camel@palomino.walls.org>
References: <5f8558830807291934i34579ed6s8de1dd8240d2f93e@mail.gmail.com>
	<1217728894.5348.72.camel@morgan.walls.org>
	<5f8558830808031049p1a714907y94e9d2e98e30ba8b@mail.gmail.com>
	<1217791214.2690.31.camel@morgan.walls.org>
	<1217810697.2673.8.camel@pc10.localdom.local>
	<1217817352.23133.64.camel@palomino.walls.org>
Date: Mon, 04 Aug 2008 20:07:43 +0200
Message-Id: <1217873263.2671.27.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1600 - No audio
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


Am Sonntag, den 03.08.2008, 22:35 -0400 schrieb Andy Walls:
> On Mon, 2008-08-04 at 02:44 +0200, hermann pitton wrote:
> > Hi Andy,
> > 
> > Am Sonntag, den 03.08.2008, 15:20 -0400 schrieb Andy Walls:
> > > On Sun, 2008-08-03 at 10:49 -0700, Brian Steele wrote:
> 
> > > So we'll go with the tried and true axiom of "the bug was caused by the
> > > last thing I changed".
> > > 
> > > On Jul 23 & 25 I made some changes to the cx18-av-audio.c file to fix
> > > the 32 kHz sample rate, lock the Video PLL and Audio PLL together, and
> > > fine tune the video sample rate PLL values.
> > > 
> > > I've just put in a small change at 
> > > 
> > > http://linuxtv.org/hg/~awalls/v4l-dvb
> > > 
> > > to back out the part of the change that locked the video PLL & the audio
> > > PLL together for both tuner and line in audio.
> > > 
> > > See if that change makes things work for you.
> > > 
> > > 
> > > BTW, Did the cx18 driver ever work properly for tuner audio for you
> > > before?
> > > 
> > > > > (Also note that the first analog capture after modprobe cx18 will not
> 
> > without looking up any of your code, kick my ass if needed,
> > but this should be all still on some tuner 57 ?
> 
> I would never kick the ass of anyone whom is offering help or advice. :)
> 
> 
> I have two HVR-1600's: one with radio and one without.  I can't check
> the one without radio right now (that computer is down for other
> experiments).
> 
> For my HVR-1600 without radio, IIRC it has a TCL M2523_5N_E just like
> Brian's HVR-1600.  I remember the driver initialization logging saying
> that it would treat it like a TCL_2002 (or something like that).  I know
> that it worked for me just a few days ago.
> 
> Looking at linux/include/media/tuner.h, the only TCL 2002 tuners are
> type numbers 50 or 55.  Type 55 is for a PAL tuner, which an HVR-1600
> should not have, AFAIK.
> 
> 
> > All have been around I can think about, but it still has no tda988x
> > config something in tuner-types.c, and you need it for sure, maybe you
> > have it in the cards entry? All other will fail.
> 
> tveeprom.c has the answer.
> 
> $ cd v4l-dvb/linux/drivers/media/video
> $ grep 2523 tveeprom.c
>         { TUNER_TCL_2002N,              "TCL M2523_5N_E"},   <-------
>         { TUNER_TCL_2002MB,             "TCL M2523_3DB_E"},
>         { TUNER_ABSENT,                 "TCL M2523_3DI_E"},
>         { TUNER_ABSENT,                 "TCL M2523_5NH_E"},
>         { TUNER_ABSENT,                 "TCL M2523_3DBH_E"},
>         { TUNER_ABSENT,                 "TCL M2523_3DIH_E"},
> 
> $ cd v4l-dvb/linux/include/media
> $ egrep '(2002)|(2523)' tuner.h
> #define TUNER_TCL_2002N                 50     <--------------
> #define TUNER_TCL_2002MB                55      /* Hauppauge PVR-150 PAL */
> 
> 
> 
> I'm not quite sure I understand everything you were trying to say, but I
> agree with your line of thinking.  It's most likely a tuner problem.
> 
> Does a TCL M2523_5N_E have a TDA988x?  I know the TDA9887 can
> demodulate FM radio. Brian's HVR-1600 doesn't have FM radio according to
> tveeeprom, so are you thinking a TDA988[56] is in the TCL M2523 5N E? 

No, therefore the warning that I did not look any closer yet.

http://www.tclrf.com/English/html/enewsproopen.asp?proname=102&url=product

> "struct tuner_params tuner_tcl_2002n_params[]" in
> v4l-dvb/linux/drivers/media/common/tuners/tuner-types.c
> doesn't have ".has_tda9887 = 1" set.

I assumed a MK4 tuner=57 on it like it is also on PVR-150 and PVR-500.
They also have no radio, but without tda9887, includes tda9885 and
tda9886, you won't get anything useful out of them.

Then exactly the above missing .has_tda9887 = 1 for _that one_ could
cause such problems.

> 
> Thanks.
> 
> If you have any other thoughts/idea, please let me know.

It just came in mind it might be related to the missing tda9887 for
tuner=57, but you obviously deal with other tuners.

However, the missing tda9887 for the FQ1236A seems to be at least a
inconsistency in tuner-types.c for me.

>From logs of the PVR-500 and PVR-150 one can see they need the tda9887
module and it is at 0x43/0x86.

Cheers,
Hermann





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
