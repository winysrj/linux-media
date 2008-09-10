Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KdUbr-0001mx-CM
	for linux-dvb@linuxtv.org; Wed, 10 Sep 2008 20:40:12 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6Z001YNT5XZ6Z0@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 10 Sep 2008 14:39:37 -0400 (EDT)
Date: Wed, 10 Sep 2008 14:39:33 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200809101733.29910.janne-dvb@grunau.be>
To: Janne Grunau <janne-dvb@grunau.be>
Message-id: <48C81465.9060709@linuxtv.org>
MIME-version: 1.0
References: <48B8400A.9030409@linuxtv.org> <48C7CDCF.9090300@hauppauge.com>
	<200809101710.19695.hftom@free.fr>
	<200809101733.29910.janne-dvb@grunau.be>
Cc: linux-dvb@linuxtv.org
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

Janne Grunau wrote:
> On Wednesday 10 September 2008 17:10:19 Christophe Thommeret wrote:
>> Le Wednesday 10 September 2008 15:38:23 Steven Toth, vous avez =E9crit :
>>>> Is this card able to deliver both S and T at the same time?
>>> No, the hardware can do S/S2 or T.
>>>
>>> The driver in the S2API tree only has S/S2 enabled (for the time
>>> being).
>> So, maybe we have to think a bit about how to add support for this
>> kind of device.
>>
>> Maybe a solution could be to have :
>> - adapter0/frontend0 -> S/S2 tuner
>> - adapter0/frontend1 -> T tuner
>>
>> So applications could know that these 2 frontends are exclusive.
>> That would not require any API change, but would have to be a rule
>> followed by all drivers.
> =

> The experimental HVR4000 does this already and we have at least initial =

> support for that in mythtv.

Yes, I believe it was added sometime ago.

> =

> I don't think this was the intended use of multiple frontends in the DVB =

> API but AFAIK all dual tuners drivers uses multiple adapters.

It actually was intended for use, it came from patches based on =

linuxtv.org/hg/~stoth/hvr3000 2 years ago, for this exact reason.

The idea died on the vine, except for a few die-hard people to =

maintained their own spin-off/derivative.

> =

> I like this approach.

So do I, it solves a lot of problems with multiple frontends on a single =

transport bus. At the time I did not patch the 7134 framework with the =

minor changes for it to comply, but if that's done then the 6-in-1 7134 =

Dual DVB-S/T/Analog card would also benefit greatly. Right now that card =

only supports some functions in the kernel (IIRC).

It's been a very long time but this was also mentioned on the mailing list.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
