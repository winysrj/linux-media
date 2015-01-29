Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:45970 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751350AbbA2HSF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2015 02:18:05 -0500
Message-ID: <54C9DE8A.5040608@xs4all.nl>
Date: Thu, 29 Jan 2015 08:17:30 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Nick Burrett <nick@sqrt.co.uk>, linux-media@vger.kernel.org
Subject: Re: TBS6981/vb2-cx23885 kernel oops
References: <CAKDxb-rbjS08v7hDFRMQc8VXHDPRjyRKLb_r=3-zXSU6_UHP_g@mail.gmail.com>
In-Reply-To: <CAKDxb-rbjS08v7hDFRMQc8VXHDPRjyRKLb_r=3-zXSU6_UHP_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/28/2015 01:01 PM, Nick Burrett wrote:
> The following are 3 samples of kernel messages that I am getting on a
> fairly regular basis, which seem to have started occurring since the
> cx23885 vb2 conversion. I am using the
> https://github.com/ljalves/linux_media tree from 16 Jan 2015

That's too old. You need to upgrade as you need the version that has
this important fix:

https://github.com/ljalves/linux_media/commit/6cf11ee6300f38b7cfc43af9b7be2afaa5e05869

After upgrading, please try again and let me know the results. My
understanding is that this fixes the crashes, but that there are still
'UNBALANCED' reports and 'mpeg_risc op error' messages. Unfortunately,
I seem unable to reproduce this, so the more information I get about
this, the better it is.

Regards,

	Hans

> 
> I have a TBS6985 and a TBS6981 card present in the machine. The
> TBS6985 is working fine. The kernel messages are triggered by VDR's
> idle scanning which it done using the TBS6981.
> 
> [16795.690383] BUG: Bad page state in process vb2-cx23885[0] pfn:36bd1
> [16795.690387] page:ffffea0000daf440 count:-1 mapcount:0 mapping:
> (null) index:0x0
> [16795.690389] flags: 0x1ffff0000000000()
> [16795.690390] page dumped because: nonzero _count
> [16795.690391] Modules linked in: rfcomm bluetooth iptable_mangle
> xt_DSCP ip_tables x_tables ir_jvc_decoder(OE) ir_lirc_codec(OE)
> lirc_dev(OE) ir_xmp_decoder(OE) ir_sony_decoder(OE)
> ir_sanyo_decoder(OE) ir_sharp_decoder(OE) ir_rc6_decoder(OE)
> ir_rc5_decoder(OE) ir_nec_decoder(OE) ir_mce_kbd_decoder(OE)
> rc_tbs_nec(OE) cx25840(OE) binfmt_misc rc_dib0700_rc5(OE) dib7000p(OE)
> cx23885(OE) altera_ci(OE) tda18271(OE) altera_stapl(OE)
> snd_hda_codec_hdmi videobuf2_dvb(OE) tveeprom(OE)
> snd_hda_codec_realtek av201x(OE) intel_rapl cx2341x(OE)
> x86_pkg_temp_thermal intel_powerclamp videobuf2_dma_sg(OE)
> videobuf2_memops(OE) coretemp videobuf2_core(OE) kvm
> snd_hda_codec_generic v4l2_common(OE) snd_hda_intel snd_hda_controller
> snd_hda_codec videodev(OE) crct10dif_pclmul crc32_pclmul
> saa716x_budget(OE) ghash_clmulni_intel snd_hwdep media(OE) snd_pcm
> i915 aesni_intel dvb_usb_dib0700(OE) tas2101(OE) aes_x86_64
> dib9000(OE) dib7000m(OE) dib0090(OE) dib0070(OE)
> [16795.690421] vb2: counters for queue ffff880227c55828: UNBALANCED!
> [16795.690422] cxd2820r(OE) dib3000mc(OE) lrw video
> [16795.690425] vb2: setup: 1 start_streaming: 1 stop_streaming: 1
> [16795.690426] vb2: wait_prepare: 10464 wait_finish: 10465
> [16795.690427] vb2: counters for queue ffff880227c55828, buffer 31: UNBALANCED!
> [16795.690429] vb2: buf_init: 1 buf_cleanup: 1 buf_prepare: 109 buf_finish: 110
> [16795.690429] vb2: buf_queue: 109 buf_done: 109
> [16795.690430] vb2: alloc: 1 put: 1 prepare: 109 finish: 109 mmap: 0
> [16795.690431] vb2: get_userptr: 0 put_userptr: 0
> [16795.690432] vb2: attach_dmabuf: 0 detach_dmabuf: 0 map_dmabuf: 0
> unmap_dmabuf: 0
> [16795.690433] vb2: get_dmabuf: 0 num_users: 0 vaddr: 110 cookie: 110
> [16795.690434] gpio_ich drm_kms_helper snd_seq_midi snd_seq_midi_event
> snd_rawmidi gf128mul dibx000_common(OE) mb86a16(OE) snd_seq
> glue_helper snd_seq_device lp cx24117(OE) mei_me snd_timer dvb_usb(OE)
> drm ablk_helper rc_core(OE) parport saa716x_core(OE) lpc_ich snd mei
> dvb_core(OE) soundcore i2c_algo_bit i2c_mux serio_raw cryptd mac_hid
> psmouse ahci r8169 libahci mii
> [16795.690452] CPU: 1 PID: 16771 Comm: vb2-cx23885[0] Tainted: G OE
> 3.18.1-ickle75+ #1
> [16795.690453] Hardware name: Shuttle SH67H3/FH67, BIOS 4.6.4 03/22/2011
> [16795.690454] ffffffff81aad259 ffff880231493a48 ffffffff817781fd
> 0000000000000000
> [16795.690456] ffffea0000daf440 ffff880231493a78 ffffffff81774bcc
> ffffea0000daf440
> [16795.690458] 0000000000000141 0000000000000200 ffff88023fdf4780
> ffff880231493b68
> [16795.690459] Call Trace:
> [16795.690465] [] dump_stack+0x46/0x58
> [16795.690468] [] bad_page.part.50+0xe0/0xfe
> [16795.690471] [] get_page_from_freelist+0x873/0x9e0
> [16795.690474] [] ? select_idle_sibling+0x2b/0x120
> [16795.690498] [] __alloc_pages_nodemask+0x15f/0xa50
> [16795.690501] [] ? try_to_wake_up+0x1e4/0x330
> [16795.690505] [] dma_generic_alloc_coherent+0xa4/0x160
> [16795.690508] [] x86_swiotlb_alloc_coherent+0x21/0x50
> [16795.690513] [] cx23885_risc_databuffer+0xb2/0x170 [cx23885]
> [16795.690519] [] ? dvb_dmx_swfilter_section_copy_dump+0x1f1/0x250 [dvb_core]
> [16795.690522] [] cx23885_buf_prepare+0x7f/0xd0 [cx23885]
> [16795.690526] [] buffer_prepare+0x19/0x20 [cx23885]
> [16795.690529] [] __buf_prepare+0x27e/0x390 [videobuf2_core]
> [16795.690532] [] vb2_internal_qbuf+0x7b/0x240 [videobuf2_core]
> [16795.690535] [] vb2_thread+0x10e/0x480 [videobuf2_core]
> [16795.690538] [] ? vb2_internal_qbuf+0x240/0x240 [videobuf2_core]
> [16795.690540] [] kthread+0xd2/0xf0
> [16795.690542] [] ? kthread_create_on_node+0x180/0x180
> [16795.690545] [] ret_from_fork+0x7c/0xb0
> [16795.690547] [] ? kthread_create_on_node+0x180/0x180
> [16795.690548] Disabling lock debugging due to kernel taint
> 
> 
> 
> [129577.894551] BUG: unable to handle kernel NULL pointer dereference
> at 0000000000000058
> [129577.896227] IP: [] vb2_thread+0x17a/0x480 [videobuf2_core]
> [129577.897858] PGD 0
> [129577.899451] Oops: 0002 [#6] SMP
> [129577.901033] Modules linked in: rfcomm bluetooth iptable_mangle
> xt_DSCP ip_tables x_tables ir_jvc_decoder(OE) ir_lirc_codec(OE)
> lirc_dev(OE) ir_x
> mp_decoder(OE) ir_sony_decoder(OE) ir_sanyo_decoder(OE)
> ir_sharp_decoder(OE) ir_rc6_decoder(OE) ir_rc5_decoder(OE)
> ir_nec_decoder(OE) ir_mce_kbd_dec
> oder(OE) rc_tbs_nec(OE) cx25840(OE) binfmt_misc rc_dib0700_rc5(OE)
> dib7000p(OE) cx23885(OE) altera_ci(OE) tda18271(OE) altera_stapl(OE)
> snd_hda_code
> c_hdmi videobuf2_dvb(OE) tveeprom(OE) snd_hda_codec_realtek av201x(OE)
> intel_rapl cx2341x(OE) x86_pkg_temp_thermal intel_powerclamp
> videobuf2_dma_sg
> (OE) videobuf2_memops(OE) coretemp videobuf2_core(OE) kvm
> snd_hda_codec_generic v4l2_common(OE) snd_hda_intel snd_hda_controller
> snd_hda_codec video
> dev(OE) crct10dif_pclmul crc32_pclmul saa716x_budget(OE)
> ghash_clmulni_intel snd_hwdep media(OE) snd_pcm i915 aesni_intel
> dvb_usb_dib0700(OE) tas210
> 1(OE) aes_x86_64 dib9000(OE) dib7000m(OE) dib0090(OE) dib0070(OE)
> cxd2820r(OE) dib3000mc(OE) lrw video gpio_ich drm_kms_helper
> snd_seq_midi snd_seq_
> midi_event snd_rawmidi gf128mul dibx000_common(OE) mb86a16(OE) snd_seq
> glue_helper snd_seq_device lp cx24117(OE) mei_me snd_timer dvb_usb(OE)
> drm ab
> lk_helper rc_core(OE) parport saa716x_core(OE) lpc_ich snd mei
> dvb_core(OE) soundcore i2c_algo_bit i2c_mux serio_raw cryptd mac_hid
> psmouse ahci r81
> 69 libahci mii
> [129577.911617] CPU: 0 PID: 11837 Comm: vb2-cx23885[0] Tainted: G B D
> OE 3.18.1-ickle75+ #1
> [129577.913452] Hardware name: Shuttle SH67H3/FH67, BIOS 4.6.4 03/22/2011
> [129577.915308] task: ffff880228249e00 ti: ffff8802310d0000 task.ti:
> ffff8802310d0000
> [129577.917139] RIP: 0010:[] [] vb2_thread+0x17a/0x480 [videobuf2_core]
> [129577.918983] RSP: 0018:ffff8802310d3e48 EFLAGS: 00010246
> [129577.920817] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
> 000000000000000b
> [129577.922654] RDX: 0000000000000058 RSI: ffff880228249e00 RDI:
> 0000000000000058
> [129577.924485] RBP: ffff8802310d3eb8 R08: ffff8802310d0000 R09:
> 0000000000000000
> [129577.926316] R10: ffff88021b17beb8 R11: 00000000000003ff R12:
> 0000000000000058
> [129577.928149] R13: ffff8800b130f6c0 R14: 0000000000000000 R15:
> ffff880227c56028
> [129577.929976] FS: 0000000000000000(0000) GS:ffff88023fa00000(0000)
> knlGS:0000000000000000
> [129577.931807] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [129577.933635] CR2: 0000000000000058 CR3: 0000000001c16000 CR4:
> 00000000000407f0
> [129577.935472] Stack:
> [129577.937296] ffff880228249e00 ffff880228249e00 0000000000000070
> 0000000000013680
> [129577.939144] 0000000000000000 ffff880200000000 0000000000000292
> ffff88023353d680
> [129577.940935] ffff880227c56028 ffff88023353d680 ffff880227c56028
> ffffffffc0462200
> [129577.942671] Call Trace:
> [129577.944392] [] ? vb2_internal_qbuf+0x240/0x240 [videobuf2_core]
> [129577.946134] [] kthread+0xd2/0xf0
> [129577.947862] [] ? kthread_create_on_node+0x180/0x180
> [129577.949588] [] ret_from_fork+0x7c/0xb0
> [129577.951306] [] ? kthread_create_on_node+0x180/0x180
> [129577.953034] Code: 89 e7 ba 58 00 00 00 0f 85 94 01 00 00 40 f6 c7
> 02 0f 85 72 01 00 00 40 f6 c7 04 0f 85 50 01 00 00 89 d1 31 c0 c1 e9
> 03 f6 c2
> 04 48 ab 74 0a c7 07 00 00 00 00 48 83 c7 04 f6 c2 02 74 0a 31
> [129577.954898] RIP [] vb2_thread+0x17a/0x480 [videobuf2_core]
> [129577.956659] RSP
> [129577.958370] CR2: 0000000000000058
> [129577.967313] ---[ end trace 78ca5e4a2591960e ]---
> 
> 
> 
> [132180.785645] cx23885[0]: mpeg risc op code error
> [132180.785653] cx23885[0]: TS2 C - dma channel status dump
> [132180.785657] cx23885[0]: cmds: init risc lo : 0x3691c000
> [132180.785662] cx23885[0]: cmds: init risc hi : 0x00000000
> [132180.785665] cx23885[0]: cmds: cdt base : 0x000105e0
> [132180.785668] cx23885[0]: cmds: cdt size : 0x0000000a
> [132180.785671] cx23885[0]: cmds: iq base : 0x00010440
> [132180.785674] cx23885[0]: cmds: iq size : 0x00000010
> [132180.785684] cx23885[0]: cmds: risc pc lo : 0x3691c020
> [132180.785687] cx23885[0]: cmds: risc pc hi : 0x00000000
> [132180.785689] cx23885[0]: cmds: iq wr ptr : 0x00004118
> [132180.785691] cx23885[0]: cmds: iq rd ptr : 0x00004110
> [132180.785693] cx23885[0]: cmds: cdt current : 0x000105f8
> [132180.785695] cx23885[0]: cmds: pci target lo : 0x079402f0
> [132180.785697] cx23885[0]: cmds: pci target hi : 0x00000000
> [132180.785699] cx23885[0]: cmds: line / byte : 0x03810000
> [132180.785701] cx23885[0]: risc0: 0x1c0002f0 [ write sol eol count=752 ]
> [132180.785706] cx23885[0]: risc1: 0x079402f0 [ INVALID eol irq2 irq1
> 23 20 18 count=752 ]
> [132180.785711] cx23885[0]: risc2: 0x00000000 [ INVALID count=0 ]
> [132180.785713] cx23885[0]: risc3: 0x1c0002f0 [ write sol eol count=752 ]
> [132180.785717] cx23885[0]: (0x00010440) iq 0: 0x137cb002 [ write irq2
> irq1 22 21 20 19 18 resync 13 12 count=2 ]
> [132180.785722] cx23885[0]: iq 1: 0x0000c1f3 [ arg #1 ]
> [132180.785725] cx23885[0]: iq 2: 0x06f0feff [ arg #2 ]
> [132180.785727] cx23885[0]: (0x0001044c) iq 3: 0xb480040c [ writerm
> eol 23 count=1036 ]
> [132180.785730] cx23885[0]: iq 4: 0xe2026881 [ arg #1 ]
> [132180.785732] cx23885[0]: iq 5: 0x5210f004 [ arg #2 ]
> [132180.785734] cx23885[0]: (0x00010458) iq 6: 0x03020401 [ INVALID
> irq2 irq1 cnt1 count=1025 ]
> [132180.785738] cx23885[0]: (0x0001045c) iq 7: 0x065f481a [ INVALID
> eol irq2 22 20 19 18 cnt1 cnt0 14 count=2074 ]
> [132180.785743] cx23885[0]: (0x00010460) iq 8: 0x00000000 [ INVALID count=0 ]
> [132180.785746] cx23885[0]: (0x00010464) iq 9: 0x1c0002f0 [ write sol
> eol count=752 ]
> [132180.785749] cx23885[0]: iq a: 0x07940bc0 [ arg #1 ]
> [132180.785751] cx23885[0]: iq b: 0x00000000 [ arg #2 ]
> [132180.785753] cx23885[0]: (0x00010470) iq c: 0x71000000 [ jump irq1 count=0 ]
> [132180.785756] cx23885[0]: iq d: 0x1c0002f0 [ arg #1 ]
> [132180.785759] cx23885[0]: iq e: 0x07940000 [ arg #2 ]
> [132180.785761] cx23885[0]: (0x0001047c) iq f: 0x00000000 [ INVALID count=0 ]
> [132180.785762] cx23885[0]: fifo: 0x00006000 -> 0x7000
> [132180.785763] cx23885[0]: ctrl: 0x00010440 -> 0x104a0
> [132180.785765] cx23885[0]: ptr1_reg: 0x00006310
> [132180.785767] cx23885[0]: ptr2_reg: 0x000105f8
> [132180.785769] cx23885[0]: cnt1_reg: 0x00000002
> [132180.785771] cx23885[0]: cnt2_reg: 0x00000007
> 
> 
> 
> 00:00.0 Host bridge: Intel Corporation 2nd Generation Core Processor
> Family DRAM Controller (rev 09)
> 00:01.0 PCI bridge: Intel Corporation Xeon E3-1200/2nd Generation Core
> Processor Family PCI Express Root Port (rev 09)
> 00:02.0 VGA compatible controller: Intel Corporation 2nd Generation
> Core Processor Family Integrated Graphics Controller (rev 09)
> 00:16.0 Communication controller: Intel Corporation 6 Series/C200
> Series Chipset Family MEI Controller#1 (rev 04)
> 00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset
> Family USB Enhanced Host Controller #2 (rev 05)
> 00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset
> Family High Definition Audio Controller (rev 05)
> 00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
> Family PCI Express Root Port 1 (rev b5)
> 00:1c.1 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
> Family PCI Express Root Port 2 (rev b5)
> 00:1c.2 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
> Family PCI Express Root Port 3 (rev b5)
> 00:1c.3 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
> Family PCI Express Root Port 4 (rev b5)
> 00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset
> Family PCI Express Root Port 5 (rev b5)
> 00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset
> Family USB Enhanced Host Controller #1 (rev 05)
> 00:1f.0 ISA bridge: Intel Corporation H67 Express Chipset Family LPC
> Controller (rev 05)
> 00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series
> Chipset Family SATA AHCI Controller (rev 05)
> 00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family
> SMBus Controller (rev 05)
> 01:00.0 Multimedia video controller: Conexant Systems, Inc. CX23885
> PCI Video and Audio Decoder (rev 04)
> 03:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB
> Host Controller
> 04:00.0 USB controller: ASMedia Technology Inc. ASM1042 SuperSpeed USB
> Host Controller
> 05:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
> 06:00.0 Multimedia controller: Philips Semiconductors SAA7160 (rev 02)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

