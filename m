Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:45502 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab3CUSqF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 14:46:05 -0400
Received: by mail-ve0-f170.google.com with SMTP id 14so2774257vea.29
        for <linux-media@vger.kernel.org>; Thu, 21 Mar 2013 11:46:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201303201218.48929.hverkuil@xs4all.nl>
References: <1363707694-27224-1-git-send-email-edubezval@gmail.com>
	<201303201004.05563.hverkuil@xs4all.nl>
	<CAC-25o-rJGeYnQ91E4W888Ak6GxVe9u6e0ZY-qcpfoaKNkU0hw@mail.gmail.com>
	<201303201218.48929.hverkuil@xs4all.nl>
Date: Thu, 21 Mar 2013 14:46:03 -0400
Message-ID: <CAC-25o-qAs1yB6EqC8bfCXjwCmvWM_2z6SDu0VCuPQVeJvms8Q@mail.gmail.com>
Subject: Re: [PATCH 0/4] media: si4713: minor updates
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,


<snip>

>> > Are you still able to test the si4713 driver? Because I have patches
>>
>>
>>
>> I see. In fact that is my next step on my todo list for si4713. I
>> still have an n900 that I can fetch from my drobe, so just a matter of
>> booting it with newer kernel.
>>
>> > outstanding that I would love for someone to test for me:
>> >
>> > http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/si4713

So, I got my hands on my old n900 and thanks to Aaro and lo community
I could still boot it with 3.9-rc3 kernel! amazing!

I didn't have the time to look at your patches, but I could do a blind
run of v4l2-compliance -r 0 on n900. It follows the results:

#1 on my branch which is
is radio
Driver Info:
	Driver name   : radio-si4713
	Card type     : Silicon Labs Si4713 Modulator
	Bus info      :
	Driver version: 3.9.0
	Capabilities  : 0x00080800
		RDS Output
		Modulator

Compliance test for device /dev/radio0 (not using libv4l2):

Required ioctls:
		fail: v4l2-compliance.cpp(226): string empty
		fail: v4l2-compliance.cpp(278): check_ustring(vcap.bus_info,
sizeof(vcap.bus_info))
	test VIDIOC_QUERYCAP: FAIL

Allow for multiple opens:
	test second radio open: OK
		fail: v4l2-compliance.cpp(226): string empty
		fail: v4l2-compliance.cpp(278): check_ustring(vcap.bus_info,
sizeof(vcap.bus_info))
	test VIDIOC_QUERYCAP: FAIL
		fail: v4l2-compliance.cpp(336): doioctl(node, VIDIOC_G_PRIORITY, &prio)
	test VIDIOC_G/S_PRIORITY: FAIL

Debug ioctls:
	test VIDIOC_DBG_G_CHIP_IDENT: OK (Not Supported)
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 0 Audio Inputs: 0 Tuners: 0

Output ioctls:
		fail: v4l2-test-input-output.cpp(567): V4L2_TUNER_CAP_RDS set, but
not V4L2_CAP_READWRITE
		fail: v4l2-test-input-output.cpp(590): invalid modulator 0
	test VIDIOC_G/S_MODULATOR: FAIL
		fail: v4l2-test-input-output.cpp(675): could get frequency for
invalid modulator 0
	test VIDIOC_G/S_FREQUENCY: FAIL
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Control ioctls:
		fail: v4l2-test-controls.cpp(145): can do querymenu on a non-menu control
		fail: v4l2-test-controls.cpp(201): invalid control 00980001
	test VIDIOC_QUERYCTRL/MENU: FAIL
		fail: v4l2-test-controls.cpp(442): g_ctrl accepted invalid control ID
	test VIDIOC_G/S_CTRL: FAIL
		fail: v4l2-test-controls.cpp(511): g_ext_ctrls does not support count == 0
	test VIDIOC_G/S/TRY_EXT_CTRLS: FAIL
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 0 Private Controls: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)

Total: 38, Succeeded: 30, Failed: 8, Warnings: 0


# on your branch on the other hand I get a NULL pointer:
[    8.995758] Unable to handle kernel NULL pointer dereference at
virtual address 00000008
[    8.996093] pgd = ce5e8000
[    8.996185] [00000008] *pgd=8e532831, *pte=00000000, *ppte=00000000
[    8.996459] Internal error: Oops: 17 [#1] SMP ARM
[    8.996612] Modules linked in: si4713_i2c radio_si4713 v4l2_common videodev
[    8.996948] CPU: 0    Tainted: G        W
(3.9.0-rc1-00205-g0826407-dirty #8)
[    8.997283] PC is at v4l2_prio_open+0x10/0x58 [videodev]
[    8.997528] LR is at v4l2_fh_add+0x24/0x60 [videodev]
[    8.997680] pc : [<bf0000a8>]    lr : [<bf0060a8>]    psr: 80000013
[    8.997680] sp : ce515db0  ip : ce515d3c  fp : ce5189c0
[    8.997955] r10: ce0b5240  r9 : ce4dd1f0  r8 : 00000000
[    8.998107] r7 : ce65d4c8  r6 : ce4df640  r5 : ce65d4c8  r4 : ce4df640
[    8.998260] r3 : 00000008  r2 : ce4df684  r1 : ce4df650  r0 : 00000000
[    8.998474] Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
[    8.998657] Control: 10c5387d  Table: 8e5e8019  DAC: 00000015
[    8.998809] Process v4l2-compliance (pid: 851, stack limit = 0xce514240)
[    8.998992] Stack: (0xce515db0 to 0xce516000)
[    8.999114] 5da0:                                     ce5189c0
bf006198 bf006150 ce65d4d0
[    9.001647] 5dc0: ce5189c0 bf00059c bf0004fc ce4dd0d8 ce5189c0
ce4ca840 00000000 c0120220
[    9.004211] 5de0: ce5189c0 00000000 00000000 ce5189c0 c0120190
ce4dd0d8 ce5189c8 c011ac5c
[    9.006774] 5e00: ce515ec8 ce515f78 00000002 00000000 ce515ec0
00000026 00000000 c011add4
[    9.009338] 5e20: ce515f00 c01294dc ce072800 c0126940 60000013
ce515e48 ce4dd130 cd802708
[    9.011962] 5e40: 00000000 00000000 00000000 00000006 ce4fb015
ce515f78 000efae8 c0127490
[    9.014678] 5e60: 00000000 00000000 ce4dd0d8 ce034a58 c08158f8
ce515f00 ce5189c0 ce514000
[    9.017425] 5e80: ce4fb000 ce515ec8 00000000 ce515f78 ce515ec0
c0129b90 ce515ec8 ce4fb000
[    9.020141] 5ea0: ce2a7400 ce51a104 00000000 c009a2b8 00000000
00000000 ce514000 ce02d7d0
[    9.022796] 5ec0: ce018150 cd9f8660 00000000 00000000 00000000
ce515f78 ce515f00 00000001
[    9.025451] 5ee0: ffffff9c ce4fb000 ce514000 00000000 000efae8
c012a044 00000041 ce02d7c0
[    9.028076] 5f00: ce018150 cd9f8660 b4879d71 00000006 ce4fb015
ce515f78 00000000 cd9c8858
[    9.030731] 5f20: ce4dd0d8 00000101 00000004 00000000 00000000
ce02d780 00000000 c0137724
[    9.033355] 5f40: ce02d7c0 00000002 000efae8 ce4fb000 00000002
00000000 ce4fb000 00000002
[    9.035949] 5f60: 00000003 ffffff9c 00000001 c011a8c0 00000000
ef000000 00000002 c0090000
[    9.038574] 5f80: 00000026 00000100 00000000 00000000 000ef95c
00000000 00000005 c00144a8
[    9.041198] 5fa0: 00000000 c0014300 00000000 000ef95c 000efae8
00000002 00000000 00000000
[    9.043792] 5fc0: 00000000 000ef95c 00000000 00000005 becbecc8
00000000 0014a808 000efae8
[    9.046386] 5fe0: becbeceb becbe0e8 000097d8 0001cbac 60000010
000efae8 00000000 00000000
[    9.049133] [<bf0000a8>] (v4l2_prio_open+0x10/0x58 [videodev]) from
[<bf0060a8>] (v4l2_fh_add+0x24/0x60 [videodev])
[    9.054534] [<bf0060a8>] (v4l2_fh_add+0x24/0x60 [videodev]) from
[<bf006198>] (v4l2_fh_open+0x48/0x58 [videodev])
[    9.060089] [<bf006198>] (v4l2_fh_open+0x48/0x58 [videodev]) from
[<bf00059c>] (v4l2_open+0xa0/0xe0 [videodev])
[    9.065856] [<bf00059c>] (v4l2_open+0xa0/0xe0 [videodev]) from
[<c0120220>] (chrdev_open+0x90/0x150)
[    9.071746] [<c0120220>] (chrdev_open+0x90/0x150) from [<c011ac5c>]
(do_dentry_open+0x1f8/0x280)
[    9.074890] [<c011ac5c>] (do_dentry_open+0x1f8/0x280) from
[<c011add4>] (finish_open+0x34/0x50)
[    9.078063] [<c011add4>] (finish_open+0x34/0x50) from [<c01294dc>]
(do_last+0x5b0/0xbb4)
[    9.081237] [<c01294dc>] (do_last+0x5b0/0xbb4) from [<c0129b90>]
(path_openat+0xb0/0x464)
[    9.084442] [<c0129b90>] (path_openat+0xb0/0x464) from [<c012a044>]
(do_filp_open+0x30/0x84)
[    9.087646] [<c012a044>] (do_filp_open+0x30/0x84) from [<c011a8c0>]
(do_sys_open+0xe0/0x170)
[    9.090911] [<c011a8c0>] (do_sys_open+0xe0/0x170) from [<c0014300>]
(ret_fast_syscall+0x0/0x3c)
[    9.094146] Code: e5913000 e3530002 012fff1e e2803008 (e193cf9f)
[    9.097686] ---[ end trace f9c354f7ca1aeb09 ]---
>> >
>> > In particular, run the latest v4l2-compliance test over it.
>> >
>>
>>
>> OK. I will check your branch once I get my setup done and let you know.
>
> Great! Let me quickly rebase my tree first. I'll mail you when that's done.
>
> Regards,
>
>         Hans



-- 
Eduardo Bezerra Valentin
