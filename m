Return-path: <linux-media-owner@vger.kernel.org>
Received: from eterpe-smout.broadpark.no ([80.202.8.16]:43185 "EHLO
	eterpe-smout.broadpark.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2LPVlI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Dec 2012 16:41:08 -0500
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Received: from ignis-smin.broadpark.no ([80.202.8.11])
 by eterpe-smout.broadpark.no
 (Oracle Communications Messaging Server 7u4-27.01(7.0.4.27.0) 64bit (built Aug
 30 2012)) with ESMTP id <0MF5009CG5FGLM20@eterpe-smout.broadpark.no> for
 linux-media@vger.kernel.org; Sun, 16 Dec 2012 21:40:28 +0100 (CET)
Received: from alstadheim.priv.no ([178.164.66.9]) by ignis-smin.broadpark.no
 (Oracle Communications Messaging Server 7u4-27.01(7.0.4.27.0) 64bit (built Aug
 30 2012)) with ESMTPSA id <0MF500FQV5FGA470@ignis-smin.broadpark.no> for
 linux-media@vger.kernel.org; Sun, 16 Dec 2012 21:40:28 +0100 (CET)
Received: from alstadheim.priv.no (localhost [127.0.0.1])
	by signed.alstadheim.priv.no (Postfix) with ESMTP id 0AC6FA0AB8A4F	for
 <linux-media@vger.kernel.org>; Sun, 16 Dec 2012 21:40:28 +0100 (CET)
Received: from [192.168.2.19] (sorgen.alstadheim.priv.no [192.168.2.19])
	(Authenticated sender: hakon)	by submission.alstadheim.priv.no (Postfix)
 with ESMTPSA id 67A47A0AB8A4B	for <linux-media@vger.kernel.org>; Sun,
 16 Dec 2012 21:40:27 +0100 (CET)
Message-id: <50CE31B9.6080203@alstadheim.priv.no>
Date: Sun, 16 Dec 2012 21:40:25 +0100
From: =?ISO-8859-1?Q?H=E5kon_Alstadheim?= <hakon@alstadheim.priv.no>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Anyone want a crash-backtrace (Atom/Ion) ?
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Don't know if anyone will want to try getting any info out of the log 
messages below here, my system is tainted in every way possible. I'm 
running squeeze with a kernel from backports and nvidia vdpau 
display-drivers (ii  nvidia-kernel-dkms  295.59-1~bpo60+2  ) . Also 
running mythtv-0.26-fixes with some homegrown patches. Anyway, if anyone 
wants it, here it is. At the time this happens the system becomes 
totally unresponsive. Logging is via udp to another host on my network.

If anyone has patches to test, I'm up for it.

I'm running an atom 330 cpu and an nVidia ION gpu. TechnoTrend AG 
TT-connect CT-3650 CI capturecard
Kernel:
----------------
root@sookie:/apub:0:# uname -a
Linux sookie 3.2.0-0.bpo.4-rt-686-pae #1 SMP PREEMPT RT Debian 
3.2.32-1~bpo60+1 i686 GNU/Linux
---------------
Modules loaded are
-----------
root@sookie:/apub:0:# lsmod
Module                  Size  Used by
joydev                 16906  0
hidp                   17543  0
parport_pc             21895  0
ppdev                  12621  0
lp                     12858  0
parport                27018  3 parport_pc,ppdev,lp
bridge                 59191  0
stp                    12368  1 bridge
mperf                  12387  0
bnep                   17147  2
cpufreq_conservative    12987  0
rfcomm                 31983  8
cpufreq_stats          12711  0
autofs4                22715  1
cpufreq_powersave      12422  0
cpufreq_userspace      12520  0
snd_hrtimer            12540  1
nfsd                  176690  13
nfs                   271813  7
lockd                  60955  2 nfsd,nfs
fscache                31488  1 nfs
auth_rpcgss            31970  2 nfsd,nfs
nfs_acl                12463  2 nfsd,nfs
sunrpc                150575  30 nfsd,nfs,lockd,auth_rpcgss,nfs_acl
binfmt_misc            12778  1
fuse                   55737  1
loop                   22119  0
nvidia              10933469  40
snd_hda_codec_hdmi     30242  1
snd_hda_codec_realtek   141983  1
rc_tt_1500             12372  0
ir_lirc_codec          12651  0
lirc_dev               12797  1 ir_lirc_codec
snd_hda_intel          21660  1
ir_mce_kbd_decoder     12518  0
tda10048               16982  1
ir_sony_decoder        12403  0
tda827x                12954  2
tda10023               12839  1
ir_jvc_decoder         12401  0
snd_hda_codec          63120  3 
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel
dvb_usb_ttusb2         17404  22
dvb_usb                17913  1 dvb_usb_ttusb2
dvb_core               67624  2 dvb_usb_ttusb2,dvb_usb
ir_rc6_decoder         12401  0
snd_hwdep              12906  1 snd_hda_codec
snd_pcm_oss            35906  0
snd_mixer_oss          17649  1 snd_pcm_oss
ir_rc5_decoder         12401  0
snd_pcm                52946  4 
snd_hda_codec_hdmi,snd_hda_intel,snd_hda_codec,snd_pcm_oss
ir_nec_decoder         12401  0
btusb                  17209  2
snd_seq_midi           12744  0
bluetooth             111085  24 hidp,bnep,rfcomm,btusb
rc_core                17813  11 
rc_tt_1500,ir_lirc_codec,ir_mce_kbd_decoder,ir_sony_decoder,ir_jvc_decoder,dvb_usb_ttusb2,dvb_usb,ir_rc6_decoder,ir_rc5_decoder,ir_nec_decoder
snd_rawmidi            22310  1 snd_seq_midi
rfkill                 18474  3 bluetooth
snd_seq_midi_event     13124  1 snd_seq_midi
snd_seq                39208  3 snd_seq_midi,snd_seq_midi_event
crc16                  12327  1 bluetooth
psmouse                54719  0
snd_timer              22209  3 snd_hrtimer,snd_pcm,snd_seq
snd_seq_device         12995  3 snd_seq_midi,snd_rawmidi,snd_seq
evdev                  17209  14
shpchp                 26653  0
tpm_tis                13027  0
tpm                    17545  1 tpm_tis
tpm_bios               12799  1 tpm
wmi                    13051  0
coretemp               12793  0
processor              27159  0
serio_raw              12820  0
i2c_nforce2            12520  0
snd                    42459  15 
snd_hda_codec_hdmi,snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_hwdep,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_rawmidi,snd_seq,snd_timer,snd_seq_device
soundcore              12878  1 snd
snd_page_alloc         12841  2 snd_hda_intel,snd_pcm
pcspkr                 12515  0
i2c_core               19022  6 
nvidia,tda10048,tda827x,tda10023,dvb_usb,i2c_nforce2
button                 12783  0
thermal_sys            17712  1 processor
usbhid                 35206  0
hid                    63962  2 hidp,usbhid
ext3                  141637  2
jbd                    50667  1 ext3
mbcache                12810  1 ext3
sg                     21385  0
sd_mod                 35060  4
sr_mod                 17418  0
cdrom                  30535  1 sr_mod
crc_t10dif             12332  1 sd_mod
ata_generic            12439  0
ohci_hcd               21855  0
ahci                   20821  4
libahci                22282  1 ahci
libata                124147  3 ata_generic,ahci,libahci
ehci_hcd               34968  0
usbcore               107736  7 
dvb_usb_ttusb2,dvb_usb,btusb,usbhid,ohci_hcd,ehci_hcd
scsi_mod              134484  4 sg,sr_mod,sd_mod,libata
forcedeth              47936  0
usb_common             12338  1 usbcore
------------------------------------------------------------------------------------------------------------------

root@sookie:/apub:0:# modinfo dvb_usb_ttusb2
filename:       
/lib/modules/3.2.0-0.bpo.4-rt-686-pae/kernel/drivers/media/dvb/dvb-usb/dvb-usb-ttusb2.ko
license:        GPL
version:        1.0
description:    Driver for Pinnacle PCTV 400e DVB-S USB2.0
author:         Patrick Boettcher <patrick.boettcher@desy.de>
srcversion:     A616E65D12AA6E41824E255
alias:          usb:v0B48p300Dd*dc*dsc*dp*ic*isc*ip*
alias:          usb:v0B48p3006d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2304p0222d*dc*dsc*dp*ic*isc*ip*
alias:          usb:v2304p020Fd*dc*dsc*dp*ic*isc*ip*
depends:        dvb-usb,usbcore,rc-core,dvb-core
intree:         Y
vermagic:       3.2.0-0.bpo.4-rt-686-pae SMP preempt mod_unload 
modversions 686
parm:           debug:set debugging level (1=info (or-able)). (debugging 
is not enabled) (int)
parm:           debug_ci:set debugging ci. (debugging is not enabled) (int)
parm:           adapter_nr:DVB adapter numbers (array of short)
root@sookie:/apub:0:#
-------------------------

Here is my log:
--------------
Dec 16 19:51:59 sookie kernel: [244601.837221] dvb_ca adapter 0: DVB CAM 
detected and initialised successfully
Dec 16 19:53:09 sookie kernel: [244672.345224] dvb_ca adapter 0: DVB CAM 
detected and initialised successfully
Dec 16 20:15:39 sookie kernel: [245660.360177] BUG: scheduling while 
atomic: mythfrontend/26795/0x00000002
Dec 16 20:15:39 sookie kernel: [245660.360183] Modules linked in: joydev 
hidp parport_pc ppdev lp parport bridge stp mperf rfcomm bnep 
cpufreq_conservative cpufreq_stats cpufreq_powersave cpufreq_userspace 
autofs4 snd_hrtimer nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc 
binfmt_misc fuse loop nvidia(P) snd_hda_codec_hdmi snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm 
rc_tt_1500 ir_lirc_codec lirc_dev ir_mce_kbd_decoder snd_seq_midi 
ir_sony_decoder tda10048 snd_rawmidi tda827x ir_jvc_decoder 
snd_seq_midi_event tda10023 ir_rc6_decoder snd_seq ir_rc5_decoder 
ir_nec_decoder tpm_tis dvb_usb_ttusb2 dvb_usb dvb_core rc_core snd_timer 
snd_seq_device tpm btusb bluetooth rfkill snd pcspkr i2c_nforce2 psmouse 
coretemp tpm_bios serio_raw wmi evdev soundcore snd_page_alloc crc16 
shpchp i2c_core processor button thermal_sys ext3 jbd mbcache usbhid hid 
sg sd_mod sr_mod cdrom crc_t10dif ata_generic ohci_hcd ahci libahci 
libata ehci_hcd usbcore scsi_mod forcedeth usb_common [las
Dec 16 20:15:39 sookie kernel: [245660.360336] Pid: 26795, comm: 
mythfrontend Tainted: P           O 3.2.0-0.bpo.4-rt-686-pae #1 Debian 
3.2.32-1~bpo60+1
Dec 16 20:15:39 sookie kernel: [245660.360341] Call Trace:
Dec 16 20:15:39 sookie kernel: [245660.360358]  [<c12d1b26>] ? 
__schedule+0x69/0x54c
Dec 16 20:15:39 sookie kernel: [245660.360366]  [<c102d399>] ? 
update_curr+0x55/0x1b1
Dec 16 20:15:39 sookie kernel: [245660.360375]  [<c1028ec4>] ? 
dequeue_pushable_task+0x17/0x3c
Dec 16 20:15:39 sookie kernel: [245660.360383]  [<c12d3328>] ? 
_raw_spin_unlock_irq+0x1e/0x28
Dec 16 20:15:39 sookie kernel: [245660.360391]  [<c102cb9f>] ? 
finish_task_switch+0x3f/0xb0
Dec 16 20:15:39 sookie kernel: [245660.360400]  [<c10263a0>] ? 
need_resched+0x11/0x1a
Dec 16 20:15:39 sookie kernel: [245660.360409]  [<c12d3300>] ? 
_raw_spin_unlock_irqrestore+0x22/0x2c
Dec 16 20:15:39 sookie kernel: [245660.360420]  [<c105b33e>] ? 
task_blocks_on_rt_mutex+0x14c/0x193
Dec 16 20:15:39 sookie kernel: [245660.360431]  [<c12d22f0>] ? 
schedule+0x5d/0x76
Dec 16 20:15:39 sookie kernel: [245660.360437]  [<c12d2f39>] ? 
rt_spin_lock_slowlock+0x10c/0x198
Dec 16 20:15:39 sookie kernel: [245660.360445]  [<c10c899d>] ? 
__local_lock_irq+0x16/0x28
Dec 16 20:15:39 sookie kernel: [245660.360450]  [<c10c9376>] ? 
kfree+0xa1/0xdb
Dec 16 20:15:39 sookie kernel: [245660.360769]  [<faf95ba2>] ? 
nv_get_event+0x5b/0xf1 [nvidia]
Dec 16 20:15:39 sookie kernel: [245660.361086]  [<faf72a68>] ? 
_nv001074rm+0x315/0xad2 [nvidia]
Dec 16 20:15:39 sookie kernel: [245660.361397]  [<faf75328>] ? 
rm_get_event_data+0x53/0x72 [nvidia]
Dec 16 20:15:39 sookie kernel: [245660.361710]  [<faf6833e>] ? 
_nv001099rm+0x9ba/0xb94 [nvidia]
Dec 16 20:15:39 sookie kernel: [245660.362011]  [<faf74d49>] ? 
rm_ioctl+0x78/0x176 [nvidia]
Dec 16 20:15:39 sookie kernel: [245660.362023]  [<c121bdd1>] ? 
raw_pci_read+0x39/0x45
Dec 16 20:15:39 sookie kernel: [245660.362031]  [<c10ca03a>] ? 
__kmalloc+0xea/0xf6
Dec 16 20:15:39 sookie kernel: [245660.362333]  [<faf97b0f>] ? 
nv_kern_ioctl+0x2e6/0x340 [nvidia]
Dec 16 20:15:39 sookie kernel: [245660.362343]  [<c104d703>] ? 
hrtimer_cancel+0xa/0x19
Dec 16 20:15:39 sookie kernel: [245660.362645]  [<faf97b7f>] ? 
nv_kern_compat_ioctl+0x16/0x16 [nvidia]
Dec 16 20:15:39 sookie kernel: [245660.362943]  [<faf97b92>] ? 
nv_kern_unlocked_ioctl+0x13/0x16 [nvidia]
Dec 16 20:15:39 sookie kernel: [245660.362952]  [<c104dc68>] ? 
hrtimer_nanosleep+0x7a/0xe7
Dec 16 20:15:39 sookie kernel: [245660.363256]  [<faf97b92>] ? 
nv_kern_unlocked_ioctl+0x13/0x16 [nvidia]
Dec 16 20:15:39 sookie kernel: [245660.363269]  [<c10defb6>] ? 
do_vfs_ioctl+0x455/0x4a0
Dec 16 20:15:39 sookie kernel: [245660.363280]  [<c1051318>] ? 
timekeeping_get_ns+0x10/0x48
Dec 16 20:15:39 sookie kernel: [245660.363287]  [<c1051a8c>] ? 
ktime_get_ts+0x76/0x7d
Dec 16 20:15:39 sookie kernel: [245660.363293]  [<c10df045>] ? 
sys_ioctl+0x44/0x64
Dec 16 20:15:39 sookie kernel: [245660.363300]  [<c12d76df>] ? 
sysenter_do_call+0x12/0x28
Dec 16 20:15:39 sookie kernel: [245660.363307]  [<c12d0000>] ? 
timer_cpu_notify+0x130/0x243
Dec 16 20:15:39 sookie kernel: [246021.937392] dvb_ca adapter 0: DVB CAM 
detected and initialised successfully
Dec 16 20:16:07 sookie kernel: [246049.980239] BUG: scheduling while 
atomic: mythfrontend/26795/0x00000002
Dec 16 20:16:07 sookie kernel: [246049.980245] Modules linked in: joydev 
hidp parport_pc ppdev lp parport bridge stp mperf rfcomm bnep 
cpufreq_conservative cpufreq_stats cpufreq_powersave cpufreq_userspace 
autofs4 snd_hrtimer nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc 
binfmt_misc fuse loop nvidia(P) snd_hda_codec_hdmi snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm 
rc_tt_1500 ir_lirc_codec lirc_dev ir_mce_kbd_decoder snd_seq_midi 
ir_sony_decoder tda10048 snd_rawmidi tda827x ir_jvc_decoder 
snd_seq_midi_event tda10023 ir_rc6_decoder snd_seq ir_rc5_decoder 
ir_nec_decoder tpm_tis dvb_usb_ttusb2 dvb_usb dvb_core rc_core snd_timer 
snd_seq_device tpm btusb bluetooth rfkill snd pcspkr i2c_nforce2 psmouse 
coretemp tpm_bios serio_raw wmi evdev soundcore snd_page_alloc crc16 
shpchp i2c_core processor button thermal_sys ext3 jbd mbcache usbhid hid 
sg sd_mod sr_mod cdrom crc_t10dif ata_generic ohci_hcd ahci libahci 
libata ehci_hcd usbcore scsi_mod forcedeth usb_common [las
Dec 16 20:16:07 sookie kernel: [246049.980398] Pid: 26795, comm: 
mythfrontend Tainted: P           O 3.2.0-0.bpo.4-rt-686-pae #1 Debian 
3.2.32-1~bpo60+1
Dec 16 20:16:07 sookie kernel: [246049.980404] Call Trace:
Dec 16 20:16:07 sookie kernel: [246049.980423]  [<c12d1b26>] ? 
__schedule+0x69/0x54c
Dec 16 20:16:07 sookie kernel: [246049.980434]  [<c102d399>] ? 
update_curr+0x55/0x1b1
Dec 16 20:16:07 sookie kernel: [246049.980443]  [<c12d3328>] ? 
_raw_spin_unlock_irq+0x1e/0x28
Dec 16 20:16:07 sookie kernel: [246049.980452]  [<c102cb9f>] ? 
finish_task_switch+0x3f/0xb0
Dec 16 20:16:07 sookie kernel: [246049.980461]  [<c12d1ff9>] ? 
__schedule+0x53c/0x54c
Dec 16 20:16:07 sookie kernel: [246049.980468]  [<c12d3300>] ? 
_raw_spin_unlock_irqrestore+0x22/0x2c
Dec 16 20:16:07 sookie kernel: [246049.980478]  [<c105b33e>] ? 
task_blocks_on_rt_mutex+0x14c/0x193
Dec 16 20:16:07 sookie kernel: [246049.980487]  [<c12d22f0>] ? 
schedule+0x5d/0x76
Dec 16 20:16:07 sookie kernel: [246049.980497]  [<c12d2f39>] ? 
rt_spin_lock_slowlock+0x10c/0x198
Dec 16 20:16:07 sookie kernel: [246049.980509]  [<c10c899d>] ? 
__local_lock_irq+0x16/0x28
Dec 16 20:16:07 sookie kernel: [246049.980519]  [<c10c9376>] ? 
kfree+0xa1/0xdb
Dec 16 20:16:07 sookie kernel: [246049.980901]  [<faf95ba2>] ? 
nv_get_event+0x5b/0xf1 [nvidia]
Dec 16 20:16:07 sookie kernel: [246049.981283]  [<faf72a68>] ? 
_nv001074rm+0x315/0xad2 [nvidia]
Dec 16 20:16:07 sookie kernel: [246049.981598]  [<faf75328>] ? 
rm_get_event_data+0x53/0x72 [nvidia]
Dec 16 20:16:07 sookie kernel: [246049.981876]  [<faf6833e>] ? 
_nv001099rm+0x9ba/0xb94 [nvidia]
Dec 16 20:16:07 sookie kernel: [246049.982151]  [<faf74d49>] ? 
rm_ioctl+0x78/0x176 [nvidia]
Dec 16 20:16:07 sookie kernel: [246049.982162]  [<c121bdd1>] ? 
raw_pci_read+0x39/0x45
Dec 16 20:16:07 sookie kernel: [246049.982171]  [<c10ca03a>] ? 
__kmalloc+0xea/0xf6
Dec 16 20:16:07 sookie kernel: [246049.982444]  [<faf97b0f>] ? 
nv_kern_ioctl+0x2e6/0x340 [nvidia]
Dec 16 20:16:07 sookie kernel: [246049.982453]  [<c104d703>] ? 
hrtimer_cancel+0xa/0x19
Dec 16 20:16:07 sookie kernel: [246049.982727]  [<faf97b7f>] ? 
nv_kern_compat_ioctl+0x16/0x16 [nvidia]
Dec 16 20:16:07 sookie kernel: [246049.983002]  [<faf97b92>] ? 
nv_kern_unlocked_ioctl+0x13/0x16 [nvidia]
Dec 16 20:16:07 sookie kernel: [246049.983028]  [<c104dc68>] ? 
hrtimer_nanosleep+0x7a/0xe7
Dec 16 20:16:07 sookie kernel: [246049.983330]  [<faf97b92>] ? 
nv_kern_unlocked_ioctl+0x13/0x16 [nvidia]
Dec 16 20:16:07 sookie kernel: [246049.983342]  [<c10defb6>] ? 
do_vfs_ioctl+0x455/0x4a0
Dec 16 20:16:07 sookie kernel: [246049.983387]  [<c1051318>] ? 
timekeeping_get_ns+0x10/0x48
Dec 16 20:16:07 sookie kernel: [246049.983394]  [<c1051a8c>] ? 
ktime_get_ts+0x76/0x7d
Dec 16 20:16:07 sookie kernel: [246049.983399]  [<c10df045>] ? 
sys_ioctl+0x44/0x64
Dec 16 20:16:07 sookie kernel: [246049.983407]  [<c12d76df>] ? 
sysenter_do_call+0x12/0x28
Dec 16 20:16:07 sookie kernel: [246049.983415]  [<c12d0000>] ? 
timer_cpu_notify+0x130/0x243
Dec 16 20:16:07 sookie kernel: [246049.987518] ------------[ cut here 
]------------
Dec 16 20:16:07 sookie kernel: [246049.987539] WARNING: at 
/build/buildd-linux_3.2.32-1~bpo60+1-i386-PU9TzG/linux-3.2.32/debian/build/source_rt/kernel/sched.c:4619 
migrate_disable+0x44/0xa8()
Dec 16 20:16:07 sookie kernel: [246049.987549] Hardware name: To Be 
Filled By O.E.M.
Dec 16 20:16:07 sookie kernel: [246049.987555] Modules linked in: joydev 
hidp parport_pc ppdev lp parport bridge stp mperf rfcomm bnep 
cpufreq_conservative cpufreq_stats cpufreq_powersave cpufreq_userspace 
autofs4 snd_hrtimer nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc 
binfmt_misc fuse loop nvidia(P) snd_hda_codec_hdmi snd_hda_codec_realtek 
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm 
rc_tt_1500 ir_lirc_codec lirc_dev ir_mce_kbd_decoder snd_seq_midi 
ir_sony_decoder tda10048 snd_rawmidi tda827x ir_jvc_decoder 
snd_seq_midi_event tda10023 ir_rc6_decoder snd_seq ir_rc5_decoder 
ir_nec_decoder tpm_tis dvb_usb_ttusb2 dvb_usb dvb_core rc_core snd_timer 
snd_seq_device tpm btusb bluetooth rfkill snd pcspkr i2c_nforce2 psmouse 
coretemp tpm_bios serio_raw wmi evdev soundcore snd_page_alloc crc16 
shpchp i2c_core processor button thermal_sys ext3 jbd mbcache usbhid hid 
sg sd_mod sr_mod cdrom crc_t10dif ata_generic ohci_hcd ahci libahci 
libata ehci_hcd usbcore scsi_mod forcedeth usb_common [las
Dec 16 20:16:07 sookie kernel: [246049.987935] Pid: 26795, comm: 
mythfrontend Tainted: P           O 3.2.0-0.bpo.4-rt-686-pae #1 Debian 
3.2.32-1~bpo60+1
Dec 16 20:16:07 sookie kernel: [246049.987943] Call Trace:
Dec 16 20:16:07 sookie kernel: [246049.987954]  [<c1032b4f>] ? 
warn_slowpath_common+0x6a/0x7b
Dec 16 20:16:07 sookie kernel: [246049.987961]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.987969]  [<c1032b6d>] ? 
warn_slowpath_null+0xd/0x10
Dec 16 20:16:07 sookie kernel: [246049.987988]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.987996]  [<c1033628>] ? 
vprintk+0xf7/0x450
Dec 16 20:16:07 sookie kernel: [246049.988052]  [<c12d19fe>] ? 
printk+0xe/0x18
Dec 16 20:16:07 sookie kernel: [246049.988060]  [<c1032b06>] ? 
warn_slowpath_common+0x21/0x7b
Dec 16 20:16:07 sookie kernel: [246049.988067]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988076]  [<c1032b6d>] ? 
warn_slowpath_null+0xd/0x10
Dec 16 20:16:07 sookie kernel: [246049.988084]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988091]  [<c1033628>] ? 
vprintk+0xf7/0x450
Dec 16 20:16:07 sookie kernel: [246049.988105]  [<c12d19fe>] ? 
printk+0xe/0x18
Dec 16 20:16:07 sookie kernel: [246049.988113]  [<c1032b06>] ? 
warn_slowpath_common+0x21/0x7b
Dec 16 20:16:07 sookie kernel: [246049.988120]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988128]  [<c1032b6d>] ? 
warn_slowpath_null+0xd/0x10
Dec 16 20:16:07 sookie kernel: [246049.988135]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988141]  [<c1033628>] ? 
vprintk+0xf7/0x450
Dec 16 20:16:07 sookie kernel: [246049.988152]  [<c12d19fe>] ? 
printk+0xe/0x18
Dec 16 20:16:07 sookie kernel: [246049.988159]  [<c1032b06>] ? 
warn_slowpath_common+0x21/0x7b
Dec 16 20:16:07 sookie kernel: [246049.988166]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988174]  [<c1032b6d>] ? 
warn_slowpath_null+0xd/0x10
Dec 16 20:16:07 sookie kernel: [246049.988181]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988187]  [<c1033628>] ? 
vprintk+0xf7/0x450
Dec 16 20:16:07 sookie kernel: [246049.988199]  [<c12d19fe>] ? 
printk+0xe/0x18
Dec 16 20:16:07 sookie kernel: [246049.988206]  [<c1032b06>] ? 
warn_slowpath_common+0x21/0x7b
Dec 16 20:16:07 sookie kernel: [246049.988213]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988220]  [<c1032b6d>] ? 
warn_slowpath_null+0xd/0x10
Dec 16 20:16:07 sookie kernel: [246049.988227]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988234]  [<c1033628>] ? 
vprintk+0xf7/0x450
Dec 16 20:16:07 sookie kernel: [246049.988245]  [<c12d19fe>] ? 
printk+0xe/0x18
Dec 16 20:16:07 sookie kernel: [246049.988253]  [<c1032b06>] ? 
warn_slowpath_common+0x21/0x7b
Dec 16 20:16:07 sookie kernel: [246049.988259]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988267]  [<c1032b6d>] ? 
warn_slowpath_null+0xd/0x10
Dec 16 20:16:07 sookie kernel: [246049.988274]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988281]  [<c1033628>] ? 
vprintk+0xf7/0x450
Dec 16 20:16:07 sookie kernel: [246049.988289]  [<c1029d8a>] ? 
get_parent_ip+0x8/0x19
Dec 16 20:16:07 sookie kernel: [246049.988296]  [<c12d600b>] ? 
sub_preempt_count+0x74/0x80
Dec 16 20:16:07 sookie kernel: [246049.988303]  [<c1003273>] ? 
do_IRQ+0x72/0x83
Dec 16 20:16:07 sookie kernel: [246049.988312]  [<c12d7c70>] ? 
common_interrupt+0x30/0x38
Dec 16 20:16:07 sookie kernel: [246049.988318]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988327]  [<c12d19fe>] ? 
printk+0xe/0x18
Dec 16 20:16:07 sookie kernel: [246049.988335]  [<c1032b06>] ? 
warn_slowpath_common+0x21/0x7b
Dec 16 20:16:07 sookie kernel: [246049.988341]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988349]  [<c1032b6d>] ? 
warn_slowpath_null+0xd/0x10
Dec 16 20:16:07 sookie kernel: [246049.988356]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988363]  [<c1033628>] ? 
vprintk+0xf7/0x450
Dec 16 20:16:07 sookie kernel: [246049.988375]  [<c12d19fe>] ? 
printk+0xe/0x18
Dec 16 20:16:07 sookie kernel: [246049.988382]  [<c1032b06>] ? 
warn_slowpath_common+0x21/0x7b
Dec 16 20:16:07 sookie kernel: [246049.988389]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988396]  [<c1032b6d>] ? 
warn_slowpath_null+0xd/0x10
Dec 16 20:16:07 sookie kernel: [246049.988403]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988410]  [<c1033628>] ? 
vprintk+0xf7/0x450
Dec 16 20:16:07 sookie kernel: [246049.988421]  [<c12d19fe>] ? 
printk+0xe/0x18
Dec 16 20:16:07 sookie kernel: [246049.988428]  [<c1032b06>] ? 
warn_slowpath_common+0x21/0x7b
Dec 16 20:16:07 sookie kernel: [246049.988435]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988442]  [<c1032b6d>] ? 
warn_slowpath_null+0xd/0x10
Dec 16 20:16:07 sookie kernel: [246049.988449]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988456]  [<c1033628>] ? 
vprintk+0xf7/0x450
Dec 16 20:16:07 sookie kernel: [246049.988468]  [<c12d19fe>] ? 
printk+0xe/0x18
Dec 16 20:16:07 sookie kernel: [246049.988475]  [<c1032b06>] ? 
warn_slowpath_common+0x21/0x7b
Dec 16 20:16:07 sookie kernel: [246049.988495]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988504]  [<c1032b6d>] ? 
warn_slowpath_null+0xd/0x10
Dec 16 20:16:07 sookie kernel: [246049.988512]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988520]  [<c1033628>] ? 
vprintk+0xf7/0x450
Dec 16 20:16:07 sookie kernel: [246049.988532]  [<c12d19fe>] ? 
printk+0xe/0x18
Dec 16 20:16:07 sookie kernel: [246049.988539]  [<c1032b06>] ? 
warn_slowpath_common+0x21/0x7b
Dec 16 20:16:07 sookie kernel: [246049.988547]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988555]  [<c1032b6d>] ? 
warn_slowpath_null+0xd/0x10
Dec 16 20:16:07 sookie kernel: [246049.988563]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988570]  [<c1033628>] ? 
vprintk+0xf7/0x450
Dec 16 20:16:07 sookie kernel: [246049.988581]  [<c12d19fe>] ? 
printk+0xe/0x18
Dec 16 20:16:07 sookie kernel: [246049.988588]  [<c1032b06>] ? 
warn_slowpath_common+0x21/0x7b
Dec 16 20:16:07 sookie kernel: [246049.988595]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988603]  [<c1032b6d>] ? 
warn_slowpath_null+0xd/0x10
Dec 16 20:16:07 sookie kernel: [246049.988610]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988616]  [<c1033628>] ? 
vprintk+0xf7/0x450
Dec 16 20:16:07 sookie kernel: [246049.988628]  [<c12d19fe>] ? 
printk+0xe/0x18
Dec 16 20:16:07 sookie kernel: [246049.988635]  [<c1032b06>] ? 
warn_slowpath_common+0x21/0x7b
Dec 16 20:16:07 sookie kernel: [246049.988642]  [<c102f194>] ? 
migrate_disable+0x44/0xa8
Dec 16 20:16:07 sookie kernel: [246049.988650]  [<c1032b6d>] ? 
warn_slowpath_null+0xd/0x10
Dec 16 20:19:21 sookie kernel: [    0.000000] Atom PSE erratum detected, 
BIOS microcode update recommended
Dec 16 20:19:21 sookie kernel: [    0.000000] ACPI: RSDP 000fa6b0 00014 
(v00 ACPIAM)
Dec 16 20:19:21 sookie kernel: [    0.000000] ACPI: RSDT 5ffa0000 00040 
(v01 081710 RSDT1115 20100817 MSFT 00000097)
Dec 16 20:19:21 sookie kernel: [    0.000000] ACPI: FACP 5ffa0200 00084 
(v01 A_M_I  OEMFACP  12000601 MSFT 00000097)
Dec 16 20:19:21 sookie kernel: [    0.000000] ACPI: DSDT 5ffa0450 06C21 
(v01  AS271 AS271114 00000114 INTL 20051117)
Dec 16 20:19:21 sookie kernel: [    0.000000] ACPI: FACS 5ffb0000 00040
Dec 16 20:19:21 sookie kernel: [    0.000000] ACPI: APIC 5ffa0390 00080 
(v01 081710 APIC1115 20100817 MSFT 00000097)
Dec 16 20:19:21 sookie kernel: [    0.000000] ACPI: MCFG 5ffa0410 0003C 
(v01 081710 OEMMCFG  20100817 MSFT 00000097)
Dec 16 20:19:21 sookie kernel: [    0.000000] ACPI: OEMB 5ffb0040 00078 
(v01 081710 OEMB1115 20100817 MSFT 00000097)
Dec 16 20:19:21 sookie kernel: [    0.000000] ACPI: AAFT 5ffaa450 00027 
(v01 081710 OEMAAFT  20100817 MSFT 00000097)
Dec 16 20:19:21 sookie kernel: [    0.000000] ACPI: HPET 5ffaa480 00038 
(v01 081710 OEMHPET0 20100817 MSFT 00000097)
Dec 16 20:19:21 sookie kernel: [    0.000000] ACPI: NVHD 5ffb00c0 00284 
(v01 081710  NVHDCP  20100817 MSFT 00000097)
Dec 16 20:19:21 sookie kernel: [    0.000000] Zone PFN ranges:
Dec 16 20:19:21 sookie kernel: [    0.000000]   DMA      0x00000010 -> 
0x00001000
Dec 16 20:19:21 sookie kernel: [    0.000000]   Normal   0x00001000 -> 
0x000379fe
Dec 16 20:19:21 sookie kernel: [    0.000000]   HighMem  0x000379fe -> 
0x0005ffa0
Dec 16 20:19:21 sookie kernel: [    0.000000] Movable zone start PFN for 
each node
Dec 16 20:19:21 sookie kernel: [    0.000000] early_node_map[2] active 
PFN ranges
Dec 16 20:19:21 sookie kernel: [    0.000000]     0: 0x00000010 -> 
0x0000009f
Dec 16 20:19:21 sookie kernel: [    0.000000]     0: 0x00000100 -> 
0x0005ffa0
Dec 16 20:19:21 sookie kernel: [    0.000000] Built 1 zonelists in Zone 
order, mobility grouping on.  Total pages: 389935
Dec 16 20:19:21 sookie kernel: [    0.000000] Fast TSC calibration using PIT
Dec 16 20:19:21 sookie kernel: [    0.000000] Detected 2100.001 MHz 
processor.
Dec 16 20:19:21 sookie kernel: [    0.004484] Atom PSE erratum detected, 
BIOS microcode update recommended
Dec 16 20:19:21 sookie kernel: [    0.008000] Atom PSE erratum detected, 
BIOS microcode update recommended
Dec 16 20:19:21 sookie kernel: [    0.200096]  #2
Dec 16 20:19:21 sookie kernel: [    0.008000] Atom PSE erratum detected, 
BIOS microcode update recommended
Dec 16 20:19:21 sookie kernel: [    0.308112]  #3 Ok.
Dec 16 20:19:21 sookie kernel: [    0.008000] Atom PSE erratum detected, 
BIOS microcode update recommended
Dec 16 20:19:21 sookie kernel: [    0.421182] ACPI: Executed 1 blocks of 
module-level executable AML code
Dec 16 20:19:21 sookie kernel: [    0.640552] ACPI: PCI Interrupt Link 
[LRP3] enabled at IRQ 23
Dec 16 20:19:21 sookie kernel: [    0.646422] ACPI: PCI Interrupt Link 
[LUB0] enabled at IRQ 16
Dec 16 20:19:21 sookie kernel: [    0.732964] ACPI: PCI Interrupt Link 
[LUB2] enabled at IRQ 18
Dec 16 20:19:21 sookie kernel: [    1.210743] highmem bounce pool size: 
64 pages
Dec 16 20:19:21 sookie kernel: [    1.211607] Dquot-cache hash table 
entries: 1024 (order 0, 4096 bytes)
Dec 16 20:19:21 sookie kernel: [    2.010896] ACPI: PCI Interrupt Link 
[LMAC] enabled at IRQ 22
Dec 16 20:19:21 sookie kernel: [    2.098542] ACPI: PCI Interrupt Link 
[LSA0] enabled at IRQ 21
Dec 16 20:19:21 sookie kernel: [    2.510726] sr0: scsi3-mmc drive: 
24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Dec 16 20:19:21 sookie kernel: [   11.893759] ACPI: resource 
nForce2_smbus [io  0x4e00-0x4e3f] conflicts with ACPI region SM00 [io 
0x4e00-0x4e3f]
Dec 16 20:19:21 sookie kernel: [   12.949262] DVB: registering adapter 0 
frontend 0 (Philips TDA10023 DVB-C)...
Dec 16 20:19:21 sookie kernel: [   13.009518] DVB: registering adapter 0 
frontend 1 (NXP TDA10048HN DVB-T)...
Dec 16 20:19:21 sookie kernel: [   13.012314] ACPI: PCI Interrupt Link 
[LAZA] enabled at IRQ 20
Dec 16 20:19:21 sookie kernel: [   14.309608] nvidia: module license 
'NVIDIA' taints kernel.
Dec 16 20:19:21 sookie kernel: [   14.309629] nvidia: module license 
'NVIDIA' taints kernel.
Dec 16 20:19:21 sookie kernel: [   14.309634] Disabling lock debugging 
due to kernel taint
Dec 16 20:19:21 sookie kernel: [   15.339568] ACPI: PCI Interrupt Link 
[LPMU] enabled at IRQ 23
Dec 16 20:19:21 sookie kernel: [   15.340648] ACPI: PCI Interrupt Link 
[SGRU] enabled at IRQ 22
Dec 16 20:19:21 sookie kernel: [   15.341567] NVRM: loading NVIDIA UNIX 
x86 Kernel Module  295.59  Wed Jun  6 21:24:41 PDT 2012
Dec 16 20:19:21 sookie kernel: [   20.161885] dvb_ca adapter 0: Invalid 
PC card inserted :(
Dec 16 20:19:31 sookie kernel: [   68.197974] NFSD: Using 
/var/lib/nfs/v4recovery as the NFSv4 state recovery directory
Dec 16 20:19:36 sookie udev-configure-printer: Failed to get parent
Dec 16 20:19:43 sookie kernel: [   79.348242] sshd (2725): 
/proc/2725/oom_adj is deprecated, please use /proc/2725/oom_score_adj 
instead.
Dec 16 20:19:52 sookie kernel: [   89.621884] dvb_ca adapter 0: Invalid 
PC card inserted :(
Dec 16 20:20:30 sookie kernel: [  127.953254] dvb_ca adapter 0: DVB CAM 
detected and initialised successfully
Dec 16 20:21:15 sookie kernel: [  172.524512] dvb_ca adapter 0: DVB CAM 
link initialisation failed :(
Dec 16 20:21:49 sookie kernel: [  206.890264] dvb_ca adapter 0: DVB CAM 
detected and initialised successfully



-- 
Håkon Alstadheim / N-7510 Skatval / email:hakon@alstadheim.priv.no
tlf: 74 82 60 27 mob: 47 35 39 38
http://alstadheim.priv.no/hakon/
spamtrap: finnesikke@alstadheim.priv.no -- 1 hit&  you are out


