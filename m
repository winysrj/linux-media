Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ns3.belkam.com ([87.249.237.18] helo=relay2.belkam.com)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dm@belkam.com>) id 1JsK73-00014d-En
	for linux-dvb@linuxtv.org; Sat, 03 May 2008 17:57:26 +0200
Received: from localhost (localhost [127.0.0.1])
	by relay2.belkam.com (Postfix) with ESMTP id D3F93216132
	for <linux-dvb@linuxtv.org>; Sat,  3 May 2008 20:56:48 +0500 (SAMST)
Received: from relay2.belkam.com ([127.0.0.1])
	by localhost (mandela.p98.belkam.com [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id NKo8fA59r+-c for <linux-dvb@linuxtv.org>;
	Sat,  3 May 2008 20:56:45 +0500 (SAMST)
Received: from [192.168.31.38] (unknown [192.168.31.38])
	by relay2.belkam.com (Postfix) with ESMTP
	for <linux-dvb@linuxtv.org>; Sat,  3 May 2008 20:56:44 +0500 (SAMST)
Message-ID: <481C8B39.1020509@belkam.com>
Date: Sat, 03 May 2008 20:56:41 +0500
From: Dmitry Melekhov <dm@belkam.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] kernel 2.6.24 and dvb_shutdown_timeout=0 problem
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

Hello!

I just upgraded my desktop to ubuntu 8.04 and found that I can't get my 
sat internet working.

cat /sys/module/dvb_core/parameters/dvb_shutdown_timeout
0


using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 01 | signal a285 | snr 7311 | ber 00003d2a | unc 00000000 |
status 1f | signal b20d | snr c0bd | ber 00000166 | unc 00000000 | 
FE_HAS_LOCK
using '/dev/dvb/adapter0/frontend0'
FE: ST STV0299 DVB-S (SAT)
status 1f | signal b2c1 | snr c0c3 | ber 00000000 | unc 00000000 | 
FE_HAS_LOCK
status 03 | signal 9f5e | snr 0000 | ber 00008080 | unc 00000000 |
status 03 | signal 9f5e | snr 0000 | ber 00008080 | unc 00000000 |



This is similar to what we had before, with 5 second default timeout.
But other, non-zero, timeouts work correctly.

I looked into dvb_frontend.c and found that there are some changes 
regarding dvb_shutdown_timeout.
Unfortunately, I can't find why dvb_shutdown_timeout=0 doesn't mean 
"work forever" now.

Could you tell me how can I fix it and use sat internet again ? :-)

Thank you!


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
