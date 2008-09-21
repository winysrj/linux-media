Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]
	helo=sasl.smtp.pobox.com) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <torgeir@pobox.com>) id 1KhHTw-0006qF-51
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 07:27:42 +0200
Received: from localhost.localdomain (localhost [127.0.0.1])
	by a-sasl-fastnet.sasl.smtp.pobox.com (Postfix) with ESMTP id
	7F91D63D42
	for <linux-dvb@linuxtv.org>; Sun, 21 Sep 2008 01:27:14 -0400 (EDT)
Received: from [192.168.1.12] (ppp118-208-39-114.lns3.bne1.internode.on.net
	[118.208.39.114]) (using TLSv1 with cipher AES128-SHA (128/128 bits))
	(No
	client certificate requested) by a-sasl-fastnet.sasl.smtp.pobox.com
	(Postfix)
	with ESMTPSA id C597463D41 for <linux-dvb@linuxtv.org>; Sun, 21 Sep 2008
	01:27:13 -0400 (EDT)
Message-Id: <C8AA13C7-C91C-457F-A53D-386F74787902@pobox.com>
From: Torgeir Veimo <torgeir@pobox.com>
To: linux-dvb <linux-dvb@linuxtv.org>
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Sun, 21 Sep 2008 15:27:06 +1000
Subject: [linux-dvb] skystar 2 usb IR receiver with other remotes
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

I'm looking for information about how to use a skystar 2 usb IR remote  
sensor, type USB IR receiver 0900/3704, with other remotes than the  
originally supplied Technisat TTS35AI remote. I think this remote is  
using RC5 signalling, and that the recognised keys are hard coded in  
the kernel driver? Or are they simply hard coded in the USB IR  
receiver itself? I was hoping to use it as a generic RC5 receiver with  
lirc.

lsusb says;

[...]
Bus 006 Device 021: ID 147a:e02d Formosa Industrial Computing, Inc.

-- 
Torgeir Veimo
torgeir@pobox.com





_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
