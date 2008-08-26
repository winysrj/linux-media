Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <beth.null@gmail.com>) id 1KY7BI-0002J5-Et
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 00:38:34 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1372551fga.25
	for <linux-dvb@linuxtv.org>; Tue, 26 Aug 2008 15:38:28 -0700 (PDT)
Message-ID: <7641eb8f0808261538i569a9cc5o1f7a6a106f0b04c8@mail.gmail.com>
Date: Wed, 27 Aug 2008 00:38:28 +0200
From: Beth <beth.null@gmail.com>
To: free_beer_for_all@yahoo.com
In-Reply-To: <826551.18619.qm@web46111.mail.sp1.yahoo.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <7641eb8f0808231328s3b265741p4e5d57e7b6ca8c8c@mail.gmail.com>
	<826551.18619.qm@web46111.mail.sp1.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Skystar HD2 (device don't stream data).
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

Hi barry, sorry for the delay, I have two very busy days ...

First of all, what an awesome work. ;)

>
> First of all, the problems I am seeing *could* be from a less-than-
> perfect satellite installation, or could be driver problems.  It
> may be that your signal from particular transponders is not quite
> strong enough for reliable tuning.  But from this distance, I
> cannot say anything.  If you are able to tune into the problem
> channels without problems and a strong signal on a regular
> satellite receiver, or with your card under 'Doze, then your
> dish installation may be okay.

I think I have a good installation, as in other operating systems I
didn't have problems, (now I am not at home so I can't check the
signal quality, but as soon as I back to home I will check it.

>
> Anyway, here are parts of your scan-0-stderr file.
>
> First scanned transponder:
>   Tune to frequency 12551500
>   DiSEqC: switch pos 0, 13V, hiband (index 2)
>   DVB-S IF freq is 1951500
>   >>> tuning status == 0x1e
> Perfect!  Locks onto the signal instantly.
>   PAT
>   PMT 0x0024 for service 0x2f94
> [snip]
>   PMT 0x002a for service 0x000c
>   SDT (actual TS)
>   0x0000 0x000c: pmt_pid 0x002a SES ASTRA -- ASTRA SDT (running)
> [snip]
>   0x0000 0x2fa4: pmt_pid 0x0033 GIST -- PVR service (running)
>   NIT (actual TS)
>   Network Name 'ASTRA'
>   NIT (actual TS)
>
> This is all normal, and shows no problems from this transponder.
> It is just debugging output to show correct operation.
>
> Next,
>   Tune to frequency 12070500
>   DiSEqC: switch pos 0, 18V, hiband (index 3)
>   DVB-S IF freq is 1470500
>   >>> tuning status == 0x00
>   >>> tuning status == 0x00
>   >>> tuning status == 0x00
> [big snip]
> This is not so good.  And as you see below, this is bad...
>   >>> tuning status == 0x00
>   WARNING: >>> tuning failed!!!
>   Tune to frequency 12070500
>   DiSEqC: switch pos 0, 18V, hiband (index 3)
>   DVB-S IF freq is 1470500
>   >>> tuning status == 0x00
>   >>> tuning status == 0x00
> `scan' makes two attempts to lock onto a transponder if it fails.
> This is a german Premiere transponder...
> [another big snip]
>   >>> tuning status == 0x00
>   WARNING: >>> tuning failed!!!
>
>
> You are unable to lock onto this transponder.  This could be, as I
> mention, a problem with your dish installation, or it could be a
> problem in the Linux driver for your card.
>

Aha, I must check it on XP too, so we will get out of doubts.

>
> I am disturbed by the number of times the `tuning status 0x00' line
> repeats, because with my much-older `scan' I only see ten lines of
> failures, at one or two per second.  Perhaps your `scan' is printing
> many more lines per second, or perhaps the timeout is much longer
> (a minute?) before your scan decides it will not be able to receive
> a signal.
>
> The other thing to concern me, is that on this and other active
> transponders where I see this, the status is `0x00' rather than
> something else, meaning that the driver is seeing not a weak signal,
> but no signal.
>

Yes it seems to be strange but I must recheck it on XP and other scannings.

>
> Now here are some more problems:
>
>   Tune to frequency 12480000
> [...]
>   PAT
>   PMT 0x0071 for service 0x0301
>   NIT (actual TS)
>   Network Name 'BetaDigital'
> [...]
>   SDT (actual TS)
>   0x0021 0x004c: pmt_pid 0x0000 BetaDigital -- equi8 (running)
>   0x0021 0x004d: pmt_pid 0x0000 BetaDigital -- . (not running)
>   0x0021 0x0020: pmt_pid 0x0000 PREMIERE -- Sonnenklar TV (running)
> [followed by lots of...]
>   WARNING: filter timeout pid 0x0089
>   WARNING: filter timeout pid 0x0088
>   WARNING: filter timeout pid 0x0083
>   WARNING: filter timeout pid 0x0080
>   WARNING: filter timeout pid 0x0087
>
> and so on.
>
> First, there is only a single PMT, which also happens to be the
> first seen in your previous successfully-tuned transponder:
>
>   DiSEqC: switch pos 0, 18V, hiband (index 3)
>   DVB-S IF freq is 1548500
>   >>> tuning status == 0x1e
>   PAT
>   PMT 0x0071 for service 0x0301
>   PMT 0x006e for service 0x00a1
>
>
> Second, here you see in your stdout file, that the PIDs for these
> channels are all 0:0...
>
>   equi8:12480:v:0:27500:0:0:76:0
>   .:12480:v:0:27500:0:0:77:0
>   Sonnenklar TV:12480:v:0:27500:0:0:32:0
>   XXHOME:12480:v:0:27500:0:0:898:0
>
>
> And third, in the lines like
>   0x0021 0x0020: pmt_pid 0x0000 PREMIERE -- Sonnenklar TV (running)
> one can see that the PMT PID ^^^ is not non-zero, which is wrong.
>
>
> So here is a problem.
>

Maybe there is a correlation on this case (I am getting a bit lost, I
need to read more DVB-S stuff)

>
> Then...
>
>   Tune to frequency 11836500
>   DiSEqC: switch pos 0, 18V, hiband (index 3)
>   DVB-S IF freq is 1236500
>   >>> tuning status == 0x00
> [...]
>   >>> tuning status == 0x00
>   WARNING: >>> tuning failed!!!
>
> Rather strange; this is the german ARD transponder, which never shows
> results in any of your scans.  You did receive the ZDF transponder,
> though it took some time.  Do you know if you should be in reach of
> the ARD transponder, which I would expect should cover you?
>
> Can you receive ARD, Bayerisches FS, hessen, either with 'Doze, or
> with a regular satellite receiver (these are all free-to-air, unlike
> most Premiere channels)?
>

I will check it.

> As I noted at the start, if your satellite dish installation is less
> than perfect, you may have problems with certain transponders but not
> with others.  Also, a weaker signal will result in transmission errors
> that will show up as mangled PIDs, as I saw several unexpected PIDs
> when you posted the `tspids' summary of your ten-hour recording.
>

Well as more as I read you, more doubts come to me about the quality
of the dish installation, I never had problems with it (80cm, and I
had just change the LNB), but as I used it to see Digital+, I don't
know if the transponders affected are from this provider (TV GALICIA
is from this provider)
>
>
> Something that may be interesting, or not, is that I was thinking
> I could locate those services which receive incorrect 0:0 PIDs by
> scanning for 0x0000 in the stderr file, but in this case:
>
>   Tune to frequency 11597000
>   DiSEqC: switch pos 0, 13V, loband (index 0)
>   DVB-S IF freq is 1847000
>   >>> tuning status == 0x1e
>   SDT (actual TS)
>   0x0402 0x2724: pmt_pid 0x0000 Deutsche Telekom AG -- DW-TV (running)
>   0x0402 0x272e: pmt_pid 0x0000 CNBC -- CNBC Europe (running)
>   0x0402 0x2742: pmt_pid 0x0000 BBC -- BBC World (running)
>   0x0402 0x2773: pmt_pid 0x0000 ASTRA -- Data System (running)
>   0x0402 0x7023: pmt_pid 0x0000 BT -- Sky News (running)
>   0x0402 0x274c: pmt_pid 0x0000 TV5MONDE -- TV5MONDE EUROPE (running)
>   0x0402 0x274e: pmt_pid 0x0000 GlobeCast -- Best of shopping (running)
>   0x0402 0x274f: pmt_pid 0x0000 Globecast -- M6 BOUTIQUE LA CHAINE (running)
>   PAT
>   PMT 0x0742 for service 0x2742
>   PMT 0x072e for service 0x272e
>   PMT 0x0724 for service 0x2724
>   PMT 0x044c for service 0x274f
>   PMT 0x00cd for service 0x274e
>   PMT 0x02cf for service 0x274c
>   PMT 0x1023 for service 0x7023
>   PMT 0x0773 for service 0x2773
>   NIT (actual TS)
>   Network Name 'ASTRA'
>   NIT (actual TS)
>
> BBC World at least, gets the proper PIDs also when the PAT is parsed
> after printing the SDT parsing.
>

Uff more options to take into consideration, this is a bit frustrating jeje.

>
> Now to a summary:
>
> You never seem to receive anything when trying to scan certain
> transponders, such as the ARD transponder at 11836.
>
> It seems to take some time before other transponders lock.
>
> Both you and I experience the same problems with leftover PMT
> data, or failure to scan new data.
>
>
> This can be readily found, when knowing what to look for, in your
> stderr 0 file, but as a pointer, one should compare the found PMT
> PIDs at 11097, with the WARNINGs in the following transponder at
> 10788
>
>

I will try to confirm and make more tests about this facts.

>
> Actually, now that I look more closely, I see the same thing in
> your results from the ARD radio transponder that I see myself:
>
> Note the service IDs found in the transponder immediately above
> at 11479, just before 12265.  For example:
>
>   CANAL EVENEMENT:11479:v:0:22000:160:80:6401:0
>   [1907]:11479:v:0:22000:166:104:6407:0
>
> Now note the service IDs of the below unnamed channels which are not
> present in the list of channels on the ARD radio transponder, but
> which show up here:
>
>   [191e]:11479:v:0:22000:2047:0:6430:0
>   [1901]:12265:h:0:27500:0:0:6401:0
>   [1907]:12265:h:0:27500:0:0:6407:0
>   [1921]:12265:h:0:27500:0:0:6433:0
>   [1920]:12265:h:0:27500:0:0:6432:0
>   [1903]:12265:h:0:27500:0:0:6403:0
>   [193c]:12265:h:0:27500:0:0:6460:0
>   [1932]:12265:h:0:27500:0:0:6450:0
>   [191e]:12265:h:0:27500:0:0:6430:0
>   [191f]:12265:h:0:27500:0:0:6431:0
>   [1963]:12265:h:0:27500:0:0:6499:0
>   [1905]:12265:h:0:27500:0:0:6405:0
>   [1904]:12265:h:0:27500:0:0:6404:0
>   [1902]:12265:h:0:27500:0:0:6402:0
>   MDR FIGARO:12265:h:0:27500:0:0:28431:0
>
> And of course, the audio ID for all the following radio channels
> is :0 which is wrong.
>
> This is repeated in your scans 7 and 8; all the others give the
> correct values.
>
>
>
> I honestly don't know if this is a problem in the driver for the
> card, or something in `scan'.  I see these problems myself with
> a different card, with the same `scan' that works fine with two
> other cards on a different machine (much older kernel).
>

Can I try another scan? from where?

>
> Input from an Expert is welcome, before I decide to try to add
> some debugging to `scan', which means trying to understand how
> it works, which means doing something vaguely resembling `work'.
> Though I'll probably wait a day or two to allow time to think
> about what I want to try to do...
>
>
> thanks
> barry bouwmsa
>

Ok barry, as soon as I get home ( a pair of days ), I am going to try
to repeat the problems with the transponders on linux and on XP, and I
will try to repeat the scanning of this transponders to see if there
is a problem with the dish, or the card. Also I try to fine the dish
orientation to see if I get different results.

Well friend, I will contact you as soon as I can, see you and a lot a
lot of thanks (your beer count is running up at a very high speed ;)
).

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
