Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lucastim@gmail.com>) id 1LVDxc-0007i8-Dp
	for linux-dvb@linuxtv.org; Fri, 06 Feb 2009 00:48:44 +0100
Received: by ewy13 with SMTP id 13so969320ewy.17
	for <linux-dvb@linuxtv.org>; Thu, 05 Feb 2009 15:48:10 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 5 Feb 2009 15:48:10 -0800
Message-ID: <e32e0e5d0902051548x3023851cua78424304a09cb7e@mail.gmail.com>
From: Tim Lucas <lucastim@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] DViCO FusionHDTV7 Dual Express
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1390765531=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1390765531==
Content-Type: multipart/alternative; boundary=0015174bdf2e739db80462348934

--0015174bdf2e739db80462348934
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

My cable system was recently updated to time warner so I thought I would try
to get the mythbuntu box working again.
I have the DViCO FusionHDTV7 Dual Express card which seems to be recognized
by my system but I still cannot tune channels. I tried using tvtime and got
the following error

I/O error : Permission denied
Cannot change owner of /home/lucas/.tvtime/tvtime.xml: Permission denied.
videoinput: Cannot open capture device /dev/video0: No such file or
directory.

dmesg says:
[ 9.489376] Linux video capture interface: v2.00 [ 9.528296] cx23885 driver
version 0.0.1 loaded [ 9.528684] ACPI: PCI Interrupt Link [APC6] enabled at
IRQ 16 [ 9.528688] cx23885 0000:08:00.0: PCI INT A -> Link[APC6] -> GSI 16
(level, low) -> IRQ 16 [ 9.528751] CORE cx23885[0]: subsystem: 18ac:d618,
board: DViCO FusionHDTV7 Dual Express [card=10,autod etected] [ 9.716984]
cx23885[0]: i2c bus 0 registered [ 9.717002] cx23885[0]: i2c bus 1
registered [ 9.717016] cx23885[0]: i2c bus 2 registered [ 9.743438]
cx23885[0]: cx23885 based dvb card [ 9.880184] xc5000: Successfully
identified at address 0x64 [ 9.880186] xc5000: Firmware has not been loaded
previously [ 9.880190] DVB: registering new adapter (cx23885[0]) [ 9.880192]
DVB: registering frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)... [
9.880482] cx23885[0]: cx23885 based dvb card [ 9.926399] xc5000:
Successfully identified at address 0x64 [ 9.926401] xc5000: Firmware has not
been loaded previously [ 9.926403] DVB: registering new adapter (cx23885[0])
[ 9.926406] DVB: registering frontend 1 (Samsung S5H1411 QAM/8VSB
Frontend)... [ 9.926642] cx23885_dev_checkrevision() Hardware revision =
0xb0 [ 9.926648] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 16,
latency: 0, mmio: 0xfd800000 [ 9.926654] cx23885 0000:08:00.0: setting
latency timer to 64

I have the latest version of the v4l-dvb code from the mercurial repos. Any
ideas what the problem is?

-- 
    --Tim

--0015174bdf2e739db80462348934
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div>My cable system was recently updated to time warner so I thought I wou=
ld try to get the mythbuntu box working again. &nbsp;</div><div>I have the&=
nbsp;<span class=3D"Apple-style-span" style=3D"border-collapse: collapse; w=
hite-space: pre; -webkit-border-horizontal-spacing: 2px; -webkit-border-ver=
tical-spacing: 2px; ">DViCO FusionHDTV7 Dual Express card which seems to be=
 recognized by my system but I still cannot tune channels. I tried using tv=
time and got the following error</span></div>
<div><span class=3D"Apple-style-span" style=3D"border-collapse: collapse; w=
hite-space: pre; -webkit-border-horizontal-spacing: 2px; -webkit-border-ver=
tical-spacing: 2px;"><br></span></div><div><span class=3D"Apple-style-span"=
 style=3D"border-collapse: collapse; white-space: pre; -webkit-border-horiz=
ontal-spacing: 2px; -webkit-border-vertical-spacing: 2px;">I/O error : Perm=
ission denied</span></div>
<div><span class=3D"Apple-style-span" style=3D"border-collapse: collapse; w=
hite-space: pre; -webkit-border-horizontal-spacing: 2px; -webkit-border-ver=
tical-spacing: 2px;">Cannot change owner of /home/lucas/.tvtime/tvtime.xml:=
 Permission denied.</span></div>
<div><span class=3D"Apple-style-span" style=3D"border-collapse: collapse; w=
hite-space: pre; -webkit-border-horizontal-spacing: 2px; -webkit-border-ver=
tical-spacing: 2px;">videoinput: Cannot open capture device /dev/video0: No=
 such file or directory.</span></div>
<div><span class=3D"Apple-style-span" style=3D"border-collapse: collapse; w=
hite-space: pre; -webkit-border-horizontal-spacing: 2px; -webkit-border-ver=
tical-spacing: 2px;"><br></span></div><div><span class=3D"Apple-style-span"=
 style=3D"border-collapse: collapse; white-space: pre; -webkit-border-horiz=
ontal-spacing: 2px; -webkit-border-vertical-spacing: 2px;">dmesg says:</spa=
n></div>
<div><span class=3D"Apple-style-span" style=3D"border-collapse: collapse; w=
hite-space: pre; -webkit-border-horizontal-spacing: 2px; -webkit-border-ver=
tical-spacing: 2px;">[    9.489376] Linux video capture interface: v2.00
[    9.528296] cx23885 driver version 0.0.1 loaded
[    9.528684] ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
[    9.528688] cx23885 0000:08:00.0: PCI INT A -&gt; Link[APC6] -&gt; GSI 1=
6 (level, low) -&gt; IRQ 16
[    9.528751] CORE cx23885[0]: subsystem: 18ac:d618, board: DViCO FusionHD=
TV7 Dual Express [card=3D10,autod
etected]
[    9.716984] cx23885[0]: i2c bus 0 registered
[    9.717002] cx23885[0]: i2c bus 1 registered
[    9.717016] cx23885[0]: i2c bus 2 registered
[    9.743438] cx23885[0]: cx23885 based dvb card
[    9.880184] xc5000: Successfully identified at address 0x64
[    9.880186] xc5000: Firmware has not been loaded previously
[    9.880190] DVB: registering new adapter (cx23885[0])
[    9.880192] DVB: registering frontend 0 (Samsung S5H1411 QAM/8VSB Fronte=
nd)...
[    9.880482] cx23885[0]: cx23885 based dvb card
[    9.926399] xc5000: Successfully identified at address 0x64
[    9.926401] xc5000: Firmware has not been loaded previously
[    9.926403] DVB: registering new adapter (cx23885[0])
[    9.926406] DVB: registering frontend 1 (Samsung S5H1411 QAM/8VSB Fronte=
nd)...
[    9.926642] cx23885_dev_checkrevision() Hardware revision =3D 0xb0
[    9.926648] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 16, latenc=
y: 0, mmio: 0xfd800000
[    9.926654] cx23885 0000:08:00.0: setting latency timer to 64<br></span>=
</div><div><span class=3D"Apple-style-span" style=3D"border-collapse: colla=
pse; white-space: pre; -webkit-border-horizontal-spacing: 2px; -webkit-bord=
er-vertical-spacing: 2px;"><br>
</span></div><div><span class=3D"Apple-style-span" style=3D"border-collapse=
: collapse; white-space: pre; -webkit-border-horizontal-spacing: 2px; -webk=
it-border-vertical-spacing: 2px;">I have the latest version of the v4l-dvb =
code from the mercurial repos.  Any ideas what the problem is?</span></div>
<br>-- <br> &nbsp; &nbsp; --Tim<br>

--0015174bdf2e739db80462348934--


--===============1390765531==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1390765531==--
