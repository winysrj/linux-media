Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm5.bullet.mail.ukl.yahoo.com ([217.146.182.226]:30706 "HELO
	nm5.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753850Ab1KXTJX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 14:09:23 -0500
Message-ID: <1322161379.18402.YahooMailNeo@web28008.mail.ukl.yahoo.com>
Date: Thu, 24 Nov 2011 19:02:59 +0000 (GMT)
From: Stefan Macher <maker76s@yahoo.de>
Reply-To: Stefan Macher <maker76s@yahoo.de>
Subject: BUG: scheduling while atomic: kworker/0:0/0/0x00000100
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hi,

I have setup a new vdr with yavdr 0.4 with one TT full-featured DVB-S card (S2300) and one Mystique SaTiX-S2 Sky Xpress dual. As soon as I pause the video I get endless reports like the one in the headline and the vdr is dead.

Because of the new SaTiX card I had to update the DVB drivers to the latest media-tree. I tried the yavdr kernel 2.6.38-12, a vanilla 3.0.9 kernel and I also tested the DVB driver from dvbsky.net on top of vanilla 3.0.9. I always get the same result - working perfectly until I press pause.

In the log below schedule is called by play_video_cb (dvb-ttpci). Any help is appreciated.

/Stefan

LOG:

Nov 22 20:19:23 vdr4 kernel: [ 1881.295798] BUG: scheduling while atomic: kworker/0:0/0/0x00000100
Nov 22 20:19:23 vdr4 kernel: [ 1881.295806] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek speedstep_lib nfsd exportfs nfs lockd fscache auth_rpcgss nfs_acl rc_dvbsky ds3000 lnbp21 sunrpc stv0299 cx25840 ir_lirc_codec lirc_dev snd_hda_intel snd_hda_codec ir_mce_kbd_decoder snd_hwdep ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder cx23885 rc_core snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event cx2341x videobuf_dvb v4l2_common snd_seq dvb_ttpci dvb_core saa7146_vv snd_timer snd_seq_device snd mxm_wmi saa7146 videodev soundcore videobuf_dma_sg videobuf_core v4l2_compat_ioctl32 ttpci_eeprom psmouse snd_page_alloc serio_raw video btcx_risc tveeprom edac_core edac_mce_amd k8temp shpchp i2c_nforce2 lp parport floppy firewire_ohci firewire_core crc_itu_t forcedeth ahci libahci
Nov 22 20:19:23 vdr4 kernel: [ 1881.295863] CPU 1 
Nov 22 20:19:23 vdr4 kernel: [ 1881.295864] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek speedstep_lib nfsd exportfs nfs lockd fscache auth_rpcgss nfs_acl rc_dvbsky ds3000 lnbp21 sunrpc stv0299 cx25840 ir_lirc_codec lirc_dev snd_hda_intel snd_hda_codec ir_mce_kbd_decoder snd_hwdep ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder ir_nec_decoder cx23885 rc_core snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event cx2341x videobuf_dvb v4l2_common snd_seq dvb_ttpci dvb_core saa7146_vv snd_timer snd_seq_device snd mxm_wmi saa7146 videodev soundcore videobuf_dma_sg videobuf_core v4l2_compat_ioctl32 ttpci_eeprom psmouse snd_page_alloc serio_raw video btcx_risc tveeprom edac_core edac_mce_amd k8temp shpchp i2c_nforce2 lp parport floppy firewire_ohci firewire_core crc_itu_t forcedeth ahci libahci
Nov 22 20:19:23 vdr4 kernel: [ 1881.295910] 
Nov 22 20:19:23 vdr4 kernel: [ 1881.295913] Pid: 0, comm: kworker/0:0 Not tainted 3.1.0-media+ #1 System manufacturer System Product Name/M3N78-EM
Nov 22 20:19:23 vdr4 kernel: [ 1881.295919] RIP: 0010:[<ffffffff8103b14b>]  [<ffffffff8103b14b>] native_safe_halt+0xb/0x10
Nov 22 20:19:23 vdr4 kernel: [ 1881.295928] RSP: 0018:ffff88007432fe88  EFLAGS: 00000246
Nov 22 20:19:23 vdr4 kernel: [ 1881.295931] RAX: 0000000000000000 RBX: ffffffff8101aa95 RCX: 0000000000000000
Nov 22 20:19:23 vdr4 kernel: [ 1881.295934] RDX: 0000000000000000 RSI: ffff88007432fec4 RDI: 0000000000000000
Nov 22 20:19:23 vdr4 kernel: [ 1881.295936] RBP: ffff88007432fe88 R08: 0000000000000000 R09: 0000000000000000
Nov 22 20:19:23 vdr4 kernel: [ 1881.295939] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880077c91200
Nov 22 20:19:23 vdr4 kernel: [ 1881.295941] R13: 00ff880000000000 R14: 0000000000000000 R15: ffff880071760058
Nov 22 20:19:23 vdr4 kernel: [ 1881.295945] FS:  00007fe326c31740(0000) GS:ffff880077c80000(0000) knlGS:0000000000000000
Nov 22 20:19:23 vdr4 kernel: [ 1881.295948] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Nov 22 20:19:23 vdr4 kernel: [ 1881.295951] CR2: 00007fe2fc5efac4 CR3: 0000000071d26000 CR4: 00000000000006e0
Nov 22 20:19:23 vdr4 kernel: [ 1881.295953] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 22 20:19:23 vdr4 kernel: [ 1881.295956] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 22 20:19:23 vdr4 kernel: [ 1881.295959] Process kworker/0:0 (pid: 0, threadinfo ffff88007432e000, task ffff880074330000)
Nov 22 20:19:23 vdr4 kernel: [ 1881.295962] Stack:
Nov 22 20:19:23 vdr4 kernel: [ 1881.295964]  ffff88007432fea8 ffffffff8101b901 ffff88007432fec4 ffffffff81abccc0
Nov 22 20:19:23 vdr4 kernel: [ 1881.295968]  ffff88007432fed8 ffffffff8101b9fd ffff88007432fec8 000000007432e000
Nov 22 20:19:23 vdr4 kernel: [ 1881.295973]  ffff88007432e000 ffffffff81abccc0 ffff88007432ff18 ffffffff81012276
Nov 22 20:19:23 vdr4 kernel: [ 1881.295977] Call Trace:
Nov 22 20:19:23 vdr4 kernel: [ 1881.295983]  [<ffffffff8101b901>] default_idle+0x41/0xe0
Nov 22 20:19:23 vdr4 kernel: [ 1881.295987]  [<ffffffff8101b9fd>] amd_e400_idle+0x5d/0x120
Nov 22 20:19:23 vdr4 kernel: [ 1881.295991]  [<ffffffff81012276>] cpu_idle+0xd6/0x110
Nov 22 20:19:23 vdr4 kernel: [ 1881.295997]  [<ffffffff815dd074>] start_secondary+0x1e0/0x1e7
Nov 22 20:19:23 vdr4 kernel: [ 1881.295999] Code: 55 48 89 e5 66 66 66 66 90 fa c9 c3 0f 1f 40 00 55 48 89 e5 66 66 66 66 90 fb c9 c3 0f 1f 40 00 55 48 89 e5 66 66 66 66 90 fb f4 <c9> c3 0f 1f 00 55 48 89 e5 66 66 66 66 90 f4 c9 c3 0f 1f 40 00 
Nov 22 20:19:23 vdr4 kernel: [ 1881.296047] Call Trace:
Nov 22 20:19:23 vdr4 kernel: [ 1881.296050]  [<ffffffff8101b901>] default_idle+0x41/0xe0
Nov 22 20:19:23 vdr4 kernel: [ 1881.296053]  [<ffffffff8101b9fd>] amd_e400_idle+0x5d/0x120
Nov 22 20:19:23 vdr4 kernel: [ 1881.296057]  [<ffffffff81012276>] cpu_idle+0xd6/0x110
Nov 22 20:19:23 vdr4 kernel: [ 1881.296061]  [<ffffffff815dd074>] start_secondary+0x1e0/0x1e7
Nov 22 20:19:23 vdr4 kernel: [ 1881.296064] bad: scheduling from the idle thread!
Nov 22 20:19:23 vdr4 kernel: [ 1881.296068] Pid: 0, comm: kworker/0:0 Not tainted 3.1.0-media+ #1
Nov 22 20:19:23 vdr4 kernel: [ 1881.296070] Call Trace:
Nov 22 20:19:23 vdr4 kernel: [ 1881.296072]  <IRQ>  [<ffffffff81051dfa>] dequeue_task_idle+0x3a/0x50
Nov 22 20:19:23 vdr4 kernel: [ 1881.296080]  [<ffffffff8104c993>] dequeue_task+0x93/0xb0
Nov 22 20:19:23 vdr4 kernel: [ 1881.296083]  [<ffffffff8104c9d3>] deactivate_task+0x23/0x30
Nov 22 20:19:23 vdr4 kernel: [ 1881.296087]  [<ffffffff815e22d9>] __schedule+0x4c9/0x8a0
Nov 22 20:19:23 vdr4 kernel: [ 1881.296091]  [<ffffffff815e29df>] schedule+0x3f/0x60
Nov 22 20:19:23 vdr4 kernel: [ 1881.296102]  [<ffffffffa017e3b5>] play_video_cb+0x295/0x4f0 [dvb_ttpci]
Nov 22 20:19:23 vdr4 kernel: [ 1881.296107]  [<ffffffff81087030>] ? wake_up_bit+0x40/0x40
Nov 22 20:19:23 vdr4 kernel: [ 1881.296111]  [<ffffffff81059860>] ? try_to_wake_up+0x250/0x2b0
Nov 22 20:19:23 vdr4 kernel: [ 1881.296119]  [<ffffffffa018562d>] send_ipack+0xed/0x250 [dvb_ttpci]
Nov 22 20:19:23 vdr4 kernel: [ 1881.296122]  [<ffffffff810598d2>] ? default_wake_function+0x12/0x20
Nov 22 20:19:23 vdr4 kernel: [ 1881.296130]  [<ffffffffa0185815>] write_ipack+0x85/0xd0 [dvb_ttpci]
Nov 22 20:19:23 vdr4 kernel: [ 1881.296137]  [<ffffffffa0185d6a>] av7110_ipack_instant_repack+0x35a/0x890 [dvb_ttpci]
Nov 22 20:19:23 vdr4 kernel: [ 1881.296144]  [<ffffffffa017cb74>] write_ts_to_decoder+0x74/0xc0 [dvb_ttpci]
Nov 22 20:19:23 vdr4 kernel: [ 1881.296151]  [<ffffffffa017feb9>] av7110_write_to_decoder+0x99/0xf0 [dvb_ttpci]
Nov 22 20:19:23 vdr4 kernel: [ 1881.296163]  [<ffffffffa0155d8c>] dvb_dmx_swfilter_packet+0x1fc/0x5b0 [dvb_core]
Nov 22 20:19:23 vdr4 kernel: [ 1881.296170]  [<ffffffffa01771bd>] ? av7110_debiread+0x4d/0x160 [dvb_ttpci]
Nov 22 20:19:23 vdr4 kernel: [ 1881.296175]  [<ffffffff8103bed9>] ? default_spin_lock_flags+0x9/0x10
Nov 22 20:19:23 vdr4 kernel: [ 1881.296182]  [<ffffffffa01563aa>] dvb_dmx_swfilter_packets+0x5a/0x80 [dvb_core]
Nov 22 20:19:23 vdr4 kernel: [ 1881.296189]  [<ffffffffa01828a9>] debiirq+0x1d9/0x490 [dvb_ttpci]
Nov 22 20:19:23 vdr4 kernel: [ 1881.296193]  [<ffffffff8106ab73>] tasklet_action+0x73/0x120
Nov 22 20:19:23 vdr4 kernel: [ 1881.296197]  [<ffffffff8106b1a8>] __do_softirq+0xa8/0x1c0
Nov 22 20:19:23 vdr4 kernel: [ 1881.296201]  [<ffffffff81033dd6>] ? ack_apic_level+0x76/0x1f0
Nov 22 20:19:23 vdr4 kernel: [ 1881.296206]  [<ffffffff815ef02c>] call_softirq+0x1c/0x30
Nov 22 20:19:23 vdr4 kernel: [ 1881.296210]  [<ffffffff810152b5>] do_softirq+0x65/0xa0
Nov 22 20:19:23 vdr4 kernel: [ 1881.296213]  [<ffffffff8106b53e>] irq_exit+0x8e/0xb0
Nov 22 20:19:23 vdr4 kernel: [ 1881.296217]  [<ffffffff815ef8e6>] do_IRQ+0x66/0xe0
Nov 22 20:19:23 vdr4 kernel: [ 1881.296222]  [<ffffffff815e502e>] common_interrupt+0x6e/0x6e
Nov 22 20:19:23 vdr4 kernel: [ 1881.296224]  <EOI>  [<ffffffff8101aa95>] ? native_sched_clock+0x15/0x70
Nov 22 20:19:23 vdr4 kernel: [ 1881.296230]  [<ffffffff8103b14b>] ? native_safe_halt+0xb/0x10
Nov 22 20:19:23 vdr4 kernel: [ 1881.296233]  [<ffffffff8101b901>] default_idle+0x41/0xe0
Nov 22 20:19:23 vdr4 kernel: [ 1881.296237]  [<ffffffff8101b9fd>] amd_e400_idle+0x5d/0x120
Nov 22 20:19:23 vdr4 kernel: [ 1881.296240]  [<ffffffff81012276>] cpu_idle+0xd6/0x110
Nov 22 20:19:23 vdr4 kernel: [ 1881.296244]  [<ffffffff815dd074>] start_secondary+0x1e0/0x1e7

