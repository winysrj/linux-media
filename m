Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bis.amsnet.pl ([195.64.174.7] helo=host.amsnet.pl ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gasiu@konto.pl>) id 1JcUlT-00051T-7J
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 01:05:44 +0100
Received: from dxa99.neoplus.adsl.tpnet.pl ([83.22.86.99] helo=[192.168.1.3])
	by host.amsnet.pl with esmtpa (Exim 4.67)
	(envelope-from <gasiu@konto.pl>) id 1JcUoO-00033a-VO
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 01:08:45 +0100
Message-ID: <47E2FBD2.2080305@konto.pl>
Date: Fri, 21 Mar 2008 01:05:38 +0100
From: Gasiu <gasiu@konto.pl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Multiproto szap lock, but video file is empty
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

i've got SkystarHD, Ubuntu64 and multiproto-ecb96c96a69e - after 
patching szap.c

I can szap a channel:

 ./szap polsat2

reading channels from file '/home/gasiu/.szap/channels.conf'
zapping to 4 'polsat2':
sat 0, frequency = 11158 MHz V, symbolrate 27500000, vpid = 0x0111, apid 
= 0x0112 sid = 0x332e
Querying info .. Delivery system=DVB-S
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
----------------------------------> Using 'STB0899 DVB-S' DVB-S
do_tune: API version=3, delivery system = 0
do_tune: Frequency = 1408000, Srate = 27500000
do_tune: Frequency = 1408000, Srate = 27500000


status 1e | signal 0172 | snr 0062 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
status 1e | signal 0172 | snr 0059 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK
status 1e | signal 0172 | snr 0059 | ber 00000000 | unc fffffffe | 
FE_HAS_LOCK

but when I type in second window:

cat /dev/dvb/adapter0/dvr0 > /home/gasiu/Desktop/test.mpg

I've got an empty file... ?? what is wrong?

after szap dmesg shows:

[ 1256.033588] dvb_frontend_ioctl: DVBFE_GET_INFO
[ 1256.033592] stb0899_get_info: Querying DVB-S info
[ 1256.093351] newfec_to_oldfec: Unsupported FEC 9
[ 1256.093354] dvb_frontend_ioctl: FESTATE_RETUNE: fepriv->state=2
[ 1256.093358] stb0899_search: set DVB-S params
[ 1256.098648] stb6100_set_bandwidth: Bandwidth=61262500
[ 1256.098811] stb6100_get_bandwidth: Bandwidth=62000000
[ 1256.100025] stb6100_get_bandwidth: Bandwidth=62000000
[ 1256.117227] stb6100_set_frequency: Frequency=1408000
[ 1256.117391] stb6100_get_frequency: Frequency=1408007
[ 1256.120049] stb6100_get_bandwidth: Bandwidth=62000000



lsmod
Module                  Size  Used by
snd_rtctimer            5216  1
binfmt_misc            14860  1
ipv6                  317192  14
ppdev                  11272  0
powernow_k8            16608  1
cpufreq_userspace       6048  0
cpufreq_conservative     9608  0
cpufreq_ondemand       10896  1
cpufreq_stats           8160  0
freq_table              6464  3 powernow_k8,cpufreq_ondemand,cpufreq_stats
cpufreq_powersave       3072  0
ac                      7304  0
sbs                    21520  0
dock                   12264  0
button                 10400  0
video                  21140  0
container               6400  0
battery                12424  0
af_packet              28172  2
sbp2                   27144  0
lp                     15048  0
snd_emu10k1_synth       9344  0
snd_emux_synth         40064  1 snd_emu10k1_synth
snd_seq_virmidi         9216  1 snd_emux_synth
snd_seq_midi_emul       9088  1 snd_emux_synth
lnbp21                  3712  1
stb6100                 9732  1
stb0899                38656  1
snd_emu10k1           152864  2 snd_emu10k1_synth
snd_ac97_codec        122200  1 snd_emu10k1
ac97_bus                4096  1 snd_ac97_codec
snd_util_mem            6656  2 snd_emux_synth,snd_emu10k1
snd_hwdep              12168  2 snd_emux_synth,snd_emu10k1
snd_pcm_oss            50048  0
snd_pcm                94344  3 snd_emu10k1,snd_ac97_codec,snd_pcm_oss
snd_page_alloc         12560  2 snd_emu10k1,snd_pcm
snd_mixer_oss          20096  1 snd_pcm_oss
snd_seq_dummy           5380  0
snd_seq_oss            36864  0
snd_seq_midi           11008  0
snd_rawmidi            29824  3 snd_seq_virmidi,snd_emu10k1,snd_seq_midi
snd_seq_midi_event      9984  3 snd_seq_virmidi,snd_seq_oss,snd_seq_midi
snd_seq                62496  10 
snd_emux_synth,snd_seq_virmidi,snd_seq_midi_emul,snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event
snd_timer              27272  4 snd_rtctimer,snd_emu10k1,snd_pcm,snd_seq
snd_seq_device         10260  8 
snd_emu10k1_synth,snd_emux_synth,snd_emu10k1,snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
usblp                  16896  0
budget_ci              28676  0
budget_core            14468  1 budget_ci
dvb_core              102612  2 budget_ci,budget_core
saa7146                22152  2 budget_ci,budget_core
ttpci_eeprom            3840  1 budget_core
nvidia               7013492  24
serio_raw               9092  0
ir_common              41220  1 budget_ci
snd                    69288  16 
snd_emux_synth,snd_seq_virmidi,snd_emu10k1,snd_ac97_codec,snd_hwdep,snd_pcm_oss,snd_pcm,snd_mixer_oss,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
parport_pc             41896  1
parport                44172  3 ppdev,lp,parport_pc
acx                   106756  0
i2c_nforce2             7808  0
soundcore              10272  1 snd
psmouse                45596  0
emu10k1_gp              5632  0
gameport               18704  2 emu10k1_gp
pcspkr                  4608  0
i2c_core               30208  8 
lnbp21,stb6100,stb0899,budget_ci,budget_core,ttpci_eeprom,nvidia,i2c_nforce2
k8temp                  7680  0
shpchp                 38300  0
pci_hotplug            36612  1 shpchp
evdev                  13056  4
ext3                  146576  2
jbd                    69360  1 ext3
mbcache                11272  1 ext3
sg                     41384  0
usbhid                 32576  0
hid                    33408  1 usbhid
sd_mod                 32512  5
ide_cd                 35488  0
cdrom                  41768  1 ide_cd
ata_generic             9988  0
ehci_hcd               40076  0
sata_nv                24068  4
amd74xx                17328  0 [permanent]
ide_core              141200  2 ide_cd,amd74xx
ohci1394               38984  0
ieee1394              109528  2 sbp2,ohci1394
ohci_hcd               25092  0
usbcore               161584  6 usblp,acx,usbhid,ehci_hcd,ohci_hcd
libata                138928  2 ata_generic,sata_nv
scsi_mod              172856  4 sbp2,sg,sd_mod,libata
forcedeth              55048  0
thermal                16528  0
processor              36232  2 powernow_k8,thermal
fan                     6920  0
fuse                   52528  3
apparmor               47008  0
commoncap               9472  1 apparmor







-- 
Pozdrawiam!
Gasiu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
