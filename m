Return-Path: <SRS0=NtRf=QX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32913C43381
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 11:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EA8E8222DD
	for <linux-media@archiver.kernel.org>; Sat, 16 Feb 2019 11:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfBPLM6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 16 Feb 2019 06:12:58 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:41184 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726012AbfBPLM6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Feb 2019 06:12:58 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud9.xs4all.net with ESMTPA
        id uxtrg1HiFI8AWuxtvg67q3; Sat, 16 Feb 2019 12:12:55 +0100
Subject: Re: vimc kernel warning and kernel oops
To:     Helen Koike <helen.koike@collabora.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>
References: <3a4770e4-851c-78fd-73c3-a919bd190347@xs4all.nl>
 <04ee738f-bb04-338c-273c-366f052c7702@collabora.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <553b14a5-9fd5-399a-35bb-2730d98c6df5@xs4all.nl>
Date:   Sat, 16 Feb 2019 12:12:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <04ee738f-bb04-338c-273c-366f052c7702@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfBe3L2DDJ2wKcpDeyI/fr2xtj8aqgzoltLYktf3/2kPaZT65wl3ADssQQyEGks7jFzadZQ9QBeJT5DjEL3PvX6N9reyTLmgp+uI5pFnuE9uohx3Tbwnh
 PvK7P31Kr20R+6yvu773ElXqJuCze1jBJEi+VOD2+Kn0OCYukHh5AV9tAxLJICxvXxy6ytZQtKR8MElhadA4rNOnrmFjFcTNBaV/MFFhiaC+4fmvbpL/41CG
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 1/14/19 1:47 PM, Helen Koike wrote:
> Hi Hans
> 
> On 1/11/19 1:25 PM, Hans Verkuil wrote:
>> Hi Helen,
>>
>> I've started work to fix the last compliance failures with vimc so that
>> vimc can be used in regression tests.
>>
>> But I found a kernel warning and a kernel oops using vimc from our master tree.
>>
>> To test, load vimc, then run:
>>
>> v4l2-ctl -d2 -v width=1920,height=1440
>> v4l2-ctl -d2 --stream-mmap
>>
>> This is the first kernel warning:
>>
>> [  671.799450] ------------[ cut here ]------------
>> [  671.799471] do not call blocking ops when !TASK_RUNNING; state=2 set at [<0000000050c41bbb>] vimc_sen_tpg_thread+0x0/0x110 [vimc_sensor]
>> [  671.799487] WARNING: CPU: 5 PID: 31428 at kernel/sched/core.c:6099 __might_sleep+0x63/0x70
>> [  671.799492] Modules linked in: vimc_scaler vimc_sensor v4l2_tpg vimc_capture videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 vimc_debayer videobuf2_common vimc_common vimc videodev media
>> vmw_vsock_vmci_transport vmw_balloon vmwgfx ttm vmw_vmci button [last unloaded: media]
>> [  671.799515] CPU: 5 PID: 31428 Comm: vimc vimc.0-sen Not tainted 5.0.0-rc1-test-nl #23
>> [  671.799518] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
>> [  671.799522] RIP: 0010:__might_sleep+0x63/0x70
>> [  671.799526] Code: 5b 5d 41 5c e9 3e ff ff ff 48 8b 90 f0 20 00 00 48 8b 70 10 48 c7 c7 98 79 30 82 c6 05 91 fb 5b 01 01 48 89 d1 e8 14 91 fd ff <0f> 0b eb ca 66 0f 1f 84 00 00 00 00 00 55 53 48 83
>> ec 08 65 48 8b
>> [  671.799529] RSP: 0018:ffffc90016457ec8 EFLAGS: 00010282
>> [  671.799532] RAX: 0000000000000000 RBX: ffffffffa00ec398 RCX: 0000000000000000
>> [  671.799535] RDX: 0000000000000007 RSI: ffffffff8232b345 RDI: 00000000ffffffff
>> [  671.799537] RBP: 0000000000000039 R08: 0000000000000000 R09: 0000000000000000
>> [  671.799540] R10: 000000007e7cfc77 R11: ffffc90016457d70 R12: 0000000000000000
>> [  671.799542] R13: ffff88842afc4168 R14: ffff88842afc4000 R15: ffffffffa00eb0e0
>> [  671.799545] FS:  0000000000000000(0000) GS:ffff88842ed40000(0000) knlGS:0000000000000000
>> [  671.799585] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  671.799587] CR2: 000056027a051cc0 CR3: 00000004136ec000 CR4: 00000000003406e0
>> [  671.799615] Call Trace:
>> [  671.799624]  vimc_sen_tpg_thread+0x72/0x110 [vimc_sensor]
>> [  671.799632]  kthread+0x113/0x130
>> [  671.799637]  ? kthread_create_on_node+0x60/0x60
>> [  671.799645]  ret_from_fork+0x22/0x40
>> [  671.799653] ---[ end trace 9048b36dd38333b9 ]---
>>
>> The cause is that set_current_state(TASK_UNINTERRUPTIBLE); is called too early,
>> it should be called just before the schedule_timeout().
>>
>> The kernel oops follows the warning:
>>
>> [  671.800597] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
>> [  671.800600] #PF error: [normal kernel read fault]
>> [  671.800602] PGD 0 P4D 0
>> [  671.800606] Oops: 0000 [#1] PREEMPT SMP
>> [  671.800609] CPU: 5 PID: 31428 Comm: vimc vimc.0-sen Tainted: G        W         5.0.0-rc1-test-nl #23
>> [  671.800610] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
>> [  671.800615] RIP: 0010:vimc_deb_process_frame+0x14b/0x2b0 [vimc_debayer]
>> [  671.800617] Code: 4c 24 08 41 89 f0 48 8d 1c 12 8d 4e ff 45 0f af c4 48 89 5c 24 10 48 89 4c 24 18 48 8b 4c 24 08 89 fa 83 e2 01 48 03 54 24 10 <44> 8b 4c 91 04 44 89 c1 4a 8d 6c 8c 38 44 8b 55 00
>> 85 f6 74 32 48
>> [  671.800619] RSP: 0018:ffffc90016457e38 EFLAGS: 00010246
>> [  671.800622] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
>> [  671.800623] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000000
>> [  671.800625] RBP: ffff888422331b40 R08: 0000000000000000 R09: 0000000000000001
>> [  671.800628] R10: 00000000000001df R11: 0000000000000001 R12: 0000000000000000
>> [  671.800630] R13: 0000000000000000 R14: 0000000000000280 R15: ffff88842a465800
>> [  671.800632] FS:  0000000000000000(0000) GS:ffff88842ed40000(0000) knlGS:0000000000000000
>> [  671.800635] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  671.800637] CR2: 0000000000000004 CR3: 00000004136ec000 CR4: 00000000003406e0
>> [  671.800641] Call Trace:
>> [  671.800647]  ? vimc_sen_enum_mbus_code+0x30/0x30 [vimc_sensor]
>> [  671.800651]  vimc_propagate_frame+0x8f/0xa0 [vimc_common]
>> [  671.800655]  vimc_sen_tpg_thread+0xcb/0x110 [vimc_sensor]
>> [  671.800660]  kthread+0x113/0x130
>> [  671.800663]  ? kthread_create_on_node+0x60/0x60
>> [  671.800667]  ret_from_fork+0x22/0x40
>> [  671.800671] Modules linked in: vimc_scaler vimc_sensor v4l2_tpg vimc_capture videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 vimc_debayer videobuf2_common vimc_common vimc videodev media
>> vmw_vsock_vmci_transport vmw_balloon vmwgfx ttm vmw_vmci button [last unloaded: media]
>> [  671.800681] CR2: 0000000000000004
>> [  671.800685] ---[ end trace 9048b36dd38333ba ]---
>>
>> The reason for this is that in vimc_deb_s_stream() this call:
>>
>> vdeb->sink_pix_map = vimc_deb_pix_map_by_code(vdeb->sink_fmt.code);
>>
>> sets vdeb->sink_pix_map to NULL since vdeb->sink_fmt.code isn't a Bayer code, but
>> s_stream just continues without returning an error.
>>
>> The core problem is that sink_fmt.code is initialized with a code that isn't legal
>> for the debayer subdev:
>>
>> $ v4l2-ctl -d /dev/v4l-subdev2 --get-subdev-fmt --list-subdev-mbus-codes 0
>> ioctl: VIDIOC_SUBDEV_G_FMT (pad=0)
>>         Width/Height      : 640/480
>>         Mediabus Code     : 0x100a (MEDIA_BUS_FMT_RGB888_1X24)
>>         Field             : None
>>         Colorspace        : Default
>>         Transfer Function : Default (maps to Rec. 709)
>>         YCbCr/HSV Encoding: Default (maps to ITU-R 601)
>>         Quantization      : Default (maps to Full Range)
>> ioctl: VIDIOC_SUBDEV_ENUM_MBUS_CODE (pad=0)
>>         0x3001: MEDIA_BUS_FMT_SBGGR8_1X8
>>         0x3013: MEDIA_BUS_FMT_SGBRG8_1X8
>>         0x3002: MEDIA_BUS_FMT_SGRBG8_1X8
>>         0x3014: MEDIA_BUS_FMT_SRGGB8_1X8
>>         0x3007: MEDIA_BUS_FMT_SBGGR10_1X10
>>         0x300e: MEDIA_BUS_FMT_SGBRG10_1X10
>>         0x300a: MEDIA_BUS_FMT_SGRBG10_1X10
>>         0x300f: MEDIA_BUS_FMT_SRGGB10_1X10
>>         0x3008: MEDIA_BUS_FMT_SBGGR12_1X12
>>         0x3010: MEDIA_BUS_FMT_SGBRG12_1X12
>>         0x3011: MEDIA_BUS_FMT_SGRBG12_1X12
>>         0x3012: MEDIA_BUS_FMT_SRGGB12_1X12
>>
>> That's obviously not right.
>>
>> Can you take a look at these issues?
> 
> Sure, I'll take a look, thanks for reporting it.

Gentle reminder, this is still happening.

Regards,

	Hans

> 
> Helen
> 
>>
>> Thanks!
>>
>> 	Hans
>>

