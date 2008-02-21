Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from aiolos.otenet.gr ([195.170.0.93] ident=OTEnet-mail-system)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vnonas@otenet.gr>) id 1JS9zT-0005hx-0G
	for linux-dvb@linuxtv.org; Thu, 21 Feb 2008 12:53:27 +0100
Received: from dali.otenet.gr (srv-nat1.otenet.gr [195.170.0.91])
	by aiolos.otenet.gr (8.13.8/8.13.8/Debian-3) with ESMTP id
	m1LBrBas028976
	for <linux-dvb@linuxtv.org>; Thu, 21 Feb 2008 13:53:11 +0200
Date: Thu, 21 Feb 2008 13:53:11 +0200 (EET)
From: NONAS EUAGGELOS <vnonas@otenet.gr>
To: linux-dvb@linuxtv.org
Message-ID: <32245669.2613.1203594791803.JavaMail.tomcat@dali.otenet.gr>
MIME-Version: 1.0
Subject: [linux-dvb] TechniSat SkyStar HD: Problems scaning and zaping
Reply-To: vnonas@otenet.gr
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

Hello,

I have a Skystar HD. I use multiproto from here (checked it out yesterday):
http://jusst.de/hg/multiproto
It compiles fine, all needed modules are loaded automatically upon boot.
This is my dmesg:
saa7146: found saa7146 @ mem f88f2000 (revision 1, irq 21) (0x13c2,0x1019).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (TT-Budget S2-3200 PCI)
adapter has MAC addr = 00:d0:5c:67:dd:91
input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input3
stb0899_write_regs [0xf1b6]: 02
stb0899_write_regs [0xf1c2]: 00
stb0899_write_regs [0xf1c3]: 00
_stb0899_read_reg: Reg=[0xf000], data=82
stb0899_get_dev_id: ID reg=[0x82]
stb0899_get_dev_id: Device ID=[8], Release=[2]
_stb0899_read_s2reg Device=[0xf3fc], Base address=[0x00000400], Offset=[0xf334], Data=[0x444d4431]
_stb0899_read_s2reg Device=[0xf3fc], Base address=[0x00000400], Offset=[0xf33c], Data=[0x00000001]
stb0899_get_dev_id: Demodulator Core ID=[DMD1], Version=[1]
_stb0899_read_s2reg Device=[0xfafc], Base address=[0x00000800], Offset=[0xfa2c], Data=[0x46454331]
_stb0899_read_s2reg Device=[0xfafc], Base address=[0x00000800], Offset=[0xfa34], Data=[0x00000001]
stb0899_get_dev_id: FEC Core ID=[FEC1], Version=[1]
stb0899_attach: Attaching STB0899
stb6100_attach: Attaching STB6100
DVB: registering frontend 0 (STB0899 Multistandard)...

I use scan from here: 
http://jusst.de/manu/scan.tar.bz2
It does not compile, I use the binary I found in the archive.

I use szap2 from here:
http://www.free-x.de/vdr/patches/hdtv/szap2.tgz
It does compile.

My kernel is:
2.6.22-gentoo-r9

My problems are:
- When I scan the same transponder more than once, sometimes I get some services, sometimes I get no services.
- When I zap (with szap2) to a station more than once, sometimes I get a lock, sometimes I get no lock.
- I have also tried with vdr 1.4.7(old DVB API) and 1.5.14 (new dvb API). Both versions can tune to only one channel, the "Active" channel from previous vdr shutdown. When you change channel the signal is lost. I suppose it relates to the zap problem.

I would appreciate your help / suggestions.

Thank you very much.
Vagelis
 

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
