Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:51322 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935571AbdIYUoy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Sep 2017 16:44:54 -0400
Received: by mail-wr0-f169.google.com with SMTP id z39so9991378wrb.8
        for <linux-media@vger.kernel.org>; Mon, 25 Sep 2017 13:44:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <58433b8c-5e72-feb1-4515-9396d075e350@xs4all.nl>
References: <1506119053-21828-1-git-send-email-tharvey@gateworks.com>
 <1506119053-21828-4-git-send-email-tharvey@gateworks.com> <58433b8c-5e72-feb1-4515-9396d075e350@xs4all.nl>
From: Tim Harvey <tharvey@gateworks.com>
Date: Mon, 25 Sep 2017 13:44:51 -0700
Message-ID: <CAJ+vNU2FCkn1zVY5ZhVzg7u-SN1svX-a4j-9XYmvHjF9r+SJsQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] media: i2c: Add TDA1997x HDMI receiver driver
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 23, 2017 at 12:30 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Tim,
>
> On 23/09/17 00:24, Tim Harvey wrote:
>> Add support for the TDA1997x HDMI receivers.
>

Hans,

Thanks for the quick review!

> I did a very quick high-level scan and found a few blockers:
>
> 1) You *must* implement the get/set_edid ops. I won't accept
>    the driver without that. You can use v4l2-ctl to set/get the
>    EDID (see v4l2-ctl --help-edid).

ok

When I add hooks for get_edid/set_edid I'm getting 'VIDIOC_S_EDID:
failed: Inappropriate ioctl for device'. v4l2-ctl doesn't operate
directly on subdevs so I'm operating on the imx-media-capture device
that the tda1997x is linked to via media-ctl. Am I missing something?

>
> 2) The dv_timings_cap and enum_dv_timings ops are missing: those
>    must be implemented as well.

ok

The v4l2_dv_timings_cap contains a v4l2_bt_timings_cap and a type but
it looks like the only type currently available is
V4L2_DV_BT_656_1120. As the tda1997x can output raw RGB and raw YUV
which are not technically BT656/1120 what should I be setting for
those?

>
> 3) Drop the deprecated g_mbus_config op.

ok

>
> 4) Do a proper implementation of query_dv_timings. It appears you
>    change the timings in the irq function: that's wrong. The sequence
>    should be the following:
>
>    a) the irq handler detects that timings have changed and sends
>       a V4L2_EVENT_SOURCE_CHANGE event to userspace.
>    b) when userspace receives that event it will stop streaming,
>       call VIDIOC_QUERY_DV_TIMINGS and if new valid timings are
>       detected it will call VIDIOC_S_DV_TIMINGS, allocate the new
>       buffers and start streaming again.
>
>    The driver shall never switch timings on its own, this must be
>    directed from userspace. Different timings will require different
>    configuration through the whole stack (other HW in the video pipeline,
>    DMA engines, userspace memory allocations, etc, etc). Only userspace
>    can do the reconfiguration.

ok, that makes a ton of sense. I was curious how userspace was
notified and handled this.

>
> General note: if you want to implement CEC and/or HDCP, contact me first.
> I can give pointers on how to do that.
>
> This is just a quick scan. I won't have time to do an in-depth review
> for the next two weeks. Ideally you'll have a v2 ready by then with the
> issues mentioned above fixed.

yes, I should have a v2 ready in a week or so after waiting for some
more feedback.

I do have some general questions perhaps you can answer for me.

The TDA1997x video output port can drive HS/VS/DE either directly from
the HDMI input data (which creates a HS/VS pulses) or it can use an
internal VHREF timing generator that generates VREF/HREF signals
(active during the entire frame/row). What sync signalling is
typically required by SoC's video input?

The IMX6 which I'm using needs HREF and VS so I've defaulted the sync
configuration to that and not allowed sync type configuration via
device-tree (although I did allow sync type configuration via a
platform data struct). I'm not clear if I need to allow all the sync
configuration possibilities to be defined in device-tree at this point
and haven't run across any other video decoders that expose this level
of flexibility via dts.

In order for HREF/VREF to be generated the TDA1997x has an internal
VHREF timing generator that works off of pixel counting. I'm currently
configuring this based off of hard-coded values (units of pixel clock)
for href_start, href_end, vref_f1_start, vref_f1_width, vref_f2_start,
vref_f2_width, fieldref_f1_start, fieldref_f2_start and field_polarity
that were provided in some vendor-specific sample code. I didn't see
anything that would let me pull these values from the list of possible
timings in the kernel, but perhaps I should try calculate these based
on struct v4l2_bt_timings fields instead?

>
> Did you run the v4l2-compliance utility to test this driver? For a v2
> please run it and add the output to the cover letter of the patch series.

I did run v4l2-compliance but I wasn't clear how to interpret the
results and filter out compliance issues between the v4l2-subdev and
the capture driver it's linked to.

I will post this info on the v2 cover page as requested but if
interested here's what it shows with my v0 RFC:

Here's my pipline configuration for a GW54xx IMX6Q where tda19971 is
on IPU1_CSI0 via 16bit data bus supporting YUV422 (single clock cycle)

# links
media-ctl --reset
media-ctl --links '"tda19971 2-0048":0 -> "ipu1_csi0_mux":1[1]'
media-ctl --links '"ipu1_csi0_mux":2 -> "ipu1_csi0":0[1]'
media-ctl --links '"ipu1_csi0":2 -> "ipu1_csi0 capture":0[1]'
# format
media-ctl --set-v4l2 "'tda19971 2-0048':0[fmt:UYVY8_1X16/1280x720]"
media-ctl --set-v4l2 "'ipu1_csi0_mux':2[fmt:UYVY8_1X16/1280x720]"
media-ctl --set-v4l2 "'ipu1_csi0':0[fmt:UYVY8_1X16/1280x720]"

# capture 1 frame
v4l2-ctl -d4 --set-fmt-video=width=1280,height=720,pixelformat=UYVY
v4l2-ctl -d4 --stream-mmap --stream-skip=1 --stream-to=/tmp/x.raw
--stream-count=1

media-ctl topology (.txt, .dot, .png) is at
http://dev.gateworks.com/images/tharvey/tda1997x/gw54xx-imx6q/

Running v4l2-compliance on /dev/video4 shows:
root@ventana:~# v4l2-compliance -d /dev/video4
Driver Info:
        Driver name   : imx-media-captu
        Card type     : imx-media-capture
        Bus info      : platform:ipu1_csi0
        Driver version: 4.13.0
        Capabilities  : 0x84200001
                Video Capture
                Streaming
                Extended Pix Format
                Device Capabilities
        Device Caps   : 0x04200001
                Video Capture
                Streaming
                Extended Pix Format

Compliance test for device /dev/video4 (not using libv4l2):

Required ioctls:
        test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
        test second video open: OK
        test VIDIOC_QUERYCAP: OK
        test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
        test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
        test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
        test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
        test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
        test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
        test VIDIOC_ENUMAUDIO: OK (Not Supported)
                fail: v4l2-test-input-output.cpp(418): G_INPUT not
supported for a capture device
        test VIDIOC_G/S/ENUMINPUT: FAIL
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
        test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
        test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
        test VIDIOC_G/S_EDID: OK (Not Supported)

        Control ioctls:
                test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
                test VIDIOC_QUERYCTRL: OK
                test VIDIOC_G/S_CTRL: OK
                test VIDIOC_G/S/TRY_EXT_CTRLS: OK
                fail: v4l2-test-controls.cpp(782): subscribe event for
control 'User Controls' failed
                test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
                test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
                Standard Controls: 1 Private Controls: 7

        Format ioctls:
                test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
                test VIDIOC_G/S_PARM: OK
                test VIDIOC_G_FBUF: OK (Not Supported)
                test VIDIOC_G_FMT: OK
                test VIDIOC_TRY_FMT: OK
                test VIDIOC_S_FMT: OK
                test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
                test Cropping: OK (Not Supported)
                test Composing: OK (Not Supported)
                test Scaling: OK (Not Supported)

        Codec ioctls:
                test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
                test VIDIOC_G_ENC_INDEX: OK (Not Supported)
                test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

        Buffer ioctls:
                test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
                test VIDIOC_EXPBUF: OK

Test input 0:


Total: 42, Succeeded: 40, Failed: 2, Warnings: 0


>
> You say "TDA19972 support (2 inputs)": I assume that that means that there
> are 2 inputs, but only one is active at a time. Right?
>

There are two inputs, both which can detect/report signal changes but
yes only 1 can be selected at a time and output to a single video
output port.

What is the correct subdev api for implementing multiple inputs?

Regards,

Tim
