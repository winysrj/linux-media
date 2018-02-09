Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:19727 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750961AbeBIL4k (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Feb 2018 06:56:40 -0500
Subject: Re: [PATCHv2 04/15] v4l2-subdev: without controls return -ENOTTY
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180208083655.32248-1-hverkuil@xs4all.nl>
 <20180208083655.32248-5-hverkuil@xs4all.nl>
 <20180209114559.s3gpuzccdsemqhfe@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <c2c96e5d-518d-f858-29d5-2dfefdb17c03@cisco.com>
Date: Fri, 9 Feb 2018 12:56:37 +0100
MIME-Version: 1.0
In-Reply-To: <20180209114559.s3gpuzccdsemqhfe@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/09/18 12:46, Sakari Ailus wrote:
> Hi Hans,
> 
> On Thu, Feb 08, 2018 at 09:36:44AM +0100, Hans Verkuil wrote:
>> If the subdev did not define any controls, then return -ENOTTY if
>> userspace attempts to call these ioctls.
>>
>> The control framework functions will return -EINVAL, not -ENOTTY if
>> vfh->ctrl_handler is NULL.
>>
>> Several of these framework functions are also called directly from
>> drivers, so I don't want to change the error code there.
>>
>> Found with vimc and v4l2-compliance.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Thanks for the patch.
> 
> If the handler is NULL, can there be support for the IOCTL at all? I.e.
> should the missing handler as such result in returning -ENOTTY from these
> functions instead of -EINVAL?

I didn't dare change the control framework. Some of these v4l2_... functions
are called by drivers and I didn't want to analyze them all. If these
functions were only called by v4l2-ioctl.c and v4l2-subdev.c, then I'd have
changed it in v4l2-ctrls.c, but that's not the case.

It would be a useful project to replace all calls from drivers to these
functions (they really shouldn't be used by drivers), but that is out-of-scope
of this patch.

Regards,

	Hans

> 
>> ---
>>  drivers/media/v4l2-core/v4l2-subdev.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
>> index 43fefa73e0a3..be7a19272614 100644
>> --- a/drivers/media/v4l2-core/v4l2-subdev.c
>> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
>> @@ -187,27 +187,43 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>>  
>>  	switch (cmd) {
>>  	case VIDIOC_QUERYCTRL:
>> +		if (!vfh->ctrl_handler)
>> +			return -ENOTTY;
>>  		return v4l2_queryctrl(vfh->ctrl_handler, arg);
>>  
>>  	case VIDIOC_QUERY_EXT_CTRL:
>> +		if (!vfh->ctrl_handler)
>> +			return -ENOTTY;
>>  		return v4l2_query_ext_ctrl(vfh->ctrl_handler, arg);
>>  
>>  	case VIDIOC_QUERYMENU:
>> +		if (!vfh->ctrl_handler)
>> +			return -ENOTTY;
>>  		return v4l2_querymenu(vfh->ctrl_handler, arg);
>>  
>>  	case VIDIOC_G_CTRL:
>> +		if (!vfh->ctrl_handler)
>> +			return -ENOTTY;
>>  		return v4l2_g_ctrl(vfh->ctrl_handler, arg);
>>  
>>  	case VIDIOC_S_CTRL:
>> +		if (!vfh->ctrl_handler)
>> +			return -ENOTTY;
>>  		return v4l2_s_ctrl(vfh, vfh->ctrl_handler, arg);
>>  
>>  	case VIDIOC_G_EXT_CTRLS:
>> +		if (!vfh->ctrl_handler)
>> +			return -ENOTTY;
>>  		return v4l2_g_ext_ctrls(vfh->ctrl_handler, arg);
>>  
>>  	case VIDIOC_S_EXT_CTRLS:
>> +		if (!vfh->ctrl_handler)
>> +			return -ENOTTY;
>>  		return v4l2_s_ext_ctrls(vfh, vfh->ctrl_handler, arg);
>>  
>>  	case VIDIOC_TRY_EXT_CTRLS:
>> +		if (!vfh->ctrl_handler)
>> +			return -ENOTTY;
>>  		return v4l2_try_ext_ctrls(vfh->ctrl_handler, arg);
>>  
>>  	case VIDIOC_DQEVENT:
> 
