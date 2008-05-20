Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1JyZf9-0003zM-G0
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 23:46:34 +0200
Received: from wfilter.us4.outblaze.com.int (wfilter.us4.outblaze.com.int
	[192.168.9.180])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	ACE981800D9F
	for <linux-dvb@linuxtv.org>; Tue, 20 May 2008 21:45:49 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: "jochen s" <bumkunjo@gmx.de>, linux-dvb@linuxtv.org
Date: Wed, 21 May 2008 07:45:48 +1000
Message-Id: <20080520214549.60B471CE808@ws1-6.us4.outblaze.com>
Cc: stev391@email.com
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0999783835=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0999783835==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_121131994895111"

This is a multi-part message in MIME format.

--_----------=_121131994895111
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

 Jochen,

Which sources is this dmesg output from (my patch or Chris Pascoe's
xc-test branch)?  Mine are definately dead in the water at the moment as
the existing code relies on the moons alligning to work.  I'm still
working on this...

If it is from Chris Pascoe's branch it should work, if not for the module
"tuner_xc2028" when loading pass the option debug=3D1 (This will generate
alot more lines in dmesg) and repeat whatever you did to break it.  Send
this on and I will attempt to work out where it is going wrong.

Regards,
Stephen

  ----- Original Message -----
  From: "jochen s"
  To: linux-dvb@linuxtv.org
  Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]
  Date: Tue, 20 May 2008 18:10:26 +0200



  May 20 17:48:11 kernel: [ 48.744161] ACPI: PCI Interrupt 0000:02:00.0
  [A] -> GSI 16 (level, low) -> IRQ 16
  May 20 17:48:11 kernel: [ 48.744179] CORE cx23885[0]: subsystem:
  18ac:db78, board: DViCO FusionHDTV DVB-T Dual Express
  [card=3D10,autodetected]
  May 20 17:48:11 kernel: [ 48.844132] cx23885[0]: i2c bus 0 registered
  May 20 17:48:11 kernel: [ 48.844154] cx23885[0]: i2c bus 1 registered
  May 20 17:48:11 kernel: [ 48.844168] cx23885[0]: i2c bus 2 registered
  May 20 17:48:11 kernel: [ 48.908665] input: i2c IR (FusionHDTV)
  as /class/input/input3
  May 20 17:48:11 kernel: [ 48.908687] ir-kbd-i2c: i2c IR (FusionHDTV)
  detected at i2c-2/2-006b/ir0 [cx23885[0]]
  May 20 17:48:11 kernel: [ 48.909711] cx23885[0]: cx23885 based dvb
  card
  May 20 17:48:11 kernel: [ 48.970326] xc2028 2-0061: type set to
  XCeive
  xc2028/xc3028 tuner
  May 20 17:48:11 kernel: [ 48.970336] DVB: registering new adapter
  (cx23885
  [0])
  May 20 17:48:11 kernel: [ 48.970340] DVB: registering frontend 1
  (Zarlink
  ZL10353 DVB-T)...
  May 20 17:48:11 kernel: [ 48.970625] cx23885[0]: cx23885 based dvb
  card
  May 20 17:48:11 kernel: [ 48.976144] xc2028 3-0061: type set to
  XCeive
  xc2028/xc3028 tuner
  May 20 17:48:11 kernel: [ 48.976147] DVB: registering new adapter
  (cx23885
  [0])
  May 20 17:48:11 kernel: [ 48.976151] DVB: registering frontend 2
  (Zarlink
  ZL10353 DVB-T)...
  May 20 17:48:11 kernel: [ 48.976368] cx23885_dev_checkrevision()
  Hardware
  revision =3D 0xb0
  May 20 17:48:11 kernel: [ 48.976376] cx23885[0]/0: found at
  0000:02:00.0,
  rev: 2, irq: 16, latency: 0, mmio: 0xfd600000
  May 20 17:48:11 kernel: [ 48.976383] PCI: Setting latency timer of
  device
  0000:02:00.0 to 64

  ok - so far...

  but then:

  May 20 17:48:50 vdr: [7428] frontend 1 timed out while tuning to
  channel 2,
  tp 514
  May 20 17:48:50 kernel: [ 80.313642] xc2028 2-0061: Loading firmware
  for
  type=3DBASE F8MHZ (3), id 0000000000000000.
  May 20 17:48:51 kernel: [ 81.247786] xc2028 2-0061: Loading firmware
  for
  type=3DBASE F8MHZ (3), id 0000000000000000.
  May 20 17:48:53 kernel: [ 83.150433] xc2028 2-0061: Loading firmware
  for
  type=3DBASE F8MHZ (3), id 0000000000000000.
  May 20 17:48:53 kernel: [ 83.720342] eth0: no IPv6 routers present
  May 20 17:48:54 kernel: [ 84.117987] xc2028 2-0061: Loading firmware
  for
  type=3DBASE F8MHZ (3), id 0000000000000000.
  May 20 17:48:56 kernel: [ 86.047256] xc2028 2-0061: Loading firmware
  for
  type=3DBASE F8MHZ (3), id 0000000000000000.
  May 20 17:48:57 kernel: [ 86.979688] xc2028 2-0061: Loading firmware
  for
  type=3DBASE F8MHZ (3), id 0000000000000000.
  ...
  May 20 17:48:59 kernel: [ 88.486428] xc2028 2-0061: Loading firmware
  for
  type=3DBASE F8MHZ (3), id 0000000000000000.
  May 20 17:49:00 kernel: [ 89.498026] xc2028 2-0061: Loading firmware
  for
  type=3DBASE F8MHZ (3), id 0000000000000000.
  May 20 17:49:02 kernel: [ 91.416250] xc2028 2-0061: Loading firmware
  for
  type=3DBASE F8MHZ (3), id 0000000000000000.
  May 20 17:49:03 kernel: [ 92.346871] xc2028 2-0061: Loading firmware
  for
  type=3DBASE F8MHZ (3), id 0000000000000000.
  ...
  May 20 17:49:23 kernel: [ 109.368185] xc2028 2-0061: Loading firmware
  for
  type=3DBASE F8MHZ (3), id 0000000000000000.
  May 20 17:49:24 kernel: [ 109.934506] xc2028 3-0061: Loading 3
  firmware
  images from xc3028-dvico-au-01.fw, type: DViCO DualDig4/Nano2
  (Australia),
  ver 2.7
  May 20 17:49:24 kernel: [ 109.938812] xc2028 3-0061: Loading firmware
  for
  type=3DBASE F8MHZ (3), id 0000000000000000.
  May 20 17:49:24 kernel: [ 110.034395] xc2028 2-0061: i2c output
  error: rc
  =3D -5 (should be 4)
  May 20 17:49:24 kernel: [ 110.034399] xc2028 2-0061: -5 returned from
  send
  May 20 17:49:24 kernel: [ 110.034434] xc2028 2-0061: Error -22 while
  loading base firmware
  May 20 17:49:24 kernel: [ 110.081951] xc2028 2-0061: Loading firmware
  for
  type=3DBASE F8MHZ (3), id 0000000000000000.
  May 20 17:49:24 kernel: [ 110.088001] xc2028 2-0061: i2c output
  error: rc
  =3D -5 (should be 64)
  May 20 17:49:24 kernel: [ 110.088003] xc2028 2-0061: -5 returned from
  send
  May 20 17:49:24 kernel: [ 110.088050] xc2028 2-0061: Error -22 while
  loading base firmware
  May 20 17:49:24 kernel: [ 110.089843] zl10353: write to reg 62 failed
  (err
  =3D -5)!
  May 20 17:49:24 kernel: [ 110.091667] zl10353: write to reg 5f failed
  (err
  =3D -5)!
  May 20 17:49:24 kernel: [ 110.093428] zl10353: write to reg 71 failed
  (err
  =3D -5)!
  May 20 17:49:24 kernel: [ 110.095201] zl10353_read_register: readreg
  error
  (reg=3D6, ret=3D=3D-5)
  May 20 17:49:24 kernel: [ 110.105956] zl10353_read_register: readreg
  error
  (reg=3D6, ret=3D=3D-5)
  May 20 17:49:24 kernel: [ 110.116251] zl10353_read_register: readreg
  error
  (reg=3D6, ret=3D=3D-5)
  ...

  May 20 18:01:00 kernel: [ 791.122235] xc2028 3-0061: Loading firmware
  for
  type=3DBASE F8MHZ (3), id 0000000000000000.
  May 20 18:01:01 kernel: [ 791.998348] xc2028 2-0061: Loading firmware
  for
  type=3DBASE F8MHZ (3), id 0000000000000000.
  May 20 18:01:02 kernel: [ 793.049839] xc2028 2-0061: Loading firmware
  for
  type=3DBASE F8MHZ (3), id 0000000000000000.
  May 20 18:01:02 kernel: [ 793.144856] xc2028 3-0061: Loading firmware
  for
  type=3DBASE F8MHZ (3), id 0000000000000000.
  May 20 18:01:03 kernel: [ 794.054455] xc2028 2-0061: i2c output
  error: rc
  =3D -5 (should be 4)
  May 20 18:01:03 kernel: [ 794.054460] xc2028 2-0061: -5 returned from
  send
  May 20 18:01:03 kernel: [ 794.054528] xc2028 2-0061: Error -22 while
  loading base firmware
  May 20 18:01:03 kernel: [ 794.056622] zl10353: write to reg 62 failed
  (err
  =3D -5)!
  May 20 18:01:03 kernel: [ 794.058744] zl10353: write to reg 5f failed
  (err
  =3D -5)!
  May 20 18:01:03 kernel: [ 794.060858] zl10353: write to reg 71 failed
  (err
  =3D -5)!
  May 20 18:01:03 kernel: [ 794.063013] zl10353_read_register: readreg
  error
  (reg=3D6, ret=3D=3D-5)
  May 20 18:01:03 kernel: [ 794.075006] zl10353_read_register: readreg
  error
  (reg=3D6, ret=3D=3D-5)
  May 20 18:01:03 kernel: [ 794.087060] zl10353_read_register: readreg
  error
  (reg=3D6, ret=3D=3D-5)
  May 20 18:01:03 kernel: [ 794.098969] zl10353_read_register: readreg
  error
  (reg=3D6, ret=3D=3D-5)
  May 20 18:01:03 kernel: [ 794.111100] zl10353_read_register: readreg
  error
  (reg=3D6, ret=3D=3D-5)
  May 20 18:01:03 kernel: [ 794.122939] zl10353_read_register: readreg
  error
  (reg=3D6, ret=3D=3D-5)
  May 20 18:01:03 kernel: [ 794.135009] zl10353_read_register: readreg
  error
  (reg=3D6, ret=3D=3D-5)
  May 20 18:01:03 kernel: [ 794.148908] zl10353_read_register: readreg
  error
  (reg=3D6, ret=3D=3D-5)

  any idea to help me?

  thanks in advance, jochen

  Am Donnerstag 15 Mai 2008 00:12:52 schrieb stev391@email.com:
  > Thom,
  >
  > Disclaimer: This not guranteed to work and will break any webcams
  you
  > have running on ubuntu, this is reversable by reinstalling the
  "linux-*"
  > packages that you have already installed.
  >
  > I can't seem to find any information about that version of
  Mythbuntu, is
  > it supposed to be version 8.04? Anyway the following will work for
  > previous versions as well.
  > All commands to be run in a terminal.
  >
  > Step 1, Install the required packages to retrieve and compile the
  source
  > (you also need to install the linux-headers that match your kernel,
  which
  > is done by the following command as well)
  > sudo apt-get install mercurial build-essential patch
  linux-headers-`uname
  > -r`
  >
  > Step 2, Retrieve the v4l-dvb sources
  > hg clone http://linuxtv.org/hg/v4l-dvb
  >
  > Step 3, Apply patch (which was an attachment on the previous email)
  > cd v4l-dvb
  > patch -p1 < ../DViCO_FUSIONHDTV_DVB_T_DUAL_EXP_v2.patch
  >
  > Step 4, Compile which will take awhile... (maybe time to make a cup
  of
  > coffee)
  > make all
  >
  > Step 5 Remove the old modules as this causes issues when loading
  the
  > modules later(this depends on version of ubuntu)
  > 8.04: cd /lib/modules/`uname -r`/ubuntu/media
  > cd /lib/modules/`uname -r`/kernel/drivers/media
  > sudo rm -r common
  > sudo rm -r dvb
  > sudo rm -r radio
  > sudo rm -r video
  >
  > Step 6: return to v4l-dvb directory and run:
  > sudo make install
  >
  > Step 7: Update the initramfs:
  > sudo dpkg-reconfigure linux-ubuntu-modules-`uname -r`
  >
  > Step 8: Reboot and see if it worked
  > sudo shutdown -r now
  >
  > If this didn't work with my patch please send me the output of
  dmesg and
  > any relevant logs of the application that you used to identify the
  > problem with (eg mythbackend log). Then try replacing step 2 & 3
  with
  > (This uses the older branch by Chris Pascoe, whose code I'm trying
  to
  > update to bring into the main v4l-dvb):
  > hg clone http://linuxtv.org/hg/~pascoe/xc-test/
  > cd xc-test
  >
  > If this still doesn't work and your dvb system is broken just
  reinstall
  > your linux-* packages.
  >
  > Regards,
  > Stephen

--=20
See Exclusive Video: 10th Annual Young Hollywood Awards
http://www.hollywoodlife.net/younghollywoodawards2008/


--_----------=_121131994895111
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="utf-8"


<div>
Jochen,<br><br>Which sources is this dmesg output from (my patch or Chris P=
ascoe's xc-test branch)?&nbsp; Mine are definately dead in the water at the=
 moment as the existing code relies on the moons alligning to work.&nbsp; I=
'm still working on this...<br><br>
If it is from Chris Pascoe's branch it should work, if not for the module "=
tuner_xc2028" when loading pass the option debug=3D1 (This will generate al=
ot more lines in dmesg) and repeat whatever you did to break it.&nbsp; Send=
 this on and I will attempt to work out where it is going wrong.<br><br>Reg=
ards,<br>Stephen<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: "jochen s" <bumkunjo@gmx.de><br>
To: linux-dvb@linuxtv.org<br>
Subject: Re: [linux-dvb] DViCO Fusion HDTV DVB-T Dual Express [PATCH]<br>
Date: Tue, 20 May 2008 18:10:26 +0200<br>
<br>
<br>
<br>
May 20 17:48:11   kernel: [   48.744161] ACPI: PCI Interrupt 0000:02:00.0<b=
r>
[A] -&gt; GSI 16 (level, low) -&gt; IRQ 16<br>
May 20 17:48:11   kernel: [   48.744179] CORE cx23885[0]: subsystem:<br>
18ac:db78, board: DViCO FusionHDTV DVB-T Dual Express [card=3D10,autodetect=
ed]<br>
May 20 17:48:11   kernel: [   48.844132] cx23885[0]: i2c bus 0 registered<b=
r>
May 20 17:48:11   kernel: [   48.844154] cx23885[0]: i2c bus 1 registered<b=
r>
May 20 17:48:11   kernel: [   48.844168] cx23885[0]: i2c bus 2 registered<b=
r>
May 20 17:48:11   kernel: [   48.908665] input: i2c IR (FusionHDTV)<br>
as /class/input/input3<br>
May 20 17:48:11   kernel: [   48.908687] ir-kbd-i2c: i2c IR (FusionHDTV)<br>
detected at i2c-2/2-006b/ir0 [cx23885[0]]<br>
May 20 17:48:11   kernel: [   48.909711] cx23885[0]: cx23885 based dvb card=
<br>
May 20 17:48:11   kernel: [   48.970326] xc2028 2-0061: type set to XCeive<=
br>
xc2028/xc3028 tuner<br>
May 20 17:48:11   kernel: [   48.970336] DVB: registering new adapter (cx23=
885<br>
[0])<br>
May 20 17:48:11   kernel: [   48.970340] DVB: registering frontend 1 (Zarli=
nk<br>
ZL10353 DVB-T)...<br>
May 20 17:48:11   kernel: [   48.970625] cx23885[0]: cx23885 based dvb card=
<br>
May 20 17:48:11   kernel: [   48.976144] xc2028 3-0061: type set to XCeive<=
br>
xc2028/xc3028 tuner<br>
May 20 17:48:11   kernel: [   48.976147] DVB: registering new adapter (cx23=
885<br>
[0])<br>
May 20 17:48:11   kernel: [   48.976151] DVB: registering frontend 2 (Zarli=
nk<br>
ZL10353 DVB-T)...<br>
May 20 17:48:11   kernel: [   48.976368] cx23885_dev_checkrevision() Hardwa=
re<br>
revision =3D 0xb0<br>
May 20 17:48:11   kernel: [   48.976376] cx23885[0]/0: found at 0000:02:00.=
0,<br>
rev: 2, irq: 16, latency: 0, mmio: 0xfd600000<br>
May 20 17:48:11   kernel: [   48.976383] PCI: Setting latency timer of devi=
ce<br>
0000:02:00.0 to 64<br>
<br>
ok - so far...<br>
<br>
but then:<br>
<br>
May 20 17:48:50   vdr: [7428] frontend 1 timed out while tuning to channel =
2,<br>
tp 514<br>
May 20 17:48:50   kernel: [   80.313642] xc2028 2-0061: Loading firmware fo=
r<br>
type=3DBASE F8MHZ (3), id 0000000000000000.<br>
May 20 17:48:51   kernel: [   81.247786] xc2028 2-0061: Loading firmware fo=
r<br>
type=3DBASE F8MHZ (3), id 0000000000000000.<br>
May 20 17:48:53   kernel: [   83.150433] xc2028 2-0061: Loading firmware fo=
r<br>
type=3DBASE F8MHZ (3), id 0000000000000000.<br>
May 20 17:48:53   kernel: [   83.720342] eth0: no IPv6 routers present<br>
May 20 17:48:54   kernel: [   84.117987] xc2028 2-0061: Loading firmware fo=
r<br>
type=3DBASE F8MHZ (3), id 0000000000000000.<br>
May 20 17:48:56   kernel: [   86.047256] xc2028 2-0061: Loading firmware fo=
r<br>
type=3DBASE F8MHZ (3), id 0000000000000000.<br>
May 20 17:48:57   kernel: [   86.979688] xc2028 2-0061: Loading firmware fo=
r<br>
type=3DBASE F8MHZ (3), id 0000000000000000.<br>
...<br>
May 20 17:48:59   kernel: [   88.486428] xc2028 2-0061: Loading firmware fo=
r<br>
type=3DBASE F8MHZ (3), id 0000000000000000.<br>
May 20 17:49:00   kernel: [   89.498026] xc2028 2-0061: Loading firmware fo=
r<br>
type=3DBASE F8MHZ (3), id 0000000000000000.<br>
May 20 17:49:02   kernel: [   91.416250] xc2028 2-0061: Loading firmware fo=
r<br>
type=3DBASE F8MHZ (3), id 0000000000000000.<br>
May 20 17:49:03   kernel: [   92.346871] xc2028 2-0061: Loading firmware fo=
r<br>
type=3DBASE F8MHZ (3), id 0000000000000000.<br>
...<br>
May 20 17:49:23   kernel: [  109.368185] xc2028 2-0061: Loading firmware fo=
r<br>
type=3DBASE F8MHZ (3), id 0000000000000000.<br>
May 20 17:49:24   kernel: [  109.934506] xc2028 3-0061: Loading 3 firmware<=
br>
images from xc3028-dvico-au-01.fw, type: DViCO DualDig4/Nano2 (Australia),<=
br>
ver 2.7<br>
May 20 17:49:24   kernel: [  109.938812] xc2028 3-0061: Loading firmware fo=
r<br>
type=3DBASE F8MHZ (3), id 0000000000000000.<br>
May 20 17:49:24   kernel: [  110.034395] xc2028 2-0061: i2c output error: r=
c<br>
=3D -5 (should be 4)<br>
May 20 17:49:24   kernel: [  110.034399] xc2028 2-0061: -5 returned from se=
nd<br>
May 20 17:49:24   kernel: [  110.034434] xc2028 2-0061: Error -22 while<br>
loading base firmware<br>
May 20 17:49:24   kernel: [  110.081951] xc2028 2-0061: Loading firmware fo=
r<br>
type=3DBASE F8MHZ (3), id 0000000000000000.<br>
May 20 17:49:24   kernel: [  110.088001] xc2028 2-0061: i2c output error: r=
c<br>
=3D -5 (should be 64)<br>
May 20 17:49:24   kernel: [  110.088003] xc2028 2-0061: -5 returned from se=
nd<br>
May 20 17:49:24   kernel: [  110.088050] xc2028 2-0061: Error -22 while<br>
loading base firmware<br>
May 20 17:49:24   kernel: [  110.089843] zl10353: write to reg 62 failed (e=
rr<br>
=3D -5)!<br>
May 20 17:49:24   kernel: [  110.091667] zl10353: write to reg 5f failed (e=
rr<br>
=3D -5)!<br>
May 20 17:49:24   kernel: [  110.093428] zl10353: write to reg 71 failed (e=
rr<br>
=3D -5)!<br>
May 20 17:49:24   kernel: [  110.095201] zl10353_read_register: readreg err=
or<br>
(reg=3D6, ret=3D=3D-5)<br>
May 20 17:49:24   kernel: [  110.105956] zl10353_read_register: readreg err=
or<br>
(reg=3D6, ret=3D=3D-5)<br>
May 20 17:49:24   kernel: [  110.116251] zl10353_read_register: readreg err=
or<br>
(reg=3D6, ret=3D=3D-5)<br>
...<br>
<br>
May 20 18:01:00   kernel: [  791.122235] xc2028 3-0061: Loading firmware fo=
r<br>
type=3DBASE F8MHZ (3), id 0000000000000000.<br>
May 20 18:01:01   kernel: [  791.998348] xc2028 2-0061: Loading firmware fo=
r<br>
type=3DBASE F8MHZ (3), id 0000000000000000.<br>
May 20 18:01:02   kernel: [  793.049839] xc2028 2-0061: Loading firmware fo=
r<br>
type=3DBASE F8MHZ (3), id 0000000000000000.<br>
May 20 18:01:02   kernel: [  793.144856] xc2028 3-0061: Loading firmware fo=
r<br>
type=3DBASE F8MHZ (3), id 0000000000000000.<br>
May 20 18:01:03   kernel: [  794.054455] xc2028 2-0061: i2c output error: r=
c<br>
=3D -5 (should be 4)<br>
May 20 18:01:03   kernel: [  794.054460] xc2028 2-0061: -5 returned from se=
nd<br>
May 20 18:01:03   kernel: [  794.054528] xc2028 2-0061: Error -22 while<br>
loading base firmware<br>
May 20 18:01:03   kernel: [  794.056622] zl10353: write to reg 62 failed (e=
rr<br>
=3D -5)!<br>
May 20 18:01:03   kernel: [  794.058744] zl10353: write to reg 5f failed (e=
rr<br>
=3D -5)!<br>
May 20 18:01:03   kernel: [  794.060858] zl10353: write to reg 71 failed (e=
rr<br>
=3D -5)!<br>
May 20 18:01:03   kernel: [  794.063013] zl10353_read_register: readreg err=
or<br>
(reg=3D6, ret=3D=3D-5)<br>
May 20 18:01:03   kernel: [  794.075006] zl10353_read_register: readreg err=
or<br>
(reg=3D6, ret=3D=3D-5)<br>
May 20 18:01:03   kernel: [  794.087060] zl10353_read_register: readreg err=
or<br>
(reg=3D6, ret=3D=3D-5)<br>
May 20 18:01:03   kernel: [  794.098969] zl10353_read_register: readreg err=
or<br>
(reg=3D6, ret=3D=3D-5)<br>
May 20 18:01:03   kernel: [  794.111100] zl10353_read_register: readreg err=
or<br>
(reg=3D6, ret=3D=3D-5)<br>
May 20 18:01:03   kernel: [  794.122939] zl10353_read_register: readreg err=
or<br>
(reg=3D6, ret=3D=3D-5)<br>
May 20 18:01:03   kernel: [  794.135009] zl10353_read_register: readreg err=
or<br>
(reg=3D6, ret=3D=3D-5)<br>
May 20 18:01:03   kernel: [  794.148908] zl10353_read_register: readreg err=
or<br>
(reg=3D6, ret=3D=3D-5)<br>
<br>
any idea to help me?<br>
<br>
thanks in advance, jochen<br>
<br>
Am Donnerstag 15 Mai 2008 00:12:52 schrieb stev391@email.com:<br>
&gt;  Thom,<br>
&gt;<br>
&gt; Disclaimer: This not guranteed to work and will break any webcams you<=
br>
&gt; have running on ubuntu, this is reversable by reinstalling the "linux-=
*"<br>
&gt; packages that you have already installed.<br>
&gt;<br>
&gt; I can't seem to find any information about that version of Mythbuntu, =
is<br>
&gt; it supposed to be version 8.04? Anyway the following will work for<br>
&gt; previous versions as well.<br>
&gt; All commands to be run in a terminal.<br>
&gt;<br>
&gt; Step 1, Install the required packages to retrieve and compile the sour=
ce<br>
&gt; (you also need to install the linux-headers that match your kernel, wh=
ich<br>
&gt; is done by the following command as well)<br>
&gt; sudo apt-get install mercurial build-essential patch linux-headers-`un=
ame<br>
&gt; -r`<br>
&gt;<br>
&gt; Step 2, Retrieve the v4l-dvb sources<br>
&gt; hg clone http://linuxtv.org/hg/v4l-dvb<br>
&gt;<br>
&gt; Step 3, Apply patch (which was an attachment on the previous email)<br>
&gt; cd v4l-dvb<br>
&gt; patch -p1 &lt; ../DViCO_FUSIONHDTV_DVB_T_DUAL_EXP_v2.patch<br>
&gt;<br>
&gt; Step 4, Compile which will take awhile... (maybe time to make a cup of=
<br>
&gt; coffee)<br>
&gt; make all<br>
&gt;<br>
&gt; Step 5 Remove the old modules as this causes issues when loading the<b=
r>
&gt; modules later(this depends on version of ubuntu)<br>
&gt; 8.04:  cd /lib/modules/`uname -r`/ubuntu/media<br>
&gt; cd /lib/modules/`uname -r`/kernel/drivers/media<br>
&gt; sudo rm -r common<br>
&gt; sudo rm -r dvb<br>
&gt; sudo rm -r radio<br>
&gt; sudo rm -r video<br>
&gt;<br>
&gt; Step 6: return to v4l-dvb directory and run:<br>
&gt; sudo make install<br>
&gt;<br>
&gt; Step 7: Update the initramfs:<br>
&gt; sudo dpkg-reconfigure linux-ubuntu-modules-`uname -r`<br>
&gt;<br>
&gt; Step 8: Reboot and see if it worked<br>
&gt; sudo shutdown -r now<br>
&gt;<br>
&gt; If this didn't work with my patch please send me the output of dmesg a=
nd<br>
&gt; any relevant logs of the application that you used to identify the<br>
&gt; problem with (eg mythbackend log). Then try replacing step 2 &amp; 3 w=
ith<br>
&gt; (This uses the older branch by Chris Pascoe, whose code I'm trying to<=
br>
&gt; update to bring into the main v4l-dvb):<br>
&gt; hg clone http://linuxtv.org/hg/~pascoe/xc-test/<br>
&gt; cd xc-test<br>
&gt;<br>
&gt; If this still doesn't work and your dvb system is broken just reinstal=
l<br>
&gt; your linux-* packages.<br>
&gt;<br>
&gt; Regards,<br>
&gt; Stephen<br>
</bumkunjo@gmx.de></blockquote>
</div>
<BR>

--=20
<div> See Exclusive Video: <a href=3D "http://www.hollywoodlife.net/youngho=
llywoodawards2008/" target=3D"_blank"> <b> 10th Annual Young Hollywood Awar=
ds</b></a><br></div>

--_----------=_121131994895111--



--===============0999783835==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0999783835==--
