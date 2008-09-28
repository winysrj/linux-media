Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1Kk38G-0007PW-Q0
	for linux-dvb@linuxtv.org; Sun, 28 Sep 2008 22:44:46 +0200
Received: by ey-out-2122.google.com with SMTP id 25so452314eya.17
	for <linux-dvb@linuxtv.org>; Sun, 28 Sep 2008 13:44:41 -0700 (PDT)
Date: Sun, 28 Sep 2008 22:44:20 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Malte Forkel <malte.forkel@berlin.de>
In-Reply-To: <gbofuu$gds$1@ger.gmane.org>
Message-ID: <alpine.DEB.2.00.0809282207220.6275@ybpnyubfg.ybpnyqbznva>
References: <gbofuu$gds$1@ger.gmane.org>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Still problems with ttusb_dec / DEC3000-s
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

On Sun, 28 Sep 2008, Malte Forkel wrote:

> I'm trying to get my Hauppauge DEC3000-s working. And I don't seem to be the only one. For an earlier, more accurate account see e.g. http://www.linuxtv.org/pipermail/linux-dvb/2006-April/009259.html. 

Please, wrap your lines at around 70 characters or less, or
fix your mailer to do that -- in my quoting of you here, I see
> I'm trying to get my Hauppauge DEC3000-s working. And I don't seem to be the $
without re-formatting, and that makes it hard for me to address
what you write if I've forgotten what it was...


> errors. But I still can't scan:
> # scan -x0 -t1 /usr/share/dvb/dvb-s/Astra-19.2E | tee channels.conf
> scanning /usr/share/dvb/dvb-s/Astra-19.2E
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
> initial transponder 12551500 V 22000000 5
> >>> tune to: 12551:v:0:22000

> Is anybody successfully using a DEC3000-s or can give some advice?

Yes, I use the DEC3000-s with ``success'', for some values
of ``success''...

You are probably running into the problem I had, that it does
not appear to generate the 22kHz bandswitch tone normally
needed to tune in what are essentially all interesting
high-band transponders.

I used to feed it with the loop-through output of a receiver
tuned to a horizontal+hi-band transponder to enable me to
receive what were then all german channels of interest to me.

I'm now connected via a Multischalter; this somehow permits
me to tune all bands of four sat positions successfully,
without help from other hardware.

If you are experiencing this problem, then you can only
tune in the transponders below 11700MHz of any satellite
without help -- and the starting frequency for the NIT
data you quoted is not in this range.

You can hand-craft an initial data file with, say, the ARD
transponder at 10744MHz at 19E2, and see if that gets you
a few channels (largely spanish).

If you get this, then your device is ``working'', and I
would have to ask, for what purpose do you intend to use
it (which channels do you want to watch/record)?

In particular, the USB1 bandwidth limitation prevents me
from using it for other than radio, except for a handful
of channels (largely commercial/private) with limited
bandwidth that don't get corrupted by packet-loss -- the
only german public-service broadcasts not affected are
Bayern-alpha (you can not hear the AC3 5.1 channel such
as on the jazz broadcast which just finished, but that is
a different problem) and Suedwest-Saarland, both of which
for me require either my multiswitch, or the loop-through
hack.


thanks,
barry bouwsma

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
