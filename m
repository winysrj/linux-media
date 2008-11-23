Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpi1.ngi.it ([88.149.128.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mail@robertoragusa.it>) id 1L4LOV-0000fm-4u
	for linux-dvb@linuxtv.org; Sun, 23 Nov 2008 21:17:25 +0100
Received: from [127.0.0.1] (81-174-56-138.static.ngi.it [81.174.56.138])
	by smtpi1.ngi.it (8.13.8/8.13.8) with ESMTP id mANKH3Yu022381
	for <linux-dvb@linuxtv.org>; Sun, 23 Nov 2008 21:17:04 +0100
Message-ID: <4929BA4D.1040906@robertoragusa.it>
Date: Sun, 23 Nov 2008 21:17:17 +0100
From: Roberto Ragusa <mail@robertoragusa.it>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] MC44S803 driver still not merged?
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

Hi,

my Terratec Cinergy T USB XE Ver.2 used to work with this
af9015 mc44s80x driver

http://git.bocc.de/cgi-bin/gitweb.cgi?p=cinergy.git;a=commitdiff;h=141a8da01a6f3f87ed49a0b344d42a9df2e0648b
http://git.bocc.de/cgi-bin/gitweb.cgi?p=cinergy.git;a=commitdiff;h=10361aea659e073de19b205d1ecbacf909eaa5c7

which provides support for the MC44S803 frontend.

That driver does not compile on 2.6.27 (but it works on 2.6.25).
My hope was that 2.6.27 would have supported this hardware with no
need for patches or external builds.

My question: will this driver be merged in a near future?

I'm willing to test, if it can be useful.

Best regards.
-- 
   Roberto Ragusa    mail at robertoragusa.it

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
