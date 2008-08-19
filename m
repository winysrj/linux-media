Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1KVHec-0008Ua-AJ
	for linux-dvb@linuxtv.org; Tue, 19 Aug 2008 05:13:07 +0200
Message-ID: <48AA3A3C.2050906@linuxtv.org>
Date: Mon, 18 Aug 2008 23:13:00 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Tim Lucas <lucastim@gmail.com>
References: <e32e0e5d0808181946w7e852dc7tef2df349b2f538f0@mail.gmail.com>
In-Reply-To: <e32e0e5d0808181946w7e852dc7tef2df349b2f538f0@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DViCO Fusion HDTV7 Dual Express
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

Tim Lucas wrote:
> I apologize if this is outside the scope of the list and would appreciate
> any help I could get offline if that makes more sense.
> I have been searching online for support for this card and it looks there
> may be support now or coming soon. I am running mythbuntu 8.04 which does
> not yet include support for this card.  I am a linux novice so I was
> wondering if you could help me add the appropriate files that will add
> support for the card.  I am a linux novice (I'm good at apt-get install, but
> no so much at building my own kernel) so I may need a little bit of hand
> holding.  Any help
> you could provide would be appreciated.
> 
> 
> 
> Side question.  I thought I might have seen something about only support for
> digital on this card, not analog.  I am in an apartment complex that uses an
> 
> antiquated (very large) satellite system.  It is listed with schedules
> direct, but I am not sure if it is digital or analog.

FusionHDTV7 Dual Express is supported in the v4l-dvb mercurial tree, hosted on linuxtv.org.
See http://linuxtv.org/repo for info about installing the driver into your running kernel.

Support for the card will be available out-of-the-box in the unreleased kernel 2.6.27

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
