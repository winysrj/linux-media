Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:56330 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751999Ab3EaBDX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 May 2013 21:03:23 -0400
Message-ID: <51A7F811.5090805@iki.fi>
Date: Fri, 31 May 2013 04:08:33 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Andrzej Hajda <a.hajda@samsung.com>, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH RFC v3 2/3] media: added managed v4l2 control initialization
References: <1368692074-483-1-git-send-email-a.hajda@samsung.com> <1368692074-483-3-git-send-email-a.hajda@samsung.com> <20130516223451.GA2077@valkosipuli.retiisi.org.uk> <201305231239.32156.hverkuil@xs4all.nl>
In-Reply-To: <201305231239.32156.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Hans Verkuil wrote:
> On Fri 17 May 2013 00:34:51 Sakari Ailus wrote:
>> Hi Andrzej,
>>
>> Thanks for the patchset!
>>
>> On Thu, May 16, 2013 at 10:14:33AM +0200, Andrzej Hajda wrote:
>>> This patch adds managed version of initialization
>>> function for v4l2 control handler.
>>>
>>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>> v3:
>>> 	- removed managed cleanup
>>> v2:
>>> 	- added missing struct device forward declaration,
>>> 	- corrected few comments
>>> ---
>>>   drivers/media/v4l2-core/v4l2-ctrls.c |   32 ++++++++++++++++++++++++++++++++
>>>   include/media/v4l2-ctrls.h           |   16 ++++++++++++++++
>>>   2 files changed, 48 insertions(+)
>>>
>>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>>> index ebb8e48..f47ccfa 100644
>>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>>> @@ -1421,6 +1421,38 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
>>>   }
>>>   EXPORT_SYMBOL(v4l2_ctrl_handler_free);
>>>
>>> +static void devm_v4l2_ctrl_handler_release(struct device *dev, void *res)
>>> +{
>>> +	struct v4l2_ctrl_handler **hdl = res;
>>> +
>>> +	v4l2_ctrl_handler_free(*hdl);
>>
>> v4l2_ctrl_handler_free() acquires hdl->mutex which is independent of the
>> existence of hdl. By default hdl->lock is in the handler, but it may also be
>> elsewhere, e.g. in a driver-specific device struct such as struct
>> smiapp_sensor defined in drivers/media/i2c/smiapp/smiapp.h. I wonder if
>> anything guarantees that hdl->mutex still exists at the time the device is
>> removed.
>
> If it is a driver-managed lock, then the driver should also be responsible for
> that lock during the life-time of the control handler. I think that is a fair
> assumption.

Agreed.

>> I have to say I don't think it's neither meaningful to acquire that mutex in
>> v4l2_ctrl_handler_free(), though, since the whole going to be freed next
>> anyway: reference counting would be needed to prevent bad things from
>> happening, in case the drivers wouldn't take care of that.
>
> It's probably not meaningful today, but it might become meaningful in the
> future. And in any case, not taking the lock when manipulating internal
> lists is very unexpected even though it might work with today's use cases.

I simply don't think it's meaningful to acquire a lock related to an 
object when that object is being destroyed. If something else was 
holding that lock, you should not have begun destroying that object in 
the first place. This could be solved by reference counting the handler 
which I don't think is needed.

I'd just shout out loud about this rather than hiding such potential 
bug, i.e. replace mutex_lock() and mutex_unlock() in the function by 
WARN_ON(mutex_is_lock()).

But that should be a separate patch.

-- 
Sakari Ailus
sakari.ailus@iki.fi
