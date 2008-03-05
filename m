Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from machts.net ([213.133.110.14] helo=mail.machts.net)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@machts.net>) id 1JX21l-0008Oh-AZ
	for linux-dvb@linuxtv.org; Wed, 05 Mar 2008 23:23:58 +0100
Received: from localhost (localhost [127.0.0.1])
	by mail.machts.net (Postfix) with ESMTP id 0EC9E1031FEF
	for <linux-dvb@linuxtv.org>; Wed,  5 Mar 2008 23:23:54 +0100 (CET)
Received: from mail.machts.net ([127.0.0.1])
	by localhost (machts.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ILZJKn89M1xM for <linux-dvb@linuxtv.org>;
	Wed,  5 Mar 2008 23:19:07 +0100 (CET)
Received: from [192.168.1.132] (unknown [84.114.50.236])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.machts.net (Postfix) with ESMTP id 6FB681031FE8
	for <linux-dvb@linuxtv.org>; Wed,  5 Mar 2008 23:19:07 +0100 (CET)
Message-ID: <47CF1C5A.9050306@machts.net>
Date: Wed, 05 Mar 2008 23:19:06 +0100
From: Paul Leitner <linux-dvb@machts.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb]  [PATCH] support Cinergy HT USB XE (0ccd:0058)
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

Hi there!

I was totally happy when I found this patch through the wiki.

Everything went pretty smooth. After i found the right firmware, 
scanning in Kaffeine worked for me.

But there is another question:
This USB Stick is a hybrid one. Due to this i also gave xawtv a try, but 
after some logfile-watching I noticed the /dev/video0 is missing.
Is the current firmware for the tuner only capable of DVB-T or is there 
a possibilty to get analogue TV working too?
I'm asking this because I live in Vienna and I'v got analogue cable here 
would be nice to record and watch on the PC.

Thanks for help. ;)

Paul

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
