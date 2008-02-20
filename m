Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sif.is.scarlet.be ([193.74.71.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ben@bbackx.com>) id 1JRmuw-0001Wf-RL
	for linux-dvb@linuxtv.org; Wed, 20 Feb 2008 12:15:15 +0100
Received: from fry (ip-81-11-173-211.dsl.scarlet.be [81.11.173.211])
	by sif.is.scarlet.be (8.14.2/8.14.2) with ESMTP id m1KBF93O022710
	for <linux-dvb@linuxtv.org>; Wed, 20 Feb 2008 12:15:10 +0100
From: "Ben Backx" <ben@bbackx.com>
To: <linux-dvb@linuxtv.org>
References: 
In-Reply-To: 
Date: Wed, 20 Feb 2008 12:15:02 +0100
Message-ID: <003501c873b1$d72ff870$858fe950$@com>
MIME-Version: 1.0
Content-Language: en-gb
Subject: Re: [linux-dvb] Null pointer in dvb_device_open
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0360927627=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multipart message in MIME format.

--===============0360927627==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_0036_01C873BA.38F46070"
Content-Language: en-gb

This is a multipart message in MIME format.

------=_NextPart_000_0036_01C873BA.38F46070
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Sorry for the messed-up dmesg-output, hopefully this time it's better:

[  484.858908] BUG: unable to handle kernel NULL pointer dereference at
virtual address 00000000
[  484.858917]  printing eip:
[  484.858919] f8cd360a
[  484.858921] *pde = 00000000
[  484.858924] Oops: 0000 [#1]
[  484.858925] SMP 
[  484.858928] Modules linked in: dvb_driver dvb_core ipv6 af_packet rfcomm
l2cap bluetooth ppdev cpufreq_ondemand cpufreq_stats cpufreq_powersave
cpufreq_userspace freq_table cpufreq_conservative sbs button ac container
dock video battery sbp2 lp snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore parport_pc
parport pcspkr snd_page_alloc shpchp pci_hotplug i2c_nforce2 i2c_core
nvidia_agp agpgart dv1394 evdev ext3 jbd mbcache sg sd_mod ide_cd cdrom
usbhid hid amd74xx ide_core sata_sil ohci1394 ieee1394 ata_generic libata
scsi_mod forcedeth ehci_hcd ohci_hcd usbcore thermal processor fan fuse
apparmor commoncap
[  484.858978] CPU:    0
[  484.858979] EIP:    0060:[<f8cd360a>]    Not tainted VLI
[  484.858981] EFLAGS: 00010293   (2.6.22-14-generic #1)
[  484.858999] EIP is at dvb_device_open+0x3a/0x120 [dvb_core]
[  484.859002] eax: eafcfc04   ebx: 76697264   ecx: f8ce6600   edx: 00000003
[  484.859006] esi: 00000000   edi: eafcfc0c   ebp: eafcfc00   esp: ea123ec0
[  484.859009] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[  484.859012] Process scan (pid: 5981, ti=ea122000 task=ea766f90
task.ti=ea122000)
[  484.859015] Stack: ec9ae960 eb2aa8d0 00000003 f8cd35d0 f8ce65a0 00000000
eb2aa8d0 c0183466
[  484.859021]        ec9ae960 00000003 ec9ae960 eb2aa8d0 00000000 c01833c0
c017ec48 dff5ac00 
[  484.859028]        e9a2c440 ec9ae960 ffffff9c ea123f30 00000003 c017ee05
ec9ae960 00000000 
[  484.859034] Call Trace:
[  484.859038]  [<f8cd35d0>] dvb_device_open+0x0/0x120 [dvb_core]
[  484.859048]  [<c0183466>] chrdev_open+0xa6/0x190
[  484.859058]  [<c01833c0>] chrdev_open+0x0/0x190
[  484.859062]  [<c017ec48>] __dentry_open+0xb8/0x1c0
[  484.859073]  [<c017ee05>] nameidata_to_filp+0x35/0x40
[  484.859079]  [<c017ee60>] do_filp_open+0x50/0x60
[  484.859085]  [<c02f20ea>] schedule+0x2ca/0x890
[  484.859099]  [<c017eebe>] do_sys_open+0x4e/0xf0
[  484.859105]  [<c01813b1>] sys_write+0x41/0x70
[  484.859110]  [<c017ef9c>] sys_open+0x1c/0x20
[  484.859114]  [<c01041d2>] sysenter_past_esp+0x6b/0xa9
[  484.859128]  =======================
[  484.859129] Code: 50 34 a1 6c 66 ce f8 81 e2 ff ff 0f 00 89 54 24 08 eb
02 89 d8 8b 18 0f 18 03 90 3d 6c 66 ce f8 74 35 8d 68 fc 8b 75 0c 8d 78 08
<8b> 0e 0f 18 01 90 39 fe 74 de 8b 46 14 8b 55 00 c1 e0 04 0b 46 
[  484.859154] EIP: [<f8cd360a>] dvb_device_open+0x3a/0x120 [dvb_core]
SS:ESP 0068:ea123ec0


		_____________________________________________
		From: Ben Backx [mailto:ben@bbackx.com] 
		Sent: 20 February 2008 12:07
		To: 'linux-dvb@linuxtv.org'
		Subject: Null pointer in dvb_device_open
		

		Hi,

		I'm (still) developing a driver for a dvb-device, I'm making
some progress, but I'm currently stuck at a null-pointer in dvb_device_open.
The (relevant) dmesg-output:

		[  484.858908] BUG: unable to handle kernel NULL pointer
dereference at virtual address 00000000[  484.858917]  printing eip:[
484.858919] f8cd360a[  484.858921] *pde = 00000000[  484.858924] Oops: 0000
[#1][  484.858925] SMP [  484.858928] Modules linked in: dvb_driver dvb_core
ipv6 af_packet rfcomm l2cap bluetooth ppdev cpufreq_ondemand cpufreq_stats
cpufreq_powersave cpufreq_userspace freq_table cpufreq_conservative sbs
button ac container dock video battery sbp2 lp snd_intel8x0 snd_ac97_codec
ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device
snd soundcore parport_pc parport pcspkr snd_page_alloc shpchp pci_hotplug
i2c_nforce2 i2c_core nvidia_agp agpgart dv1394 evdev ext3 jbd mbcache sg
sd_mod ide_cd cdrom usbhid hid amd74xx ide_core sata_sil ohci1394 ieee1394
ata_generic libata scsi_mod forcedeth ehci_hcd ohci_hcd usbcore thermal
processor fan fuse apparmor commoncap[  484.858978] CPU:    0[  484.858979]
EIP:    0060:[<f8cd360a>]    Not tainted VLI[  484.858981] EFLAGS: 00010293
(2.6.22-14-generic #1)[  484.858999] EIP is at dvb_device_open+0x3a/0x120
[dvb_core][  484.859002] eax: eafcfc04   ebx: 76697264   ecx: f8ce6600
edx: 00000003[  484.859006] esi: 00000000   edi: eafcfc0c   ebp: eafcfc00
esp: ea123ec0[  484.859009] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss:
0068[  484.859012] Process scan (pid: 5981, ti=ea122000 task=ea766f90
task.ti=ea122000)[  484.859015] Stack: ec9ae960 eb2aa8d0 00000003 f8cd35d0
f8ce65a0 00000000 eb2aa8d0 c0183466 [  484.859021]        ec9ae960 00000003
ec9ae960 eb2aa8d0 00000000 c01833c0 c017ec48 dff5ac00 [  484.859028]
e9a2c440 ec9ae960 ffffff9c ea123f30 00000003 c017ee05 ec9ae960 00000000 [
484.859034] Call Trace:[  484.859038]  [<f8cd35d0>]
dvb_device_open+0x0/0x120 [dvb_core][  484.859048]  [<c0183466>]
chrdev_open+0xa6/0x190[  484.859058]  [<c01833c0>] chrdev_open+0x0/0x190[
484.859062]  [<c017ec48>] __dentry_open+0xb8/0x1c0[  484.859073]
[<c017ee05>] nameidata_to_filp+0x35/0x40[  484.859079]  [<c017ee60>]
do_filp_open+0x50/0x60[  484.859085]  [<c02f20ea>] schedule+0x2ca/0x890[
484.859099]  [<c017eebe>] do_sys_open+0x4e/0xf0[  484.859105]  [<c01813b1>]
sys_write+0x41/0x70[  484.859110]  [<c017ef9c>] sys_open+0x1c/0x20[
484.859114]  [<c01041d2>] sysenter_past_esp+0x6b/0xa9[  484.859128]
=======================[  484.859129] Code: 50 34 a1 6c 66 ce f8 81 e2 ff ff
0f 00 89 54 24 08 eb 02 89 d8 8b 18 0f 18 03 90 3d 6c 66 ce f8 74 35 8d 68
fc 8b 75 0c 8d 78 08 <8b> 0e 0f 18 01 90 39 fe 74 de 8b 46 14 8b 55 00 c1 e0
04 0b 46 [  484.859154] EIP: [<f8cd360a>] dvb_device_open+0x3a/0x120
[dvb_core] SS:ESP 0068:ea123ec0

		Since dvb_device_open is a function of the dvb_core, I'm
guessing the function is ok and there's something wrong with my part of the
code. But, as far as I can see, I never explicitly call or register the
function, so there's probably something wrong with the initialisation. I
don't really see what can go wrong, so if any of you guys can give me some
hints/tips to what I should pay extra attention, this is really appreciated.


		Greetings,
		Ben

------=_NextPart_000_0036_01C873BA.38F46070
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
08.00.0681.000">
<TITLE>RE: Null pointer in dvb_device_open</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/rtf format -->

<P DIR=3DLTR><SPAN LANG=3D"en-gb"></SPAN><SPAN LANG=3D"en-gb"><FONT =
COLOR=3D"#1F497D" FACE=3D"Calibri">Sorry for the messed-up dmesg-output, =
hopefully this time it</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN><SPAN =
LANG=3D"en-gb"><FONT COLOR=3D"#1F497D" =
FACE=3D"Calibri">&#8217;</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN><SPAN =
LANG=3D"en-gb"><FONT COLOR=3D"#1F497D" FACE=3D"Calibri">s =
better:</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.858908] BUG: unable to handle kernel NULL pointer dereference at =
virtual address 00000000</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.858917]&nbsp; printing eip:</FONT></SPAN><SPAN =
LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.858919] f8cd360a</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.858921] *pde =3D 00000000</FONT></SPAN><SPAN =
LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.858924] Oops: 0000 [#1]</FONT></SPAN><SPAN =
LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.858925] SMP</FONT></SPAN><SPAN LANG=3D"en-gb"> </SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.858928] Modules linked in: dvb_driver dvb_core ipv6 af_packet rfcomm =
l2cap bluetooth ppdev cpufreq_ondemand cpufreq_stats cpufreq_powersave =
cpufreq_userspace freq_table cpufreq_conservative sbs button ac =
container dock video battery sbp2 lp snd_intel8x0 snd_ac97_codec =
ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss =
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer =
snd_seq_device snd soundcore parport_pc parport pcspkr snd_page_alloc =
shpchp pci_hotplug i2c_nforce2 i2c_core nvidia_agp agpgart dv1394 evdev =
ext3 jbd mbcache sg sd_mod ide_cd cdrom usbhid hid amd74xx ide_core =
sata_sil ohci1394 ieee1394 ata_generic libata scsi_mod forcedeth =
ehci_hcd ohci_hcd usbcore thermal processor fan fuse apparmor =
commoncap</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.858978] CPU:&nbsp;&nbsp;&nbsp; 0</FONT></SPAN><SPAN =
LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.858979] EIP:&nbsp;&nbsp;&nbsp; =
0060:[&lt;f8cd360a&gt;]&nbsp;&nbsp;&nbsp; Not tainted =
VLI</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.858981] EFLAGS: 00010293&nbsp;&nbsp; (2.6.22-14-generic =
#1)</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.858999] EIP is at dvb_device_open+0x3a/0x120 =
[dvb_core]</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859002] eax: eafcfc04&nbsp;&nbsp; ebx: 76697264&nbsp;&nbsp; ecx: =
f8ce6600&nbsp;&nbsp; edx: 00000003</FONT></SPAN><SPAN =
LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859006] esi: 00000000&nbsp;&nbsp; edi: eafcfc0c&nbsp;&nbsp; ebp: =
eafcfc00&nbsp;&nbsp; esp: ea123ec0</FONT></SPAN><SPAN =
LANG=3D"en-gb"><BR>
<FONT FACE=3D"Calibri">[&nbsp; 484.859009] ds: 007b&nbsp;&nbsp; es: =
007b&nbsp;&nbsp; fs: 00d8&nbsp; gs: 0033&nbsp; ss: =
0068</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859012] Process scan (pid: 5981, ti=3Dea122000 task=3Dea766f90 =
task.ti=3Dea122000)</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859015] Stack: ec9ae960 eb2aa8d0 00000003 f8cd35d0 f8ce65a0 00000000 =
eb2aa8d0 c0183466</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859021]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ec9ae960 00000003 =
ec9ae960 eb2aa8d0 00000000 c01833c0 c017ec48 dff5ac00</FONT></SPAN><SPAN =
LANG=3D"en-gb"> </SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859028]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; e9a2c440 ec9ae960 =
ffffff9c ea123f30 00000003 c017ee05 ec9ae960 00000000</FONT></SPAN><SPAN =
LANG=3D"en-gb"> </SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859034] Call Trace:</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859038]&nbsp; [&lt;f8cd35d0&gt;] dvb_device_open+0x0/0x120 =
[dvb_core]</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859048]&nbsp; [&lt;c0183466&gt;] =
chrdev_open+0xa6/0x190</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859058]&nbsp; [&lt;c01833c0&gt;] =
chrdev_open+0x0/0x190</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859062]&nbsp; [&lt;c017ec48&gt;] =
__dentry_open+0xb8/0x1c0</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859073]&nbsp; [&lt;c017ee05&gt;] =
nameidata_to_filp+0x35/0x40</FONT></SPAN><SPAN =
LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859079]&nbsp; [&lt;c017ee60&gt;] =
do_filp_open+0x50/0x60</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859085]&nbsp; [&lt;c02f20ea&gt;] =
schedule+0x2ca/0x890</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859099]&nbsp; [&lt;c017eebe&gt;] =
do_sys_open+0x4e/0xf0</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859105]&nbsp; [&lt;c01813b1&gt;] =
sys_write+0x41/0x70</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859110]&nbsp; [&lt;c017ef9c&gt;] =
sys_open+0x1c/0x20</FONT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859114]&nbsp; [&lt;c01041d2&gt;] =
sysenter_past_esp+0x6b/0xa9</FONT></SPAN><SPAN =
LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859128]&nbsp; =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</FO=
NT></SPAN><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859129] Code: 50 34 a1 6c 66 ce f8 81 e2 ff ff 0f 00 89 54 24 08 eb =
02 89 d8 8b 18 0f 18 03 90 3d 6c 66 ce f8 74 35 8d 68 fc 8b 75 0c 8d 78 =
08 &lt;8b&gt; 0e 0f 18 01 90 39 fe 74 de 8b 46 14 8b 55 00 c1 e0 04 0b =
46</FONT></SPAN><SPAN LANG=3D"en-gb"> </SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.859154] EIP: [&lt;f8cd360a&gt;] dvb_device_open+0x3a/0x120 =
[dvb_core] SS:ESP 0068:ea123ec0</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"></SPAN><SPAN =
LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"></SPAN><SPAN =
LANG=3D"en-gb"></SPAN></P>
<UL DIR=3DLTR><UL DIR=3DLTR>
<P DIR=3DLTR><SPAN LANG=3D"en-gb"></SPAN><SPAN =
LANG=3D"en-gb"></SPAN><SPAN LANG=3D"en-gb"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Tahoma">_____________________________________________<BR>
</FONT></SPAN><SPAN LANG=3D"en-gb"><B></B></SPAN><SPAN =
LANG=3D"en-gb"><B></B></SPAN><SPAN LANG=3D"en-gb"><B></B></SPAN><B><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Tahoma">From:</FONT></SPAN></B><SPAN LANG=3D"en-gb"></SPAN><SPAN =
LANG=3D"en-gb"></SPAN><SPAN LANG=3D"en-gb"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Tahoma"> Ben Backx [<A =
HREF=3D"mailto:ben@bbackx.com">mailto:ben@bbackx.com</A>]<BR>
</FONT></SPAN><SPAN LANG=3D"en-gb"><B></B></SPAN><SPAN =
LANG=3D"en-gb"><B></B></SPAN><SPAN LANG=3D"en-gb"><B></B></SPAN><B><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Tahoma">Sent:</FONT></SPAN></B><SPAN LANG=3D"en-gb"></SPAN><SPAN =
LANG=3D"en-gb"></SPAN><SPAN LANG=3D"en-gb"></SPAN><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Tahoma"> 20 February 2008 =
12:07<BR>
</FONT></SPAN><SPAN LANG=3D"en-gb"><B></B></SPAN><SPAN =
LANG=3D"en-gb"><B></B></SPAN><SPAN LANG=3D"en-gb"><B></B></SPAN><B><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 FACE=3D"Tahoma">To:</FONT></SPAN></B><SPAN =
LANG=3D"en-gb"></SPAN><SPAN LANG=3D"en-gb"></SPAN><SPAN =
LANG=3D"en-gb"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Tahoma"> 'linux-dvb@linuxtv.org'<BR>
</FONT></SPAN><SPAN LANG=3D"en-gb"><B></B></SPAN><SPAN =
LANG=3D"en-gb"><B></B></SPAN><SPAN LANG=3D"en-gb"><B></B></SPAN><B><SPAN =
LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Tahoma">Subject:</FONT></SPAN></B><SPAN =
LANG=3D"en-gb"></SPAN><SPAN LANG=3D"en-gb"></SPAN><SPAN =
LANG=3D"en-gb"></SPAN><SPAN LANG=3D"en-us"><FONT SIZE=3D2 =
FACE=3D"Tahoma"> Null pointer in dvb_device_open</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT =
FACE=3D"Calibri">Hi,</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">I&#8217;m =
(still) developing a driver for a dvb-device, I&#8217;m making some =
progress, but I&#8217;m currently stuck at a null-pointer in =
dvb_device_open. The (relevant) dmesg-output:</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">[&nbsp; =
484.858908] BUG: unable to handle kernel NULL pointer dereference at =
virtual address 00000000[&nbsp; 484.858917]&nbsp; printing eip:[&nbsp; =
484.858919] f8cd360a[&nbsp; 484.858921] *pde =3D 00000000[&nbsp; =
484.858924] Oops: 0000 [#1][&nbsp; 484.858925] SMP [&nbsp; 484.858928] =
Modules linked in: dvb_driver dvb_core ipv6 af_packet rfcomm l2cap =
bluetooth ppdev cpufreq_ondemand cpufreq_stats cpufreq_powersave =
cpufreq_userspace freq_table cpufreq_conservative sbs button ac =
container dock video battery sbp2 lp snd_intel8x0 snd_ac97_codec =
ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss =
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer =
snd_seq_device snd soundcore parport_pc parport pcspkr snd_page_alloc =
shpchp pci_hotplug i2c_nforce2 i2c_core nvidia_agp agpgart dv1394 evdev =
ext3 jbd mbcache sg sd_mod ide_cd cdrom usbhid hid amd74xx ide_core =
sata_sil ohci1394 ieee1394 ata_generic libata scsi_mod forcedeth =
ehci_hcd ohci_hcd usbcore thermal processor fan fuse apparmor =
commoncap[&nbsp; 484.858978] CPU:&nbsp;&nbsp;&nbsp; 0[&nbsp; 484.858979] =
EIP:&nbsp;&nbsp;&nbsp; 0060:[&lt;f8cd360a&gt;]&nbsp;&nbsp;&nbsp; Not =
tainted VLI[&nbsp; 484.858981] EFLAGS: 00010293&nbsp;&nbsp; =
(2.6.22-14-generic #1)[&nbsp; 484.858999] EIP is at =
dvb_device_open+0x3a/0x120 [dvb_core][&nbsp; 484.859002] eax: =
eafcfc04&nbsp;&nbsp; ebx: 76697264&nbsp;&nbsp; ecx: f8ce6600&nbsp;&nbsp; =
edx: 00000003[&nbsp; 484.859006] esi: 00000000&nbsp;&nbsp; edi: =
eafcfc0c&nbsp;&nbsp; ebp: eafcfc00&nbsp;&nbsp; esp: ea123ec0[&nbsp; =
484.859009] ds: 007b&nbsp;&nbsp; es: 007b&nbsp;&nbsp; fs: 00d8&nbsp; gs: =
0033&nbsp; ss: 0068[&nbsp; 484.859012] Process scan (pid: 5981, =
ti=3Dea122000 task=3Dea766f90 task.ti=3Dea122000)[&nbsp; 484.859015] =
Stack: ec9ae960 eb2aa8d0 00000003 f8cd35d0 f8ce65a0 00000000 eb2aa8d0 =
c0183466 [&nbsp; 484.859021]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
ec9ae960 00000003 ec9ae960 eb2aa8d0 00000000 c01833c0 c017ec48 dff5ac00 =
[&nbsp; 484.859028]&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; e9a2c440 =
ec9ae960 ffffff9c ea123f30 00000003 c017ee05 ec9ae960 00000000 [&nbsp; =
484.859034] Call Trace:[&nbsp; 484.859038]&nbsp; [&lt;f8cd35d0&gt;] =
dvb_device_open+0x0/0x120 [dvb_core][&nbsp; 484.859048]&nbsp; =
[&lt;c0183466&gt;] chrdev_open+0xa6/0x190[&nbsp; 484.859058]&nbsp; =
[&lt;c01833c0&gt;] chrdev_open+0x0/0x190[&nbsp; 484.859062]&nbsp; =
[&lt;c017ec48&gt;] __dentry_open+0xb8/0x1c0[&nbsp; 484.859073]&nbsp; =
[&lt;c017ee05&gt;] nameidata_to_filp+0x35/0x40[&nbsp; 484.859079]&nbsp; =
[&lt;c017ee60&gt;] do_filp_open+0x50/0x60[&nbsp; 484.859085]&nbsp; =
[&lt;c02f20ea&gt;] schedule+0x2ca/0x890[&nbsp; 484.859099]&nbsp; =
[&lt;c017eebe&gt;] do_sys_open+0x4e/0xf0[&nbsp; 484.859105]&nbsp; =
[&lt;c01813b1&gt;] sys_write+0x41/0x70[&nbsp; 484.859110]&nbsp; =
[&lt;c017ef9c&gt;] sys_open+0x1c/0x20[&nbsp; 484.859114]&nbsp; =
[&lt;c01041d2&gt;] sysenter_past_esp+0x6b/0xa9[&nbsp; 484.859128]&nbsp; =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D[&nb=
sp; 484.859129] Code: 50 34 a1 6c 66 ce f8 81 e2 ff ff 0f 00 89 54 24 08 =
eb 02 89 d8 8b 18 0f 18 03 90 3d 6c 66 ce f8 74 35 8d 68 fc 8b 75 0c 8d =
78 08 &lt;8b&gt; 0e 0f 18 01 90 39 fe 74 de 8b 46 14 8b 55 00 c1 e0 04 =
0b 46 [&nbsp; 484.859154] EIP: [&lt;f8cd360a&gt;] =
dvb_device_open+0x3a/0x120 [dvb_core] SS:ESP =
0068:ea123ec0</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT FACE=3D"Calibri">Since =
dvb_device_open is a function of the dvb_core, I&#8217;m guessing the =
function is ok and there&#8217;s something wrong with my part of the =
code. But, as far as I can see, I never explicitly call or register the =
function, so there&#8217;s probably something wrong with the =
initialisation. I don&#8217;t really see what can go wrong, so if any of =
you guys can give me some hints/tips to what I should pay extra =
attention, this is really appreciated.</FONT></SPAN></P>
<BR>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT =
FACE=3D"Calibri">Greetings,</FONT></SPAN></P>

<P DIR=3DLTR><SPAN LANG=3D"en-gb"><FONT =
FACE=3D"Calibri">Ben</FONT></SPAN></P>
</UL></UL>
</BODY>
</HTML>
------=_NextPart_000_0036_01C873BA.38F46070--



--===============0360927627==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0360927627==--
