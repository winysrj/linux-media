Return-Path: <SRS0=kVnX=P5=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD526C2F420
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 14:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77EDF20879
	for <linux-media@archiver.kernel.org>; Mon, 21 Jan 2019 14:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729585AbfAUOqN (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 21 Jan 2019 09:46:13 -0500
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:49048 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729252AbfAUOqN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 21 Jan 2019 09:46:13 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id lapxga5L6BDyIlaq0gPaxY; Mon, 21 Jan 2019 15:46:09 +0100
Subject: Re: [PATCH v9 0/4] Media Device Allocator API
To:     shuah@kernel.org, mchehab@kernel.org, perex@perex.cz,
        tiwai@suse.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <cover.1545154777.git.shuah@kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <606f731d-11f9-e2d7-aee4-b20abadc4d41@xs4all.nl>
Date:   Mon, 21 Jan 2019 15:46:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <cover.1545154777.git.shuah@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfKhRCgywLhG+zRgpueIPVaaDGZwquRz6ibVeJNL+P6fuIdo2HyxXqbFooHJbx36xuFVWZ0i2vwgNlqQCC5Ep2tErIYPoQbP4oyYZhtNcJN1Be/XI9Xik
 91NbMq/KQnc4mSQgO5IlwAX4CO6d/gflIuwIeTz+3IsSownFwrg5mGhg4fEhtMo8hBKs6VRM9uELjyWfhqS/3sgHTKRgL6GJlcPFOcgkU0o7qgXwMdJ7dASe
 txeyOXFr93NYLhTrjahKxOsVV9TxweLjFuD8//C6kx9AnBGSHCWIhRKyBzyuk4n4B0uIfA7iShLptvGW+h8nATidOJnZIMrUFWfH3brX0dLzOvmhpZFKCeVZ
 TUd4yNCqD3UTeSOxtN4nGv2Q7jKWMA==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Shuah,

On 12/18/2018 06:59 PM, shuah@kernel.org wrote:
> From: Shuah Khan <shuah@kernel.org>
> 
> Media Device Allocator API to allows multiple drivers share a media device.
> This API solves a very common use-case for media devices where one physical
> device (an USB stick) provides both audio and video. When such media device
> exposes a standard USB Audio class, a proprietary Video class, two or more
> independent drivers will share a single physical USB bridge. In such cases,
> it is necessary to coordinate access to the shared resource.
> 
> Using this API, drivers can allocate a media device with the shared struct
> device as the key. Once the media device is allocated by a driver, other
> drivers can get a reference to it. The media device is released when all
> the references are released.
> 
> - Tested sharing resources with kaffeine, vlc, xawtv, tvtime, and
>   arecord. When analog is streaming, digital and audio user-space
>   applications detect that the tuner is busy and exit. When digital
>   is streaming, analog and audio applications detect that the tuner is
>   busy and exit. When arecord is owns the tuner, digital and analog
>   detect that the tuner is busy and exit.
> - Tested media device allocator API with bind/unbind testing on
>   snd-usb-audio and au0828 drivers to make sure /dev/mediaX is released
>   only when the last driver is unbound.
> - This patch series is tested on 4.20-rc6
> - Addressed review comments from Hans on the RFC v8 (rebased on 4.19)
> - Updated change log to describe the use-case more clearly.
> - No changes to 0001,0002 code since the v7 referenced below.
> - 0003 is a new patch to enable ALSA defines that have been
>   disabled for kernel between 4.9 and 4.19.
> - Minor merge conflict resolution in 0004.
> - Added SPDX to new files.
> 
> References:
> https://lkml.org/lkml/2018/11/2/169
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg105854.html

When I connect my au0828 to my laptop with your v9 patch series applied I get
these warnings:

[   45.416047] xhci_hcd 0000:39:00.0: xHCI Host Controller
[   45.417882] xhci_hcd 0000:39:00.0: new USB bus registered, assigned bus number 3
[   45.419292] xhci_hcd 0000:39:00.0: hcc params 0x200077c1 hci version 0x110 quirks 0x0000000200009810
[   45.420835] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.00
[   45.420893] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   45.420899] usb usb3: Product: xHCI Host Controller
[   45.420905] usb usb3: Manufacturer: Linux 5.0.0-rc1-zen xhci-hcd
[   45.420911] usb usb3: SerialNumber: 0000:39:00.0
[   45.424290] hub 3-0:1.0: USB hub found
[   45.425274] hub 3-0:1.0: 2 ports detected
[   45.431061] xhci_hcd 0000:39:00.0: xHCI Host Controller
[   45.432436] xhci_hcd 0000:39:00.0: new USB bus registered, assigned bus number 4
[   45.432448] xhci_hcd 0000:39:00.0: Host supports USB 3.1 Enhanced SuperSpeed
[   45.433299] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.00
[   45.433354] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   45.433360] usb usb4: Product: xHCI Host Controller
[   45.433365] usb usb4: Manufacturer: Linux 5.0.0-rc1-zen xhci-hcd
[   45.433370] usb usb4: SerialNumber: 0000:39:00.0
[   45.436134] hub 4-0:1.0: USB hub found
[   45.436576] hub 4-0:1.0: 2 ports detected
[   45.750940] usb 3-1: new high-speed USB device number 2 using xhci_hcd
[   45.899927] usb 3-1: New USB device found, idVendor=2040, idProduct=721e, bcdDevice= 0.05
[   45.899949] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=10
[   45.899960] usb 3-1: Product: WinTV Aero-A
[   45.899970] usb 3-1: Manufacturer: Hauppauge
[   45.899979] usb 3-1: SerialNumber: 4033622430
[   46.053476] au0828: au0828 driver loaded
[   46.053726] WARNING: CPU: 1 PID: 1824 at kernel/module.c:262 module_assert_mutex+0x20/0x30
[   46.053818] Modules linked in: au0828(+) tveeprom dvb_core v4l2_common rfcomm bnep snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_codec_generic uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_common videodev media btusb btintel bluetooth
snd_soc_skl snd_soc_skl_ipc snd_soc_sst_ipc snd_soc_sst_dsp snd_soc_acpi_intel_match snd_soc_acpi snd_hda_ext_core x86_pkg_temp_thermal
snd_soc_core snd_compress ac97_bus snd_pcm_dmaengine snd_hda_intel iwlmvm snd_hda_codec snd_hda_core snd_hwdep snd_pcm snd_timer snd iwlwifi
i915 intel_gtt battery ac pcc_cpufreq thermal
[   46.053853] CPU: 1 PID: 1824 Comm: systemd-udevd Not tainted 5.0.0-rc1-zen #85
[   46.053856] Hardware name: ASUSTeK COMPUTER INC. UX490UA/UX490UA, BIOS UX490UA.312 04/09/2018
[   46.053862] RIP: 0010:module_assert_mutex+0x20/0x30
[   46.053867] Code: 5d c3 e8 f3 68 f5 ff 0f 1f 00 8b 05 d2 5a 7c 01 85 c0 75 01 c3 be ff ff ff ff 48 c7 c7 80 bc 86 82 e8 e4 27 fb ff 85 c0
75 ea <0f> 0b c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 53 48 89 fb e8 c7
[   46.053871] RSP: 0018:ffffc90002aa3ac8 EFLAGS: 00010246
[   46.053876] RAX: 0000000000000000 RBX: ffffffffa0573abf RCX: 0000000000000000
[   46.053880] RDX: 0000000000000000 RSI: ffffffff8286bc80 RDI: ffff8882a517d570
[   46.053883] RBP: ffff8882880e6000 R08: 0000000000000000 R09: ffff8882b1f5d000
[   46.053886] R10: 0000000000000001 R11: 0000000000000003 R12: ffffffffa0573abf
[   46.053890] R13: ffff8882880e60a0 R14: ffff8882880e6000 R15: ffffffffa0577200
[   46.053894] FS:  00007f0ac7d318c0(0000) GS:ffff8882b6a80000(0000) knlGS:0000000000000000
[   46.053898] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   46.053902] CR2: 0000560d354ed800 CR3: 00000002880f9003 CR4: 00000000003606e0
[   46.053905] Call Trace:
[   46.053910]  find_module+0x9/0x20
[   46.053918]  media_device_usb_allocate+0x10b/0x170 [media]
[   46.053929]  au0828_usb_probe+0x1bd/0x290 [au0828]
[   46.053954]  usb_probe_interface+0xe8/0x2a0
[   46.053960]  really_probe+0xee/0x2a0
[   46.053966]  driver_probe_device+0x4a/0xb0
[   46.053970]  __driver_attach+0xb3/0xd0
[   46.053975]  ? driver_probe_device+0xb0/0xb0
[   46.053979]  bus_for_each_dev+0x74/0xc0
[   46.053985]  bus_add_driver+0x19a/0x1e0
[   46.053990]  driver_register+0x66/0xb0
[   46.053995]  usb_register_driver+0x9a/0x150
[   46.053999]  ? 0xffffffffa0284000
[   46.054007]  au0828_init+0xb3/0x1000 [au0828]
[   46.054012]  do_one_initcall+0x61/0x2fb
[   46.054016]  ? do_init_module+0x1d/0x1e0
[   46.054021]  ? rcu_read_lock_sched_held+0x6f/0x80
[   46.054026]  ? kmem_cache_alloc_trace+0x123/0x210
[   46.054032]  do_init_module+0x55/0x1e0
[   46.054036]  load_module+0x145b/0x1710
[   46.054046]  ? vfs_read+0x128/0x150
[   46.054057]  ? __do_sys_finit_module+0xba/0xe0
[   46.054060]  __do_sys_finit_module+0xba/0xe0
[   46.054071]  do_syscall_64+0x4b/0x180
[   46.054077]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   46.054080] RIP: 0033:0x7f0ac8993a79
[   46.054084] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d df 43 0c 00 f7 d8 64 89 01 48
[   46.054087] RSP: 002b:00007ffcbd9034f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[   46.054092] RAX: ffffffffffffffda RBX: 0000560d35494b30 RCX: 00007f0ac8993a79
[   46.054095] RDX: 0000000000000000 RSI: 00007f0ac869b0ed RDI: 0000000000000011
[   46.054098] RBP: 00007f0ac869b0ed R08: 0000000000000000 R09: 0000000000000000
[   46.054101] R10: 0000000000000011 R11: 0000000000000246 R12: 0000000000000000
[   46.054104] R13: 0000560d3547aef0 R14: 0000000000020000 R15: 0000560d35494b30
[   46.054114] irq event stamp: 6660
[   46.054119] hardirqs last  enabled at (6659): [<ffffffff81251eca>] get_page_from_freelist.part.104+0x10fa/0x15c0
[   46.054124] hardirqs last disabled at (6660): [<ffffffff81001c56>] trace_hardirqs_off_thunk+0x1a/0x1c
[   46.054129] softirqs last  enabled at (6488): [<ffffffff819f628c>] peernet2id+0x4c/0x70
[   46.054132] softirqs last disabled at (6486): [<ffffffff819f626d>] peernet2id+0x2d/0x70
[   46.054134] ---[ end trace 33cd45564590d7c7 ]---
[   46.054169] WARNING: CPU: 1 PID: 1824 at kernel/module.c:272 module_assert_mutex_or_preempt+0x29/0x30
[   46.054172] Modules linked in: au0828(+) tveeprom dvb_core v4l2_common rfcomm bnep snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_codec_generic uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_common videodev media btusb btintel bluetooth
snd_soc_skl snd_soc_skl_ipc snd_soc_sst_ipc snd_soc_sst_dsp snd_soc_acpi_intel_match snd_soc_acpi snd_hda_ext_core x86_pkg_temp_thermal
snd_soc_core snd_compress ac97_bus snd_pcm_dmaengine snd_hda_intel iwlmvm snd_hda_codec snd_hda_core snd_hwdep snd_pcm snd_timer snd iwlwifi
i915 intel_gtt battery ac pcc_cpufreq thermal
[   46.054198] CPU: 1 PID: 1824 Comm: systemd-udevd Tainted: G        W         5.0.0-rc1-zen #85
[   46.054201] Hardware name: ASUSTeK COMPUTER INC. UX490UA/UX490UA, BIOS UX490UA.312 04/09/2018
[   46.054206] RIP: 0010:module_assert_mutex_or_preempt+0x29/0x30
[   46.054210] Code: 00 8b 05 a2 5e 7c 01 85 c0 74 09 e8 11 5b fd ff 85 c0 74 01 c3 be ff ff ff ff 48 c7 c7 80 bc 86 82 e8 ab 2b fb ff 85 c0
75 ea <0f> 0b c3 0f 1f 40 00 41 56 49 89 fe 41 55 41 89 d5 41 54 49 89 f4
[   46.054215] RSP: 0018:ffffc90002aa3aa8 EFLAGS: 00010246
[   46.054219] RAX: 0000000000000000 RBX: ffff8882b1f5d000 RCX: 0000000000000000
[   46.054222] RDX: 0000000000000000 RSI: ffffffff8286bc80 RDI: ffff8882a517d570
[   46.054225] RBP: ffff8882880e6000 R08: 0000000000000000 R09: ffff8882b1f5d000
[   46.054229] R10: 0000000000000001 R11: 0000000000000003 R12: 0000000000000006
[   46.054232] R13: 0000000000000000 R14: ffffffffa0573abf R15: ffffffffa0577200
[   46.054236] FS:  00007f0ac7d318c0(0000) GS:ffff8882b6a80000(0000) knlGS:0000000000000000
[   46.054239] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   46.054243] CR2: 0000560d354ed800 CR3: 00000002880f9003 CR4: 00000000003606e0
[   46.054246] Call Trace:
[   46.054251]  find_module_all+0x16/0x90
[   46.054260]  media_device_usb_allocate+0x10b/0x170 [media]
[   46.054269]  au0828_usb_probe+0x1bd/0x290 [au0828]
[   46.054277]  usb_probe_interface+0xe8/0x2a0
[   46.054285]  really_probe+0xee/0x2a0
[   46.054292]  driver_probe_device+0x4a/0xb0
[   46.054297]  __driver_attach+0xb3/0xd0
[   46.054304]  ? driver_probe_device+0xb0/0xb0
[   46.054311]  bus_for_each_dev+0x74/0xc0
[   46.054321]  bus_add_driver+0x19a/0x1e0
[   46.054330]  driver_register+0x66/0xb0
[   46.054337]  usb_register_driver+0x9a/0x150
[   46.054344]  ? 0xffffffffa0284000
[   46.054353]  au0828_init+0xb3/0x1000 [au0828]
[   46.054361]  do_one_initcall+0x61/0x2fb
[   46.054367]  ? do_init_module+0x1d/0x1e0
[   46.054375]  ? rcu_read_lock_sched_held+0x6f/0x80
[   46.054381]  ? kmem_cache_alloc_trace+0x123/0x210
[   46.054391]  do_init_module+0x55/0x1e0
[   46.054398]  load_module+0x145b/0x1710
[   46.054411]  ? vfs_read+0x128/0x150
[   46.054427]  ? __do_sys_finit_module+0xba/0xe0
[   46.054433]  __do_sys_finit_module+0xba/0xe0
[   46.054446]  do_syscall_64+0x4b/0x180
[   46.054454]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   46.054461] RIP: 0033:0x7f0ac8993a79
[   46.054467] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d df 43 0c 00 f7 d8 64 89 01 48
[   46.054473] RSP: 002b:00007ffcbd9034f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[   46.054477] RAX: ffffffffffffffda RBX: 0000560d35494b30 RCX: 00007f0ac8993a79
[   46.054481] RDX: 0000000000000000 RSI: 00007f0ac869b0ed RDI: 0000000000000011
[   46.054484] RBP: 00007f0ac869b0ed R08: 0000000000000000 R09: 0000000000000000
[   46.054488] R10: 0000000000000011 R11: 0000000000000246 R12: 0000000000000000
[   46.054491] R13: 0000560d3547aef0 R14: 0000000000020000 R15: 0000560d35494b30
[   46.054502] irq event stamp: 6674
[   46.054507] hardirqs last  enabled at (6673): [<ffffffff81001c3a>] trace_hardirqs_on_thunk+0x1a/0x1c
[   46.054511] hardirqs last disabled at (6674): [<ffffffff81001c56>] trace_hardirqs_off_thunk+0x1a/0x1c
[   46.054516] softirqs last  enabled at (6672): [<ffffffff820002c0>] __do_softirq+0x2c0/0x4c0
[   46.054521] softirqs last disabled at (6663): [<ffffffff811369f9>] irq_exit+0xa9/0xc0
[   46.054524] ---[ end trace 33cd45564590d7c8 ]---
[   46.418079] au0828: i2c bus registered
[   46.464037] tveeprom: Hauppauge model 72251, rev D3F0, serial# 4033622430
[   46.464052] tveeprom: MAC address is 00:0d:fe:6c:31:9e
[   46.464061] tveeprom: tuner model is Xceive XC5000 (idx 150, type 76)
[   46.464070] tveeprom: TV standards NTSC(M) ATSC/DVB Digital (eeprom 0x88)
[   46.464077] tveeprom: audio processor is AU8522 (idx 44)
[   46.464085] tveeprom: decoder processor is AU8522 (idx 42)
[   46.464091] tveeprom: has no radio
[   46.464100] au0828: hauppauge_eeprom: hauppauge eeprom: model=72251
[   46.480275] au8522 9-0047: creating new instance
[   46.481073] au8522_decoder creating new instance...
[   46.493942] tuner: 9-0061: Tuner -1 found with type(s) Radio TV.
[   46.498807] xc5000 9-0061: creating new instance
[   46.503833] xc5000: Successfully identified at address 0x61
[   46.503840] xc5000: Firmware has not been loaded previously
[   46.673037] au8522 9-0047: attaching existing instance
[   46.675595] xc5000 9-0061: attaching existing instance
[   46.679924] xc5000: Successfully identified at address 0x61
[   46.679937] xc5000: Firmware has not been loaded previously
[   46.680182] dvbdev: DVB: registering new adapter (au0828)
[   46.680543] usb 3-1: DVB: registering adapter 0 frontend 0 (Auvitek AU8522 QAM/8VSB Frontend)...
[   46.680970] dvbdev: dvb_create_media_entity: media entity 'Auvitek AU8522 QAM/8VSB Frontend' registered.
[   46.686969] dvbdev: dvb_create_media_entity: media entity 'dvb-demux' registered.
[   46.787967] Registered IR keymap rc-hauppauge
[   46.791557] IR RC5(x/sz) protocol handler initialized
[   46.815417] rc rc0: au0828 IR (Hauppauge HVR950Q) as /devices/pci0000:00/0000:00:1c.4/0000:03:00.0/0000:04:02.0/0000:39:00.0/usb3/3-1/rc/rc0
[   46.815731] input: au0828 IR (Hauppauge HVR950Q) as
/devices/pci0000:00/0000:00:1c.4/0000:03:00.0/0000:04:02.0/0000:39:00.0/usb3/3-1/rc/rc0/input18
[   46.821468] au0828: Remote controller au0828 IR (Hauppauge HVR950Q) initialized
[   46.821479] au0828: Registered device AU0828 [Hauppauge HVR950Q]
[   46.822937] usbcore: registered new interface driver au0828
[   46.861371] WARNING: CPU: 1 PID: 1822 at kernel/module.c:262 module_assert_mutex+0x20/0x30
[   46.861490] Modules linked in: snd_usb_audio(+) snd_usbmidi_lib snd_rawmidi ir_rc5_decoder rc_hauppauge au8522_dig xc5000 tuner
au8522_decoder au8522_common au0828 tveeprom dvb_core v4l2_common rfcomm bnep snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic
uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_common videodev media btusb btintel bluetooth snd_soc_skl
snd_soc_skl_ipc snd_soc_sst_ipc snd_soc_sst_dsp snd_soc_acpi_intel_match snd_soc_acpi snd_hda_ext_core x86_pkg_temp_thermal snd_soc_core
snd_compress ac97_bus snd_pcm_dmaengine snd_hda_intel iwlmvm snd_hda_codec snd_hda_core snd_hwdep snd_pcm snd_timer snd iwlwifi i915
intel_gtt battery ac pcc_cpufreq thermal
[   46.861570] CPU: 1 PID: 1822 Comm: systemd-udevd Tainted: G        W         5.0.0-rc1-zen #85
[   46.861577] Hardware name: ASUSTeK COMPUTER INC. UX490UA/UX490UA, BIOS UX490UA.312 04/09/2018
[   46.861588] RIP: 0010:module_assert_mutex+0x20/0x30
[   46.861596] Code: 5d c3 e8 f3 68 f5 ff 0f 1f 00 8b 05 d2 5a 7c 01 85 c0 75 01 c3 be ff ff ff ff 48 c7 c7 80 bc 86 82 e8 e4 27 fb ff 85 c0
75 ea <0f> 0b c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 53 48 89 fb e8 c7
[   46.861603] RSP: 0018:ffffc90002b87a48 EFLAGS: 00010246
[   46.861611] RAX: 0000000000000000 RBX: ffffffffa059d994 RCX: 0000000000000000
[   46.861618] RDX: ffff888288242640 RSI: ffffffff8286bc80 RDI: ffff888288242f30
[   46.861626] RBP: ffff8882880e6000 R08: ffffffff83999000 R09: 0000000000000000
[   46.861633] R10: ffffc90002b87a60 R11: 0000000000000003 R12: ffffffffa059d994
[   46.861641] R13: ffff8882880e60a0 R14: ffff88829a88ac9c R15: ffff88829ab2ec58
[   46.861651] FS:  00007f0ac7d318c0(0000) GS:ffff8882b6a80000(0000) knlGS:0000000000000000
[   46.861659] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   46.861667] CR2: 00007f0ac740dba0 CR3: 00000002ad550004 CR4: 00000000003606e0
[   46.861675] Call Trace:
[   46.861687]  find_module+0x9/0x20
[   46.861707]  media_device_usb_allocate+0x7c/0x170 [media]
[   46.861741]  snd_media_device_create+0x160/0x280 [snd_usb_audio]
[   46.861754]  ? snd_card_register+0x124/0x1c0 [snd]
[   46.861775]  usb_audio_probe+0x8a4/0xaa0 [snd_usb_audio]
[   46.861793]  usb_probe_interface+0xe8/0x2a0
[   46.861805]  really_probe+0xee/0x2a0
[   46.861815]  driver_probe_device+0x4a/0xb0
[   46.861828]  __driver_attach+0xb3/0xd0
[   46.861840]  ? driver_probe_device+0xb0/0xb0
[   46.861849]  bus_for_each_dev+0x74/0xc0
[   46.861860]  bus_add_driver+0x19a/0x1e0
[   46.861870]  driver_register+0x66/0xb0
[   46.861879]  usb_register_driver+0x9a/0x150
[   46.861886]  ? 0xffffffffa05c3000
[   46.861894]  do_one_initcall+0x61/0x2fb
[   46.861901]  ? do_init_module+0x1d/0x1e0
[   46.861910]  ? rcu_read_lock_sched_held+0x6f/0x80
[   46.861918]  ? kmem_cache_alloc_trace+0x123/0x210
[   46.861927]  do_init_module+0x55/0x1e0
[   46.861935]  load_module+0x145b/0x1710
[   46.861951]  ? vfs_read+0x128/0x150
[   46.861969]  ? __do_sys_finit_module+0xba/0xe0
[   46.861974]  __do_sys_finit_module+0xba/0xe0
[   46.861991]  do_syscall_64+0x4b/0x180
[   46.862001]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   46.862007] RIP: 0033:0x7f0ac8993a79
[   46.862014] Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08
0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d df 43 0c 00 f7 d8 64 89 01 48
[   46.862019] RSP: 002b:00007ffcbd9034f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000139
[   46.862026] RAX: ffffffffffffffda RBX: 0000560d3548f460 RCX: 00007f0ac8993a79
[   46.862031] RDX: 0000000000000000 RSI: 0000560d354a6ab0 RDI: 0000000000000012
[   46.862036] RBP: 0000560d354a6ab0 R08: 0000000000000000 R09: 0000000000000000
[   46.862041] R10: 0000000000000012 R11: 0000000000000246 R12: 0000000000000000
[   46.862045] R13: 0000560d354846d0 R14: 0000000000020000 R15: 0000000000000000
[   46.862061] irq event stamp: 8750
[   46.862068] hardirqs last  enabled at (8749): [<ffffffff81c8340c>] _raw_spin_unlock_irqrestore+0x4c/0x60
[   46.862075] hardirqs last disabled at (8750): [<ffffffff81001c56>] trace_hardirqs_off_thunk+0x1a/0x1c
[   46.862083] softirqs last  enabled at (8722): [<ffffffff820002c0>] __do_softirq+0x2c0/0x4c0
[   46.862091] softirqs last disabled at (8709): [<ffffffff811369f9>] irq_exit+0xa9/0xc0
[   46.862096] ---[ end trace 33cd45564590d7c9 ]---
[   46.866081] usbcore: registered new interface driver snd-usb-audio
[   55.010427] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
[   55.045345] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
[   57.480184] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
[   58.460287] wlp2s0: authenticate with e0:28:6d:86:46:9e
[   58.478641] wlp2s0: send auth to e0:28:6d:86:46:9e (try 1/3)
[   58.487199] wlp2s0: authenticated
[   58.489866] wlp2s0: associate with e0:28:6d:86:46:9e (try 1/3)
[   58.492757] wlp2s0: RX AssocResp from e0:28:6d:86:46:9e (capab=0x1511 status=0 aid=4)
[   58.498171] wlp2s0: associated
[   58.536392] wlp2s0: Limiting TX power to 27 (30 - 3) dBm as advertised by e0:28:6d:86:46:9e
[   58.537657] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready

And the same when I unplug:

[   74.220960] usb 3-1: USB disconnect, device number 2
[   74.323245] xhci_hcd 0000:39:00.0: remove, state 4
[   74.323424] usb usb4: USB disconnect, device number 1
[   74.327940] xhci_hcd 0000:39:00.0: USB bus 4 deregistered
[   74.329918] xhci_hcd 0000:39:00.0: xHCI host controller not responding, assume dead
[   74.329995] xhci_hcd 0000:39:00.0: remove, state 1
[   74.330075] usb usb3: USB disconnect, device number 1
[   74.338585] au8522 9-0047: destroying instance
[   74.341038] xc5000 9-0061: destroying instance
[   74.341142] WARNING: CPU: 2 PID: 46 at kernel/module.c:262 module_assert_mutex+0x20/0x30
[   74.341173] Modules linked in: snd_usb_audio snd_usbmidi_lib snd_rawmidi ir_rc5_decoder rc_hauppauge au8522_dig xc5000 tuner
au8522_decoder au8522_common au0828 tveeprom dvb_core v4l2_common rfcomm bnep snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic
uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_common videodev media btusb btintel bluetooth snd_soc_skl
snd_soc_skl_ipc snd_soc_sst_ipc snd_soc_sst_dsp snd_soc_acpi_intel_match snd_soc_acpi snd_hda_ext_core x86_pkg_temp_thermal snd_soc_core
snd_compress ac97_bus snd_pcm_dmaengine snd_hda_intel iwlmvm snd_hda_codec snd_hda_core snd_hwdep snd_pcm snd_timer snd iwlwifi i915
intel_gtt battery ac pcc_cpufreq thermal
[   74.341198] CPU: 2 PID: 46 Comm: kworker/2:1 Tainted: G        W         5.0.0-rc1-zen #85
[   74.341200] Hardware name: ASUSTeK COMPUTER INC. UX490UA/UX490UA, BIOS UX490UA.312 04/09/2018
[   74.341204] Workqueue: usb_hub_wq hub_event
[   74.341207] RIP: 0010:module_assert_mutex+0x20/0x30
[   74.341209] Code: 5d c3 e8 f3 68 f5 ff 0f 1f 00 8b 05 d2 5a 7c 01 85 c0 75 01 c3 be ff ff ff ff 48 c7 c7 80 bc 86 82 e8 e4 27 fb ff 85 c0
75 ea <0f> 0b c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 53 48 89 fb e8 c7
[   74.341211] RSP: 0018:ffffc90000e3fb18 EFLAGS: 00010246
[   74.341213] RAX: 0000000000000000 RBX: ffffffffa0573abf RCX: 0000000000000000
[   74.341215] RDX: ffff8882b5684c80 RSI: ffffffff8286bc80 RDI: ffff8882b56855c0
[   74.341217] RBP: ffffffffa0577800 R08: ffffffff839a7d00 R09: ffffffff82b53590
[   74.341218] R10: ffffc90000e3fb30 R11: 0000000000000013 R12: ffffffffa0573abf
[   74.341220] R13: ffff8882b1f5d140 R14: ffff8882880e60a0 R15: 00000000ffffffed
[   74.341223] FS:  0000000000000000(0000) GS:ffff8882b6b00000(0000) knlGS:0000000000000000
[   74.341224] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   74.341226] CR2: 000056317f04cfe0 CR3: 000000029e7cf004 CR4: 00000000003606e0
[   74.341228] Call Trace:
[   74.341231]  find_module+0x9/0x20
[   74.341236]  media_device_delete+0x27/0x68 [media]
[   74.341241]  au0828_usb_release+0xdf/0x100 [au0828]
[   74.341248]  v4l2_device_put+0x24/0x30 [videodev]
[   74.341252]  au0828_analog_unregister+0x68/0x70 [au0828]
[   74.341255]  au0828_usb_disconnect+0x61/0x80 [au0828]
[   74.341259]  usb_unbind_interface+0x77/0x280
[   74.341263]  ? _raw_spin_unlock_irqrestore+0x39/0x60
[   74.341267]  device_release_driver_internal+0x186/0x240
[   74.341271]  bus_remove_device+0xee/0x130
[   74.341274]  device_del+0x140/0x350
[   74.341278]  usb_disable_device+0x7c/0x1d0
[   74.341281]  usb_disconnect+0xb4/0x280
[   74.341284]  hub_port_connect+0x7a/0xa10
[   74.341289]  port_event+0x4c8/0x6a0
[   74.341294]  hub_event+0x119/0x2c0
[   74.341299]  process_one_work+0x283/0x690
[   74.341304]  worker_thread+0x34/0x3d0
[   74.341308]  ? rescuer_thread+0x360/0x360
[   74.341311]  kthread+0x118/0x130
[   74.341313]  ? kthread_create_on_node+0x60/0x60
[   74.341316]  ret_from_fork+0x3a/0x50
[   74.341322] irq event stamp: 94118
[   74.341325] hardirqs last  enabled at (94117): [<ffffffff81c8340c>] _raw_spin_unlock_irqrestore+0x4c/0x60
[   74.341328] hardirqs last disabled at (94118): [<ffffffff81001c56>] trace_hardirqs_off_thunk+0x1a/0x1c
[   74.341331] softirqs last  enabled at (94092): [<ffffffff819f628c>] peernet2id+0x4c/0x70
[   74.341334] softirqs last disabled at (94090): [<ffffffff819f626d>] peernet2id+0x2d/0x70
[   74.341335] ---[ end trace 33cd45564590d7ca ]---
[   74.350561] WARNING: CPU: 2 PID: 46 at kernel/module.c:262 module_assert_mutex+0x20/0x30
[   74.350610] Modules linked in: snd_usb_audio snd_usbmidi_lib snd_rawmidi ir_rc5_decoder rc_hauppauge au8522_dig xc5000 tuner
au8522_decoder au8522_common au0828 tveeprom dvb_core v4l2_common rfcomm bnep snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic
uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_common videodev media btusb btintel bluetooth snd_soc_skl
snd_soc_skl_ipc snd_soc_sst_ipc snd_soc_sst_dsp snd_soc_acpi_intel_match snd_soc_acpi snd_hda_ext_core x86_pkg_temp_thermal snd_soc_core
snd_compress ac97_bus snd_pcm_dmaengine snd_hda_intel iwlmvm snd_hda_codec snd_hda_core snd_hwdep snd_pcm snd_timer snd iwlwifi i915
intel_gtt battery ac pcc_cpufreq thermal
[   74.350644] CPU: 2 PID: 46 Comm: kworker/2:1 Tainted: G        W         5.0.0-rc1-zen #85
[   74.350647] Hardware name: ASUSTeK COMPUTER INC. UX490UA/UX490UA, BIOS UX490UA.312 04/09/2018
[   74.350652] Workqueue: usb_hub_wq hub_event
[   74.350657] RIP: 0010:module_assert_mutex+0x20/0x30
[   74.350661] Code: 5d c3 e8 f3 68 f5 ff 0f 1f 00 8b 05 d2 5a 7c 01 85 c0 75 01 c3 be ff ff ff ff 48 c7 c7 80 bc 86 82 e8 e4 27 fb ff 85 c0
75 ea <0f> 0b c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 53 48 89 fb e8 c7
[   74.350664] RSP: 0018:ffffc90000e3fae0 EFLAGS: 00010246
[   74.350668] RAX: 0000000000000000 RBX: ffffffffa059d994 RCX: 0000000000000000
[   74.350671] RDX: ffff8882b5684c80 RSI: ffffffff8286bc80 RDI: ffff8882b56855e8
[   74.350674] RBP: ffffffffa0577800 R08: 0000000000012a81 R09: ffffffff82554cd8
[   74.350677] R10: ffffc90000e3faf8 R11: 0000000000000006 R12: ffffffffa059d994
[   74.350680] R13: ffff8882b1f5d000 R14: ffff8882b1f5d000 R15: ffff88829ab2eda8
[   74.350683] FS:  0000000000000000(0000) GS:ffff8882b6b00000(0000) knlGS:0000000000000000
[   74.350686] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   74.350689] CR2: 0000560d354e6920 CR3: 00000002b31ef003 CR4: 00000000003606e0
[   74.350691] Call Trace:
[   74.350696]  find_module+0x9/0x20
[   74.350704]  media_device_delete+0x27/0x68 [media]
[   74.350714]  snd_media_device_delete+0x112/0x131 [snd_usb_audio]
[   74.350724]  usb_audio_disconnect+0x1bc/0x240 [snd_usb_audio]
[   74.350730]  ? __pm_runtime_resume+0x4f/0x80
[   74.350737]  usb_unbind_interface+0x77/0x280
[   74.350742]  ? _raw_spin_unlock_irqrestore+0x39/0x60
[   74.350749]  device_release_driver_internal+0x186/0x240
[   74.350754]  bus_remove_device+0xee/0x130
[   74.350758]  device_del+0x140/0x350
[   74.350765]  usb_disable_device+0x7c/0x1d0
[   74.350770]  usb_disconnect+0xb4/0x280
[   74.350775]  hub_port_connect+0x7a/0xa10
[   74.350783]  port_event+0x4c8/0x6a0
[   74.350791]  hub_event+0x119/0x2c0
[   74.350800]  process_one_work+0x283/0x690
[   74.350808]  worker_thread+0x34/0x3d0
[   74.350814]  ? rescuer_thread+0x360/0x360
[   74.350817]  kthread+0x118/0x130
[   74.350821]  ? kthread_create_on_node+0x60/0x60
[   74.350826]  ret_from_fork+0x3a/0x50
[   74.350835] irq event stamp: 94728
[   74.350840] hardirqs last  enabled at (94727): [<ffffffff812ac725>] kfree+0xc5/0x270
[   74.350845] hardirqs last disabled at (94728): [<ffffffff81001c56>] trace_hardirqs_off_thunk+0x1a/0x1c
[   74.350849] softirqs last  enabled at (94632): [<ffffffff819f628c>] peernet2id+0x4c/0x70
[   74.350853] softirqs last disabled at (94630): [<ffffffff819f626d>] peernet2id+0x2d/0x70
[   74.350856] ---[ end trace 33cd45564590d7cb ]---
[   74.360386] xhci_hcd 0000:39:00.0: Host halt failed, -19
[   74.360445] xhci_hcd 0000:39:00.0: Host not accessible, reset failed.
[   74.360976] xhci_hcd 0000:39:00.0: USB bus 3 deregistered

My .config is available upon request.

Regards,

	Hans
