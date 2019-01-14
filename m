Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E5D9C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 12:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D288320656
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 12:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfANMrh (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 07:47:37 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:54800 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfANMrg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 07:47:36 -0500
Received: from [IPv6:2804:431:9719:bf7d:1558:9404:b5d6:dfc1] (unknown [IPv6:2804:431:9719:bf7d:1558:9404:b5d6:dfc1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: koike)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 7062A277BC1;
        Mon, 14 Jan 2019 12:47:32 +0000 (GMT)
Subject: Re: vimc kernel warning and kernel oops
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>
References: <3a4770e4-851c-78fd-73c3-a919bd190347@xs4all.nl>
From:   Helen Koike <helen.koike@collabora.com>
Openpgp: preference=signencrypt
Autocrypt: addr=helen.koike@collabora.com; keydata=
 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
Message-ID: <04ee738f-bb04-338c-273c-366f052c7702@collabora.com>
Date:   Mon, 14 Jan 2019 10:47:26 -0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <3a4770e4-851c-78fd-73c3-a919bd190347@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Hans

On 1/11/19 1:25 PM, Hans Verkuil wrote:
> Hi Helen,
> 
> I've started work to fix the last compliance failures with vimc so that
> vimc can be used in regression tests.
> 
> But I found a kernel warning and a kernel oops using vimc from our master tree.
> 
> To test, load vimc, then run:
> 
> v4l2-ctl -d2 -v width=1920,height=1440
> v4l2-ctl -d2 --stream-mmap
> 
> This is the first kernel warning:
> 
> [  671.799450] ------------[ cut here ]------------
> [  671.799471] do not call blocking ops when !TASK_RUNNING; state=2 set at [<0000000050c41bbb>] vimc_sen_tpg_thread+0x0/0x110 [vimc_sensor]
> [  671.799487] WARNING: CPU: 5 PID: 31428 at kernel/sched/core.c:6099 __might_sleep+0x63/0x70
> [  671.799492] Modules linked in: vimc_scaler vimc_sensor v4l2_tpg vimc_capture videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 vimc_debayer videobuf2_common vimc_common vimc videodev media
> vmw_vsock_vmci_transport vmw_balloon vmwgfx ttm vmw_vmci button [last unloaded: media]
> [  671.799515] CPU: 5 PID: 31428 Comm: vimc vimc.0-sen Not tainted 5.0.0-rc1-test-nl #23
> [  671.799518] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
> [  671.799522] RIP: 0010:__might_sleep+0x63/0x70
> [  671.799526] Code: 5b 5d 41 5c e9 3e ff ff ff 48 8b 90 f0 20 00 00 48 8b 70 10 48 c7 c7 98 79 30 82 c6 05 91 fb 5b 01 01 48 89 d1 e8 14 91 fd ff <0f> 0b eb ca 66 0f 1f 84 00 00 00 00 00 55 53 48 83
> ec 08 65 48 8b
> [  671.799529] RSP: 0018:ffffc90016457ec8 EFLAGS: 00010282
> [  671.799532] RAX: 0000000000000000 RBX: ffffffffa00ec398 RCX: 0000000000000000
> [  671.799535] RDX: 0000000000000007 RSI: ffffffff8232b345 RDI: 00000000ffffffff
> [  671.799537] RBP: 0000000000000039 R08: 0000000000000000 R09: 0000000000000000
> [  671.799540] R10: 000000007e7cfc77 R11: ffffc90016457d70 R12: 0000000000000000
> [  671.799542] R13: ffff88842afc4168 R14: ffff88842afc4000 R15: ffffffffa00eb0e0
> [  671.799545] FS:  0000000000000000(0000) GS:ffff88842ed40000(0000) knlGS:0000000000000000
> [  671.799585] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  671.799587] CR2: 000056027a051cc0 CR3: 00000004136ec000 CR4: 00000000003406e0
> [  671.799615] Call Trace:
> [  671.799624]  vimc_sen_tpg_thread+0x72/0x110 [vimc_sensor]
> [  671.799632]  kthread+0x113/0x130
> [  671.799637]  ? kthread_create_on_node+0x60/0x60
> [  671.799645]  ret_from_fork+0x22/0x40
> [  671.799653] ---[ end trace 9048b36dd38333b9 ]---
> 
> The cause is that set_current_state(TASK_UNINTERRUPTIBLE); is called too early,
> it should be called just before the schedule_timeout().
> 
> The kernel oops follows the warning:
> 
> [  671.800597] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> [  671.800600] #PF error: [normal kernel read fault]
> [  671.800602] PGD 0 P4D 0
> [  671.800606] Oops: 0000 [#1] PREEMPT SMP
> [  671.800609] CPU: 5 PID: 31428 Comm: vimc vimc.0-sen Tainted: G        W         5.0.0-rc1-test-nl #23
> [  671.800610] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/13/2018
> [  671.800615] RIP: 0010:vimc_deb_process_frame+0x14b/0x2b0 [vimc_debayer]
> [  671.800617] Code: 4c 24 08 41 89 f0 48 8d 1c 12 8d 4e ff 45 0f af c4 48 89 5c 24 10 48 89 4c 24 18 48 8b 4c 24 08 89 fa 83 e2 01 48 03 54 24 10 <44> 8b 4c 91 04 44 89 c1 4a 8d 6c 8c 38 44 8b 55 00
> 85 f6 74 32 48
> [  671.800619] RSP: 0018:ffffc90016457e38 EFLAGS: 00010246
> [  671.800622] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [  671.800623] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000000
> [  671.800625] RBP: ffff888422331b40 R08: 0000000000000000 R09: 0000000000000001
> [  671.800628] R10: 00000000000001df R11: 0000000000000001 R12: 0000000000000000
> [  671.800630] R13: 0000000000000000 R14: 0000000000000280 R15: ffff88842a465800
> [  671.800632] FS:  0000000000000000(0000) GS:ffff88842ed40000(0000) knlGS:0000000000000000
> [  671.800635] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  671.800637] CR2: 0000000000000004 CR3: 00000004136ec000 CR4: 00000000003406e0
> [  671.800641] Call Trace:
> [  671.800647]  ? vimc_sen_enum_mbus_code+0x30/0x30 [vimc_sensor]
> [  671.800651]  vimc_propagate_frame+0x8f/0xa0 [vimc_common]
> [  671.800655]  vimc_sen_tpg_thread+0xcb/0x110 [vimc_sensor]
> [  671.800660]  kthread+0x113/0x130
> [  671.800663]  ? kthread_create_on_node+0x60/0x60
> [  671.800667]  ret_from_fork+0x22/0x40
> [  671.800671] Modules linked in: vimc_scaler vimc_sensor v4l2_tpg vimc_capture videobuf2_vmalloc videobuf2_memops videobuf2_v4l2 vimc_debayer videobuf2_common vimc_common vimc videodev media
> vmw_vsock_vmci_transport vmw_balloon vmwgfx ttm vmw_vmci button [last unloaded: media]
> [  671.800681] CR2: 0000000000000004
> [  671.800685] ---[ end trace 9048b36dd38333ba ]---
> 
> The reason for this is that in vimc_deb_s_stream() this call:
> 
> vdeb->sink_pix_map = vimc_deb_pix_map_by_code(vdeb->sink_fmt.code);
> 
> sets vdeb->sink_pix_map to NULL since vdeb->sink_fmt.code isn't a Bayer code, but
> s_stream just continues without returning an error.
> 
> The core problem is that sink_fmt.code is initialized with a code that isn't legal
> for the debayer subdev:
> 
> $ v4l2-ctl -d /dev/v4l-subdev2 --get-subdev-fmt --list-subdev-mbus-codes 0
> ioctl: VIDIOC_SUBDEV_G_FMT (pad=0)
>         Width/Height      : 640/480
>         Mediabus Code     : 0x100a (MEDIA_BUS_FMT_RGB888_1X24)
>         Field             : None
>         Colorspace        : Default
>         Transfer Function : Default (maps to Rec. 709)
>         YCbCr/HSV Encoding: Default (maps to ITU-R 601)
>         Quantization      : Default (maps to Full Range)
> ioctl: VIDIOC_SUBDEV_ENUM_MBUS_CODE (pad=0)
>         0x3001: MEDIA_BUS_FMT_SBGGR8_1X8
>         0x3013: MEDIA_BUS_FMT_SGBRG8_1X8
>         0x3002: MEDIA_BUS_FMT_SGRBG8_1X8
>         0x3014: MEDIA_BUS_FMT_SRGGB8_1X8
>         0x3007: MEDIA_BUS_FMT_SBGGR10_1X10
>         0x300e: MEDIA_BUS_FMT_SGBRG10_1X10
>         0x300a: MEDIA_BUS_FMT_SGRBG10_1X10
>         0x300f: MEDIA_BUS_FMT_SRGGB10_1X10
>         0x3008: MEDIA_BUS_FMT_SBGGR12_1X12
>         0x3010: MEDIA_BUS_FMT_SGBRG12_1X12
>         0x3011: MEDIA_BUS_FMT_SGRBG12_1X12
>         0x3012: MEDIA_BUS_FMT_SRGGB12_1X12
> 
> That's obviously not right.
> 
> Can you take a look at these issues?

Sure, I'll take a look, thanks for reporting it.

Helen

> 
> Thanks!
> 
> 	Hans
> 
