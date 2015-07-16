Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:49801 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754589AbbGPIiD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 04:38:03 -0400
Message-ID: <55A76D09.2040202@xs4all.nl>
Date: Thu, 16 Jul 2015 10:36:25 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
Subject: Re: [RFC v3 04/19] media/usb/uvc: Implement vivioc_g_def_ext_ctrls
References: <1434127598-11719-1-git-send-email-ricardo.ribalda@gmail.com> <3162887.2tIlvOM8NK@avalon> <55A769E7.8010308@xs4all.nl> <1628799.CQBSk2GIHo@avalon>
In-Reply-To: <1628799.CQBSk2GIHo@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/16/15 10:27, Laurent Pinchart wrote:
> On Thursday 16 July 2015 10:23:03 Hans Verkuil wrote:
>> On 07/16/15 10:11, Laurent Pinchart wrote:
>>> On Thursday 16 July 2015 09:38:11 Hans Verkuil wrote:
>>>> On 07/15/15 23:05, Laurent Pinchart wrote:
>>>>> On Friday 12 June 2015 18:46:23 Ricardo Ribalda Delgado wrote:
>>>>>> Callback needed by ioctl VIDIOC_G_DEF_EXT_CTRLS as this driver does not
>>>>>> use the controller framework.
>>>>>>
>>>>>> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>>>>>> ---
>>>>>>
>>>>>>  drivers/media/usb/uvc/uvc_v4l2.c | 30 ++++++++++++++++++++++++++++++
>>>>>>  1 file changed, 30 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
>>>>>> b/drivers/media/usb/uvc/uvc_v4l2.c index 2764f43607c1..e2698a77138a
>>>>>> 100644
>>>>>> --- a/drivers/media/usb/uvc/uvc_v4l2.c
>>>>>> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
>>>>>> @@ -1001,6 +1001,35 @@ static int uvc_ioctl_g_ext_ctrls(struct file
>>>>>> *file, void *fh,
>>>>>>  	return uvc_ctrl_rollback(handle);
>>>>>>  }
>>>>>>
>>>>>> +static int uvc_ioctl_g_def_ext_ctrls(struct file *file, void *fh,
>>>>>> +				     struct v4l2_ext_controls *ctrls)
>>>>>> +{
>>>>>> +	struct uvc_fh *handle = fh;
>>>>>> +	struct uvc_video_chain *chain = handle->chain;
>>>>>> +	struct v4l2_ext_control *ctrl = ctrls->controls;
>>>>>> +	unsigned int i;
>>>>>> +	int ret;
>>>>>> +	struct v4l2_queryctrl qc;
>>>>>> +
>>>>>> +	ret = uvc_ctrl_begin(chain);
>>>>>
>>>>> There's no need to call uvc_ctrl_begin() here (and if there was, you'd
>>>>> have to call uvc_ctrl_rollback() or uvc_ctrl_commit() before returning).
>>>>>
>>>>>> +	if (ret < 0)
>>>>>> +		return ret;
>>>>>> +
>>>>>> +	for (i = 0; i < ctrls->count; ++ctrl, ++i) {
>>>>>> +		qc.id = ctrl->id;
>>>>>> +		ret = uvc_query_v4l2_ctrl(chain, &qc);
>>>>>> +		if (ret < 0) {
>>>>>> +			ctrls->error_idx = i;
>>>>>> +			return ret;
>>>>>> +		}
>>>>>> +		ctrl->value = qc.default_value;
>>>>>> +	}
>>>>>> +
>>>>>> +	ctrls->error_idx = 0;
>>>>>> +
>>>>>> +	return 0;
>>>>>> +}
>>>>>
>>>>> Instead of open-coding this in multiple drivers, how about adding a
>>>>> helper function to the core ? Something like (totally untested)
>>>>
>>>> It's only open-coded in drivers that do not use the control framework.
>>>> For drivers that use the control framework it is completely transparent.
>>>
>>> Sure, but still, the same function is implemented several times while a
>>> single implementation could do. I'd prefer having it in the core until
>>> all (or all but one) drivers are converted to the control framework.
>>
>> There are only three drivers that need to implement this manually: uvc,
>> saa7164 and pvrusb2. That's not enough to warrant moving this into the
>> core.
> 
> I'd argue that even just two drivers would be enough :-) Especially given that 
> the proposed implementation for uvcvideo is wrong.

I don't want to add code to the core to cater to exceptions.

>> One of these days I should sit down and convert saa7164 to the control
>> framework. That shouldn't be too difficult.
> 
> How about pvrusb2, is there a good reason not to use the control framework 
> there ?

Brrr. pvrusb2 exports controls (and a bunch of other things) to /sys allowing
scripts to get/set controls using cat and echo. I have no idea how to switch pvrusb2
to the control framework while still keeping this non-standard API.

I guess one of these days I will need to look at it, but I've been postponing it
for years now :-)

There are still a few other drivers that do not use the control framework:

saa7164, zoran, fsl-viu, omap_vout (although I hope that one can be removed),
usbvision and bcm2048 (that's a staging driver, so I can probably ignore that one).

pvrusb2 is actually fairly important: v4l2-subdev still has legacy ops for handling
controls and as long as pvrusb2 is not converted I cannot remove those ops.

Regards,

	Hans
