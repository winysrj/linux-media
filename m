Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1LAXCw-0003zX-8J
	for linux-dvb@linuxtv.org; Wed, 10 Dec 2008 23:07:06 +0100
Date: Wed, 10 Dec 2008 23:06:21 +0100 (CET)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: linux-dvb@linuxtv.org
Message-ID: <alpine.LRH.1.10.0812101628500.23745@pub3.ifh.de>
MIME-Version: 1.0
Cc: Zinne Enrico <enrico.zinne@gmx.de>, Uwe Bugla <uwe.bugla@gmx.de>
Subject: [linux-dvb] Technisat SkyStar2 rev 2.8 GPL driver now available
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

Hi all,

Finally and with pleasure, I can announce that I just released the last 
missing piece to add full GPL support to LinuxTV for the Technisat 
SkyStar2 rev2.8. The last missing piece in question was the driver for the 
CX24113 tuner. I just committed the source for that into my repository and 
will ask Mauro to pull it into the main soon. 
(http://linuxtv.org/hg/~pb/v4l-dvb/)

Expect support for this card in 2.6.29 .

happy using and best regards,
Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
