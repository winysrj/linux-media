Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KZ4eu-0004Aq-DT
	for linux-dvb@linuxtv.org; Fri, 29 Aug 2008 16:09:05 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6D009JH8M13XK0@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 29 Aug 2008 10:08:26 -0400 (EDT)
Date: Fri, 29 Aug 2008 10:08:24 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48B7A60C.4050600@kipdola.com>
To: Jelle De Loecker <skerit@kipdola.com>
Message-id: <48B802D8.7010806@linuxtv.org>
MIME-version: 1.0
References: <20080821173909.114260@gmx.net> <20080823200531.246370@gmx.net>
	<48B78AE6.1060205@gmx.net> <48B7A60C.4050600@kipdola.com>
Cc: LinuxTV DVB Mailing <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Future of DVB-S2
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

>> 1. We decide multiproto is awesome, it's status is not that bad and the 
>> future path. Fix it and put it in hg.
>>
>> 2. Multiproto is NOT the way to go in the future, or it's too messed up 
>> and too much work to fix. In that case, forget about any other new 
>> protocol other than DVB-S2 and port the drivers for the DVB-S2 cards to 
>> hg. Apps will get patched soon enough as soon as S2 goes in-kernel.

These aren't the only options.

> I just hope the developper understand US.

... and yes, many people understand you.

> We know all about the "coding in your free time" and we can only have 
> the highest respect for that, but the drivers are completely abandonded, 
> and that's how we feel, too.

No, and that's my HVR4000 code you're talking about (and the good work 
of Darron Broad, which was then picked up by Igor). The driver is 
marginalized, it's not abandoned.

The HVR4000 situation is under review, the wheels are slowly turning.... 
just not fast enough for many of you - I guess.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
