Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mx03.lb01.inode.at ([62.99.145.3] helo=mx.inode.at)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e.peinlich@inode.at>) id 1JQiQH-0005vQ-Nx
	for linux-dvb@linuxtv.org; Sun, 17 Feb 2008 13:15:09 +0100
Received: from [85.124.58.196] (port=15724 helo=[10.0.2.30])
	by smartmx-03.inode.at with esmtpa (Exim 4.50) id 1JQiPm-0001dt-Fe
	for linux-dvb@linuxtv.org; Sun, 17 Feb 2008 13:14:38 +0100
Message-ID: <47B82526.5090203@inode.at>
Date: Sun, 17 Feb 2008 13:14:30 +0100
From: Ernst Peinlich <e.peinlich@inode.at>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <200801252245.58642.dkuhlen@gmx.net>	<47A086D6.4080200@okg-computer.de>	<200801301908.36169.dkuhlen@gmx.net>	<47A0CD3C.40508@okg-computer.de>	<47A0E8CC.3080207@okg-computer.de>	<47B0C1FF.7060202@okg-computer.de>
	<47B1B384.1050503@okg-computer.de>
In-Reply-To: <47B1B384.1050503@okg-computer.de>
Subject: Re: [linux-dvb] Pinnacle PCTV Sat HDTV Pro USB (PCTV452e) and DVB-S2
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

Jens Krehbiel-Gr=E4ther schrieb:
> Hi!
>
> Here is the complete log.
>
> syslog from loading the modules:
>
> Feb 12 13:57:34 dev kernel: usb 3-6: new high speed USB device using =

> ehci_hcd and address 3
> Feb 12 13:57:34 dev kernel: usb 3-6: configuration #1 chosen from 1 choice
> Feb 12 13:57:34 dev kernel: dvb-usb: found a 'PCTV HDTV USB' in warm stat=
e.
> Feb 12 13:57:34 dev kernel: pctv452e_power_ctrl: 1
> Feb 12 13:57:34 dev kernel: dvb-usb: will pass the complete MPEG2 =

> transport stream to the software demuxer.
> Feb 12 13:57:34 dev kernel: DVB: registering new adapter (PCTV HDTV USB)
> Feb 12 13:57:34 dev kernel: pctv452e_frontend_attach Enter
> Feb 12 13:57:34 dev kernel: stb0899_write_regs [0xf1b6]: 02
> Feb 12 13:57:34 dev kernel: stb0899_write_regs [0xf1c2]: 00
> Feb 12 13:57:34 dev kernel: stb0899_write_regs [0xf1c3]: 00
> Feb 12 13:57:34 dev kernel: stb0899_write_regs [0xf141]: 02
> Feb 12 13:57:34 dev kernel: _stb0899_read_reg: Reg=3D[0xf000], data=3D81
> Feb 12 13:57:34 dev kernel: stb0899_get_dev_id: ID reg=3D[0x81]
> Feb 12 13:57:34 dev kernel: stb0899_get_dev_id: Device ID=3D[8], Release=
=3D[1]
> Feb 12 13:57:34 dev kernel: _stb0899_read_s2reg Device=3D[0xf3fc], Base =

> address=3D[0x00000400], Offset=3D[0xf334], Data=3D[0x444d4431]
> Feb 12 13:57:34 dev kernel: _stb0899_read_s2reg Device=3D[0xf3fc], Base =

> address=3D[0x00000400], Offset=3D[0xf33c], Data=3D[0x00000001]
> Feb 12 13:57:34 dev kernel: stb0899_get_dev_id: Demodulator Core =

> ID=3D[DMD1], Version=3D[1]
> Feb 12 13:57:34 dev kernel: _stb0899_read_s2reg Device=3D[0xfafc], Base =

> address=3D[0x00000800], Offset=3D[0xfa2c], Data=3D[0x46454331]
> Feb 12 13:57:34 dev kernel: _stb0899_read_s2reg Device=3D[0xfafc], Base =

> address=3D[0x00000800], Offset=3D[0xfa34], Data=3D[0x00000001]
> Feb 12 13:57:34 dev kernel: stb0899_get_dev_id: FEC Core ID=3D[FEC1], =

> Version=3D[1]
> Feb 12 13:57:34 dev kernel: stb0899_attach: Attaching STB0899
> Feb 12 13:57:34 dev kernel: lnbp22_set_voltage: 2 (18V=3D1 13V=3D0)
> Feb 12 13:57:34 dev kernel: lnbp22_set_voltage: 0x60)
> Feb 12 13:57:34 dev kernel: pctv452e_frontend_attach Leave Ok
> Feb 12 13:57:34 dev kernel: DVB: registering frontend 0 (STB0899 =

> Multistandard)...
> Feb 12 13:57:34 dev kernel: pctv452e_tuner_attach Enter
> Feb 12 13:57:34 dev kernel: stb6100_attach: Attaching STB6100
> Feb 12 13:57:34 dev kernel: pctv452e_tuner_attach Leave
> Feb 12 13:57:34 dev kernel: input: IR-receiver inside an USB DVB =

> receiver as /class/input/input5
> Feb 12 13:57:34 dev kernel: dvb-usb: schedule remote query interval to =

> 100 msecs.
> Feb 12 13:57:34 dev kernel: pctv452e_power_ctrl: 0
> Feb 12 13:57:34 dev kernel: dvb-usb: PCTV HDTV USB successfully =

> initialized and connected.
> Feb 12 13:57:34 dev kernel: usbcore: registered new interface driver =

> pctv452e
>
>
> And a complete log from a complete scan on Astra 19,2=B0E can you downloa=
d =

> here (about 1,6MB uncompressed, for Download 37kB gzip-File):
> http://www.rz.uni-karlsruhe.de/~ry52/syslog.gz
>
> If you see anything that can help me, please let me know. I don't =

> believe that the new device has also a hardware failiure, because (as I =

> wrote) it works for one time scanning and one time tuning... :-(
>
> Hope to get help here,
>
> Jens
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
>   =

Hi
i have problems with DVBS on the driver.
i get PES errors
on DVBS2 its works
(vdr-1.5.14+h264 patch)
thanks



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
