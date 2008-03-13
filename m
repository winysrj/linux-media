Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.183])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JZvCq-0003LH-J6
	for linux-dvb@linuxtv.org; Thu, 13 Mar 2008 22:43:25 +0100
Received: by py-out-1112.google.com with SMTP id a29so4130164pyi.0
	for <linux-dvb@linuxtv.org>; Thu, 13 Mar 2008 14:43:11 -0700 (PDT)
Message-ID: <47D99FE8.80903@googlemail.com>
Date: Thu, 13 Mar 2008 21:43:04 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb]  Implementing support for multi-channel
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

 > -----Original Message-----
 > Thank you everybody for the answers so far, I do have enough software-based
 > solutions to start testing.
 > However, there's still the question: can filtering be done in the driver?

Have you read my last post?

http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024456.html

When I talk about filter, demux, dvr, this is all in the kernel driver for the dvb.

You can find here an example of how to open the demux to get 1 PID.
You can run it multiple times and get as many streams as you want

http://www.audetto.pwp.blueyonder.co.uk/dvb.cpp

 > Are there any drivers that support this or which dvb-api-functions need to
 > be implemented?

If you want to extend the driver for the dvb, I'd like to be able to set a filter in the demux for 
more that 1 pid at a time.

Good luck.

Andrea

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
