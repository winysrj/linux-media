Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-11.arcor-online.net ([151.189.21.51])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <debalance@arcor.de>) id 1KCM3N-0002w6-1Z
	for linux-dvb@linuxtv.org; Sat, 28 Jun 2008 00:04:26 +0200
Message-ID: <486563DE.4070705@arcor.de>
Date: Sat, 28 Jun 2008 00:04:14 +0200
From: =?ISO-8859-15?Q?Philipp_H=FCbner?= <debalance@arcor.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] TerraTec Cinergy S2 PCI HD
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello all!

I'm new to this list as I just bought a TerraTec Cinergy S2 PCI HD and
want to get it working on Debian Lenny/Sid.

I followed
"Installing on Debian etch with Multiproto diver (Recommended)"
on
http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_S2_PCI_HD_CI

I compiled and installed the kernel-modules as described there.
After reboot, the device appears under /dev/dvb/adapter0/...

I did not download and compile scan2, since it is available on Debian
via the dvb-utils package (available in all Debian versions).

Now the following happens:

der_schakal@kuehlschrank:~$ scan
/usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E > channels.conf

scanning /usr/share/doc/dvb-utils/examples/scan/dvb-s/Astra-19.2E
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 12551500 V 22000000 5
>>> tune to: 12551:v:0:22000
__tune_to_transponder:1491: ERROR: FE_READ_STATUS failed: 22 Invalid
argument
>>> tune to: 12551:v:0:22000
__tune_to_transponder:1491: ERROR: FE_READ_STATUS failed: 22 Invalid
argument
ERROR: initial tuning failed
dumping lists (0 services)
Done.

channels.conf exists but it empty after this process.

I copied /usr/share/doc/dvb-utils/examples/channels.conf-dvbs-astra to
~/channels.conf and then called szap:

der_schakal@kuehlschrank:~$ szap -r -n 001
reading channels from file '/home/der_schakal/.szap/channels.conf'
zapping to 1 'Das Erste':
sat 0, frequency = 11837 MHz H, symbolrate 27500000, vpid = 0x0065, apid
= 0x0066
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
FE_READ_STATUS failed: Invalid argument
status 8048788 | signal fffe | snr fffe | ber fffffffe | unc fffffffe |
FE_READ_STATUS failed: Invalid argument
status 8048788 | signal fffe | snr fffe | ber fffffffe | unc fffffffe |
FE_READ_STATUS failed: Invalid argument

It goes on like this until I press CTRL+C.
As you can imagine by now, trying to watch DVB with mplayer or kaffeine
fails.


Any ideas that could help me?

Thanks in advance,
Philipp




PS: I can offer my help for development/testing concerning this card, if
wanted.
Some additional information:

der_schakal@kuehlschrank:~$ uname -a
Linux kuehlschrank 2.6.24-1-686 #1 SMP Thu May 8 02:16:39 UTC 2008 i686
GNU/Linux

der_schakal@kuehlschrank:~$ lsmod | grep mantis
mantis                 39876  0
lnbp21                  2208  1 mantis
mb86a16                18496  1 mantis
stb6100                 7492  1 mantis
tda10021                6116  1 mantis
tda10023                5924  1 mantis
stb0899                32800  1 mantis
stv0299                 9736  1 mantis
dvb_core               80060  2 mantis,stv0299
i2c_core               22432  10
nvidia,mantis,lnbp21,mb86a16,stb6100,tda10021,tda10023,stb0899,stv0299,i2c_i801

der_schakal@kuehlschrank:~$ lspci -vv
04:01.0 Multimedia controller: Twinhan Technology Co. Ltd Mantis DTV PCI
Bridge Controller [Ver 1.0] (rev 01)
        Subsystem: TERRATEC Electronic GmbH Device 1179
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
<TAbort+ <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (2000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at d5100000 (32-bit, prefetchable) [size=4K]
        Kernel driver in use: Mantis
        Kernel modules: mantis
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIZWPdFhl05MJZ4OgRAtjSAKDEcUpgsyDg2dw60l2WEGHOpvW51gCfYYmM
VU2EMpT6GSZOZtzGUwaX0Is=
=alRm
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
