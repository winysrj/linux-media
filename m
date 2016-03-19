Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54865 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754486AbcCSNbr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Mar 2016 09:31:47 -0400
Subject: Re: [PATCH] sound/usb: fix to release stream resources from
 media_snd_device_delete()
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1458355831-9467-1-git-send-email-shuahkh@osg.samsung.com>
 <20160319091026.3f2cbaf2@recife.lan>
Cc: tiwai@suse.com, perex@perex.cz, linux-media@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <56ED54C0.7030802@osg.samsung.com>
Date: Sat, 19 Mar 2016 07:31:44 -0600
MIME-Version: 1.0
In-Reply-To: <20160319091026.3f2cbaf2@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/19/2016 06:10 AM, Mauro Carvalho Chehab wrote:
> Em Fri, 18 Mar 2016 20:50:31 -0600
> Shuah Khan <shuahkh@osg.samsung.com> escreveu:
> 
>> Fix to release stream resources from media_snd_device_delete() before
>> media device is unregistered. Without this change, stream resource free
>> is attempted after the media device is unregistered which would result
>> in use-after-free errors.
>>
>> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
>> ---
>>
>> - Ran bind/unbind loop (1000 iteration) test on snd-usb-audio
>>   while running mc_nextgen_test loop (1000 iterations) in parallel.
>> - Ran bind/unbind and rmmod/modprobe tests on both drivers. Also
>>   generated graphs when after bind/unbind, rmmod/modprobe. Graphs
>>   look good.
>> - Note: Please apply the following patch to fix memory leak:
>>   sound/usb: Fix memory leak in media_snd_stream_delete() during unbind
>>   https://lkml.org/lkml/2016/3/16/1050
> 
> Yeah, a way better!
> 
> For normal bind/unbind, it seems to be working fine. Also
> for driver's rmmod, so:
> 
> Tested-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> PS.:
> ===
> 
> There are still some troubles if we run an infinite loop
> binding/unbinding au0828 and another one binding/unbinding
> snd-usb-audio, like this one:

Yes. I noticed this one when I was running a loop of 1000 on au0828.
I couldn't reproduce this when I tested this patch.

P.S: au08282 loops takes longer btw since au0828 initialization is lot more
complex. We have to look at this one.

> 
> 
> [   91.556188] ------------[ cut here ]------------
> [   91.556500] WARNING: CPU: 1 PID: 2920 at drivers/media/media-entity.c:392 __media_entity_pipeline_start+0x271/0xce0 [media]()
> [   91.556626] Modules linked in: ir_lirc_codec lirc_dev au8522_dig xc5000 tuner au8522_decoder au8522_common au0828 videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core tveeprom dvb_core rc_core v4l2_common videodev snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device media cpufreq_powersave cpufreq_conservative cpufreq_userspace cpufreq_stats parport_pc ppdev lp parport snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel iTCO_wdt kvm iTCO_vendor_support irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel sha256_ssse3 sha256_generic hmac drbg snd_hda_codec_realtek i915 snd_hda_codec_generic aesni_intel aes_x86_64 btusb lrw btrtl gf128mul snd_hda_intel glue_helper ablk_helper btbcm btintel cryptd psmouse snd_hda_codec bluetooth
> [   91.556693]  snd_hwdep i2c_algo_bit sg snd_hda_core serio_raw pcspkr evdev drm_kms_helper snd_pcm rfkill drm snd_timer mei_me snd i2c_i801 soundcore lpc_ich mei mfd_core battery video dw_dmac i2c_designware_platform dw_dmac_core i2c_designware_core acpi_pad button tpm_tis tpm ext4 crc16 mbcache jbd2 dm_mod sd_mod hid_generic usbhid ahci libahci libata e1000e xhci_pci ptp scsi_mod ehci_pci ehci_hcd pps_core xhci_hcd fan thermal sdhci_acpi sdhci mmc_core i2c_hid hid
> [   91.556748] CPU: 1 PID: 2920 Comm: v4l_id Tainted: G      D W       4.5.0+ #62
> [   91.556751] Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
> [   91.556754]  ffffffffa0e247a0 ffff8803a3d17b08 ffffffff819447c1 0000000000000000
> [   91.556759]  ffff88009bbe17c0 ffff8803a3d17b48 ffffffff8114fd16 ffffffffa0e20651
> [   91.556763]  ffff8803a47c9c58 ffff8803a477d2c8 ffff8803a5ac96f8 dffffc0000000000
> [   91.556768] Call Trace:
> [   91.556774]  [<ffffffff819447c1>] dump_stack+0x85/0xc4
> [   91.556778]  [<ffffffff8114fd16>] warn_slowpath_common+0xc6/0x120
> [   91.556783]  [<ffffffffa0e20651>] ? __media_entity_pipeline_start+0x271/0xce0 [media]
> [   91.556786]  [<ffffffff8114feea>] warn_slowpath_null+0x1a/0x20
> [   91.556790]  [<ffffffffa0e20651>] __media_entity_pipeline_start+0x271/0xce0 [media]
> [   91.556794]  [<ffffffff822d9aca>] ? __schedule+0x78a/0x2570
> [   91.556797]  [<ffffffff8156e428>] ? memset+0x28/0x30
> [   91.556802]  [<ffffffffa0e203e0>] ? media_entity_pipeline_stop+0x60/0x60 [media]
> [   91.556806]  [<ffffffff8124a73d>] ? trace_hardirqs_on+0xd/0x10
> [   91.556810]  [<ffffffffa1430a05>] ? au0828_enable_source+0x55/0x9f0 [au0828]
> [   91.556813]  [<ffffffff822ddb20>] ? mutex_trylock+0x400/0x400
> [   91.556818]  [<ffffffffa1440833>] ? au0828_v4l2_close+0xb3/0x590 [au0828]
> [   91.556822]  [<ffffffffa1430da4>] au0828_enable_source+0x3f4/0x9f0 [au0828]
> [   91.556824]  [<ffffffff822ddb20>] ? mutex_trylock+0x400/0x400
> [   91.556834]  [<ffffffffa133acf6>] v4l_enable_media_source+0x66/0x90 [videodev]
> [   91.556839]  [<ffffffffa14409da>] au0828_v4l2_close+0x25a/0x590 [au0828]
> [   91.556846]  [<ffffffffa1301270>] v4l2_release+0xf0/0x210 [videodev]
> [   91.556849]  [<ffffffff815c2c4f>] __fput+0x20f/0x6d0
> [   91.556853]  [<ffffffff815c317e>] ____fput+0xe/0x10
> [   91.556856]  [<ffffffff811acde7>] task_work_run+0x137/0x200
> [   91.556859]  [<ffffffff81005d54>] exit_to_usermode_loop+0x154/0x180
> [   91.556863]  [<ffffffff8124a1b6>] ? trace_hardirqs_on_caller+0x16/0x590
> [   91.556866]  [<ffffffff810073a6>] syscall_return_slowpath+0x186/0x1c0
> [   91.556869]  [<ffffffff822e7a1c>] entry_SYSCALL_64_fastpath+0xbf/0xc1
> [   91.556872] ---[ end trace 3e95e11ff0b9efad ]---
> 
> I suspect that something is not properly protected by the graph mutex at
> either ALSA or au0828 driver.
> 
> I also got a GPF:
> 
> [   95.398931] au0828: Start Pipeline: Xceive XC5000->au0828a vbi Error -16
> [   95.398936] au0828: Deactivate link Error 0
> [   95.398943] tuner 6-0061: Putting tuner to sleep
> [   95.398960] kasan: CONFIG_KASAN_INLINE enabled
> [   95.398962] kasan: GPF could be caused by NULL-ptr deref or user memory access
> [   95.398967] general protection fault: 0000 [#2] SMP KASAN
> [   95.399020] Modules linked in: ir_lirc_codec lirc_dev au8522_dig xc5000 tuner au8522_decoder au8522_common au0828 videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_core tveeprom dvb_core rc_core v4l2_common videodev snd_usb_audio snd_usbmidi_lib snd_rawmidi snd_seq_device media cpufreq_powersave cpufreq_conservative cpufreq_userspace cpufreq_stats parport_pc ppdev lp parport snd_hda_codec_hdmi intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel iTCO_wdt kvm iTCO_vendor_support irqbypass crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel sha256_ssse3 sha256_generic hmac drbg snd_hda_codec_realtek i915 snd_hda_codec_generic aesni_intel aes_x86_64 btusb lrw btrtl gf128mul snd_hda_intel glue_helper ablk_helper btbcm btintel cryptd psmouse snd_hda_codec bluetooth
> [   95.399853]  snd_hwdep i2c_algo_bit sg snd_hda_core serio_raw pcspkr evdev drm_kms_helper snd_pcm rfkill drm snd_timer mei_me snd i2c_i801 soundcore lpc_ich mei mfd_core battery video dw_dmac i2c_designware_platform dw_dmac_core i2c_designware_core acpi_pad button tpm_tis tpm ext4 crc16 mbcache jbd2 dm_mod sd_mod hid_generic usbhid ahci libahci libata e1000e xhci_pci ptp scsi_mod ehci_pci ehci_hcd pps_core xhci_hcd fan thermal sdhci_acpi sdhci mmc_core i2c_hid hid
> [   95.400389] CPU: 2 PID: 2966 Comm: v4l_id Tainted: G      D W       4.5.0+ #62
> [   95.400455] Hardware name:                  /NUC5i7RYB, BIOS RYBDWi35.86A.0350.2015.0812.1722 08/12/2015
> [   95.400541] task: ffff88009bbe4740 ti: ffff8803a45a0000 task.ti: ffff8803a45a0000
> [   95.400610] RIP: 0010:[<ffffffff81db0aa4>]  [<ffffffff81db0aa4>] usb_set_interface+0x34/0x9c0
> [   95.400694] RSP: 0018:ffff8803a45a7d18  EFLAGS: 00010202
> [   95.400744] RAX: dffffc0000000000 RBX: ffff8803a3cbab2c RCX: 1ffff10006ba18e2
> [   95.400809] RDX: 0000000000000008 RSI: 0000000000000000 RDI: 0000000000000040
> [   95.400873] RBP: ffff8803a45a7d88 R08: 0000000000000001 R09: 0000000000000001
> [   95.400938] R10: ffff8803a4414a38 R11: 0000000000000000 R12: ffff8803bc482400
> [   95.401004] R13: dffffc0000000000 R14: ffff8803a3cb8000 R15: 0000000000000000
> [   95.401069] FS:  00007f19fbd19700(0000) GS:ffff8803c6900000(0000) knlGS:0000000000000000
> [   95.401141] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   95.401190] CR2: 0000558300d51d44 CR3: 000000009af29000 CR4: 00000000003406e0
> [   95.401255] Stack:
> [   95.401277]  ffff8803a5b5ea20 ffff8803a45a7d40 ffffffffa1490f0f 0000000000000061
> [   95.401358]  ffff8803a5b5e510 ffff8803a45a7d58 ffffffffa147003c ffff880300000000
> [   95.401438]  ffff880300000000 ffff8803a3cbab2c ffff8803bc482400 dffffc0000000000
> [   95.401518] Call Trace:
> [   95.401547]  [<ffffffffa1490f0f>] ? xc5000_sleep+0x8f/0xd0 [xc5000]
> [   95.405722]  [<ffffffffa147003c>] ? fe_standby+0x3c/0x50 [tuner]
> [   95.409842]  [<ffffffffa1440b20>] au0828_v4l2_close+0x3a0/0x590 [au0828]
> [   95.412140]  [<ffffffffa1301270>] v4l2_release+0xf0/0x210 [videodev]
> [   95.414119]  [<ffffffff815c2c4f>] __fput+0x20f/0x6d0
> [   95.416046]  [<ffffffff815c317e>] ____fput+0xe/0x10
> [   95.417879]  [<ffffffff811acde7>] task_work_run+0x137/0x200
> [   95.419656]  [<ffffffff81005d54>] exit_to_usermode_loop+0x154/0x180
> [   95.421420]  [<ffffffff8124a1b6>] ? trace_hardirqs_on_caller+0x16/0x590
> [   95.423177]  [<ffffffff810073a6>] syscall_return_slowpath+0x186/0x1c0
> [   95.424911]  [<ffffffff822e7a1c>] entry_SYSCALL_64_fastpath+0xbf/0xc1
> [   95.426629] Code: 00 00 00 00 fc ff df 48 89 e5 41 57 41 56 41 55 41 54 49 89 ff 53 48 83 c7 40 48 83 ec 48 89 55 c8 48 89 fa 48 c1 ea 03 89 75 d0 <80> 3c 02 00 0f 85 67 07 00 00 49 8d 7f 18 48 b8 00 00 00 00 00 
> [   95.428560] RIP  [<ffffffff81db0aa4>] usb_set_interface+0x34/0x9c0
> [   95.430358]  RSP <ffff8803a45a7d18>
> [   95.432566] ---[ end trace 3e95e11ff0b9efaf ]---
> 
> As nobody expects someone to do infinite loops binding/unbinding
> both drivers, I guess it is ok to keep it for Kernel 4.6, but
> we need to find a way fix those locking issues for dynamic graph
> changes.
> 

Yes. Right. We have to look at these closely. I agree nobody runs a stress
bin/ubind and rmmod/modprobe like we are doing. I think there is some lock
and race type issue in au0828 v4l2 release path. I have had to fix some issues
there in the past. I agree with you that we are good for 4.6-rc1 and I can 
continue to look at this. We can get this fixed for rc2 or rc3.

thanks,
-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Open Source Innovation Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
