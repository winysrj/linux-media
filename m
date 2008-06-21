Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KA2cf-0007PH-4R
	for linux-dvb@linuxtv.org; Sat, 21 Jun 2008 14:55:19 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta2.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K2T001RED73IZW0@mta2.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sat, 21 Jun 2008 08:54:40 -0400 (EDT)
Date: Sat, 21 Jun 2008 08:54:39 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080621052211.5D76732675A@ws1-8.us4.outblaze.com>
To: stev391@email.com
Message-id: <485CFA0F.9020407@linuxtv.org>
MIME-version: 1.0
References: <20080621052211.5D76732675A@ws1-8.us4.outblaze.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] cx23885 driver and DMA timeouts
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


> As soon as I try to access both cards at the same time it breaks and 
> only a full computer restart will fix it, i have tried unloading all the 
> modules that I can find that this card uses and loading them again. I 
> get the syslog attached below (cx23885 with debug =1).  It doesn't 
> matter what progam i use to access them (tried gxine, totem, mythtv) it 
> all works the same, only one at a time or it breaks.

If the vidb and vidc (ts1 / ts2) bridge streams each single channel 
correctly, but not both together then this is either a sram 
configuration issue (the risc engine's workspace is being corrupted by 
another risc channel), or your system has a pcie compatibility issue.

I've seen both of these issues in the past.

I don't have a hardware product with demodulators on vidb and c, so 
that's not something I can repro.

Can you dual boot the same system under windows and remove any pcie 
compatibility doubts?

- Steve




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
