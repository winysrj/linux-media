Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from paperboy.networkhell.de ([78.46.237.218])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <keef@networkhell.de>) id 1MPbx9-0006rn-Px
	for linux-dvb@linuxtv.org; Sat, 11 Jul 2009 14:45:20 +0200
Message-ID: <4A58893E.4060508@networkhell.de>
Date: Sat, 11 Jul 2009 14:44:46 +0200
From: =?ISO-8859-15?Q?Matthias_M=FCller?= <keef@networkhell.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] problems with Terratec Cinergy 1200 DVB-C MK3 after
	mainboard switch
Reply-To: linux-media@vger.kernel.org
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

I use two Cinergy 1200 DVB-C MK3 for quite a long time and had no 
problems so far. Now I switched to a new mainboard (Asus m4n78 pro) and 
after some time, the dvb-c cards aren't usable anymore. This can be 
triggered by heavy IO.
On both mainboards I use Ubuntu 9.04 with the same kernel version 
(2.6.28-13-generic, also tested with 2.6.28-14-server). While running 
vdr I see the following in syslog:

Jul 11 12:29:52 bowser vdr: [4678] frontend 0 lost lock on channel 6, tp 121
Jul 11 12:29:52 bowser kernel: [ 1235.601266] DVB: TDA10023(0): 
tda10023_readreg: readreg error (reg == 0x11, ret == -1)
Jul 11 12:29:52 bowser vdr: [4682] frontend 1 lost lock on channel 40, 
tp 730
Jul 11 12:29:52 bowser kernel: [ 1235.631263] DVB: TDA10023(1): 
tda10023_readreg: readreg error (reg == 0x11, ret == -1)
Jul 11 12:29:52 bowser kernel: [ 1235.701265] DVB: TDA10023(0): 
tda10023_readreg: readreg error (reg == 0x11, ret == -1)
Jul 11 12:29:52 bowser kernel: [ 1235.741264] DVB: TDA10023(1): 
tda10023_readreg: readreg error (reg == 0x11, ret == -1)
Jul 11 12:29:52 bowser kernel: [ 1235.801262] tda10023: lock tuner fails
Jul 11 12:29:52 bowser kernel: [ 1235.851263] DVB: TDA10023(1): 
tda10023_readreg: readreg error (reg == 0x11, ret == -1)
Jul 11 12:29:52 bowser kernel: [ 1235.951264] DVB: TDA10023(1): 
tda10023_readreg: readreg error (reg == 0x11, ret == -1)
Jul 11 12:29:52 bowser kernel: [ 1236.001263] tda10023: unlock tuner fails
Jul 11 12:29:52 bowser kernel: [ 1236.051271] tda10023: lock tuner fails
Jul 11 12:29:52 bowser kernel: [ 1236.101271] DVB: TDA10023(0): 
tda10023_readreg: readreg error (reg == 0x03, ret == -1)
Jul 11 12:29:53 bowser kernel: [ 1236.200557] DVB: TDA10023(0): 
tda10023_writereg, writereg error (reg == 0x03, val == 0x00, ret == -1)

Using lspci I see the following:

01:05.0 Multimedia controller: Philips Semiconductors SAA7146 (rev ff) 
(prog-if ff)
        !!! Unknown header type 7f
        Kernel driver in use: budget_av

01:07.0 Multimedia controller: Philips Semiconductors SAA7146 (rev ff) 
(prog-if ff)
        !!! Unknown header type 7f
        Kernel driver in use: budget_av

Before the problem the lspci output looked like this:

01:06.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: TERRATEC Electronic GmbH Device 1176
        Flags: bus master, medium devsel, latency 32, IRQ 16
        Memory at faeffc00 (32-bit, non-prefetchable) [size=512]
        Kernel driver in use: budget_av
        Kernel modules: budget-av

01:07.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
        Subsystem: TERRATEC Electronic GmbH Device 1176
        Flags: bus master, medium devsel, latency 32, IRQ 19
        Memory at faeff800 (32-bit, non-prefetchable) [size=512]
        Kernel driver in use: budget_av
        Kernel modules: budget-av

Searching on google I found something about adjusting pci-latencies to 
64, I already tried that, but it didn't help. I updated the BIOS to the 
latest version, but that didn't help either.

Any ideas?

Matthias

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
