Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JVBVD-0006Uo-Qk
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 21:06:43 +0100
Received: from steven-toths-macbook-pro.local
	(ool-18bac60f.dyn.optonline.net [24.186.198.15]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JX000HBPNU3ZA71@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 29 Feb 2008 15:06:05 -0500 (EST)
Date: Fri, 29 Feb 2008 15:06:03 -0500
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <a6e3d9900802291150l33e8dc7fu39ccbef9310d706c@mail.gmail.com>
To: John Donaghy <johnfdonaghy@gmail.com>
Message-id: <47C865AB.3070101@linuxtv.org>
MIME-version: 1.0
References: <a6e3d9900802291150l33e8dc7fu39ccbef9310d706c@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] xc3028 tuner development status?
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


Correct, it's a rebranded Haupauge HVR1500.

> Unlike the previous poster I'm not getting "frontend initialization
> failed" which is promising, but when I run:
> 
> /usr/bin/scan /usr/share/doc/dvb-utils/examples/scan/atsc/us-ATSC-center-frequencies-8VSB
> 
> I get a bunch of "tuning failed" messages like this:
> 
> scanning /usr/share/doc/dvb-utils/examples/scan/atsc/us-ATSC-center-frequencies-8VSB
> using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>>> tune to: 57028615:8VSB
> WARNING: >>> tuning failed!!!
>>>> tune to: 57028615:8VSB (tuning failed)
> WARNING: >>> tuning failed!!!
> 
> Am I missing something (like firmware perhaps) or does it not work
> yet? Let me know if there's anything I can do to help get it working.

Do you have the xc3028 firmware on your system?

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
