Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail1.perspektivbredband.net ([81.186.254.13])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <p.blomqvist@lsn.se>) id 1JO2tQ-0003NV-WF
	for linux-dvb@linuxtv.org; Sun, 10 Feb 2008 04:30:13 +0100
Received: from [192.168.2.103]
	(201.4.185.213.se-stf.res.dyn.perspektivbredband.net [213.185.4.201])
	by mail1.perspektivbredband.net (Postfix) with ESMTP id 52AEE18E032E
	for <linux-dvb@linuxtv.org>; Sun, 10 Feb 2008 04:29:42 +0100 (CET)
Message-ID: <47AE6FAD.7090909@lsn.se>
Date: Sun, 10 Feb 2008 04:29:49 +0100
From: Per Blomqvist <p.blomqvist@lsn.se>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] I cant view the video (again) saa7134 (..)
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
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello, again.
(I have reinstalled my system, and tested Ubunto also today. Same 
problem there)

I cant view the video.
(But I can tune)

What can I do?

modinfo saa7134, gives alot of debugging options.
(I tested a few, thought I saw an error for some device, but cant 
replicate it)

My system, is kernel-2.6.22, on some Amd.. Media-card ":
http://www.linuxtv.org/wiki/index.php/Asus_My_Cinema-P7131_Hybrid

lsmod: (ahg

Im say its the "/dev/dvb/adapter0/dvr0", thats invalid.

Are there any elegant way, to sortout all kernel-modules taht handle 
this device?

HELP!



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
