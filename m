Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web55614.mail.re4.yahoo.com ([206.190.58.238])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <trevor_boon@yahoo.com>) id 1Jo3jM-0000cQ-QL
	for linux-dvb@linuxtv.org; Mon, 21 Apr 2008 23:40:07 +0200
Date: Tue, 22 Apr 2008 07:38:36 +1000 (EST)
From: Trevor Boon <trevor_boon@yahoo.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <mailman.73.1208797403.823.linux-dvb@linuxtv.org>
MIME-Version: 1.0
Message-ID: <685282.37355.qm@web55614.mail.re4.yahoo.com>
Subject: Re: [linux-dvb] HVR1200 / HVR1700 / TDA10048 support
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

Hi Amitay,

I specified the i2c_scan=1 option in my
/etc/modprobe.d/saa7134 file and the following
addresses were returned..

saa7130[0]: i2c scan: found device @ 0xa0  [eeprom]
saa7130[0]: i2c scan: found device @ 0xc0  [tuner
(analog)]

Regards,
Trevor.


      Get the name you always wanted with the new y7mail email address.
www.yahoo7.com.au/y7mail



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
