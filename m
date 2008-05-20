Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1JySqv-0003Ho-Bw
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 16:30:14 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K1600KSO899Q3O0@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 20 May 2008 10:29:33 -0400 (EDT)
Date: Tue, 20 May 2008 10:29:32 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <25670.1211292560@kewl.org>
To: Darron Broad <darron@kewl.org>
Message-id: <4832E04C.9090506@linuxtv.org>
MIME-version: 1.0
References: <E1JyRpw-0001jr-00.goga777-bk-ru@f121.mail.ru>
	<25670.1211292560@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] new firmware for HVR-1100/1300/3000/4000 &
 Nova-T/S-PCI/HD_S2
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

Darron Broad wrote:
> In message <E1JyRpw-0001jr-00.goga777-bk-ru@f121.mail.ru>, Igor wrote:
>> Hi
> 
> lo
> 
>> http://www.hauppauge.co.uk/pages/support/support_driversonly.html
>> here you can find the updated firmware version for  HVR-1100/1300/3000/4000 & Nova-T/S-PCI/HD_S2
>> Version 2.122.26109 (1.39Mb)
> 
> to extract for the cx24116 try this:
> 
> (FW version 1.22.82.0, previously 1.20.79.0)
> 
> dd if=hcw88bda.sys of=dvb-fe-cx24116.fw skip=75504 bs=1 count=32501
> 
> What difference it makes is unknown.

You could just ask ;)

This does not contain any new firmware.

The best and latest firmware is still from www.steventoth.net/linux/cx24116

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
