Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [88.151.248.2] (helo=mail.krastelcom.ru)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vpr@krastelcom.ru>) id 1KAezY-0007PB-O3
	for linux-dvb@linuxtv.org; Mon, 23 Jun 2008 07:53:29 +0200
Message-Id: <36ADB82E-9B62-4847-BB60-0AD1AB572391@krastelcom.ru>
From: Vladimir Prudnikov <vpr@krastelcom.ru>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
Mime-Version: 1.0 (Apple Message framework v924)
Date: Mon, 23 Jun 2008 09:53:24 +0400
Subject: [linux-dvb] Express AM2 11044 H 45 MSps
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

Hi!

I have recently realized that none of the available cards are able to  
properly lock on Express AM2 11044H 45 MSps . The only one that can is  
TT-S1401 with buf[5] register corrections.

I have tried:

TT S-1500
TT S2-3200
Skystar 2.6
TT S-1401 with non-modified drivers.

Regards,
Vladimir

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
