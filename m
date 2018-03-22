Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:57074 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751721AbeCVH2e (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Mar 2018 03:28:34 -0400
Subject: Re: [PATCH v5 0/2] media: video-i2c: add video-i2c driver support
To: Matt Ranostay <matt.ranostay@konsulko.com>
Cc: linux-media@vger.kernel.org
References: <20180308182141.28997-1-matt.ranostay@konsulko.com>
 <b6b62671-e5a9-c3c9-2303-11dbc48da7c8@xs4all.nl>
 <CAJCx=g=VwCqm9t56j=r2KE-sDOpgA82XwxhJNbdbkFpwuJSkKw@mail.gmail.com>
 <CAJCx=g=Uci1X7FLv5jxmN=uCK7mRN7Pw6hTOLG3GUPAdfZXsoQ@mail.gmail.com>
 <56ef9e6f-e209-f9df-7a0b-fe2add6b32c9@xs4all.nl>
 <CAJCx=gnZPcDuXANzguaQ9DPb1L=rmkXKie1oSsxucG2GJ9F8ig@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e4f98a62-9526-766a-1380-d56651ac597d@xs4all.nl>
Date: Thu, 22 Mar 2018 08:28:29 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCx=gnZPcDuXANzguaQ9DPb1L=rmkXKie1oSsxucG2GJ9F8ig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/22/2018 06:46 AM, Matt Ranostay wrote:
> On Mon, Mar 19, 2018 at 5:31 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> On 03/16/2018 03:47 AM, Matt Ranostay wrote:
>>> On Fri, Mar 9, 2018 at 10:26 AM, Matt Ranostay
>>> <matt.ranostay@konsulko.com> wrote:
>>>> On Fri, Mar 9, 2018 at 4:45 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>>>> Hi Matt,
>>>>>
>>>>> This is looking good. One request before I merge: please run the
>>>>> 'v4l2-compliance -s -f' utility and post the result here.
>>>>>
>>>>> I don't think I've asked you to do that before (or if I did, I couldn't
>>>>> find it in my mail archive).
>>>>>
>>>>> It should run without failures.
>>>>>
>>>>> Use the latest version from the git repo: https://git.linuxtv.org/v4l-utils.git/
>>>>>
>>>>> ./bootstrap.sh; ./configure; make; sudo make install
>>>>
>>>> Heh so not exactly no failures. Suspect a lot of these are due to the
>>>> weird small 8x8 pixel input, and the fact it doesn't
>>>> support modes a typical video capture device would.
>>>>
>>>> v4l2-compliance SHA   : 14ce03c18ef67aa7a3d5781f015be855fd43839c
>>>>
>>>> Compliance test for device /dev/video0:
>>>>
>>>> Driver Info:
>>>> Driver name      : video-i2c
>>>> Card type        : I2C 2-105 Transport Video
>>>> Bus info         : I2C:2-105
>>>> Driver version   : 4.14.11
>>>> Capabilities     : 0x85200001
>>>> Video Capture
>>>> Read/Write
>>>> Streaming
>>>> Extended Pix Format
>>>> Device Capabilities
>>>> Device Caps      : 0x05200001
>>>> Video Capture
>>>> Read/Write
>>>> Streaming
>>>> Extended Pix Format
>>>>
>>>> Required ioctls:
>>>> test VIDIOC_QUERYCAP: OK
>>>>
>>>> Allow for multiple opens:
>>>> test second /dev/video0 open: OK
>>>> test VIDIOC_QUERYCAP: OK
>>>> test VIDIOC_G/S_PRIORITY: OK
>>>> test for unlimited opens: OK
>>>>
>>>> Debug ioctls:
>>>> test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
>>>> test VIDIOC_LOG_STATUS: OK (Not Supported)
>>>>
>>>> Input ioctls:
>>>> test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
>>>> test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>>> test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
>>>> test VIDIOC_ENUMAUDIO: OK (Not Supported)
>>>> test VIDIOC_G/S/ENUMINPUT: OK
>>>> test VIDIOC_G/S_AUDIO: OK (Not Supported)
>>>> Inputs: 1 Audio Inputs: 0 Tuners: 0
>>>>
>>>> Output ioctls:
>>>> test VIDIOC_G/S_MODULATOR: OK (Not Supported)
>>>> test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
>>>> test VIDIOC_ENUMAUDOUT: OK (Not Supported)
>>>> test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
>>>> test VIDIOC_G/S_AUDOUT: OK (Not Supported)
>>>> Outputs: 0 Audio Outputs: 0 Modulators: 0
>>>>
>>>> Input/Output configuration ioctls:
>>>> test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
>>>> test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
>>>> test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
>>>> test VIDIOC_G/S_EDID: OK (Not Supported)
>>>>
>>>> Control ioctls (Input 0):
>>>> test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
>>>> test VIDIOC_QUERYCTRL: OK (Not Supported)
>>>> test VIDIOC_G/S_CTRL: OK (Not Supported)
>>>> test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
>>>> test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
>>>> test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
>>>> Standard Controls: 0 Private Controls: 0
>>>>
>>>> Format ioctls (Input 0):
>>>> test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
>>>> test VIDIOC_G/S_PARM: OK
>>>> test VIDIOC_G_FBUF: OK (Not Supported)
>>>> test VIDIOC_G_FMT: OK
>>>> test VIDIOC_TRY_FMT: OK
>>>> test VIDIOC_S_FMT: OK
>>>> test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
>>>> test Cropping: OK (Not Supported)
>>>> test Composing: OK (Not Supported)
>>>> test Scaling: OK (Not Supported)
>>>>
>>>> Codec ioctls (Input 0):
>>>> test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
>>>> test VIDIOC_G_ENC_INDEX: OK (Not Supported)
>>>> test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
>>>>
>>>> Buffer ioctls (Input 0):
>>>> test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
>>>> test VIDIOC_EXPBUF: OK (Not Supported)
>>>>
>>>> Test input 0:
>>>>
>>>> Streaming ioctls:
>>>> test read/write: OK
>>>> fail: v4l2-test-buffers.cpp(248): g_field() == V4L2_FIELD_ANY
>>>
>>> Noticed this seems to be the most worrying of the failures.  Any
>>> suggestions where could be requested and still be 0 == V4L2_FIELD_ANY?
>>
>> struct v4l2_buffers should never return FIELD_ANY. For this driver
>> the frames are always progressive, not interlaced, so just set this
>> to FIELD_NONE in the driver.
>>
>> Basically the driver must never give FIELD_ANY back to userspace.
>> Userspace can pass in FIELD_ANY when it calls TRY/S_FMT, but it should
>> always be replaced with a non-zero field value. In this case FIELD_NONE.
> 
> 
> Which callback would that be in? Because currently the driver is only
> handling the v4l2_pix_format settings, and not
> vb2_v4l2_buffer settings.

You typically do that in buffer_prepare(). BTW, I noticed that you do not
set the sequence counter in v4l2_buffer! You set that just before calling
vb2_buffer_done().

Regards,

	Hans
