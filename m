Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from [212.57.247.218] (helo=glcweb.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael.curtis@glcweb.co.uk>) id 1JOVzD-0006BV-AF
	for linux-dvb@linuxtv.org; Mon, 11 Feb 2008 11:34:08 +0100
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Mon, 11 Feb 2008 10:33:36 -0000
Message-ID: <A33C77E06C9E924F8E6D796CA3D635D1017B4B@w2k3sbs.glcdomain.local>
From: "Michael Curtis" <michael.curtis@glcweb.co.uk>
To: "Michael Curtis" <michael.curtis@glcweb.co.uk>,
	<linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] multiproto TT3200 szap no lock
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0966823752=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============0966823752==
Content-class: urn:content-classes:message
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C86C99.8EDBE1DD"

This is a multi-part message in MIME format.

------_=_NextPart_001_01C86C99.8EDBE1DD
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Can anyone advise on why the required parameters are not it would seem =
being passed to the tuner?
=20
I am fumbling in the dark on this as all modules seem to have loaded =
o.k.
=20
=20
Feb  8 15:53:44 f864office kernel: stb0899_search: delivery system=3D1=20
Feb  8 15:53:44 f864office kernel: stb0899_search: Frequency=3D0, =
Srate=3D0=20
Feb  8 15:53:44 f864office kernel: stb0899_read_status: Delivery system=20
DVB-S/DSS=20

Regards
=20
=20
Michael Curtis

________________________________

From: linux-dvb-bounces@linuxtv.org on behalf of Michael Curtis
Sent: Fri 2/8/2008 11:06 PM
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] multiproto TT3200 szap no lock



Hi all=20

I have been trying to get the TT3200 working on linux for a while now=20
and was encouraged by initial results from the latest Manu offering=20

multiproto-45eec532cefa=20

No errors in compiling and after a reboot all modules (I think all=20
modules) seem to have loaded=20

Dmesg gave (I have snipped this for brevity)=20

(saa7130 refs are from Compro DVB-T card fitted, that works well with=20
these drivers)=20

Feb  8 15:36:14 f864office kernel: ACPI: PCI Interrupt 0000:01:07.0[A]=20
-> Link [APC2] -> GSI 17 (level, low) -> IRQ 17=20
Feb  8 15:36:14 f864office kernel: saa7146: found saa7146 @ mem=20
ffffc20000abe000 (revision 1, irq 17) (0x13c2,0x1019).=20
Feb  8 15:36:14 f864office kernel: saa7146 (0): dma buffer size 192512=20
Feb  8 15:36:14 f864office kernel: DVB: registering new adapter=20
(TT-Budget S2-3200 PCI)=20
Feb  8 15:36:14 f864office kernel: adapter has MAC addr =3D=20
00:d0:5c:61:77:b3=20
Feb  8 15:36:14 f864office kernel: input: Budget-CI dvb ir receiver=20
saa7146 (0) as /class/input/input7=20
Feb  8 15:36:14 f864office kernel: budget_ci: CI interface initialised=20
Feb  8 15:36:14 f864office kernel: DVB: registering new adapter=20
(saa7130[0])=20
Feb  8 15:36:14 f864office kernel: DVB: registering frontend 1 (Philips=20
TDA10046H DVB-T)...=20
Feb  8 15:36:14 f864office kernel: tda1004x: setting up plls for 53MHz=20
sampling clock=20
Feb  8 15:36:14 f864office kernel: _stb0899_read_reg: Reg=3D[0xf000],=20
data=3D82=20
Feb  8 15:36:14 f864office kernel: stb0899_get_dev_id: ID reg=3D[0x82]=20
Feb  8 15:36:14 f864office kernel: stb0899_get_dev_id: Device ID=3D[8],=20
Release=3D[2]=20
Feb  8 15:36:14 f864office kernel: stb0899_get_dev_id: Demodulator Core=20
ID=3D[DMD1], Version=3D[1]=20
Feb  8 15:36:14 f864office kernel: stb0899_get_dev_id: FEC Core=20
ID=3D[FEC1], Version=3D[1]=20
Feb  8 15:36:14 f864office kernel: stb0899_attach: Attaching STB0899=20
Feb  8 15:36:14 f864office kernel: stb6100_attach: Attaching STB6100=20
Feb  8 15:36:14 f864office kernel: DVB: registering frontend 0 (STB0899=20
Multistandard)...=20

Output from lsmod=20

Module                  Size  Used by=20
nls_utf8               10305  1=20
vfat                   19009  1=20
fat                    54513  1 vfat=20
rfcomm                 50537  0=20
l2cap                  36289  9 rfcomm=20
bluetooth              64453  4 rfcomm,l2cap=20
sunrpc                168009  1=20
cpufreq_ondemand       15569  1=20
loop                   23493  0=20
dm_multipath           24401  0=20
ipv6                  307273  18=20
osst                   57193  0=20
st                     43109  0=20
lnbp21                 10240  1=20
stb6100                15748  1=20
stb0899                41728  1=20
saa7134_dvb            24076  0=20
videobuf_dvb           13316  1 saa7134_dvb=20
tda1004x               23300  2 saa7134_dvb=20
sr_mod                 23397  1=20
cdrom                  40553  1 sr_mod=20
snd_hda_intel         361577  3=20
snd_seq_dummy          11461  0=20
snd_seq_oss            37313  0=20
snd_seq_midi_event     15041  1 snd_seq_oss=20
snd_seq                56673  5=20
snd_seq_dummy,snd_seq_oss,snd_seq_midi_event=20
snd_seq_device         15061  3 snd_seq_dummy,snd_seq_oss,snd_seq=20
snd_pcm_oss            45889  0=20
snd_mixer_oss          22721  1 snd_pcm_oss=20
snd_pcm                80201  2 snd_hda_intel,snd_pcm_oss=20
snd_timer              27721  2 snd_seq,snd_pcm=20
snd_page_alloc         16465  2 snd_hda_intel,snd_pcm=20
budget_ci              30980  0=20
budget_core            17668  1 budget_ci=20
saa7134               148572  1 saa7134_dvb=20
videodev               33664  1 saa7134=20
v4l1_compat            19460  1 videodev=20
compat_ioctl32         16128  1 saa7134=20
v4l2_common            26240  3 saa7134,videodev,compat_ioctl32=20
videobuf_dma_sg        19716  3 saa7134_dvb,videobuf_dvb,saa7134=20
videobuf_core          24196  3 videobuf_dvb,saa7134,videobuf_dma_sg=20
ir_kbd_i2c             16912  1 saa7134=20
snd_hwdep              16073  1 snd_hda_intel=20
dvb_core               89684  3 videobuf_dvb,budget_ci,budget_core=20
saa7146                23688  2 budget_ci,budget_core=20
ttpci_eeprom           10496  1 budget_core=20
firewire_ohci          25281  0=20
ir_common              41732  3 budget_ci,saa7134,ir_kbd_i2c=20
snd                    60137  15=20
snd_hda_intel,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_o =

ss,snd_pcm,snd_timer,snd_hwdep=20
nvidia               8895940  24=20
firewire_core          46337  1 firewire_ohci=20
crc_itu_t              10433  1 firewire_core=20
aic7xxx               133501  0=20
scsi_transport_spi     32577  1 aic7xxx=20
parport_pc             35177  0=20
tveeprom               24848  1 saa7134=20
soundcore              15073  1 snd=20
sg                     40297  0=20
forcedeth              53321  0=20
parport                42317  1 parport_pc=20
pcspkr                 11329  0=20
button                 15969  0=20
pata_amd               20293  0=20
k8temp                 13377  0=20
hwmon                  11081  1 k8temp=20
i2c_nforce2            14017  0=20
usblp                  20801  0=20
i2c_core               28865  14=20
lnbp21,stb6100,stb0899,saa7134_dvb,tda1004x,budget_ci,budget_core,saa713 =

4,v4l2_common,ir_kbd_i2c,ttpci_eeprom,nvidia,tveeprom,i2c_nforce2=20
usb_storage            87681  2=20
dm_snapshot            23049  0=20
dm_zero                10433  0=20
dm_mirror              27200  0=20
dm_mod                 57905  9=20
dm_multipath,dm_snapshot,dm_zero,dm_mirror=20
ata_generic            14533  0=20
sata_nv                25285  2=20
libata                114288  3 pata_amd,ata_generic,sata_nv=20
sd_mod                 33345  5=20
scsi_mod              146553  9=20
osst,st,sr_mod,aic7xxx,scsi_transport_spi,sg,usb_storage,libata,sd_mod=20
ext3                  127569  2=20
jbd                    64945  1 ext3=20
mbcache                15937  1 ext3=20
uhci_hcd               30689  0=20
ohci_hcd               27973  0=20
ehci_hcd               39245  0=20


Trying the patched szap, I get=20

[mythtv@f864office Manu szap]$ ./szap -c ~/channels.sat2 -n 1424=20
reading channels from file '/home/mythtv/channels.sat2'=20
zapping to 1424 'BBC 1 London;BSkyB':=20
sat 0, frequency =3D 10773 MHz H, symbolrate 22000000, vpid =3D 0x1388, =
apid=20
=3D 0x1389 sid =3D 0x138b=20
Querying info .. Delivery system=3DDVB-S=20
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'=20
----------------------------------> Using 'STB0899 DVB-S' DVB-Sstatus 00 =

| signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |=20
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |=20
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |=20
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |=20
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |=20
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |=20
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |=20

and then the following appearing in dmesg (much shorter for brevity)=20

Feb  8 15:53:44 f864office kernel: stb0899_search: delivery system=3D1=20
Feb  8 15:53:44 f864office kernel: stb0899_search: Frequency=3D0, =
Srate=3D0=20
Feb  8 15:53:44 f864office kernel: stb0899_read_status: Delivery system=20
DVB-S/DSS=20
Feb  8 15:53:44 f864office kernel: stb0899_search: set DVB-S params=20
Feb  8 15:53:44 f864office kernel: stb0899_search: delivery system=3D1=20
Feb  8 15:53:44 f864office kernel: stb0899_search: Frequency=3D0, =
Srate=3D0=20
Feb  8 15:53:44 f864office kernel: stb0899_read_status: Delivery system=20
DVB-S/DSS=20
Feb  8 15:53:44 f864office kernel: stb0899_read_status: Delivery system=20
DVB-S/DSS=20
Feb  8 15:53:44 f864office kernel: _stb0899_read_reg: Reg=3D[0xf50d],=20
data=3D00=20
Feb  8 15:53:45 f864office kernel: stb0899_search: set DVB-S params=20
Feb  8 15:53:45 f864office kernel: stb0899_search: delivery system=3D1=20
Feb  8 15:53:45 f864office kernel: stb0899_search: Frequency=3D0, =
Srate=3D0=20
Feb  8 15:53:45 f864office kernel: stb0899_read_status: Delivery system=20
DVB-S/DSS=20
Feb  8 15:53:45 f864office kernel: stb0899_search: set DVB-S params=20
Feb  8 15:53:45 f864office kernel: stb0899_search: delivery system=3D1=20
Feb  8 15:53:45 f864office kernel: stb0899_search: Frequency=3D0, =
Srate=3D0=20
Feb  8 15:53:45 f864office kernel: stb0899_read_status: Delivery system=20
DVB-S/DSS=20
Feb  8 15:53:45 f864office kernel: stb0899_read_status: Delivery system=20
DVB-S/DSS=20
Feb  8 15:53:45 f864office kernel: _stb0899_read_reg: Reg=3D[0xf50d],=20
data=3D00=20
Feb  8 15:53:46 f864office kernel: _stb0899_read_reg: Reg=3D[0xf12a],=20
data=3Dc8=20
Feb  8 15:53:46 f864office kernel: stb0899_sleep: Going to Sleep ..=20
(Really tired .. :-))=20

I cannot see anything wrong and so am stumped to proceed, any help will=20
be appreciated=20

Is there a howto on installing these driver so I can check if I have=20
done everything correctly?=20

Regards=20


Mike=20

_______________________________________________=20
linux-dvb mailing list=20
linux-dvb@linuxtv.org=20
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb=20

--=20
This message has been scanned for viruses and=20
dangerous content by IC-MailScanner, and is=20
believed to be clean.=20

For queries or information please contact:-=20

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=20
Internet Central Technical Support=20


 http://www.netcentral.co.uk=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=20


No virus found in this incoming message.
Checked by AVG Free Edition.
Version: 7.5.516 / Virus Database: 269.20.2/1270 - Release Date: =
10/02/2008 12:21
 =20


------_=_NextPart_001_01C86C99.8EDBE1DD
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Diso-8859-1">=0A=
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">=0A=
<HTML>=0A=
<HEAD>=0A=
=0A=
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.5.7226.0">=0A=
<TITLE>[linux-dvb] multiproto TT3200 szap no lock</TITLE>=0A=
</HEAD>=0A=
<BODY>=0A=
<DIV id=3DidOWAReplyText96530 dir=3Dltr>=0A=
<DIV dir=3Dltr><FONT face=3DArial color=3D#000000 size=3D2><FONT =0A=
face=3D"Times New Roman">Can anyone advise on why the required =
parameters are not =0A=
it would seem being passed to the tuner?</FONT></FONT></DIV>=0A=
<DIV dir=3Dltr><FONT size=3D2></FONT>&nbsp;</DIV>=0A=
<DIV dir=3Dltr><FONT size=3D2>I am fumbling in the dark on this as all =
modules seem =0A=
to have loaded o.k.</FONT></DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial color=3D#000000 size=3D2><FONT =0A=
face=3D"Times New Roman"></FONT></FONT>&nbsp;</DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial color=3D#000000 size=3D2><FONT =0A=
face=3D"Times New Roman"></FONT></FONT>&nbsp;</DIV>=0A=
<DIV dir=3Dltr><FONT face=3DArial color=3D#000000 size=3D2><FONT =0A=
face=3D"Times New Roman">Feb&nbsp; 8 15:53:44 f864office kernel: =
stb0899_search: =0A=
delivery system=3D1</FONT><FONT face=3D"Times New Roman"><FONT size=3D3> =0A=
<BR></FONT><FONT size=3D2>Feb&nbsp; 8 15:53:44 f864office kernel: =
stb0899_search: =0A=
Frequency=3D0, Srate=3D0</FONT></FONT><FONT face=3D"Times New =
Roman"><FONT size=3D3> =0A=
<BR></FONT><FONT size=3D2>Feb&nbsp; 8 15:53:44 f864office kernel: =0A=
stb0899_read_status: Delivery system</FONT></FONT><FONT =0A=
face=3D"Times New Roman"><FONT size=3D3> <BR></FONT><FONT =0A=
size=3D2>DVB-S/DSS</FONT><FONT size=3D3> =
</FONT></FONT><BR></DIV></FONT></DIV>=0A=
<DIV dir=3Dltr>Regards</DIV>=0A=
<DIV dir=3Dltr>&nbsp;</DIV>=0A=
<DIV dir=3Dltr>&nbsp;</DIV>=0A=
<DIV dir=3Dltr>Michael Curtis<BR></DIV>=0A=
<DIV dir=3Dltr>=0A=
<HR tabIndex=3D-1>=0A=
</DIV>=0A=
<DIV dir=3Dltr><FONT face=3DTahoma size=3D2><B>From:</B> =
linux-dvb-bounces@linuxtv.org =0A=
on behalf of Michael Curtis<BR><B>Sent:</B> Fri 2/8/2008 11:06 =
PM<BR><B>To:</B> =0A=
linux-dvb@linuxtv.org<BR><B>Subject:</B> [linux-dvb] multiproto TT3200 =
szap no =0A=
lock<BR></FONT><BR></DIV>=0A=
<DIV>=0A=
<P><FONT size=3D2>Hi all</FONT> </P>=0A=
<P><FONT size=3D2>I have been trying to get the TT3200 working on linux =
for a =0A=
while now</FONT> <BR><FONT size=3D2>and was encouraged by initial =
results from the =0A=
latest Manu offering</FONT> </P>=0A=
<P><FONT size=3D2>multiproto-45eec532cefa</FONT> </P>=0A=
<P><FONT size=3D2>No errors in compiling and after a reboot all modules =
(I think =0A=
all</FONT> <BR><FONT size=3D2>modules) seem to have loaded</FONT> </P>=0A=
<P><FONT size=3D2>Dmesg gave (I have snipped this for brevity) =
</FONT></P>=0A=
<P><FONT size=3D2>(saa7130 refs are from Compro DVB-T card fitted, that =
works well =0A=
with</FONT> <BR><FONT size=3D2>these drivers)</FONT> </P>=0A=
<P><FONT size=3D2>Feb&nbsp; 8 15:36:14 f864office kernel: ACPI: PCI =
Interrupt =0A=
0000:01:07.0[A]</FONT> <BR><FONT size=3D2>-&gt; Link [APC2] -&gt; GSI 17 =
(level, =0A=
low) -&gt; IRQ 17</FONT> <BR><FONT size=3D2>Feb&nbsp; 8 15:36:14 =
f864office =0A=
kernel: saa7146: found saa7146 @ mem</FONT> <BR><FONT =
size=3D2>ffffc20000abe000 =0A=
(revision 1, irq 17) (0x13c2,0x1019).</FONT> <BR><FONT =
size=3D2>Feb&nbsp; 8 =0A=
15:36:14 f864office kernel: saa7146 (0): dma buffer size 192512</FONT> =
<BR><FONT =0A=
size=3D2>Feb&nbsp; 8 15:36:14 f864office kernel: DVB: registering new =0A=
adapter</FONT> <BR><FONT size=3D2>(TT-Budget S2-3200 PCI)</FONT> =
<BR><FONT =0A=
size=3D2>Feb&nbsp; 8 15:36:14 f864office kernel: adapter has MAC addr =
=3D</FONT> =0A=
<BR><FONT size=3D2>00:d0:5c:61:77:b3</FONT> <BR><FONT size=3D2>Feb&nbsp; =
8 15:36:14 =0A=
f864office kernel: input: Budget-CI dvb ir receiver</FONT> <BR><FONT =0A=
size=3D2>saa7146 (0) as /class/input/input7</FONT> <BR><FONT =
size=3D2>Feb&nbsp; 8 =0A=
15:36:14 f864office kernel: budget_ci: CI interface initialised</FONT> =
<BR><FONT =0A=
size=3D2>Feb&nbsp; 8 15:36:14 f864office kernel: DVB: registering new =0A=
adapter</FONT> <BR><FONT size=3D2>(saa7130[0])</FONT> <BR><FONT =
size=3D2>Feb&nbsp; 8 =0A=
15:36:14 f864office kernel: DVB: registering frontend 1 (Philips</FONT> =0A=
<BR><FONT size=3D2>TDA10046H DVB-T)...</FONT> <BR><FONT =
size=3D2>Feb&nbsp; 8 =0A=
15:36:14 f864office kernel: tda1004x: setting up plls for 53MHz</FONT> =
<BR><FONT =0A=
size=3D2>sampling clock</FONT> <BR><FONT size=3D2>Feb&nbsp; 8 15:36:14 =
f864office =0A=
kernel: _stb0899_read_reg: Reg=3D[0xf000],</FONT> <BR><FONT =
size=3D2>data=3D82</FONT> =0A=
<BR><FONT size=3D2>Feb&nbsp; 8 15:36:14 f864office kernel: =
stb0899_get_dev_id: ID =0A=
reg=3D[0x82]</FONT> <BR><FONT size=3D2>Feb&nbsp; 8 15:36:14 f864office =
kernel: =0A=
stb0899_get_dev_id: Device ID=3D[8],</FONT> <BR><FONT =
size=3D2>Release=3D[2]</FONT> =0A=
<BR><FONT size=3D2>Feb&nbsp; 8 15:36:14 f864office kernel: =
stb0899_get_dev_id: =0A=
Demodulator Core</FONT> <BR><FONT size=3D2>ID=3D[DMD1], =
Version=3D[1]</FONT> <BR><FONT =0A=
size=3D2>Feb&nbsp; 8 15:36:14 f864office kernel: stb0899_get_dev_id: FEC =0A=
Core</FONT> <BR><FONT size=3D2>ID=3D[FEC1], Version=3D[1]</FONT> =
<BR><FONT =0A=
size=3D2>Feb&nbsp; 8 15:36:14 f864office kernel: stb0899_attach: =
Attaching =0A=
STB0899</FONT> <BR><FONT size=3D2>Feb&nbsp; 8 15:36:14 f864office =
kernel: =0A=
stb6100_attach: Attaching STB6100</FONT> <BR><FONT size=3D2>Feb&nbsp; 8 =
15:36:14 =0A=
f864office kernel: DVB: registering frontend 0 (STB0899</FONT> <BR><FONT =0A=
size=3D2>Multistandard)...</FONT> </P>=0A=
<P><FONT size=3D2>Output from lsmod</FONT> </P>=0A=
<P><FONT =0A=
size=3D2>Module&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
Size&nbsp; Used by</FONT> <BR><FONT =0A=
size=3D2>nls_utf8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
10305&nbsp; 1 </FONT><BR><FONT =0A=
size=3D2>vfat&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
19009&nbsp; 1 </FONT><BR><FONT =0A=
size=3D2>fat&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
54513&nbsp; 1 vfat</FONT> <BR><FONT =0A=
size=3D2>rfcomm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
50537&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>l2cap&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
36289&nbsp; 9 rfcomm</FONT> <BR><FONT =0A=
size=3D2>bluetooth&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; =0A=
64453&nbsp; 4 rfcomm,l2cap</FONT> <BR><FONT =0A=
size=3D2>sunrpc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
168009&nbsp; 1 </FONT><BR><FONT =0A=
size=3D2>cpufreq_ondemand&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
15569&nbsp; 1 =0A=
</FONT><BR><FONT =0A=
size=3D2>loop&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
23493&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>dm_multipath&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; =0A=
24401&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>ipv6&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
307273&nbsp; 18 </FONT><BR><FONT =0A=
size=3D2>osst&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
57193&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>st&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
43109&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>lnbp21&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
10240&nbsp; 1 </FONT><BR><FONT =0A=
size=3D2>stb6100&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
15748&nbsp; 1 </FONT><BR><FONT =0A=
size=3D2>stb0899&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
41728&nbsp; 1 </FONT><BR><FONT =0A=
size=3D2>saa7134_dvb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; =0A=
24076&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>videobuf_dvb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; =0A=
13316&nbsp; 1 saa7134_dvb</FONT> <BR><FONT =0A=
size=3D2>tda1004x&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
23300&nbsp; 2 saa7134_dvb</FONT> <BR><FONT =0A=
size=3D2>sr_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
23397&nbsp; 1 </FONT><BR><FONT =0A=
size=3D2>cdrom&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
40553&nbsp; 1 sr_mod</FONT> <BR><FONT =0A=
size=3D2>snd_hda_intel&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
361577&nbsp; 3 </FONT><BR><FONT =0A=
size=3D2>snd_seq_dummy&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; =0A=
11461&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>snd_seq_oss&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; =0A=
37313&nbsp; 0 </FONT><BR><FONT =
size=3D2>snd_seq_midi_event&nbsp;&nbsp;&nbsp;&nbsp; =0A=
15041&nbsp; 1 snd_seq_oss</FONT> <BR><FONT =0A=
size=3D2>snd_seq&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
56673&nbsp; 5</FONT> <BR><FONT =0A=
size=3D2>snd_seq_dummy,snd_seq_oss,snd_seq_midi_event</FONT> <BR><FONT =0A=
size=3D2>snd_seq_device&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
15061&nbsp; 3 snd_seq_dummy,snd_seq_oss,snd_seq</FONT> <BR><FONT =0A=
size=3D2>snd_pcm_oss&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; =0A=
45889&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>snd_mixer_oss&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; =0A=
22721&nbsp; 1 snd_pcm_oss</FONT> <BR><FONT =0A=
size=3D2>snd_pcm&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
80201&nbsp; 2 snd_hda_intel,snd_pcm_oss</FONT> <BR><FONT =0A=
size=3D2>snd_timer&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; =0A=
27721&nbsp; 2 snd_seq,snd_pcm</FONT> <BR><FONT =0A=
size=3D2>snd_page_alloc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
16465&nbsp; 2 snd_hda_intel,snd_pcm</FONT> <BR><FONT =0A=
size=3D2>budget_ci&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; =0A=
30980&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>budget_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; =0A=
17668&nbsp; 1 budget_ci</FONT> <BR><FONT =0A=
size=3D2>saa7134&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
148572&nbsp; 1 saa7134_dvb</FONT> <BR><FONT =0A=
size=3D2>videodev&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
33664&nbsp; 1 saa7134</FONT> <BR><FONT =0A=
size=3D2>v4l1_compat&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; =0A=
19460&nbsp; 1 videodev</FONT> <BR><FONT =0A=
size=3D2>compat_ioctl32&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
16128&nbsp; 1 saa7134</FONT> <BR><FONT =0A=
size=3D2>v4l2_common&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; =0A=
26240&nbsp; 3 saa7134,videodev,compat_ioctl32</FONT> <BR><FONT =0A=
size=3D2>videobuf_dma_sg&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
19716&nbsp; 3 =0A=
saa7134_dvb,videobuf_dvb,saa7134</FONT> <BR><FONT =0A=
size=3D2>videobuf_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; =0A=
24196&nbsp; 3 videobuf_dvb,saa7134,videobuf_dma_sg</FONT> <BR><FONT =0A=
size=3D2>ir_kbd_i2c&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; =0A=
16912&nbsp; 1 saa7134</FONT> <BR><FONT =0A=
size=3D2>snd_hwdep&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; =0A=
16073&nbsp; 1 snd_hda_intel</FONT> <BR><FONT =0A=
size=3D2>dvb_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
89684&nbsp; 3 videobuf_dvb,budget_ci,budget_core</FONT> <BR><FONT =0A=
size=3D2>saa7146&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
23688&nbsp; 2 budget_ci,budget_core</FONT> <BR><FONT =0A=
size=3D2>ttpci_eeprom&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp; =0A=
10496&nbsp; 1 budget_core</FONT> <BR><FONT =0A=
size=3D2>firewire_ohci&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; =0A=
25281&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>ir_common&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; =0A=
41732&nbsp; 3 budget_ci,saa7134,ir_kbd_i2c</FONT> <BR><FONT =0A=
size=3D2>snd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
60137&nbsp; 15</FONT> <BR><FONT =0A=
size=3D2>snd_hda_intel,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd=
_mixer_o</FONT> =0A=
<BR><FONT size=3D2>ss,snd_pcm,snd_timer,snd_hwdep</FONT> <BR><FONT =0A=
size=3D2>nvidia&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
8895940&nbsp; 24 </FONT><BR><FONT =0A=
size=3D2>firewire_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; =0A=
46337&nbsp; 1 firewire_ohci</FONT> <BR><FONT =0A=
size=3D2>crc_itu_t&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; =0A=
10433&nbsp; 1 firewire_core</FONT> <BR><FONT =0A=
size=3D2>aic7xxx&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
133501&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>scsi_transport_spi&nbsp;&nbsp;&nbsp;&nbsp; 32577&nbsp; 1 =
aic7xxx</FONT> =0A=
<BR><FONT =0A=
size=3D2>parport_pc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; =0A=
35177&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>tveeprom&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
24848&nbsp; 1 saa7134</FONT> <BR><FONT =0A=
size=3D2>soundcore&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; =0A=
15073&nbsp; 1 snd</FONT> <BR><FONT =0A=
size=3D2>sg&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
40297&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>forcedeth&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; =0A=
53321&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>parport&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
42317&nbsp; 1 parport_pc</FONT> <BR><FONT =0A=
size=3D2>pcspkr&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
11329&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>button&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
15969&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>pata_amd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
20293&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>k8temp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
13377&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>hwmon&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
11081&nbsp; 1 k8temp</FONT> <BR><FONT =0A=
size=3D2>i2c_nforce2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; =0A=
14017&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>usblp&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
20801&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>i2c_core&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
28865&nbsp; 14</FONT> <BR><FONT =0A=
size=3D2>lnbp21,stb6100,stb0899,saa7134_dvb,tda1004x,budget_ci,budget_cor=
e,saa713</FONT> =0A=
<BR><FONT =0A=
size=3D2>4,v4l2_common,ir_kbd_i2c,ttpci_eeprom,nvidia,tveeprom,i2c_nforce=
2</FONT> =0A=
<BR><FONT =0A=
size=3D2>usb_storage&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; =0A=
87681&nbsp; 2 </FONT><BR><FONT =0A=
size=3D2>dm_snapshot&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; =0A=
23049&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>dm_zero&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
10433&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>dm_mirror&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp; =0A=
27200&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>dm_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
57905&nbsp; 9</FONT> <BR><FONT =0A=
size=3D2>dm_multipath,dm_snapshot,dm_zero,dm_mirror</FONT> <BR><FONT =0A=
size=3D2>ata_generic&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp; =0A=
14533&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>sata_nv&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
25285&nbsp; 2 </FONT><BR><FONT =0A=
size=3D2>libata&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
114288&nbsp; 3 pata_amd,ata_generic,sata_nv</FONT> <BR><FONT =0A=
size=3D2>sd_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
33345&nbsp; 5 </FONT><BR><FONT =0A=
size=3D2>scsi_mod&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp; =0A=
146553&nbsp; 9</FONT> <BR><FONT =0A=
size=3D2>osst,st,sr_mod,aic7xxx,scsi_transport_spi,sg,usb_storage,libata,=
sd_mod</FONT> =0A=
<BR><FONT =0A=
size=3D2>ext3&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
127569&nbsp; 2 </FONT><BR><FONT =0A=
size=3D2>jbd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
64945&nbsp; 1 ext3</FONT> <BR><FONT =0A=
size=3D2>mbcache&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
15937&nbsp; 1 ext3</FONT> <BR><FONT =0A=
size=3D2>uhci_hcd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
30689&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>ohci_hcd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
27973&nbsp; 0 </FONT><BR><FONT =0A=
size=3D2>ehci_hcd&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp; =0A=
39245&nbsp; 0 </FONT></P><BR>=0A=
<P><FONT size=3D2>Trying the patched szap, I get</FONT> </P>=0A=
<P><FONT size=3D2>[mythtv@f864office Manu szap]$ ./szap -c =
~/channels.sat2 -n =0A=
1424</FONT> <BR><FONT size=3D2>reading channels from file =0A=
'/home/mythtv/channels.sat2'</FONT> <BR><FONT size=3D2>zapping to 1424 =
'BBC 1 =0A=
London;BSkyB':</FONT> <BR><FONT size=3D2>sat 0, frequency =3D 10773 MHz =
H, =0A=
symbolrate 22000000, vpid =3D 0x1388, apid</FONT> <BR><FONT size=3D2>=3D =
0x1389 sid =3D =0A=
0x138b</FONT> <BR><FONT size=3D2>Querying info .. Delivery =
system=3DDVB-S</FONT> =0A=
<BR><FONT size=3D2>using '/dev/dvb/adapter0/frontend0' and =0A=
'/dev/dvb/adapter0/demux0'</FONT> <BR><FONT =0A=
size=3D2>----------------------------------&gt; Using 'STB0899 DVB-S' =
DVB-Sstatus =0A=
00</FONT> <BR><FONT size=3D2>| signal 0000 | snr 0004 | ber 00000000 | =
unc =0A=
fffffffe | </FONT><BR><FONT size=3D2>status 00 | signal 0000 | snr 0004 =
| ber =0A=
00000000 | unc fffffffe | </FONT><BR><FONT size=3D2>status 00 | signal =
0000 | snr =0A=
0004 | ber 00000000 | unc fffffffe | </FONT><BR><FONT size=3D2>status 00 =
| signal =0A=
0000 | snr 0004 | ber 00000000 | unc fffffffe | </FONT><BR><FONT =
size=3D2>status =0A=
00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe | =
</FONT><BR><FONT =0A=
size=3D2>status 00 | signal 0000 | snr 0004 | ber 00000000 | unc =
fffffffe | =0A=
</FONT><BR><FONT size=3D2>status 00 | signal 0000 | snr 0004 | ber =
00000000 | unc =0A=
fffffffe |</FONT> </P>=0A=
<P><FONT size=3D2>and then the following appearing in dmesg (much =
shorter for =0A=
brevity)</FONT> </P>=0A=
<P><FONT size=3D2>Feb&nbsp; 8 15:53:44 f864office kernel: =
stb0899_search: delivery =0A=
system=3D1</FONT> <BR><FONT size=3D2>Feb&nbsp; 8 15:53:44 f864office =
kernel: =0A=
stb0899_search: Frequency=3D0, Srate=3D0</FONT> <BR><FONT =
size=3D2>Feb&nbsp; 8 =0A=
15:53:44 f864office kernel: stb0899_read_status: Delivery system</FONT> =0A=
<BR><FONT size=3D2>DVB-S/DSS</FONT> <BR><FONT size=3D2>Feb&nbsp; 8 =
15:53:44 =0A=
f864office kernel: stb0899_search: set DVB-S params</FONT> <BR><FONT =0A=
size=3D2>Feb&nbsp; 8 15:53:44 f864office kernel: stb0899_search: =
delivery =0A=
system=3D1</FONT> <BR><FONT size=3D2>Feb&nbsp; 8 15:53:44 f864office =
kernel: =0A=
stb0899_search: Frequency=3D0, Srate=3D0</FONT> <BR><FONT =
size=3D2>Feb&nbsp; 8 =0A=
15:53:44 f864office kernel: stb0899_read_status: Delivery system</FONT> =0A=
<BR><FONT size=3D2>DVB-S/DSS</FONT> <BR><FONT size=3D2>Feb&nbsp; 8 =
15:53:44 =0A=
f864office kernel: stb0899_read_status: Delivery system</FONT> <BR><FONT =0A=
size=3D2>DVB-S/DSS</FONT> <BR><FONT size=3D2>Feb&nbsp; 8 15:53:44 =
f864office kernel: =0A=
_stb0899_read_reg: Reg=3D[0xf50d],</FONT> <BR><FONT =
size=3D2>data=3D00</FONT> =0A=
<BR><FONT size=3D2>Feb&nbsp; 8 15:53:45 f864office kernel: =
stb0899_search: set =0A=
DVB-S params</FONT> <BR><FONT size=3D2>Feb&nbsp; 8 15:53:45 f864office =
kernel: =0A=
stb0899_search: delivery system=3D1</FONT> <BR><FONT size=3D2>Feb&nbsp; =
8 15:53:45 =0A=
f864office kernel: stb0899_search: Frequency=3D0, Srate=3D0</FONT> =
<BR><FONT =0A=
size=3D2>Feb&nbsp; 8 15:53:45 f864office kernel: stb0899_read_status: =
Delivery =0A=
system</FONT> <BR><FONT size=3D2>DVB-S/DSS</FONT> <BR><FONT =
size=3D2>Feb&nbsp; 8 =0A=
15:53:45 f864office kernel: stb0899_search: set DVB-S params</FONT> =
<BR><FONT =0A=
size=3D2>Feb&nbsp; 8 15:53:45 f864office kernel: stb0899_search: =
delivery =0A=
system=3D1</FONT> <BR><FONT size=3D2>Feb&nbsp; 8 15:53:45 f864office =
kernel: =0A=
stb0899_search: Frequency=3D0, Srate=3D0</FONT> <BR><FONT =
size=3D2>Feb&nbsp; 8 =0A=
15:53:45 f864office kernel: stb0899_read_status: Delivery system</FONT> =0A=
<BR><FONT size=3D2>DVB-S/DSS</FONT> <BR><FONT size=3D2>Feb&nbsp; 8 =
15:53:45 =0A=
f864office kernel: stb0899_read_status: Delivery system</FONT> <BR><FONT =0A=
size=3D2>DVB-S/DSS</FONT> <BR><FONT size=3D2>Feb&nbsp; 8 15:53:45 =
f864office kernel: =0A=
_stb0899_read_reg: Reg=3D[0xf50d],</FONT> <BR><FONT =
size=3D2>data=3D00</FONT> =0A=
<BR><FONT size=3D2>Feb&nbsp; 8 15:53:46 f864office kernel: =
_stb0899_read_reg: =0A=
Reg=3D[0xf12a],</FONT> <BR><FONT size=3D2>data=3Dc8</FONT> <BR><FONT =
size=3D2>Feb&nbsp; =0A=
8 15:53:46 f864office kernel: stb0899_sleep: Going to Sleep ..</FONT> =
<BR><FONT =0A=
size=3D2>(Really tired .. :-))</FONT> </P>=0A=
<P><FONT size=3D2>I cannot see anything wrong and so am stumped to =
proceed, any =0A=
help will</FONT> <BR><FONT size=3D2>be appreciated</FONT> </P>=0A=
<P><FONT size=3D2>Is there a howto on installing these driver so I can =
check if I =0A=
have</FONT> <BR><FONT size=3D2>done everything correctly?</FONT> </P>=0A=
<P><FONT size=3D2>Regards</FONT> </P><BR>=0A=
<P><FONT size=3D2>Mike </FONT></P>=0A=
<P><FONT size=3D2>_______________________________________________</FONT> =
<BR><FONT =0A=
size=3D2>linux-dvb mailing list</FONT> <BR><FONT =0A=
size=3D2>linux-dvb@linuxtv.org</FONT> <BR><FONT size=3D2><A =0A=
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http:/=
/www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</A></FONT> =0A=
</P>=0A=
<P><FONT size=3D2>-- </FONT><BR><FONT size=3D2>This message has been =
scanned for =0A=
viruses and</FONT> <BR><FONT size=3D2>dangerous content by =
IC-MailScanner, and =0A=
is</FONT> <BR><FONT size=3D2>believed to be clean.</FONT> </P>=0A=
<P><FONT size=3D2>For queries or information please contact:-</FONT> </P>=0A=
<P><FONT =
size=3D2>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</FONT> <BR><FONT =0A=
size=3D2>Internet Central Technical Support</FONT> </P><BR>=0A=
<P><FONT size=3D2>&nbsp;<A =0A=
href=3D"http://www.netcentral.co.uk">http://www.netcentral.co.uk</A></FON=
T> =0A=
<BR><FONT =
size=3D2>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D</FONT> </P><BR>=0A=
<P><FONT size=3D2>No virus found in this incoming message.<BR>Checked by =
AVG Free =0A=
Edition.<BR>Version: 7.5.516 / Virus Database: 269.20.2/1270 - Release =
Date: =0A=
10/02/2008 12:21<BR></FONT>&nbsp; </P></DIV>=0A=
=0A=
</BODY>=0A=
</HTML>
------_=_NextPart_001_01C86C99.8EDBE1DD--


--===============0966823752==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0966823752==--
