Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@hotair.fastmail.co.uk>) id 1L7G6r-0001to-OL
	for linux-dvb@linuxtv.org; Mon, 01 Dec 2008 22:15:15 +0100
Received: from compute2.internal (compute2.internal [10.202.2.42])
	by out1.messagingengine.com (Postfix) with ESMTP id 8B4CF1C95DE
	for <linux-dvb@linuxtv.org>; Mon,  1 Dec 2008 16:15:09 -0500 (EST)
Message-Id: <1228166109.13667.1287679483@webmail.messagingengine.com>
From: "petercarm" <linuxtv@hotair.fastmail.co.uk>
To: "Linux-dvb" <linux-dvb@linuxtv.org>
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
	<412bdbff0812011247l600103bdn6b18bf0533b7a981@mail.gmail.com>
In-Reply-To: <412bdbff0812011247l600103bdn6b18bf0533b7a981@mail.gmail.com>
Date: Mon, 01 Dec 2008 21:15:09 +0000
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

On Mon, 1 Dec 2008 15:47:54 -0500, "Devin Heitmueller"
<devin.heitmueller@gmail.com> said:
> 
> Woah.  You didn't mention it was doing a panic.
> 
> I'm not sure what is going on there.  You're getting errors in
> af9013/af9016, so it's not specific to the mt2060 like other people
> were reporting issues.
> 
> I'll look at the backtrace tonight and see if I can figure out what
> happened.  In the meantime, could you please update to the hg
> immediately before and after the November 16th changeset and confirm
> that IR change definitely caused the issue?

I've since removed the Kworld (Afatech device) and it is still doing the
same on reboot.

The problems can be reproduced with just the Nova-T 500.  The same OS
image runs fine on boxes running with the afatech and connexant devices
I have available.  It will take me a while to re-arrange my test
hardware to test the Nova-TD in isolation.

I'll go back to the rev 9638, as you suggest.  Again, it will take me
overnight to get that sorted.

I'm signing off for a couple of hours now but I am as keen to get to the
bottom of this as you.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
