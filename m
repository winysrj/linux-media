Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout-fallback.aon.at ([195.3.96.119]:12357 "EHLO
	smtpout-fallback.aon.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbbHXP0a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2015 11:26:30 -0400
Received: from unknown (HELO smtpout.aon.at) ([172.18.1.205])
          (envelope-sender <klammerj@a1.net>)
          by fallback44.highway.telekom.at (qmail-ldap-1.03) with SMTP
          for <linux-media@vger.kernel.org>; 24 Aug 2015 15:19:48 -0000
Message-ID: <55DB3608.5010906@a1.net>
Date: Mon, 24 Aug 2015 17:19:36 +0200
From: Johann Klammer <klammerj@a1.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: hverkuil@xs4all.nl
Subject: [BUG] STV0299 has bogus CAN_INVERSION_AUTO flag
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

from gdb dump:
[...]
info = {
      name = "ST STV0299 DVB-S", '\000' <repeats 111 times>, type = FE_QPSK, 
      frequency_min = 950000, frequency_max = 2150000, 
      frequency_stepsize = 125, frequency_tolerance = 0, 
      symbol_rate_min = 1000000, symbol_rate_max = 45000000, 
      symbol_rate_tolerance = 500, notifier_delay = 0, 
      caps = (FE_CAN_INVERSION_AUTO | FE_CAN_FEC_1_2 | FE_CAN_FEC_2_3 | FE_CAN_FEC_3_4 | FE_CAN_FEC_5_6 | FE_CAN_FEC_7_8 | FE_CAN_FEC_AUTO | FE_CAN_QPSK)}, 
[...]

when tuning:
[...]
[331012.238617] stv0299 does not support auto-inversion
[331012.538760] stv0299 does not support auto-inversion
[331012.838898] stv0299 does not support auto-inversion
[331014.192121] stv0299 does not support auto-inversion
[331014.492257] stv0299 does not support auto-inversion
[331014.792391] stv0299 does not support auto-inversion
[331015.092571] stv0299 does not support auto-inversion
[331015.392692] stv0299 does not support auto-inversion
[331015.692825] stv0299 does not support auto-inversion
[331015.992964] stv0299 does not support auto-inversion
[331016.293106] stv0299 does not support auto-inversion
[331019.306883] stv0299 does not support auto-inversion
[331019.607024] stv0299 does not support auto-inversion
[331019.907166] stv0299 does not support auto-inversion
[331020.207352] stv0299 does not support auto-inversion
[331020.507480] stv0299 does not support auto-inversion
[331020.807610] stv0299 does not support auto-inversion
[331021.107747] stv0299 does not support auto-inversion
[...]
(but how the heck should I know?)

kernel:
[...]
uname -a
Linux tivi 4.1.0-1-586 #1 Debian 4.1.3-1 (2015-08-03) i686 GNU/Linux
[...]

hardware[boot msg]:
[...]
[   12.785499] saa7146: register extension 'budget_av'
[   12.786359] saa7146: found saa7146 @ mem cf83e000 (revision 1, irq 10) (0x153b,0x1154)
[   12.786472] saa7146 (0): dma buffer size 192512
[   12.786533] DVB: registering new adapter (TerraTec Cinergy 1200 DVB-S)
[   12.828641] adapter failed MAC signature check
[   12.828721] encoded MAC from EEPROM was ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff:ff
[   13.096516] budget_av: KNC1-0: MAC addr = 00:0a:ac:01:8d:a1
[   13.604381] budget_av 0000:00:14.0: DVB: registering adapter 0 frontend 0 (ST STV0299 DVB-S)...
[   13.621283] budget_av: ci interface initialised
[...]

