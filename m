Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1KWb0o-0003f0-No
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 20:05:27 +0200
Received: from [10.11.11.138] (user-5446d4c3.lns5-c13.telh.dsl.pol.co.uk
	[84.70.212.195])
	by mail.youplala.net (Postfix) with ESMTP id 9D5C3D880A4
	for <linux-dvb@linuxtv.org>; Fri, 22 Aug 2008 20:04:28 +0200 (CEST)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <1219427117.29624.33.camel@youkaida>
References: <1219330331.15825.2.camel@dark> <48ADF515.6080401@nafik.cz>
	<1219360304.6770.34.camel@youkaida> <1219423326.29624.8.camel@youkaida>
	<1219423493.29624.9.camel@youkaida>
	<412bdbff0808220952y16d36f3by646f0000991de4d3@mail.gmail.com>
	<1219424386.29624.16.camel@youkaida>
	<1219427117.29624.33.camel@youkaida>
Date: Fri, 22 Aug 2008 19:04:30 +0100
Message-Id: <1219428270.29624.39.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] dib0700 and analog broadcasting
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

On Fri, 2008-08-22 at 18:45 +0100, Nicolas Will wrote:
> 
> What is interesting, is that at each self-reboot, that are warm
> reboots,
> the card is in cold state and needs a firmware. So can I conclude that
> it never got loaded? Or that the self reboot is a cold reboot?


hmmm...

OK.

It works now.

A lot of noise about not much, and that makes me wonder how much of an
idiot I am...

I did a 

sudo find /lib/firmware/2.6.24-1* -name "dvb-usb-dib07*.fw" -exec rm {}
\;

It did remove all the 1.10 firware files provided by the Ubuntu
packaging.

I made sure that I had the 1.20 fw with the 1.10 name in /lib/firmware,
and all is working.

Apparently the driver/kernel was confused about which file to pick-up.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
