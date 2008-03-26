Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1Jed64-0000xl-RW
	for linux-dvb@linuxtv.org; Wed, 26 Mar 2008 22:23:49 +0100
Received: from [11.11.11.138] (user-514f84eb.l1.c4.dsl.pol.co.uk
	[81.79.132.235])
	by mail.youplala.net (Postfix) with ESMTP id C8543D88137
	for <linux-dvb@linuxtv.org>; Wed, 26 Mar 2008 22:22:42 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <8ad9209c0803261352s664d40fdud2fcbf877b10484b@mail.gmail.com>
References: <1206139910.12138.34.camel@youkaida>
	<1206185051.22131.5.camel@tux> <1206190455.6285.20.camel@youkaida>
	<1206270834.4521.11.camel@shuttle> <1206348478.6370.27.camel@youkaida>
	<1206546831.8967.13.camel@acropora>
	<af2e95fa0803261142r33a0cdb1u31f9b8abc2193265@mail.gmail.com>
	<1206563002.8947.2.camel@youkaida>
	<8ad9209c0803261352s664d40fdud2fcbf877b10484b@mail.gmail.com>
Date: Wed, 26 Mar 2008 21:22:41 +0000
Message-Id: <1206566561.8947.10.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Now with debug info - Nova-T-500 disconnects -	They
	are back!
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


On Wed, 2008-03-26 at 21:52 +0100, Patrik Hansson wrote:
> Linux IKA 2.6.22-14-generic #1 SMP Tue Dec 18 08:02:57 UTC 2007 i686
> GNU/Linux
> Not stable at all here, got 2 disconnects in 2 hours.
> So it can't just be the kernel.

Didn't you say that you are running Hardy, but downgraded the kernel?

If so, maybe we should look at the user space.

The dvb-utils may be fairly old in Ubuntu.

Can the persons experiencing disconnects post:

Distro
distro version
kernel version (uname -a)
dvb-utils version


I'll start:

Ubuntu
Hardy (8.04)
Linux favia 2.6.24-12-generic #1 SMP Wed Mar 12 22:31:43 UTC 2008 x86_64
GNU/Linux
dvb-utils 1.1.1-3

Nico



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
