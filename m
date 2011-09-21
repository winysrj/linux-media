Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:8626 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab1IUPbd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 11:31:33 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LRV003NWPSJFV50@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 16:31:31 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LRV00K0SPSJ0C@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 21 Sep 2011 16:31:31 +0100 (BST)
Date: Wed, 21 Sep 2011 17:31:30 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 1/3] sr030pc30: Remove empty s_stream op
In-reply-to: <4E7A014F.5040602@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, Kyungmin Park <kyungin.park@samsung.com>
Message-id: <4E7A0352.104@samsung.com>
References: <1295487842-23410-1-git-send-email-s.nawrocki@samsung.com>
 <1295487842-23410-2-git-send-email-s.nawrocki@samsung.com>
 <4E7A014F.5040602@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/21/2011 05:22 PM, Mauro Carvalho Chehab wrote:
> Em 19-01-2011 23:44, Sylwester Nawrocki escreveu:
>> s_stream does nothing in current form so remove it.
>>
>> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungin.park@samsung.com>
>> ---
>>  drivers/media/video/sr030pc30.c |    6 ------
>>  1 files changed, 0 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/video/sr030pc30.c b/drivers/media/video/sr030pc30.c
>> index c901721..e1eced1 100644
>> --- a/drivers/media/video/sr030pc30.c
>> +++ b/drivers/media/video/sr030pc30.c
>> @@ -714,11 +714,6 @@ static int sr030pc30_base_config(struct v4l2_subdev *sd)
>>  	return ret;
>>  }
>>  
>> -static int sr030pc30_s_stream(struct v4l2_subdev *sd, int enable)
>> -{
>> -	return 0;
>> -}
>> -
>>  static int sr030pc30_s_power(struct v4l2_subdev *sd, int on)
>>  {
>>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
>> @@ -761,7 +756,6 @@ static const struct v4l2_subdev_core_ops sr030pc30_core_ops = {
>>  };
>>  
>>  static const struct v4l2_subdev_video_ops sr030pc30_video_ops = {
>> -	.s_stream	= sr030pc30_s_stream,
>>  	.g_mbus_fmt	= sr030pc30_g_fmt,
>>  	.s_mbus_fmt	= sr030pc30_s_fmt,
>>  	.try_mbus_fmt	= sr030pc30_try_fmt,
> 
> Hmm...
> this patch[1] were never merged. It seems a cleanup, though.
> 
> Care to review it?

Indeed, it is still worth to apply. There was some ongoing work
at the control framework and other patches form this series need some
more modifications. But this one alone can be merged.

> 
> Thanks!
> Mauro
> 
> [1] http://patchwork.linuxtv.org/patch/5631/
> 
> 

Thank you,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
