Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:45523 "EHLO
        lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750980AbdBFM6c (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 6 Feb 2017 07:58:32 -0500
Subject: Re: [PATCH 1/6] staging: Import the BCM2835 MMAL-based V4L2 camera
 driver.
To: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>,
        Eric Anholt <eric@anholt.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20170127215503.13208-1-eric@anholt.net>
 <20170127215503.13208-2-eric@anholt.net>
 <f7f6bed9-b6c9-48cd-814d-9a2f4afe0a8b@xs4all.nl>
 <4cb2ee48-0033-b5ac-bbed-80aa119ee9f5@destevenson.freeserve.co.uk>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <2cf0d891-55a1-4917-8411-b216ca7544a0@xs4all.nl>
Date: Mon, 6 Feb 2017 13:58:26 +0100
MIME-Version: 1.0
In-Reply-To: <4cb2ee48-0033-b5ac-bbed-80aa119ee9f5@destevenson.freeserve.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/06/2017 12:37 PM, Dave Stevenson wrote:
> Hi Hans.
> 
> On 06/02/17 09:08, Hans Verkuil wrote:
>> Hi Eric,
>>
>> Great to see this driver appearing for upstream merging!
>>
>> See below for my review comments, focusing mostly on V4L2 specifics.
>>
>> On 01/27/2017 10:54 PM, Eric Anholt wrote:
>>> - Supports raw YUV capture, preview, JPEG and H264.
>>> - Uses videobuf2 for data transfer, using dma_buf.
>>> - Uses 3.6.10 timestamping
>>> - Camera power based on use
>>> - Uses immutable input mode on video encoder
>>>
>>> This code comes from the Raspberry Pi kernel tree (rpi-4.9.y) as of
>>> a15ba877dab4e61ea3fc7b006e2a73828b083c52.
>>>
>>> Signed-off-by: Eric Anholt <eric@anholt.net>
>>> ---
>>>  .../media/platform/bcm2835/bcm2835-camera.c        | 2016 ++++++++++++++++++++
>>>  .../media/platform/bcm2835/bcm2835-camera.h        |  145 ++
>>>  drivers/staging/media/platform/bcm2835/controls.c  | 1345 +++++++++++++
>>>  .../staging/media/platform/bcm2835/mmal-common.h   |   53 +
>>>  .../media/platform/bcm2835/mmal-encodings.h        |  127 ++
>>>  .../media/platform/bcm2835/mmal-msg-common.h       |   50 +
>>>  .../media/platform/bcm2835/mmal-msg-format.h       |   81 +
>>>  .../staging/media/platform/bcm2835/mmal-msg-port.h |  107 ++
>>>  drivers/staging/media/platform/bcm2835/mmal-msg.h  |  404 ++++
>>>  .../media/platform/bcm2835/mmal-parameters.h       |  689 +++++++
>>>  .../staging/media/platform/bcm2835/mmal-vchiq.c    | 1916 +++++++++++++++++++
>>>  .../staging/media/platform/bcm2835/mmal-vchiq.h    |  178 ++
>>>  12 files changed, 7111 insertions(+)
>>>  create mode 100644 drivers/staging/media/platform/bcm2835/bcm2835-camera.c
>>>  create mode 100644 drivers/staging/media/platform/bcm2835/bcm2835-camera.h
>>>  create mode 100644 drivers/staging/media/platform/bcm2835/controls.c
>>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-common.h
>>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-encodings.h
>>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-common.h
>>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-format.h
>>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg-port.h
>>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-msg.h
>>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-parameters.h
>>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-vchiq.c
>>>  create mode 100644 drivers/staging/media/platform/bcm2835/mmal-vchiq.h
>>>
>>> diff --git a/drivers/staging/media/platform/bcm2835/bcm2835-camera.c b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
>>> new file mode 100644
>>> index 000000000000..4f03949aecf3
>>> --- /dev/null
>>> +++ b/drivers/staging/media/platform/bcm2835/bcm2835-camera.c
>>> @@ -0,0 +1,2016 @@
>>
>> <snip>
>>
>>> +static int start_streaming(struct vb2_queue *vq, unsigned int count)
>>> +{
>>> +	struct bm2835_mmal_dev *dev = vb2_get_drv_priv(vq);
>>> +	int ret;
>>> +	int parameter_size;
>>> +
>>> +	v4l2_dbg(1, bcm2835_v4l2_debug, &dev->v4l2_dev, "%s: dev:%p\n",
>>> +		 __func__, dev);
>>> +
>>> +	/* ensure a format has actually been set */
>>> +	if (dev->capture.port == NULL)
>>> +		return -EINVAL;
>>
>> Standard mistake. If start_streaming returns an error, then it should call vb2_buffer_done
>> for all queued buffers with state VB2_BUF_STATE_QUEUED. Otherwise the buffer administration
>> gets unbalanced.
> 
> OK.
> This is an error path that I'm not convinced can ever be followed, just 
> defensive programming. It may be a candidate for just removing, but yes 
> otherwise it needs to be fixed to do the right thing.

It's not for this specific 'if', it is for all the paths where start_streaming or
stop_streaming can return a non-0 code.

Sorry if that was clear to you already, I just mention this to be unambiguous.

<snip>

>>> +	f->pixelformat = fmt->fourcc;
>>> +	f->flags = fmt->flags;
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static int vidioc_g_fmt_vid_cap(struct file *file, void *priv,
>>> +				struct v4l2_format *f)
>>> +{
>>> +	struct bm2835_mmal_dev *dev = video_drvdata(file);
>>> +
>>> +	f->fmt.pix.width = dev->capture.width;
>>> +	f->fmt.pix.height = dev->capture.height;
>>> +	f->fmt.pix.field = V4L2_FIELD_NONE;
>>> +	f->fmt.pix.pixelformat = dev->capture.fmt->fourcc;
>>> +	f->fmt.pix.bytesperline = dev->capture.stride;
>>> +	f->fmt.pix.sizeimage = dev->capture.buffersize;
>>> +
>>> +	if (dev->capture.fmt->fourcc == V4L2_PIX_FMT_RGB24)
>>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
>>> +	else if (dev->capture.fmt->fourcc == V4L2_PIX_FMT_JPEG)
>>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_JPEG;
>>> +	else
>>> +		f->fmt.pix.colorspace = V4L2_COLORSPACE_SMPTE170M;
>>
>> Colorspace has nothing to do with the pixel format. It should come from the
>> sensor/video receiver.
>>
>> If this information is not available, then COLORSPACE_SRGB is generally a
>> good fallback.
> 
> I would if I could, but then I fail v4l2-compliance on V4L2_PIX_FMT_JPEG
> https://git.linuxtv.org/v4l-utils.git/tree/utils/v4l2-compliance/v4l2-test-formats.cpp#n329
> The special case for JPEG therefore has to remain.

Correct. Sorry, my fault, I forgot about that.

> 
> It looks like I tripped over the subtlety between V4L2_COLORSPACE_, 
> V4L2_XFER_FUNC_, V4L2_YCBCR_ENC_, and V4L2_QUANTIZATION_, and Y'CbCr 
> encoding vs colourspace.
> 
> The ISP coefficients are set up for BT601 limited range, and any 
> conversion back to RGB is done based on that. That seemed to fit 
> SMPTE170M rather than SRGB.

Colorspace refers to the primary colors + whitepoint that are used to
create the colors (basically this answers the question to which colors
R, G and B exactly refer to). The SMPTE170M has different primaries
compared to sRGB (and a different default transfer function as well).

RGB vs Y'CbCr is just an encoding and it doesn't change the underlying
colorspace. Unfortunately, the term 'colorspace' is often abused to just
refer to RGB vs Y'CbCr.

If the colorspace is SRGB, then when the pixelformat is a Y'CbCr encoding,
then the BT601 limited range encoding is implied, unless overridden via
the ycbcr_enc and/or quantization fields in struct v4l2_pix_format.

In other words, this does already the right thing.

The JPEG colorspace is a short-hand for V4L2_COLORSPACE_SRGB, V4L2_YCBCR_ENC_601
and V4L2_QUANTIZATION_FULL_RANGE. It's historical that this colorspace exists.

If I would redesign this this JPEG colorspace would be dropped.

For a lot more colorspace information see:

https://hverkuil.home.xs4all.nl/spec/uapi/v4l/colorspaces.html

> 
> I do note that as there is now support for more RGB formats (BGR24 and 
> BGR32) the first "if" needs extending to cover those. Or I don't care 
> and only special case JPEG with all others just reporting SRGB.
> 

Only special case JPEG.

But as I said, this information really needs to come from the sensor or
video receiver since this driver has no knowledge of this.

<snip>

>>
>> This is IMHO unnecessarily complex.
>>
>> My recommendation is that controls are added with a set of v4l2_ctrl_new_std* calls
>> or if you really want to by walking a struct v4l2_ctrl_config array and adding controls
>> via v4l2_ctrl_new_custom.
>>
>> The s_ctrl is a switch that calls the 'setter' function.
>>
>> No need for arrays, callbacks, etc. Just keep it simple.
> 
> I can look into that, but I'm not sure I fully follow what you are 
> suggesting.
> 
> In the current implementation things like V4L2_CID_SATURATION, 
> V4L2_CID_SHARPNESS, V4L2_CID_CONTRAST, and V4L2_CID_BRIGHTNESS all use 
> the one common ctrl_set_rational setter function because the only thing 
> different in setting is the MMAL_PARAMETER_xxx value. I guess that could 
> move into the common setter based on V4L2_CID_xxx, but then the control 
> configuration is split between multiple places which feels less well 
> contained.

See e.g. samples/v4l/v4l2-pci-skeleton.c: in the probe function (or in a
function called from there if there are a lot of controls) you add the
controls, and in s_ctrl you handle them.

But this is just my preference.

So in s_ctrl you would see something like this:

switch (ctrl->id) {
case V4L2_CID_SATURATION:
	ctrl_set_rational(ctrl->val, MMAL_PARAMETER_SAT);
	break;
case V4L2_CID_BRIGHTNESS:
	ctrl_set_rational(ctrl->val, MMAL_PARAMETER_BRIGHTNESS);
	break;
...
}

> 
>> <snip>
>>
>> Final question: did you run v4l2-compliance over this driver? Before this driver can
>> be moved out of staging it should pass the compliance tests. Note: always compile
>> this test from the main repository, don't rely on distros. That ensures you use the
>> latest code.
>>
>> The compliance test is part of the v4l-utils repo (https://git.linuxtv.org/v4l-utils.git/).
>>
>> If you have any questions about the v4l2-compliance output (it can be a bit obscure at
>> times), just mail me or ask the question on the #v4l irc channel.
> 
> I haven't checked this version, but the downstream version has 43 
> passes, 0 failures, 0 warnings.
> 
> The full output:
> v4l2-compliance SHA   : 99306f20cc7e76cf2161e3059de4da245aed2130

That's pretty recent. Good to know you've used this.

Also test with v4l2-compliance -f: this tests all available formats.

> 
> Driver Info:
> 	Driver name   : bm2835 mmal
> 	Card type     : mmal service 16.1
> 	Bus info      : platform:bcm2835-v4l2
> 	Driver version: 4.4.45
> 	Capabilities  : 0x85200005
> 		Video Capture
> 		Video Overlay
> 		Read/Write
> 		Streaming
> 		Extended Pix Format
> 		Device Capabilities
> 	Device Caps   : 0x05200005
> 		Video Capture
> 		Video Overlay
> 		Read/Write
> 		Streaming
> 		Extended Pix Format
> 
> Compliance test for device /dev/video0 (not using libv4l2):
> 
> Required ioctls:
> 	test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
> 	test second video open: OK
> 	test VIDIOC_QUERYCAP: OK
> 	test VIDIOC_G/S_PRIORITY: OK
> 	test for unlimited opens: OK
> 
> Debug ioctls:
> 	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
> 	test VIDIOC_LOG_STATUS: OK
> 
> Input ioctls:
> 	test VIDIOC_G/S_TUNER/ENUM_FREQ_BANDS: OK (Not Supported)
> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> 	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
> 	test VIDIOC_ENUMAUDIO: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMINPUT: OK
> 	test VIDIOC_G/S_AUDIO: OK (Not Supported)
> 	Inputs: 1 Audio Inputs: 0 Tuners: 0
> 
> Output ioctls:
> 	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
> 	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
> 	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
> 	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
> 	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
> 	Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Input/Output configuration ioctls:
> 	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
> 	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
> 	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
> 	test VIDIOC_G/S_EDID: OK (Not Supported)
> 
> Test input 0:
> 
> 	Control ioctls:
> 		test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
> 		test VIDIOC_QUERYCTRL: OK
> 		test VIDIOC_G/S_CTRL: OK
> 		test VIDIOC_G/S/TRY_EXT_CTRLS: OK
> 		test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
> 		test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
> 		Standard Controls: 33 Private Controls: 0
> 
> 	Format ioctls:
> 		test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
> 		test VIDIOC_G/S_PARM: OK
> 		test VIDIOC_G_FBUF: OK
> 		test VIDIOC_G_FMT: OK
> 		test VIDIOC_TRY_FMT: OK
> 		test VIDIOC_S_FMT: OK
> 		test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
> 		test Cropping: OK (Not Supported)
> 		test Composing: OK (Not Supported)
> 		test Scaling: OK

Is scaling supported? Just checking.

> 
> 	Codec ioctls:
> 		test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
> 		test VIDIOC_G_ENC_INDEX: OK (Not Supported)
> 		test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)
> 
> 	Buffer ioctls:
> 		test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
> 		test VIDIOC_EXPBUF: OK (Not Supported)
> 
> Test input 0:
> 
> 
> Total: 43, Succeeded: 43, Failed: 0, Warnings: 0

Note that v4l2-compliance does very limited testing of overlay handling.
You should test this manually to make sure it functions properly.

Regards,

	Hans
