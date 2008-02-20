Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JRsms-0005xU-EN
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 18:31:18 +0100
Received: from steven-toths-macbook-pro.local
	(ool-18bac60f.dyn.optonline.net [24.186.198.15]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JWJ00EAXSMYW7C1@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 20 Feb 2008 12:30:36 -0500 (EST)
Date: Wed, 20 Feb 2008 12:30:34 -0500
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <47BB7044.2090804@ecst.csuchico.edu>
To: Barry Quiel <quielb@ecst.csuchico.edu>
Message-id: <47BC63BA.8010102@linuxtv.org>
MIME-version: 1.0
References: <47BB7044.2090804@ecst.csuchico.edu>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1800 status
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

Barry Quiel wrote:
> I haven't seen any code updates to support the analog portion of the 
> HVR-1800 in a few weeks.  Is it still being worked on?

Not recently, the current tree is under ~stoth. The encoder is working, 
the tuner is tuning, everything looks OK.

I need to cleanup the ioctl handling.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
