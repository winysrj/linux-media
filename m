Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:55174 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318Ab3ETOY3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 May 2013 10:24:29 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MN3009GCP92PBA0@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 20 May 2013 15:24:27 +0100 (BST)
Message-id: <519A3219.9040809@samsung.com>
Date: Mon, 20 May 2013 16:24:25 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	hj210.choi@samsung.com, sw0312.kim@samsung.com
Subject: Re: [PATCH RFC v3 2/3] media: added managed v4l2 control initialization
References: <1368692074-483-1-git-send-email-a.hajda@samsung.com>
 <1368692074-483-3-git-send-email-a.hajda@samsung.com>
 <20130516223451.GA2077@valkosipuli.retiisi.org.uk>
In-reply-to: <20130516223451.GA2077@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the review.


On 17.05.2013 00:34, Sakari Ailus wrote:
> Hi Andrzej,
>
> Thanks for the patchset!
>
> On Thu, May 16, 2013 at 10:14:33AM +0200, Andrzej Hajda wrote:
>> This patch adds managed version of initialization
>> function for v4l2 control handler.
>>
>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>> v3:
>> 	- removed managed cleanup
>> v2:
>> 	- added missing struct device forward declaration,
>> 	- corrected few comments
>> ---
>>  drivers/media/v4l2-core/v4l2-ctrls.c |   32 ++++++++++++++++++++++++++++++++
>>  include/media/v4l2-ctrls.h           |   16 ++++++++++++++++
>>  2 files changed, 48 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index ebb8e48..f47ccfa 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -1421,6 +1421,38 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
>>  }
>>  EXPORT_SYMBOL(v4l2_ctrl_handler_free);
>>  
>> +static void devm_v4l2_ctrl_handler_release(struct device *dev, void *res)
>> +{
>> +	struct v4l2_ctrl_handler **hdl = res;
>> +
>> +	v4l2_ctrl_handler_free(*hdl);
> v4l2_ctrl_handler_free() acquires hdl->mutex which is independent of the
> existence of hdl. By default hdl->lock is in the handler, but it may also be
> elsewhere, e.g. in a driver-specific device struct such as struct
> smiapp_sensor defined in drivers/media/i2c/smiapp/smiapp.h. I wonder if
> anything guarantees that hdl->mutex still exists at the time the device is
> removed.
IMO in general if somebody provides custom mutex he becomes responsible
for validity of that mutex during v4l2_ctrl_handler usage.
In the particular case of smiapp if we replace v4l2_ctrl_handler_init with
devm version and remove v4l2_ctrl_handler_free calls it seems to be OK:
- mutex is in devm allocated memory chunk acquired at the beginning of
probe,
- mutex is initialized before devm_v4l2_ctrl_handler_init,
- there is no mutex_destroy call - ie the mutex is valid until the
memory is freed,
- memory free is called after v4l2_ctrl_handler_free - devm
'destructors' are
called in order reverse to devm_* 'constructor' calls.

Anyway in cases when devm_* usage would cause errors
we can still use non devm_* versions.
>
> I have to say I don't think it's neither meaningful to acquire that mutex in
> v4l2_ctrl_handler_free(), though, since the whole going to be freed next
> anyway: reference counting would be needed to prevent bad things from
> happening, in case the drivers wouldn't take care of that.
I do not understand what do you mean exactly. Could you please explain
it more?
What do you want to reference count?


Regards
Andrzej
>
>> +}
>> +

