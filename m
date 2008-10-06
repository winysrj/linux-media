Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@hotair.fastmail.co.uk>) id 1Kmz7h-0004zP-1w
	for linux-dvb@linuxtv.org; Tue, 07 Oct 2008 01:04:17 +0200
Received: from compute1.internal (compute1.internal [10.202.2.41])
	by out1.messagingengine.com (Postfix) with ESMTP id A559A177C52
	for <linux-dvb@linuxtv.org>; Mon,  6 Oct 2008 19:04:12 -0400 (EDT)
Message-Id: <1223334252.12152.1277866355@webmail.messagingengine.com>
From: "petercarm" <linuxtv@hotair.fastmail.co.uk>
To: linux-dvb@linuxtv.org
Content-Disposition: inline
MIME-Version: 1.0
Date: Tue, 07 Oct 2008 00:04:12 +0100
Subject: [linux-dvb] Why doesn't dmesg tell me my Nova-TD USB has an IR
	receiver?
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

I've been pretty successful in getting the stable drivers to run my
Hauppauge Nova-TD USB stick.  The build is a minimal boot-from-flash/PXE
Gentoo MythTV image that I have brewed up myself, running on a VIA Epia
SP motherboard.

Kernel is 2.6.25-r7.

I've got both tuners working well simultaneously.  The only thing is
that dmesg is not reporting the presence of any sort of IR receiver. 
The unit came in a retail box with a remote control.

What dependencies does the IR receiver element of the Hauppauge stick
have on the kernel?  All my web searches for problems with IR from this
card always start with dmesg saying:

[...]
input: IR-receiver inside an USB DVB receiver as /class/input/...
[...]

This is exactly what I'm not getting.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
