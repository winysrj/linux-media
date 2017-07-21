Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:37393 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750762AbdGUM4i (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Jul 2017 08:56:38 -0400
Received: by mail-pg0-f65.google.com with SMTP id g14so707899pgu.4
        for <linux-media@vger.kernel.org>; Fri, 21 Jul 2017 05:56:38 -0700 (PDT)
MIME-Version: 1.0
From: Przemyslaw Gajos <przemyslaw.gajos@gmail.com>
Date: Fri, 21 Jul 2017 13:56:36 +0100
Message-ID: <CA+mzHXp0DZXZvcNQGLd+Nvv_C7onO7FokQE25zFTaETfJNqnYw@mail.gmail.com>
Subject: WARNING from linux/drivers/media/v4l2-core/v4l2-ioctl.c: Unknown
 pixelformat 0x20203852
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Deal all,

My v4l2 capture driver advertises some non-v4l2 pixel formats and in
new kernels I get a warning message to kernel logs when
VIDIOC_ENUM_FMT ioctl is called in the driver:

[11205.998032] WARNING: CPU: 5 PID: 2471 at
/home/kernel/COD/linux/drivers/media/v4l2-core/v4l2-ioctl.c:1272
v4l_enum_fmt+0xd86/0x10f0 [videodev]()
[11205.998034] Unknown pixelformat 0x20203852
[11205.998036] Modules linked in: arc4 md4 nls_utf8 cifs fscache
rgb200(POE) videodev media gpio_ich snd_hda_codec_realtek
snd_hda_codec_generic intel_rapl x86_pkg_temp_thermal intel_powerclamp
coretemp snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep snd_pcm
snd_seq_midi snd_seq_midi_event joydev input_leds snd_rawmidi kvm
snd_seq snd_seq_device snd_timer snd soundcore shpchp irqbypass
crct10dif_pclmul crc32_pclmul ghash_clmulni_intel lpc_ich aesni_intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper mei_me mei cryptd
8250_fintek mac_hid parport_pc ppdev lp parport autofs4 hid_generic
hid_cherry usbhid hid amdkfd amd_iommu_v2 radeon i2c_algo_bit ttm
drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops e1000e
ahci drm libahci ptp pps_core floppy fjes
[11205.998093] CPU: 5 PID: 2471 Comm: gst-launch-1.0 Tainted: P
W  OE   4.4.76-040476-generic #201707050936
[11205.998095] Hardware name: To be filled by O.E.M. To be filled by
O.E.M./To be filled by O.E.M., BIOS 4.6.4 12/16/2011
[11205.998098]  0000000000000286 82331ce6718839c1 ffff8802325fbbf0
ffffffff813da083
[11205.998101]  ffff8802325fbc38 ffffffffc05b8a68 ffff8802325fbc28
ffffffff81080132
[11205.998105]  ffff8802325fbda0 0000000000000000 0000000000000000
ffffc900013da000
[11205.998108] Call Trace:
[11205.998116]  [<ffffffff813da083>] dump_stack+0x63/0x90
[11205.998121]  [<ffffffff81080132>] warn_slowpath_common+0x82/0xc0
[11205.998124]  [<ffffffff810801cc>] warn_slowpath_fmt+0x5c/0x80
[11205.998132]  [<ffffffffc05a36f6>] v4l_enum_fmt+0xd86/0x10f0 [videodev]
[11205.998145]  [<ffffffffc071a1db>] ?
rgb133_enum_framesizes+0x2c4/0x2d4 [rgb200]
[11205.998153]  [<ffffffffc05a42c1>] __video_do_ioctl+0x291/0x310 [videodev]
[11205.998161]  [<ffffffffc05a3d96>] video_usercopy+0x336/0x5b0 [videodev]
[11205.998169]  [<ffffffffc05a4030>] ? video_ioctl2+0x20/0x20 [videodev]
[11205.998174]  [<ffffffff811bf6e7>] ? handle_mm_fault+0x1277/0x1820
[11205.998181]  [<ffffffffc05a4025>] video_ioctl2+0x15/0x20 [videodev]
[11205.998188]  [<ffffffffc059f6a3>] v4l2_ioctl+0xd3/0xe0 [videodev]
[11205.998193]  [<ffffffff8121f598>] do_vfs_ioctl+0x298/0x480
[11205.998196]  [<ffffffff8106a574>] ? __do_page_fault+0x1b4/0x400
[11205.998200]  [<ffffffff8121f7f9>] SyS_ioctl+0x79/0x90
[11205.998204]  [<ffffffff8181aaf2>] entry_SYSCALL_64_fastpath+0x16/0x71
[11205.998206] ---[ end trace 13c7a64a61ea1959 ]---
[11205.998210] ------------[ cut here ]------------

The above is printed to kernel logs every time a non-v4l2 pixel format
is enumerated (every time a format is not recognised by the v4l2
layer). In older kernels such warning was not present but was enabled
in new kernels (>=4.4).
Note that my driver supports 8 non-v4l2 formats and in practice, every
time a capture is opened kernel logs get filled with 8 such warnings
as shown above. This results in kernel logs being not only polluted
with those call traces but also their size rising quickly in some
cases.

What is Your position on those warning messages? Do You think they are
really needed in the v4l2 layer? Do You think they could disappear?

Best regards,
Przemek Gajos
