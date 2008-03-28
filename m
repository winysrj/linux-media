Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JfGxc-0006Pz-23
	for linux-dvb@linuxtv.org; Fri, 28 Mar 2008 16:57:46 +0100
Received: from [134.32.138.158] (unknown [134.32.138.158])
	by mail.youplala.net (Postfix) with ESMTP id AF059D88138
	for <linux-dvb@linuxtv.org>; Fri, 28 Mar 2008 16:56:43 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <8ad9209c0803280846q53e75546g2007d4e8be98fb8e@mail.gmail.com>
References: <1206139910.12138.34.camel@youkaida>
	<1206546831.8967.13.camel@acropora>
	<af2e95fa0803261142r33a0cdb1u31f9b8abc2193265@mail.gmail.com>
	<1206563002.8947.2.camel@youkaida>
	<8ad9209c0803261352s664d40fdud2fcbf877b10484b@mail.gmail.com>
	<1206566255.8947.5.camel@youkaida> <1206605144.8947.18.camel@youkaida>
	<af2e95fa0803271044lda4ac30yb242d7c9920c2051@mail.gmail.com>
	<47EC13BE.6020600@simmons.titandsl.co.uk>
	<1206655986.17233.8.camel@youkaida>
	<8ad9209c0803280846q53e75546g2007d4e8be98fb8e@mail.gmail.com>
Date: Fri, 28 Mar 2008 15:56:37 +0000
Message-Id: <1206719797.14161.8.camel@acropora>
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

On Fri, 2008-03-28 at 16:46 +0100, Patrik Hansson wrote:
> Tried to collect some info from logs.
> messages:
> http://pastebin.com/f5cc1bc26
> syslog:
> http://pastebin.com/f402477c9
> debug:
> http://pastebin.com/f187de73a
> 

This is missing a bit of context.

And I see no disconnect there.

The mt2060 i2c read/write errors are, I think, a by-product of something
else, and not the real problem. A disconnect happens, then you see the
mt2060 i2c error, not the other way around.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
