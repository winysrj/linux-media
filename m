Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-16.arcor-online.net ([151.189.21.56])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <debalance@arcor.de>) id 1KEkmS-0002pO-C4
	for linux-dvb@linuxtv.org; Fri, 04 Jul 2008 14:52:55 +0200
Message-ID: <486E1D1E.6030403@arcor.de>
Date: Fri, 04 Jul 2008 14:52:46 +0200
From: =?KOI8-R?Q?Philipp_Hu=22bner?= <debalance@arcor.de>
MIME-Version: 1.0
To: Goga777 <goga777@bk.ru>
References: <48664867.9060507@arcor.de>
	<E1KCx5p-000Bpw-00.goga777-bk-ru@f37.mail.ru>
In-Reply-To: <E1KCx5p-000Bpw-00.goga777-bk-ru@f37.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TerraTec Cinergy S2 PCI HD
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

Hey all,

Goga777 schrieb:
> you should use szap2 from test directory of dvb-apps
> http://linuxtv.org/hg/dvb-apps/file/77e3c7baa1e4/test/szap2.c

scan works now, szap2 works now:

szap2 -rxn 001
reading channels from file '/home/der_schakal/.szap/channels.conf'
zapping to 1 'ASTRA SDT':
sat 0, frequency = 12551 MHz V, symbolrate 22000000, vpid = 0x1fff, apid
= 0x1fff sid = 0x000c
Delivery system=DVB-S
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'

do_tune: API version=3, delivery system = 0
do_tune: Frequency = 1951000, Srate = 22000000
do_tune: Frequency = 1951000, Srate = 22000000


status 00 | signal 22e0 | snr b7fa | ber 00000000 | unc fffffffe |
status 1e | signal 014f | snr 007b | ber 00000000 | unc fffffffe |
FE_HAS_LOCK


But mplayer /dev/dvb/adapter0/dvr0 doesn't work:
ls /dev/dvb/adapter0/
ca0  demux0  dvr0  frontend0  net0

 mplayer /dev/dvb/adapter0/dvr0
MPlayer dev-SVN-r26940
CPU: Intel(R) Pentium(R) 4 CPU 3.00GHz (Family: 15, Model: 4, Stepping: 3)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
Compiled with runtime CPU detection.
Can't open joystick device /dev/input/js0: No such file or directory
Can't init input joystick
mplayer: could not open config files /home/der_schakal/.lircrc and
/etc/lirc//lircrc
mplayer: No such file or directory
Failed to read LIRC config file ~/.lircrc.

Playing /dev/dvb/adapter0/dvr0.

[CTRL+C]
MPlayer interrupted by signal 2 in module: demux_open

[CTRL+C]
MPlayer interrupted by signal 2 in module: demux_open


How can I actually watch some channel?

Furthermore I'd like to use kaffeine, is this possible with this card?
At the moment kaffeine fails to scan for channels because tuning fails.
Is there some workaround?

Thanks in advance,
Philipp
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIbh0eFhl05MJZ4OgRAqN6AJwLO4/rhMpctg6HO85M8lLzjPR5ugCfcAXu
YGpOeG+PNXJFY+O7ckIJs6Q=
=Gkr1
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
