Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from host06.hostingexpert.com ([216.80.70.60])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@linuxtv.org>) id 1KYh6U-0002TL-BD
	for linux-dvb@linuxtv.org; Thu, 28 Aug 2008 14:59:59 +0200
Message-ID: <48B6A148.7010702@linuxtv.org>
Date: Thu, 28 Aug 2008 08:59:52 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: olly <olly@dEU5.net>
References: <48B68D4A.4050800@dEU5.net>
In-Reply-To: <48B68D4A.4050800@dEU5.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] WinTV Nova-S USB2 support
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

olly wrote:
> Hi,
> 
> due to the wiki i know that there is no support for the WinTV Nova-S 
> USB2 yet in the kernel. so here's the alltime question. Is there someone 
> active in developing and needs help, info, tester? Or better, is there a 
> way to get that device working?

That device has a tm6000 chipset, a driver is currently under development by Mauro Carvalho Chehab.

I don't know the state of the driver, but I am under the impression that it is not yet ready for testing.

His development repository is visible on linuxtv.org, if you want to look at the code.

-Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
