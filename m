Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KdaYi-0005RT-FN
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 03:01:21 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K7000JXEAT9NQF0@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 10 Sep 2008 21:00:46 -0400 (EDT)
Date: Wed, 10 Sep 2008 21:00:45 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200809110201.48935.hftom@free.fr>
To: Christophe Thommeret <hftom@free.fr>
Message-id: <48C86DBD.6090108@linuxtv.org>
MIME-version: 1.0
References: <48B8400A.9030409@linuxtv.org> <20080910161222.21640@gmx.net>
	<48C85153.8010205@linuxtv.org> <200809110201.48935.hftom@free.fr>
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

Christophe Thommeret wrote:
> Le Thursday 11 September 2008 00:59:31 Andreas Oberritter, vous avez =E9c=
rit :
>> Hans Werner wrote:
>>>> So applications could know that these 2 frontends are exclusive.
>>>> That would not require any API change, but would have to be a rule
>>>> followed by
>>>> all drivers.
>>> Yes, if we keep to that rule then only frontends which can operate truly
>>> simultaneously should have a different adapter number.
>> An adapter refers to a self-contained piece of hardware, whose parts can
>> not be used by a second adapter (e.g. adapter0/demux0 can not access the
>> data from adapter1/frontend1). In a commonly used setup it means that
>> adapter0 is the first initialized PCI card and adapter1 is the second.
>>
>> Now, if you want a device with two tuners that can be accessed
>> simultaneously to create a second adapter, then you would have to
>> artificially divide its components so that it looks like two independant
>> PCI cards. This might become very complicated and limits the functions
>> of the hardware.
>>
>> However, on a setup with multiple accessible tuners you can expect at
>> least the same amount of accessible demux devices on the same adapter
>> (and also dvr devices for that matter). There is an ioctl to connect a
>> frontend to a specific demux (DMX_SET_SOURCE).
>>
>> So, if there are demux0, frontend0 and frontend1, then the application
>> knows that it can't use both frontends simultaneously. Otherwise, if =

>> there are demux0, demux1, frontend0 and frontend1, then it can use both
>> of them (by using both demux devices and connecting them to the
>> frontends via the ioctl mentioned above).
> =

> Sounds logical. And that's why Kaffeine search for frontend/demux/dvr > 0=
 and =

> uses demux1 with frontend1. (That was just a guess since i've never seen =

> neither any such devices nor comments/recommendations/rules about such ca=
se).
> =

> However, all dual tuners devices drivers i know expose the 2 frontends as =

> frontend0 in separate adapters. But all these devices seems to be USB.
> =

> The fact that Kaffeine works with the experimental hvr4000 driver indicat=
es =

> that this driver populates frontend1/demux1/dvr1 and then doesn't follow =
the =

> way you describe (since the tuners can't be used at once).
> I would like to hear from Steve on this point.
> =

> =


Correct, frontend1, demux1, dvr1 etc. All on the same adapter. The =

driver and multi-frontend patches manage exclusive access to the single =

internal resource.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
