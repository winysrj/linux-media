Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f182.google.com ([209.85.128.182]:47750 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964942Ab3DHPdK (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 11:33:10 -0400
Received: by mail-ve0-f182.google.com with SMTP id m1so5516543ves.13
        for <linux-media@vger.kernel.org>; Mon, 08 Apr 2013 08:33:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC-25o9A3e2j+cwADcYb19rG3-2pMC5uj7JaBkQ6dCnF+trLJQ@mail.gmail.com>
References: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
	<CAC-25o9A3e2j+cwADcYb19rG3-2pMC5uj7JaBkQ6dCnF+trLJQ@mail.gmail.com>
Date: Mon, 8 Apr 2013 11:33:09 -0400
Message-ID: <CAC-25o_3dJAefuHS-6CLtcEZbmedQ1HZyd0QZnLfdib4-BkAWQ@mail.gmail.com>
Subject: Re: [REVIEW PATCH 0/7] radio-si4713: driver overhaul
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

On Mon, Apr 8, 2013 at 8:03 AM, edubezval@gmail.com <edubezval@gmail.com> wrote:
> Hans,
>
>
>
> On Mon, Apr 8, 2013 at 6:47 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> This patch series makes radio-si4713 compliant with v4l2-compliance.
>>
>
> Thanks for your patches.
>
>> Eduardo, thanks for testing the previous code. I hope this version resolves
>> all the issues we found. Can you test again?
>>
>
> Of course, I will take some time to review and test them for you.
>
>> This code is also available here:
>>
>> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/si4713b
>>
>> Make sure you also update v4l2-compliance: I found a bug in the way RDS
>> capabilities were tested.
>
> OK. sure.
>

Here is the output of updated v4l2-compliant without your changes.
This will be the same output for patches 01 and 02 of your series:
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
		fail: v4l2-compliance.cpp(277): check_ustring(vcap.bus_info,
sizeof(vcap.bus_info))
	test VIDIOC_QUERYCAP: FAIL

Allow for multiple opens:
	test second radio open: OK
		fail: v4l2-compliance.cpp(226): string empty
		fail: v4l2-compliance.cpp(277): check_ustring(vcap.bus_info,
sizeof(vcap.bus_info))
	test VIDIOC_QUERYCAP: FAIL
		fail: v4l2-compliance.cpp(335): doioctl(node, VIDIOC_G_PRIORITY, &prio)
	test VIDIOC_G/S_PRIORITY: FAIL

Debug ioctls:
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
	test VIDIOC_G/S_MODULATOR: OK
		fail: v4l2-test-input-output.cpp(655): could not set rangelow-1 frequency
	test VIDIOC_G/S_FREQUENCY: FAIL
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 1

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

Total: 36, Succeeded: 29, Failed: 7, Warnings: 0

>>
>> Regards,
>>
>>         Hans
>>
>
>
>
> --
> Eduardo Bezerra Valentin



-- 
Eduardo Bezerra Valentin
