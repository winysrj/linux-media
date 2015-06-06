Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:36570 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbbFFWWD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2015 18:22:03 -0400
Received: by qgep100 with SMTP id p100so38030358qge.3
        for <linux-media@vger.kernel.org>; Sat, 06 Jun 2015 15:22:02 -0700 (PDT)
Message-ID: <557371C3.9080304@vanguardiasur.com.ar>
Date: Sat, 06 Jun 2015 19:18:43 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Michael Stegemann <michael@stegemann.it>,
	Dale Hamel <dale.hamel@srvthe.net>
Subject: Re: [PATCH] stk1160: Add frame scaling support
References: <1432851543-3576-1-git-send-email-ezequiel@vanguardiasur.com.ar> <557183F6.4010600@xs4all.nl>
In-Reply-To: <557183F6.4010600@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 06/05/2015 08:11 AM, Hans Verkuil wrote:
> Hi Ezequiel,
> 
> As mentioned in irc: run v4l2-compliance -s and v4l2-compliance -f.
> I quickly tried it and v4l2-compliance fails:
> 
> Test input 0:
> 
>         Control ioctls:
>                 test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>                 test VIDIOC_QUERYCTRL: OK
>                 test VIDIOC_G/S_CTRL: OK
>                 test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>                 test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>                 test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>                 Standard Controls: 7 Private Controls: 0
> 
>         Format ioctls:
>                 test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>                 test VIDIOC_G/S_PARM: OK
>                 test VIDIOC_G_FBUF: OK (Not Supported)
>                 test VIDIOC_G_FMT: OK
>                 fail: v4l2-test-formats.cpp(422): !pix.width || !pix.height
>                 fail: v4l2-test-formats.cpp(726): Video Capture is valid, but TRY_FMT failed to return a format
>                 test VIDIOC_TRY_FMT: FAIL
>                 fail: v4l2-test-formats.cpp(422): !pix.width || !pix.height
>                 fail: v4l2-test-formats.cpp(942): Video Capture is valid, but no S_FMT was implemented
>                 test VIDIOC_S_FMT: FAIL
>                 test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>                 test Cropping: OK (Not Supported)
>                 test Composing: OK (Not Supported)
> 
> and it ends with a segfault and this in the kernel log:
> 
> [  180.135178] stk1160: width 720, height 480
> [  180.135187] stk1160: width 0, height 0
> [  180.135240] stk1160: width 0, height 0
> [  180.135317] stk1160: decimate 0x1f, column units -721, row units -481
> [  180.135450] stk1160: width 1, height 1
> [  180.135524] stk1160: decimate 0x1f, column units 719, row units 479
> [  180.135572] stk1160: width 720, height 480
> [  180.135701] stk1160: decimate 0x10, column units 0, row units 0
> [  180.135750] divide error: 0000 [#1] PREEMPT SMP 
> [  180.135773] Modules linked in: stk1160 ivtv_alsa tuner_simple tuner_types tda9887 tda8290 tuner msp3400 saa7127 ivtv saa7115 videobuf2_vmalloc tveeprom videobuf2_memops videobuf2_core cx2341x v4l2_common videodev media x86_pkg_temp_thermal processor button [last unloaded: stk1160]
> [  180.135851] CPU: 2 PID: 7391 Comm: v4l2-compliance Not tainted 4.1.0-rc3-koryphon #837
> [  180.135862] Hardware name: ASUSTeK COMPUTER INC. Z10PA-U8 Series/Z10PA-U8 Series, BIOS 0303 11/20/2014
> [  180.135873] task: ffff8810364b1830 ti: ffff88100c794000 task.ti: ffff88100c794000
> [  180.135882] RIP: 0010:[<ffffffffa003ed9a>]  [<ffffffffa003ed9a>] stk1160_try_fmt.isra.5+0x1ba/0x1e0 [stk1160]
> [  180.135902] RSP: 0018:ffff88100c797bd8  EFLAGS: 00010202
> [  180.135910] RAX: 00000000000002d0 RBX: 0000000000000000 RCX: ffff88100c797c14
> [  180.135918] RDX: 0000000000000000 RSI: ffff8810364107c0 RDI: 00000000000001e0
> [  180.135927] RBP: ffff88100c797bf8 R08: ffff881036537500 R09: 00000000000001e0
> [  180.135939] R10: 0000000000000000 R11: 0000000000000005 R12: 0000000000000000
> [  180.135948] R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000000
> [  180.135958] FS:  00007f7acbad8740(0000) GS:ffff88107fc80000(0000) knlGS:0000000000000000
> [  180.135968] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  180.135975] CR2: 00007faa881e4148 CR3: 000000102974d000 CR4: 00000000001406e0
> [  180.135984] Stack:
> [  180.136003]  ffff881036410000 0000000000000000 ffff881036537500 ffff881036536c00
> [  180.136018]  ffff88100c797c48 ffffffffa003ee4b ffff88100c797c58 ffff000081a0dbc2
> [  180.136033]  0000000100000001 0000000000000000 ffff88100c797c48 ffff881036537500
> [  180.136048] Call Trace:
> [  180.136057]  [<ffffffffa003ee4b>] vidioc_s_fmt_vid_cap+0x4b/0xf0 [stk1160]
> [  180.136073]  [<ffffffffa074e163>] v4l_s_fmt+0x123/0x490 [videodev]
> [  180.136086]  [<ffffffffa074d294>] __video_do_ioctl+0x274/0x310 [videodev]
> [  180.136099]  [<ffffffffa074ee4a>] ? video_usercopy+0x2fa/0x4c0 [videodev]
> [  180.136111]  [<ffffffffa074ee86>] video_usercopy+0x336/0x4c0 [videodev]
> [  180.136122]  [<ffffffffa074d020>] ? v4l_querycap+0x60/0x60 [videodev]
> [  180.136135]  [<ffffffff813dea63>] ? __this_cpu_preempt_check+0x13/0x20
> [  180.136146]  [<ffffffff810d325f>] ? __srcu_read_lock+0x5f/0xa0
> [  180.136157]  [<ffffffffa074f020>] video_ioctl2+0x10/0x20 [videodev]
> [  180.136168]  [<ffffffffa07486a0>] v4l2_ioctl+0xd0/0xf0 [videodev]
> [  180.136179]  [<ffffffff8118fc60>] do_vfs_ioctl+0x2e0/0x4e0
> [  180.136187]  [<ffffffff8117bccc>] ? vfs_write+0x14c/0x1b0
> [  180.136196]  [<ffffffff8118fee1>] SyS_ioctl+0x81/0xa0
> [  180.136208]  [<ffffffff81a1266e>] system_call_fastpath+0x12/0x71
> [  180.136216] Code: 31 d2 41 89 c1 41 89 40 0c e9 d0 fe ff ff 0f 1f 00 44 89 d0 41 be 01 00 00 00 45 31 ed c1 e8 1f 44 01 d0 d1 f8 05 d0 02 00 00 99 <41> f7 fa 31 d2 41 89 c2 44 8d 60 ff b8 d0 02 00 00 41 f7 f2 41 
> [  180.136354] RIP  [<ffffffffa003ed9a>] stk1160_try_fmt.isra.5+0x1ba/0x1e0 [stk1160]
> [  180.136366]  RSP <ffff88100c797bd8>
> [  180.139977] ---[ end trace a699ade0cf2b43de ]---
> 
> So this needs a bit more work... Remember: v4l2-compliance is your friend! :-)
> 

Indeed, sorry about that.

> I didn't review the patch, this should be fixed first.
> 
> BTW, I noticed that this driver is logging a lot in the kernel log. Normal
> operation of a driver shouldn't log anything, so can you fix this while you're
> at it?
> 

Done.

Thanks a lot for the feedback,
-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
