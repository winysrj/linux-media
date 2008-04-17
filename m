Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mailhost.tue.nl ([131.155.2.19])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bas@kompasmedia.nl>) id 1JmSen-0007Lk-5H
	for linux-dvb@linuxtv.org; Thu, 17 Apr 2008 13:52:05 +0200
Received: from localhost (localhost [127.0.0.1])
	by mailhost.tue.nl (Postfix) with ESMTP id D4A6A5C076
	for <linux-dvb@linuxtv.org>; Thu, 17 Apr 2008 13:51:24 +0200 (CEST)
Received: from mailhost.tue.nl ([131.155.2.19])
	by localhost (pastinakel.tue.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FsDcrBkTq8nJ for <linux-dvb@linuxtv.org>;
	Thu, 17 Apr 2008 13:51:24 +0200 (CEST)
Received: from [131.155.156.90] (KC14189.buro.tue.nl [131.155.156.90])
	by mailhost.tue.nl (Postfix) with ESMTP id 9D7165C068
	for <linux-dvb@linuxtv.org>; Thu, 17 Apr 2008 13:51:24 +0200 (CEST)
Message-ID: <480739BC.9010002@kompasmedia.nl>
Date: Thu, 17 Apr 2008 13:51:24 +0200
From: "Bas v.d. Wiel" <bas@kompasmedia.nl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Mantis 2033 crashes
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

Last night I tried the suggestions that were posted here concerning the 
mantis 2033. Nothing worked, dvb-scan still gives me a long stream of 
'tuning failed!!!' warnings.

I tried using the very latest code from Manu that has some beginning 
support for the CI module. This only crashes the mantis module with a 
huge error message (I'll post the exact error later, can't access the 
machine right now) as soon as I insert my Alphacrypt. Same happens when 
I switch the PC on with the cam already inserted. When there's nothing 
in the CI slot, everything loads up alright and the CA device gets 
registered properly. Still no tuning though..

If there's anything I can do to help debug this driver, I'd be happy 
to.. Windows is getting on my nerves.

Bas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
