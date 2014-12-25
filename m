Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43896 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaLYCQz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Dec 2014 21:16:55 -0500
Received: by mail-ie0-f174.google.com with SMTP id at20so8243203iec.33
        for <linux-media@vger.kernel.org>; Wed, 24 Dec 2014 18:16:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA9z4Lb5PkGhs5EYyVyoLbpmNi-TbnFmfxhgpCMDNQFKD+1SxQ@mail.gmail.com>
References: <CAA9z4LZn8wKHw6=F_e8nLQLEDPFVmmaEojv=5Lev3hr6hX3K5Q@mail.gmail.com>
	<CAA9z4Lb5PkGhs5EYyVyoLbpmNi-TbnFmfxhgpCMDNQFKD+1SxQ@mail.gmail.com>
Date: Wed, 24 Dec 2014 19:16:54 -0700
Message-ID: <CAA9z4La9B3nY9xbdbYOROjDsk4c3BUPm5XdZC+KmrtY32e_faA@mail.gmail.com>
Subject: Re: Prof 7301 issues
From: Chris Lee <updatelee@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Another issue is I can't unload the module any longer.

Dec 24 17:50:39 DVB kernel: [ 7547.269390] ------------[ cut here ]------------
Dec 24 17:50:39 DVB kernel: [ 7547.269397] WARNING: CPU: 7 PID: 10618
at kernel/irq/manage.c:1311 __free_irq+0x9f/0x1f0()
Dec 24 17:50:39 DVB kernel: [ 7547.269398] Trying to free already-free IRQ 0
Dec 24 17:50:39 DVB kernel: [ 7547.269398] Modules linked in:
cx88_vp3054_i2c cx8802(-) cx88xx videobuf2_core videobuf2_dma_sg
videobuf2_memops tveeprom v4l2_common videodev stb6100 stv090x
dvb_usb_tbsqbox2ci dvb_usb dvb_core rc_core nf_conntrack_ipv4
nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4
xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc
snd_hda_codec_hdmi mxm_wmi snd_hda_codec_via snd_hda_codec_generic
snd_usb_audio x86_pkg_temp_thermal bnep snd_usbmidi_lib rfcomm
snd_hda_intel kvm_intel snd_hda_controller bluetooth snd_hda_codec kvm
snd_hwdep snd_pcm ghash_clmulni_intel snd_seq_midi aesni_intel
snd_seq_midi_event aes_x86_64 snd_rawmidi lrw i915 gf128mul
glue_helper ablk_helper cryptd snd_seq snd_seq_device snd_timer
drm_kms_helper snd drm microcode soundcore i2c_algo_bit shpchp lpc_ich
serio_raw wmi tpm_infineon tpm_tis video nfsd mac_hid auth_rpcgss
oid_registry nfs_acl parport_pc ppdev nfs lockd grace it87 binfmt_misc
sunrpc hwmon_vid coretemp fscache lp parport nls_iso8859_1 hid_generic
usbhid hid psmouse ahci alx libahci mdio [last unloaded:
videobuf2_dvb]
Dec 24 17:50:39 DVB kernel: [ 7547.269434] CPU: 7 PID: 10618 Comm:
modprobe Not tainted 3.19.0-rc1+ #2
Dec 24 17:50:39 DVB kernel: [ 7547.269434] Hardware name: Gigabyte
Technology Co., Ltd. To be filled by O.E.M./Z77X-UD3H, BIOS F20e
01/06/2014
Dec 24 17:50:39 DVB kernel: [ 7547.269435]  ffffffff81a72a51
ffff8803a382bcb8 ffffffff8174947e 0000000000000007
Dec 24 17:50:39 DVB kernel: [ 7547.269437]  ffff8803a382bd08
ffff8803a382bcf8 ffffffff8105899a ffff8803a382bcd8
Dec 24 17:50:39 DVB kernel: [ 7547.269438]  0000000000000000
0000000000000000 ffff88040e80a6a4 ffff88040e80a600
Dec 24 17:50:39 DVB kernel: [ 7547.269439] Call Trace:
Dec 24 17:50:39 DVB kernel: [ 7547.269444]  [<ffffffff8174947e>]
dump_stack+0x45/0x57
Dec 24 17:50:39 DVB kernel: [ 7547.269446]  [<ffffffff8105899a>]
warn_slowpath_common+0x8a/0xc0
Dec 24 17:50:39 DVB kernel: [ 7547.269447]  [<ffffffff81058a16>]
warn_slowpath_fmt+0x46/0x50
Dec 24 17:50:39 DVB kernel: [ 7547.269450]  [<ffffffff810af52f>]
__free_irq+0x9f/0x1f0
Dec 24 17:50:39 DVB kernel: [ 7547.269451]  [<ffffffff810af71d>]
free_irq+0x4d/0xd0
Dec 24 17:50:39 DVB kernel: [ 7547.269454]  [<ffffffffa06c0d96>]
cx8802_remove+0xa6/0x1c0 [cx8802]
Dec 24 17:50:39 DVB kernel: [ 7547.269456]  [<ffffffff813c0f1f>]
pci_device_remove+0x3f/0xc0
Dec 24 17:50:39 DVB kernel: [ 7547.269459]  [<ffffffff81498fef>]
__device_release_driver+0x7f/0xf0
Dec 24 17:50:39 DVB kernel: [ 7547.269461]  [<ffffffff81499a08>]
driver_detach+0xb8/0xc0
Dec 24 17:50:39 DVB kernel: [ 7547.269462]  [<ffffffff81498c69>]
bus_remove_driver+0x59/0xe0
Dec 24 17:50:39 DVB kernel: [ 7547.269464]  [<ffffffff8149a1d0>]
driver_unregister+0x30/0x70
Dec 24 17:50:39 DVB kernel: [ 7547.269465]  [<ffffffff813c0895>]
pci_unregister_driver+0x25/0x90
Dec 24 17:50:39 DVB kernel: [ 7547.269466]  [<ffffffffa06c18f5>]
cx8802_pci_driver_exit+0x10/0x71b [cx8802]
Dec 24 17:50:39 DVB kernel: [ 7547.269469]  [<ffffffff810d708f>]
SyS_delete_module+0x1af/0x250
Dec 24 17:50:39 DVB kernel: [ 7547.269471]  [<ffffffff810030e1>] ?
do_notify_resume+0x61/0x90
Dec 24 17:50:39 DVB kernel: [ 7547.269473]  [<ffffffff81750056>]
system_call_fastpath+0x16/0x1b
Dec 24 17:50:39 DVB kernel: [ 7547.269474] ---[ end trace 935d21431b629f9c ]---

It shows as a warning but its more than that. It locks my computer up
so badly even the reset button doesnt work. Even if I do this in a VM
(qemu) it will lock up the host.

Chris Lee
