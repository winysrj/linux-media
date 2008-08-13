Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KTJG0-0003LL-Cm
	for linux-dvb@linuxtv.org; Wed, 13 Aug 2008 18:31:33 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K5J000MOSJJOI70@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Wed, 13 Aug 2008 12:30:58 -0400 (EDT)
Date: Wed, 13 Aug 2008 12:30:55 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <9A560F1988F700499D7636F15A62E436A06CCD@exchange02.Nsighttel.com>
To: Mark A Jenks <Mark.Jenks@nsighttel.com>
Message-id: <48A30C3F.9040600@linuxtv.org>
MIME-version: 1.0
References: <9A560F1988F700499D7636F15A62E436A06CCD@exchange02.Nsighttel.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] WinTV-HVR-1800
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

Mark A Jenks wrote:
> I am looking at purchasing a few 1800's for a new Myth box that I am 
> setting up.
>  
> Should I get the ones with the IR's, or not?   Is the IR support on linux?
>  
> I can't find anything searching around.

Native IR receive via the cx23885 isn't supported in Linux. I don't 
remember whether Hauppauge ship a Zilog enabled version (blaster 
support), if they do then that could be made to work.

Assume worst case.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
