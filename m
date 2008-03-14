Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from psmtp30.wxs.nl ([195.121.247.32])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jan-conceptronic@h-i-s.nl>) id 1JaGih-0007j2-1N
	for linux-dvb@linuxtv.org; Fri, 14 Mar 2008 21:41:39 +0100
Received: from his01.frop.org (ip545779c6.direct-adsl.nl [84.87.121.198])
	by psmtp30.wxs.nl
	(iPlanet Messaging Server 5.2 HotFix 2.15 (built Nov 14 2006))
	with ESMTP id <0JXQ002Y7MSGUQ@psmtp30.wxs.nl> for linux-dvb@linuxtv.org;
	Fri, 14 Mar 2008 21:41:04 +0100 (MET)
Received: from [10.0.0.151] (his08.frop.org [10.0.0.151])
	by his01.frop.org (8.11.0/8.11.0) with ESMTP id m2EKf4h01716	for
	<linux-dvb@linuxtv.org>; Fri, 14 Mar 2008 21:41:04 +0100
Date: Fri, 14 Mar 2008 21:41:04 +0100
From: Jan Hoogenraad <jan-conceptronic@h-i-s.nl>
To: linux-dvb@linuxtv.org
Message-id: <47DAE2E0.2090400@h-i-s.nl>
MIME-version: 1.0
Subject: [linux-dvb] Help requested on removing behavior
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


We are working now on the support for a new device (RTL2831U DVB-T 
USB2.0 DEVICE).
We get a lot of help from the tech support people.

Now they have asked me a question that I cannot answer, and I don't know 
if there is documentation on this.

The version now behaves as follows>
When the stick is inserted, the module is loaded (usage count 0 in lsmod).
When the stick is removed, the module stays loaded (usage count 0 in 
lsmod), and when it is re-inserted, the driver works again.

When Kaffeine is started with the driver in memory, but the stick 
unplugged, Kaffeine senses that the device is unplugged, and does not 
show the DVB capability.

When Kaffeine is running, and the stick is removed during that, the 
video freezes.
Re-instering the stick does not cause the video to become "live" again.
After re-inserting the stick, Kaffeine recognizes that it's there again, 
and functions again.

Can anybody confirm me that this is the specified behavior and/or send 
me the place where I can find these specifications ?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
