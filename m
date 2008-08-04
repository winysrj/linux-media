Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1KPp9R-0005d1-3p
	for linux-dvb@linuxtv.org; Mon, 04 Aug 2008 03:46:24 +0200
From: Andy Walls <awalls@radix.net>
To: Brian Steele <steele.brian@gmail.com>
In-Reply-To: <5f8558830808031428u3c9a8191tcd1705b27087f992@mail.gmail.com>
References: <5f8558830807291934i34579ed6s8de1dd8240d2f93e@mail.gmail.com>
	<1217728894.5348.72.camel@morgan.walls.org>
	<5f8558830808031049p1a714907y94e9d2e98e30ba8b@mail.gmail.com>
	<1217791214.2690.31.camel@morgan.walls.org>
	<5f8558830808031428u3c9a8191tcd1705b27087f992@mail.gmail.com>
Date: Sun, 03 Aug 2008 21:47:06 -0400
Message-Id: <1217814427.23133.24.camel@palomino.walls.org>
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

On Sun, 2008-08-03 at 14:28 -0700, Brian Steele wrote:
> On Sun, Aug 3, 2008 at 12:20 PM, Andy Walls <awalls@radix.net> wrote:

> > So we'll go with the tried and true axiom of "the bug was caused by the
> > last thing I changed".
> >
> > On Jul 23 & 25 I made some changes to the cx18-av-audio.c file to fix
> > the 32 kHz sample rate, lock the Video PLL and Audio PLL together, and
> > fine tune the video sample rate PLL values.
> >
> > I've just put in a small change at
> >
> > http://linuxtv.org/hg/~awalls/v4l-dvb
> >
> > to back out the part of the change that locked the video PLL & the audio
> > PLL together for both tuner and line in audio.
> >
> > See if that change makes things work for you.
> 
> Unfortunately it doesn't.  This is the output of v4l2-ctl --log-status
> with your update after make, make install, make unload, modprobe cx18,
> tuning a channel, and doing three test captures.
> 



Well, let's collect some debug data about how the tuner is getting set
up and what happens on channel change.  (Because it's either tuner
commands not working, or cx18-av setup or register changes not working.)

Add lines like these to /etc/modprobe.conf

options tuner show_i2c=1 debug=2
options tuner-simple debug=1
options tda8290 debug=1
options tda9887 debug=2

   (and/or debug options for whatever other tuner modules your
    system loads for the cx18)

Then do

# modprobe -r cx18 tda9887 tda8290 tuner-simple tuner
# modprobe cx18 debug=83      (<---- warn, info, i2c, ioctl)

I'd be interested in all the messages when the cx18 module initializes
(not just the ones prefixed with "cx18") and the messages that occur
when you change channels.


Depending on what shows up in the debug for the tuner, I may ask for
more information about the state of particular cx23418 registers.
Please compile v4l2-dbg found under v4l-dvb/v4l2-apps/utils, if you have
a chance.

> > BTW, Did the cx18 driver ever work properly for tuner audio for you
> > before?
> >
> 
> I bought the card on July 27 from a friend who has had it sitting in
> his closet for a year and a half.  This is the first time anybody has
> ever installed it in a system and tried to get it working.  I'm
> starting to wonder if maybe I have a defective card.  I suppose I
> could try installing it in a windows system and see if I can get
> audio.

I got your message about the card working in a Windows machine.  So we
know you don't have a bad card.

Regards.
Andy


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
