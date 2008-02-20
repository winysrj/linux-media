Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fides.aptilo.com ([62.181.224.35])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jonas@anden.nu>) id 1JRkpD-0006Qv-Rf
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 10:01:11 +0100
Received: from [192.168.1.8] (h-49-157.A157.cust.bahnhof.se [79.136.49.157])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by fides.aptilo.com (Postfix) with ESMTP id 4F7CF1F9065
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 10:00:32 +0100 (CET)
From: Jonas Anden <jonas@anden.nu>
To: linux-dvb@linuxtv.org
In-Reply-To: <Pine.LNX.4.64.0802192327000.13027@pub6.ifh.de>
References: <1203434275.6870.25.camel@tux>
	<Pine.LNX.4.64.0802192208010.13027@pub6.ifh.de>
	<1203457264.8019.6.camel@anden.nu> <1203459408.28796.19.camel@youkaida>
	<Pine.LNX.4.64.0802192327000.13027@pub6.ifh.de>
Date: Wed, 20 Feb 2008 10:00:27 +0100
Message-Id: <1203498027.10076.13.camel@anden.nu>
Mime-Version: 1.0
Subject: Re: [linux-dvb] [patch] support for key repeat with dib0700
	ir	receiver
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

> > Wouldn't going away from an event interface kill a possible direct link
> > between the remote and X?

Yes, it would.

> > The way I see it, LIRC is an additional layer that may be one too many
> > in most cases. From my point of view, it is a relative pain I could do
> > without. But I may have tunnel vision by lack of knowledge.
>
> I agree with you. I'm more looking for a solution with existing things. 
> LIRC is not in kernel. I don't think we should do something specific, new. 
> If there is nothing which can be done with the event system I think we 
> should either extend it or just drop this idea.

IMHO, the event interface does not match well with the reduced key set
on a remote control. The keys are mapped in the driver which makes it
difficult to customize. I'm not talking about the current problem with
the mappings being hardcoded -- that could probably be solved without
too much work.

The problem I see with the mapping taking place in the driver, is that
the interpretation of the key presses and releases should be
application-specific. If I'm in MythTV, I want one interpretation. In
Evolution, the same keypress should be interpreted differently. Firefox
has a third set of mappings. Lircd solves this problem for me, while the
event interface creates one static mapping.

  // J


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
