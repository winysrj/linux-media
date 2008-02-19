Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JRafR-0005lN-Gf
	for linux-dvb@linuxtv.org; Tue, 19 Feb 2008 23:10:25 +0100
Received: from [11.11.11.138] (user-54458eb9.lns1-c13.telh.dsl.pol.co.uk
	[84.69.142.185])
	by mail.youplala.net (Postfix) with ESMTP id D372ED88113
	for <linux-dvb@linuxtv.org>; Tue, 19 Feb 2008 23:09:27 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <950c7d180802191310x5882541h61bc60195a998da4@mail.gmail.com>
References: <1203434275.6870.25.camel@tux>
	<1203441662.9150.29.camel@acropora> <1203448799.28796.3.camel@youkaida>
	<1203449457.28796.7.camel@youkaida>
	<950c7d180802191310x5882541h61bc60195a998da4@mail.gmail.com>
Date: Tue, 19 Feb 2008 22:09:26 +0000
Message-Id: <1203458966.28796.13.camel@youkaida>
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


On Wed, 2008-02-20 at 06:10 +0900, Matthew Vermeulen wrote:
> Hi all... I'm seeing exactly the same problems everyone else is (log
> flooding etc) except that I can't seem to get any keys picked by lirc
> or /dev/input/event7 at all...
> 
> Would this patch help in this case?

It would help with the flooding, most probably, though there was a patch
for that available before.

As for LIRC not picking up the event, I would be tempted to say no, it
won't help.

Are you certain that your LIRC is configured properly? Are you certain
that your event number is the right one?

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
