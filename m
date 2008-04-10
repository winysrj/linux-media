Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JjwHQ-0006V2-5E
	for linux-dvb@linuxtv.org; Thu, 10 Apr 2008 14:53:30 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18be07c9.dyn.optonline.net [24.190.7.201]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JZ400L7F142WJ81@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Thu, 10 Apr 2008 08:52:50 -0400 (EDT)
Date: Thu, 10 Apr 2008 08:52:49 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <47FDAD31.6030901@optusnet.com.au>
To: Darrin Ritter <darrinritter@optusnet.com.au>
Message-id: <47FE0DA1.5050302@linuxtv.org>
MIME-version: 1.0
References: <47FDAD31.6030901@optusnet.com.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Conexant CX23880 suspected driver memory leak
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


> I tested the application for an hour and the memory usage stayed at a 
> steady 14.6 Mb, given the previous tests I would have expected the 
> memory usage to rise to approx 26.6 Mb

Thanks Darrin.

I'll fix it if you can prove the leak with dvbstream.

http://sourceforge.net/projects/dvbtools/

Can you?

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
