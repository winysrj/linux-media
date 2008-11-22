Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from crow.cadsoft.de ([217.86.189.86] helo=raven.cadsoft.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Klaus.Schmidinger@cadsoft.de>) id 1L3rGr-0007O1-Ab
	for linux-dvb@linuxtv.org; Sat, 22 Nov 2008 13:07:30 +0100
Received: from [192.168.100.10] (hawk.cadsoft.de [192.168.100.10])
	by raven.cadsoft.de (8.14.3/8.14.3) with ESMTP id mAMC7P6J005785
	for <linux-dvb@linuxtv.org>; Sat, 22 Nov 2008 13:07:25 +0100
Message-ID: <4927F5FD.5080805@cadsoft.de>
Date: Sat, 22 Nov 2008 13:07:25 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] S2API: problem unloading dvb_ttpci
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

I'm making my first steps in using the S2API driver, and already
have a problem. When trying to do

  /sbin/rmmod dvb_ttpci

I get the error

  ERROR: Removing 'dvb_ttpci': Device or resource busy

'lsmod' shows

  Module                  Size  Used by
  dvb_ttpci             348748  0

So who is using dvb_ttpci?

BTW: this worked fine with the 'multiproto' driver ;-)

Klaus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
