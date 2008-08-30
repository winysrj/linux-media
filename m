Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KZUQq-0002It-6O
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 19:40:17 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6F00A4LD25DZ90@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sat, 30 Aug 2008 13:39:42 -0400 (EDT)
Date: Sat, 30 Aug 2008 13:39:41 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080830200613.48c66ee6@bk.ru>
To: Goga777 <goga777@bk.ru>
Message-id: <48B985DD.7030402@linuxtv.org>
MIME-version: 1.0
References: <48B8400A.9030409@linuxtv.org>
	<20080830150844.GQ7830@moelleritberatung.de>
	<48B963D1.3060908@linuxtv.org> <20080830200613.48c66ee6@bk.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
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

Goga777 wrote:
> Hi, Steven
> 
> - if new api will be approve, who will update the drivers for stb0899 based cards ?


I suspect Manu has included the stb0899 driver in his recent pull 
request, which by definition will have his sign-off. So, people are free 
to derive new drivers form his work providing they follow his licensing 
rules.

I have one of those boards. Assuming the stb0899 TT-3200 drivers are GPL 
- and signed-off for release, if nobody else offers to do this then I will.

> - if new api will be approve, how long time need for first release of updated dvb-s2 drivers for cx24116/stb0899 cards ?

If the API is approved then HVR4000 support will also be included with 
that merge.

I don't know the stb0899 driver specifically so I can't say whether it 
would be part of the initial merge, but I would expect it to follow 
shortly afterwards.

Regards,

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
