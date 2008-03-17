Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yosemite.cellcom.com ([206.40.111.98])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Mark.Jenks@nsighttel.com>) id 1Jb67l-00048P-D5
	for linux-dvb@linuxtv.org; Mon, 17 Mar 2008 04:35:00 +0100
Received: from exchange01.Nsighttel.com (exchange01.nsighttel.com
	[10.70.91.215])
	by yosemite.cellcom.com (Postfix) with ESMTP id 941234ECA7
	for <linux-dvb@linuxtv.org>; Sun, 16 Mar 2008 21:34:22 -0600 (CST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Sun, 16 Mar 2008 22:34:21 -0500
Message-ID: <C82A808D35A16542ACB16AF56367E0580A7968E9@exchange01.nsighttel.com>
From: "Mark A Jenks" <Mark.Jenks@nsighttel.com>
To: <linux-dvb@linuxtv.org>
Subject: [linux-dvb] HVR-1250, Suse 10.3, scan hangs, taints kernel.
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1036064530=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1036064530==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C887DF.C9E9B987"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C887DF.C9E9B987
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Not sure what is happening here.  I'm about to rebuild the box again and
see if it works before I install everything that I did to it.
=20
Here is what I have so far..
=20
Thoughts?   I was thinking sensors (k8temp, it87), but I removed them,
and it stil happens.
=20
-Mark
=20
---------------------------
=20
=20
>>> tune to: 509028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 509028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 515028615:8VSB
service is running. Channel number: 14:1. Name: 'WIWB-HD*'
=20
=20
mythtv:~ # dmesg=20
CORE cx23885[0]: subsystem: 0070:7911, board: Hauppauge WinTV-HVR1250
[card=3D3,autodetected]
cx23885[0]: i2c bus 0 registered
cx23885[0]: i2c bus 1 registered
cx23885[0]: i2c bus 2 registered
tveeprom 2-0050: Encountered bad packet header [ff]. Corrupt or not a
Hauppauge eeprom.
cx23885[0]: warning: unknown hauppauge model #0
cx23885[0]: hauppauge eeprom: model=3D0
cx23885[0]: cx23885 based dvb card
MT2131: successfully identified at address 0x61
DVB: registering new adapter (cx23885[0])
DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx23885_dev_checkrevision() Hardware revision =3D 0xc0
cx23885[0]/0: found at 0000:02:00.0, rev: 3, irq: 21, latency: 0, mmio:
0xfd600000


BUG: unable to handle kernel paging request at virtual address fd7fffff
 printing eip:
c01090bd
*pde =3D 00000000
Oops: 0000 [#1]
SMP
last sysfs file: /devices/pci0000:00/0000:00:18.3/name
Modules linked in: snd_pcm_oss snd_mixer_oss snd_seq_midi
snd_seq_midi_event snd_seq iptable_filter ip_tables ip6_tables x_tables
xfs loop dm_mod mt2131 s5h1409 osst ohci1394 cx23885 nvidia(P) ieee1394
videodev v4l1_compat compat_ioctl32 v4l2_common st button rtc_cmos
snd_hda_intel rtc_core snd_pcm snd_timer snd_mpu401 forcedeth rtc_lib
btcx_risc tveeprom videobuf_dvb dvb_core videobuf_dma_sg agpgart
snd_mpu401_uart snd_rawmidi snd_seq_device snd soundcore hwmon
videobuf_core snd_page_alloc parport_pc lirc_imon(F) parport sr_mod
cdrom i2c_nforce2 i2c_core lirc_dev sg sd_mod ehci_hcd ohci_hcd usbcore
edd ext3 mbcache jbd fan aic7xxx scsi_transport_spi sata_nv pata_amd
libata scsi_mod thermal processor
CPU:    0
EIP:    0060:[<c01090bd>]    Tainted: PF     N VLI
EFLAGS: 00010286   (2.6.22.17-0.1-default #1)
EIP is at dma_free_coherent+0x22/0x53
eax: 00000000   ebx: ebcab000   ecx: fd7fffff   edx: 000001d4
esi: 00000000   edi: f305422c   ebp: f746d1e0   esp: ebc77f60
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process cx23885[0] dvb (pid: 4290, ti=3Debc76000 task=3Df600f570
task.ti=3Debc76000)
Stack: dfe01c90 dfe01c48 f9178416 2bcab000 f918a358 ffffffea f30541c0
f3054248
       f746d128 f92a1dcd f746d128 00000000 00000282 f914a414 f746d128
00000000
       ebc8be80 f914a504 f746d128 f746d120 f914a58b ebc8bea4 f915f3e7
c011dfa6
Call Trace:
 [<f9178416>] btcx_riscmem_free+0x58/0x68 [btcx_risc]
 [<f918a358>] videobuf_dma_unmap+0x43/0x58 [videobuf_dma_sg]
 [<f92a1dcd>] cx23885_free_buffer+0x4a/0x55 [cx23885]
 [<f914a414>] videobuf_queue_cancel+0x72/0x8e [videobuf_core]
 [<f914a504>] __videobuf_read_stop+0xb/0x53 [videobuf_core]
 [<f914a58b>] videobuf_read_stop+0xf/0x17 [videobuf_core]
 [<f915f3e7>] videobuf_dvb_thread+0xec/0x12f [videobuf_dvb]
 [<c011dfa6>] complete+0x39/0x48
 [<f915f2fb>] videobuf_dvb_thread+0x0/0x12f [videobuf_dvb]
 [<c01350ee>] kthread+0x38/0x5e
 [<c01350b6>] kthread+0x0/0x5e
 [<c0106117>] kernel_thread_helper+0x7/0x10
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: d8 5b e9 eb 44 06 00 5b c3 56 53 89 cb 31 c9 85 c0 74 06 8b 88 40
01 00 00 8d 42 ff 83 ce ff c1 e8 0b 46 d1 e8 75 fb 85 c9 74 26 <8b> 11
39 d3 72 20 8b 41 08 c1 e0 0c 8d 04 02 39 c3 73 13 29 d3
EIP: [<c01090bd>] dma_free_coherent+0x22/0x53 SS:ESP 0068:ebc77f60
=20
=20
=20
=20
=20
mythtv:~ # lsmod
Module                  Size  Used by
snd_pcm_oss            50432  0
snd_mixer_oss          20096  1 snd_pcm_oss
snd_seq_midi           13440  0
snd_seq_midi_event     10880  1 snd_seq_midi
snd_seq                54452  2 snd_seq_midi,snd_seq_midi_event
iptable_filter          6912  0
ip_tables              16324  1 iptable_filter
ip6_tables             17476  0
x_tables               18308  2 ip_tables,ip6_tables
xfs                   502932  1
loop                   21636  0
dm_mod                 56880  3
mt2131                  9732  1
s5h1409                12548  1
osst                   54172  0
ohci1394               36272  0
cx23885                66644  2
nvidia               7846932  26
ieee1394               91136  1 ohci1394
videodev               35584  1 cx23885
v4l1_compat            16388  1 videodev
compat_ioctl32          5376  1 cx23885
v4l2_common            14976  1 cx23885
st                     40092  0
button                 12560  0
rtc_cmos               12064  0
snd_hda_intel         273180  3
rtc_core               23048  1 rtc_cmos
snd_pcm                82564  3 snd_pcm_oss,snd_hda_intel
snd_timer              26756  2 snd_seq,snd_pcm
snd_mpu401             12684  0
forcedeth              50056  0
rtc_lib                 7040  1 rtc_core
btcx_risc               8712  1 cx23885
tveeprom               15748  1 cx23885
videobuf_dvb           10628  1 cx23885
dvb_core               76548  1 videobuf_dvb
videobuf_dma_sg        17028  2 cx23885,videobuf_dvb
agpgart                35764  1 nvidia
snd_mpu401_uart        12416  1 snd_mpu401
snd_rawmidi            28416  2 snd_seq_midi,snd_mpu401_uart
snd_seq_device         12172  3 snd_seq_midi,snd_seq,snd_rawmidi
snd                    58164  16
snd_pcm_oss,snd_mixer_oss,snd_seq_midi,snd_seq,snd_hda_intel,snd_pcm,snd
_timer,snd_mpu401,snd_mpu401_uart,snd_rawmidi,snd_seq_device
soundcore              11460  1 snd
hwmon                   7300  0
videobuf_core          21380  3 cx23885,videobuf_dvb,videobuf_dma_sg
snd_page_alloc         14472  2 snd_hda_intel,snd_pcm
parport_pc             40892  0
lirc_imon              19976  1
parport                37832  1 parport_pc
sr_mod                 19492  0
cdrom                  37020  1 sr_mod
i2c_nforce2             9856  0
i2c_core               27520  7
mt2131,s5h1409,cx23885,nvidia,v4l2_common,tveeprom,i2c_nforce2
lirc_dev               18264  1 lirc_imon
sg                     37036  0
sd_mod                 31104  7
ehci_hcd               35340  0
ohci_hcd               23684  0
usbcore               124268  5 lirc_imon,ehci_hcd,ohci_hcd
edd                    12996  0
ext3                  131848  4
mbcache                12292  1 ext3
jbd                    68148  1 ext3
fan                     9220  0
aic7xxx               157348  0
scsi_transport_spi     27008  1 aic7xxx
sata_nv                22664  6
pata_amd               16644  0
libata                139216  2 sata_nv,pata_amd
scsi_mod              140376  8
osst,st,sr_mod,sg,sd_mod,aic7xxx,scsi_transport_spi,libata
thermal                20872  0
processor              40876  1 thermal


------_=_NextPart_001_01C887DF.C9E9B987
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dus-ascii">
<META content=3D"MSHTML 6.00.6000.16608" name=3DGENERATOR></HEAD>
<BODY>
<DIV><SPAN class=3D653502903-17032008><FONT face=3DArial size=3D2>Not =
sure what is=20
happening here.&nbsp; I'm about to rebuild the box again and see if it =
works=20
before I install everything that I did to it.</FONT></SPAN></DIV>
<DIV><SPAN class=3D653502903-17032008><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D653502903-17032008><FONT face=3DArial size=3D2>Here =
is what I have=20
so far..</FONT></SPAN></DIV>
<DIV><SPAN class=3D653502903-17032008><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D653502903-17032008><FONT face=3DArial=20
size=3D2>Thoughts?&nbsp;&nbsp;&nbsp;I was thinking sensors (k8temp, =
it87), but I=20
removed them, and it stil happens.</FONT></SPAN></DIV>
<DIV><SPAN class=3D653502903-17032008><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D653502903-17032008><FONT face=3DArial=20
size=3D2>-Mark</FONT></SPAN></DIV>
<DIV><SPAN class=3D653502903-17032008><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D653502903-17032008><FONT face=3DArial=20
size=3D2>---------------------------</FONT></SPAN></DIV>
<DIV><SPAN class=3D653502903-17032008><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D653502903-17032008><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>
<DIV><SPAN class=3D653502903-17032008><FONT face=3DArial =
size=3D2>&gt;&gt;&gt; tune=20
to: 509028615:8VSB<BR>WARNING: &gt;&gt;&gt; tuning =
failed!!!<BR>&gt;&gt;&gt;=20
tune to: 509028615:8VSB (tuning failed)<BR>WARNING: &gt;&gt;&gt; tuning=20
failed!!!<BR>&gt;&gt;&gt; tune to: 515028615:8VSB<BR>service is running. =
Channel=20
number: 14:1. Name: 'WIWB-HD&middot;'</FONT></SPAN></DIV>
<DIV>&nbsp;</DIV>
<DIV><SPAN class=3D653502903-17032008><FONT face=3DArial=20
size=3D2></FONT></SPAN>&nbsp;</DIV>mythtv:~ #&nbsp;dmesg
<DIV><SPAN class=3D653502903-17032008><FONT face=3DArial size=3D2>CORE =
cx23885[0]:=20
subsystem: 0070:7911, board: Hauppauge WinTV-HVR1250=20
[card=3D3,autodetected]<BR>cx23885[0]: i2c bus 0 =
registered<BR>cx23885[0]: i2c bus=20
1 registered<BR>cx23885[0]: i2c bus 2 registered<BR>tveeprom 2-0050: =
Encountered=20
bad packet header [ff]. Corrupt or not a Hauppauge =
eeprom.<BR>cx23885[0]:=20
warning: unknown hauppauge model #0<BR>cx23885[0]: hauppauge eeprom:=20
model=3D0<BR>cx23885[0]: cx23885 based dvb card<BR>MT2131: successfully =
identified=20
at address 0x61<BR>DVB: registering new adapter (cx23885[0])<BR>DVB: =
registering=20
frontend 0 (Samsung S5H1409 QAM/8VSB =
Frontend)...<BR>cx23885_dev_checkrevision()=20
Hardware revision =3D 0xc0<BR>cx23885[0]/0: found at 0000:02:00.0, rev: =
3, irq:=20
21, latency: 0, mmio: 0xfd600000<BR></FONT></SPAN></DIV>
<DIV><SPAN class=3D653502903-17032008><FONT face=3DArial =
size=3D2><BR>BUG: unable to=20
handle kernel paging request at virtual address =
fd7fffff<BR>&nbsp;printing=20
eip:<BR>c01090bd<BR>*pde =3D 00000000<BR>Oops: 0000 [#1]<BR>SMP<BR>last =
sysfs=20
file: /devices/pci0000:00/0000:00:18.3/name<BR>Modules linked in: =
snd_pcm_oss=20
snd_mixer_oss snd_seq_midi snd_seq_midi_event snd_seq iptable_filter =
ip_tables=20
ip6_tables x_tables xfs loop dm_mod mt2131 s5h1409 osst ohci1394 cx23885 =

nvidia(P) ieee1394 videodev v4l1_compat compat_ioctl32 v4l2_common st =
button=20
rtc_cmos snd_hda_intel rtc_core snd_pcm snd_timer snd_mpu401 forcedeth =
rtc_lib=20
btcx_risc tveeprom videobuf_dvb dvb_core videobuf_dma_sg agpgart =
snd_mpu401_uart=20
snd_rawmidi snd_seq_device snd soundcore hwmon videobuf_core =
snd_page_alloc=20
parport_pc lirc_imon(F) parport sr_mod cdrom i2c_nforce2 i2c_core =
lirc_dev sg=20
sd_mod ehci_hcd ohci_hcd usbcore edd ext3 mbcache jbd fan aic7xxx=20
scsi_transport_spi sata_nv pata_amd libata scsi_mod thermal=20
processor<BR>CPU:&nbsp;&nbsp;&nbsp; 0<BR>EIP:&nbsp;&nbsp;&nbsp;=20
0060:[&lt;c01090bd&gt;]&nbsp;&nbsp;&nbsp; Tainted: =
PF&nbsp;&nbsp;&nbsp;&nbsp; N=20
VLI<BR>EFLAGS: 00010286&nbsp;&nbsp; (2.6.22.17-0.1-default #1)<BR>EIP is =
at=20
dma_free_coherent+0x22/0x53<BR>eax: 00000000&nbsp;&nbsp; ebx:=20
ebcab000&nbsp;&nbsp; ecx: fd7fffff&nbsp;&nbsp; edx: 000001d4<BR>esi:=20
00000000&nbsp;&nbsp; edi: f305422c&nbsp;&nbsp; ebp: f746d1e0&nbsp;&nbsp; =
esp:=20
ebc77f60<BR>ds: 007b&nbsp;&nbsp; es: 007b&nbsp;&nbsp; fs: 00d8&nbsp; gs: =

0000&nbsp; ss: 0068<BR>Process cx23885[0] dvb (pid: 4290, ti=3Debc76000=20
task=3Df600f570 task.ti=3Debc76000)<BR>Stack: dfe01c90 dfe01c48 f9178416 =
2bcab000=20
f918a358 ffffffea f30541c0 =
f3054248<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
f746d128 f92a1dcd f746d128 00000000 00000282 f914a414 f746d128=20
00000000<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ebc8be80 f914a504 =
f746d128=20
f746d120 f914a58b ebc8bea4 f915f3e7 c011dfa6<BR>Call=20
Trace:<BR>&nbsp;[&lt;f9178416&gt;] btcx_riscmem_free+0x58/0x68=20
[btcx_risc]<BR>&nbsp;[&lt;f918a358&gt;] videobuf_dma_unmap+0x43/0x58=20
[videobuf_dma_sg]<BR>&nbsp;[&lt;f92a1dcd&gt;] =
cx23885_free_buffer+0x4a/0x55=20
[cx23885]<BR>&nbsp;[&lt;f914a414&gt;] videobuf_queue_cancel+0x72/0x8e=20
[videobuf_core]<BR>&nbsp;[&lt;f914a504&gt;] =
__videobuf_read_stop+0xb/0x53=20
[videobuf_core]<BR>&nbsp;[&lt;f914a58b&gt;] videobuf_read_stop+0xf/0x17=20
[videobuf_core]<BR>&nbsp;[&lt;f915f3e7&gt;] =
videobuf_dvb_thread+0xec/0x12f=20
[videobuf_dvb]<BR>&nbsp;[&lt;c011dfa6&gt;]=20
complete+0x39/0x48<BR>&nbsp;[&lt;f915f2fb&gt;] =
videobuf_dvb_thread+0x0/0x12f=20
[videobuf_dvb]<BR>&nbsp;[&lt;c01350ee&gt;]=20
kthread+0x38/0x5e<BR>&nbsp;[&lt;c01350b6&gt;]=20
kthread+0x0/0x5e<BR>&nbsp;[&lt;c0106117&gt;]=20
kernel_thread_helper+0x7/0x10<BR>&nbsp;=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<BR>Code: d8 5b e9=20
eb 44 06 00 5b c3 56 53 89 cb 31 c9 85 c0 74 06 8b 88 40 01 00 00 8d 42 =
ff 83 ce=20
ff c1 e8 0b 46 d1 e8 75 fb 85 c9 74 26 &lt;8b&gt; 11 39 d3 72 20 8b 41 =
08 c1 e0=20
0c 8d 04 02 39 c3 73 13 29 d3<BR>EIP: [&lt;c01090bd&gt;]=20
dma_free_coherent+0x22/0x53 SS:ESP 0068:ebc77f60</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<DIV>mythtv:~ #=20
lsmod<BR>Module&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
Size&nbsp; Used=20
by<BR>snd_pcm_oss&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;=20
50432&nbsp;=20
0<BR>snd_mixer_oss&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =

20096&nbsp; 1=20
snd_pcm_oss<BR>snd_seq_midi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;=20
13440&nbsp; 0<BR>snd_seq_midi_event&nbsp;&nbsp;&nbsp;&nbsp; 10880&nbsp; =
1=20
snd_seq_midi<BR>snd_seq&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
54452&nbsp; 2=20
snd_seq_midi,snd_seq_midi_event<BR>iptable_filter&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
6912&nbsp;=20
0<BR>ip_tables&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;=20
16324&nbsp; 1=20
iptable_filter<BR>ip6_tables&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;=20
17476&nbsp;=20
0<BR>x_tables&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;=20
18308&nbsp; 2=20
ip_tables,ip6_tables<BR>xfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
502932&nbsp;=20
1<BR>loop&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
21636&nbsp;=20
0<BR>dm_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
56880&nbsp;=20
3<BR>mt2131&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
9732&nbsp;=20
1<BR>s5h1409&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
12548&nbsp;=20
1<BR>osst&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
54172&nbsp;=20
0<BR>ohci1394&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;=20
36272&nbsp;=20
0<BR>cx23885&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
66644&nbsp;=20
2<BR>nvidia&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;=20
7846932&nbsp;=20
26<BR>ieee1394&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;=20
91136&nbsp; 1=20
ohci1394<BR>videodev&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
35584&nbsp; 1=20
cx23885<BR>v4l1_compat&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;=20
16388&nbsp; 1=20
videodev<BR>compat_ioctl32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;=20
5376&nbsp; 1=20
cx23885<BR>v4l2_common&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;=20
14976&nbsp; 1=20
cx23885<BR>st&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
40092&nbsp;=20
0<BR>button&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
12560&nbsp;=20
0<BR>rtc_cmos&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;=20
12064&nbsp; =
0<BR>snd_hda_intel&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
273180&nbsp;=20
3<BR>rtc_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;=20
23048&nbsp; 1=20
rtc_cmos<BR>snd_pcm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
82564&nbsp; 3=20
snd_pcm_oss,snd_hda_intel<BR>snd_timer&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
26756&nbsp; 2=20
snd_seq,snd_pcm<BR>snd_mpu401&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
12684&nbsp;=20
0<BR>forcedeth&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;=20
50056&nbsp;=20
0<BR>rtc_lib&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
7040&nbsp; 1=20
rtc_core<BR>btcx_risc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8712&nbsp; 1=20
cx23885<BR>tveeprom&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
15748&nbsp; 1=20
cx23885<BR>videobuf_dvb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;=20
10628&nbsp; 1=20
cx23885<BR>dvb_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
76548&nbsp; 1=20
videobuf_dvb<BR>videobuf_dma_sg&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
=20
17028&nbsp; 2=20
cx23885,videobuf_dvb<BR>agpgart&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
35764&nbsp; 1=20
nvidia<BR>snd_mpu401_uart&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
12416&nbsp;=20
1=20
snd_mpu401<BR>snd_rawmidi&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;=20
28416&nbsp; 2=20
snd_seq_midi,snd_mpu401_uart<BR>snd_seq_device&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;=20
12172&nbsp; 3=20
snd_seq_midi,snd_seq,snd_rawmidi<BR>snd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;=20
58164&nbsp; 16=20
snd_pcm_oss,snd_mixer_oss,snd_seq_midi,snd_seq,snd_hda_intel,snd_pcm,snd_=
timer,snd_mpu401,snd_mpu401_uart,snd_rawmidi,snd_seq_device<BR>soundcore&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;=20
11460&nbsp; 1=20
snd<BR>hwmon&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
7300&nbsp;=20
0<BR>videobuf_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =

21380&nbsp; 3=20
cx23885,videobuf_dvb,videobuf_dma_sg<BR>snd_page_alloc&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
14472&nbsp; 2=20
snd_hda_intel,snd_pcm<BR>parport_pc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
40892&nbsp;=20
0<BR>lirc_imon&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;=20
19976&nbsp;=20
1<BR>parport&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
37832&nbsp; 1=20
parport_pc<BR>sr_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
19492&nbsp;=20
0<BR>cdrom&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
37020&nbsp; 1=20
sr_mod<BR>i2c_nforce2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;=20
9856&nbsp;=20
0<BR>i2c_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;=20
27520&nbsp; 7=20
mt2131,s5h1409,cx23885,nvidia,v4l2_common,tveeprom,i2c_nforce2<BR>lirc_de=
v&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;=20
18264&nbsp; 1=20
lirc_imon<BR>sg&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
37036&nbsp;=20
0<BR>sd_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
31104&nbsp;=20
7<BR>ehci_hcd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;=20
35340&nbsp;=20
0<BR>ohci_hcd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;=20
23684&nbsp;=20
0<BR>usbcore&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;=20
124268&nbsp; 5=20
lirc_imon,ehci_hcd,ohci_hcd<BR>edd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
12996&nbsp;=20
0<BR>ext3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
131848&nbsp;=20
4<BR>mbcache&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
12292&nbsp; 1=20
ext3<BR>jbd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
68148&nbsp; 1=20
ext3<BR>fan&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
9220&nbsp;=20
0<BR>aic7xxx&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;=20
157348&nbsp; 0<BR>scsi_transport_spi&nbsp;&nbsp;&nbsp;&nbsp; 27008&nbsp; =
1=20
aic7xxx<BR>sata_nv&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
22664&nbsp;=20
6<BR>pata_amd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;=20
16644&nbsp;=20
0<BR>libata&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
139216&nbsp; 2=20
sata_nv,pata_amd<BR>scsi_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
140376&nbsp; 8=20
osst,st,sr_mod,sg,sd_mod,aic7xxx,scsi_transport_spi,libata<BR>thermal&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;=20
20872&nbsp;=20
0<BR>processor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;=20
40876&nbsp; 1 thermal<BR></FONT></SPAN></DIV></BODY></HTML>

------_=_NextPart_001_01C887DF.C9E9B987--


--===============1036064530==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1036064530==--
