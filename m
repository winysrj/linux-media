Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44601 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755246Ab3BERId (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Feb 2013 12:08:33 -0500
Received: by mail-wi0-f178.google.com with SMTP id o1so508751wic.5
        for <linux-media@vger.kernel.org>; Tue, 05 Feb 2013 09:08:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALF0-+X3rwi6Dg8G8aDcv65Kz7hRM4qRhBUmMymW_JmifSFysQ@mail.gmail.com>
References: <1359981381-23901-1-git-send-email-hverkuil@xs4all.nl>
	<201302041435.26878.hverkuil@xs4all.nl>
	<CA+6av4kp54eQSeefAnJxY80HtOJ5iCBh+ETOZaKQHbo=m86-DQ@mail.gmail.com>
	<201302051635.08448.hverkuil@xs4all.nl>
	<CALF0-+X3rwi6Dg8G8aDcv65Kz7hRM4qRhBUmMymW_JmifSFysQ@mail.gmail.com>
Date: Tue, 5 Feb 2013 18:08:31 +0100
Message-ID: <CA+6av4nj+Gvt2ivVm6YdaMtqF44n7JA3ZSK55CeefonFuaMjTQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/8] stk-webcam: various fixes.
From: Arvydas Sidorenko <asido4@gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 5, 2013 at 5:56 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> On Tue, Feb 5, 2013 at 12:35 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On Tue February 5 2013 16:28:17 Arvydas Sidorenko wrote:
>>>
>>> I have tested the patches using STK-1135 webcam. Everything works well.
>>>
>>> $ v4l2-compliance -d /dev/video0
>>> Driver Info:
>>>       Driver name   : stk
>>>       Card type     : stk
>>>       Bus info      :
>>>       Driver version: 0.0.1
>>
>> This is the old version of the driver you are testing with :-)
>>
>
> @Arvydas: First of all, thanks for taking the time to test Hans' patches.
>
> I suggest to double check the old driver
> is not loaded and then run "depmod -a" to update modules.
>
> As a last resource you can always wipe out the driver from
> /lib/modules/what-ever and reinstall.
>
> Hope this helps!
>
> --
>     Ezequiel

Yes, I am sorry. I built the wrong branch.

The cam works, but the view is upside down.

$ v4l2-compliance -d /dev/video0
Driver Info:
	Driver name   : stk
	Card type     : stk
	Bus info      : 4-8
	Driver version: 3.1.0
	Capabilities  : 0x85000001
		Video Capture
		Read/Write
		Streaming
		Device Capabilities
	Device Caps   : 0x05000001
		Video Capture
		Read/Write
		Streaming

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
		fail: v4l2-compliance.cpp(285): missing bus_info prefix ('4-8')
	test VIDIOC_QUERYCAP: FAIL

Allow for multiple opens:
	test second video open: OK
		fail: v4l2-compliance.cpp(285): missing bus_info prefix ('4-8')
	test VIDIOC_QUERYCAP: FAIL
	test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
	test VIDIOC_DBG_G_CHIP_IDENT: OK (Not Supported)
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK

Input ioctls:
	test VIDIOC_G/S_TUNER: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 1 Audio Inputs: 0 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Control ioctls:
	test VIDIOC_QUERYCTRL/MENU: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 4 Private Controls: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
		fail: v4l2-test-formats.cpp(566): Video Capture is valid, but
TRY_FMT failed to return a format
	test VIDIOC_TRY_FMT: FAIL
		fail: v4l2-test-formats.cpp(719): Video Capture is valid, but no
S_FMT was implemented
	test VIDIOC_S_FMT: FAIL
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
		fail: v4l2-test-buffers.cpp(132): ret != -1
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: FAIL

Total: 38, Succeeded: 33, Failed: 5, Warnings: 0
