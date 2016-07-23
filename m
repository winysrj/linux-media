Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:36658 "EHLO
	mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbcGWCKJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 22:10:09 -0400
MIME-Version: 1.0
In-Reply-To: <1fca9689-3bfa-11bf-28c6-f81050bfeb88@xs4all.nl>
References: <1468876238-24599-1-git-send-email-nick@shmanahar.org> <1fca9689-3bfa-11bf-28c6-f81050bfeb88@xs4all.nl>
From: Chris Healy <cphealy@gmail.com>
Date: Fri, 22 Jul 2016 19:10:07 -0700
Message-ID: <CAFXsbZow3zAp1w3NZmrN15TzZvo6uc3Rs8sRzSWUcGYZwA2W6A@mail.gmail.com>
Subject: Re: [PATCH v8 0/10] Output raw touch data via V4L2
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Nick Dyer <nick@shmanahar.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm not Nick, but I'm testing his patches. ;-)  Here's what I'm
getting from v4l2-compliance with his patches:

root@RDU2:/mnt/disk ./v4l2-compliance -a -f -d /dev/v4l-touch0
Driver Info:
Driver name   : rmi4_f54
Card type     : Synaptics RMI4 Touch Sensor
Bus info      : rmi4:rmi4-00.fn54
Driver version: 4.7.0
Capabilities  : 0x95200001
Video Capture
Touch Capture
Read/Write
Streaming
Extended Pix Format
Device Capabilities
Device Caps   : 0x15200001
Video Capture
Touch Capture
Read/Write
Streaming
Extended Pix Format

Compliance test for device /dev/v4l-touch0 (not using libv4l2):

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
test VIDIOC_G/S/ENUMINPUT: OK
test VIDIOC_G/S_AUDIO: OK (Not Supported)
Inputs: 5 Audio Inputs: 0 Tuners: 0

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
test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
test VIDIOC_QUERYCTRL: OK (Not Supported)
test VIDIOC_G/S_CTRL: OK (Not Supported)
test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
Standard Controls: 0 Private Controls: 0

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

Test input 1:

Control ioctls:
test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
test VIDIOC_QUERYCTRL: OK (Not Supported)
test VIDIOC_G/S_CTRL: OK (Not Supported)
test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
Standard Controls: 0 Private Controls: 0

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

Test input 2:

Control ioctls:
test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
test VIDIOC_QUERYCTRL: OK (Not Supported)
test VIDIOC_G/S_CTRL: OK (Not Supported)
test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
Standard Controls: 0 Private Controls: 0

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

Test input 3:

Control ioctls:
test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
test VIDIOC_QUERYCTRL: OK (Not Supported)
test VIDIOC_G/S_CTRL: OK (Not Supported)
test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
Standard Controls: 0 Private Controls: 0

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

Test input 4:

Control ioctls:
test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK (Not Supported)
test VIDIOC_QUERYCTRL: OK (Not Supported)
test VIDIOC_G/S_CTRL: OK (Not Supported)
test VIDIOC_G/S/TRY_EXT_CTRLS: OK (Not Supported)
test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK (Not Supported)
test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
Standard Controls: 0 Private Controls: 0

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

Stream using all formats:
test MMAP for Format TD16, Frame Size 60x36:
Stride 120, Field None: OK
test MMAP for Format TD08, Frame Size 60x36:
Stride 120, Field None: OK
test MMAP for Format TU16, Frame Size 60x36:
Stride 120, Field None: OK
Test input 1:

Stream using all formats:
test MMAP for Format TD16, Frame Size 60x36:
Stride 120, Field None: OK
test MMAP for Format TD08, Frame Size 60x36:
Stride 120, Field None: OK
test MMAP for Format TU16, Frame Size 60x36:
Stride 120, Field None: OK
Test input 2:

Stream using all formats:
test MMAP for Format TD16, Frame Size 60x36:
Stride 120, Field None: OK
test MMAP for Format TD08, Frame Size 60x36:
Stride 120, Field None: OK
test MMAP for Format TU16, Frame Size 60x36:
Stride 120, Field None: OK
Test input 3:

Stream using all formats:
test MMAP for Format TD16, Frame Size 60x36:
Stride 120, Field None: OK
test MMAP for Format TD08, Frame Size 60x36:
Stride 120, Field None: OK
test MMAP for Format TU16, Frame Size 60x36:
Stride 120, Field None: OK
Test input 4:

Stream using all formats:
test MMAP for Format TD16, Frame Size 60x36:
Stride 120, Field None: OK
test MMAP for Format TD08, Frame Size 60x36:
Stride 120, Field None: OK
test MMAP for Format TU16, Frame Size 60x36:
Stride 120, Field None: OK

Total: 141, Succeeded: 141, Failed: 0, Warnings: 0

On Wed, Jul 20, 2016 at 12:48 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Nick,
>
> This series looks good. I plan on taking it for 4.9. I have to wait until
> 4.8-rc1 is out and merged in our media_tree repo before I can make the pull
> request, probably in about 3 weeks from now.
>
> One request: can you post the 'v4l2-compliance -a -f' output, using the latest
> v4l2-compliance code with your patch on top.
>
> I'd like to make sure all input and format combinations are working as they should.
>
> Regards,
>
>         Hans
>
> On 07/18/2016 11:10 PM, Nick Dyer wrote:
>> This is a series of patches to add output of raw touch diagnostic data via V4L2
>> to the Atmel maXTouch and Synaptics RMI4 drivers.
>>
>> It's a rewrite of the previous implementation which output via debugfs: it now
>> uses a V4L2 device in a similar way to the sur40 driver.
>>
>> We have a utility which can read the data and display it in a useful format:
>>     https://github.com/ndyer/heatmap/commits/heatmap-v4l
>>
>> Changes in v8:
>> - Split out docs changes, rework in RST/Sphinx, and rebase against docs-next
>> - Update for changes to vb2_queue alloc_ctxs
>> - Rebase against git://linuxtv.org/media_tree.git and re-test
>>
>> Changes in v7:
>> - Tested by Andrew Duggan and Chris Healy.
>> - Update bus_info to add "rmi4:" bus.
>> - Fix code style issues in sur40 changes.
>>
>> Changes in v6:
>> - Remove BUF_TYPE_TOUCH_CAPTURE, as discussed with Hans V touch devices will
>>   use BUF_TYPE_VIDEO_CAPTURE.
>> - Touch devices should now register CAP_VIDEO_CAPTURE: CAP_TOUCH just says that
>>   this is a touch device, not a video device, but otherwise it acts the same.
>> - Add some code to v4l_s_fmt() to set sensible default values for fields not
>>   used by touch.
>> - Improve naming/doc of RMI4 F54 report types.
>> - Various minor DocBook fixes, and split to separate patch.
>> - Update my email address.
>> - Rework sur40 changes so that PIX_FMT_GREY is supported for backward
>>   compatibility. Florian is it possible for you to test?
>>
>> Changes in v5 (Hans Verkuil review):
>> - Update v4l2-core:
>>   - Add VFL_TYPE_TOUCH, V4L2_BUF_TYPE_TOUCH_CAPTURE and V4L2_CAP_TOUCH
>>   - Change V4L2_INPUT_TYPE_TOUCH_SENSOR to V4L2_INPUT_TYPE_TOUCH
>>   - Improve DocBook documentation
>>   - Add FMT definitions for touch data
>>   - Note this will need the latest version of the heatmap util
>> - Synaptics RMI4 driver:
>>   - Remove some less important non full frame report types
>>   - Switch report type names to const char * array
>>   - Move a static array to inside context struct
>> - Split sur40 changes to a separate commit
>>
>> Changes in v4:
>> - Address nits from the input side in atmel_mxt_ts patches (Dmitry Torokhov)
>> - Add Synaptics RMI4 F54 support patch
>>
>> Changes in v3:
>> - Address V4L2 review comments from Hans Verkuil
>> - Run v4l-compliance and fix all issues - needs minor patch here:
>>   https://github.com/ndyer/v4l-utils/commit/cf50469773f
>>
>> Changes in v2:
>> - Split pixfmt changes into separate commit and add DocBook
>> - Introduce VFL_TYPE_TOUCH_SENSOR and /dev/v4l-touch
>> - Remove "single node" support for now, it may be better to treat it as
>>   metadata later
>> - Explicitly set VFL_DIR_RX
>> - Fix Kconfig
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
