Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:48575 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbcBPUAz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Feb 2016 15:00:55 -0500
Subject: Re: [PATCH] [media] v4l2-async: Don't fail if registered_async isn't
 implemented
To: Benoit Parrot <bparrot@ti.com>
References: <1455648666-4377-1-git-send-email-javier@osg.samsung.com>
 <20160216195351.GG1380@ti.com>
Cc: linux-kernel@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Bryan Wu <cooloney@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56C37FEE.1080508@osg.samsung.com>
Date: Tue, 16 Feb 2016 17:00:46 -0300
MIME-Version: 1.0
In-Reply-To: <20160216195351.GG1380@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Benoit,

On 02/16/2016 04:53 PM, Benoit Parrot wrote:
> Javier Martinez Canillas <javier@osg.samsung.com> wrote on Tue [2016-Feb-16 15:51:05 -0300]:
>> After sub-dev registration in v4l2_async_test_notify(), the v4l2-async
>> core calls the registered_async callback but if a sub-dev driver does
>> not implement it, v4l2_subdev_call() will return a -ENOIOCTLCMD which
>> should not be considered an error.
>>
>> Reported-by: Benoit Parrot <bparrot@ti.com>
>> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> ---
>>
>>   drivers/media/v4l2-core/v4l2-async.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
>> index 716bfd47daab..4d809115ba49 100644
>> --- a/drivers/media/v4l2-core/v4l2-async.c
>> +++ b/drivers/media/v4l2-core/v4l2-async.c
>> @@ -113,7 +113,7 @@ static int v4l2_async_test_notify(struct v4l2_async_notifier *notifier,
>>   	list_move(&sd->async_list, &notifier->done);
>>
>>   	ret = v4l2_device_register_subdev(notifier->v4l2_dev, sd);
>> -	if (ret < 0) {
>> +	if (ret < 0 && ret != -ENOIOCTLCMD) {
>
> NAK.
> This fix should be on the next if block.
> The one that actually invokes the registered_async call back.

Yeah, that's actually what the commit says but I'm too stupid
to write a one line patch... I'll send a v2.

> As is it does not help.
>

Sorry about that, I shouldn't post patches in a rush.

> Benoit
>

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
