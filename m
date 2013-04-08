Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:50652 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936441Ab3DHPqB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 11:46:01 -0400
Received: by mail-ve0-f176.google.com with SMTP id ox1so5444052veb.21
        for <linux-media@vger.kernel.org>; Mon, 08 Apr 2013 08:46:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365418061-23694-8-git-send-email-hverkuil@xs4all.nl>
References: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
	<1365418061-23694-8-git-send-email-hverkuil@xs4all.nl>
Date: Mon, 8 Apr 2013 11:46:00 -0400
Message-ID: <CAC-25o-k70kW9tGa7YzY0ZEZARXnwdgFu1RB0cJRU8XUB988Ow@mail.gmail.com>
Subject: Re: [REVIEW PATCH 7/7] radio-si4713: add prio checking and control events.
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Apr 8, 2013 at 6:47 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Eduardo Valentin <edubezval@gmail.com>
Tested-by: Eduardo Valentin <edubezval@gmail.com>

Output of v4l2-compliant:
is radio
Driver Info:
	Driver name   : radio-si4713
	Card type     : Silicon Labs Si4713 Modulator
	Bus info      : platform:radio-si4713
	Driver version: 3.9.0
	Capabilities  : 0x80080800
		RDS Output
		Modulator
		Device Capabilities
	Device Caps   : 0x00080800
		RDS Output
		Modulator

Compliance test for device /dev/radio0 (not using libv4l2):

Required ioctls:
		fail: v4l2-compliance.cpp(321): !(dcaps & io_caps)
	test VIDIOC_QUERYCAP: FAIL

Allow for multiple opens:
	test second radio open: OK
		fail: v4l2-compliance.cpp(321): !(dcaps & io_caps)
	test VIDIOC_QUERYCAP: FAIL
	test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK

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
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 1

Control ioctls:
	test VIDIOC_QUERYCTRL/MENU: OK
		fail: v4l2-test-controls.cpp(428): could not set minimum value
	test VIDIOC_G/S_CTRL: FAIL
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 22 Private Controls: 0

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

Total: 36, Succeeded: 33, Failed: 3, Warnings: 0

> ---
>  drivers/media/radio/radio-si4713.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
> index f8c6137..ba4cfc9 100644
> --- a/drivers/media/radio/radio-si4713.c
> +++ b/drivers/media/radio/radio-si4713.c
> @@ -31,6 +31,9 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-ioctl.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-ctrls.h>
> +#include <media/v4l2-event.h>
>  #include <media/radio-si4713.h>
>
>  /* module parameters */
> @@ -55,6 +58,9 @@ struct radio_si4713_device {
>  /* radio_si4713_fops - file operations interface */
>  static const struct v4l2_file_operations radio_si4713_fops = {
>         .owner          = THIS_MODULE,
> +       .open = v4l2_fh_open,
> +       .release = v4l2_fh_release,
> +       .poll = v4l2_ctrl_poll,
>         /* Note: locking is done at the subdev level in the i2c driver. */
>         .unlocked_ioctl = video_ioctl2,
>  };
> @@ -126,6 +132,9 @@ static struct v4l2_ioctl_ops radio_si4713_ioctl_ops = {
>         .vidioc_s_modulator     = radio_si4713_s_modulator,
>         .vidioc_g_frequency     = radio_si4713_g_frequency,
>         .vidioc_s_frequency     = radio_si4713_s_frequency,
> +       .vidioc_log_status      = v4l2_ctrl_log_status,
> +       .vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
> +       .vidioc_unsubscribe_event = v4l2_event_unsubscribe,
>         .vidioc_default         = radio_si4713_default,
>  };
>
> @@ -187,6 +196,7 @@ static int radio_si4713_pdriver_probe(struct platform_device *pdev)
>         rsdev->radio_dev = radio_si4713_vdev_template;
>         rsdev->radio_dev.v4l2_dev = &rsdev->v4l2_dev;
>         rsdev->radio_dev.ctrl_handler = sd->ctrl_handler;
> +       set_bit(V4L2_FL_USE_FH_PRIO, &rsdev->radio_dev.flags);
>         /* Serialize all access to the si4713 */
>         rsdev->radio_dev.lock = &rsdev->lock;
>         video_set_drvdata(&rsdev->radio_dev, rsdev);
> --
> 1.7.10.4
>



-- 
Eduardo Bezerra Valentin
