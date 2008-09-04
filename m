Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KbF6A-0001wX-Dh
	for linux-dvb@linuxtv.org; Thu, 04 Sep 2008 15:42:11 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6O00LPKBDAGR70@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Thu, 04 Sep 2008 09:41:36 -0400 (EDT)
Date: Thu, 04 Sep 2008 09:41:34 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <37990.81.144.130.125.1220526363.squirrel@manicminer.homeip.net>
To: Stephen Rowles <stephen@rowles.org.uk>
Message-id: <48BFE58E.5020508@linuxtv.org>
MIME-version: 1.0
References: <48BF6A09.3020205@linuxtv.org>
	<48BFBE68.7070707@beardandsandals.co.uk>
	<37990.81.144.130.125.1220526363.squirrel@manicminer.homeip.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] S2API - First release
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

Stephen Rowles wrote:
>>> Steven Toth wrote:
>>> A tuning demo app? What? Obviously, tuning older modulation types via
>>> the new API isn't a requirements, but it's a useful validation exercise
>>> for the new S2API.
>>>
>>> Steven
>> Your statement about tuning older modulation types not being a
>> requirement worries me. I would have thought it was an important
>> requirement from an application perspective to be able to tune old and
>> new modulation types through one api. The services I use (BSkyB and
>> Freesat) are mostly DVB-S with very little if any S2. But I would like
>> to be able to tune them via my (not so) new S2 card. Maybe I have
>> misinterpreted what you meant.
> 
> I imagine that there isn't really any need to use the S2 API to tune older
> modulation types, because you just use the existing API if you want the
> old style tuning.

Correct, it's the developers choice.

> 
> However I would agree that if the new API supports both old and new style
> tuning, then that is nicer for anyone writing a new app, as they only have
> to code for the S2API, and get support for all tuning styles. Unless I too
> am not understanding :)

Correct again, it supports old and new tuners.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
