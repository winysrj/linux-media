Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wx-out-0506.google.com ([66.249.82.236])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gregoire.favre@gmail.com>) id 1KeGSZ-0004e6-NE
	for linux-dvb@linuxtv.org; Fri, 12 Sep 2008 23:45:48 +0200
Received: by wx-out-0506.google.com with SMTP id t16so539113wxc.17
	for <linux-dvb@linuxtv.org>; Fri, 12 Sep 2008 14:45:42 -0700 (PDT)
Date: Fri, 12 Sep 2008 23:45:37 +0200
To: Steven Toth <stoth@linuxtv.org>
Message-ID: <20080912214537.GA3248@gmail.com>
References: <48C70F88.4050701@linuxtv.org>
	<200809122102.27540.liplianin@tut.by>
	<48CAD330.1000804@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <48CAD330.1000804@linuxtv.org>
From: Gregoire Favre <gregoire.favre@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] S2API Bug fix:
	ioctl	FE_SET_PROPERTY/FE_GET_PROPERTY always return error
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Fri, Sep 12, 2008 at 04:38:08PM -0400, Steven Toth wrote:

> Merged, thanks.

I can again get locks on some channels, but sofar I didn't manage to get
anything from mplayer... I don't know if all modules got well loaded :

i2c-adapter i2c-4: SMBus Quick command not supported, can't probe for chips
OmniVision ov7670 sensor driver, at your service
wm8775' 2-001b: chip found @ 0x36 (cx88[0])
i2c-adapter i2c-4: SMBus Quick command not supported, can't probe for chips
tuner' 2-0043: chip found @ 0x86 (cx88[0])
tda9887 2-0043: creating new instance
tda9887 2-0043: tda988[5/6/7] found
tuner' 2-0061: chip found @ 0xc2 (cx88[0])
tuner' 2-0063: chip found @ 0xc6 (cx88[0])
saa7146: register extension 'budget dvb'.
saa7146: register extension 'budget_ci dvb'.
ACPI: PCI Interrupt 0000:04:01.0[A] -> GSI 22 (level, low) -> IRQ 22
saa7146: found saa7146 @ mem ffffc2000003ec00 (revision 1, irq 22) (0x13c2,=
0x100f).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (TT-Budget/WinTV-NOVA-CI PCI)
adapter has MAC addr =3D 00:d0:5c:23:a3:9b
input: Budget-CI dvb ir receiver saa7146 (0) as /devices/pci0000:00/0000:00=
:1e.0/0000:04:01.0/input/input11
DVB: registering frontend 0 (ST STV0299 DVB-S)...
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:04:02.0[A] -> GSI 23 (level, low) -> IRQ 23
cx88[0]/0: found at 0000:04:02.0, rev: 5, irq: 23, latency: 64, mmio: 0xdb0=
00000
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
tuner' 2-0061: tuner type not set
ACPI: PCI Interrupt 0000:04:05.0[A] -> GSI 20 (level, low) -> IRQ 20
cx88[1]/0: found at 0000:04:05.0, rev: 3, irq: 20, latency: 64, mmio: 0xd90=
00000
cx88[1]/0: registered device video1 [v4l2]
cx88[1]/0: registered device vbi1
saa7146: register extension 'budget_av'.
cx23885 driver version 0.0.1 loaded
cx2388x alsa driver version 0.0.6 loaded
ACPI: PCI Interrupt 0000:04:02.1[A] -> GSI 23 (level, low) -> IRQ 23
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
cx2388x blackbird driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: blackbird access: shared
cx88[0]/2: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 DVB-S/S2/T/=
Hybrid [card=3D68]
cx88[0]/2: cx8802 probe failed, err =3D -19
cx88[1]/2: subsystem: 14f1:0084, board: Geniatech DVB-S [card=3D52]
cx88[1]/2: cx8802 probe failed, err =3D -19

At least my HVR-4000 don't seems to be well loaded, no ?

Thank for all developpement :-)
-- =

Gr=E9goire FAVRE  http://gregoire.favre.googlepages.com  http://www.gnupg.o=
rg
               http://picasaweb.google.com/Gregoire.Favre

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
