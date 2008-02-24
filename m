Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.176])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mariofutire@googlemail.com>) id 1JTPIR-0007LN-H5
	for linux-dvb@linuxtv.org; Sun, 24 Feb 2008 23:26:11 +0100
Received: by py-out-1112.google.com with SMTP id a29so1418954pyi.0
	for <linux-dvb@linuxtv.org>; Sun, 24 Feb 2008 14:26:07 -0800 (PST)
Message-ID: <47C1EEFB.7020600@googlemail.com>
Date: Sun, 24 Feb 2008 22:26:03 +0000
From: Andrea <mariofutire@googlemail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Length of /dev/dvb/adapter0/dvr0's buffer.
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

I'm trying to read from /dev/dvb/adapter0/dvr0.
The problem is that the process reading sometimes is not fast enough and after a while I get errno 
75 when I try to read from it.

On average the speed is ok, so it should work.
There must be a buffer behind dvr0 that goes in error onece it is full.

1) how can I make it bigger?
2) how can I check how full it is?

Andrea

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
