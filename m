Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1KWIoQ-0002m0-7J
	for linux-dvb@linuxtv.org; Fri, 22 Aug 2008 00:39:27 +0200
Received: from [10.11.11.138] (user-5446d4c3.lns5-c13.telh.dsl.pol.co.uk
	[84.70.212.195])
	by mail.youplala.net (Postfix) with ESMTP id C14FFD880AC
	for <linux-dvb@linuxtv.org>; Fri, 22 Aug 2008 00:38:30 +0200 (CEST)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb@linuxtv.org
In-Reply-To: <1219357458.6770.14.camel@youkaida>
References: <1219357458.6770.14.camel@youkaida>
Date: Thu, 21 Aug 2008 23:38:29 +0100
Message-Id: <1219358309.6770.23.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] [mythtv-users] New firmware for dib0700 (Nova-T-500
	and others)
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

On Thu, 2008-08-21 at 23:24 +0100, Nicolas Will wrote:
> All,
> 
> There is a new firmware file fixing the last cause for i2c errors and
> disconnects and providing a new, more modular i2c request formatting.

I will need to request someone with Mercurial access and knowledge to
change the code in dib0700_devices.c to ask for that new file.

Until then, I have put instructions in the wiki for a link or a change
to the old file name.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
