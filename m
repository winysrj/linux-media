Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Jo93T-0007sN-AH
	for linux-dvb@linuxtv.org; Tue, 22 Apr 2008 05:20:34 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JZP00CVSIL43AE0@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 21 Apr 2008 23:19:53 -0400 (EDT)
Date: Mon, 21 Apr 2008 23:19:52 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <75a6c8000804212007m785f6aa0i2804c56a4796feb0@mail.gmail.com>
To: Amitay Isaacs <amitay@gmail.com>
Message-id: <480D5958.1090504@linuxtv.org>
MIME-version: 1.0
References: <685282.37355.qm@web55614.mail.re4.yahoo.com>
	<1208817758.10519.13.camel@pc10.localdom.local>
	<480D499A.2040806@linuxtv.org>
	<75a6c8000804212007m785f6aa0i2804c56a4796feb0@mail.gmail.com>
Cc: Trevor Boon <trevor_boon@yahoo.com>, linux-dvb@linuxtv.org
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

Amitay Isaacs wrote:
> Hello everyone,
> 
> On Tue, Apr 22, 2008 at 12:12 PM, Steven Toth <stoth@linuxtv.org 
> <mailto:stoth@linuxtv.org>> wrote:
> 
>     hermann pitton wrote:
>      > Hi, Trevor and Amitay,
>      >
>      > Am Dienstag, den 22.04.2008, 07:38 +1000 schrieb Trevor Boon:
>      >> Hi Amitay,
>      >>
>      >> I specified the i2c_scan=1 option in my
>      >> /etc/modprobe.d/saa7134 file and the following
>      >> addresses were returned..
>      >>
>      >> saa7130[0]: i2c scan: found device @ 0xa0  [eeprom]
>      >> saa7130[0]: i2c scan: found device @ 0xc0  [tuner
>      >> (analog)]
>      >>
>      >> Regards,
>      >> Trevor.
>      >>
>      >
>      > the 0x10 >> 1 for the digital demod is in the eeprom, if it follows
>      > usual rules, at least the tuner is correct there.
>      >
>      > Likely there are more possibilities, why the tda10048 does not
>     appear,
>      > powered off for example to safe energy, but since you also had a
>     crash
>      > previously, try a cold boot at first, means wait some time
>     without any
>      > power connected, depending on capacitors of the mobo, but 30 seconds
>      > without any power should be always safe, and then just let it auto
>      > detect card=0 without a tuner again and let i2c_scan=1 enabled
>     one more
>      > time.
>      >
>      > If still the same, you are likely above that basic testing step
>     and can
>      > scratch heads on what doing next.
> 
>     If this doesn't work then you may need to drive a GPIO to being the part
>     out of reset.
> 
>     - Steve
> 
> 
>  
> Here is an update on the tests suggested on the list.
> 
> After a cold restart and with i2c_scan=1 options to saa7134 the output 
> is as follows.
> 
> 
> [ 1638.631715] Linux video capture interface: v2.00
> [ 1638.648219] saa7130/34: v4l2 driver version 0.2.14 loaded
> [ 1638.649371] saa7130[0]: found at 0000:02:09.0, rev: 1, irq: 21, 
> latency: 66, mmio: 0xf9e00000
> [ 1638.649386] saa7130[0]: subsystem: 107d:6655, board: Leadtek Winfast 
> DTV-1000S [card=142,autodetected]
> [ 1638.649406] saa7130[0]: board init: gpio is 222000
> [ 1638.649409] saa7130[0]/core: hwinit1
> [ 1638.798382] saa7130[0]: i2c eeprom 00: 7d 10 55 66 54 20 1c 00 43 43 
> a9 1c 55 d2 b2 92
> [ 1638.798405] saa7130[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff 
> ff ff ff ff ff ff
> [ 1638.798422] saa7130[0]: i2c eeprom 20: 01 40 01 01 01 ff 01 03 08 ff 
> 00 8a ff ff ff ff
> [ 1638.798440] saa7130[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 1638.798457] saa7130[0]: i2c eeprom 40: ff 35 00 c0 00 10 03 02 ff 04 
> ff ff ff ff ff ff
> [ 1638.798474] saa7130[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 1638.798491] saa7130[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 1638.798508] saa7130[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 1638.798524] saa7130[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 1638.798541] saa7130[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 1638.798558] saa7130[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 1638.798575] saa7130[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 1638.798592] saa7130[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 1638.798609] saa7130[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 1638.798626] saa7130[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 1638.798643] saa7130[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff 
> ff ff ff ff ff ff
> [ 1638.838381] saa7130[0]: i2c scan: found device @ 0xa0  [eeprom]
> [ 1638.846378] saa7130[0]: i2c scan: found device @ 0xc0  [tuner (analog)]
> [ 1638.852943] saa7130[0]/core: hwinit2
> [ 1638.877459] saa7130[0]: registered device video0 [v4l2]
> [ 1638.878602] saa7130[0]: registered device vbi0
> [ 1638.879508] saa7130[0]: registered device radio0
> [ 1638.999695] tda10048: tda10048_attach()
> [ 1638.999705] tda10048: tda10048_readreg(reg = 0x00)
> [ 1638.999883] tda10048_readreg: readreg error (ret == -5)
> [ 1638.999955] saa7130[0]/dvb: frontend initialization failed
> 
> I2C scan reveals only tuner at 0xc0 and no tda10048.
> 
> I guess the next step is to try to drive a GPIO to bring the demod out 
> of reset as suggested by Steve.
> Any suggestions on how to get GPIO addresses?

saa7134-cards.c func saa7134_xc2028_callback(), this is example code 
that toggles the gpio specific for a 2028 tuner on another card, the 
mechanism and registers will be similar to this.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
