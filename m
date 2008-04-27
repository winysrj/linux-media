Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.236])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <eduardhc@gmail.com>) id 1JqDLJ-0006K1-Cq
	for linux-dvb@linuxtv.org; Sun, 27 Apr 2008 22:19:31 +0200
Received: by rv-out-0506.google.com with SMTP id b25so3056836rvf.41
	for <linux-dvb@linuxtv.org>; Sun, 27 Apr 2008 13:19:24 -0700 (PDT)
Message-ID: <617be8890804271319w6231ccecs3defb3b8c8a8984@mail.gmail.com>
Date: Sun, 27 Apr 2008 22:19:24 +0200
From: "Eduard Huguet" <eduardhc@gmail.com>
To: "Matthias Schwarzott" <zzam@gentoo.org>
In-Reply-To: <617be8890804270954nc3d060ev6836849841f65d06@mail.gmail.com>
MIME-Version: 1.0
References: <617be8890804140209p3b79df8cm3f94de8f82b1faa5@mail.gmail.com>
	<200804270540.29590.zzam@gentoo.org>
	<617be8890804270442t5318e322g8904e6e698c70a15@mail.gmail.com>
	<200804271659.41562.zzam@gentoo.org>
	<617be8890804270954nc3d060ev6836849841f65d06@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] a700 support (was: [patch 5/5] mt312: add
	attach-time setting to invert lnb-voltage (Matthias Schwarzott))
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2037749692=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2037749692==
Content-Type: multipart/alternative;
	boundary="----=_Part_2835_12442958.1209327564733"

------=_Part_2835_12442958.1209327564733
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Well, still no luck. I'm unable to discover any channel from Astra 19.2
neither from dvbscan nor Kaffeine. For the sake of any possible diagnostics,
here you have the dmesg output for the "modprobe saa7134 i2c_scan=1"
command:

[40824.395017] Linux video capture interface: v2.00
[40824.427006] saa7130/34: v4l2 driver version 0.2.14 loaded
[40824.428056] saa7133[0]: found at 0000:00:09.0, rev: 209, irq: 23,
latency: 64, mmio: 0xf7ffa800
[40824.428097] saa7133[0]: subsystem: 1461:a7a1, board: Avermedia DVB-S Pro
A700 [card=140,autodetected]
[40824.428151] saa7133[0]: board init: gpio is 6f300
[40824.564594] saa7133[0]: i2c eeprom 00: 61 14 a1 a7 ff ff ff ff ff ff ff
ff ff ff ff ff
[40824.564680] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[40824.564741] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[40824.564882] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[40824.565080] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[40824.565128] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[40824.565173] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[40824.565226] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[40824.565277] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[40824.565325] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[40824.565374] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[40824.565418] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[40824.565463] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[40824.565507] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[40824.565578] saa7133[0]: i2c eeprom e0: 00 01 81 af ea b5 ff ff ff ff ff
ff ff ff ff ff
[40824.565630] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff
ff ff ff ff ff
[40824.572529] saa7133[0]: i2c scan: found device @ 0x1c  [???]
[40824.588514] saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
[40824.619181] saa7133[0]: registered device video0 [v4l2]
[40824.620182] saa7133[0]: registered device vbi0
[40824.745393] mt312: R(126): 05
[40824.785660] mt312: R(20): 03
[40824.785694] mt312: W(20): 40
[40824.806192] mt312: R(20): 43
[40824.806227] mt312: W(20): 00
[40824.808187] zl10036_attach: tuner initialization (Zarlink ZL10036
addr=0x60) ok
[40824.808213] DVB: registering new adapter (saa7133[0])
[40824.808232] DVB: registering frontend 0 (Zarlink ZL10313 DVB-S)...
[40824.809840] mt312: W(127): 8c
[40824.812347] mt312: W(21): 80
[40824.814217] mt312: W(86): 14 12 03 02 01 00 00 00
[40824.817178] mt312: W(20): 80
[40824.819187] mt312: W(84): 80 b0
[40824.823540] mt312: W(84): 00
[40824.825158] mt312: W(85): 00
[40824.827162] mt312: W(34): b6 73
[40824.829161] mt312: W(49): 32
[40824.831146] mt312: W(96): 33
[40824.834197] mt312: W(51): 8c 98
[40824.836583] mt312: W(57): 69
[40824.838884] mt312: W(21): 80
[40824.841869] mt312: W(20): 00
[40824.844860] mt312: W(84): 0d
[40824.851210] mt312: R(127): 8c
[40824.851262] mt312: W(127): 0c
[40824.856840] mt312: R(20): 03
[40824.856884] mt312: W(20): 40
[40824.868466] mt312: R(20): 43

I have also "debug=1" for mt312 module, as you might see. I don't know if
this can be also helpful, but this is the dmesg output when scanning
channels from within Kaffeine:

[41068.542974] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30
[41068.547076] mt312: R(4): 10 8a 30
[41068.547118] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30
[41068.547138] mt312: mt312_set_frontend: Freq 1951000
[41068.549810] mt312: R(20): 83
[41068.549839] mt312: W(20): c0
[41068.568762] mt312: R(20): c3
[41068.568786] mt312: W(20): 80
[41068.574794] mt312: R(20): 87
[41068.574829] mt312: W(20): 80
[41068.577740] mt312: W(23): 16 00 48 40 01
[41068.579730] mt312: W(21): 40
[41068.634835] mt312: R(4): 10 8a 30
[41068.634865] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30
[41068.634880] mt312: mt312_set_frontend: Freq 1951000
[41068.636842] mt312: R(20): 83
[41068.636867] mt312: W(20): c0
[41068.657785] mt312: R(20): c3
[41068.657811] mt312: W(20): 80
[41068.661987] mt312: R(20): 83
[41068.662012] mt312: W(20): 80
[41068.663782] mt312: W(23): 16 00 48 40 01
[41068.666772] mt312: W(21): 40
[41068.671506] mt312: R(4): 10 07 30
[41068.671543] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x07, FEC_STATUS: 0x30
[41068.721382] mt312: R(4): 10 8a 30
[41068.721412] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30
[41068.721432] mt312: mt312_set_frontend: Freq 1951000
[41068.723378] mt312: R(20): 87
[41068.723399] mt312: W(20): c0
[41068.741311] mt312: R(20): c7
[41068.741336] mt312: W(20): 80
[41068.745296] mt312: R(20): 87
[41068.745316] mt312: W(20): 80
[41068.747442] mt312: W(23): 16 00 08 40 01
[41068.750296] mt312: W(21): 40
[41068.774971] mt312: R(4): 10 8a 30
[41068.775007] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30
[41068.805141] mt312: R(4): 10 8a 30
[41068.805175] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30
[41068.805191] mt312: mt312_set_frontend: Freq 1951000
[41068.807384] mt312: R(20): 83
[41068.807409] mt312: W(20): c0
[41068.828329] mt312: R(20): c3
[41068.828361] mt312: W(20): 80
[41068.834074] mt312: R(20): 87
[41068.834094] mt312: W(20): 80
[41068.836412] mt312: W(23): 16 00 08 40 01
[41068.839063] mt312: W(21): 40
[41068.844286] mt312: R(108): 95 df fe
[41068.844312] mt312: agc=00002577 err_db=-2
[41068.849075] mt312: R(9): 3e 09
[41068.857257] mt312: R(4): 10 8a 30
[41068.857287] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30
[41068.877974] mt312: R(4): 10 8a 30
[41068.878004] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30
[41068.894433] mt312: R(4): 10 8a 30
[41068.894463] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30
[41068.894479] mt312: mt312_set_frontend: Freq 1951000
[41068.896915] mt312: R(20): 83
[41068.896934] mt312: W(20): c0
[41068.916112] mt312: R(20): c7
[41068.916147] mt312: W(20): 80
[41068.920088] mt312: R(20): 87
[41068.920112] mt312: W(20): 80
[41068.922532] mt312: W(23): 16 00 48 40 01
[41068.925082] mt312: W(21): 40
[41068.979682] mt312: R(4): 10 8a 30
[41068.979716] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30
[41068.979736] mt312: mt312_set_frontend: Freq 1951000
[41068.981682] mt312: R(20): 83
[41068.981702] mt312: W(20): c0
[41069.003880] mt312: R(20): c3
[41069.003906] mt312: W(20): 80
[41069.008863] mt312: R(20): 83
[41069.008883] mt312: W(20): 80
[41069.012801] mt312: W(23): 16 00 48 40 01
[41069.015847] mt312: W(21): 40
[41069.021725] mt312: R(4): 10 07 30
[41069.021756] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x07, FEC_STATUS: 0x30
[41069.071296] mt312: R(4): 10 8a 30
[41069.071331] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30

The output was indeed longer, I've shortened it a bit because it's the same
output again and again.

Best regards,
  Eduard



2008/4/27 Eduard Huguet <eduardhc@gmail.com>:

> Thanks! I'll try it later and let you know the results.
>
> Regards,
>   Eduard
>
>
>
> 2008/4/27 Matthias Schwarzott <zzam@gentoo.org>:
>
> > On Sonntag, 27. April 2008, Eduard Huguet wrote:
> > > Thank you very much, Matthias. I was going to try the patch right now,
> > > however I'm finding that it doesn't apply clean to the current HG
> > tree.
> > > This is what I'm getting:
> > >
> > > patching file linux/drivers/media/dvb/frontends/Kconfig
> > > Hunk #1 FAILED at 368.
> > > 1 out of 1 hunk FAILED -- saving rejects to file
> > > linux/drivers/media/dvb/frontends/Kconfig.rej
> > > patching file linux/drivers/media/dvb/frontends/Makefile
> > > Hunk #1 succeeded at 23 (offset -2 lines).
> > > patching file linux/drivers/media/dvb/frontends/zl10036.c
> > > patching file linux/drivers/media/dvb/frontends/zl10036.h
> > > patching file linux/drivers/media/video/saa7134/Kconfig
> > > patching file linux/drivers/media/video/saa7134/saa7134-cards.c
> > > Hunk #3 succeeded at 5716 (offset 42 lines).
> > > patching file linux/drivers/media/video/saa7134/saa7134-dvb.c
> > >
> > > I've tried to manually patch Kconfig by adding the rejected lines, but
> > I
> > > suppose there must something I'm doing wrong: apparently it compiles
> > fine,
> > > but saa7134-dvb is not loaded and the frontend is not being created
> > for the
> > > card (although the card is detected and the video0 device for analog
> > is
> > > there).
> > >
> > This reject is caused by the massive movement of the hybrid tuner
> > drivers to
> > another directory.
> > I solved the reject, and re-uploaded the patch.
> > Here it does still work.
> >
> > Regards
> > Matthias
> >
>
>

------=_Part_2835_12442958.1209327564733
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Well, still no luck. I&#39;m unable to discover any channel from Astra 19.2 neither from dvbscan nor Kaffeine. For the sake of any possible diagnostics, here you have the dmesg output for the &quot;modprobe saa7134 i2c_scan=1&quot; command:<br>
<br><div style="margin-left: 40px;"><span style="font-family: courier new,monospace;">[40824.395017] Linux video capture interface: v2.00</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.427006] saa7130/34: v4l2 driver version 0.2.14 loaded</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.428056] saa7133[0]: found at 0000:00:09.0, rev: 209, irq: 23, latency: 64, mmio: 0xf7ffa800</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.428097] saa7133[0]: subsystem: 1461:a7a1, board: Avermedia DVB-S Pro A700 [card=140,autodetected]</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.428151] saa7133[0]: board init: gpio is 6f300</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.564594] saa7133[0]: i2c eeprom 00: 61 14 a1 a7 ff ff ff ff ff ff ff ff ff ff ff ff</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.564680] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.564741] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.564882] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.565080] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.565128] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.565173] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.565226] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.565277] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.565325] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.565374] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.565418] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.565463] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.565507] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.565578] saa7133[0]: i2c eeprom e0: 00 01 81 af ea b5 ff ff ff ff ff ff ff ff ff ff</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.565630] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.572529] saa7133[0]: i2c scan: found device @ 0x1c&nbsp; [???]</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.588514] saa7133[0]: i2c scan: found device @ 0xa0&nbsp; [eeprom]</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.619181] saa7133[0]: registered device video0 [v4l2]</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.620182] saa7133[0]: registered device vbi0</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.745393] mt312: R(126): 05</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.785660] mt312: R(20): 03</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.785694] mt312: W(20): 40</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.806192] mt312: R(20): 43</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.806227] mt312: W(20): 00</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.808187] zl10036_attach: tuner initialization (Zarlink ZL10036 addr=0x60) ok</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.808213] DVB: registering new adapter (saa7133[0])</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.808232] DVB: registering frontend 0 (Zarlink ZL10313 DVB-S)...</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.809840] mt312: W(127): 8c</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.812347] mt312: W(21): 80</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.814217] mt312: W(86): 14 12 03 02 01 00 00 00</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.817178] mt312: W(20): 80</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.819187] mt312: W(84): 80 b0</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.823540] mt312: W(84): 00</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.825158] mt312: W(85): 00</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.827162] mt312: W(34): b6 73</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.829161] mt312: W(49): 32</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.831146] mt312: W(96): 33</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.834197] mt312: W(51): 8c 98</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.836583] mt312: W(57): 69</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.838884] mt312: W(21): 80</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.841869] mt312: W(20): 00</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.844860] mt312: W(84): 0d</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.851210] mt312: R(127): 8c</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.851262] mt312: W(127): 0c</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.856840] mt312: R(20): 03</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[40824.856884] mt312: W(20): 40</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[40824.868466] mt312: R(20): 43</span><br style="font-family: courier new,monospace;"></div><br>I have also &quot;debug=1&quot; for mt312 module, as you might see. I don&#39;t know if this can be also helpful, but this is the dmesg output when scanning channels from within Kaffeine:<br>
<br><div style="margin-left: 40px;"><span style="font-family: courier new,monospace;">[41068.542974] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.547076] mt312: R(4): 10 8a 30</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.547118] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.547138] mt312: mt312_set_frontend: Freq 1951000</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.549810] mt312: R(20): 83</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.549839] mt312: W(20): c0</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.568762] mt312: R(20): c3</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.568786] mt312: W(20): 80</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.574794] mt312: R(20): 87</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.574829] mt312: W(20): 80</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.577740] mt312: W(23): 16 00 48 40 01</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.579730] mt312: W(21): 40</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.634835] mt312: R(4): 10 8a 30</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.634865] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.634880] mt312: mt312_set_frontend: Freq 1951000</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.636842] mt312: R(20): 83</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.636867] mt312: W(20): c0</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.657785] mt312: R(20): c3</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.657811] mt312: W(20): 80</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.661987] mt312: R(20): 83</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.662012] mt312: W(20): 80</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.663782] mt312: W(23): 16 00 48 40 01</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.666772] mt312: W(21): 40</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.671506] mt312: R(4): 10 07 30</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.671543] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x07, FEC_STATUS: 0x30</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.721382] mt312: R(4): 10 8a 30</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.721412] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.721432] mt312: mt312_set_frontend: Freq 1951000</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.723378] mt312: R(20): 87</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.723399] mt312: W(20): c0</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.741311] mt312: R(20): c7</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.741336] mt312: W(20): 80</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.745296] mt312: R(20): 87</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.745316] mt312: W(20): 80</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.747442] mt312: W(23): 16 00 08 40 01</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.750296] mt312: W(21): 40</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.774971] mt312: R(4): 10 8a 30</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.775007] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.805141] mt312: R(4): 10 8a 30</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.805175] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.805191] mt312: mt312_set_frontend: Freq 1951000</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.807384] mt312: R(20): 83</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.807409] mt312: W(20): c0</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.828329] mt312: R(20): c3</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.828361] mt312: W(20): 80</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.834074] mt312: R(20): 87</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.834094] mt312: W(20): 80</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.836412] mt312: W(23): 16 00 08 40 01</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.839063] mt312: W(21): 40</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.844286] mt312: R(108): 95 df fe</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.844312] mt312: agc=00002577 err_db=-2</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.849075] mt312: R(9): 3e 09</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.857257] mt312: R(4): 10 8a 30</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.857287] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.877974] mt312: R(4): 10 8a 30</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.878004] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.894433] mt312: R(4): 10 8a 30</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.894463] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.894479] mt312: mt312_set_frontend: Freq 1951000</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.896915] mt312: R(20): 83</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.896934] mt312: W(20): c0</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.916112] mt312: R(20): c7</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.916147] mt312: W(20): 80</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.920088] mt312: R(20): 87</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.920112] mt312: W(20): 80</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.922532] mt312: W(23): 16 00 48 40 01</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.925082] mt312: W(21): 40</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.979682] mt312: R(4): 10 8a 30</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.979716] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.979736] mt312: mt312_set_frontend: Freq 1951000</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41068.981682] mt312: R(20): 83</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41068.981702] mt312: W(20): c0</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41069.003880] mt312: R(20): c3</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41069.003906] mt312: W(20): 80</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41069.008863] mt312: R(20): 83</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41069.008883] mt312: W(20): 80</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41069.012801] mt312: W(23): 16 00 48 40 01</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41069.015847] mt312: W(21): 40</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41069.021725] mt312: R(4): 10 07 30</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41069.021756] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x07, FEC_STATUS: 0x30</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">[41069.071296] mt312: R(4): 10 8a 30</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">[41069.071331] mt312: QPSK_STAT_H: 0x10, QPSK_STAT_L: 0x8a, FEC_STATUS: 0x30<br>
<br></span><span style="font-family: courier new,monospace;"></span></div><div class="gmail_quote">The output was indeed longer, I&#39;ve shortened it a bit because it&#39;s the same output again and again.<br><br>Best regards, <br>
&nbsp; Eduard<br><br><br><br>2008/4/27 Eduard Huguet &lt;<a href="mailto:eduardhc@gmail.com">eduardhc@gmail.com</a>&gt;:<br><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;">
Thanks! I&#39;ll try it later and let you know the results.<br><br>Regards, <br><font color="#888888">&nbsp; Eduard<br><br><br><br></font><div class="gmail_quote"><div class="Ih2E3d">2008/4/27 Matthias Schwarzott &lt;<a href="mailto:zzam@gentoo.org" target="_blank">zzam@gentoo.org</a>&gt;:<br>

</div><div><div></div><div class="Wj3C7c"><blockquote class="gmail_quote" style="border-left: 1px solid rgb(204, 204, 204); margin: 0pt 0pt 0pt 0.8ex; padding-left: 1ex;"><div>On Sonntag, 27. April 2008, Eduard Huguet wrote:<br>

&gt; Thank you very much, Matthias. I was going to try the patch right now,<br>
&gt; however I&#39;m finding that it doesn&#39;t apply clean to the current HG tree.<br>
&gt; This is what I&#39;m getting:<br>
&gt;<br>
&gt; patching file linux/drivers/media/dvb/frontends/Kconfig<br>
&gt; Hunk #1 FAILED at 368.<br>
&gt; 1 out of 1 hunk FAILED -- saving rejects to file<br>
&gt; linux/drivers/media/dvb/frontends/Kconfig.rej<br>
&gt; patching file linux/drivers/media/dvb/frontends/Makefile<br>
&gt; Hunk #1 succeeded at 23 (offset -2 lines).<br>
&gt; patching file linux/drivers/media/dvb/frontends/zl10036.c<br>
&gt; patching file linux/drivers/media/dvb/frontends/zl10036.h<br>
&gt; patching file linux/drivers/media/video/saa7134/Kconfig<br>
&gt; patching file linux/drivers/media/video/saa7134/saa7134-cards.c<br>
&gt; Hunk #3 succeeded at 5716 (offset 42 lines).<br>
&gt; patching file linux/drivers/media/video/saa7134/saa7134-dvb.c<br>
&gt;<br>
&gt; I&#39;ve tried to manually patch Kconfig by adding the rejected lines, but I<br>
&gt; suppose there must something I&#39;m doing wrong: apparently it compiles fine,<br>
&gt; but saa7134-dvb is not loaded and the frontend is not being created for the<br>
&gt; card (although the card is detected and the video0 device for analog is<br>
&gt; there).<br>
&gt;<br>
</div>This reject is caused by the massive movement of the hybrid tuner drivers to<br>
another directory.<br>
I solved the reject, and re-uploaded the patch.<br>
Here it does still work.<br>
<br>
Regards<br>
<font color="#888888">Matthias<br>
</font></blockquote></div></div></div><br>
</blockquote></div><br>

------=_Part_2835_12442958.1209327564733--


--===============2037749692==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2037749692==--
