Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:46522 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbaLHEdv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Dec 2014 23:33:51 -0500
Received: by mail-ig0-f170.google.com with SMTP id r2so3620513igi.5
        for <linux-media@vger.kernel.org>; Sun, 07 Dec 2014 20:33:50 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 7 Dec 2014 21:33:50 -0700
Message-ID: <CAA9z4LbKVv1PXxYZTKjewx2rRRYvwKK7LX-=d+KdSX14jz6R5g@mail.gmail.com>
Subject: vb2_dma_sg_alloc regression
From: Chris Lee <updatelee@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I noticed today that my Prof 7301 wasnt working any longer. I get a
kernel oops when I send ioctl DMX_SET_PES_FILTER

Dec  7 21:18:07 DVB kernel: [13728.751355] ------------[ cut here ]------------
Dec  7 21:18:07 DVB kernel: [13728.751366] WARNING: CPU: 1 PID: 7106
at drivers/media/v4l2-core/videobuf2-dma-sg.c:102
vb2_dma_sg_alloc+0x22c/0x270 [videobuf2_dma_sg]()
Dec  7 21:18:07 DVB kernel: [13728.751368] Modules linked in: ddbridge
cxd2099(C) stv6110x saa716x_budget tas2101 cxd2820r mb86a16
saa716x_core cx24117 dvb_usb_tbsqbox2ci dvb_usb_gp8psk cx23885
altera_ci tda18271 altera_stapl dvb_usb_dw2102 dvb_usb stb6100 stv090x
cx88_dvb cx88_vp3054_i2c cx8802 cx88xx videobuf2_dvb videobuf2_core
videobuf2_dma_sg videobuf2_memops cx231xx_dvb cx231xx videobuf_vmalloc
cx2341x videobuf_core i2c_mux lgdt3305 dvb_usb_mxl111sf dvb_usb_v2
rc_core tuner_xc2028 s5h1409 em28xx_dvb em28xx v4l2_common videodev
xc5000 au8522_dig au8522_common au0828 tveeprom dvb_core
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT
nf_reject_ipv4 xt_tcpudp iptable_filter ip_tables x_tables bridge stp
llc mxl111sf_tuner lg2160 mxl111sf_demod snd_usb_audio snd_usbmidi_lib
mxm_wmi i915 lnbp21 snd_hda_codec_hdmi snd_hda_codec_via
snd_hda_codec_generic x86_pkg_temp_thermal kvm_intel snd_hda_intel kvm
snd_hda_controller snd_hda_codec snd_hwdep snd_pcm snd_seq_midi
snd_seq_midi_event snd_rawmidi snd_seq ghash_clmulni_intel aesni_intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper snd_seq_device cryptd
snd_timer snd microcode drm_kms_helper rfcomm serio_raw bnep lpc_ich
soundcore drm bluetooth tpm_infineon wmi tpm_tis video mac_hid nfsd
shpchp i2c_algo_bit auth_rpcgss oid_registry nfs_acl nfs lockd grace
sunrpc parport_pc ppdev it87 hwmon_vid coretemp lp parport binfmt_misc
fscache nls_iso8859_1 hid_generic usbhid hid psmouse ahci libahci alx
mdio [last unloaded: tuner_xc2028]
Dec  7 21:18:07 DVB kernel: [13728.751425] CPU: 1 PID: 7106 Comm:
dvbtraffic Tainted: G        WC     3.18.0-rc4+ #1
Dec  7 21:18:07 DVB kernel: [13728.751426] Hardware name: Gigabyte
Technology Co., Ltd. To be filled by O.E.M./Z77X-UD3H, BIOS F20e
01/06/2014
Dec  7 21:18:07 DVB kernel: [13728.751427]  0000000000000009
ffff88023ac07a28 ffffffff8173576f 0000000000000007
Dec  7 21:18:07 DVB kernel: [13728.751428]  0000000000000000
ffff88023ac07a68 ffffffff81051a21 ffff88023ac07b18
Dec  7 21:18:07 DVB kernel: [13728.751429]  0000000000000000
ffff8804068369f0 0000000000000000 ffff8804048df400
Dec  7 21:18:07 DVB kernel: [13728.751430] Call Trace:
Dec  7 21:18:07 DVB kernel: [13728.751434]  [<ffffffff8173576f>]
dump_stack+0x46/0x58
Dec  7 21:18:07 DVB kernel: [13728.751438]  [<ffffffff81051a21>]
warn_slowpath_common+0x81/0xa0
Dec  7 21:18:07 DVB kernel: [13728.751440]  [<ffffffff81051afa>]
warn_slowpath_null+0x1a/0x20
Dec  7 21:18:07 DVB kernel: [13728.751443]  [<ffffffffa046056c>]
vb2_dma_sg_alloc+0x22c/0x270 [videobuf2_dma_sg]
Dec  7 21:18:07 DVB kernel: [13728.751447]  [<ffffffffa0468aea>] ?
__vb2_queue_alloc+0x9a/0x570 [videobuf2_core]
Dec  7 21:18:07 DVB kernel: [13728.751449]  [<ffffffffa0468bbd>]
__vb2_queue_alloc+0x16d/0x570 [videobuf2_core]
Dec  7 21:18:07 DVB kernel: [13728.751451]  [<ffffffffa04694f3>]
__reqbufs.isra.14+0x153/0x350 [videobuf2_core]
Dec  7 21:18:07 DVB kernel: [13728.751453]  [<ffffffffa04f6220>] ?
vb2_dvb_start_feed+0xc0/0xc0 [videobuf2_dvb]
Dec  7 21:18:07 DVB kernel: [13728.751455]  [<ffffffffa0469b37>]
__vb2_init_fileio+0xc7/0x380 [videobuf2_core]
Dec  7 21:18:07 DVB kernel: [13728.751457]  [<ffffffff8119aa8e>] ?
kmem_cache_alloc_trace+0x11e/0x130
Dec  7 21:18:07 DVB kernel: [13728.751459]  [<ffffffffa04f6220>] ?
vb2_dvb_start_feed+0xc0/0xc0 [videobuf2_dvb]
Dec  7 21:18:07 DVB kernel: [13728.751461]  [<ffffffffa046ac3e>]
vb2_thread_start+0xae/0x470 [videobuf2_core]
Dec  7 21:18:07 DVB kernel: [13728.751462]  [<ffffffffa04f61e8>]
vb2_dvb_start_feed+0x88/0xc0 [videobuf2_dvb]
Dec  7 21:18:07 DVB kernel: [13728.751466]  [<ffffffffa01d1f56>]
dmx_ts_feed_start_filtering+0x66/0x110 [dvb_core]
Dec  7 21:18:07 DVB kernel: [13728.751470]  [<ffffffffa01cf3ed>]
dvb_dmxdev_start_feed.isra.0+0xad/0x110 [dvb_core]
Dec  7 21:18:07 DVB kernel: [13728.751474]  [<ffffffffa01cff6f>]
dvb_dmxdev_filter_start+0x35f/0x4d0 [dvb_core]
Dec  7 21:18:07 DVB kernel: [13728.751477]  [<ffffffffa01d0c40>]
dvb_demux_do_ioctl+0x580/0x6c0 [dvb_core]
Dec  7 21:18:07 DVB kernel: [13728.751481]  [<ffffffffa01ce8e6>]
dvb_usercopy+0xc6/0x160 [dvb_core]
Dec  7 21:18:07 DVB kernel: [13728.751484]  [<ffffffffa01d06c0>] ?
dvb_dmxdev_add_pid+0xc0/0xc0 [dvb_core]
Dec  7 21:18:07 DVB kernel: [13728.751486]  [<ffffffff811c831a>] ?
do_filp_open+0x3a/0xb0
Dec  7 21:18:07 DVB kernel: [13728.751489]  [<ffffffffa01cedc5>]
dvb_demux_ioctl+0x15/0x20 [dvb_core]
Dec  7 21:18:07 DVB kernel: [13728.751491]  [<ffffffff811ca898>]
do_vfs_ioctl+0x2c8/0x490
Dec  7 21:18:07 DVB kernel: [13728.751494]  [<ffffffff811c7126>] ?
final_putname+0x26/0x50
Dec  7 21:18:07 DVB kernel: [13728.751496]  [<ffffffff811c73c9>] ?
putname+0x29/0x40
Dec  7 21:18:07 DVB kernel: [13728.751499]  [<ffffffff811b5941>] ?
do_sys_open+0x1a1/0x220
Dec  7 21:18:07 DVB kernel: [13728.751501]  [<ffffffff811caae1>]
SyS_ioctl+0x81/0xa0
Dec  7 21:18:07 DVB kernel: [13728.751504]  [<ffffffff8173c6d6>]
system_call_fastpath+0x16/0x1b
Dec  7 21:18:07 DVB kernel: [13728.751506] ---[ end trace ae6176f38894369b ]---

reverting patches one at a time it kept failing until I reverted

http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/drivers/media/v4l2-core?id=0c3a14c177aa85afb991e7c2be3921aa9a52a893

Then everything works again. Honestly Ive never looked at this part of
the kernel before so Im going to just report it as a bug and hopefully
Hans or Mauro knows whats going on here.

Chris Lee
