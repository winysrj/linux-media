Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <paul@whitelands.org.uk>) id 1O2g1h-00020U-Ha
	for linux-dvb@linuxtv.org; Fri, 16 Apr 2010 09:31:49 +0200
Received: from smarthost02.mail.zen.net.uk ([212.23.3.141])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1O2g1g-00067Z-35; Fri, 16 Apr 2010 09:31:45 +0200
Received: from [217.155.39.57] (helo=proxyplus.universe)
	by smarthost02.mail.zen.net.uk with esmtp (Exim 4.63)
	(envelope-from <paul@whitelands.org.uk>) id 1O2g1f-0004Mo-LW
	for linux-dvb@linuxtv.org; Fri, 16 Apr 2010 07:31:43 +0000
Received: from 127.0.0.1 [127.0.0.1] by Proxy+ with ESMTP
	for <linux-dvb@linuxtv.org>; Fri, 16 Apr 2010 08:31:43 +0100
Message-ID: <4BC8125F.6000203@whitelands.org.uk>
Date: Fri, 16 Apr 2010 08:31:43 +0100
From: Paul Shepherd <paul@whitelands.org.uk>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Tevii S660 USB card and dw2102 module generating RC
	messages
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


I have a Tevii S660 (a usb dvb-s2 device) which is causing a problem.

After the S660 is attached to a USB 2 socket, the firmware is d/l and 
everything looks fine but then there are continual RC (check/debug?) 
messages every 150 ms, then some time later everything goes pear shaped, 
see http://pastebin.com/r9DtUaqX

Tevii think the h/w is ok as it works in a Windows box with their 
myTevii application.  It does work with Ubuntu while the RC messages are 
occurring, I can watch and record SD+HD content in mythtv until the crash.

I have tried the latest tevii beta s/w (v4l and .fw files) and also the 
v4l-dvb drivers from linuxtv dated 6 april - the same result each time. 
  I can see in the dw2102.c where 150ms is defined and this seems the 
same as other devices in the code.

Google suggests that others have seen the problem but it's not clear 
what the solution is.

Three questions:

1) are the RC messages caused by a h/w or s/w issue?

2) if its s/w what do I need to do?

3) is the subsequent khubd crash related and how do I fix that?

I have a nova dvb-t usb box connected and that works fine - I assume 
there's no interaction.

I am running Ubuntu 9.10 with the following kernel:

Linux antec300.home.org 2.6.31-20-generic #57-Ubuntu SMP Mon Feb 8 
09:05:19 UTC 2010 i686 GNU/Linux

thanks for any suggestions, paul



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
