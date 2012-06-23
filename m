Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35570 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2FWSiN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jun 2012 14:38:13 -0400
Received: by obbuo13 with SMTP id uo13so3817595obb.19
        for <linux-media@vger.kernel.org>; Sat, 23 Jun 2012 11:38:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340476571-10832-1-git-send-email-elezegarcia@gmail.com>
References: <1340476571-10832-1-git-send-email-elezegarcia@gmail.com>
Date: Sat, 23 Jun 2012 15:38:12 -0300
Message-ID: <CALF0-+VJS8p6Qb9VJ1HEpufRKDky-M1uxJ87eAWNOoxdRMU_6w@mail.gmail.com>
Subject: Re: [RFC/PATCH v3] media: Add stk1160 new driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	linux-media@vger.kernel.org,
	Ezequiel Garcia <elezegarcia@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jun 23, 2012 at 3:36 PM, Ezequiel Garcia <elezegarcia@gmail.com> wrote:
> This driver adds support for stk1160 usb bridge as used in some
> video/audio usb capture devices.
> It is a complete rewrite of staging/media/easycap driver and
> it's expected as a future replacement.
>
> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> ---
> Hi again,
>
> As stk1160 allows communication with an ac97 codec chip, this
> driver registers a control-only sound card to allow the user
> to access ac97 controls.
> This is achieved through snd_ac97_codec/ac97_bus drivers.
> I'm not sure about this approach so feedback/flames are welcome/expected.
>
> Testing has been performed using both vlc and mplayer
> on a gentoo machine, including hot unplug and on-the-fly standard
> and input switching using two kind of devices:
> * 1-cvbs video and 1-audio ac97 input,
> * 4-cvbs inputs
>
> Both of these devices reports with the same id [05e1:0408],
> so the driver tries to support a superset of the capabilities.
>
> As this is my first complete driver,
> the patch (obviously) intended as RFC only.
> Any comments/reviews of *any* kind will be greatly appreciated.
>
> Changes from v2:
>  * Added support for multiple video input device
>  * Added ac97 initialization
>  * Register an ac97 sound card (mixer control only)
>   to access ac97 registers.
>
> Changes from v1:
>  * Use media control framework
>  * Register video device as the last thing
>  * Use v4l_device release to release all resources
>  * Add explicit locking for file operations
>  * Add vb2 buffer sanity check
>  * Minor style cleanups

$ v4l2-compliance
Driver Info:
	Driver name   : stk1160
	Card type     : stk1160
	Bus info      : usb-0000:00:13.2-2
	Driver version: 3.5.0
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
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
	test VIDIOC_DBG_G_CHIP_IDENT: OK
	test VIDIOC_DBG_G/S_REGISTER: OK
	test VIDIOC_LOG_STATUS: OK

Input ioctls:
	test VIDIOC_G/S_TUNER: Not Supported
	test VIDIOC_G/S_FREQUENCY: Not Supported
	test VIDIOC_S_HW_FREQ_SEEK: Not Supported
	test VIDIOC_ENUMAUDIO: Not Supported
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: Not Supported
	Inputs: 4 Audio Inputs: 0 Tuners: 0

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
