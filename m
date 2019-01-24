Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9143C282C3
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 07:30:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B982221855
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 07:30:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbfAXHao (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 02:30:44 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:43293 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725986AbfAXHao (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 02:30:44 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud8.xs4all.net with ESMTPA
        id mZTAgVNXzNR5ymZTDgoZ74; Thu, 24 Jan 2019 08:30:41 +0100
Subject: Re: [PATCH v9 0/4] Media Device Allocator API
To:     shuah <shuah@kernel.org>, mchehab@kernel.org, perex@perex.cz,
        tiwai@suse.com
Cc:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
References: <cover.1545154777.git.shuah@kernel.org>
 <606f731d-11f9-e2d7-aee4-b20abadc4d41@xs4all.nl>
 <2ebe7776-d24d-79d5-bd38-efba4221b7c2@kernel.org>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ecd0647c-4ee7-fe17-4324-4770f1f1dcdc@xs4all.nl>
Date:   Thu, 24 Jan 2019 08:30:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <2ebe7776-d24d-79d5-bd38-efba4221b7c2@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: sv-FI
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfNufD9ni9Xq6iZDIOJpGUcNC1MOpo1YnJMaKP8btqqycCY7S0SJk4209bEVsPHZSgV0qcMxQ+U9UUhBHq+AXfig7SACHLRxIuwW+dvdPDaB7veMEpuJ/
 /0v5Nq1aW2YulHgtNRKmHlP5E5FOk6ADzdRKJNrfNn6rPJ5pMbK7u6GBexHVTnM8YfwE4YfdZ3vXSiWoKZxNSII8z3r5hd1gzgNbT9sLGiPnJ0UnaTyX5+cv
 +3aQt1uq9c73uYz5m6pklb1E6nDueTua5i1eB9rqFlIL/ZZA0sZ0Af0ihsasOdmx2kRsmaFpfj6HwHpsPTBXRhfDucbwkuK35NNn6LSTFYsALyEXcVdypf9S
 n2yd2zjZx0qs/jpPb9f8FLfC4UlkMg==
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/24/19 2:35 AM, shuah wrote:
> On 1/21/19 7:46 AM, Hans Verkuil wrote:
>> Hi Shuah,
>>
>> On 12/18/2018 06:59 PM, shuah@kernel.org wrote:
>>> From: Shuah Khan <shuah@kernel.org>
>>>
>>> Media Device Allocator API to allows multiple drivers share a media device.
>>> This API solves a very common use-case for media devices where one physical
>>> device (an USB stick) provides both audio and video. When such media device
>>> exposes a standard USB Audio class, a proprietary Video class, two or more
>>> independent drivers will share a single physical USB bridge. In such cases,
>>> it is necessary to coordinate access to the shared resource.
>>>
>>> Using this API, drivers can allocate a media device with the shared struct
>>> device as the key. Once the media device is allocated by a driver, other
>>> drivers can get a reference to it. The media device is released when all
>>> the references are released.
>>>
>>> - Tested sharing resources with kaffeine, vlc, xawtv, tvtime, and
>>>    arecord. When analog is streaming, digital and audio user-space
>>>    applications detect that the tuner is busy and exit. When digital
>>>    is streaming, analog and audio applications detect that the tuner is
>>>    busy and exit. When arecord is owns the tuner, digital and analog
>>>    detect that the tuner is busy and exit.
>>> - Tested media device allocator API with bind/unbind testing on
>>>    snd-usb-audio and au0828 drivers to make sure /dev/mediaX is released
>>>    only when the last driver is unbound.
>>> - This patch series is tested on 4.20-rc6
>>> - Addressed review comments from Hans on the RFC v8 (rebased on 4.19)
>>> - Updated change log to describe the use-case more clearly.
>>> - No changes to 0001,0002 code since the v7 referenced below.
>>> - 0003 is a new patch to enable ALSA defines that have been
>>>    disabled for kernel between 4.9 and 4.19.
>>> - Minor merge conflict resolution in 0004.
>>> - Added SPDX to new files.
>>>
>>> References:
>>> https://lkml.org/lkml/2018/11/2/169
>>> https://www.mail-archive.com/linux-media@vger.kernel.org/msg105854.html
>>
>> When I connect my au0828 to my laptop with your v9 patch series applied I get
>> these warnings:
>>
>> [   45.416047] xhci_hcd 0000:39:00.0: xHCI Host Controller
>> [   45.417882] xhci_hcd 0000:39:00.0: new USB bus registered, assigned bus number 3
>> [   45.419292] xhci_hcd 0000:39:00.0: hcc params 0x200077c1 hci version 0x110 quirks 0x0000000200009810
>> [   45.420835] usb usb3: New USB device found, idVendor=1d6b, idProduct=0002, bcdDevice= 5.00
>> [   45.420893] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [   45.420899] usb usb3: Product: xHCI Host Controller
>> [   45.420905] usb usb3: Manufacturer: Linux 5.0.0-rc1-zen xhci-hcd
>> [   45.420911] usb usb3: SerialNumber: 0000:39:00.0
>> [   45.424290] hub 3-0:1.0: USB hub found
>> [   45.425274] hub 3-0:1.0: 2 ports detected
>> [   45.431061] xhci_hcd 0000:39:00.0: xHCI Host Controller
>> [   45.432436] xhci_hcd 0000:39:00.0: new USB bus registered, assigned bus number 4
>> [   45.432448] xhci_hcd 0000:39:00.0: Host supports USB 3.1 Enhanced SuperSpeed
>> [   45.433299] usb usb4: New USB device found, idVendor=1d6b, idProduct=0003, bcdDevice= 5.00
>> [   45.433354] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
>> [   45.433360] usb usb4: Product: xHCI Host Controller
>> [   45.433365] usb usb4: Manufacturer: Linux 5.0.0-rc1-zen xhci-hcd
>> [   45.433370] usb usb4: SerialNumber: 0000:39:00.0
>> [   45.436134] hub 4-0:1.0: USB hub found
>> [   45.436576] hub 4-0:1.0: 2 ports detected
>> [   45.750940] usb 3-1: new high-speed USB device number 2 using xhci_hcd
>> [   45.899927] usb 3-1: New USB device found, idVendor=2040, idProduct=721e, bcdDevice= 0.05
>> [   45.899949] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=10
>> [   45.899960] usb 3-1: Product: WinTV Aero-A
>> [   45.899970] usb 3-1: Manufacturer: Hauppauge
>> [   45.899979] usb 3-1: SerialNumber: 4033622430
>> [   46.053476] au0828: au0828 driver loaded
>> [   46.053726] WARNING: CPU: 1 PID: 1824 at kernel/module.c:262 module_assert_mutex+0x20/0x30
>> [   46.053818] Modules linked in: au0828(+) tveeprom dvb_core v4l2_common rfcomm bnep snd_hda_codec_hdmi snd_hda_codec_realtek
>> snd_hda_codec_generic uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 videobuf2_common videodev media btusb btintel bluetooth
>> snd_soc_skl snd_soc_skl_ipc snd_soc_sst_ipc snd_soc_sst_dsp snd_soc_acpi_intel_match snd_soc_acpi snd_hda_ext_core x86_pkg_temp_thermal
>> snd_soc_core snd_compress ac97_bus snd_pcm_dmaengine snd_hda_intel iwlmvm snd_hda_codec snd_hda_core snd_hwdep snd_pcm snd_timer snd iwlwifi
>> i915 intel_gtt battery ac pcc_cpufreq thermal
>> [   46.053853] CPU: 1 PID: 1824 Comm: systemd-udevd Not tainted 5.0.0-rc1-zen #85
>> [   46.053856] Hardware name: ASUSTeK COMPUTER INC. UX490UA/UX490UA, BIOS UX490UA.312 04/09/2018
>> [   46.053862] RIP: 0010:module_assert_mutex+0x20/0x30
>> [   46.053867] Code: 5d c3 e8 f3 68 f5 ff 0f 1f 00 8b 05 d2 5a 7c 01 85 c0 75 01 c3 be ff ff ff ff 48 c7 c7 80 bc 86 82 e8 e4 27 fb ff 85 c0
>> 75 ea <0f> 0b c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 53 48 89 fb e8 c7
>> [   46.053871] RSP: 0018:ffffc90002aa3ac8 EFLAGS: 00010246
>> [   46.053876] RAX: 0000000000000000 RBX: ffffffffa0573abf RCX: 0000000000000000
>> [   46.053880] RDX: 0000000000000000 RSI: ffffffff8286bc80 RDI: ffff8882a517d570
>> [   46.053883] RBP: ffff8882880e6000 R08: 0000000000000000 R09: ffff8882b1f5d000
>> [   46.053886] R10: 0000000000000001 R11: 0000000000000003 R12: ffffffffa0573abf
>> [   46.053890] R13: ffff8882880e60a0 R14: ffff8882880e6000 R15: ffffffffa0577200
>> [   46.053894] FS:  00007f0ac7d318c0(0000) GS:ffff8882b6a80000(0000) knlGS:0000000000000000
>> [   46.053898] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   46.053902] CR2: 0000560d354ed800 CR3: 00000002880f9003 CR4: 00000000003606e0
>> [   46.053905] Call Trace:
>> [   46.053910]  find_module+0x9/0x20
>>
>> My .config is available upon request.
>>
> 
> Thanks for the config.
> 
> Thanks for finding this. find_module() should be called with
> module_mutex since 4.15. The media allocator patch was written
> before that.
> 
> I didn't realize I don't have CONFIG_DEBUG_MUTEXES=y when I switched
> to a new system.
> 
> I reproduced the problem and re-worked patch 1 and patch 4 in this
> series. I will resend the v10 for just those two patches tomorrow.
> 
> Please let me know if you want me to send the entire series.

Please send the entire series. Less chance of mistakes that way.

Thanks!

	Hans
