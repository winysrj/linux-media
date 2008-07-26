Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KMlsA-00020p-HK
	for linux-dvb@linuxtv.org; Sat, 26 Jul 2008 17:39:55 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K4M00LMJE5GLUL0@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sat, 26 Jul 2008 11:39:16 -0400 (EDT)
Date: Sat, 26 Jul 2008 11:39:16 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200807260353.23359.yusikk@gmail.com>
To: Yusik Kim <yusikk@gmail.com>
Message-id: <488B4524.5070203@linuxtv.org>
MIME-version: 1.0
References: <200807260353.23359.yusikk@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge HVR-1950 digital part
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

Yusik Kim wrote:
> Hi,
> 
> Has anyone got the digital part of this device to work properly? 
> 
> Modules are compiled from the latest (7/26) v4l-dvb snapshot with a 2.6.25.4 
> kernel. The modules seem to load properly and the analog part works in 
> mythtv. The digital part kind of works.
> The problems I can observe are:
> 1. Can only scan 3 digital channels using both the command line scan and 
> mythtv. My other PCI TV card scans 36 of them. 
> 2. Only occasionally locks in to a channel.
> 3. Takes 5 minutes to lock in to a channel when it actually does succeed.
> 
> I saw from another mailing list that people were trying to get the remote 
> control to work so I'm guessing the core of the device functions properly. If 
> this is the current state of support, I'd be glad to help testing.

What steps did you take to prove your hardware is function properly, or 
your digital cable feed is reliable?

The drivers works for me, it sounds like you have an environmental issue.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
