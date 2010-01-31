Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <nicke.claesson@gmail.com>) id 1NbgKM-0005fy-Vu
	for linux-dvb@linuxtv.org; Sun, 31 Jan 2010 21:23:28 +0100
Received: from mail-bw0-f227.google.com ([209.85.218.227])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1NbgKM-0003Ix-7P; Sun, 31 Jan 2010 21:23:26 +0100
Received: by bwz27 with SMTP id 27so2573593bwz.1
	for <linux-dvb@linuxtv.org>; Sun, 31 Jan 2010 12:23:25 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 31 Jan 2010 21:23:25 +0100
Message-ID: <f509f3091001311223q19a9854fwb546e6fcadc08021@mail.gmail.com>
From: Niklas Claesson <nicke.claesson@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Twinhan dtv 3030 mantis
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0062327128=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0062327128==
Content-Type: multipart/alternative; boundary=00151750e3180f6c7e047e7ba4af

--00151750e3180f6c7e047e7ba4af
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,
I'm trying to use this tv-card with ubuntu 9.10. I've installed Manu's
drivers from http://jusst.de/hg/mantis-v4l-dvb/ and did "modprobe mantis"
which resulted in the following in /var/log/messages

Jan 31 20:57:40 niklas-desktop kernel: [  179.000227] Mantis 0000:05:02.0:
PCI INT A -> GSI 23 (level, low) -> IRQ 23
Jan 31 20:57:40 niklas-desktop kernel: [  179.001234] DVB: registering new
adapter (Mantis DVB adapter)
Jan 31 20:57:41 niklas-desktop kernel: [  179.672664] *pde =3D bac3e067
Jan 31 20:57:41 niklas-desktop kernel: [  179.672676] Modules linked in:
mantis(+) mantis_core ir_common ir_core tda665x lnbp21 mb86a16 stb6100
tda10021 tda10023 zl10353 stb0899 stv0299 dvb_core joydev hidp binfmt_misc
ppdev bridge stp bnep arc4 ecb snd_hda_codec_analog rtl8187 mac80211
led_class eeprom_93cx6 snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss
snd_mixer_oss snd_pcm usblp snd_seq_dummy iptable_filter ip_tables x_tables
btusb cfg80211 asus_atk0110 lirc_imon lirc_dev lp parport snd_seq_oss
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_devic=
e
snd soundcore snd_page_alloc nvidia(P) usbhid skge ohci1394 ieee1394 sky2
intel_agp agpgart
Jan 31 20:57:41 niklas-desktop kernel: [  179.672743]
Jan 31 20:57:41 niklas-desktop kernel: [  179.672748] Pid: 2768, comm:
modprobe Tainted: P           (2.6.31-17-generic #54-Ubuntu) System Product
Name
Jan 31 20:57:41 niklas-desktop kernel: [  179.672752] EIP: 0060:[<f8517480>=
]
EFLAGS: 00010292 CPU: 1
Jan 31 20:57:41 niklas-desktop kernel: [  179.672761] EIP is at
dvb_unregister_frontend+0x10/0xe0 [dvb_core]
Jan 31 20:57:41 niklas-desktop kernel: [  179.672764] EAX: 00000000 EBX:
f398f800 ECX: f6a51cc0 EDX: 00000000
Jan 31 20:57:41 niklas-desktop kernel: [  179.672767] ESI: 00000000 EDI:
f398f9fc EBP: f4983dec ESP: f4983dc8
Jan 31 20:57:41 niklas-desktop kernel: [  179.672771]  DS: 007b ES: 007b FS=
:
00d8 GS: 00e0 SS: 0068
Jan 31 20:57:41 niklas-desktop kernel: [  179.672779]  f4983dec f851c07e
f398f800 00000000 f398f9fc f4983dec f398f800 f398f800
Jan 31 20:57:41 niklas-desktop kernel: [  179.672797] <0> ffffffff f4983e2c
f85955d5 f70fc858 f8599b50 f398f800 00000000 f398fc70
Jan 31 20:57:41 niklas-desktop kernel: [  179.672804] <0> f398f848 f398fc64
f398fc58 f85a9500 f398fbfc f398f9ac f398f800 00000000
Jan 31 20:57:41 niklas-desktop kernel: [  179.672820]  [<f851c07e>] ?
dvb_net_release+0x1e/0xb0 [dvb_core]
Jan 31 20:57:41 niklas-desktop kernel: [  179.672827]  [<f85955d5>] ?
mantis_dvb_init+0x398/0x3de [mantis_core]
Jan 31 20:57:41 niklas-desktop kernel: [  179.672833]  [<f85a6606>] ?
mantis_pci_probe+0x1d7/0x2f8 [mantis]
Jan 31 20:57:41 niklas-desktop kernel: [  179.672839]  [<c03285ae>] ?
local_pci_probe+0xe/0x10
Jan 31 20:57:41 niklas-desktop kernel: [  179.672843]  [<c0329330>] ?
pci_device_probe+0x60/0x80
Jan 31 20:57:41 niklas-desktop kernel: [  179.672848]  [<c03a2e30>] ?
really_probe+0x50/0x140
Jan 31 20:57:41 niklas-desktop kernel: [  179.672852]  [<c0570cea>] ?
_spin_lock_irqsave+0x2a/0x40
Jan 31 20:57:41 niklas-desktop kernel: [  179.672855]  [<c03a2f39>] ?
driver_probe_device+0x19/0x20
Jan 31 20:57:41 niklas-desktop kernel: [  179.672859]  [<c03a2fb9>] ?
__driver_attach+0x79/0x80
Jan 31 20:57:41 niklas-desktop kernel: [  179.672862]  [<c03a2488>] ?
bus_for_each_dev+0x48/0x70
Jan 31 20:57:41 niklas-desktop kernel: [  179.672866]  [<c03a2cf9>] ?
driver_attach+0x19/0x20
Jan 31 20:57:41 niklas-desktop kernel: [  179.672869]  [<c03a2f40>] ?
__driver_attach+0x0/0x80
Jan 31 20:57:41 niklas-desktop kernel: [  179.672872]  [<c03a26df>] ?
bus_add_driver+0xbf/0x2a0
Jan 31 20:57:41 niklas-desktop kernel: [  179.672876]  [<c0329270>] ?
pci_device_remove+0x0/0x40
Jan 31 20:57:41 niklas-desktop kernel: [  179.672879]  [<c03a3245>] ?
driver_register+0x65/0x120
Jan 31 20:57:41 niklas-desktop kernel: [  179.672883]  [<c0329550>] ?
__pci_register_driver+0x40/0xb0
Jan 31 20:57:41 niklas-desktop kernel: [  179.672887]  [<f85a642d>] ?
mantis_init+0x17/0x19 [mantis]
Jan 31 20:57:41 niklas-desktop kernel: [  179.672890]  [<c010112c>] ?
do_one_initcall+0x2c/0x190
Jan 31 20:57:41 niklas-desktop kernel: [  179.672894]  [<f85a6416>] ?
mantis_init+0x0/0x19 [mantis]
Jan 31 20:57:41 niklas-desktop kernel: [  179.672899]  [<c0173711>] ?
sys_init_module+0xb1/0x1f0
Jan 31 20:57:41 niklas-desktop kernel: [  179.672903]  [<c01e83ed>] ?
sys_write+0x3d/0x70
Jan 31 20:57:41 niklas-desktop kernel: [  179.672906]  [<c010336c>] ?
syscall_call+0x7/0xb
Jan 31 20:57:41 niklas-desktop kernel: [  179.672961] ---[ end trace
035b3cc151b9cf1a ]---

I can't even get the drivers from http://jusst.de/hg/mantis/ to compile:

Kernel build directory is /lib/modules/2.6.31-17-generic/build
make -C /lib/modules/2.6.31-17-generic/build
SUBDIRS=3D/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l  modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.31-17-generic'
  CC [M]  /home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/tuner-xc2028=
.o
In file included from
/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/tuner-xc2028.h:10,
                 from
/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/tuner-xc2028.c:21:
/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:52: err=
or:
field 'fe_params' has incomplete type
/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:297: wa=
rning:
'struct dvbfe_info' declared inside parameter list
/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:297: wa=
rning:
its scope is only this definition or declaration, which is probably not wha=
t
you want
/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:298: wa=
rning:
'enum dvbfe_delsys' declared inside parameter list
/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:299: wa=
rning:
'enum dvbfe_delsys' declared inside parameter list
/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:316: er=
ror:
field 'fe_events' has incomplete type
/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:317: er=
ror:
field 'fe_params' has incomplete type
/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:354: wa=
rning:
'enum dvbfe_fec' declared inside parameter list
/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:354: wa=
rning:
'enum dvbfe_modulation' declared inside parameter list
/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:359: wa=
rning:
'enum dvbfe_delsys' declared inside parameter list
/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/tuner-xc2028.c:49: err=
or:
'FIRMWARE_NAME_MAX' undeclared here (not in a function)
make[3]: ***
[/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/tuner-xc2028.o] Error=
 1
make[2]: *** [_module_/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l]=
 Error
2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.31-17-generic'
make[1]: *** [default] Fel 2
make[1]: L=C3=A4mnar katalogen "/home/niklas/H=C3=A4mtningar/mantis-5292a47=
772ad/v4l"
make: *** [all] Fel 2

Is there anything I can do?

Niklas Claesson

--00151750e3180f6c7e047e7ba4af
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,<div>I&#39;m trying to use this tv-card with ubuntu 9.10. I&#39;ve insta=
lled Manu&#39;s drivers from=C2=A0<a href=3D"http://jusst.de/hg/mantis-v4l-=
dvb/">http://jusst.de/hg/mantis-v4l-dvb/</a> and did &quot;modprobe mantis&=
quot; which resulted in the following in /var/log/messages</div>
<div><br></div><div><div>Jan 31 20:57:40 niklas-desktop kernel: [ =C2=A0179=
.000227] Mantis 0000:05:02.0: PCI INT A -&gt; GSI 23 (level, low) -&gt; IRQ=
 23</div><div>Jan 31 20:57:40 niklas-desktop kernel: [ =C2=A0179.001234] DV=
B: registering new adapter (Mantis DVB adapter)</div>
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672664] *pde =3D ba=
c3e067=C2=A0</div><div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.6=
72676] Modules linked in: mantis(+) mantis_core ir_common ir_core tda665x l=
nbp21 mb86a16 stb6100 tda10021 tda10023 zl10353 stb0899 stv0299 dvb_core jo=
ydev hidp binfmt_misc ppdev bridge stp bnep arc4 ecb snd_hda_codec_analog r=
tl8187 mac80211 led_class eeprom_93cx6 snd_hda_intel snd_hda_codec snd_hwde=
p snd_pcm_oss snd_mixer_oss snd_pcm usblp snd_seq_dummy iptable_filter ip_t=
ables x_tables btusb cfg80211 asus_atk0110 lirc_imon lirc_dev lp parport sn=
d_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd=
_seq_device snd soundcore snd_page_alloc nvidia(P) usbhid skge ohci1394 iee=
e1394 sky2 intel_agp agpgart</div>
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672743]=C2=A0</div>=
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672748] Pid: 2768, =
comm: modprobe Tainted: P =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (2.6.31-17-gen=
eric #54-Ubuntu) System Product Name</div>
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672752] EIP: 0060:[=
&lt;f8517480&gt;] EFLAGS: 00010292 CPU: 1</div><div>Jan 31 20:57:41 niklas-=
desktop kernel: [ =C2=A0179.672761] EIP is at dvb_unregister_frontend+0x10/=
0xe0 [dvb_core]</div>
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672764] EAX: 000000=
00 EBX: f398f800 ECX: f6a51cc0 EDX: 00000000</div><div>Jan 31 20:57:41 nikl=
as-desktop kernel: [ =C2=A0179.672767] ESI: 00000000 EDI: f398f9fc EBP: f49=
83dec ESP: f4983dc8</div>
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672771] =C2=A0DS: 0=
07b ES: 007b FS: 00d8 GS: 00e0 SS: 0068</div><div>Jan 31 20:57:41 niklas-de=
sktop kernel: [ =C2=A0179.672779] =C2=A0f4983dec f851c07e f398f800 00000000=
 f398f9fc f4983dec f398f800 f398f800</div>
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672797] &lt;0&gt; f=
fffffff f4983e2c f85955d5 f70fc858 f8599b50 f398f800 00000000 f398fc70</div=
><div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672804] &lt;0&gt; =
f398f848 f398fc64 f398fc58 f85a9500 f398fbfc f398f9ac f398f800 00000000</di=
v>
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672820] =C2=A0[&lt;=
f851c07e&gt;] ? dvb_net_release+0x1e/0xb0 [dvb_core]</div><div>Jan 31 20:57=
:41 niklas-desktop kernel: [ =C2=A0179.672827] =C2=A0[&lt;f85955d5&gt;] ? m=
antis_dvb_init+0x398/0x3de [mantis_core]</div>
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672833] =C2=A0[&lt;=
f85a6606&gt;] ? mantis_pci_probe+0x1d7/0x2f8 [mantis]</div><div>Jan 31 20:5=
7:41 niklas-desktop kernel: [ =C2=A0179.672839] =C2=A0[&lt;c03285ae&gt;] ? =
local_pci_probe+0xe/0x10</div>
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672843] =C2=A0[&lt;=
c0329330&gt;] ? pci_device_probe+0x60/0x80</div><div>Jan 31 20:57:41 niklas=
-desktop kernel: [ =C2=A0179.672848] =C2=A0[&lt;c03a2e30&gt;] ? really_prob=
e+0x50/0x140</div>
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672852] =C2=A0[&lt;=
c0570cea&gt;] ? _spin_lock_irqsave+0x2a/0x40</div><div>Jan 31 20:57:41 nikl=
as-desktop kernel: [ =C2=A0179.672855] =C2=A0[&lt;c03a2f39&gt;] ? driver_pr=
obe_device+0x19/0x20</div>
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672859] =C2=A0[&lt;=
c03a2fb9&gt;] ? __driver_attach+0x79/0x80</div><div>Jan 31 20:57:41 niklas-=
desktop kernel: [ =C2=A0179.672862] =C2=A0[&lt;c03a2488&gt;] ? bus_for_each=
_dev+0x48/0x70</div>
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672866] =C2=A0[&lt;=
c03a2cf9&gt;] ? driver_attach+0x19/0x20</div><div>Jan 31 20:57:41 niklas-de=
sktop kernel: [ =C2=A0179.672869] =C2=A0[&lt;c03a2f40&gt;] ? __driver_attac=
h+0x0/0x80</div>
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672872] =C2=A0[&lt;=
c03a26df&gt;] ? bus_add_driver+0xbf/0x2a0</div><div>Jan 31 20:57:41 niklas-=
desktop kernel: [ =C2=A0179.672876] =C2=A0[&lt;c0329270&gt;] ? pci_device_r=
emove+0x0/0x40</div>
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672879] =C2=A0[&lt;=
c03a3245&gt;] ? driver_register+0x65/0x120</div><div>Jan 31 20:57:41 niklas=
-desktop kernel: [ =C2=A0179.672883] =C2=A0[&lt;c0329550&gt;] ? __pci_regis=
ter_driver+0x40/0xb0</div>
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672887] =C2=A0[&lt;=
f85a642d&gt;] ? mantis_init+0x17/0x19 [mantis]</div><div>Jan 31 20:57:41 ni=
klas-desktop kernel: [ =C2=A0179.672890] =C2=A0[&lt;c010112c&gt;] ? do_one_=
initcall+0x2c/0x190</div>
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672894] =C2=A0[&lt;=
f85a6416&gt;] ? mantis_init+0x0/0x19 [mantis]</div><div>Jan 31 20:57:41 nik=
las-desktop kernel: [ =C2=A0179.672899] =C2=A0[&lt;c0173711&gt;] ? sys_init=
_module+0xb1/0x1f0</div>
<div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672903] =C2=A0[&lt;=
c01e83ed&gt;] ? sys_write+0x3d/0x70</div><div>Jan 31 20:57:41 niklas-deskto=
p kernel: [ =C2=A0179.672906] =C2=A0[&lt;c010336c&gt;] ? syscall_call+0x7/0=
xb</div><div>Jan 31 20:57:41 niklas-desktop kernel: [ =C2=A0179.672961] ---=
[ end trace 035b3cc151b9cf1a ]---</div>
<div><br></div></div><div>I can&#39;t even get the drivers from <a href=3D"=
http://jusst.de/hg/mantis/">http://jusst.de/hg/mantis/</a> to compile:</div=
><div><br></div><div><div>Kernel build directory is /lib/modules/2.6.31-17-=
generic/build</div>
<div>make -C /lib/modules/2.6.31-17-generic/build SUBDIRS=3D/home/niklas/H=
=C3=A4mtningar/mantis-5292a47772ad/v4l =C2=A0modules</div><div>make[2]: Ent=
ering directory `/usr/src/linux-headers-2.6.31-17-generic&#39;</div><div>=
=C2=A0=C2=A0CC [M] =C2=A0/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v=
4l/tuner-xc2028.o</div>
<div>In file included from /home/niklas/H=C3=A4mtningar/mantis-5292a47772ad=
/v4l/tuner-xc2028.h:10,</div><div>=C2=A0=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 from /home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/=
v4l/tuner-xc2028.c:21:</div><div>/home/niklas/H=C3=A4mtningar/mantis-5292a4=
7772ad/v4l/dvb_frontend.h:52: error: field &#39;fe_params&#39; has incomple=
te type</div>
<div>/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:29=
7: warning: &#39;struct dvbfe_info&#39; declared inside parameter list</div=
><div>/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:2=
97: warning: its scope is only this definition or declaration, which is pro=
bably not what you want</div>
<div>/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:29=
8: warning: &#39;enum dvbfe_delsys&#39; declared inside parameter list</div=
><div>/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:2=
99: warning: &#39;enum dvbfe_delsys&#39; declared inside parameter list</di=
v>
<div>/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:31=
6: error: field &#39;fe_events&#39; has incomplete type</div><div>/home/nik=
las/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:317: error: fiel=
d &#39;fe_params&#39; has incomplete type</div>
<div>/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:35=
4: warning: &#39;enum dvbfe_fec&#39; declared inside parameter list</div><d=
iv>/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:354:=
 warning: &#39;enum dvbfe_modulation&#39; declared inside parameter list</d=
iv>
<div>/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:35=
9: warning: &#39;enum dvbfe_delsys&#39; declared inside parameter list</div=
><div>/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/tuner-xc2028.c:4=
9: error: &#39;FIRMWARE_NAME_MAX&#39; undeclared here (not in a function)</=
div>
<div>make[3]: *** [/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l/tun=
er-xc2028.o] Error 1</div><div>make[2]: *** [_module_/home/niklas/H=C3=A4mt=
ningar/mantis-5292a47772ad/v4l] Error 2</div><div>make[2]: Leaving director=
y `/usr/src/linux-headers-2.6.31-17-generic&#39;</div>
<div>make[1]: *** [default] Fel 2</div><div>make[1]: L=C3=A4mnar katalogen =
&quot;/home/niklas/H=C3=A4mtningar/mantis-5292a47772ad/v4l&quot;</div><div>=
make: *** [all] Fel 2</div><div><br></div><div>Is there anything I can do?<=
/div><div>
<br></div>Niklas Claesson<br>
</div>

--00151750e3180f6c7e047e7ba4af--


--===============0062327128==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0062327128==--
