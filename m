Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nskntmtas04p.mx.bigpond.com ([61.9.168.146])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vince_m@bigpond.com>) id 1L8DCK-0000Sp-2W
	for linux-dvb@linuxtv.org; Thu, 04 Dec 2008 13:20:49 +0100
Received: from nskntotgx01p.mx.bigpond.com ([202.89.181.98])
	by nskntmtas04p.mx.bigpond.com with ESMTP id
	<20081204122009.BSUE2038.nskntmtas04p.mx.bigpond.com@nskntotgx01p.mx.bigpond.com>
	for <linux-dvb@linuxtv.org>; Thu, 4 Dec 2008 12:20:09 +0000
Received: from [127.0.0.1] (really [202.89.181.98])
	by nskntotgx01p.mx.bigpond.com with ESMTP
	id <20081204122008.DBDI6972.nskntotgx01p.mx.bigpond.com@[127.0.0.1]>
	for <linux-dvb@linuxtv.org>; Thu, 4 Dec 2008 12:20:08 +0000
Message-ID: <4937CAE4.8080100@bigpond.com>
Date: Thu, 04 Dec 2008 21:19:48 +0900
From: Vince Mari <vince_m@bigpond.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb]  Support for Leadtek DTV1000S ?
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

Hi,
I am trying to get this card to work as well and  I also got the i2c 
errors from the tda10048 -

but the i2c_debug=1 option of the saa7134 driver points to the following 
code, which was added
recently I think. Without it the i2c errors stop, the tda10048 and 
tda18271 attach, and the firmware loads

#diff saa7134-i2c.c.1.1.1.1 saa7134-i2c.c
262a263,271
 >                       if (i > 0 && msgs[i].flags & I2C_M_RD) {
 >                               /* workaround for a saa7134 i2c bug
 >                                * needed to talk to the mt352 demux
 >                                * thanks to pinnacle for the hint */
 >                               int quirk = 0xfd;
 >                               d1printk(" [%02x quirk]",quirk);
 >                               i2c_send_byte(dev,START,quirk);
 >                               i2c_recv_byte(dev);
 >                       }

I am currently trying to get the tda18271 to lock onto a signal but with 
no luck yet

 ./tzap -r -a 0 -c channels.conf-dvbt-australia '7 Digital'
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 177500000 Hz
video pid 0x0301, audio pid 0x0302
status 00 | signal 3434 | snr 0013 | ber 0000ffff | unc 00000000 |
status 00 | signal ecec | snr 0076 | ber 0000ffff | unc 00000000 |
status 00 | signal f5f5 | snr 0078 | ber 0000ffff | unc 00000000 |
status 00 | signal dbdb | snr 005a | ber 0000ffff | unc 00000000 |
status 00 | signal d9d9 | snr 0058 | ber 0000ffff | unc 00000000 |
status 00 | signal ecec | snr 0076 | ber 0000ffff | unc 00000000 |
status 00 | signal ecec | snr 0058 | ber 0000ffff | unc 00000000 |
status 00 | signal d9d9 | snr 0058 | ber 0000ffff | unc 00000000 |
status 00 | signal d7d7 | snr 0049 | ber 0000ffff | unc 00000000 |


Cheers,
Vince Mari


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
