Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.62]:36095 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbaKRWwz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 17:52:55 -0500
Received: from [187.123.53.75] (helo=[192.168.0.2])
	by smtp04.mailcore.me with esmtpa (Exim 4.80.1)
	(envelope-from <it@sca-uk.com>)
	id 1XqrM0-0007TM-55
	for linux-media@vger.kernel.org; Tue, 18 Nov 2014 22:34:34 +0000
Message-ID: <546BC96D.0@sca-uk.com>
Date: Tue, 18 Nov 2014 22:34:21 +0000
From: Steve Cookson <it@sca-uk.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org >> Linux Media Mailing List"
	<linux-media@vger.kernel.org>
Subject: WARNING: CPU: 2 PID: 28560 at /home/apw/COD/linux/drivers/media/v4l2-core/videobuf2-core.c:2144
 __vb2_queue_cancel+0x1d0/0x240 [videobuf2_core]()
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

While trying to debug a particularly recalcitrant segfault on entering 
GStreamer, I found all this on dmesg.  I don't know if it is connected, 
but I haven't seen it before.  I'm using a Dazzle DVC 100 Rev 1.1.

I get it across several different platforms (this is an Asus Zen 
laptop).  The operating system is Kubuntu 14.04 LTS and 
3.17.0-031700-generic.

Can anyone offer any guidance?

Regards,

Steve.

[32550.400043] ------------[ cut here ]------------
[32550.400079] WARNING: CPU: 2 PID: 28560 at 
/home/apw/COD/linux/drivers/media/v4l2-core/videobuf2-core.c:2144 
__vb2_queue_cancel+0x1d0/0x240 [videobuf2_core]()
[32550.400083] Modules linked in: saa7115 em28xx_v4l snd_usb_audio 
snd_usbmidi_lib em28xx tveeprom hid_sensor_accel_3d hid_sensor_gyro_3d 
hid_sensor_magn_3d hid_sensor_incl_3d hid_sensor_rotation 
hid_sensor_trigger industrialio_triggered_buffer kfifo_buf industrialio 
hid_sensor_iio_common hid_sensor_hub ctr ccm snd_hda_codec_hdmi 
snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel 
snd_hda_controller snd_hda_codec snd_hwdep snd_pcm asus_nb_wmi asus_wmi 
sparse_keymap snd_seq_midi intel_rapl x86_pkg_temp_thermal 
intel_powerclamp coretemp kvm_intel snd_seq_midi_event kvm arc4 
snd_rawmidi crct10dif_pclmul uvcvideo crc32_pclmul iwldvm 
ghash_clmulni_intel videobuf2_vmalloc videobuf2_memops aesni_intel 
mac80211 videobuf2_core aes_x86_64 v4l2_common lrw videodev gf128mul 
media glue_helper ablk_helper snd_seq cryptd joydev rtc_efi serio_raw 
iwlwifi hid_multitouch cfg80211 btusb snd_seq_device lpc_ich snd_timer 
int3403_thermal snd soundcore intel_rst mac_hid bnep rfcomm bluetooth 
mei_me mei parport_pc ppdev lp parport nls_iso8859_1 hid_generic usbhid 
hid i915 i2c_algo_bit psmouse drm_kms_helper ahci libahci drm wmi video
[32550.400152] CPU: 2 PID: 28560 Comm: qv4l2 Tainted: G W 
3.17.0-031700-generic #201410060605
[32550.400153] Hardware name: ASUSTeK COMPUTER INC. TAICHI21A/TAICHI21A, 
BIOS TAICHI21A.203 02/04/2013
[32550.400154]  0000000000000860 ffff880117a6fbd8 ffffffff81796bd7 
0000000000000007
[32550.400156]  0000000000000000 ffff880117a6fc18 ffffffff81074a3c 
0000000000000292
[32550.400158]  ffff880112d73148 0000000000000001 ffff88005fceca00 
ffffffffc0aa4960
[32550.400160] Call Trace:
[32550.400165]  [<ffffffff81796bd7>] dump_stack+0x46/0x58
[32550.400168]  [<ffffffff81074a3c>] warn_slowpath_common+0x8c/0xc0
[32550.400171]  [<ffffffff81074a8a>] warn_slowpath_null+0x1a/0x20
[32550.400175]  [<ffffffffc0790a10>] __vb2_queue_cancel+0x1d0/0x240 
[videobuf2_core]
[32550.400179]  [<ffffffffc0792755>] vb2_internal_streamoff+0x45/0xe0 
[videobuf2_core]
[32550.400182]  [<ffffffffc0792825>] vb2_streamoff+0x35/0x60 
[videobuf2_core]
[32550.400186]  [<ffffffffc07928a8>] vb2_ioctl_streamoff+0x58/0x70 
[videobuf2_core]
[32550.400191]  [<ffffffffc0756b5a>] v4l_streamoff+0x1a/0x20 [videodev]
[32550.400196]  [<ffffffffc075bca4>] __video_do_ioctl+0x274/0x310 [videodev]
[32550.400202]  [<ffffffffc0759adc>] video_usercopy+0x29c/0x4a0 [videodev]
[32550.400207]  [<ffffffffc075ba30>] ? v4l_printk_ioctl+0xb0/0xb0 [videodev]
[32550.400210]  [<ffffffff811ea7a7>] ? do_readv_writev+0x187/0x2e0
[32550.400214]  [<ffffffffc0759cf5>] video_ioctl2+0x15/0x20 [videodev]
[32550.400218]  [<ffffffffc0755723>] v4l2_ioctl+0x133/0x160 [videodev]
[32550.400221]  [<ffffffff81206535>] ? __fget_light+0x25/0x70
[32550.400223]  [<ffffffff811fbfe5>] do_vfs_ioctl+0x75/0x2c0
[32550.400226]  [<ffffffff816707b5>] ? __sys_recvmsg+0x75/0x90
[32550.400228]  [<ffffffff81206535>] ? __fget_light+0x25/0x70
[32550.400229]  [<ffffffff811fc2c1>] SyS_ioctl+0x91/0xb0
[32550.400232]  [<ffffffff817a472d>] system_call_fastpath+0x1a/0x1f
[32550.400233] ---[ end trace 039a366d7d2aff19 ]---

