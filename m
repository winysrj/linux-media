Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dd6832.kasserver.com ([85.13.131.133])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <xxx@muad-dib.net>) id 1KHKes-0006QQ-8m
	for linux-dvb@linuxtv.org; Fri, 11 Jul 2008 17:35:44 +0200
Received: from [192.168.0.90] (dslb-092-072-015-081.pools.arcor-ip.net
	[92.72.15.81])
	by dd6832.kasserver.com (Postfix) with ESMTP id A7108C875A
	for <linux-dvb@linuxtv.org>; Fri, 11 Jul 2008 17:35:38 +0200 (CEST)
Message-ID: <48777DC7.1020904@muad-dib.net>
Date: Fri, 11 Jul 2008 17:35:35 +0200
From: "xxx@muad-dib.net" <xxx@muad-dib.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem with Terratec Cinergy T USB XXS Remote Control
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

Everthing is running fine but I can't config the ir-remote, some keys 
are working in VDR like: up, down, left, ok and the numberkeys.
dmesg gives me something like this on the other ~33 keys.

dib0700: Unknown remote controller key:  D 71  1  0
dib0700: Unknown remote controller key:  9 40  1  0
dib0700: Unknown remote controller key:  7 2C  1  0
dib0700: Unknown remote controller key:  2  5  0  0

The remote control looks like the one from Cinergy DT USB XS Diversity 
and Cinergy T USB XS FM.
I use the lates modules from http://linuxtv.org/hg/v4l-dvb and latest 
kernel on my Gentoo system linux-2.6.26-rc8
I think there are some entries missing in dib0700.devices.c, but i can 
figure out how they must look like.

Thanks very mucht for any help and for your good work :-)

Greetings Sebastian

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
