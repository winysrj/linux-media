Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:39082 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752018AbeBFHQf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Feb 2018 02:16:35 -0500
Received: by mail-wr0-f176.google.com with SMTP id f6so813520wra.6
        for <linux-media@vger.kernel.org>; Mon, 05 Feb 2018 23:16:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <be1babc7-ed0b-8853-19e8-43b20a6f4c17@xs4all.nl>
References: <be1babc7-ed0b-8853-19e8-43b20a6f4c17@xs4all.nl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Mon, 5 Feb 2018 23:16:33 -0800
Message-ID: <CAJ+vNU1erjHtttuctgR=xd_XmhvxzyuhqdmyfOLKFVaiVf=ufg@mail.gmail.com>
Subject: Re: Please help test the new v4l-subdev support in v4l2-compliance
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Feb 3, 2018 at 7:56 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Tim, Jacopo,
>
> I have now finished writing the v4l2-compliance tests for the various v4l-subdev
> ioctls. I managed to test some with the vimc driver, but that doesn't implement all
> ioctls, so I could use some help testing my test code :-)
>
> To test you first need to apply these patches to your kernel:
>
> https://patchwork.linuxtv.org/patch/46817/
> https://patchwork.linuxtv.org/patch/46822/
>
> Otherwise the compliance test will fail a lot.
>
> Now run v4l2-compliance -u /dev/v4l-subdevX (or -uX as a shortcut) and see what
> happens.
>

Hans,

Here's the compliance results for my tda1997x driver:

v4l2-compliance SHA   : b2f8f9049056eb6f9e028927dacb2c715a062df8
Media Driver Info:
        Driver name      : imx-media
        Model            : imx-media
        Serial           :
        Bus info         :
        Media version    : 4.15.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.15.0
Interface Info:
        ID               : 0x0300008f
        Type             : V4L Sub-Device
Entity Info:
        ID               : 0x00000003 (3)
        Name             : tda19971 2-0048
        Function         : Unknown
        Pad 0x01000004   : Source
          Link 0x0200006f: to remote pad 0x1000063 of entity
'ipu1_csi0_mux': Data, Enabled

Compliance test for device /dev/v4l-subdev1:

Allow for multiple opens:
        test second /dev/v4l-subdev1 open: OK
        test for unlimited opens: OK

Debug ioctls:
        test VIDIOC_LOG_STATUS: OK

Input ioctls:
        test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 0 Audio Inputs: 0 Tuners: 0

Output ioctls:
        test VIDIOC_G/S_MODULATOR: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_ENUMAUDOUT: OK (Not Supported)
        test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDOUT: OK (Not Supported)
        Outputs: 0 Audio Outputs: 0 Modulators: 0

Input/Output configuration ioctls:
        test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
        test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK
                fail: v4l2-test-io-config.cpp(375): doioctl(node,
VIDIOC_DV_TIMINGS_CAP, &timingscap) != EINVAL
                fail: v4l2-test-io-config.cpp(392): EDID check failed
for source pad 0.
        test VIDIOC_DV_TIMINGS_CAP: FAIL
                fail: v4l2-test-io-config.cpp(454): ret && ret != EINVAL
                fail: v4l2-test-io-config.cpp(533): EDID check failed
for source pad 0.
        test VIDIOC_G/S_EDID: FAIL

Sub-Device ioctls (Source Pad 0):
        test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
                fail: v4l2-test-subdevs.cpp(303): fmt.code == 0 ||
fmt.code == ~0U
                fail: v4l2-test-subdevs.cpp(342):
checkMBusFrameFmt(node, fmt.format)
        test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
        test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
        test Active VIDIOC_SUBDEV_G/S_FMT: OK
        test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
        test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)

Control ioctls:
        test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
        test VIDIOC_QUERYCTRL: OK (Not Supported)
        test VIDIOC_G/S_CTRL: OK (Not Supported)
        test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
        test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
        test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
        Standard Controls: 0 Private Controls: 0

Format ioctls:
        test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
root@ventana:~# cat foo
v4l2-compliance SHA   : b2f8f9049056eb6f9e028927dacb2c715a062df8
Media Driver Info:
        Driver name      : imx-media
        Model            : imx-media
        Serial           :
        Bus info         :
        Media version    : 4.15.0
        Hardware revision: 0x00000000 (0)
        Driver version   : 4.15.0
Interface Info:
        ID               : 0x0300008f
        Type             : V4L Sub-Device
Entity Info:
        ID               : 0x00000003 (3)
        Name             : tda19971 2-0048
        Function         : Unknown
        Pad 0x01000004   : Source
          Link 0x0200006f: to remote pad 0x1000063 of entity
'ipu1_csi0_mux': Data, Enabled

Compliance test for device /dev/v4l-subdev1:

Allow for multiple opens:
        test second /dev/v4l-subdev1 open: OK
        test for unlimited opens: OK

Debug ioctls:
        test VIDIOC_LOG_STATUS: OK

Input ioctls:
        test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
        test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
        test VIDIOC_G/S_AUDIO: OK (Not Supported)
        Inputs: 0 Audio Inputs: 0 Tuners: 0
        test VIDIOC_G/S_PARM: OK (Not Supported)
        test VIDIOC_G_FBUF: OK (Not Supported)
        test VIDIOC_G_FMT: OK (Not Supported)
        test VIDIOC_TRY_FMT: OK (Not Supported)
        test VIDIOC_S_FMT: OK (Not Supported)
        test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
        test Cropping: OK (Not Supported)
        test Composing: OK (Not Supported)
        test Scaling: OK (Not Supported)

Codec ioctls:
        test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
        test VIDIOC_G_ENC_INDEX: OK (Not Supported)
        test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
        test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
        test VIDIOC_EXPBUF: OK (Not Supported)

Total: 46, Succeeded: 43, Failed: 3, Warnings: 0
----

With regards to the 3 failures:

1. test VIDIOC_G/S_EDID: FAIL
This is a valid catch where I was returning -EINVAL when the caller
was simply querying the edid - I've fixed it in my driver

2. test VIDIOC_DV_TIMINGS_CAP: FAIL
fail: v4l2-test-io-config.cpp(375): doioctl(node,
VIDIOC_DV_TIMINGS_CAP, &timingscap) != EINVAL
fail: v4l2-test-io-config.cpp(392): EDID check failed for source pad 0.

It looks like the purpose of the test is to do an ioctl with an
invalid pad setting to ensure -EINVAL is returned. However by the time
the VIDIOC_DV_TIMINGS_CAP ioctl used here gets routed to a
VIDIOC_SUBDEV_DV_TIMINGS_CAP the pad is changed to 0 which is valid.
I'm not following what's going on here.

3. test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
fail: v4l2-test-subdevs.cpp(303): fmt.code == 0 || fmt.code == ~0U
fail: v4l2-test-subdevs.cpp(342): checkMBusFrameFmt(node, fmt.format)

This is reporting that a VIDIOC_SUBDEV_G_FMT with
which=V4L2_SUBDEV_FORMAT_TRY returns format->code = 0. The following
is my set_format:

static int tda1997x_get_format(struct v4l2_subdev *sd,
                               struct v4l2_subdev_pad_config *cfg,
                               struct v4l2_subdev_format *format)
{
        struct tda1997x_state *state = to_state(sd);

        v4l_dbg(1, debug, state->client, "%s pad=%d which=%d\n",
                __func__, format->pad, format->which);
        if (format->pad != TDA1997X_PAD_SOURCE)
                return -EINVAL;

        tda1997x_fill_format(state, &format->format);

        if (format->which == V4L2_SUBDEV_FORMAT_TRY) {
                struct v4l2_mbus_framefmt *fmt;

                fmt = v4l2_subdev_get_try_format(sd, cfg, format->pad);
                format->format.code = fmt->code;
        } else {
                format->format.code = state->mbus_code;
        }

        return 0;
}

I don't at all understand the V4L2_SUBDEV_FORMAT_TRY logic here which
I took from other subdev drivers as boilerplate. Is the test valid?

Regards,

Tim
