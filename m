Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <debalance@arcor.de>) id 1KCbHC-0004n9-3D
	for linux-dvb@linuxtv.org; Sat, 28 Jun 2008 16:19:43 +0200
Message-ID: <48664867.9060507@arcor.de>
Date: Sat, 28 Jun 2008 16:19:19 +0200
From: =?UTF-8?B?UGhpbGlwcCBIw7xibmVy?= <debalance@arcor.de>
MIME-Version: 1.0
To: Artem Makhutov <artem@makhutov.org>
References: <486563DE.4070705@arcor.de>
	<20080628063926.GN12592@moelleritberatung.de>
In-Reply-To: <20080628063926.GN12592@moelleritberatung.de>
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

Hey,

Artem Makhutov schrieb:
> The dvb-utils package, that is shipped with debian won't work with multiproto,
> because multiproto introduced a new DVB-API.
> 
> You have to compile szap (szap2) and scan for yourself, otherwise it
> won't work.

Thanks for that hint.
I uninstalled dvb-utils and compiled and installed the dvb-apps.
Scan ran successfully and now I've got a very long channels.conf ;)

Unfortunately szap seems not to work successfully and I didn't manage to
see any TV yet.

Here's the output:

der_schakal@kuehlschrank:~$ szap -r -n 001
reading channels from file '/home/der_schakal/.szap/channels.conf'
zapping to 1 'ASTRA SDT':
sat 0, frequency = 12551 MHz V, symbolrate 22000000, vpid = 0x1fff, apid
= 0x1fff sid = 0x000c
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal 0009 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0009 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0009 | snr 0000 | ber 00000000 | unc fffffffe |
status 00 | signal 0009 | snr 0000 | ber 00000000 | unc fffffffe |
[...]

It goes on like this forever until I press CTRL+C.


The test with mplayer looks like this:

der_schakal@kuehlschrank:~$ mplayer /dev/dvb/adapter0/dvr0
MPlayer dev-SVN-r26940
CPU: Intel(R) Pentium(R) 4 CPU 3.00GHz (Family: 15, Model: 4, Stepping: 3)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
Compiled with runtime CPU detection.
Can't open joystick device /dev/input/js0: No such file or directory
Can't init input joystick
mplayer: could not open config files /home/der_schakal/.lircrc and
/etc/lirc//lircrc
[I guess the joystick- and lirc-stuff can be ignored]
mplayer: No such file or directory
Failed to read LIRC config file ~/.lircrc.

Playing /dev/dvb/adapter0/dvr0.

[I don't hear anything and I don't see anything since now mplayer window
pops up.]

[CTRL+C]
MPlayer interrupted by signal 2 in module: demux_open

[CTRL+C]
MPlayer interrupted by signal 2 in module: demux_open



Any more ideas?

Best wishes,
Philipp
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIZkhmFhl05MJZ4OgRAlzEAJ9TpUrENl9KPCykm8RxDS9NnlMevACfQE9x
Fo6seaAAu2wUjKcWCRQcVpo=
=hw8d
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
