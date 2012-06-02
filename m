Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:32947 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab2FBPh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Jun 2012 11:37:29 -0400
Received: by obbtb18 with SMTP id tb18so4482288obb.19
        for <linux-media@vger.kernel.org>; Sat, 02 Jun 2012 08:37:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338651169-10446-1-git-send-email-elezegarcia@gmail.com>
References: <1338651169-10446-1-git-send-email-elezegarcia@gmail.com>
Date: Sat, 2 Jun 2012 12:37:28 -0300
Message-ID: <CALF0-+W5DCf1HMs=MYMc2KVgz=SJKS2YLY7LSrxU6-gnc=+LAA@mail.gmail.com>
Subject: Re: [RFC/PATCH v2] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Ezequiel Garcia <elezegarcia@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 2, 2012 at 12:32 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> This driver adds support for stk1160 usb bridge as used in some
> video/audio usb capture devices.
> It is a complete rewrite of staging/media/easycap driver and
> it's expected as a future replacement.
>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
> As of today testing has been performed using both vlc and mplayer
> on a gentoo machine, including hot unplug and on-the-fly standard
> change using a device with 1-cvs and 1-audio output.
> However more testing is underway with another device and/or another
> distribution.
>
> Support for multiple input devices is a missing feature.
> Alsa sound support is a missing feature. (I'm working on both)
>
> As this is my first complete driver,
> the patch (obviously) intended as RFC only.
> Any comments/reviews of *any* kind will be greatly appreciated.
>
> This new version tries to solve the issues pointed out by
> Hans Verkuil and Sylwester Nawrocki (thanks to both!)
>
> Changes from v1:
>  * Use media control framework
>  * Register video device as the last thing
>  * Use v4l_device release to release all resources
>  * Add explicit locking for file operations
>  * Add vb2 buffer sanity check
>  * Minor style cleanups
>

I'm adding "v4l2-compliance -v 2 -d /dev/video1" output as requested by Hans.

Driver Info:
	Driver name   : stk1160
	Card type     : stk1160
	Bus info      :
	Driver version: 3.4.0
	Capabilities  : 0x05000001
		Video Capture
		Read/Write
		Streaming

Compliance test for device /dev/video1 (not using libv4l2):

Required ioctls:
		fail: v4l2-compliance.cpp(217): string empty
		warn: VIDIOC_QUERYCAP: empty bus_info
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
		fail: v4l2-compliance.cpp(217): string empty
		warn: VIDIOC_QUERYCAP: empty bus_info
	test VIDIOC_QUERYCAP: OK
		fail: v4l2-compliance.cpp(273): doioctl(node, VIDIOC_G_PRIORITY, &prio)
	test VIDIOC_G/S_PRIORITY: FAIL

Debug ioctls:
	test VIDIOC_DBG_G_CHIP_IDENT: FAIL
		fail: v4l2-test-debug.cpp(82): uid == 0 && ret
	test VIDIOC_DBG_G/S_REGISTER: FAIL
	test VIDIOC_LOG_STATUS: FAIL

Input ioctls:
		fail: v4l2-test-input-output.cpp(133): couldn't get tuner 0
	test VIDIOC_G/S_TUNER: FAIL
		fail: v4l2-test-input-output.cpp(228): could get frequency for invalid tuner 0
	test VIDIOC_G/S_FREQUENCY: FAIL
		fail: v4l2-test-input-output.cpp(358): could not enumerate audio input 0
	test VIDIOC_ENUMAUDIO: FAIL
	test VIDIOC_G/S/ENUMINPUT: OK
		fail: v4l2-test-input-output.cpp(377): No audio inputs, but G_AUDIO
did not return EINVAL
		fail: v4l2-test-input-output.cpp(421): invalid audioset for input 0
	test VIDIOC_G/S_AUDIO: FAIL
	Inputs: 1 Audio Inputs: 0 Tuners: 0

Output ioctls:
		fail: v4l2-test-input-output.cpp(479): couldn't get modulator 0
	test VIDIOC_G/S_MODULATOR: FAIL
		fail: v4l2-test-input-output.cpp(563): could get frequency for
invalid modulator 0
	test VIDIOC_G/S_FREQUENCY: FAIL
		fail: v4l2-test-input-output.cpp(682): could not enumerate audio output 0
	test VIDIOC_ENUMAUDOUT: FAIL
	test VIDIOC_G/S/ENUMOUTPUT: FAIL
	test VIDIOC_G/S_AUDOUT: Not Supported
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Control ioctls:
		info: checking v4l2_queryctrl of control 'User Controls' (0x00980001)
		info: checking v4l2_queryctrl of control 'Brightness' (0x00980900)
		info: checking v4l2_queryctrl of control 'Contrast' (0x00980901)
		info: checking v4l2_queryctrl of control 'Saturation' (0x00980902)
		info: checking v4l2_queryctrl of control 'Hue' (0x00980903)
		info: checking v4l2_queryctrl of control 'Chroma AGC' (0x0098091d)
		info: checking v4l2_queryctrl of control 'Chroma Gain' (0x00980924)
		info: checking v4l2_queryctrl of control 'Brightness' (0x00980900)
		info: checking v4l2_queryctrl of control 'Contrast' (0x00980901)
		info: checking v4l2_queryctrl of control 'Saturation' (0x00980902)
		info: checking v4l2_queryctrl of control 'Hue' (0x00980903)
		info: checking v4l2_queryctrl of control 'Chroma AGC' (0x0098091d)
		info: checking v4l2_queryctrl of control 'Chroma Gain' (0x00980924)
	test VIDIOC_QUERYCTRL/MENU: OK
		info: checking control 'User Controls' (0x00980001)
		info: checking control 'Brightness' (0x00980900)
		info: checking control 'Contrast' (0x00980901)
		info: checking control 'Saturation' (0x00980902)
		info: checking control 'Hue' (0x00980903)
		info: checking control 'Chroma AGC' (0x0098091d)
		info: checking control 'Chroma Gain' (0x00980924)
	test VIDIOC_G/S_CTRL: OK
		info: checking extended control 'User Controls' (0x00980001)
		info: checking extended control 'Brightness' (0x00980900)
		info: checking extended control 'Contrast' (0x00980901)
		info: checking extended control 'Saturation' (0x00980902)
		info: checking extended control 'Hue' (0x00980903)
		info: checking extended control 'Chroma AGC' (0x0098091d)
		info: checking extended control 'Chroma Gain' (0x00980924)
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	Standard Controls: 7 Private Controls: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK
		fail: v4l2-test-io-config.cpp(167): could set preset V4L2_DV_INVALID
		fail: v4l2-test-io-config.cpp(216): Presets failed for input 0.
	test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: FAIL
	test VIDIOC_G/S_DV_TIMINGS: Not Supported

Format ioctls:
		info: found 1 formats for buftype 1
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
		fail: v4l2-test-formats.cpp(327): expected EINVAL, but got 25 when
getting framebuffer format
	test VIDIOC_G_FBUF: FAIL
		fail: v4l2-test-formats.cpp(481): Video Capture Multiplanar cap set,
but no Video Capture Multiplanar formats defined
	test VIDIOC_G_FMT: FAIL
		fail: v4l2-test-formats.cpp(509): ret && ret != EINVAL && sliced_type
	test VIDIOC_G_SLICED_VBI_CAP: FAIL
Total: 27 Succeeded: 11 Failed: 16 Warnings: 2
