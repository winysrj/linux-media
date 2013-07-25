Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:34127 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142Ab3GYJpz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jul 2013 05:45:55 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQH00HA0K5NKC50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 25 Jul 2013 10:45:54 +0100 (BST)
Message-id: <51F0F3D0.8010700@samsung.com>
Date: Thu, 25 Jul 2013 11:45:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, prabhakar.csengg@gmail.com,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	kyungmin.park@samsung.com
Subject: Re: [PATCH RFC 3/5] V4L2: Add V4L2_ASYNC_MATCH_OF subdev matching type
References: <1374516287-7638-1-git-send-email-s.nawrocki@samsung.com>
 <1374516287-7638-4-git-send-email-s.nawrocki@samsung.com>
 <Pine.LNX.4.64.1307241320170.30777@axis700.grange>
In-reply-to: <Pine.LNX.4.64.1307241320170.30777@axis700.grange>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 07/24/2013 01:21 PM, Guennadi Liakhovetski wrote:
> Hi Sylwester
> 
> On Mon, 22 Jul 2013, Sylwester Nawrocki wrote:
> 
>> Add support for matching by device_node pointer. This allows
>> the notifier user to simply pass a list of device_node pointers
>> corresponding to sub-devices.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-async.c |    9 +++++++++
>>  include/media/v4l2-async.h           |    5 +++++
>>  2 files changed, 14 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
>> index 86934ca..9f91013 100644
>> --- a/drivers/media/v4l2-core/v4l2-async.c
>> +++ b/drivers/media/v4l2-core/v4l2-async.c
>> @@ -39,6 +39,11 @@ static bool match_devname(struct device *dev, struct v4l2_async_subdev *asd)
>>  	return !strcmp(asd->match.device_name.name, dev_name(dev));
>>  }
>>  
>> +static bool match_of(struct device *dev, struct v4l2_async_subdev *asd)
>> +{
>> +	return dev->of_node == asd->match.of.node;
>> +}
>> +
>>  static LIST_HEAD(subdev_list);
>>  static LIST_HEAD(notifier_list);
>>  static DEFINE_MUTEX(list_lock);
>> @@ -66,6 +71,9 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
>>  		case V4L2_ASYNC_MATCH_I2C:
>>  			match = match_i2c;
>>  			break;
>> +		case V4L2_ASYNC_MATCH_OF:
>> +			match = match_of;
>> +			break;
>>  		default:
>>  			/* Cannot happen, unless someone breaks us */
>>  			WARN_ON(true);
>> @@ -145,6 +153,7 @@ int v4l2_async_notifier_register(struct v4l2_device *v4l2_dev,
>>  		case V4L2_ASYNC_MATCH_CUSTOM:
>>  		case V4L2_ASYNC_MATCH_DEVNAME:
>>  		case V4L2_ASYNC_MATCH_I2C:
>> +		case V4L2_ASYNC_MATCH_OF:
>>  			break;
>>  		default:
>>  			dev_err(notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL,
>> diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
>> index 33e3b2a..295782e 100644
>> --- a/include/media/v4l2-async.h
>> +++ b/include/media/v4l2-async.h
>> @@ -13,6 +13,7 @@
>>  
>>  #include <linux/list.h>
>>  #include <linux/mutex.h>
>> +#include <linux/of.h>
>>  
>>  struct device;
>>  struct v4l2_device;
> 
> A nitpick: it is common to just forward-declare structs as above instead 
> of including a header if just a pointer to that struct is needed. I think 
> it would be more consistent to update it here.

Sure, I will make this change before sending the pull request. I wasn't 
really sure which way is better.
--
Regards,
Sylwester

