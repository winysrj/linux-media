Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f178.google.com ([209.85.128.178]:52150 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936507Ab3DHPnb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 11:43:31 -0400
Received: by mail-ve0-f178.google.com with SMTP id db10so5539337veb.9
        for <linux-media@vger.kernel.org>; Mon, 08 Apr 2013 08:43:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365418061-23694-6-git-send-email-hverkuil@xs4all.nl>
References: <1365418061-23694-1-git-send-email-hverkuil@xs4all.nl>
	<1365418061-23694-6-git-send-email-hverkuil@xs4all.nl>
Date: Mon, 8 Apr 2013 11:43:30 -0400
Message-ID: <CAC-25o9LpC9vzZ+HtsGcxQ7UEq5hb-LorBr02pCfvAnpjbb+kg@mail.gmail.com>
Subject: Re: [REVIEW PATCH 5/7] radio-si4713: fix g/s_frequency
From: "edubezval@gmail.com" <edubezval@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Apr 8, 2013 at 6:47 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> - check for invalid modulators.
> - clamp frequency to valid range.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Eduardo Valentin <edubezval@gmail.com>
Tested-by: Eduardo Valentin <edubezval@gmail.com>

Here is the output of v4l2-compliant:
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
	test VIDIOC_G/S_FREQUENCY: OK
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

Total: 36, Succeeded: 30, Failed: 6, Warnings: 0

> ---
>  drivers/media/radio/si4713-i2c.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
> index 1cb9a2e..facd669 100644
> --- a/drivers/media/radio/si4713-i2c.c
> +++ b/drivers/media/radio/si4713-i2c.c
> @@ -1852,7 +1852,8 @@ static int si4713_g_frequency(struct v4l2_subdev *sd, struct v4l2_frequency *f)
>         struct si4713_device *sdev = to_si4713_device(sd);
>         int rval = 0;
>
> -       f->type = V4L2_TUNER_RADIO;
> +       if (f->tuner)
> +               return -EINVAL;
>
>         if (sdev->power_state) {
>                 u16 freq;
> @@ -1877,9 +1878,11 @@ static int si4713_s_frequency(struct v4l2_subdev *sd, const struct v4l2_frequenc
>         int rval = 0;
>         u16 frequency = v4l2_to_si4713(f->frequency);
>
> +       if (f->tuner)
> +               return -EINVAL;
> +
>         /* Check frequency range */
> -       if (frequency < FREQ_RANGE_LOW || frequency > FREQ_RANGE_HIGH)
> -               return -EDOM;
> +       frequency = clamp_t(u16, frequency, FREQ_RANGE_LOW, FREQ_RANGE_HIGH);
>
>         if (sdev->power_state) {
>                 rval = si4713_tx_tune_freq(sdev, frequency);
> --
> 1.7.10.4
>



-- 
Eduardo Bezerra Valentin
