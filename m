Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp.seznam.cz ([77.75.72.43])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oldium.pro@seznam.cz>) id 1L8JAh-0006T9-5t
	for linux-dvb@linuxtv.org; Thu, 04 Dec 2008 19:43:32 +0100
From: Oldrich Jedlicka <oldium.pro@seznam.cz>
To: linux-dvb@linuxtv.org
Date: Thu, 4 Dec 2008 19:41:46 +0100
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812041941.47145.oldium.pro@seznam.cz>
Subject: [linux-dvb] AverMedia CardBus E501R/E506R remote control
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

Hi all,

Had anybody tried to figure out how the remote control interacts with the 
card? My old E501R has remote control with chip RT1221 that generates 0.56ms 
long pulses with variable length space (1.12ms for "0", 2.24ms for "1"). I 
guess E506R has the same chip, but I do not want to open it (that breaks 
warranty).

If anybody had success getting those pulses on some GPIO bit, please let me 
know. The protocol decoding is rather easy, but I was not able to get the raw 
bits.

Regards,
Oldrich.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
