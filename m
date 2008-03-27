Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.youplala.net ([88.191.51.216] helo=mail.youplala.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nico@youplala.net>) id 1Jen88-0003Lp-TN
	for linux-dvb@linuxtv.org; Thu, 27 Mar 2008 09:06:41 +0100
Received: from [11.11.11.138] (user-514f84eb.l1.c4.dsl.pol.co.uk
	[81.79.132.235])
	by mail.youplala.net (Postfix) with ESMTP id 82BC0D88134
	for <linux-dvb@linuxtv.org>; Thu, 27 Mar 2008 09:05:45 +0100 (CET)
From: Nicolas Will <nico@youplala.net>
To: linux-dvb <linux-dvb@linuxtv.org>
In-Reply-To: <1206566255.8947.5.camel@youkaida>
References: <1206139910.12138.34.camel@youkaida>
	<1206185051.22131.5.camel@tux> <1206190455.6285.20.camel@youkaida>
	<1206270834.4521.11.camel@shuttle> <1206348478.6370.27.camel@youkaida>
	<1206546831.8967.13.camel@acropora>
	<af2e95fa0803261142r33a0cdb1u31f9b8abc2193265@mail.gmail.com>
	<1206563002.8947.2.camel@youkaida>
	<8ad9209c0803261352s664d40fdud2fcbf877b10484b@mail.gmail.com>
	<1206566255.8947.5.camel@youkaida>
Date: Thu, 27 Mar 2008 08:05:44 +0000
Message-Id: <1206605144.8947.18.camel@youkaida>
Mime-Version: 1.0
Subject: Re: [linux-dvb] Now with debug info - Nova-T-500 disconnects	-	They
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


On Wed, 2008-03-26 at 21:17 +0000, Nicolas Will wrote:
> Well, fine.
> 
> What we need here is a developer.
> 
> What a developer needs is info, without it, he will not be able to
> help.
> 
> I've posted logs, now your turn.
> 

Adding the following lines in your /etc/modprobe.d/options would be a
good start:

options dvb-usb-dib0700 debug=1
options mt2060 debug=1
options dibx000_common debug=1
options dvb_core debug=1
options dvb_core dvbdev_debug=1
options dvb_core frontend_debug=1
options dvb_usb debug=1
options dib3000mc debug=1

Then post the lines of /var/log/syslog and /var/log/messages around the
disconnect event.

Better post them somewhere on a web page or a pastebin.

Nico


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
