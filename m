Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f46.google.com ([209.85.215.46]:34573 "EHLO
	mail-lf0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbbLNPl1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Dec 2015 10:41:27 -0500
MIME-Version: 1.0
In-Reply-To: <566EBDD7.7010006@xs4all.nl>
References: <1449849893-14865-1-git-send-email-ulrich.hecht+renesas@gmail.com>
	<566AF904.9050102@xs4all.nl>
	<566E9ADC.1030608@xs4all.nl>
	<CAO3366zrZsrsZWt1aC94+qDBUKkD4r_x1W2O59jZJHWCCbF1Uw@mail.gmail.com>
	<566EBDD7.7010006@xs4all.nl>
Date: Mon, 14 Dec 2015 16:41:25 +0100
Message-ID: <CAO3366xbDR22UqNHYq=JQb5DVh3YiyvhxFfOLjzDem4hyjYd3g@mail.gmail.com>
Subject: Re: [PATCH 0/3] adv7604: .g_crop and .cropcap support
From: Ulrich Hecht <ulrich.hecht+renesas@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, SH-Linux <linux-sh@vger.kernel.org>,
	Magnus Damm <magnus.damm@gmail.com>,
	Laurent <laurent.pinchart@ideasonboard.com>,
	hans.verkuil@cisco.com, ian.molton@codethink.co.uk,
	lars@metafoo.de, William Towle <william.towle@codethink.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 14, 2015 at 2:02 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 12/14/2015 01:55 PM, Ulrich Hecht wrote:
>> On Mon, Dec 14, 2015 at 11:33 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> OK, my http://git.linuxtv.org/hverkuil/media_tree.git/log/?h=rmcrop branch now has a
>>> rebased patch to remove g/s_crop. Only compile-tested. It's just the one patch that you
>>> need.
>>
>> Thank you, that works perfectly with rcar_vin and adv7604; I'll send a
>> revised series.
>
> Just making sure: you have actually tested cropping with my patch?

OK, I'll revise my statement: The "get" part works perfectly. :)

>
> It would also be interesting to see if you can run v4l2-compliance for rcar. See what it says.

Driver Info:
       Driver name   : e6ef0000.video
       Card type     : R_Car_VIN
       Bus info      : platform:rcar_vin0
       Driver version: 4.4.0
       Capabilities  : 0x84200001
               Video Capture
               Streaming
               Extended Pix Format
               Device Capabilities
       Device Caps   : 0x04200001
               Video Capture
               Streaming
               Extended Pix Format

Compliance test for device /dev/video0 (not using libv4l2):

Required ioctls:
       test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
       test second video open: OK
       test VIDIOC_QUERYCAP: OK
               fail: v4l2-compliance.cpp(585): prio != match
       test VIDIOC_G/S_PRIORITY: FAIL

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

Test input 0:

       Control ioctls:
               test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
               test VIDIOC_QUERYCTRL: OK
               test VIDIOC_G/S_CTRL: OK
               test VIDIOC_G/S/TRY_EXT_CTRLS: OK
               fail: v4l2-test-controls.cpp(782): subscribe event for
control 'User Co
ntrols' failed
               test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: FAIL
               test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
               Standard Controls: 5 Private Controls: 0

       Format ioctls:
               fail: v4l2-test-formats.cpp(268): duplicate format 34424752
               test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: FAIL
               test VIDIOC_G/S_PARM: OK (Not Supported)
               test VIDIOC_G_FBUF: OK (Not Supported)
               test VIDIOC_G_FMT: OK
               test VIDIOC_TRY_FMT: OK
               warn: v4l2-test-formats.cpp(827): Could not set fmt2
               test VIDIOC_S_FMT: OK
               test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
               test Cropping: OK
               test Composing: OK
               test Scaling: OK (Not Supported)

       Codec ioctls:
               test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
               test VIDIOC_G_ENC_INDEX: OK (Not Supported)
               test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

       Buffer ioctls:
               test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
               test VIDIOC_EXPBUF: OK

Test input 0:


Total: 42, Succeeded: 39, Failed: 3, Warnings: 1

CU
Uli
