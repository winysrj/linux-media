Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n67.bullet.mail.sp1.yahoo.com ([98.136.44.47])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KX8sH-0001r0-UL
	for linux-dvb@linuxtv.org; Sun, 24 Aug 2008 08:14:56 +0200
Date: Sat, 23 Aug 2008 23:07:36 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org, Beth <beth.null@gmail.com>
In-Reply-To: <7641eb8f0808231328s3b265741p4e5d57e7b6ca8c8c@mail.gmail.com>
MIME-Version: 1.0
Message-ID: <826551.18619.qm@web46111.mail.sp1.yahoo.com>
Subject: Re: [linux-dvb] Skystar HD2 (device don't stream data).
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

I'm going to reply in two parts, eventually...



Hola, Beth!

I am going to go through one of your stderr files, and point out
what is normal, and what are definite problems, and what might be
problems.

That will help an Expert to step in and fix the problems that may
be in the driver...


First of all, the problems I am seeing *could* be from a less-than-
perfect satellite installation, or could be driver problems.  It
may be that your signal from particular transponders is not quite
strong enough for reliable tuning.  But from this distance, I 
cannot say anything.  If you are able to tune into the problem
channels without problems and a strong signal on a regular
satellite receiver, or with your card under 'Doze, then your
dish installation may be okay.


Anyway, here are parts of your scan-0-stderr file.

First scanned transponder:
   Tune to frequency 12551500
   DiSEqC: switch pos 0, 13V, hiband (index 2)
   DVB-S IF freq is 1951500
   >>> tuning status == 0x1e
Perfect!  Locks onto the signal instantly.
   PAT
   PMT 0x0024 for service 0x2f94
[snip]
   PMT 0x002a for service 0x000c
   SDT (actual TS)
   0x0000 0x000c: pmt_pid 0x002a SES ASTRA -- ASTRA SDT (running)
[snip]
   0x0000 0x2fa4: pmt_pid 0x0033 GIST -- PVR service (running)
   NIT (actual TS)
   Network Name 'ASTRA'
   NIT (actual TS)

This is all normal, and shows no problems from this transponder.
It is just debugging output to show correct operation.

Next,
   Tune to frequency 12070500
   DiSEqC: switch pos 0, 18V, hiband (index 3)
   DVB-S IF freq is 1470500
   >>> tuning status == 0x00
   >>> tuning status == 0x00
   >>> tuning status == 0x00
[big snip]
This is not so good.  And as you see below, this is bad...
   >>> tuning status == 0x00
   WARNING: >>> tuning failed!!!
   Tune to frequency 12070500
   DiSEqC: switch pos 0, 18V, hiband (index 3)
   DVB-S IF freq is 1470500
   >>> tuning status == 0x00
   >>> tuning status == 0x00
`scan' makes two attempts to lock onto a transponder if it fails.
This is a german Premiere transponder...
[another big snip]
   >>> tuning status == 0x00
   WARNING: >>> tuning failed!!!


You are unable to lock onto this transponder.  This could be, as I
mention, a problem with your dish installation, or it could be a
problem in the Linux driver for your card.


I am disturbed by the number of times the `tuning status 0x00' line
repeats, because with my much-older `scan' I only see ten lines of
failures, at one or two per second.  Perhaps your `scan' is printing
many more lines per second, or perhaps the timeout is much longer
(a minute?) before your scan decides it will not be able to receive
a signal.

The other thing to concern me, is that on this and other active
transponders where I see this, the status is `0x00' rather than
something else, meaning that the driver is seeing not a weak signal,
but no signal.

The status I see from my `scan' (which is different from yours, and
very hacked) looks like
     Scanning 10714250     h       22000   # ANALOG        KiKa + ...
[...]
   >>> tune to: 10714:h:1:22000
[...]
   >>> tuning status == 0x05
   >>> tuning status == 0x05
   >>> tuning status == 0x05
   >>> tuning status == 0x01
when I'm trying to tune an analogue transponder, while for a DVB-S2
transponder that my tuner does not support, I see
     Scanning 11914500     h       27500   ##      DVB-S2 QPSK (0x05)
[...]
   >>> tune to: 11914:h:1:27500
[...]
   >>> tuning status == 0x07
   >>> tuning status == 0x03
   >>> tuning status == 0x03
   >>> tuning status == 0x07



Continuing on in your scan...
   Tune to frequency 12031500
[snip]
   >>> tuning status == 0x00
   >>> tuning status == 0x00
   >>> tuning status == 0x00
   >>> tuning status == 0x00
   >>> tuning status == 0x1e

You do eventually lock onto this Premiere transponder after the 20
status==0x00 lines I deleted.

   Network Name 'BetaDigital'
   ERROR: S2_satellite_delivery_system_descriptor not parsed

I think you can ignore this error.


Now here are some more problems:

   Tune to frequency 12480000
[...]
   PAT
   PMT 0x0071 for service 0x0301
   NIT (actual TS)
   Network Name 'BetaDigital'
[...]
   SDT (actual TS)
   0x0021 0x004c: pmt_pid 0x0000 BetaDigital -- equi8 (running)
   0x0021 0x004d: pmt_pid 0x0000 BetaDigital -- . (not running)
   0x0021 0x0020: pmt_pid 0x0000 PREMIERE -- Sonnenklar TV (running)
[followed by lots of...]
   WARNING: filter timeout pid 0x0089
   WARNING: filter timeout pid 0x0088
   WARNING: filter timeout pid 0x0083
   WARNING: filter timeout pid 0x0080
   WARNING: filter timeout pid 0x0087

and so on.

First, there is only a single PMT, which also happens to be the
first seen in your previous successfully-tuned transponder:

   DiSEqC: switch pos 0, 18V, hiband (index 3)
   DVB-S IF freq is 1548500
   >>> tuning status == 0x1e
   PAT
   PMT 0x0071 for service 0x0301
   PMT 0x006e for service 0x00a1


Second, here you see in your stdout file, that the PIDs for these
channels are all 0:0...

   equi8:12480:v:0:27500:0:0:76:0
   .:12480:v:0:27500:0:0:77:0
   Sonnenklar TV:12480:v:0:27500:0:0:32:0
   XXHOME:12480:v:0:27500:0:0:898:0


And third, in the lines like
   0x0021 0x0020: pmt_pid 0x0000 PREMIERE -- Sonnenklar TV (running)
one can see that the PMT PID ^^^ is not non-zero, which is wrong.


So here is a problem.



Then you see nearly the same thing with the Pro7Sat1 transponder:

   >>> tuning status == 0x1e
   PAT
   SDT (actual TS)
   0x0453 0x445c: pmt_pid 0x0000 ProSiebenSat.1 -- SAT.1 (running)
   0x0453 0x445d: pmt_pid 0x0000 ProSiebenSat.1 -- ProSieben (running)
   0x0453 0x445e: pmt_pid 0x0000 ProSiebenSat.1 -- kabel eins (running)
   0x0453 0x445f: pmt_pid 0x0000 ProSiebenSat.1 -- N24 (running)
   0x0453 0x4460: pmt_pid 0x0000 ProSiebenSat.1 -- 9Live (running)
   0x0453 0x4461: pmt_pid 0x0000 ProSiebenSat.1 -- Sat.1 Comedy (running, scrambled)
   0x0453 0x4462: pmt_pid 0x0000 ProSiebenSat.1 -- kabel eins classics (running, scrambled)
   NIT (actual TS)
   Network Name 'ASTRA'
   NIT (actual TS)
   WARNING: filter timeout pid 0x006c
   WARNING: filter timeout pid 0x0067
   WARNING: filter timeout pid 0x0064
   WARNING: filter timeout pid 0x0062
   WARNING: filter timeout pid 0x0063
   WARNING: filter timeout pid 0x006a
   WARNING: filter timeout pid 0x0061
   WARNING: filter timeout pid 0x0069
   WARNING: filter timeout pid 0x0066
   WARNING: filter timeout pid 0x006b
   WARNING: filter timeout pid 0x0065
   WARNING: filter timeout pid 0x0068
   WARNING: filter timeout pid 0x006d


This almost looks similar to what I see with one of my cards, other
than that I get the `ghost' leftovers from the previous transponder
services in my stdout, which you are missing...

With the next transponder (Pro7Sat1 CH+AT regional), everything is
back to normal.


Then...

   Tune to frequency 11836500
   DiSEqC: switch pos 0, 18V, hiband (index 3)
   DVB-S IF freq is 1236500
   >>> tuning status == 0x00
[...]
   >>> tuning status == 0x00
   WARNING: >>> tuning failed!!!

Rather strange; this is the german ARD transponder, which never shows
results in any of your scans.  You did receive the ZDF transponder,
though it took some time.  Do you know if you should be in reach of
the ARD transponder, which I would expect should cover you?

Can you receive ARD, Bayerisches FS, hessen, either with 'Doze, or
with a regular satellite receiver (these are all free-to-air, unlike
most Premiere channels)?

As I noted at the start, if your satellite dish installation is less
than perfect, you may have problems with certain transponders but not
with others.  Also, a weaker signal will result in transmission errors
that will show up as mangled PIDs, as I saw several unexpected PIDs
when you posted the `tspids' summary of your ten-hour recording.


   Tune to frequency 1574250
   DiSEqC: switch pos 0, 18V, loband (index 1)
   DVB-S IF freq is 8175750

You can ignore this, it seems like SES-Astra is still listing some
wrong frequencies that will never tune directly...



Something that may be interesting, or not, is that I was thinking
I could locate those services which receive incorrect 0:0 PIDs by
scanning for 0x0000 in the stderr file, but in this case:

   Tune to frequency 11597000
   DiSEqC: switch pos 0, 13V, loband (index 0)
   DVB-S IF freq is 1847000
   >>> tuning status == 0x1e
   SDT (actual TS)
   0x0402 0x2724: pmt_pid 0x0000 Deutsche Telekom AG -- DW-TV (running)
   0x0402 0x272e: pmt_pid 0x0000 CNBC -- CNBC Europe (running)
   0x0402 0x2742: pmt_pid 0x0000 BBC -- BBC World (running)
   0x0402 0x2773: pmt_pid 0x0000 ASTRA -- Data System (running)
   0x0402 0x7023: pmt_pid 0x0000 BT -- Sky News (running)
   0x0402 0x274c: pmt_pid 0x0000 TV5MONDE -- TV5MONDE EUROPE (running)
   0x0402 0x274e: pmt_pid 0x0000 GlobeCast -- Best of shopping (running)
   0x0402 0x274f: pmt_pid 0x0000 Globecast -- M6 BOUTIQUE LA CHAINE (running)
   PAT
   PMT 0x0742 for service 0x2742
   PMT 0x072e for service 0x272e
   PMT 0x0724 for service 0x2724
   PMT 0x044c for service 0x274f
   PMT 0x00cd for service 0x274e
   PMT 0x02cf for service 0x274c
   PMT 0x1023 for service 0x7023
   PMT 0x0773 for service 0x2773
   NIT (actual TS)
   Network Name 'ASTRA'
   NIT (actual TS)

BBC World at least, gets the proper PIDs also when the PAT is parsed
after printing the SDT parsing.




Now to a summary:

You never seem to receive anything when trying to scan certain
transponders, such as the ARD transponder at 11836.

It seems to take some time before other transponders lock.

Both you and I experience the same problems with leftover PMT
data, or failure to scan new data.


This can be readily found, when knowing what to look for, in your
stderr 0 file, but as a pointer, one should compare the found PMT
PIDs at 11097, with the WARNINGs in the following transponder at
10788



Actually, now that I look more closely, I see the same thing in
your results from the ARD radio transponder that I see myself:

Note the service IDs found in the transponder immediately above
at 11479, just before 12265.  For example:

   CANAL EVENEMENT:11479:v:0:22000:160:80:6401:0
   [1907]:11479:v:0:22000:166:104:6407:0

Now note the service IDs of the below unnamed channels which are not
present in the list of channels on the ARD radio transponder, but
which show up here:

   [191e]:11479:v:0:22000:2047:0:6430:0
   [1901]:12265:h:0:27500:0:0:6401:0
   [1907]:12265:h:0:27500:0:0:6407:0
   [1921]:12265:h:0:27500:0:0:6433:0
   [1920]:12265:h:0:27500:0:0:6432:0
   [1903]:12265:h:0:27500:0:0:6403:0
   [193c]:12265:h:0:27500:0:0:6460:0
   [1932]:12265:h:0:27500:0:0:6450:0
   [191e]:12265:h:0:27500:0:0:6430:0
   [191f]:12265:h:0:27500:0:0:6431:0
   [1963]:12265:h:0:27500:0:0:6499:0
   [1905]:12265:h:0:27500:0:0:6405:0
   [1904]:12265:h:0:27500:0:0:6404:0
   [1902]:12265:h:0:27500:0:0:6402:0
   MDR FIGARO:12265:h:0:27500:0:0:28431:0

And of course, the audio ID for all the following radio channels
is :0 which is wrong.

This is repeated in your scans 7 and 8; all the others give the
correct values.



I honestly don't know if this is a problem in the driver for the
card, or something in `scan'.  I see these problems myself with
a different card, with the same `scan' that works fine with two
other cards on a different machine (much older kernel).


Input from an Expert is welcome, before I decide to try to add
some debugging to `scan', which means trying to understand how
it works, which means doing something vaguely resembling `work'.
Though I'll probably wait a day or two to allow time to think
about what I want to try to do...


thanks
barry bouwmsa


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
