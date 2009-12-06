Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from defout.telus.net ([204.209.205.13])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <sandy@voytech.biz>) id 1NH7GZ-0000pJ-DX
	for linux-dvb@linuxtv.org; Sun, 06 Dec 2009 03:54:32 +0100
Received: from edmwaa02.telusplanet.net ([207.216.216.254])
	by priv-edmwes25.telusplanet.net
	(InterMail vM.7.08.04.00 201-2186-134-20080326) with ESMTP id
	<20091206025423.DDWR7884.priv-edmwes25.telusplanet.net@edmwaa02.telusplanet.net>
	for <linux-dvb@linuxtv.org>; Sat, 5 Dec 2009 19:54:23 -0700
Received: from [10.1.1.10] (d207-216-216-254.bchsia.telus.net
	[207.216.216.254])
	by edmwaa02.telusplanet.net (BorderWare Security Platform) with ESMTP
	id 59980146279E9801
	for <linux-dvb@linuxtv.org>; Sat,  5 Dec 2009 19:54:22 -0700 (MST)
From: Sandy macDonald <sandy@voytech.biz>
To: linux-dvb@linuxtv.org
Date: Sat, 05 Dec 2009 18:54:24 -0800
Message-ID: <1260068064.5339.21.camel@bubbles.local>
Mime-Version: 1.0
Subject: [linux-dvb] Sky2PC Rev. 3.1
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


Hello:

I've had a Sky2PC (ver 3.1) DVB-S card kicking around for a while and
I'd like to get it operational.

According to the v4l-dvb wiki, this card requires a definition, and to
post the details to the linuxtv mailing list, so here goes..

Thank you.
Sandy MacDonald

On the back of the card:

Model: SKY2PC
P/N: 92105-20101
Rev: 3.1
Serial no. and MAC address

The front of the card:

DBC1201 (on the metal shielding), nothing else.
Main chip: B2C2 Flexcop III
	M3B9E-001 0215

lspci -v

01:0e.0 Network controller: Techsan Electronics Co Ltd B2C2 FlexCopIII
DVB chip / Technisat SkyStar2 DVB card (rev 01)
	Subsystem: Techsan Electronics Co Ltd Device 2104
	Flags: bus master, slow devsel, latency 64, IRQ 10
	Memory at f4100000 (32-bit, non-prefetchable) [size=64K]
	I/O ports at 3400 [size=32]

lspci -vn

01:0e.0 0280: 13d0:2200 (rev 01)
	Subsystem: 13d0:2104
	Flags: bus master, slow devsel, latency 64, IRQ 10
	Memory at f4100000 (32-bit, non-prefetchable) [size=64K]
	I/O ports at 3400 [size=32]




_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
