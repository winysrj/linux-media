Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:55622 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaLRCN5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Dec 2014 21:13:57 -0500
Received: by mail-ig0-f175.google.com with SMTP id h15so148560igd.8
        for <linux-media@vger.kernel.org>; Wed, 17 Dec 2014 18:13:56 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 17 Dec 2014 19:13:56 -0700
Message-ID: <CAA9z4LZn8wKHw6=F_e8nLQLEDPFVmmaEojv=5Lev3hr6hX3K5Q@mail.gmail.com>
Subject: Prof 7301 issues
From: Chris Lee <updatelee@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The Prof 7301 still seems to be having issues sometimes. Its not every
time, but it does happen fairly regularly.

Dec 17 18:28:16 DVB kernel: [160369.173179] ------------[ cut here ]------------
Dec 17 18:28:16 DVB kernel: [160369.173181] Kernel BUG at
ffffffffa04204fb [verbose debug info unavailable]
Dec 17 18:28:16 DVB kernel: [160369.173181] vb2: __vb2_buf_mem_free:
freed plane 0 of buffer 16
Dec 17 18:28:16 DVB kernel: [160369.173183] invalid opcode: 0000 [#73] SMP
Dec 17 18:28:16 DVB kernel: [160369.173184] Modules linked in:
ddbridge cxd2099(C) stv6110x saa716x_budget tas2101 cxd2820r
Dec 17 18:28:16 DVB kernel: [160369.173187] vb2: __vb2_buf_mem_free:
freed plane 0 of buffer 17
Dec 17 18:28:16 DVB kernel: [160369.173188]  mb86a16 saa716x_core
cx24117 dvb_usb_tbsqbox2ci dvb_usb_gp8psk cx23885 altera_ci tda18271
Dec 17 18:28:16 DVB kernel: [160369.173191] vb2: __vb2_buf_mem_free:
freed plane 0 of buffer 18
Dec 17 18:28:16 DVB kernel: [160369.173192]  altera_stapl
dvb_usb_dw2102 dvb_usb stb6100 stv090x cx88_dvb cx88_vp3054_i2c cx8802
Dec 17 18:28:16 DVB kernel: [160369.173195] vb2: __vb2_buf_mem_free:
freed plane 0 of buffer 19
Dec 17 18:28:16 DVB kernel: [160369.173196]  cx88xx videobuf2_dvb
videobuf2_core videobuf2_dma_sg videobuf2_memops
Dec 17 18:28:16 DVB kernel: [160369.173198] vb2: __vb2_buf_mem_free:
freed plane 0 of buffer 20
Dec 17 18:28:16 DVB kernel: [160369.173198]  cx231xx_dvb cx231xx
videobuf_vmalloc cx2341x videobuf_core i2c_mux lgdt3305
dvb_usb_mxl111sf
Dec 17 18:28:16 DVB kernel: [160369.173202] vb2: __vb2_buf_mem_free:
freed plane 0 of buffer 21
Dec 17 18:28:16 DVB kernel: [160369.173203]  dvb_usb_v2 rc_core
tuner_xc2028 s5h1409 em28xx_dvb em28xx v4l2_common videodev xc5000
au8522_dig au8522_common au0828 tveeprom
Dec 17 18:28:16 DVB kernel: [160369.173207] vb2: __vb2_buf_mem_free:
freed plane 0 of buffer 22
Dec 17 18:28:16 DVB kernel: [160369.173208]  dvb_core pci_stub vboxpci(O)
Dec 17 18:28:16 DVB kernel: [160369.173210] vb2: __vb2_buf_mem_free:
freed plane 0 of buffer 23
Dec 17 18:28:16 DVB kernel: [160369.173210]  vboxnetadp(O) vboxnetflt(O)
Dec 17 18:28:16 DVB kernel: [160369.173212] vb2: __vb2_buf_mem_free:
freed plane 0 of buffer 24
Dec 17 18:28:16 DVB kernel: [160369.173213]  vboxdrv(O)
Dec 17 18:28:16 DVB kernel: [160369.173213] vb2: __vb2_buf_mem_free:
freed plane 0 of buffer 25
Dec 17 18:28:16 DVB kernel: [160369.173214]  nf_conntrack_ipv4
Dec 17 18:28:16 DVB kernel: [160369.173215] vb2: __vb2_buf_mem_free:
freed plane 0 of buffer 26
Dec 17 18:28:16 DVB kernel: [160369.173216]  nf_defrag_ipv4
xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp
iptable_filter ip_tables x_tables bridge stp llc mxl111sf_tuner
Dec 17 18:28:16 DVB kernel: [160369.173221] vb2: __vb2_buf_mem_free:
freed plane 0 of buffer 27
Dec 17 18:28:16 DVB kernel: [160369.173222]  lg2160 mxl111sf_demod
snd_usb_audio snd_usbmidi_lib
Dec 17 18:28:16 DVB kernel: [160369.173224] vb2: __vb2_buf_mem_free:
freed plane 0 of buffer 28
Dec 17 18:28:16 DVB kernel: [160369.173224]  mxm_wmi i915
Dec 17 18:28:16 DVB kernel: [160369.173225] vb2: __vb2_buf_mem_free:
freed plane 0 of buffer 29
Dec 17 18:28:16 DVB kernel: [160369.173226]  snd_hda_codec_hdmi
x86_pkg_temp_thermal
Dec 17 18:28:16 DVB kernel: [160369.173228] vb2: __vb2_buf_mem_free:
freed plane 0 of buffer 30
Dec 17 18:28:16 DVB kernel: [160369.173228]  kvm_intel lnbp21 snd_hda_codec_via
Dec 17 18:28:16 DVB kernel: [160369.173230] vb2: __vb2_buf_mem_free:
freed plane 0 of buffer 31
Dec 17 18:28:16 DVB kernel: [160369.173230]  snd_hda_codec_generic kvm
rfcomm bnep snd_hda_intel bluetooth snd_hda_controller snd_hda_codec
snd_hwdep snd_pcm ghash_clmulni_intel nfsd aesni_intel snd_seq_midi
aes_x86_64 snd_seq_midi_event lrw snd_rawmidi gf128mul glue_helper
snd_seq drm_kms_helper ablk_helper cryptd snd_seq_device drm microcode
snd_timer snd serio_raw auth_rpcgss lpc_ich soundcore tpm_infineon wmi
tpm_tis video oid_registry nfs_acl mac_hid nfs shpchp i2c_algo_bit
lockd grace sunrpc parport_pc ppdev fscache binfmt_misc it87 hwmon_vid
coretemp lp parport nls_iso8859_1 hid_generic usbhid hid psmouse ahci
alx libahci mdio [last unloaded: tuner_xc2028]
Dec 17 18:28:16 DVB kernel: [160369.173263] CPU: 2 PID: 5133 Comm:
vb2-cx88[0] Tainted: G      D  C O   3.18.0-rc4+ #1
Dec 17 18:28:16 DVB kernel: [160369.173264] Hardware name: Gigabyte
Technology Co., Ltd. To be filled by O.E.M./Z77X-UD3H, BIOS F20e
01/06/2014
Dec 17 18:28:16 DVB kernel: [160369.173265] task: ffff880403e21900 ti:
ffff880404c9c000 task.ti: ffff880404c9c000
Dec 17 18:28:16 DVB kernel: [160369.173266] RIP:
0010:[<ffffffffa04204fb>]  [<ffffffffa04204fb>]
cx88_risc_databuffer+0x10b/0x160 [cx88xx]
Dec 17 18:28:16 DVB kernel: [160369.173272] RSP: 0018:ffff880404c9fd28
 EFLAGS: 00010206
Dec 17 18:28:16 DVB kernel: [160369.173274] RAX: 0000000000000000 RBX:
ffff880402461360 RCX: 0000000000000118
Dec 17 18:28:16 DVB kernel: [160369.173275] RDX: 0000000000000000 RSI:
ffff8803f2324740 RDI: ffff8803f2324760
Dec 17 18:28:16 DVB kernel: [160369.173276] RBP: ffff880404c9fd78 R08:
00000000000002f0 R09: 0000000000000000
Dec 17 18:28:16 DVB kernel: [160369.173277] R10: ffffffff81a73715 R11:
ffffea0000dcb540 R12: 0000000000000020
Dec 17 18:28:16 DVB kernel: [160369.173278] R13: 00000000000002f0 R14:
ffff8803f2324740 R15: 0000000000000000
Dec 17 18:28:16 DVB kernel: [160369.173279] FS:
0000000000000000(0000) GS:ffff88041f280000(0000)
knlGS:0000000000000000
Dec 17 18:28:16 DVB kernel: [160369.173280] CS:  0010 DS: 0000 ES:
0000 CR0: 0000000080050033
Dec 17 18:28:16 DVB kernel: [160369.173281] CR2: 00007fffb80c6000 CR3:
00000004066d7000 CR4: 00000000001407e0
Dec 17 18:28:16 DVB kernel: [160369.173282] Stack:
Dec 17 18:28:16 DVB kernel: [160369.173283]  ffff880400000020
ffffffff00000000 ffff880400000001 01ffffff8109706e
Dec 17 18:28:16 DVB kernel: [160369.173285]  0000000000000002
ffff880402461000 ffff8803f2882000 0000000000005e00
Dec 17 18:28:16 DVB kernel: [160369.173286]  ffff880402461360
ffff8803f2884828 ffff880404c9fdd8 ffffffffa043b2c0
Dec 17 18:28:16 DVB kernel: [160369.173288] Call Trace:
Dec 17 18:28:16 DVB kernel: [160369.173292]  [<ffffffffa043b2c0>]
cx8802_buf_prepare+0x80/0x170 [cx8802]
Dec 17 18:28:16 DVB kernel: [160369.173296]  [<ffffffffa044106c>]
buffer_prepare+0x1c/0x20 [cx88_dvb]
Dec 17 18:28:16 DVB kernel: [160369.173299]  [<ffffffffa03ed915>]
__buf_prepare+0x2b5/0x320 [videobuf2_core]
Dec 17 18:28:16 DVB kernel: [160369.173303]  [<ffffffffa03ee02b>]
vb2_internal_qbuf+0x1fb/0x250 [videobuf2_core]
Dec 17 18:28:16 DVB kernel: [160369.173306]  [<ffffffffa03ee171>]
vb2_thread+0xf1/0x270 [videobuf2_core]
Dec 17 18:28:16 DVB kernel: [160369.173309]  [<ffffffffa03ee080>] ?
vb2_internal_qbuf+0x250/0x250 [videobuf2_core]
Dec 17 18:28:16 DVB kernel: [160369.173313]  [<ffffffff8106f4db>]
kthread+0xdb/0x100
Dec 17 18:28:16 DVB kernel: [160369.173315]  [<ffffffff8106f400>] ?
kthread_create_on_node+0x180/0x180
Dec 17 18:28:16 DVB kernel: [160369.173319]  [<ffffffff8173c62c>]
ret_from_fork+0x7c/0xb0
Dec 17 18:28:16 DVB kernel: [160369.173321]  [<ffffffff8106f400>] ?
kthread_create_on_node+0x180/0x180
Dec 17 18:28:16 DVB kernel: [160369.173322] Code: 44 24 10 45 89 e8 4c
89 f6 e8 92 ec ff ff 8b 13 48 89 43 10 48 2b 43 08 48 c1 f8 02 48 8d
0c 85 08 00 00 00 31 c0 48 39 d1 76 12 <0f> 0b 0f 1f 00 48 c7 46 08 00
00 00 00 b8 f4 ff ff ff 48 83 c4
Dec 17 18:28:16 DVB kernel: [160369.173340] RIP  [<ffffffffa04204fb>]
cx88_risc_databuffer+0x10b/0x160 [cx88xx]
Dec 17 18:28:16 DVB kernel: [160369.173344]  RSP <ffff880404c9fd28>
Dec 17 18:28:16 DVB kernel: [160369.173346] ---[ end trace 3a3edb07e8581eaf ]---

Chris Lee
