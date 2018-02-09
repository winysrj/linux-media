Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:56862 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751124AbeBIICp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 03:02:45 -0500
Subject: Re: [PATCH v9 6/8] media: i2c: Add TDA1997x HDMI receiver driver
To: Tim Harvey <tharvey@gateworks.com>
Cc: linux-media <linux-media@vger.kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hansverk@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1518043367-11531-1-git-send-email-tharvey@gateworks.com>
 <1518043367-11531-7-git-send-email-tharvey@gateworks.com>
 <f19fd00d-66fb-a4a2-295b-d4bfae3b4e51@xs4all.nl>
 <CAJ+vNU1CTUQ9EFiV09XeihSHeAMw3C=0JYFL+NPM=DOTTrAP4w@mail.gmail.com>
 <d31d879e-d55a-c300-4c6d-f0d75c575f83@xs4all.nl>
 <CAJ+vNU3TRhpBUto_bL6o_RfNX9vKFN2ThU7+8pucv9M64+Fhag@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <cdfaf99c-09a0-e965-dc6f-f6b94168e706@xs4all.nl>
Date: Fri, 9 Feb 2018 09:02:40 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU3TRhpBUto_bL6o_RfNX9vKFN2ThU7+8pucv9M64+Fhag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/09/2018 09:00 AM, Tim Harvey wrote:
> On Thu, Feb 8, 2018 at 11:41 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 02/09/2018 07:01 AM, Tim Harvey wrote:
>>>
>>> I don't see v4l2-subdev.c (or anything) ever calling g_input_status.
>>> How do I test this?
>>
>> Huh, that's a very good question! It is meant to be called by bridge
>> drivers implementing VIDIOC_ENUMINPUT. But that doesn't apply to the imx
>> driver since it is expecting userspace to talk directly to the subdev.
>>
>> Now for the DV_TIMINGS API this doesn't matter all that much since
>> QUERY_DV_TIMINGS can do the same job through the returned error code, but
>> for analog TV there is no such option (QUERYSTD doesn't support such
>> detailed feedback).
>>
>> I see that you have an adv7180 in your system. Can you run
>> 'v4l2-compliance -uX' for the adv7180 subdev and post the output here?
>>
> 
> 
> # v4l2-compliance -u0
> v4l2-compliance SHA   : b2f8f9049056eb6f9e028927dacb2c715a062df8
> 
> Compliance test for device /d[ 2526.153591] adv7180 2-0020: =================  S
> TART STATUS  =================
> ev/v4l-subdev0:
> 
> Media Driver I[ 2526.162531] adv7180 2-0020: ==================  END STATUS  ===
> ===============
> nfo:
>         Driver name      : imx-media
>         Model            : imx-media
>         Serial           :
>         Bus info         :
>         Media version    : 4.15.0
>         Hardware revision: 0x00000000 (0)
>         Driver version   : 4.15.0
> Interface Info:
>         ID               : 0x0300008d
>         Type             : V4L Sub-Device
> Entity Info:
>         ID               : 0x00000001 (1)
>         Name             : adv7180 2-0020
>         Function         : FAIL: Unknown V4L2 Sub-Device
>         Pad 0x01000002   : Source
>           Link 0x0200007f: to remote pad 0x1000067 of entity 'ipu2_csi1_mux': Da
> ta
> 
> Required ioctls:
>         test MC information (see 'Media Driver Info' above): FAIL
> 
> Allow for multiple opens:
>         test second /dev/v4l-subdev0 open: OK
>         test for unlimited opens: OK
> 
> Debug ioctls:
>         test VIDIOC_LOG_STATUS: OK (Not Supported)
> 
> Input ioctls:
>         test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>         test VIDIOC_ENUMAUDIO: OK (Not Supported)
>         test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDIO: OK (Not Supported)
>         Inputs: 0 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
>         test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>         test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>         test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>         test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>         test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>         Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
>         test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)

Not Supported!

>         test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>         test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>         test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Sub-Device ioctls (Source Pad 0):
>         test Try VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
>                 fail: v4l2-test-subdevs.cpp(301): fmt.width == 0 ||
> fmt.width == ~0U
>                 fail: v4l2-test-subdevs.cpp(342):
> checkMBusFrameFmt(node, fmt.format)
>         test Try VIDIOC_SUBDEV_G/S_FMT: FAIL
>         test Try VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
>         test Active VIDIOC_SUBDEV_ENUM_MBUS_CODE/FRAME_SIZE/FRAME_INTERVAL: OK
>                 fail: v4l2-test-subdevs.cpp(307): fmt.ycbcr_enc == 0xffff
>                 fail: v4l2-test-subdevs.cpp(342):
> checkMBusFrameFmt(node, fmt.format)
>         test Active VIDIOC_SUBDEV_G/S_FMT: FAIL
>         test Active VIDIOC_SUBDEV_G/S_SELECTION/CROP: OK (Not Supported)
>         test VIDIOC_SUBDEV_G/S_FRAME_INTERVAL: OK (Not Supported)
> 
> Control ioctls:
>         test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
>         test VIDIOC_QUERYCTRL: OK
>         test VIDIOC_G/S_CTRL: OK
>         test VIDIOC_G/S/TRY_EXT_CTRLS: OK
>         test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
>         test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>         Standard Controls: 5 Private Controls: 1
> 
> Format ioctls:
>         test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
>         test VIDIOC_G/S_PARM: OK (Not Supported)
>         test VIDIOC_G_FBUF: OK (Not Supported)
>         test VIDIOC_G_FMT: OK (Not Supported)
>         test VIDIOC_TRY_FMT: OK (Not Supported)
>         test VIDIOC_S_FMT: OK (Not Supported)
>         test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>         test Cropping: OK (Not Supported)
>         test Composing: OK (Not Supported)
>         test Scaling: OK (Not Supported)
> 
> Codec ioctls:
>         test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>         test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>         test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> Buffer ioctls:
>         test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)
>         test VIDIOC_EXPBUF: OK (Not Supported)
> 
> Total: 47, Succeeded: 44, Failed: 3, Warnings: 0
> 
>> Analog TV receivers are rare in MC bridge drivers, and I see that the subdev
>> API doesn't even support the G/S/QUERY/ENUM_STD ioctls! I think the adv7180 is
>> basically unusable in your system. And we need a subdev replacement for
>> VIDIOC_ENUMINPUT.
>>
>> Was the adv7180 ever tested? Are you able to test it?
> 
> Yes, it works - I've tested and used it.

How? Without STD support how can you even see what standards are supported
and switch between standards? Did you try to switch between PAL and NTSC?

Regards,

	Hans
