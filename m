Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56985 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab1IUNyJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 09:54:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LRV003M4LA7FV40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 14:54:07 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRV00M41LA7PW@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 14:54:07 +0100 (BST)
Date: Wed, 21 Sep 2011 15:54:07 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v3 1/3] noon010pc30: Conversion to the media controller API
In-reply-to: <201109210018.14185.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sw0312.kim@samsung.com,
	riverful.kim@samsung.com
Message-id: <4E79EC7F.2050003@samsung.com>
References: <1316188796-8374-1-git-send-email-s.nawrocki@samsung.com>
 <1316188796-8374-2-git-send-email-s.nawrocki@samsung.com>
 <201109210018.14185.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

thanks for the review.

On 09/21/2011 12:18 AM, Laurent Pinchart wrote:
> Hi Sylwester,
> 
> Thanks for the patch.
> 
> On Friday 16 September 2011 17:59:54 Sylwester Nawrocki wrote:
>> Replace g/s_mbus_fmt ops with the pad level get/set_fmt operations.
>> Add media entity initialization and set subdev flags so the host driver
>> creates a subdev device node for the driver.
>> A mutex was added for serializing the subdev operations. When setting
>> format is attempted during streaming an (EBUSY) error will be returned.
>>
>> After the device is powered up it will now remain in "power sleep"
>> mode until s_stream(1) is called. The "power sleep" mode is used
>> to suspend/resume frame generation at the sensor's output through
>> s_stream op.
>>
>> While at here simplify the colorspace parameter handling.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> [snip]
> 
>> diff --git a/drivers/media/video/noon010pc30.c
>> b/drivers/media/video/noon010pc30.c index 35f722a..115d976 100644
>> --- a/drivers/media/video/noon010pc30.c
>> +++ b/drivers/media/video/noon010pc30.c
> 
> [snip]
> 
>> @@ -599,6 +641,22 @@ static int noon010_log_status(struct v4l2_subdev *sd)
>>  	return 0;
>>  }
>>
>> +static int noon010_open(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh)
>> +{
>> +	struct v4l2_mbus_framefmt *mf = v4l2_subdev_get_try_format(fh, 0);
>> +	struct noon010_info *info = to_noon010(sd);
>> +
>> +	mutex_lock(&info->lock);
>> +	noon010_get_current_fmt(to_noon010(sd), mf);
> 
> Should you initialize mf with a constant default format instead of retrieving 
> the current format from the sensor ? A non-constant default would probably 
> confuse userspace application.

Sure, I could change to it. But I don't quite see the problem, the applications
should call set_fmt(TRY) anyway, rather than relying on the format gotten right
after opening the device, shouldn't they ? Anyway I guess it's better to have
all drivers behaving consistently.


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
