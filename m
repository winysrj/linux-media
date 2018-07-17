Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39849 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729663AbeGQQIR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Jul 2018 12:08:17 -0400
Received: by mail-lj1-f196.google.com with SMTP id l15-v6so1383094lji.6
        for <linux-media@vger.kernel.org>; Tue, 17 Jul 2018 08:35:03 -0700 (PDT)
Date: Tue, 17 Jul 2018 17:35:01 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/2] adv7180: fix field type to V4L2_FIELD_ALTERNATE
Message-ID: <20180717153501.GM10087@bigcity.dyn.berto.se>
References: <20180717123041.2862-1-niklas.soderlund+renesas@ragnatech.se>
 <20180717123041.2862-2-niklas.soderlund+renesas@ragnatech.se>
 <9541cdb4-fb87-e0bb-85cb-667fd16d3804@xs4all.nl>
 <20180717134001.GK10087@bigcity.dyn.berto.se>
 <922e658f-bd6d-1589-a429-37980f77a653@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <922e658f-bd6d-1589-a429-37980f77a653@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 2018-07-17 15:55:33 +0200, Hans Verkuil wrote:
> On 17/07/18 15:40, Niklas Söderlund wrote:
> > Hi Hans,
> > 
> > Thanks for your feedback.
> > 
> > On 2018-07-17 15:12:41 +0200, Hans Verkuil wrote:
> >> On 17/07/18 14:30, Niklas Söderlund wrote:
> >>> The ADV7180 and ADV7182 transmit whole fields, bottom field followed
> >>> by top (or vice-versa, depending on detected video standard). So
> >>> for chips that do not have support for explicitly setting the field
> >>> mode via I2P, set the field mode to V4L2_FIELD_ALTERNATE.
> >>
> >> What does I2P do? I know it was explained before, but that's a long time
> >> ago :-)
> > 
> > The best explanation I have is that I2P is interlaced to progressive and 
> > in my research I stopped at commit 851a54effbd808da ("[media] adv7180: 
> > Add I2P support").
> > 
> > I also vaguely remember reading somewhere that I2P support is planed to 
> > be removed.
> 
> I would just add a line saying:
> 
> "I2P converts fields into frames using an edge adaptive algorithm. The
> frame rate is the same as the 'field rate': e.g. X fields per second
> are now X frames per second."

Thanks, I will add this for v2.

> 
> BTW, does 'v4l2-compliance -f' pass with this patch series? Before running
> this you should first select the correct input.

I'm not sure I understand what you mean by selecting the correct input.  
I test this on Koelsch which is a Renesas Gen2 board and use the video 
node centric approach, so there are no MC magic involved in selecting 
the input.

Running 'v4l2-compliance -f' works as I expect it do do with these two 
patches applied.

# v4l2-compliance -f -d /dev/video26
v4l2-compliance SHA   : 5a870c8e3b55ba4ea255fde68c505a46bfee4e4e

Compliance test for device /dev/video26:

Driver Info:
	Driver name      : rcar_vin
	Card type        : R_Car_VIN
	Bus info         : platform:e6ef1000.video
	Driver version   : 4.18.0
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
	test second /dev/video26 open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK
	test for unlimited opens: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK

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
	test VIDIOC_ENUM/G/S/QUERY_STD: OK
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)
	test VIDIOC_G/S_EDID: OK (Not Supported)

Control ioctls (Input 0):
	test VIDIOC_QUERY_EXT_CTRL/QUERYMENU: OK
	test VIDIOC_QUERYCTRL: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 5 Private Controls: 1

Format ioctls (Input 0):
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)
	test Cropping: OK
	test Composing: OK
	test Scaling: OK

Codec ioctls (Input 0):
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls (Input 0):
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK
	test VIDIOC_EXPBUF: OK

Test input 0:

Stream using all formats:
	test MMAP for Format NV16, Frame Size 2x4:
		Crop 720x480@0x0, Compose 6x4@0x0, Stride 32, Field None: OK   
		Crop 720x480@0x0, Compose 6x4@0x0, Stride 32, Field Top: OK   
		Crop 720x480@0x0, Compose 6x4@0x0, Stride 32, Field Bottom: OK   
		Crop 720x480@0x0, Compose 6x4@0x0, Stride 32, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 6x4@0x0, Stride 32, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 6x4@0x0, Stride 32, Field Interlaced Bottom-Top: OK   
	test MMAP for Format NV16, Frame Size 2048x2048:
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 2048, Field None: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 2048, Field Top: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 2048, Field Bottom: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 2048, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 2048, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 2048, Field Interlaced Bottom-Top: OK   
	test MMAP for Format NV16, Frame Size 736x480:
		Crop 720x480@0x0, Compose 736x480@0x0, Stride 736, Field None: OK   
		Crop 720x480@0x0, Compose 736x480@0x0, Stride 736, Field Top: OK   
		Crop 720x480@0x0, Compose 736x480@0x0, Stride 736, Field Bottom: OK   
		Crop 720x480@0x0, Compose 736x480@0x0, Stride 736, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 736x480@0x0, Stride 736, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 736x480@0x0, Stride 736, Field Interlaced Bottom-Top: OK   
	test MMAP for Format YUYV, Frame Size 32x4:
		Crop 720x480@0x0, Compose 32x4@0x0, Stride 64, Field None: OK   
		Crop 720x480@0x0, Compose 32x4@0x0, Stride 64, Field Top: OK   
		Crop 720x480@0x0, Compose 32x4@0x0, Stride 64, Field Bottom: OK   
		Crop 720x480@0x0, Compose 32x4@0x0, Stride 64, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 32x4@0x0, Stride 64, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 32x4@0x0, Stride 64, Field Interlaced Bottom-Top: OK   
	test MMAP for Format YUYV, Frame Size 2048x2048:
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field None: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Top: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Bottom: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Bottom-Top: OK   
	test MMAP for Format YUYV, Frame Size 736x480:
		Crop 720x480@0x0, Compose 736x480@0x0, Stride 1472, Field None: OK   
		Crop 720x480@0x0, Compose 736x480@0x0, Stride 1472, Field Top: OK   
		Crop 720x480@0x0, Compose 736x480@0x0, Stride 1472, Field Bottom: OK   
		Crop 720x480@0x0, Compose 736x480@0x0, Stride 1472, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 736x480@0x0, Stride 1472, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 736x480@0x0, Stride 1472, Field Interlaced Bottom-Top: OK   
	test MMAP for Format UYVY, Frame Size 2x4:
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field None: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field Top: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field Bottom: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Bottom-Top: OK   
	test MMAP for Format UYVY, Frame Size 2048x2048:
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field None: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Top: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Bottom: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Bottom-Top: OK   
	test MMAP for Format UYVY, Frame Size 720x480:
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field None: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field Top: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field Bottom: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced Bottom-Top: OK   
	test MMAP for Format RGBP, Frame Size 2x4:
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field None: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field Top: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field Bottom: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Bottom-Top: OK   
	test MMAP for Format RGBP, Frame Size 2048x2048:
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field None: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Top: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Bottom: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Bottom-Top: OK   
	test MMAP for Format RGBP, Frame Size 720x480:
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field None: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field Top: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field Bottom: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced Bottom-Top: OK   
	test MMAP for Format XR15, Frame Size 2x4:
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field None: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field Top: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field Bottom: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 4, Field Interlaced Bottom-Top: OK   
	test MMAP for Format XR15, Frame Size 2048x2048:
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field None: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Top: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Bottom: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 4096, Field Interlaced Bottom-Top: OK   
	test MMAP for Format XR15, Frame Size 720x480:
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field None: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field Top: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field Bottom: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 1440, Field Interlaced Bottom-Top: OK   
	test MMAP for Format XR24, Frame Size 2x4:
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 8, Field None: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 8, Field Top: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 8, Field Bottom: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 8, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 8, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 2x4@0x0, Stride 8, Field Interlaced Bottom-Top: OK   
	test MMAP for Format XR24, Frame Size 2048x2048:
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 8192, Field None: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 8192, Field Top: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 8192, Field Bottom: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 8192, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 8192, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 2048x2048@0x0, Stride 8192, Field Interlaced Bottom-Top: OK   
	test MMAP for Format XR24, Frame Size 720x480:
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 2880, Field None: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 2880, Field Top: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 2880, Field Bottom: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 2880, Field Interlaced: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 2880, Field Interlaced Top-Bottom: OK   
		Crop 720x480@0x0, Compose 720x480@0x0, Stride 2880, Field Interlaced Bottom-Top: OK   
Total: 151, Succeeded: 151, Failed: 0, Warnings: 0

> 
> Regards,
> 
> 	Hans
> 
> > 
> >>
> >> In any case, it should be explained in the commit log as well.
> >>
> >> I faintly remember that it was just line-doubling of each field, in which
> >> case this code seems correct.
> > 
> > If you still think I2P needs to be explained in the commit message I 
> > will do so in the next version.
> > 
> >>
> >> Have you checked other drivers that use this subdev? Are they affected by
> >> this change?
> > 
> > I did a quick check what other users there are and in tree dts indicates 
> > imx6 and the sun9i-a80-cubieboard4 in addition to the Renesas boards. As 
> > I can only test on the Renesas hardware I have access to I had to 
> > trusted the acks from the patch from Steve which I dug out of patchwork 
> > [1]. His work stopped with a few comments on the code but it was acked 
> > by Lars-Peter who maintains the driver.
> > 
> > 1. https://patchwork.linuxtv.org/patch/36193/
> > 
> >>
> >> Regards,
> >>
> >> 	Hans
> >>
> >>>
> >>> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> >>> ---
> >>>  drivers/media/i2c/adv7180.c | 13 ++++++++-----
> >>>  1 file changed, 8 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> >>> index 25d24a3f10a7cb4d..c2e24132e8c21d38 100644
> >>> --- a/drivers/media/i2c/adv7180.c
> >>> +++ b/drivers/media/i2c/adv7180.c
> >>> @@ -644,6 +644,9 @@ static int adv7180_mbus_fmt(struct v4l2_subdev *sd,
> >>>  	fmt->width = 720;
> >>>  	fmt->height = state->curr_norm & V4L2_STD_525_60 ? 480 : 576;
> >>>  
> >>> +	if (state->field == V4L2_FIELD_ALTERNATE)
> >>> +		fmt->height /= 2;
> >>> +
> >>>  	return 0;
> >>>  }
> >>>  
> >>> @@ -711,11 +714,11 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
> >>>  
> >>>  	switch (format->format.field) {
> >>>  	case V4L2_FIELD_NONE:
> >>> -		if (!(state->chip_info->flags & ADV7180_FLAG_I2P))
> >>> -			format->format.field = V4L2_FIELD_INTERLACED;
> >>> -		break;
> >>> +		if (state->chip_info->flags & ADV7180_FLAG_I2P)
> >>> +			break;
> >>> +		/* fall through */
> >>>  	default:
> >>> -		format->format.field = V4L2_FIELD_INTERLACED;
> >>> +		format->format.field = V4L2_FIELD_ALTERNATE;
> >>>  		break;
> >>>  	}
> >>>  
> >>> @@ -1291,7 +1294,7 @@ static int adv7180_probe(struct i2c_client *client,
> >>>  		return -ENOMEM;
> >>>  
> >>>  	state->client = client;
> >>> -	state->field = V4L2_FIELD_INTERLACED;
> >>> +	state->field = V4L2_FIELD_ALTERNATE;
> >>>  	state->chip_info = (struct adv7180_chip_info *)id->driver_data;
> >>>  
> >>>  	state->pwdn_gpio = devm_gpiod_get_optional(&client->dev, "powerdown",
> >>>
> >>
> > 
> 

-- 
Regards,
Niklas Söderlund
