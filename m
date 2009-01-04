Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LJK3Q-0004ic-Az
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 04:53:34 +0100
Received: by ug-out-1314.google.com with SMTP id x30so1261110ugc.16
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 19:53:28 -0800 (PST)
Date: Sun, 4 Jan 2009 04:52:50 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: kedgedev@centrum.cz
In-Reply-To: <op.um64vfdkrj95b0@localhost>
Message-ID: <alpine.DEB.2.00.0901040419380.16894@ybpnyubfg.ybpnyqbznva>
References: <op.um6wpcvirj95b0@localhost>
	<c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
	<op.um60szqyrj95b0@localhost>
	<c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
	<op.um64vfdkrj95b0@localhost>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S Channel searching problem
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

On Sat, 3 Jan 2009, Roman Jarosz wrote:

> > I think that's the main issue. *BOUWSMA w*rote that its ok to rely on
> > astra's maintainers and connect to any transponder is enough to get a  
> > list
> > of all others. I personaly don't trust those maintainers since I saw too
> > many errors in NIT messages that specify the transponder, so I specify  
> > all
> > the frequencies I want to scan. I don't have a dish to 19.2, but there  

Another reason why one might want to list all the frequencies
particularly for 19E2 is that presently quite a few transponders
are still analogue, but within a year or so will become digital.
Often a digital transponder is fired up but not added to the
NIT tables until officially going into service.

The frequencies used at 19E2 are well known, as are the related
parameters -- present analogue channels will use the same
frequencies with steps 14750kHz, SR22000, and 5/6, as the
existing ex-analogue channels -- unless they get put into
DVB-S2 service.  There have been a small number of temporary
variants, though:  12728 was SR 19890 for a short while...

I have seen one or two mistakes added to the NIT tables at
this position; somehow a 11475+27500 alleged transponder was
added, and I also have seen an Intermediate Frequency added
in one or two cases, which is clearly human error.



> Could you tell me how? I've tried with S 12188000 H 27500000 3/4 and
> it doesn't find anything.
> The console outputs are here:
> http://kedge.wz.cz/dvb/scan.txt

For some reason, your card is unable to lock onto that
transponder, at least from `scan' -- seen by the tuning
status values never going above 0x1 or 0x3, which is
usually the case when no transponder is present, or the
parameters given are incorrect.

But then you said early that you could manually zap to
this frequency and see RTL...

In fact, as I look at the result of your scan, you are
only able to tune in very few of the transponders which
you should receive -- perhaps less than a third.

Oh, your bogus IF is still present toward the end of the
scan:
>>> tune to: 1574:h:S19.2E:22000:
DVB-S IF freq is 8175750
Obviously 1,574GHz is not a Ku-band transponder, but
rather the IF of the local oscillator at 9,75GHz, for
a frequency of 11,324GHz, or at 10,6GHz for 12,174GHz
which is in the band where SR27500 is used -- though
I vaguely recall there also being a frequency provided
well above 12750...

I see no regular pattern in transponders that fail to
tune.  `scan -v' will show how many attempts it takes
to tune those transponders with success; I believe the
`-5' option does not lengthen the time permitted for
a lock to be obtained, but it wouldn't hurt to try it,
I think (it normally is used where the data sent does
not cycle around in a short time as it should).

In general, I expect my tuners to lock onto a good signal
such as Astra in one, and no more than two tuning status
lines.  But I've seen other scan results where lock is not
obtained so quickly...


barry bouwsma
needs sleep badly

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
