Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.adamomail.se ([87.251.223.195] helo=adamomail.se)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sacha@hemmail.se>) id 1KVZHS-0001cW-4J
	for linux-dvb@linuxtv.org; Wed, 20 Aug 2008 00:02:22 +0200
Received: from [89.233.192.163] (account sacha@hemmail.se HELO [192.168.1.6])
	by adamomail.se (CommuniGate Pro SMTP 4.2.10)
	with ESMTP id 17455950 for linux-dvb@linuxtv.org;
	Wed, 20 Aug 2008 00:02:14 +0200
From: sacha <sacha@hemmail.se>
To: linux-dvb@linuxtv.org
Date: Wed, 20 Aug 2008 00:02:14 +0200
Message-Id: <1219183334.6734.3.camel@lanbox>
Mime-Version: 1.0
Subject: [linux-dvb] Mantis loading errors.
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

I have compiled latest Mantis driver on my 64-bit Ubuntu 8.04 and see
this message from dmesg:
[   90.229741] mantis: disagrees about version of symbol
dvb_unregister_frontend
[   90.229743] mantis: Unknown symbol dvb_unregister_frontend
[   90.229858] mantis: disagrees about version of symbol
dvb_register_frontend
[   90.229860] mantis: Unknown symbol dvb_register_frontend

what does it mean?

KR

N.B.
Musty say, never been before with so badly managed project.
Sorry!


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
