Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from [212.57.247.218] (helo=glcweb.co.uk)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <michael.curtis@glcweb.co.uk>) id 1JOylA-00019r-IR
	for linux-dvb@linuxtv.org; Tue, 12 Feb 2008 18:17:32 +0100
Content-class: urn:content-classes:message
MIME-Version: 1.0
Date: Tue, 12 Feb 2008 17:16:52 -0000
Message-ID: <A33C77E06C9E924F8E6D796CA3D635D1023970@w2k3sbs.glcdomain.local>
From: "Michael Curtis" <michael.curtis@glcweb.co.uk>
To: <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Has anyone got multiproto and TT3200 to work
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

Thank you David/Manu

This is just the kind of help I was hoping for

David, I did pretty much as you did, although after make and make install I=
 just rebooted and all the modules and /dev/dvb entries were created for me=
, so lsmod gives me all the modules you quote installed

Output from lsmod

Module                  Size  Used by
nls_utf8               10305  1 =

vfat                   19009  1 =

fat                    54513  1 vfat
rfcomm                 50537  0 =

l2cap                  36289  9 rfcomm
bluetooth              64453  4 rfcomm,l2cap
sunrpc                168009  1 =

cpufreq_ondemand       15569  1 =

loop                   23493  0 =

dm_multipath           24401  0 =

ipv6                  307273  18 =

osst                   57193  0 =

st                     43109  0 =

lnbp21                 10240  1 =

stb6100                15748  1 =

stb0899                41728  1 =

saa7134_dvb            24076  0 =

videobuf_dvb           13316  1 saa7134_dvb
tda1004x               23300  2 saa7134_dvb
sr_mod                 23397  1 =

cdrom                  40553  1 sr_mod
snd_hda_intel         361577  3 =

snd_seq_dummy          11461  0 =

snd_seq_oss            37313  0 =

snd_seq_midi_event     15041  1 snd_seq_oss
snd_seq                56673  5
snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_seq_device         15061  3 snd_seq_dummy,snd_seq_oss,snd_seq
snd_pcm_oss            45889  0 =

snd_mixer_oss          22721  1 snd_pcm_oss
snd_pcm                80201  2 snd_hda_intel,snd_pcm_oss
snd_timer              27721  2 snd_seq,snd_pcm
snd_page_alloc         16465  2 snd_hda_intel,snd_pcm
budget_ci              30980  0 =

budget_core            17668  1 budget_ci
saa7134               148572  1 saa7134_dvb
videodev               33664  1 saa7134
v4l1_compat            19460  1 videodev
compat_ioctl32         16128  1 saa7134
v4l2_common            26240  3 saa7134,videodev,compat_ioctl32
videobuf_dma_sg        19716  3 saa7134_dvb,videobuf_dvb,saa7134
videobuf_core          24196  3 videobuf_dvb,saa7134,videobuf_dma_sg
ir_kbd_i2c             16912  1 saa7134
snd_hwdep              16073  1 snd_hda_intel
dvb_core               89684  3 videobuf_dvb,budget_ci,budget_core
saa7146                23688  2 budget_ci,budget_core
ttpci_eeprom           10496  1 budget_core
firewire_ohci          25281  0 =

ir_common              41732  3 budget_ci,saa7134,ir_kbd_i2c
snd                    60137  15
snd_hda_intel,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_o
ss,snd_pcm,snd_timer,snd_hwdep
nvidia               8895940  24 =

firewire_core          46337  1 firewire_ohci
crc_itu_t              10433  1 firewire_core
aic7xxx               133501  0 =

scsi_transport_spi     32577  1 aic7xxx
parport_pc             35177  0 =

tveeprom               24848  1 saa7134
soundcore              15073  1 snd
sg                     40297  0 =

forcedeth              53321  0 =

parport                42317  1 parport_pc
pcspkr                 11329  0 =

button                 15969  0 =

pata_amd               20293  0 =

k8temp                 13377  0 =

hwmon                  11081  1 k8temp
i2c_nforce2            14017  0 =

usblp                  20801  0 =

i2c_core               28865  14
lnbp21,stb6100,stb0899,saa7134_dvb,tda1004x,budget_ci,budget_core,saa713
4,v4l2_common,ir_kbd_i2c,ttpci_eeprom,nvidia,tveeprom,i2c_nforce2
usb_storage            87681  2 =

dm_snapshot            23049  0 =

dm_zero                10433  0 =

dm_mirror              27200  0 =

dm_mod                 57905  9
dm_multipath,dm_snapshot,dm_zero,dm_mirror
ata_generic            14533  0 =

sata_nv                25285  2 =

libata                114288  3 pata_amd,ata_generic,sata_nv
sd_mod                 33345  5 =

scsi_mod              146553  9
osst,st,sr_mod,aic7xxx,scsi_transport_spi,sg,usb_storage,libata,sd_mod
ext3                  127569  2 =

jbd                    64945  1 ext3
mbcache                15937  1 ext3
uhci_hcd               30689  0 =

ohci_hcd               27973  0 =

ehci_hcd               39245  0

dmesg gives me (refs to saa7130 are off a Compro DVB-T card)

Feb  8 15:36:14 f864office kernel: ACPI: PCI Interrupt 0000:01:07.0[A]
-> Link [APC2] -> GSI 17 (level, low) -> IRQ 17
Feb  8 15:36:14 f864office kernel: saa7146: found saa7146 @ mem ffffc20000a=
be000 (revision 1, irq 17) (0x13c2,0x1019).
Feb  8 15:36:14 f864office kernel: saa7146 (0): dma buffer size 192512 Feb =
 8 15:36:14 f864office kernel: DVB: registering new adapter (TT-Budget S2-3=
200 PCI) Feb  8 15:36:14 f864office kernel: adapter has MAC addr =3D
00:d0:5c:61:77:b3
Feb  8 15:36:14 f864office kernel: input: Budget-CI dvb ir receiver
saa7146 (0) as /class/input/input7
Feb  8 15:36:14 f864office kernel: budget_ci: CI interface initialised Feb =
 8 15:36:14 f864office kernel: DVB: registering new adapter
(saa7130[0])
Feb  8 15:36:14 f864office kernel: DVB: registering frontend 1 (Philips TDA=
10046H DVB-T)...
Feb  8 15:36:14 f864office kernel: tda1004x: setting up plls for 53MHz samp=
ling clock Feb  8 15:36:14 f864office kernel: _stb0899_read_reg: Reg=3D[0xf=
000],
data=3D82
Feb  8 15:36:14 f864office kernel: stb0899_get_dev_id: ID reg=3D[0x82] Feb =
 8 15:36:14 f864office kernel: stb0899_get_dev_id: Device ID=3D[8], Release=
=3D[2] Feb  8 15:36:14 f864office kernel: stb0899_get_dev_id: Demodulator C=
ore ID=3D[DMD1], Version=3D[1] Feb  8 15:36:14 f864office kernel: stb0899_g=
et_dev_id: FEC Core ID=3D[FEC1], Version=3D[1] Feb  8 15:36:14 f864office k=
ernel: stb0899_attach: Attaching STB0899 Feb  8 15:36:14 f864office kernel:=
 stb6100_attach: Attaching STB6100 Feb  8 15:36:14 f864office kernel: DVB: =
registering frontend 0 (STB0899 Multistandard)...

Interestingly no errors re card!!

Trying the hacked szap, I get

[mythtv@f864office Manu szap]$ ./szap -c ~/channels.sat2 -n 1424 reading ch=
annels from file '/home/mythtv/channels.sat2'
zapping to 1424 'BBC 1 London;BSkyB':
sat 0, frequency =3D 10773 MHz H, symbolrate 22000000, vpid =3D 0x1388, api=
d =3D 0x1389 sid =3D 0x138b Querying info .. Delivery system=3DDVB-S using =
'/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
----------------------------------> Using 'STB0899 DVB-S' DVB-Sstatus 00
| signal 0000 | snr 0004 | ber 00000000 | unc fffffffe |
status 00 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe | status 0=
0 | signal 0000 | snr 0004 | ber 00000000 | unc fffffffe | status 00 | sign=
al 0000 | snr 0004 | ber 00000000 | unc fffffffe | status 00 | signal 0000 =
| snr 0004 | ber 00000000 | unc fffffffe | status 00 | signal 0000 | snr 00=
04 | ber 00000000 | unc fffffffe | status 00 | signal 0000 | snr 0004 | ber=
 00000000 | unc fffffffe |


and this results in dmesg reporting

Feb  8 15:53:44 f864office kernel: stb0899_search: delivery system=3D1 Feb =
 8 15:53:44 f864office kernel: stb0899_search: Frequency=3D0, Srate=3D0 Feb=
  8 15:53:44 f864office kernel: stb0899_read_status: Delivery system DVB-S/=
DSS Feb  8 15:53:44 f864office kernel: stb0899_search: set DVB-S params Feb=
  8 15:53:44 f864office kernel: stb0899_search: delivery system=3D1 Feb  8 =
15:53:44 f864office kernel: stb0899_search: Frequency=3D0, Srate=3D0 Feb  8=
 15:53:44 f864office kernel: stb0899_read_status: Delivery system DVB-S/DSS=
 Feb  8 15:53:44 f864office kernel: stb0899_read_status: Delivery system DV=
B-S/DSS Feb  8 15:53:44 f864office kernel: _stb0899_read_reg: Reg=3D[0xf50d=
], data=3D00 Feb  8 15:53:45 f864office kernel: stb0899_search: set DVB-S p=
arams

The most interesting parts are

15:53:44 f864office kernel: stb0899_search: Frequency=3D0, Srate=3D0

Which indicates to me that the tuning parameters are not being passed to th=
e frontend

But where to go from here????

Manu can you post your dmesg re the stb0899 after a successful channel lock?


Regards

Mike Curtis

Hi,

Le Mon, 11 Feb 2008 20:27:24 -0000,
"Michael Curtis" <michael.curtis@glcweb.co.uk> a =E9crit :
> If so please let me know because I am having serious issues and really
> do not know how to proceed

I'm probably more beginner than you, but, if I can help...

So, I've wrote a little documentation for me (including errors) :
DRIVER
# mkdir /opt/dvb
# cd /opt/dvb
# apt-get install mercurial
# hg clone http://jusst.de/hg/multiproto
# cd multiproto
# make
# make install
# modprobe stb6100
# modprobe stb0899
# modprobe lnbp21
# modprobe budget-ci

MAJ DU DRIVER
# modprobe -r budget-ci
# modprobe -r lnbp21
# modprobe -r stb0899
# modprobe -r stb6100
# cd /opt/dvb/multiproto
# hg pull -u http://jusst.de/hg/multiproto
# make distclean
# make
# make install
# modprobe stb6100
# modprobe stb0899
# modprobe lnbp21
# modprobe budget-ci

DMESG
# dmesg
saa7146: register extension 'budget_ci dvb'.
ACPI: PCI Interrupt 0000:05:01.0[A] -> GSI 22 (level, low) -> IRQ 22
saa7146: found saa7146 @ mem ffffc20001598c00 (revision 1, irq 22)
(0x13c2,0x1019).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (TT-Budget S2-3200 PCI)
adapter has MAC addr =3D 00:d0:5c:0b:a5:8b
input: Budget-CI dvb ir receiver saa7146 (0) as /class/input/input9
budget_ci: CI interface initialised
stb0899_write_regs [0xf1b6]: 02
stb0899_write_regs [0xf1c2]: 00
stb0899_write_regs [0xf1c3]: 00
_stb0899_read_reg: Reg=3D[0xf000], data=3D81
stb0899_get_dev_id: ID reg=3D[0x81]
stb0899_get_dev_id: Device ID=3D[8], Release=3D[1]
_stb0899_read_s2reg Device=3D[0xf3fc], Base address=3D[0x00000400],
Offset=3D[0xf334], Data=3D[0x444d4431]
_stb0899_read_s2reg Device=3D[0xf3fc], Base address=3D[0x00000400],
Offset=3D[0xf33c], Data=3D[0x00000001] stb0899_get_dev_id: Demodulator Core
ID=3D[DMD1], Version=3D[1] _stb0899_read_s2reg Device=3D[0xfafc], Base
address=3D[0x00000800], Offset=3D[0xfa2c], Data=3D[0x46454331]
_stb0899_read_s2reg Device=3D[0xfafc], Base address=3D[0x00000800],
Offset=3D[0xfa34], Data=3D[0x00000001] stb0899_get_dev_id: FEC Core
ID=3D[FEC1], Version=3D[1] stb0899_attach: Attaching STB0899
stb6100_attach: Attaching STB6100 DVB: registering frontend 0 (STB0899
Multistandard)... dvb_ca adaptor 0: PC card did not respond :(

As you can see, I have one error left, and it seems to come from my CI
module. If you have a different method, may be we can exchange ;-)))

I'll try soon to scan...

Hope it helps !!!

Regards.

David.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
