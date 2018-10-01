Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36662 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725738AbeJAWV1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 1 Oct 2018 18:21:27 -0400
Received: by mail-pf1-f196.google.com with SMTP id b7-v6so9513959pfo.3
        for <linux-media@vger.kernel.org>; Mon, 01 Oct 2018 08:43:03 -0700 (PDT)
MIME-Version: 1.0
References: <1537720492-31201-1-git-send-email-akinobu.mita@gmail.com> <92579b08-72cc-cfa6-a57a-85810d582f4d@xs4all.nl>
In-Reply-To: <92579b08-72cc-cfa6-a57a-85810d582f4d@xs4all.nl>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Tue, 2 Oct 2018 00:42:51 +0900
Message-ID: <CAC5umyibVUvA+qAd1yvHEp3n3vq6ciJ95pgOK3JHnanSdzn4cA@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] media: video-i2c: support changing frame interval
 and runtime PM
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2018=E5=B9=B410=E6=9C=881=E6=97=A5(=E6=9C=88) 18:41 Hans Verkuil <hverkuil@=
xs4all.nl>:
>
> On 09/23/2018 06:34 PM, Akinobu Mita wrote:
> > This patchset adds support for changing frame interval and runtime PM f=
or
> > video-i2c driver.  This also adds an helper macro to v4l2 common
> > internal API that is used to to find a suitable frame interval.
> >
> > There are a couple of unrelated changes that are included for simplifyi=
ng
> > driver initialization code and register accesses.
> >
> > * v2
> > - Add Acked-by and Reviewed-by tags
> > - Update commit log to clarify the use after free
> > - Add thermistor and termperature register address definisions
> > - Stop adding v4l2_find_closest_fract() in v4l2 common internal API
> > - Add V4L2_FRACT_COMPARE() macro in v4l2 common internal API
> > - Use V4L2_FRACT_COMPARE() to find suitable frame interval instead of
> >   v4l2_find_closest_fract()
>
> 1) What's wrong with v4l2_find_closest_fract()?

My implementation of v4l2_find_closest_fract() in v1 didn't care about
u32 overflow.  Even if the overflow problem is fixed, there are only a
few drivers (video-i2c and vivid) that can make use of it.  So I feel
it adds more lines of code than it can remove.

> 2) Please test this with the latest v4l2-compliance: I recently improved
>    the S_PARM checks, so I want to make sure this driver passes those tes=
ts.

v4l2-compliance SHA: 7bde5ef172bd4a09b9544788ba9c5dbb1aa9994a, 32 bits

Compliance test for device /dev/video2:

Driver Info:
Driver name      : video-i2c
Card type        : I2C 1-104 Transport Video
Bus info         : I2C:1-104
Driver version   : 4.19.0
Capabilities     : 0x85200001
Video Capture
Read/Write
Streaming
Extended Pix Format
Device Capabilities
Device Caps      : 0x05200001
Video Capture
Read/Write
Streaming
Extended Pix Format

Required ioctls:
test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
test second /dev/video2 open: OK
test VIDIOC_QUERYCAP: OK
test VIDIOC_G/S_PRIORITY: OK
test for unlimited opens: OK

Debug ioctls:
test VIDIOC_DBG_G/S_REGISTER: OK
test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
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

Input/Output configuration ioctls:
test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
test VIDIOC_G/S_EDID: OK (Not Supported)

Control ioctls (Input 0):
test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
test VIDIOC_QUERYCTRL: OK (Not Supported)
test VIDIOC_G/S_CTRL: OK (Not Supported)
test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
Standard Controls: 0 Private Controls: 0

Format ioctls (Input 0):
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

Codec ioctls (Input 0):
test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
test VIDIOC_G_ENC_INDEX: OK (Not Supported)
test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 0):
test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
test VIDIOC_EXPBUF: OK (Not Supported)

Total: 43, Succeeded: 43, Failed: 0, Warnings: 0
