Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fk-out-0910.google.com ([209.85.128.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <dschollmeyer@gmail.com>) id 1KYE0C-0002Db-6d
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 07:55:34 +0200
Received: by fk-out-0910.google.com with SMTP id f40so1672418fka.1
	for <linux-dvb@linuxtv.org>; Tue, 26 Aug 2008 22:55:28 -0700 (PDT)
Message-ID: <ed347ce40808262255s6bfc4f58ne2c8c00f56f95e44@mail.gmail.com>
Date: Tue, 26 Aug 2008 22:55:28 -0700
From: "David Schollmeyer" <dschollmeyer@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] HVR-1800 DVB Configuration
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

Hi,

I have the Hauppauge HVR-1800 that I am trying to get setup. I can get
the tuner to work on NTSC analog with my local cable provider (Cox
Communications - Phoenix, AZ). I am trying to get the ATSC/QAM tuner
to work with Cox as well. From what I've read, I should be able to get
all of the unencrypted DTV local channels from Cox but I cannot figure
out how to do so.

Following the steps at
http://www.linuxtv.org/wiki/index.php/Testing_your_DVB_device, I
created the following channels.conf file:
KASW-DT:537000000:QAM_256:33:36
KSAZ-DT:537000000:QAM_256:49:52
KNXV-DT:555000000:QAM_256:33:36
KPHO-DT:555000000:QAM_256:49:52
KAET-DT-1:567000000:QAM_256:33:34
KPNX-DT:567000000:QAM_256:49:52
KAET-DT-2:567000000:QAM_256:67:70

I've tried running azap 'KAET-DT-2' gives:

using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 567000000 Hz
video pid 0x0043, audio pid 0x0046
status 00 | signal 0000 | snr 0000 | ber 00000000 | unc 00000000 |
status 1f | signal 015e | snr 015e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 015e | snr 015e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 015e | snr 015e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 015e | snr 015e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
status 1f | signal 015e | snr 015e | ber 00000000 | unc 00000000 | FE_HAS_LOCK
...

I then try to run mplayer:
# mplayer /dev/dvb/adapter0/dvr0
MPlayer dev-SVN-r26936-4.3.0 (C) 2000-2008 MPlayer Team
CPU: Intel(R) Core(TM)2 Quad  CPU   Q9450  @ 2.66GHz (Family: 6,
Model: 23, Stepping: 6)
CPUflags:  MMX: 1 MMX2: 1 3DNow: 0 3DNow2: 0 SSE: 1 SSE2: 1
Compiled with runtime CPU detection.
mplayer: could not connect to socket
mplayer: No such file or directory

Playing /dev/dvb/adapter0/dvr0.

No window opens - it just sits there and nothing appears to be happening.

I've also tried cat /dev/dvb/adapter0/dvr0 > file.mpg but the
resulting file is always zero bytes.

I'm running Fedora Core 9 with kernel 2.6.25.14-108.fc9.x86_64. I
built the latest drivers this evening from mercurial.

Here's lsmod's output:
Module                  Size  Used by
udf                    80024  1
fuse                   51008  3
sunrpc                185000  3
ipt_REJECT             11776  2
xt_tcpudp              11648  1
nf_conntrack_ipv4      17416  2
xt_state               10752  2
nf_conntrack           64528  2 nf_conntrack_ipv4,xt_state
iptable_filter         11392  1
ip_tables              25232  1 iptable_filter
x_tables               26248  4 ipt_REJECT,xt_tcpudp,xt_state,ip_tables
cpufreq_ondemand       15760  4
acpi_cpufreq           16656  0
freq_table             13440  2 cpufreq_ondemand,acpi_cpufreq
dm_mirror              32004  0
dm_multipath           24976  0
dm_mod                 62104  2 dm_mirror,dm_multipath
ipv6                  276232  24
mt2131                 13956  1
s5h1409                17412  1
sr_mod                 23732  1
cdrom                  40616  1 sr_mod
cx23885                99836  1
compat_ioctl32         16512  1 cx23885
snd_hda_intel         457780  3
videodev               42496  3 cx23885,compat_ioctl32
v4l1_compat            21508  1 videodev
cx2341x                19588  1 cx23885
videobuf_dma_sg        20100  1 cx23885
v4l2_common            19712  2 cx23885,cx2341x
i915                  103812  2
snd_seq_dummy          11524  0
btcx_risc              12552  1 cx23885
snd_seq_oss            39232  0
tveeprom               21636  1 cx23885
snd_seq_midi_event     15104  1 snd_seq_oss
snd_seq                61840  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
videobuf_dvb           13444  1 cx23885
snd_seq_device         15508  3 snd_seq_dummy,snd_seq_oss,snd_seq
dvb_core               84644  1 videobuf_dvb
firewire_ohci          29316  0
snd_pcm_oss            52096  0
firewire_core          44480  1 firewire_ohci
snd_mixer_oss          23296  1 snd_pcm_oss
iTCO_wdt               19920  0
iTCO_vendor_support    11780  1 iTCO_wdt
sg                     40528  0
i2c_i801               17692  0
crc_itu_t              10368  1 firewire_core
serio_raw              14084  0
pcspkr                 11136  0
drm                   187280  3 i915
snd_pcm                86024  2 snd_hda_intel,snd_pcm_oss
pata_marvell           13696  1
videobuf_core          25092  3 cx23885,videobuf_dma_sg,videobuf_dvb
snd_timer              29584  2 snd_seq,snd_pcm
e1000e                100516  0
i2c_algo_bit           14212  1 i915
ata_generic            14852  0
snd_page_alloc         16912  2 snd_hda_intel,snd_pcm
snd_hwdep              16520  1 snd_hda_intel
pata_acpi              13952  0
lirc_imon              23300  0
button                 15776  0
snd                    66808  16
snd_hda_intel,snd_seq_dummy,snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_timer,snd_hwdep
i2c_core               28448  9
mt2131,s5h1409,cx23885,v4l2_common,i915,tveeprom,i2c_i801,drm,i2c_algo_bit
lirc_dev               21208  1 lirc_imon
soundcore              14864  1 snd
ahci                   35976  3
libata                149664  4 pata_marvell,ata_generic,pata_acpi,ahci
sd_mod                 33200  4
scsi_mod              150360  4 sr_mod,sg,libata,sd_mod
ext3                  129808  2
jbd                    53032  1 ext3
mbcache                15876  1 ext3
uhci_hcd               29984  0
ohci_hcd               29060  0
ehci_hcd               40460  0

Here's the kernel messages during boot for the HVR-1800:
CORE cx23885[0]: subsystem: 0070:7801, board: Hauppauge WinTV-HVR1800
[card=2,autodetected]
cx23885[0]: i2c bus 0 registered
cx23885[0]: i2c bus 1 registered
cx23885[0]: i2c bus 2 registered
tveeprom 1-0050: Hauppauge model 78521, rev C1E9, serial# 4864366
tveeprom 1-0050: MAC address is 00-0D-FE-4A-39-6E
tveeprom 1-0050: tuner model is Philips 18271_8295 (idx 149, type 54)
tveeprom 1-0050: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
tveeprom 1-0050: audio processor is CX23887 (idx 42)
tveeprom 1-0050: decoder processor is CX23887 (idx 37)
tveeprom 1-0050: has radio
cx23885[0]: hauppauge eeprom: model=78521
cx25840' 3-0044: cx25  0-21 found @ 0x88 (cx23885[0])
cx23885[0]/0: registered device video0 [v4l2]
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 125x/94x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 6:0:0:0: Attached scsi CD-ROM sr0
firewire_core: created device fw0: GUID 0090270002053bda, S400
cx25840' 3-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)
cx23885[0]: registered device video1 [mpeg]
cx23885[0]: cx23885 based dvb card
MT2131: successfully identified at address 0x61
DVB: registering new adapter (cx23885[0])
DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx23885_dev_checkrevision() Hardware revision = 0xb1
cx23885[0]/0: found at 0000:02:00.0, rev: 15, irq: 17, latency: 0,
mmio: 0xe0000000

Any help on what may be wrong would be appreciated.

Thanks,
David Schollmeyer

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
