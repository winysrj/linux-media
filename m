Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout5.freenet.de ([195.4.92.95])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <volkdir@freenet.de>) id 1MWrVk-0003RF-FZ
	for linux-dvb@linuxtv.org; Fri, 31 Jul 2009 14:47:01 +0200
Received: from [195.4.92.12] (helo=2.mx.freenet.de)
	by mout5.freenet.de with esmtpa (ID volkdir@freenet.de) (port 25) (Exim
	4.69 #92) id 1MWrVg-0008IE-UG
	for linux-dvb@linuxtv.org; Fri, 31 Jul 2009 14:46:57 +0200
Received: from web8.emo.freenet-rz.de ([194.97.107.224]:44297)
	by 2.mx.freenet.de with esmtpa (ID volkdir@freenet.de) (port 25) (Exim
	4.69 #93) id 1MWrVg-0001kq-Ox
	for linux-dvb@linuxtv.org; Fri, 31 Jul 2009 14:46:56 +0200
Received: from localhost ([127.0.0.1] helo=emo.freenet.de)
	by web8.emo.freenet-rz.de with esmtpa (Exim 4.69 1 (Panther_1))
	id 1MWrVa-0007Gr-7m
	for <linux-dvb@linuxtv.org>; Fri, 31 Jul 2009 14:46:56 +0200
Date: Fri, 31 Jul 2009 14:46:50 +0200
From: volkdir@freenet.de
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-Id: <c20d709523f44d30842f03fc7fcf7d52@email.freenet.de>
Subject: [linux-dvb] Problems with Geniatech Digistar
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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



I bought a very cheap satellite card, geniatech digistar
(20 &#65533;) and now I have some trouble with it.

In the linux tv wiki it is mentioned that the card should
work:



http://www.linuxtv.org/wiki/index.php/Geniatech_DVB-S_Digistar



Scanning for programs with scan



scan /usr/share/dvb/dvb-s/Astra-19.2E >.szap/channels.conf



only get a subset what should be available. Some major
german channels (ARD, RTL, ...) are missing.

The channels reported by scan work normally, if I szap to
them and write them via dvbstrem to a file

szap -r "Sky Select" &

dvbstream 2815 -o >test.mpg



Putting the card into an windows xp box I see the missing
channels.



Connection a normal sat receiver to the same port of the
multiswitch shows all channels.



Any ideas what I can do to get it work?



Best regards,

Dirk





Here some data of my system:



Linux version 2.6.26-2-amd64 (Debian 2.6.26-17lenny1)

Asus Mainboard with AMD Athlon(tm) X2 Dual Core Processor
BE-2300 stepping 02



The card is autodetected with:

202790] DVB: registering new adapter (cx88[0])
202799] DVB: registering frontend 0 (Conexant
CX24123/CX24109)...
470614] cx88/2: unregistering cx8802 driver, type: dvb
access: shared
470623] cx88[0]/2: subsystem: 14f1:0084, board: Geniatech
DVB-S [card=52]
180056] cx88/2: cx2388x dvb driver version 0.0.6 loaded
180065] cx88/2: registering cx8802 driver, type: dvb
access: shared
180069] cx88[0]/2: subsystem: 14f1:0084, board: Geniatech
DVB-S [card=52]
180074] cx88[0]/2: cx2388x based DVB/ATSC card
180552] CX24123: detected CX24123










Heute schon ge"freeMail"t?
Jetzt kostenlose E-Mail-Adresse sichern!
http://email.freenet.de/dienste/emailoffice/produktuebersicht/basic/mail/index.html?pid=6831


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
