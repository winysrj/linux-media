Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:62237 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751029AbeBIMsw (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Feb 2018 07:48:52 -0500
Subject: Re: [PATCHv2 04/15] v4l2-subdev: without controls return -ENOTTY
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180208083655.32248-1-hverkuil@xs4all.nl>
 <20180208083655.32248-5-hverkuil@xs4all.nl>
 <20180209114559.s3gpuzccdsemqhfe@valkosipuli.retiisi.org.uk>
 <c2c96e5d-518d-f858-29d5-2dfefdb17c03@cisco.com>
 <20180209123845.esj7dvqpq5fl2k5y@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <67ea6eb8-ed94-fe1f-a367-4fe79671f569@cisco.com>
Date: Fri, 9 Feb 2018 13:48:49 +0100
MIME-Version: 1.0
In-Reply-To: <20180209123845.esj7dvqpq5fl2k5y@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/09/18 13:38, Sakari Ailus wrote:
> Hi Hans,
> 
> On Fri, Feb 09, 2018 at 12:56:37PM +0100, Hans Verkuil wrote:
>> On 02/09/18 12:46, Sakari Ailus wrote:
>>> Hi Hans,
>>>
>>> On Thu, Feb 08, 2018 at 09:36:44AM +0100, Hans Verkuil wrote:
>>>> If the subdev did not define any controls, then return -ENOTTY if
>>>> userspace attempts to call these ioctls.
>>>>
>>>> The control framework functions will return -EINVAL, not -ENOTTY if
>>>> vfh->ctrl_handler is NULL.
>>>>
>>>> Several of these framework functions are also called directly from
>>>> drivers, so I don't want to change the error code there.
>>>>
>>>> Found with vimc and v4l2-compliance.
>>>>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> Thanks for the patch.
>>>
>>> If the handler is NULL, can there be support for the IOCTL at all? I.e.
>>> should the missing handler as such result in returning -ENOTTY from these
>>> functions instead of -EINVAL?
>>
>> I didn't dare change the control framework. Some of these v4l2_... functions
>> are called by drivers and I didn't want to analyze them all. If these
>> functions were only called by v4l2-ioctl.c and v4l2-subdev.c, then I'd have
>> changed it in v4l2-ctrls.c, but that's not the case.
>>
>> It would be a useful project to replace all calls from drivers to these
>> functions (they really shouldn't be used by drivers), but that is out-of-scope
>> of this patch.
> 
> Is your concern that the caller could check the return value and do
> something based on particular error code it gets?

Or that the handler is NULL and it returns ENOTTY to userspace. You can have
multiple control handlers, some of which might be NULL. It's all unlikely,
but the code needs to be analyzed and that takes time. Hmm, atomisp is
definitely a big user of these functions.

Also, the real issue is the use of these functions by drivers. What I want
to do is to have the drivers use the proper functions, then I can move those
functions to the core and stop exporting them. And at that moment they can
return -ENOTTY instead of -EINVAL.

A worthwhile project, but right now I just want to fix v4l2-subdev.c.

Regards,

	Hans

> Based on a quick glance there are a few tens of places these functions are
> used in drivers. Some seems legitimate; the caller having another device
> where a control needs to be accessed, for instance.
> 
> And if handler is NULL, -ENOTTY appears to be a more suitable return value
> in a lot of the cases (and in many others it makes no difference).
> 
> I wouldn't say this is something that should hold back addressing this in
> the control framework instead.
> 
> I can submit a patch if you'd prefer that instead.
> 
>>
>> Regards,
>>
>> 	Hans
>>
>>>
>>>> ---
>>>>  drivers/media/v4l2-core/v4l2-subdev.c | 16 ++++++++++++++++
>>>>  1 file changed, 16 insertions(+)
>>>>
>>>> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
>>>> index 43fefa73e0a3..be7a19272614 100644
>>>> --- a/drivers/media/v4l2-core/v4l2-subdev.c
>>>> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
>>>> @@ -187,27 +187,43 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>>>>  
>>>>  	switch (cmd) {
>>>>  	case VIDIOC_QUERYCTRL:
>>>> +		if (!vfh->ctrl_handler)
>>>> +			return -ENOTTY;
>>>>  		return v4l2_queryctrl(vfh->ctrl_handler, arg);
>>>>  
>>>>  	case VIDIOC_QUERY_EXT_CTRL:
>>>> +		if (!vfh->ctrl_handler)
>>>> +			return -ENOTTY;
>>>>  		return v4l2_query_ext_ctrl(vfh->ctrl_handler, arg);
>>>>  
>>>>  	case VIDIOC_QUERYMENU:
>>>> +		if (!vfh->ctrl_handler)
>>>> +			return -ENOTTY;
>>>>  		return v4l2_querymenu(vfh->ctrl_handler, arg);
>>>>  
>>>>  	case VIDIOC_G_CTRL:
>>>> +		if (!vfh->ctrl_handler)
>>>> +			return -ENOTTY;
>>>>  		return v4l2_g_ctrl(vfh->ctrl_handler, arg);
>>>>  
>>>>  	case VIDIOC_S_CTRL:
>>>> +		if (!vfh->ctrl_handler)
>>>> +			return -ENOTTY;
>>>>  		return v4l2_s_ctrl(vfh, vfh->ctrl_handler, arg);
>>>>  
>>>>  	case VIDIOC_G_EXT_CTRLS:
>>>> +		if (!vfh->ctrl_handler)
>>>> +			return -ENOTTY;
>>>>  		return v4l2_g_ext_ctrls(vfh->ctrl_handler, arg);
>>>>  
>>>>  	case VIDIOC_S_EXT_CTRLS:
>>>> +		if (!vfh->ctrl_handler)
>>>> +			return -ENOTTY;
>>>>  		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, arg);
>>>>  
>>>>  	case VIDIOC_TRY_EXT_CTRLS:
>>>> +		if (!vfh->ctrl_handler)
>>>> +			return -ENOTTY;
>>>>  		return v4l2_try_ext_ctrls(vfh->ctrl_handler, arg);
>>>>  
>>>>  	case VIDIOC_DQEVENT:
>>>
>>
> 
