Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:40646 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaLXX6E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Dec 2014 18:58:04 -0500
Received: by mail-ie0-f176.google.com with SMTP id tr6so8268407ieb.35
        for <linux-media@vger.kernel.org>; Wed, 24 Dec 2014 15:58:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA9z4LZn8wKHw6=F_e8nLQLEDPFVmmaEojv=5Lev3hr6hX3K5Q@mail.gmail.com>
References: <CAA9z4LZn8wKHw6=F_e8nLQLEDPFVmmaEojv=5Lev3hr6hX3K5Q@mail.gmail.com>
Date: Wed, 24 Dec 2014 16:58:02 -0700
Message-ID: <CAA9z4Lb5PkGhs5EYyVyoLbpmNi-TbnFmfxhgpCMDNQFKD+1SxQ@mail.gmail.com>
Subject: Re: Prof 7301 issues
From: Chris Lee <updatelee@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Similar issue, invalid op code, different location

Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450620] ------------[ cut here ]------------
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450626] Kernel BUG at ffffffffa03375b3 [verbose debug info
unavailable]
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450629] invalid opcode: 0000 [#1] SMP
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450632] Modules linked in: dvb_usb_tbsqbox2ci dvb_usb stb6100
cx88_dvb snd_hda_codec_generic stv090x cx88_vp3054_i2c videobuf2_dvb
dvb_core snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep
snd_pcm kvm_intel snd_seq_midi snd_seq_midi_event kvm
ghash_clmulni_intel snd_rawmidi cx8800 cx8802 cx88xx aesni_intel
videobuf2_core aes_x86_64 lrw snd_seq videobuf2_dma_sg gf128mul
videobuf2_memops glue_helper tveeprom ablk_helper rc_core v4l2_common
snd_seq_device cryptd dm_multipath videodev snd_timer scsi_dh
i2c_algo_bit microcode virtio_balloon snd serio_raw soundcore
virtio_console i2c_piix4 bnep rfcomm bluetooth mac_hid parport_pc
ppdev binfmt_misc lp parport dm_mirror dm_region_hash dm_log psmouse
vmwgfx ttm drm_kms_helper drm floppy
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450669] CPU: 5 PID: 3872 Comm: vb2-cx88[0] Not tainted
3.19.0-rc1+ #1
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450672] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.7.5-20140531_171129-lamiak 04/01/2014
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450673] task: ffff8800b9aacaa0 ti: ffff88022beb0000 task.ti:
ffff88022beb0000
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450675] RIP: 0010:[<ffffffffa03375b3>]  [<ffffffffa03375b3>]
cx88_risc_databuffer+0x153/0x170 [cx88xx]
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450682] RSP: 0018:ffff88022beb3d18  EFLAGS: 00010206
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450684] RAX: 0000000000000000 RBX: ffff88022ef68760 RCX:
00000000000004f0
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450686] RDX: 0000000000000118 RSI: ffff8801dc23ba40 RDI:
ffff8801dc23ba60
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450687] RBP: ffff88022beb3d68 R08: 00000000000002f0 R09:
0000000000000000
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450688] R10: 0000000000000000 R11: ffffea0002eb7640 R12:
0000000000000020
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450690] R13: ffff8801dc23ba40 R14: 00000000000002f0 R15:
0000000000000000
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450696] FS:  0000000000000000(0000) GS:ffff880239d40000(0000)
knlGS:0000000000000000
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450698] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450702] CR2: 00007f496996f000 CR3: 00000000bb0c2000 CR4:
00000000001406e0
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450703] Stack:
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450704]  ffff880200000020 ffffffff00000000 ffff880200000001
ffffffff810098a5
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450707]  ffff88022beb3d78 ffff88022ef68400 ffff88022e86a000
0000000000005e00
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450710]  ffff88022ef68760 ffff88022d7d6828 ffff88022beb3dc8
ffffffffa02aa2bb
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450713] Call Trace:
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450720]  [<ffffffff810098a5>] ?
dma_generic_free_coherent+0x25/0x30
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450725]  [<ffffffffa02aa2bb>] cx8802_buf_prepare+0x7b/0x170
[cx8802]
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450729]  [<ffffffffa040206c>] buffer_prepare+0x1c/0x20 [cx88_dvb]
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450734]  [<ffffffffa02549e5>] __buf_prepare+0x275/0x330
[videobuf2_core]
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450739]  [<ffffffffa0254fdb>] vb2_internal_qbuf+0x7b/0x240
[videobuf2_core]
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450743]  [<ffffffffa0255289>] vb2_thread+0xe9/0x260
[videobuf2_core]
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450747]  [<ffffffffa02551a0>] ? vb2_internal_qbuf+0x240/0x240
[videobuf2_core]
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450752]  [<ffffffff810745d2>] kthread+0xd2/0xf0
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450755]  [<ffffffff81074500>] ?
kthread_create_on_node+0x180/0x180
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450760]  [<ffffffff817360ec>] ret_from_fork+0x7c/0xb0
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450764]  [<ffffffff81074500>] ?
kthread_create_on_node+0x180/0x180
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450765] Code: 48 83 c4 28 b8 f4 ff ff ff 5b 41 5c 41 5d 41 5e 41
5f 5d c3 0f 1f 40 00 48 8b 05 91 46 8e e1 49 c7 c2 80 b9 c1 81 e9 13
ff ff ff <0f> 0b b9 ff ff ff ff 48 39 f9 19 c9 83 e1 fc 81 c1 24 80 00
00
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450792] RIP  [<ffffffffa03375b3>]
cx88_risc_databuffer+0x153/0x170 [cx88xx]
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450797]  RSP <ffff88022beb3d18>
Dec 24 14:12:48 updatelee-Standard-PC-i440FX-PIIX-1996 kernel: [
2516.450800] ---[ end trace 2c57dfb5f014bb45 ]---

It doesnt happen right away, but after repeated switching between pes
and sct filters without closing the dvr and demux I get this. Closing
the dvr and demux each time resolves the issue, but I shouldnt have
to. I dont have to with other devices.

Chris Lee

On Wed, Dec 17, 2014 at 7:13 PM, Chris Lee <updatelee@gmail.com> wrote:
> The Prof 7301 still seems to be having issues sometimes. Its not every
> time, but it does happen fairly regularly.
>
> Dec 17 18:28:16 DVB kernel: [160369.173179] ------------[ cut here ]------------
> Dec 17 18:28:16 DVB kernel: [160369.173181] Kernel BUG at
> ffffffffa04204fb [verbose debug info unavailable]
> Dec 17 18:28:16 DVB kernel: [160369.173181] vb2: __vb2_buf_mem_free:
> freed plane 0 of buffer 16
> Dec 17 18:28:16 DVB kernel: [160369.173183] invalid opcode: 0000 [#73] SMP
> Dec 17 18:28:16 DVB kernel: [160369.173184] Modules linked in:
> ddbridge cxd2099(C) stv6110x saa716x_budget tas2101 cxd2820r
> Dec 17 18:28:16 DVB kernel: [160369.173187] vb2: __vb2_buf_mem_free:
> freed plane 0 of buffer 17
> Dec 17 18:28:16 DVB kernel: [160369.173188]  mb86a16 saa716x_core
> cx24117 dvb_usb_tbsqbox2ci dvb_usb_gp8psk cx23885 altera_ci tda18271
> Dec 17 18:28:16 DVB kernel: [160369.173191] vb2: __vb2_buf_mem_free:
> freed plane 0 of buffer 18
> Dec 17 18:28:16 DVB kernel: [160369.173192]  altera_stapl
> dvb_usb_dw2102 dvb_usb stb6100 stv090x cx88_dvb cx88_vp3054_i2c cx8802
> Dec 17 18:28:16 DVB kernel: [160369.173195] vb2: __vb2_buf_mem_free:
> freed plane 0 of buffer 19
> Dec 17 18:28:16 DVB kernel: [160369.173196]  cx88xx videobuf2_dvb
> videobuf2_core videobuf2_dma_sg videobuf2_memops
> Dec 17 18:28:16 DVB kernel: [160369.173198] vb2: __vb2_buf_mem_free:
> freed plane 0 of buffer 20
> Dec 17 18:28:16 DVB kernel: [160369.173198]  cx231xx_dvb cx231xx
> videobuf_vmalloc cx2341x videobuf_core i2c_mux lgdt3305
> dvb_usb_mxl111sf
> Dec 17 18:28:16 DVB kernel: [160369.173202] vb2: __vb2_buf_mem_free:
> freed plane 0 of buffer 21
> Dec 17 18:28:16 DVB kernel: [160369.173203]  dvb_usb_v2 rc_core
> tuner_xc2028 s5h1409 em28xx_dvb em28xx v4l2_common videodev xc5000
> au8522_dig au8522_common au0828 tveeprom
> Dec 17 18:28:16 DVB kernel: [160369.173207] vb2: __vb2_buf_mem_free:
> freed plane 0 of buffer 22
> Dec 17 18:28:16 DVB kernel: [160369.173208]  dvb_core pci_stub vboxpci(O)
> Dec 17 18:28:16 DVB kernel: [160369.173210] vb2: __vb2_buf_mem_free:
> freed plane 0 of buffer 23
> Dec 17 18:28:16 DVB kernel: [160369.173210]  vboxnetadp(O) vboxnetflt(O)
> Dec 17 18:28:16 DVB kernel: [160369.173212] vb2: __vb2_buf_mem_free:
> freed plane 0 of buffer 24
> Dec 17 18:28:16 DVB kernel: [160369.173213]  vboxdrv(O)
> Dec 17 18:28:16 DVB kernel: [160369.173213] vb2: __vb2_buf_mem_free:
> freed plane 0 of buffer 25
> Dec 17 18:28:16 DVB kernel: [160369.173214]  nf_conntrack_ipv4
> Dec 17 18:28:16 DVB kernel: [160369.173215] vb2: __vb2_buf_mem_free:
> freed plane 0 of buffer 26
> Dec 17 18:28:16 DVB kernel: [160369.173216]  nf_defrag_ipv4
> xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp
> iptable_filter ip_tables x_tables bridge stp llc mxl111sf_tuner
> Dec 17 18:28:16 DVB kernel: [160369.173221] vb2: __vb2_buf_mem_free:
> freed plane 0 of buffer 27
> Dec 17 18:28:16 DVB kernel: [160369.173222]  lg2160 mxl111sf_demod
> snd_usb_audio snd_usbmidi_lib
> Dec 17 18:28:16 DVB kernel: [160369.173224] vb2: __vb2_buf_mem_free:
> freed plane 0 of buffer 28
> Dec 17 18:28:16 DVB kernel: [160369.173224]  mxm_wmi i915
> Dec 17 18:28:16 DVB kernel: [160369.173225] vb2: __vb2_buf_mem_free:
> freed plane 0 of buffer 29
> Dec 17 18:28:16 DVB kernel: [160369.173226]  snd_hda_codec_hdmi
> x86_pkg_temp_thermal
> Dec 17 18:28:16 DVB kernel: [160369.173228] vb2: __vb2_buf_mem_free:
> freed plane 0 of buffer 30
> Dec 17 18:28:16 DVB kernel: [160369.173228]  kvm_intel lnbp21 snd_hda_codec_via
> Dec 17 18:28:16 DVB kernel: [160369.173230] vb2: __vb2_buf_mem_free:
> freed plane 0 of buffer 31
> Dec 17 18:28:16 DVB kernel: [160369.173230]  snd_hda_codec_generic kvm
> rfcomm bnep snd_hda_intel bluetooth snd_hda_controller snd_hda_codec
> snd_hwdep snd_pcm ghash_clmulni_intel nfsd aesni_intel snd_seq_midi
> aes_x86_64 snd_seq_midi_event lrw snd_rawmidi gf128mul glue_helper
> snd_seq drm_kms_helper ablk_helper cryptd snd_seq_device drm microcode
> snd_timer snd serio_raw auth_rpcgss lpc_ich soundcore tpm_infineon wmi
> tpm_tis video oid_registry nfs_acl mac_hid nfs shpchp i2c_algo_bit
> lockd grace sunrpc parport_pc ppdev fscache binfmt_misc it87 hwmon_vid
> coretemp lp parport nls_iso8859_1 hid_generic usbhid hid psmouse ahci
> alx libahci mdio [last unloaded: tuner_xc2028]
> Dec 17 18:28:16 DVB kernel: [160369.173263] CPU: 2 PID: 5133 Comm:
> vb2-cx88[0] Tainted: G      D  C O   3.18.0-rc4+ #1
> Dec 17 18:28:16 DVB kernel: [160369.173264] Hardware name: Gigabyte
> Technology Co., Ltd. To be filled by O.E.M./Z77X-UD3H, BIOS F20e
> 01/06/2014
> Dec 17 18:28:16 DVB kernel: [160369.173265] task: ffff880403e21900 ti:
> ffff880404c9c000 task.ti: ffff880404c9c000
> Dec 17 18:28:16 DVB kernel: [160369.173266] RIP:
> 0010:[<ffffffffa04204fb>]  [<ffffffffa04204fb>]
> cx88_risc_databuffer+0x10b/0x160 [cx88xx]
> Dec 17 18:28:16 DVB kernel: [160369.173272] RSP: 0018:ffff880404c9fd28
>  EFLAGS: 00010206
> Dec 17 18:28:16 DVB kernel: [160369.173274] RAX: 0000000000000000 RBX:
> ffff880402461360 RCX: 0000000000000118
> Dec 17 18:28:16 DVB kernel: [160369.173275] RDX: 0000000000000000 RSI:
> ffff8803f2324740 RDI: ffff8803f2324760
> Dec 17 18:28:16 DVB kernel: [160369.173276] RBP: ffff880404c9fd78 R08:
> 00000000000002f0 R09: 0000000000000000
> Dec 17 18:28:16 DVB kernel: [160369.173277] R10: ffffffff81a73715 R11:
> ffffea0000dcb540 R12: 0000000000000020
> Dec 17 18:28:16 DVB kernel: [160369.173278] R13: 00000000000002f0 R14:
> ffff8803f2324740 R15: 0000000000000000
> Dec 17 18:28:16 DVB kernel: [160369.173279] FS:
> 0000000000000000(0000) GS:ffff88041f280000(0000)
> knlGS:0000000000000000
> Dec 17 18:28:16 DVB kernel: [160369.173280] CS:  0010 DS: 0000 ES:
> 0000 CR0: 0000000080050033
> Dec 17 18:28:16 DVB kernel: [160369.173281] CR2: 00007fffb80c6000 CR3:
> 00000004066d7000 CR4: 00000000001407e0
> Dec 17 18:28:16 DVB kernel: [160369.173282] Stack:
> Dec 17 18:28:16 DVB kernel: [160369.173283]  ffff880400000020
> ffffffff00000000 ffff880400000001 01ffffff8109706e
> Dec 17 18:28:16 DVB kernel: [160369.173285]  0000000000000002
> ffff880402461000 ffff8803f2882000 0000000000005e00
> Dec 17 18:28:16 DVB kernel: [160369.173286]  ffff880402461360
> ffff8803f2884828 ffff880404c9fdd8 ffffffffa043b2c0
> Dec 17 18:28:16 DVB kernel: [160369.173288] Call Trace:
> Dec 17 18:28:16 DVB kernel: [160369.173292]  [<ffffffffa043b2c0>]
> cx8802_buf_prepare+0x80/0x170 [cx8802]
> Dec 17 18:28:16 DVB kernel: [160369.173296]  [<ffffffffa044106c>]
> buffer_prepare+0x1c/0x20 [cx88_dvb]
> Dec 17 18:28:16 DVB kernel: [160369.173299]  [<ffffffffa03ed915>]
> __buf_prepare+0x2b5/0x320 [videobuf2_core]
> Dec 17 18:28:16 DVB kernel: [160369.173303]  [<ffffffffa03ee02b>]
> vb2_internal_qbuf+0x1fb/0x250 [videobuf2_core]
> Dec 17 18:28:16 DVB kernel: [160369.173306]  [<ffffffffa03ee171>]
> vb2_thread+0xf1/0x270 [videobuf2_core]
> Dec 17 18:28:16 DVB kernel: [160369.173309]  [<ffffffffa03ee080>] ?
> vb2_internal_qbuf+0x250/0x250 [videobuf2_core]
> Dec 17 18:28:16 DVB kernel: [160369.173313]  [<ffffffff8106f4db>]
> kthread+0xdb/0x100
> Dec 17 18:28:16 DVB kernel: [160369.173315]  [<ffffffff8106f400>] ?
> kthread_create_on_node+0x180/0x180
> Dec 17 18:28:16 DVB kernel: [160369.173319]  [<ffffffff8173c62c>]
> ret_from_fork+0x7c/0xb0
> Dec 17 18:28:16 DVB kernel: [160369.173321]  [<ffffffff8106f400>] ?
> kthread_create_on_node+0x180/0x180
> Dec 17 18:28:16 DVB kernel: [160369.173322] Code: 44 24 10 45 89 e8 4c
> 89 f6 e8 92 ec ff ff 8b 13 48 89 43 10 48 2b 43 08 48 c1 f8 02 48 8d
> 0c 85 08 00 00 00 31 c0 48 39 d1 76 12 <0f> 0b 0f 1f 00 48 c7 46 08 00
> 00 00 00 b8 f4 ff ff ff 48 83 c4
> Dec 17 18:28:16 DVB kernel: [160369.173340] RIP  [<ffffffffa04204fb>]
> cx88_risc_databuffer+0x10b/0x160 [cx88xx]
> Dec 17 18:28:16 DVB kernel: [160369.173344]  RSP <ffff880404c9fd28>
> Dec 17 18:28:16 DVB kernel: [160369.173346] ---[ end trace 3a3edb07e8581eaf ]---
>
> Chris Lee
