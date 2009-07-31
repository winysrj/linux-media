Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:60478 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbZGaNIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jul 2009 09:08:38 -0400
Received: from [195.4.92.17] (helo=7.mx.freenet.de)
	by mout4.freenet.de with esmtpa (ID volkdir@freenet.de) (port 25) (Exim 4.69 #92)
	id 1MWrqg-0005AP-8Y
	for linux-media@vger.kernel.org; Fri, 31 Jul 2009 15:08:38 +0200
Received: from web3.emo.freenet-rz.de ([194.97.107.236]:33083)
	by 7.mx.freenet.de with esmtpa (ID volkdir@freenet.de) (port 25) (Exim 4.69 #93)
	id 1MWrqg-0003GP-6L
	for linux-media@vger.kernel.org; Fri, 31 Jul 2009 15:08:38 +0200
Received: from localhost ([127.0.0.1] helo=emo.freenet.de)
	by web3.emo.freenet-rz.de with esmtpa (Exim 4.69 1 (Panther_1))
	id 1MWrqe-0006nj-38
	for <linux-media@vger.kernel.org>; Fri, 31 Jul 2009 15:08:36 +0200
Date: Fri, 31 Jul 2009 15:08:36 +0200
From: volkdir@freenet.de
Subject: FW: Problems with Geniatech Digistar
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Message-Id: <804e4009d17267e3b0b3799135e1fec3@email.freenet.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


 > Hi,
 > 
 > 
 > 
 > I bought a very cheap satellite card, geniatech
digistar
 > (20 EUR) and now I have some trouble with it.
 > 
 > In the linux tv wiki it is mentioned that the card
should
 > work:
 > 
 > 
 > 
 >
http://www.linuxtv.org/wiki/index.php/Geniatech_DVB-S_Digistar
 > 
 > 
 > 
 > Scanning for programs with scan
 > 
 > 
 > 
 > scan /usr/share/dvb/dvb-s/Astra-19.2E
>.szap/channels.conf
 > 
 > 
 > 
 > only get a subset what should be available. Some major
 > german channels (ARD, RTL, ...) are missing.
 > 
 > The channels reported by scan work normally, if I szap
to
 > them and write them via dvbstrem to a file
 > 
 > szap -r "Sky Select" &
 > 
 > dvbstream 2815 -o >test.mpg
 > 
 > 
 > 
 > Putting the card into an windows xp box I see the
missing
 > channels.
 > 
 > 
 > 
 > Connection a normal sat receiver to the same port of
the
 > multiswitch shows all channels.
 > 
 > 
 > 
 > Any ideas what I can do to get it work?
 > 
 > 
 > 
 > Best regards,
 > 
 > Dirk
 > 
 > 
 > 
 > 
 > 
 > Here some data of my system:
 > 
 > 
 > 
 > Linux version 2.6.26-2-amd64 (Debian 2.6.26-17lenny1)
 > 
 > Asus Mainboard with AMD Athlon(tm) X2 Dual Core
Processor
 > BE-2300 stepping 02
 > 
 > 
 > 
 > The card is autodetected with:
 > 
 > 202790] DVB: registering new adapter (cx88[0])
 > 202799] DVB: registering frontend 0 (Conexant
 > CX24123/CX24109)...
 > 470614] cx88/2: unregistering cx8802 driver, type: dvb
 > access: shared
 > 470623] cx88[0]/2: subsystem: 14f1:0084, board:
Geniatech
 > DVB-S [card=52]
 > 180056] cx88/2: cx2388x dvb driver version 0.0.6 loaded
 > 180065] cx88/2: registering cx8802 driver, type: dvb
 > access: shared
 > 180069] cx88[0]/2: subsystem: 14f1:0084, board:
Geniatech
 > DVB-S [card=52]
 > 180074] cx88[0]/2: cx2388x based DVB/ATSC card
 > 180552] CX24123: detected CX24123





Gratis: Jeden Monat 3 SMS versenden-
Mit freenetMail - Ihrer kostenlose E-Mail-Adresse
http://email.freenet.de/dienste/emailoffice/produktuebersicht/basic/sms/index.html?pid=6830

