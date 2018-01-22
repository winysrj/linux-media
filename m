Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:39938 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751110AbeAVMTT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 07:19:19 -0500
Subject: Re: [PATCH 2/9] media: convert g/s_parm to g/s_frame_interval in
 subdevs
To: Sakari Ailus <sakari.ailus@linux.intel.com>
References: <20180122101857.51401-1-hverkuil@xs4all.nl>
 <20180122101857.51401-3-hverkuil@xs4all.nl>
 <20180122102644.4n5yv7z4y3a47n3z@paasikivi.fi.intel.com>
 <9198b319-6821-0263-044e-3ccbc73c61f8@xs4all.nl>
 <20180122105933.uhfeqon5jnv22gbh@paasikivi.fi.intel.com>
Cc: linux-media@vger.kernel.org,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <642fe0fa-ac26-92b7-e807-91006cc4d3d4@xs4all.nl>
Date: Mon, 22 Jan 2018 13:19:16 +0100
MIME-Version: 1.0
In-Reply-To: <20180122105933.uhfeqon5jnv22gbh@paasikivi.fi.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/01/18 11:59, Sakari Ailus wrote:
> Hi Hans,
> 
> On Mon, Jan 22, 2018 at 11:33:28AM +0100, Hans Verkuil wrote:
>> On 22/01/18 11:26, Sakari Ailus wrote:
>>> Hi Hans,
>>>
>>> On Mon, Jan 22, 2018 at 11:18:50AM +0100, Hans Verkuil wrote:
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> Convert all g/s_parm calls to g/s_frame_interval. This allows us
>>>> to remove the g/s_parm ops since those are a duplicate of
>>>> g/s_frame_interval.
>>>>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> ---
>>>>  drivers/media/i2c/mt9v011.c                     | 29 +++++++++----------
>>>>  drivers/media/i2c/ov6650.c                      | 33 ++++++++++------------
>>>>  drivers/media/i2c/ov7670.c                      | 26 +++++++++--------
>>>>  drivers/media/i2c/ov7740.c                      | 29 ++++++++-----------
>>>>  drivers/media/i2c/tvp514x.c                     | 37 +++++++++++--------------
>>>>  drivers/media/i2c/vs6624.c                      | 29 ++++++++++---------
>>>>  drivers/media/platform/atmel/atmel-isc.c        | 10 ++-----
>>>>  drivers/media/platform/atmel/atmel-isi.c        | 12 ++------
>>>>  drivers/media/platform/blackfin/bfin_capture.c  | 14 +++-------
>>>>  drivers/media/platform/marvell-ccic/mcam-core.c | 12 ++++----
>>>>  drivers/media/platform/soc_camera/soc_camera.c  | 10 ++++---
>>>>  drivers/media/platform/via-camera.c             |  4 +--
>>>>  drivers/media/usb/em28xx/em28xx-video.c         | 36 ++++++++++++++++++++----
>>>>  13 files changed, 137 insertions(+), 144 deletions(-)
>>>>
>>>> diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
>>>> index 5e29064fae91..0e0bcc8b67ca 100644
>>>> --- a/drivers/media/i2c/mt9v011.c
>>>> +++ b/drivers/media/i2c/mt9v011.c
>>>> @@ -364,33 +364,30 @@ static int mt9v011_set_fmt(struct v4l2_subdev *sd,
>>>>  	return 0;
>>>>  }
>>>>  
>>>> -static int mt9v011_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *parms)
>>>> +static int mt9v011_g_frame_interval(struct v4l2_subdev *sd,
>>>> +				    struct v4l2_subdev_frame_interval *ival)
>>>>  {
>>>> -	struct v4l2_captureparm *cp = &parms->parm.capture;
>>>> -
>>>> -	if (parms->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
>>>> +	if (ival->pad)
>>>>  		return -EINVAL;
>>>
>>> The pad number checks are already present in v4l2-subdev.c. Do you think
>>> we'll need them in drivers as well?
>>>
>>> It's true that another driver could mis-use this interface. In that case
>>> I'd introduce a wrapper to the op rather than introduce the check in every
>>> driver.
>>
>> I'm not that keen on introducing wrappers for an op. I wouldn't actually know
>> how to implement that cleanly. Since the pad check is subdev driver specific,
>> and the overhead of a wrapper is almost certainly higher than just doing this
>> check I feel it is OK to do this.
> 
> For a majority of drivers, the check is that the pad must be a valid
> pad in an entity. The case where the overhead could matter (it's just a
> single if) is when called through an IOCTL from the user space. And the
> subdevices' IOCTL handler already performs this check. The wrapper would
> simply extend the check to other drivers calling the op.
> 
> It's easy to miss such checks in drivers. We've had quite a few such cases
> in the past. Performing the check universally would make the framework more
> robust.
> 
> What comes to this patchset, I'd omit the pad number check as other drivers
> don't do such checks either --- unless the check is more strict than what
> the interface allows.

I'll remove the check.

	Hans

> 
>>
>>>
>>>>  
>>>> -	memset(cp, 0, sizeof(struct v4l2_captureparm));
>>>> -	cp->capability = V4L2_CAP_TIMEPERFRAME;
>>>> +	memset(ival->reserved, 0, sizeof(ival->reserved));
>>>>  	calc_fps(sd,
>>>> -		 &cp->timeperframe.numerator,
>>>> -		 &cp->timeperframe.denominator);
>>>> +		 &ival->interval.numerator,
>>>> +		 &ival->interval.denominator);
>>>>  
>>>>  	return 0;
>>>>  }
>>
>> Regards,
>>
>> 	Hans
>>
> 
