Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]
	helo=shogun.pilppa.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lamikr@pilppa.org>) id 1K6C1l-0006tL-BL
	for linux-dvb@linuxtv.org; Wed, 11 Jun 2008 00:09:20 +0200
Message-ID: <484EFB7B.7020505@pilppa.org>
Date: Wed, 11 Jun 2008 01:08:59 +0300
From: Mika Laitio <lamikr@pilppa.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] HVR-1300 problems with new kernels
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

Hi

Is HVR-1300 DVB-T tuner working for somebody with official new kernels 
like 2.6.24, 2.6.25 or 2.6.26-rcx?
I am having problems with all of those in my Mandriva 2008.1 (X86-64 
version with AMD 780G) with it.
To get the card to working I need to build and load the V4L-DVB drivers 
with following sequence:

- build & install kernel
- rm /lib/modules<kernel>/kernel/drivers/media/video/cx88 (rmmod 
complained that somebody was using these drivers, so I removed the dir 
to prevent them got loaded)
- reboot
- hg-clone, make make unload & make load

I first tried with Mandrivas 2.6.24 kernel but needed to patch that to 
include cx88-radio gpio configuration as I had same error
message that was mentioned in ubuntu bugzilla. 
(https://bugs.launchpad.net/ubuntu/+source/linux/+bug/209971) This fix 
seems to be in official 2.6.25 kernels applied.

After that patch the DVB drivers seemed to load ok and I got files 
created under /dev/dvb/adapter0
Kaffeine is however complaining that it could not detect DVB card.
(And error goes away if I load DVB-V4L version from the drivers)

After that I have tried with own build 2.6.25.4 and 2.6.26-rc4 kernels 
and get always same result.
--> /dev/dvb/adapter0 is created but Kaffeine can find the DVB card only 
if I build and load the V4L-DVB drivers.

Is somebody else been able to test the HVR-1300 for example with the 
official 2.6.25.4 kernel to find out whether the
problem is in newest kernels, in X86-64 or somehow in Mandrivas boot & 
driver loading system?
In addition is there any info which modules I could load (and with which 
parameters) if I want to just load the needed V4L-DVB drivers for HVR-1300.
(as "make load" script loads also lot of un-required drivers)

Below is some info from my system when HVR-1300 is not working.

Mika

[lamikr@tinka ~]$ uname -a
Linux tinka 2.6.24.4-desktop-1mnb #1 SMP Thu Mar 27 14:33:51 CET 2008 
x86_64 AMD Athlon(tm) Dual Core Processor 4850e GNU/Linux

[lamikr@tinka ~]$ ls -la /dev/dvb/adapter0/
total 0
drwxr-xr-x  2 root   root     120 2008-06-11 00:53 ./
drwxr-xr-x  3 root   root      60 2008-06-11 00:53 ../
crw-rw----+ 1 lamikr video 212, 4 2008-06-11 00:53 demux0
crw-rw----+ 1 lamikr video 212, 5 2008-06-11 00:53 dvr0
crw-rw----+ 1 lamikr video 212, 3 2008-06-11 00:53 frontend0
crw-rw----+ 1 lamikr video 212, 7 2008-06-11 00:53 net0

[lamikr@tinka ~]$ dmesg | grep DVB
cx88[0]: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 
DVB-T/Hybrid MPEG Encoder [card=56,autodetected]
tveeprom 1-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) 
ATSC/DVB Digital (eeprom 0xf4)
cx88[0]/2: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 
DVB-T/Hybrid MPEG Encoder [card=56]
cx88[0]/2: cx2388x based DVB/ATSC card
DVB: registering new adapter (cx88[0])
DVB: registering frontend 0 (Conexant CX22702 DVB-T)...
cx88[0]/2: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 
DVB-T/Hybrid MPEG Encoder [card=56]

[lamikr@tinka ~]$ dmesg | grep cx88
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
cx88[0]: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 
DVB-T/Hybrid MPEG Encoder [card=56,autodetected]
cx88[0]: TV tuner type 63, Radio tuner type -1
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88[0]: hauppauge eeprom: model=96019
cx88[0]/0: found at 0000:03:06.0, rev: 5, irq: 20, latency: 32, mmio: 
0xfa000000
tuner 1-0043: chip found @ 0x86 (cx88[0])
tuner 1-0061: chip found @ 0xc2 (cx88[0])
tuner 1-0063: chip found @ 0xc6 (cx88[0])
wm8775 1-001b: chip found @ 0x36 (cx88[0])
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
cx88[0]/2: cx2388x 8802 Driver Manager
cx88[0]/2: found at 0000:03:06.2, rev: 5, irq: 20, latency: 32, mmio: 
0xfb000000
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 
DVB-T/Hybrid MPEG Encoder [card=56]
cx88[0]/2: cx2388x based DVB/ATSC card
DVB: registering new adapter (cx88[0])
cx88/2: registering cx8802 driver, type: blackbird access: shared
cx88[0]/2: subsystem: 0070:9601, board: Hauppauge WinTV-HVR1300 
DVB-T/Hybrid MPEG Encoder [card=56]
cx88[0]/2: cx23416 based mpeg encoder (blackbird reference design)
cx88[0]/2: registered device video1 [mpeg]
cx88[0]/2-bb: Firmware and/or mailbox pointer not initialized or corrupted
cx88[0]/2-bb: ERROR: Hotplug firmware request failed (v4l-cx2341x-enc.fw).
cx88[0]/2-bb: Please fix your hotplug setup, the board will not work 
without firmware loaded!

(If I understood correctly this firmware load error comes from the 
analog tuner?)

[lamikr@shogun ~]$ cat lsmod_with_hvr1300_nonworking.txt
Module                  Size  Used by
joydev                 15616  0
usbmouse                9088  0
usbkbd                 10624  0
usbhid                 50400  2 usbmouse,usbkbd
ff_memless              9608  1 usbhid
ipt_IFWLOG              7816  3
ipt_psd                52368  1
ip_set_iptree          11408  2
iptable_raw             6400  0
xt_comment              6144  0
xt_policy               8192  0
ipt_ULOG               14344  0
ipt_TTL                 6400  0
ipt_ttl                 6144  0
ipt_TOS                 6400  0
ipt_tos                 5888  0
ipt_set                 6528  2
ipt_SAME                6656  0
ipt_REJECT              8320  4
ipt_REDIRECT            6528  0
ipt_recent             13216  0
ipt_owner               6272  0
ipt_NETMAP              6528  0
ipt_MASQUERADE          7936  0
ipt_LOG                10496  9
ipt_iprange             6016  0
ipt_ECN                 7040  0
ipt_ecn                 6400  0
ipt_CLUSTERIP          11912  0
ipt_ah                  6144  0
ipt_addrtype            6144  4
nf_nat_tftp             6016  0
nf_nat_snmp_basic      14596  0
nf_nat_sip              8704  0
nf_nat_pptp             7424  0
nf_nat_proto_gre        6916  1 nf_nat_pptp
nf_nat_irc              6784  0
nf_nat_h323            11520  0
nf_nat_ftp              7680  0
nf_nat_amanda           6400  0
ts_kmp                  6400  5
nf_conntrack_amanda     8704  1 nf_nat_amanda
nf_conntrack_tftp       9364  1 nf_nat_tftp
nf_conntrack_sip       13460  1 nf_nat_sip
nf_conntrack_proto_sctp    13324  0
nf_conntrack_pptp      10496  1 nf_nat_pptp
nf_conntrack_proto_gre     9344  1 nf_conntrack_pptp
nf_conntrack_netlink    31360  0
nf_conntrack_netbios_ns     7040  0
nf_conntrack_irc       10400  1 nf_nat_irc
nf_conntrack_h323      58976  1 nf_nat_h323
nf_conntrack_ftp       12712  1 nf_nat_ftp
ip_set_portmap          8832  0
ip_set_macipmap         8712  0
ip_set_ipmap            8576  0
ip_set_iphash          11912  0
ip_set                 23340  11 
ip_set_iptree,ipt_set,ip_set_portmap,ip_set_macipmap,ip_set_ipmap,ip_set_iphash
xt_tcpmss               6528  0
xt_pkttype              6272  0
xt_physdev              6928  0
xt_NFQUEUE              6272  0
xt_NFLOG                6400  0
xt_multiport            7680  4
xt_MARK                 6912  0
xt_mark                 6528  0
xt_mac                  6272  0
xt_limit                7168  0
xt_length               6272  0
xt_helper               6784  0
xt_hashlimit           13720  0
ip6_tables             18248  1 xt_hashlimit
xt_DSCP                 6656  0
xt_dscp                 6400  0
xt_dccp                 7432  0
rfcomm                 43040  2
xt_conntrack            7680  0
xt_CONNMARK             7424  0
l2cap                  27136  9 rfcomm
xt_connmark             6912  0
xt_CLASSIFY             6144  0
xt_tcpudp               7680  13
bluetooth              60068  4 rfcomm,l2cap
xt_state                6656  13
iptable_nat            11780  0
nf_nat                 23212  14 
ipt_SAME,ipt_REDIRECT,ipt_NETMAP,ipt_MASQUERADE,nf_nat_tftp,nf_nat_sip,nf_nat_pptp,nf_nat_proto_gre,nf_nat_irc,nf_nat_h323,nf_nat_ftp,nf_nat_amanda,nf_conntrack_netlink,iptable_nat
nf_conntrack_ipv4      20752  15 iptable_nat
nf_conntrack           69616  29 
ipt_MASQUERADE,ipt_CLUSTERIP,nf_nat_tftp,nf_nat_snmp_basic,nf_nat_sip,nf_nat_pptp,nf_nat_irc,nf_nat_h323,nf_nat_ftp,nf_nat_amanda,nf_conntrack_amanda,nf_conntrack_tftp,nf_conntrack_sip,nf_conntrack_proto_sctp,nf_conntrack_pptp,nf_conntrack_proto_gre,nf_conntrack_netlink,nf_conntrack_netbios_ns,nf_conntrack_irc,nf_conntrack_h323,nf_conntrack_ftp,xt_helper,xt_conntrack,xt_CONNMARK,xt_connmark,xt_state,iptable_nat,nf_nat,nf_conntrack_ipv4
iptable_mangle          6912  1
nfnetlink               8392  1 nf_conntrack_netlink
iptable_filter          7040  1
ip_tables              23784  4 
iptable_raw,iptable_nat,iptable_mangle,iptable_filter
x_tables               20744  49 
ipt_IFWLOG,ipt_psd,xt_comment,xt_policy,ipt_ULOG,ipt_TTL,ipt_ttl,ipt_TOS,ipt_tos,ipt_set,ipt_SAME,ipt_REJECT,ipt_REDIRECT,ipt_recent,ipt_owner,ipt_NETMAP,ipt_MASQUERADE,ipt_LOG,ipt_iprange,ipt_ECN,ipt_ecn,ipt_CLUSTERIP,ipt_ah,ipt_addrtype,xt_tcpmss,xt_pkttype,xt_physdev,xt_NFQUEUE,xt_NFLOG,xt_multiport,xt_MARK,xt_mark,xt_mac,xt_limit,xt_length,xt_helper,xt_hashlimit,ip6_tables,xt_DSCP,xt_dscp,xt_dccp,xt_conntrack,xt_CONNMARK,xt_connmark,xt_CLASSIFY,xt_tcpudp,xt_state,iptable_nat,ip_tables
fuse                   51504  1
af_packet              23944  2
snd_seq_dummy           7556  0
snd_seq_oss            36736  0
snd_seq_midi_event     11520  1 snd_seq_oss
snd_seq                59264  5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event
snd_seq_device         11412  3 snd_seq_dummy,snd_seq_oss,snd_seq
ipv6                  290600  23 nf_conntrack_h323
snd_pcm_oss            45728  0
snd_mixer_oss          20608  1 snd_pcm_oss
binfmt_misc            14476  1
loop                   20100  0
dm_mod                 62840  0
floppy                 66216  0
cpufreq_ondemand       12176  1
cpufreq_conservative    12040  0
cpufreq_powersave       6016  0
powernow_k8            17824  1
freq_table              8448  2 cpufreq_ondemand,powernow_k8
cx88_blackbird         22660  0
cx2341x                16132  1 cx88_blackbird
cx88_dvb               15364  2
cx88_vp3054_i2c         7168  1 cx88_dvb
mt352                  11268  1 cx88_dvb
dvb_pll                17828  1 cx88_dvb
or51132                13188  1 cx88_dvb
videobuf_dvb            9604  1 cx88_dvb
nxt200x                18308  1 cx88_dvb
isl6421                 6400  1 cx88_dvb
zl10353                10632  1 cx88_dvb
cx24123                17544  1 cx88_dvb
lgdt330x               13444  1 cx88_dvb
dvb_core               87468  3 or51132,videobuf_dvb,lgdt330x
cx22702                10756  1 cx88_dvb
wm8775                 10124  0
tuner                  49952  0
tea5767                 9988  1 tuner
tda8290                15876  1 tuner
tuner_simple           12680  1 tuner
mt20xx                 16776  1 tuner
tea5761                 9220  1 tuner
cx88_alsa              16392  1
cx8802                 20868  2 cx88_blackbird,cx88_dvb
cx8800                 38924  1 cx88_blackbird
cx88xx                 68008  5 
cx88_blackbird,cx88_dvb,cx88_alsa,cx8802,cx8800
ir_common              36996  1 cx88xx
i2c_algo_bit           10500  2 cx88_vp3054_i2c,cx88xx
tveeprom               22160  1 cx88xx
videodev               31104  3 cx88_blackbird,cx8800,cx88xx
compat_ioctl32         13184  1 cx8800
v4l2_common            22400  8 
cx88_blackbird,cx2341x,wm8775,tuner,cx8800,cx88xx,videodev,compat_ioctl32
snd_hda_intel         444248  3
parport_pc             39208  0
pcspkr                  7168  0
rtc_cmos               11960  0
parport                40716  1 parport_pc
serio_raw              10372  0
k8temp                  9472  0
v4l1_compat            17668  1 videodev
i2c_piix4              12556  0
videobuf_dma_sg        16772  7 
cx88_blackbird,cx88_dvb,videobuf_dvb,cx88_alsa,cx8802,cx8800,cx88xx
ohci1394               34996  0
videobuf_core          21380  6 
cx88_blackbird,videobuf_dvb,cx8802,cx8800,cx88xx,videobuf_dma_sg
ide_cd                 43552  0
snd_pcm                82824  3 snd_pcm_oss,cx88_alsa,snd_hda_intel
btcx_risc               8712  4 cx88_alsa,cx8802,cx8800,cx88xx
i2c_core               25600  21 
cx88_vp3054_i2c,mt352,dvb_pll,or51132,nxt200x,isl6421,zl10353,cx24123,lgdt330x,cx22702,wm8775,tuner,tea5767,tda8290,tuner_simple,mt20xx,tea5761,cx88xx,i2c_algo_bit,tveeprom,i2c_piix4
ieee1394               94552  1 ohci1394
snd_timer              26120  2 snd_seq,snd_pcm
snd_page_alloc         12816  2 snd_hda_intel,snd_pcm
snd_hwdep              12552  1 snd_hda_intel
snd                    60744  18 
snd_seq_oss,snd_seq,snd_seq_device,snd_pcm_oss,snd_mixer_oss,cx88_alsa,snd_hda_intel,snd_pcm,snd_timer,snd_hwdep
soundcore              11296  1 snd
button                 11808  0
thermal                19616  0
tc1100_wmi             11016  0
wmi_acer               11972  0
processor              37832  2 powernow_k8,thermal
shpchp                 36764  0
pci_hotplug            32816  1 shpchp
r8169                  33668  0
evdev                  14976  4
sg                     39192  0
ide_disk               18816  0
atiixp                  8848  0 [permanent]
ide_core              123544  3 ide_cd,ide_disk,atiixp
ata_piix               22788  0
ahci                   31492  2
libata                155696  2 ata_piix,ahci
sd_mod                 31872  3
scsi_mod              157368  3 sg,libata,sd_mod
ext3                  136848  1
jbd                    51496  1 ext3
uhci_hcd               28960  0
ohci_hcd               27140  0
ehci_hcd               39948  0
usbcore               145328  7 
usbmouse,usbkbd,usbhid,uhci_hcd,ohci_hcd,ehci_hcd



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
