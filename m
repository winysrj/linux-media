Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1JUtUy-0006jJ-BY
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 01:53:16 +0100
Received: from [11.11.11.138] (user-54458eb9.lns1-c13.telh.dsl.pol.co.uk
	[84.69.142.185])
	by mail.youplala.net (Postfix) with ESMTP id A1EBCD88124
	for <linux-dvb@linuxtv.org>; Fri, 29 Feb 2008 01:52:17 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <47C74DF4.6040608@powercraft.nl>
References: <47C7329F.7030705@powercraft.nl>
	<d9def9db0802281421v698df05eq52a1978c69d80df2@mail.gmail.com>
	<47C73457.1030901@powercraft.nl>
	<d9def9db0802281425i5b487f43ub90b263a63e40a01@mail.gmail.com>
	<47C7360E.9030908@powercraft.nl>
	<d9def9db0802281440x2daa2f21n2169e76b53ccd664@mail.gmail.com>
	<47C73A05.2050007@powercraft.nl>
	<d9def9db0802281455hb962279g9f45a8e87cf16d28@mail.gmail.com>
	<d9def9db0802281458g73939fefq8c5d7bc9aa49e1aa@mail.gmail.com>
	<47C74DF4.6040608@powercraft.nl>
Date: Fri, 29 Feb 2008 00:52:16 +0000
Message-Id: <1204246336.22520.57.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Going though hell here,
	please provide how to for	Pinnacle PCTV Hybrid Pro Stick 330e
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

hmmm...

guys.

First thing: on a Debian or Ubuntu system, I never needed the full Linux
sources to compile a v4l-dvb tree. The headers were always enough.

Second thing: when you compile a v4l-dvb tree on the side, I do not
think that it is adding anything in the headers.
So, if you subsequently need to compile a driver that needs stuff from a
recent v4l-dvb tree, it won't find it.

Third thing: That weird driver of yours is probably looking for its
stuff either int the headers (were there will not be anything good to
find because of the point made above) or in an available kernel source
tree (where it will probably not find anything that will make it happy
because your recent v4l-dvb tree is elsewhere).

May I suggest to get a kernel source tree (from the appropriate
package), incorporate the v4l-dvb tree in it, then try to compile your
weird driver against this.

Getting rid of the headers may help.

Nico
has been know to be very wrong


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
