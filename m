Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from znsun1.ifh.de ([141.34.1.16])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <patrick.boettcher@desy.de>) id 1Jic6s-0007JS-Om
	for linux-dvb@linuxtv.org; Sun, 06 Apr 2008 23:09:07 +0200
Received: from pub5.ifh.de (pub5.ifh.de [141.34.15.197])
	by znsun1.ifh.de (8.12.11.20060614/8.12.11) with ESMTP id
	m36L8THw025998
	for <linux-dvb@linuxtv.org>; Sun, 6 Apr 2008 23:08:29 +0200 (MEST)
Received: from localhost (localhost [127.0.0.1])
	by pub5.ifh.de (Postfix) with ESMTP id 49EBC1F0192
	for <linux-dvb@linuxtv.org>; Sun,  6 Apr 2008 23:08:29 +0200 (CEST)
Date: Sun, 6 Apr 2008 23:08:29 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: linux-dvb@linuxtv.org
Message-ID: <Pine.LNX.4.64.0804062304020.6749@pub5.ifh.de>
MIME-Version: 1.0
Subject: [linux-dvb] Non-regression testers for Hauppauge/TT Nova-S SE needed
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

Hi,

in order to add support for another device based on the s5h1420 demod. I 
changed the driver for that component quite heavily and now I would like 
to know, whether I broke something or not:

I would highly appreciate if someone who owns the mentioned device could 
try the following repository:

http://linuxtv.org/hg/~pb/v4l-dvb/

and report whether the card still works.

Thanks a lot in advance,
Patrick.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
