Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33719 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab2FCVoF (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jun 2012 17:44:05 -0400
Received: by obbtb18 with SMTP id tb18so6228664obb.19
        for <linux-media@vger.kernel.org>; Sun, 03 Jun 2012 14:44:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201206031233.24758.hverkuil@xs4all.nl>
References: <1338651169-10446-1-git-send-email-elezegarcia@gmail.com>
	<CALF0-+W5DCf1HMs=MYMc2KVgz=SJKS2YLY7LSrxU6-gnc=+LAA@mail.gmail.com>
	<201206031233.24758.hverkuil@xs4all.nl>
Date: Sun, 3 Jun 2012 18:44:03 -0300
Message-ID: <CALF0-+XYy+fUsksYF+ok7PTZs0tX+L2G9z48NpYU4wdyPZcHzQ@mail.gmail.com>
Subject: Re: [RFC/PATCH v2] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sylwester Nawrocki <snjw23@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

On Sun, Jun 3, 2012 at 7:33 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Thanks. I've fixed several things reported by v4l2-compliance (see my patch
> below), but you are using an older v4l2-compliance version. You should clone
> and compile the v4l-utils.git repository yourself, rather than using a distro
> provided version (which I think is what you are doing now).
>
> Can you apply my patch on yours and run the latest v4l2-compliance again?

I applied your patch, updated v4l2-compliance and here is the output:

---
$ v4l2-compliance -d /dev/video1
Driver Info:
	Driver name   : stk1160
	Card type     : stk1160
	Bus info      : usb-0000:00:13.2-1
	Driver version: 3.4.0
	Capabilities  : 0x85000001
		Video Capture
		Read/Write
		Streaming
		Device Capabilities
	Device Caps   : 0x05000001
		Video Capture
		Read/Write
		Streaming

Compliance test for device /dev/video1 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
	test VIDIOC_DBG_G_CHIP_IDENT: Not Supported
	test VIDIOC_DBG_G/S_REGISTER: Not Supported
	test VIDIOC_LOG_STATUS: OK

Input ioctls:
	test VIDIOC_G/S_TUNER: Not Supported
	test VIDIOC_G/S_FREQUENCY: Not Supported
	test VIDIOC_S_HW_FREQ_SEEK: Not Supported
	test VIDIOC_ENUMAUDIO: Not Supported
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: Not Supported
	Inputs: 1 Audio Inputs: 0 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: Not Supported
	test VIDIOC_G/S_FREQUENCY: Not Supported
	test VIDIOC_ENUMAUDOUT: Not Supported
	test VIDIOC_G/S/ENUMOUTPUT: Not Supported
	test VIDIOC_G/S_AUDOUT: Not Supported
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Control ioctls:
	test VIDIOC_QUERYCTRL/MENU: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: Not Supported
	Standard Controls: 7 Private Controls: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK
	test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: Not Supported
	test VIDIOC_G/S_DV_TIMINGS: Not Supported

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: Not Supported
	test VIDIOC_G_FBUF: Not Supported
	test VIDIOC_G_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: Not Supported
Total: 31 Succeeded: 31 Failed: 0 Warnings: 0
---

None failed! :-)

Would you care to explain me this change in your patch?
+       set_bit(V4L2_FL_USE_FH_PRIO, &dev->vdev.flags);

I guess I can consider the video part as working (at least with a
basic set of features).
I'll be working on alsa and support for several inputs now.

Thanks for reviewing!
Ezequiel.
