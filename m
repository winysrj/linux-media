Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas@boerkel.de>) id 1KTYls-0005iI-P7
	for linux-dvb@linuxtv.org; Thu, 14 Aug 2008 11:05:29 +0200
Received: from backend.localdomain
	(p54A30832.dip0.t-ipconnect.de [84.163.8.50])
	by post.webmailer.de (klopstock mo56) (RZmta 16.47)
	with ESMTP id 501279k7E7EqtW for <linux-dvb@linuxtv.org>;
	Thu, 14 Aug 2008 11:05:25 +0200 (MEST)
	(envelope-from: <thomas@boerkel.de>)
Received: from [10.1.81.46] (unknown [195.243.151.195])
	by backend.localdomain (Postfix) with ESMTP id 12977245BC8
	for <linux-dvb@linuxtv.org>; Thu, 14 Aug 2008 11:05:25 +0200 (CEST)
Message-ID: <48A3F54E.40709@boerkel.de>
Date: Thu, 14 Aug 2008 11:05:18 +0200
From: =?ISO-8859-1?Q?Thomas_B=F6rkel?= <thomas@boerkel.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Nova-S Plus questions
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

HI!

I exchanged my TT 1500 cards for Nova-S Plus cards because of glitches 
in recordings every now and then.

The Novas seem to work fine, however there are some strange things:

The cards report signal strength 98% and snr 99%. This can't be right.

UNC reporting apparently does not work.

dvbsnoop -s signal also does not work (unsupported or adapter in use).

I am using kernel 2.6.23.

Any hints/info on these issues would be greatly appreciated.

Thanks!

Thomas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
