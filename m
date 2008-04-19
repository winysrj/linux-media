Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mout2.freenet.de ([195.4.92.92])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ruediger.dohmhardt@freenet.de>) id 1JnEm5-00016F-Ti
	for linux-dvb@linuxtv.org; Sat, 19 Apr 2008 17:14:47 +0200
Message-ID: <480A0C5F.8000301@freenet.de>
Date: Sat, 19 Apr 2008 17:14:39 +0200
From: Ruediger Dohmhardt <ruediger.dohmhardt@freenet.de>
MIME-Version: 1.0
To: "Bas v.d. Wiel" <bas@kompasmedia.nl>
References: <480739BC.9010002@kompasmedia.nl>
In-Reply-To: <480739BC.9010002@kompasmedia.nl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Mantis 2033 crashes
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

Bas v.d. Wiel schrieb:
> I tried using the very latest code from Manu that has some beginning 
> support for the CI module. This only crashes the mantis module with a 
> huge error message (I'll post the exact error later, can't access the 
> machine right now) as soon as I insert my Alphacrypt. Same happens when 
> I switch the PC on with the cam already inserted. When there's nothing 
> in the CI slot, everything loads up alright and the CA device gets 
> registered properly.
>   
It crashes here, when I start vdr-1.4.7 (on 2.6.24.4) even without the
CAM (Alphacrypt light) inserted.

I got the latest code with

    hg clone http://jusst.de/hg/mantis

However, tuning and watching unencrypted channels works perfectly with
code from

    hg clone http://jusst.de/hg/mantis_old_1

or

    http://jusst.de/manu/mantis-v4l-dvb.tar.bz2
<http://jusst.de/manu/mantis-v4l-dvb.tar.bz2>


The card registers with

    mantis_frontend_init (0): Probing for CU1216 (DVB-C)
    TDA10021: i2c-addr = 0x0c, id = 0x7c
    mantis_frontend_init (0): found Philips CU1216 DVB-C frontend
(TDA10021) @ 0x0c
    mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend
attach success
    DVB: registering frontend 0 (Philips TDA10021 DVB-C)...
    mantis_ca_init (0): Registering EN50221 device
    mantis_ca_init (0): Registered EN50221 device
    mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface

> If there's anything I can do to help debug this driver, I'd be happy 
> to
>   
Same applies to me!

------------------------------------------------------------------------------------------------------------------------------------------

Below follows the contents of /var/log/messages when starting "vdr".

Apr 19 16:41:07 linux-sh8m vdr: [5640] loading plugin:
./PLUGINS/lib/libvdr-xineliboutput.so.1.4.5
Apr 19 16:41:07 linux-sh8m vdr: [5640] loading /video/setup.conf
Apr 19 16:41:07 linux-sh8m vdr: [5640] ERROR: unknown config parameter:
SortTimers = 1
Apr 19 16:41:07 linux-sh8m vdr: [5640] loading /video/sources.conf
Apr 19 16:41:07 linux-sh8m vdr: [5640] loading /video/diseqc.conf
Apr 19 16:41:07 linux-sh8m vdr: [5640] loading /video/channels.conf
Apr 19 16:41:07 linux-sh8m vdr: [5640] loading /video/timers.conf
Apr 19 16:41:07 linux-sh8m vdr: [5640] loading /video/commands.conf
Apr 19 16:41:07 linux-sh8m vdr: [5640] loading /video/svdrphosts.conf
Apr 19 16:41:07 linux-sh8m vdr: [5640] loading /video/remote.conf
Apr 19 16:41:07 linux-sh8m vdr: [5640] loading /video/keymacros.conf
Apr 19 16:41:07 linux-sh8m vdr: [5641] video directory scanner thread
started (pid=5640, tid=5641)
Apr 19 16:41:07 linux-sh8m vdr: [5642] video directory scanner thread
started (pid=5640, tid=5642)
Apr 19 16:41:07 linux-sh8m vdr: [5640] reading EPG data from /video/epg.data
Apr 19 16:41:08 linux-sh8m vdr: [5641] video directory scanner thread
ended (pid=5640, tid=5641)
Apr 19 16:41:08 linux-sh8m vdr: [5642] video directory scanner thread
ended (pid=5640, tid=5642)
Apr 19 16:41:08 linux-sh8m vdr: [5640] probing /dev/dvb/adapter0/frontend0
Apr 19 16:41:11 linux-sh8m vdr: [5644] tuner on device 1 thread started
(pid=5640, tid=5644)
Apr 19 16:41:11 linux-sh8m vdr: [5645] section handler thread started
(pid=5640, tid=5645)
Apr 19 16:41:11 linux-sh8m vdr: [5640] found 1 video device
Apr 19 16:41:11 linux-sh8m vdr: [5640] initializing plugin:
xineliboutput (1.0.0rc2): X11/xine-lib output plugin
Apr 19 16:41:11 linux-sh8m vdr: [5640] [xine..put] cTimePts:
clock_gettime(CLOCK_MONOTONIC): clock resolution 999 us
Apr 19 16:41:11 linux-sh8m vdr: [5640] [xine..put] cTimePts: using
monotonic clock
Apr 19 16:41:11 linux-sh8m vdr: [5640] [xine..put] cTimePts:
clock_gettime(CLOCK_MONOTONIC): clock resolution 999 us
Apr 19 16:41:11 linux-sh8m vdr: [5640] [xine..put] cTimePts: using
monotonic clock
Apr 19 16:41:11 linux-sh8m vdr: [5640] [xine..put] RTP SSRC: 0x18ac46cb
Apr 19 16:41:11 linux-sh8m vdr: [5640] setting primary device to 2
Apr 19 16:41:11 linux-sh8m vdr: [5640] SVDRP listening on port 2001
Apr 19 16:41:11 linux-sh8m vdr: [5640] setting current skin to "sttng"
Apr 19 16:41:11 linux-sh8m vdr: [5640] loading
/video/themes/sttng-default.theme
Apr 19 16:41:11 linux-sh8m vdr: [5640] starting plugin: xineliboutput
Apr 19 16:41:11 linux-sh8m vdr: [5647] Remote decoder/display server
(cXinelibServer) thread started (pid=5640, tid=5647)
Apr 19 16:41:11 linux-sh8m vdr: [5647] [xine..put] cXinelibServer
priority set successful SCHED_RR 2 [1,99]
Apr 19 16:41:11 linux-sh8m vdr: [5647] [xine..put] Listening on port 37890
Apr 19 16:41:11 linux-sh8m vdr: [5647] [xine..put] Listening for UDP
broadcasts on port 37890
Apr 19 16:41:11 linux-sh8m vdr: [5640] [xine..put]
cXinelibDevice::StartDevice(): Device started
Apr 19 16:41:11 linux-sh8m vdr: [5648] KBD remote control thread started
(pid=5640, tid=5648)
Apr 19 16:41:11 linux-sh8m vdr: [5640] remote control KBD - keys known
Apr 19 16:41:11 linux-sh8m vdr: [5640] switching to channel 1
Apr 19 16:41:11 linux-sh8m kernel: mantis start feed & dma
Apr 19 16:41:11 linux-sh8m kernel: Unable to handle kernel paging
request at ffffc2001003bfff RIP:
Apr 19 16:41:11 linux-sh8m kernel:  [<ffffffff889efa89>]
:mantis:mantis_dma_start+0x129/0x1e0
Apr 19 16:41:11 linux-sh8m kernel: PGD 7dc22067 PUD 7dc23067 PMD 0
Apr 19 16:41:11 linux-sh8m kernel: Oops: 0000 [1] PREEMPT
Apr 19 16:41:11 linux-sh8m kernel: CPU 0
Apr 19 16:41:11 linux-sh8m kernel: Modules linked in: ip6t_LOG
nf_conntrack_ipv6 xt_pkttype ipt_LOG xt_limit af_packet kqemu(P) cpu
freq_conservative cpufreq_ondemand cpufreq_performance cpufreq_powersave
thermal fan button battery ac ip6t_REJECT xt_tcpudp ipt_RE
JECT xt_state iptable_mangle iptable_nat nf_nat iptable_filter
ip6table_mangle nf_conntrack_ipv4 nf_conntrack ip_tables ip6table_fi
lter ip6_tables x_tables ipv6 isofs nls_iso8859_1 nls_cp437 vfat fat
nls_utf8 ntfs loop md_mod dm_mod rtc w83627hf hwmon_vid powern
ow_k8 freq_table processor joydev evdev usbhid snd_ice1724
snd_ice17xx_ak4xxx snd_ac97_codec ac97_bus snd_ak4114 snd_pcm snd_timer
snd_page_alloc snd_pt2258 snd_i2c snd_ak4xxx_adda lirc_mceusb2(F)
snd_mpu401_uart lirc_dev mantis ohci1394 snd_rawmidi nvidia(P) ln
bp21 mb86a16 stb6100 tda10021 tda10023 ide_cd cdrom snd_seq_device
stb0899 stv0299 8139too ieee1394 snd soundcore dvb_core k8temp o
hci_hcd ehci_hcd usbcore i2c_piix4 lp bttv ir_common compat_ioctl32
videodev v4l1_compat i2c_algo_bit v4l2_common
Apr 19 16:41:11 linux-sh8m kernel: videobuf_dma_sg videobuf_core
btcx_risc tveeprom i2c_core sg
Apr 19 16:41:11 linux-sh8m kernel: Pid: 5640, comm: vdr Tainted:
PF       2.6.24.4 #1
Apr 19 16:41:11 linux-sh8m kernel: RIP: 0010:[<ffffffff889efa89>] 
[<ffffffff889efa89>] :mantis:mantis_dma_start+0x129/0x1e0
Apr 19 16:41:11 linux-sh8m kernel: RSP: 0018:ffff8100644b3ce8  EFLAGS:
00010282
Apr 19 16:41:11 linux-sh8m kernel: RAX: 000000007d16f000 RBX:
ffff810078f4a000 RCX: 0000000000000042
Apr 19 16:41:11 linux-sh8m kernel: RDX: ffffc2000003c000 RSI:
000000000000003d RDI: ffff810078f4a000
Apr 19 16:41:11 linux-sh8m kernel: RBP: 000000000000f800 R08:
ffff8100644b2000 R09: 0000000000000000
Apr 19 16:41:11 linux-sh8m kernel: R10: ffffffff80678e18 R11:
0000000000000001 R12: 0000000000000020
Apr 19 16:41:11 linux-sh8m kernel: R13: ffff810078f4a698 R14:
ffff810078f4a6b0 R15: ffffc20000a600f0
Apr 19 16:41:11 linux-sh8m kernel: FS:  00002abbd84790b0(0000)
GS:ffffffff80623000(0000) knlGS:0000000000000000
Apr 19 16:41:11 linux-sh8m kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Apr 19 16:41:11 linux-sh8m kernel: CR2: ffffc2001003bfff CR3:
000000007708f000 CR4: 00000000000006e0
Apr 19 16:41:11 linux-sh8m kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Apr 19 16:41:11 linux-sh8m kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Apr 19 16:41:11 linux-sh8m kernel: Process vdr (pid: 5640, threadinfo
ffff8100644b2000, task ffff810078fc2040)
Apr 19 16:41:11 linux-sh8m kernel: Stack:  ffff810078f4a000
ffff810078f4a3f0 ffff810078f4a3f0 ffffffff889f15a4
Apr 19 16:41:11 linux-sh8m kernel:  0000000000008000 ffffc20000945000
00000000fffffe00 ffffffff880d0f3c
Apr 19 16:41:11 linux-sh8m kernel:  0000000000000000 ffffc20000a600e8
0000000000000000 0000000000000001
Apr 19 16:41:11 linux-sh8m kernel: Call Trace:
Apr 19 16:41:11 linux-sh8m kernel:  [<ffffffff889f15a4>]
:mantis:mantis_dvb_start_feed+0xb4/0x110
Apr 19 16:41:11 linux-sh8m kernel:  [<ffffffff880d0f3c>]
:dvb_core:dmx_ts_feed_start_filtering+0x6c/0x120
Apr 19 16:41:11 linux-sh8m kernel:  [<ffffffff880ce6a5>]
:dvb_core:dvb_dmxdev_filter_start+0x365/0x4c0
Apr 19 16:41:11 linux-sh8m kernel:  [<ffffffff880ce9b0>]
:dvb_core:dvb_demux_do_ioctl+0x1b0/0x4e0
Apr 19 16:41:11 linux-sh8m kernel:  [<ffffffff880ce800>]
:dvb_core:dvb_demux_do_ioctl+0x0/0x4e0
Apr 19 16:41:11 linux-sh8m kernel:  [<ffffffff880cd0ff>]
:dvb_core:dvb_usercopy+0x7f/0x1a0
Apr 19 16:41:11 linux-sh8m kernel:  [<ffffffff80294381>]
__dentry_open+0x1e1/0x260
Apr 19 16:41:11 linux-sh8m kernel:  [<ffffffff8029450a>]
do_filp_open+0x3a/0x50
Apr 19 16:41:11 linux-sh8m kernel:  [<ffffffff802a497d>] do_ioctl+0x7d/0xa0
Apr 19 16:41:11 linux-sh8m kernel:  [<ffffffff802a4a14>]
vfs_ioctl+0x74/0x2d0
Apr 19 16:41:11 linux-sh8m kernel:  [<ffffffff802a4d01>] sys_ioctl+0x91/0xb0
Apr 19 16:41:11 linux-sh8m kernel:  [<ffffffff8020bb3e>]
system_call+0x7e/0x83
Apr 19 16:41:11 linux-sh8m kernel:
Apr 19 16:41:11 linux-sh8m kernel:
Apr 19 16:41:11 linux-sh8m kernel: Code: 8b 82 ff ff ff 0f 0d 00 00 00
80 89 82 ff ff ff 0f 48 8b 43
Apr 19 16:41:11 linux-sh8m kernel: RIP  [<ffffffff889efa89>]
:mantis:mantis_dma_start+0x129/0x1e0
Apr 19 16:41:11 linux-sh8m kernel:  RSP <ffff8100644b3ce8>
Apr 19 16:41:11 linux-sh8m kernel: CR2: ffffc2001003bfff
Apr 19 16:41:11 linux-sh8m kernel: ---[ end trace 0a0fe1e236c7ec03 ]---


Ciao Ruediger D.



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
