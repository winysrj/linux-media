Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KQNZe-0005Ka-0Q
	for linux-dvb@linuxtv.org; Tue, 05 Aug 2008 16:31:43 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K54006UNTNLXOB0@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 05 Aug 2008 10:31:07 -0400 (EDT)
Date: Tue, 05 Aug 2008 10:30:57 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080805114757.5502411581F@ws1-7.us4.outblaze.com>
To: stev391@email.com
Message-id: <48986421.6070002@linuxtv.org>
MIME-version: 1.0
References: <20080805114757.5502411581F@ws1-7.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH-TESTERS-REQUIRED] Leadtek Winfast PxDVR 3200
 H - DVB Only support
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

stev391@email.com wrote:
> Steve,
> 
> I have reworked the tuner callback now against your branch at:
> http://linuxtv.org/hg/~stoth/v4l-dvb
> 
> The new Patch (to add support for this card) is attached inline below 
> for testing (this is a hint Mark & Jon), I have not provided a 
> signed-off note on purpose as I want to solve the issue mentioned in the 
> next paragraph first.
> 
> Regarding the cx25840 module; the card doesn't seem to initialise 
> properly (no DVB output and DMA errors in log) unless I have this 
> requested.  Once the card is up and running I can unload all drivers, 
> recompile without the cx25840 and load and it will work again until I 
> power off the computer and back on again (This has been tedious trying 
> to work out which setting I had missed).  Is there some initialisation 
> work being performed in the cx25840 module that I can incorporate into 
> my patch to remove this dependency? Or should I leave it as is?
> 
> Anyway nearly bedtime here.

The patch looks good, with the exception of requesting the cx25840.

I've always been able to run DVB without that driver being present, so 
something is odd with the Leadtek card. I'm not aware of any 
relationship between the cx25840 driver and the DVB core.

You're going to need to find the magic register write that the cx25840 
is performing so we can discuss here. I'd rather we figured that out 
cleanly, than just merged the patch and have the problem linger on.

Other than that, good patch.

- Steve








_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
