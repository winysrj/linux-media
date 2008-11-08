Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from zim.mi-connect.com ([208.73.200.230])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ron@rongage.org>) id 1KyebM-00007D-UJ
	for linux-dvb@linuxtv.org; Sat, 08 Nov 2008 04:35:10 +0100
Received: from localhost (localhost.localdomain [127.0.0.1])
	by zim.mi-connect.com (Postfix) with ESMTP id 3AE6223387A8
	for <linux-dvb@linuxtv.org>; Fri,  7 Nov 2008 22:16:55 -0500 (EST)
Received: from zim.mi-connect.com ([127.0.0.1])
	by localhost (zim.mi-connect.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oxHwV-o5kB4n for <linux-dvb@linuxtv.org>;
	Fri,  7 Nov 2008 22:16:54 -0500 (EST)
Received: from [192.168.10.129] (unknown [68.40.223.224])
	by zim.mi-connect.com (Postfix) with ESMTP id 1619B23386FD
	for <linux-dvb@linuxtv.org>; Fri,  7 Nov 2008 22:16:54 -0500 (EST)
Message-ID: <49150AF1.5060601@rongage.org>
Date: Fri, 07 Nov 2008 22:43:45 -0500
From: Ron Gage <ron@rongage.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] crash issue with dvbstream
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

I am having problems with dvbstream segfaulting.  The segfaults are 
occurring at line 635 of dvbstream.c - PAT.entries[] are basically NULL 
causing the segfault.

I was asked by mrec on the IRC channel to make a ts dump of the video 
signal I am trying to stream.  That stream is at 
http://www.mi-connect.com/crash.ts.  This dump file is roughly 224 meg 
in size.

Let me know if I can help in finding this problem.

Ron Gage
Westland, MI


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
