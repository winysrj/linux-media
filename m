Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134Ab1HAUUE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Aug 2011 16:20:04 -0400
Message-ID: <4E370A66.3030704@redhat.com>
Date: Mon, 01 Aug 2011 17:19:50 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Joerg Heckenbach <joerg@heckenbach-aw.de>,
	Dwaine Garden <dwainegarden@rogers.com>,
	linux-media@vger.kernel.org,
	Kernel development list <linux-kernel@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] [resend] usbvision: disable scaling for Nogatech MicroCam
References: <201107222200.55834.linux@rainbow-software.org> <201107222344.46003.linux@rainbow-software.org> <4E3028AA.4030703@redhat.com> <201108012050.25416.linux@rainbow-software.org>
In-Reply-To: <201108012050.25416.linux@rainbow-software.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 01-08-2011 15:50, Ondrej Zary escreveu:
> On Wednesday 27 July 2011 17:03:06 Mauro Carvalho Chehab wrote:
>> Em 22-07-2011 18:44, Ondrej Zary escreveu:
>>> On Friday 22 July 2011 23:31:46 Devin Heitmueller wrote:
>>>> On Fri, Jul 22, 2011 at 5:22 PM, Ondrej Zary <linux@rainbow-software.org> wrote:
>>>>> Seems that this bug is widespread - the same problem appears also in guvcview
>>>>> and adobe flash. I think that the driver is broken too - it should return
>>>>> corrected resolution in TRY_FMT.
>>>>
>>>> Well, if the driver does not return the resolution it is actually
>>>> capturing in, then that indeed is a driver bug.  That's a different
>>>> issue though than what your patch proposed.
>>>>
>>>> You should make the TRY_FMT call specifying an invalid resolution and
>>>> see if it returns the real resolution the device will capture at.  If
>>>> it doesn't, then fix *that* bug.
>>>
>>> It does not, there's no code that would do that. I actually fixed that only
>>> to find out that the scaling is unusable at least with the MicroCam because
>>> of black horizontal lines that appear in the image (amount of the lines
>>> depend on the scaling factor). So I just disabled the scaling completely for
>>> MicroCam.
>>>
>>> I also don't know if the multiple-of-64 width limit is valid for all
>>> usbvision devices - that's why I haven't posted patch to fix this.
>>>
>>>> The application needs to know the capturing resolution, so it's
>>>> possible that it does properly handle the driver passing back the real
>>>> resolution and the driver is at fault, in which case no change is
>>>> needed to the app at all.
>>
>> Well, for sure you don't need to touch at s_fmt, as it calls try_fmt. Also,
>> if the problem is that the scaler requrires that the vertical resolution to be
>> multiple of some limit, a patch like the one bellow would do a better job:
>>
>> diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
>> index 5a74f5e..6907eff 100644
>> --- a/drivers/media/video/usbvision/usbvision-video.c
>> +++ b/drivers/media/video/usbvision/usbvision-video.c
>> @@ -922,6 +922,9 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>>  	RESTRICT_TO_RANGE(vf->fmt.pix.width, MIN_FRAME_WIDTH, MAX_FRAME_WIDTH);
>>  	RESTRICT_TO_RANGE(vf->fmt.pix.height, MIN_FRAME_HEIGHT, MAX_FRAME_HEIGHT);
>>  
>> +	/* FIXME: please correct the minimum resolution here */
>> +	vf->fmt.pix.width &= ~0x01;
>> +
>>  	vf->fmt.pix.bytesperline = vf->fmt.pix.width*
>>  		usbvision->palette.bytes_per_pixel;
>>  	vf->fmt.pix.sizeimage = vf->fmt.pix.bytesperline*vf->fmt.pix.height;
>>
>> Some scalers require an even vertical resolution. So, you'll need to adjust the
>> above, according with the restrictions you may have on the scaler your webcam
>> has.
>>
>> Btw, V4L2 core defines a macro for such type of adjustments. For example,
>> em28xx uses it as:
>>
>> 		/* width must even because of the YUYV format
>> 		   height must be even because of interlacing */
>> 		v4l_bound_align_image(&width, 48, maxw, 1, &height, 32, maxh,
>> 				      1, 0);
>>
>> (
>>
>> So, a better fix would be to remove the RESTRICT_TO_RANGE() calls, and use
>> the v4l_bound_align_image() macro instead, filled with the needed restrictions,
>> like:
>> 	v4l_bound_align_image(&width, MIN_FRAME_WIDTH, MAX_FRAME_WIDTH, 1,
>> 			      &height, MIN_FRAME_HEIGHT, MAX_FRAME_HEIGHT, 0);
>>
>>
>> -
>>
>> [usbvision] Fix width/height scaling limits
>>
>> It assumes that both just width is required to be even number.
> 
> Width on the Nogatech MicroCam is limited to multiples of 64 (e.g. if you set
> the width to 160, you get 128 instead). But the scaled output is useless
> because of black horizontal lines that scaling produces with compression
> (which is enabled by default).

Ok. This seems to be either a sensor or a bridge problem. So, it is not specific
to Nogatech.

> Probably nobody wants to disable the
> compression as the framerate is very low without it.

Yet, it may make sense for some applications, like surveillance cameras or
telescopes. If the driver already supports compression to be disabled, maybe
the right thing to do would be to allow scaling only if compression is disabled,
for the devices that have the same bridge and sensor.
> 
> I don't know about other usbvision devices. We shouldn't change the code for
> all of them without testing.
> 
> 
>> NOT TESTED.
>>
>> Signed-of-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> diff --git a/drivers/media/video/usbvision/usbvision-video.c b/drivers/media/video/usbvision/usbvision-video.c
>> index 5a74f5e..41d3b47 100644
>> --- a/drivers/media/video/usbvision/usbvision-video.c
>> +++ b/drivers/media/video/usbvision/usbvision-video.c
>> @@ -919,8 +919,11 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
>>  	/* robustness */
>>  	if (format_idx == USBVISION_SUPPORTED_PALETTES)
>>  		return -EINVAL;
>> -	RESTRICT_TO_RANGE(vf->fmt.pix.width, MIN_FRAME_WIDTH, MAX_FRAME_WIDTH);
>> -	RESTRICT_TO_RANGE(vf->fmt.pix.height, MIN_FRAME_HEIGHT, MAX_FRAME_HEIGHT);
>> +
>> +	v4l_bound_align_image(&vf->fmt.pix.width,
>> +			      MIN_FRAME_WIDTH, MAX_FRAME_WIDTH, 1,
>> +			      &vf->fmt.pix.height,
>> +			      MIN_FRAME_HEIGHT, MAX_FRAME_HEIGHT, 0, 0);
>>  
>>  	vf->fmt.pix.bytesperline = vf->fmt.pix.width*
>>  		usbvision->palette.bytes_per_pixel;
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
> 
> 
> 

