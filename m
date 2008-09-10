Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KdUj8-0002d4-WB
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 20:47:44 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6Z00E5UTIFUWF1@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 10 Sep 2008 14:47:09 -0400 (EDT)
Date: Wed, 10 Sep 2008 14:47:03 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080910161222.21640@gmx.net>
To: Hans Werner <HWerner4@gmx.de>
Message-id: <48C81627.8080409@linuxtv.org>
MIME-version: 1.0
References: <48B8400A.9030409@linuxtv.org> <200809101340.09702.hftom@free.fr>
	<48C7CDCF.9090300@hauppauge.com> <200809101710.19695.hftom@free.fr>
	<20080910161222.21640@gmx.net>
Cc: stoth@hauppauge.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hans Werner wrote:
> -------- Original-Nachricht --------
>> Datum: Wed, 10 Sep 2008 17:10:19 +0200
>> Von: Christophe Thommeret <hftom@free.fr>
>> An: Steven Toth <stoth@hauppauge.com>
>> CC: linux-dvb@linuxtv.org
>> Betreff: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation suppo=
rt
> =

>> Le Wednesday 10 September 2008 15:38:23 Steven Toth, vous avez =E9crit :
>>>> Is this card able to deliver both S and T at the same time?
>>> No, the hardware can do S/S2 or T.
>>> The driver in the S2API tree only has S/S2 enabled (for the time being).
>> So, maybe we have to think a bit about how to add support for this kind =
of
>> device.
> =

> Yes, absolutely, and I hope this can go in to S2API and the kernel. It wo=
uld be a lie
> to claim that linux supports the HVR4000 until this is done. Fortunately =
Steven
> and Darron made experimental drivers which do this.
> =

>> I mean, if the driver provides different adapters/frontends (say =

>> adapter0/frontend0 and adapter1/frontend0), a typical application will s=
ee
>> these as separate devices, and then when a user watch a S channel, the a=
pp
>> assumes that the T frontend is free while in fact it's not.
>> For example, Kaffeine updates its channels list according to which
>> channels =

>> can be viewed (based on which frontends are free). So, if you are
>> recording a =

>> S channel, all channels on this freq are shown as available and all T =

>> channels are also shown as available. But in the HVR4000 case, it's fals=
e,
>> since the T tuner isn't free.
>>
>> Maybe a solution could be to have :
>> - adapter0/frontend0 -> S/S2 tuner
>> - adapter0/frontend1 -> T tuner
> =

> This is what the multifrontend (mfe) driver at http://dev.kewl.org/hauppa=
uge does.
> And Kaffeine is the only major DVB app which correctly finds the two fron=
tends
> and uses them correctly (well done!!). Or very nearly -- TV watching is p=
erfect, but
> the only slight problem happens when you are recording:
> =

> (1) record a DVB-T channel:
> -->all DVB-T channels except those in same multiplex vanish from the avai=
lable
> channels list (correct)
> -->no satellite channels vanish (incorrect)
> =

> (2) record a DVB-S channel;
> -->all DVB-S channels except those on the same multiplex vanish from the =
available
> channels list (correct)
> -->no DVB-T channels vanish (incorrect)
> =

> It's a small problem, easily fixed I would think.
> =

>> So applications could know that these 2 frontends are exclusive.
>> That would not require any API change, but would have to be a rule
>> followed by =

>> all drivers.
> =

> Yes, if we keep to that rule then only frontends which can operate truly
> simultaneously should have a different adapter number.

If everyone wants this in the S2API tree then it's pretty simple to add, =

I just didn't want to overload the tree with too much baggage that =

causes it to get stuck in the approval process.

We need an S2 API in the next few weeks, and anything that delays that =

is bad news for everyone.

I'll publish a mail about this in a separate thread, and seek feedback =

from everyone.

- Steve






_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
