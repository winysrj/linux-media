Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <thomas@boerkel.de>) id 1KUx47-0007jh-RC
	for linux-dvb@linuxtv.org; Mon, 18 Aug 2008 07:14:06 +0200
Received: from backend.localdomain
	(p54A322F1.dip0.t-ipconnect.de [84.163.34.241])
	by post.webmailer.de (mrclete mo35) (RZmta 16.47)
	with ESMTP id a029a1k7I1kUBH for <linux-dvb@linuxtv.org>;
	Mon, 18 Aug 2008 07:14:00 +0200 (MEST)
	(envelope-from: <thomas@boerkel.de>)
Received: from [192.168.0.2] (linux [192.168.0.2])
	by backend.localdomain (Postfix) with ESMTP id 35DFA245BC8
	for <linux-dvb@linuxtv.org>; Mon, 18 Aug 2008 07:14:00 +0200 (CEST)
Message-ID: <48A90517.9000109@boerkel.de>
Date: Mon, 18 Aug 2008 07:13:59 +0200
From: =?ISO-8859-1?Q?Thomas_B=F6rkel?= <thomas@boerkel.de>
MIME-Version: 1.0
To: linux-dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] A/V sync issues with DVB-S
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

Is it normal, that every now and then (1-2 of 10 recordings), I get one
serious (suddenly 30 frames off) A/V sync problem with DVB-S?

I am seeing this with TT 1500 (budget_ci) and Nova-S Plus (cx88). I
tested kernel 2.6.23 and 2.6.25.

OK, when playing this recording with mplayer, I see no glitch and no
warnings.

But when I play it with MythTV, it stutters for a few seconds when it
tries to softly match the sync.

I haven't seen this with DVB-C, so I'd like to know if something is
wrong with my SAT system.

Any help would be greatly appreciated.

Thanks!

Thomas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
