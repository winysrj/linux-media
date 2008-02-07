Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail1.perspektivbredband.net ([81.186.254.13])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <p.blomqvist@lsn.se>) id 1JNEKF-0004o9-Uc
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 22:30:32 +0100
Received: from [192.168.2.103]
	(201.4.185.213.se-stf.res.dyn.perspektivbredband.net [213.185.4.201])
	by mail1.perspektivbredband.net (Postfix) with ESMTP id E0CF418E03F4
	for <linux-dvb@linuxtv.org>; Thu,  7 Feb 2008 22:29:57 +0100 (CET)
Message-ID: <47AB7865.5090008@lsn.se>
Date: Thu, 07 Feb 2008 22:30:13 +0100
From: Per Blomqvist <p.blomqvist@lsn.se>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Help! I cant view video. BUT I can scan!!
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello, help!

I can "dvbscan" and  "tzap", and gets indication of a good signal. BUT, =

I cant view the video!
(from the dvb device)

Also "dvbdate" command works (that returns time and date from the air, I =

presume). But not a command as "dvbsnoop" (that need =

"/dev/dvb/adapter0/dvr").

A sample: ( Its step by step of your guide:
http://www.linuxtv.org/wiki/index.php/Testing_your_DVB_device )

In one console I run: /.tzap# tzap -r -c channels.conf "TV4 =D6resund" ( =

and are getting lines as:
status 1f | signal c3c3 | snr ffff | ber 0000004a | unc 00000000 | =

FE_HAS_LOCK
status 1f | signal c3c3 | snr ffff | ber 0000004e | unc 00000000 | =

FE_HAS_LOCK
...
AND in another console:
mplayer -v /dev/dvb/adapter0/dvr0
(thats basically halts without any further information)

ALSO if I type: "cat /dev/dvb/adapter0/dvr0 > afile.txt"
(But then again, "afile.txt" remains empty)

Conclusion, /dev/dvb/adapter0/dvr0 never returns anything. This =

"/dev/dvb/adapter0/dvr" isnt proper. Must be a Linux-kernel/module =

problem..

Here are some further info of whats on my system:

* Media Card: "Asus P7131 Hybrid"
(This very same Media-card worked on an older machine, an old Pentium, =

that I now abandoned. Maybe I used the line "card=3D112 i2c_scan=3D1 =

tunar=3D54 gpio_tracking=3D1" when loading "saa7134" kernel-module, for =

this. By a gento wiki-tips (http://gentoo-wiki.com/HARDWARE_saa7134). I =

tested this line on this AMD64 machine also, but didnt make any =

difference..

* Linux-kernel, "2.6.22-3-amd64" (The only kernel I see in my =

Debian-testing apt list, cant use any other kernel, strange also..)

* The system, Its some dual AMD64, mother-board Asus "M2A-VM HDMI" (a =

card with most stuff built-in, as sound graphics.. etc) A common card =

(for building computers aimed toward media, as this is).

* Mplayer (for what its matter, gnu "cat" dint work ether, so it doesnt =

matter). I have compiled Mplayer myself, with everything possible =

included. Also, I have tested Debians deb-package called the same name, =

but without success (or difference).

Maybe I could include the returns of the old and new "lsmod", but the =

only difference there regarding this is, that I now dont use Alsa (sound =

system). Now I use the default outof-the-box-configurations (a fresh =

installation, this my system is, now). So I dont include what "lsmod" =

returns, in this email (because then I can continue with "lspci" "dmsg", =

and all possible and impossible sniff logs..  I dont know what may be =

relevant info, to solve this.

Any comments and Ideers are welcome! !

thx.

I just signed up for this mailing-list ( I hope this is the right =

forum.. thanx again. Also I hope the solution is simple.


-- =

Mvh, Per Blomqvist
Web: http://phoohb.shellkonto.se
Telnr: +46 70-3355632

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
