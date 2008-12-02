Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@hotair.fastmail.co.uk>) id 1L7d7D-00007B-Id
	for linux-dvb@linuxtv.org; Tue, 02 Dec 2008 22:49:08 +0100
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by out1.messagingengine.com (Postfix) with ESMTP id 516CE1C9A51
	for <linux-dvb@linuxtv.org>; Tue,  2 Dec 2008 16:49:03 -0500 (EST)
Message-Id: <1228254543.23353.1287906941@webmail.messagingengine.com>
From: "petercarm" <linuxtv@hotair.fastmail.co.uk>
To: "linux-dvb" <linux-dvb@linuxtv.org>
Content-Disposition: inline
MIME-Version: 1.0
References: <412bdbff0811200714j5fcd3d62nb2cd46e49a350ce0@mail.gmail.com>
	<1227213591.29403.1285914127@webmail.messagingengine.com>
	<412bdbff0811201246x7df23a4ak2a6b29a06d67240@mail.gmail.com>
	<1227228030.18353.1285952745@webmail.messagingengine.com>
	<412bdbff0811302059p23155b1dka4c67fcb8f17eb0e@mail.gmail.com>
	<1228152690.22348.1287628393@webmail.messagingengine.com>
	<412bdbff0812011054j21fe1831hcf6b6bc2c0f77bff@mail.gmail.com>
	<1228162425.30518.1287666879@webmail.messagingengine.com>
	<1228164038.5106.1287670679@webmail.messagingengine.com>
	<500CD7A3A0%linux@youmustbejoking.demon.co.uk>
	<1228239571.26312.1287857857@webmail.messagingengine.com>
In-Reply-To: <1228239571.26312.1287857857@webmail.messagingengine.com>
Date: Tue, 02 Dec 2008 21:49:03 +0000
Subject: Re: [linux-dvb] dib0700 remote control support fixed
Reply-To: linuxtv@hotair.fastmail.co.uk
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

I've been busy testing and I have an apology to make.

It looks like the problem is with a riser card.  When I moved the Nova-T
500 to an identical VIA SP8000 in a case that allowed a direct fitting
PCI card, the problems stabilized.

This does explain why I was the only one seeing these problems.  Curious
that the card was stable for DVB functions if the RC polling was
disabled.  I will amend the wiki to make sure it reflects the current
status of the driver.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
