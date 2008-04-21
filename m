Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-14.arcor-online.net ([151.189.21.54])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1Jo4ix-000592-5V
	for linux-dvb@linuxtv.org; Tue, 22 Apr 2008 00:43:00 +0200
From: hermann pitton <hermann-pitton@arcor.de>
To: Trevor Boon <trevor_boon@yahoo.com>
In-Reply-To: <685282.37355.qm@web55614.mail.re4.yahoo.com>
References: <685282.37355.qm@web55614.mail.re4.yahoo.com>
Date: Tue, 22 Apr 2008 00:42:38 +0200
Message-Id: <1208817758.10519.13.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
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

Hi, Trevor and Amitay,

Am Dienstag, den 22.04.2008, 07:38 +1000 schrieb Trevor Boon:
> Hi Amitay,
> 
> I specified the i2c_scan=1 option in my
> /etc/modprobe.d/saa7134 file and the following
> addresses were returned..
> 
> saa7130[0]: i2c scan: found device @ 0xa0  [eeprom]
> saa7130[0]: i2c scan: found device @ 0xc0  [tuner
> (analog)]
> 
> Regards,
> Trevor.
> 

the 0x10 >> 1 for the digital demod is in the eeprom, if it follows
usual rules, at least the tuner is correct there.

Likely there are more possibilities, why the tda10048 does not appear,
powered off for example to safe energy, but since you also had a crash
previously, try a cold boot at first, means wait some time without any
power connected, depending on capacitors of the mobo, but 30 seconds
without any power should be always safe, and then just let it auto
detect card=0 without a tuner again and let i2c_scan=1 enabled one more
time.

If still the same, you are likely above that basic testing step and can
scratch heads on what doing next.

Good Luck,
Hermann









_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
