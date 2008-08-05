Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KQBJo-00066Q-1u
	for linux-dvb@linuxtv.org; Tue, 05 Aug 2008 03:26:33 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K5300ADGTB9F7Z0@mta1.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 04 Aug 2008 21:25:58 -0400 (EDT)
Date: Mon, 04 Aug 2008 21:25:56 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080801034025.C0EC947808F@ws1-5.us4.outblaze.com>
To: stev391@email.com
Message-id: <4897AC24.3040006@linuxtv.org>
MIME-version: 1.0
References: <20080801034025.C0EC947808F@ws1-5.us4.outblaze.com>
Cc: linux-dvb@linuxtv.org, linuxdvb@itee.uq.edu.au
Subject: Re: [linux-dvb] [PATCH] Add initial support for DViCO FusionHDTV
 DVB-T Dual Express
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
> Anton,
> 
> Thankyou for cleaning this code up (and you as well Steven).
> 
> I have been meaning to do some more work on this lately, but you have 
> taken it to were I was hoping to go.
> 
> Steven, I can test your cleaned up code as well, just drop me an email 
> and I will run it on my machines (I have several that I have access to 
> with these cards in them, with various other cards).

Stephen / Anton,

http://linuxtv.org/hg/~stoth/v4l-dvb

This has Anton's patches and a subsequent cleanup patch to merge the 
single tune callback functions into a single entity. A much better 
solution all-round.

I've tested with the HVR1500Q (xc5000 based) and I'm happy with the 
results. Can you both try the DViCO board?

Thanks,

Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
