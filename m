Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.hauppauge.com ([167.206.143.4])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KdtZI-0006t1-CS
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 23:19:17 +0200
Message-ID: <48C97210.2060609@linuxtv.org>
Date: Thu, 11 Sep 2008 15:31:28 -0400
From: Steven Toth <stoth@linuxtv.org>
MIME-Version: 1.0
To: Christophe Thommeret <hftom@free.fr>
References: <48B8400A.9030409@linuxtv.org>
	<48C81627.8080409@linuxtv.org>	<200809102232.26884.hftom@free.fr>
	<200809111535.19315.hftom@free.fr>
In-Reply-To: <200809111535.19315.hftom@free.fr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiple frontends on a single adapter support
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

> Andreas Oberritter said:
> "This way is used on dual and quad tuner Dreambox models." (non exclusive 
> tuners).
> "How about dropping demux1 and dvr1 for this adapter (exclusive tuners), since 
> they don't create any benefit? IMHO the number of demux devices should always 
> equal the number of simultaneously usable transport stream inputs."

...

> 
> So, here are my questions:
> 
> @Steven Toth:
> What do you think of Andreas' suggestion? Do you think it could be done that 
> way for HVR4000 (and 3000?) ?

Could it, yes. I'll go with the majority on this to be honest.

As far as I'm concerned the hvr3000 patches (if you read the patch 
description) were not to be merged as-is, they were for discussion and 
review. It's encouraging good to see that discussion happening now, 
later than expect, but good.

The inodes largely reflect API usage so it needs to be obvious, if we 
think this isn't, then we should come to a consensus and resolve for the 
future.

Obviously, the impact would be that existing applications that are using 
unofficial patches would have to be patched again, away from the current 
approach.

- Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
