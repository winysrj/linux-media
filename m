Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nskntmtas06p.mx.bigpond.com ([61.9.168.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jhhummel@bigpond.com>) id 1L6PKT-0005mE-63
	for linux-dvb@linuxtv.org; Sat, 29 Nov 2008 13:53:47 +0100
Received: from nskntotgx03p.mx.bigpond.com ([58.173.115.237])
	by nskntmtas06p.mx.bigpond.com with ESMTP id
	<20081129125301.IVSC1809.nskntmtas06p.mx.bigpond.com@nskntotgx03p.mx.bigpond.com>
	for <linux-dvb@linuxtv.org>; Sat, 29 Nov 2008 12:53:01 +0000
Received: from harriet.localdomain ([58.173.115.237])
	by nskntotgx03p.mx.bigpond.com with ESMTP id
	<20081129125301.FTTB1879.nskntotgx03p.mx.bigpond.com@harriet.localdomain>
	for <linux-dvb@linuxtv.org>; Sat, 29 Nov 2008 12:53:01 +0000
From: Jonathan <jhhummel@bigpond.com>
To: linux-dvb@linuxtv.org
Date: Sat, 29 Nov 2008 23:53:00 +1100
References: <4675AD3E.3090608@email.cz> <492FD9E8.9070600@email.cz>
In-Reply-To: <492FD9E8.9070600@email.cz>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_ssTMJQaY+bNGVaJ"
Message-Id: <200811292353.00677.jhhummel@bigpond.com>
Subject: Re: [linux-dvb] Patch for Leadtek DTV1800H, DTV2000H (rev I, J),
	and (not working yet)  DTV2000H Plus
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_ssTMJQaY+bNGVaJ
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Fri, 28 Nov 2008 10:45:44 pm Mirek Sluge=C5=88 wrote:
> Hi, all 3 patches are in one file, they depend on each other.
>
> All GPIOs spoted from Windows with original APs
>
> DTV1800H - there is patch pending in this thread from Miroslav Sustek,
> this is only modification of his patch, difference should be only in
> GPIOs (I think it is better to use GPIOs from Windows).
>
> DTV2000H (rev. I) - Only renamed from original old DTV2000H
>
> DTV2000H (rev. J) - Almost everything is working, I have problem only
> with FM radio (no sound).
>
> DTV2000H Plus - added pci id, GPIOs, sadly Tuner is XC4000, so it is not
> working yet.
>
> Mirek Slugen


Hi Mirek,

Nice work with the patch!

I gave it a go and found that I still can't get sound for analogue TV and=20
radio.
I have a DTV2000H rev J
Tried:
 - KdeTV
 - TVtime
 - Gnome radio

I'm in Australia with PAL format TV

Attached is the dmesg output

What ya think?

Jon

--Boundary-00=_ssTMJQaY+bNGVaJ
Content-Type: text/plain;
  charset="iso 8859-15";
  name="dmesg output"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg output"

$ dmesg | grep cx88
[   41.248260] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[   41.248364] cx88[0]: subsystem: 107d:6f2b, board: WinFast DTV2000 H (ver. J) [card=80,autodetected], frontend(s): 1
[   41.248367] cx88[0]: TV tuner type 63, Radio tuner type -1
[   41.260644] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   41.381333] tuner' 0-0061: chip found @ 0xc2 (cx88[0])
[   41.381952] tuner' 0-0063: chip found @ 0xc6 (cx88[0])
[   41.719332] input: cx88 IR (WinFast DTV2000 H (ver as /devices/pci0000:00/0000:00:0a.2/input/input4
[   41.729761] cx88[0]/2: cx2388x 8802 Driver Manager
[   41.729797] cx88[0]/2: found at 0000:00:0a.2, rev: 5, irq: 19, latency: 32, mmio: 0xed000000
[   41.729819] cx8802_probe() allocating 1 frontend(s)
[   41.729985] cx88[0]/0: found at 0000:00:0a.0, rev: 5, irq: 19, latency: 32, mmio: 0xeb000000
[   41.730040] cx88[0]/0: registered device video0 [v4l2]
[   41.730062] cx88[0]/0: registered device vbi0
[   41.730080] cx88[0]/0: registered device radio0
[   41.745679] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   41.745728] cx88/2: registering cx8802 driver, type: dvb access: shared
[   41.745732] cx88[0]/2: subsystem: 107d:6f2b, board: WinFast DTV2000 H (ver. J) [card=80]
[   41.745737] cx88[0]/2: cx2388x based DVB/ATSC card
[   42.030063] DVB: registering new adapter (cx88[0])
[ 2006.873694] cx88[0]: irq mpeg  [0x100000] ts_err?*
[ 2006.873706] cx88[0]/2-mpeg: general errors: 0x00100000

--Boundary-00=_ssTMJQaY+bNGVaJ
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_ssTMJQaY+bNGVaJ--
