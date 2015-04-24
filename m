Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:47155 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754922AbbDXGzh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 02:55:37 -0400
Message-ID: <5539E8CB.906@xs4all.nl>
Date: Fri, 24 Apr 2015 08:55:07 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Andy Walls <awalls@md.metrocast.net>, labbott@redhat.com
Subject: [PATCH] cx18: add missing caps for the PCM video device
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The cx18 PCM video device didn't have any capabilities set, which caused a warnings
in the v4l2 core:

[    6.229393] ------------[ cut here ]------------
[    6.229414] WARNING: CPU: 1 PID: 593 at 
drivers/media/v4l2-core/v4l2-ioctl.c:1025 v4l_querycap+0x41/0x70 
[videodev]()
[    6.229415] Modules linked in: cx18_alsa mxl5005s s5h1409 
tuner_simple tuner_types cs5345 tuner intel_rapl iosf_mbi 
x86_pkg_temp_thermal coretemp raid1 snd_hda_codec_realtek kvm_intel 
snd_hda_codec_generic snd_hda_codec_hdmi kvm snd_oxygen(+) snd_hda_intel 
snd_oxygen_lib snd_hda_controller snd_hda_codec snd_mpu401_uart iTCO_wdt 
snd_rawmidi iTCO_vendor_support snd_hwdep crct10dif_pclmul crc32_pclmul 
crc32c_intel snd_seq cx18 snd_seq_device ghash_clmulni_intel 
videobuf_vmalloc tveeprom cx2341x snd_pcm serio_raw videobuf_core vfat 
dvb_core fat v4l2_common snd_timer videodev snd lpc_ich i2c_i801 joydev 
mfd_core mei_me media soundcore tpm_infineon soc_button_array tpm_tis 
mei shpchp tpm nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc 
i915 nouveau mxm_wmi wmi e1000e ttm i2c_algo_bit drm_kms_helper
[    6.229444]  drm ptp pps_core video
[    6.229446] CPU: 1 PID: 593 Comm: v4l_id Not tainted 
3.19.3-200.fc21.x86_64 #1
[    6.229447] Hardware name: Gigabyte Technology Co., Ltd. 
Z87-D3HP/Z87-D3HP-CF, BIOS F6 01/20/2014
[    6.229448]  0000000000000000 00000000d12b1131 ffff88042dacfc28 
ffffffff8176e215
[    6.229449]  0000000000000000 0000000000000000 ffff88042dacfc68 
ffffffff8109bc1a
[    6.229451]  ffffffffa0594000 ffff88042dacfd90 0000000000000000 
ffffffffa04e2140
[    6.229452] Call Trace:
[    6.229466]  [<ffffffff8176e215>] dump_stack+0x45/0x57
[    6.229469]  [<ffffffff8109bc1a>] warn_slowpath_common+0x8a/0xc0
[    6.229472]  [<ffffffff8109bd4a>] warn_slowpath_null+0x1a/0x20
[    6.229474]  [<ffffffffa04ca401>] v4l_querycap+0x41/0x70 [videodev]
[    6.229477]  [<ffffffffa04ca6cc>] __video_do_ioctl+0x29c/0x320 [videodev]
[    6.229479]  [<ffffffff81227131>] ? do_last+0x2f1/0x1210
[    6.229491]  [<ffffffffa04cc776>] video_usercopy+0x366/0x5d0 [videodev]
[    6.229494]  [<ffffffffa04ca430>] ? v4l_querycap+0x70/0x70 [videodev]
[    6.229497]  [<ffffffffa04cc9f5>] video_ioctl2+0x15/0x20 [videodev]
[    6.229499]  [<ffffffffa04c6794>] v4l2_ioctl+0x164/0x180 [videodev]
[    6.229501]  [<ffffffff8122e298>] do_vfs_ioctl+0x2f8/0x500
[    6.229502]  [<ffffffff8122e521>] SyS_ioctl+0x81/0xa0
[    6.229505]  [<ffffffff81774a09>] system_call_fastpath+0x12/0x17
[    6.229506] ---[ end trace dacd80d4b19277ea ]---

Added the necessary capabilities to stop this warning.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Laura Abbott <labbott@redhat.com>
Cc: <stable@vger.kernel.org>      # for v3.19 and up
---
diff --git a/drivers/media/pci/cx18/cx18-streams.c b/drivers/media/pci/cx18/cx18-streams.c
index c82d25d..c986084 100644
--- a/drivers/media/pci/cx18/cx18-streams.c
+++ b/drivers/media/pci/cx18/cx18-streams.c
@@ -90,6 +90,7 @@ static struct {
 		"encoder PCM audio",
 		VFL_TYPE_GRABBER, CX18_V4L2_ENC_PCM_OFFSET,
 		PCI_DMA_FROMDEVICE,
+		V4L2_CAP_TUNER | V4L2_CAP_AUDIO | V4L2_CAP_READWRITE,
 	},
 	{	/* CX18_ENC_STREAM_TYPE_IDX */
 		"encoder IDX",
