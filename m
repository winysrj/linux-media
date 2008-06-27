Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n78.bullet.mail.sp1.yahoo.com ([98.136.44.42])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KCEqm-0007gH-EF
	for linux-dvb@linuxtv.org; Fri, 27 Jun 2008 16:22:58 +0200
Date: Fri, 27 Jun 2008 07:19:34 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <153722.52467.qm@web46116.mail.sp1.yahoo.com>
Subject: [linux-dvb] UMT-010-like USB DVB-T receivers, that aren't
Reply-To: free_beer_for_all@yahoo.com
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

Serwoas!

Sorry in advance for the length of this message.

I've seen messages from the past years in the archive referring
to the UMT-010 code that seems to not work with different
devices.  I've got one of them, that's partly supported but
doesn't work.

The particular device was a cheap DVB-T stick for some EUR30
from a year or two ago, from the german discounter Plus (not
an advert, as I'm positive since appearing once, it won't
reappear, but just for additional info).  There's no obvious
product name on the package, other than `ciron electronics GmbH'
and a cryptic `SULPoG' or something.

The supplied CD includes a firmware which I've been able to
extract (don't remember how now), which, if used, gives a
product ID of 0x0025; if I plug in the device with the Linux-
supplied firmware, it gives the expected PID 0x0015.

Normally tuning fails.  No real surprise, in looking at the
'doze 'drivers and reading archived messages, there are apparently
a whole heap of different tuner chips used.

The MT352 demodulator is successfully identified.

FWIW, I hacked some dibXXX code, which includes code for a
remote control receiver (this device includes such), and while
it doesn't work (no surprise), it does claim to attach the
infrared remote receiver.  I haven't checked further to see
if I can actually do anything with that, since a quick look
at that code made me think it succeeds, regardless.

One more note, and I'd have to dig out my hacks, is that for
quite some time, since kernel 2.6.1x-something, one can connect
a device like this, but at least in my case (fails to attach
a usable frontend and all), in all the kernels after that point
I tried, disconnecting the device results in a panic, which
makes it impossible to reconnect the device and try a different
hack without rebooting and thus my enthusiasm to hack has been
redirected elsewhere.

However I noted there's a patch a few days ago for the umt010
codes, though I haven't tried it or revisited my problems to
see if it might be the fix I'm needing here.


The actual tuner in the stick is the MT2060F.  I'm guessing I
need to do something rather different than just try different
PLL configs, which I did try, and of course, didn't help.

The tuner in my stick is definitively not on the expected 0x61,
but at 0x60, as at least one other person with this flavour
of stick experienced.  I also see that in the 'doze files.

Some other dvb-usb devices expect to see a MT2060 as well;
a half-arsed attempt to rip out those codes for use in the
umt010 failed as expected, and I didn't proceed further.


Now, I'm just *full* of questions.

How much difference is it likely to make to use the Linux
firmware with PID 0x0015, opposed to the supplied 0x0025
firmware?  I think I recall an earlier message that there
were slight functional differences (full-TS vs. USB 1.x,
or something), but since I'm unclear on just what functions
are provided overall by the firmware, is it possible that the
MT2060 tuner in my stick would force me to use different
firmware?

FWIW, on the circuit board, I can see `VT6330C1 VER:1.0' if
that would mean anything.

If there might be an additional PLL chip, that might be what
I see mounted on the bottom of the board, next to the MT2060,
but which I can't make out any writing without removing the
bottom (the sorta-clear top was relatively easy to remove).
It's within the mostly-solid-trace-surface of the board that
I expect delimits the RF-region antenna+tuner.


If it would help if I were to quote further parts of the supplied
'doze files, I'd be happy to dig out something.  I haven't had
the chance to connect the stick to a friend's Windows machine and
verify its operation.


Otherwise, gawrsh, I'd jes' *luv* to get this thing working (bought
two) as well...

merci,
barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
