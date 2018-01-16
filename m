Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:41145 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751438AbeAPTe5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 14:34:57 -0500
Subject: Re: [PATCH] v4l: async: Protect against double notifier regstrations
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        niklas.soderlund@ragnatech.se,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        hans.verkuil@cisco.com, mchehab@kernel.org
References: <1516114358-5292-1-git-send-email-kieran.bingham@ideasonboard.com>
 <20180116152305.j7luryentsej42yq@valkosipuli.retiisi.org.uk>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <5536f373-6822-9323-63ff-8d3ee9769f15@ideasonboard.com>
Date: Tue, 16 Jan 2018 19:34:52 +0000
MIME-Version: 1.0
In-Reply-To: <20180116152305.j7luryentsej42yq@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the quick review.

On 16/01/18 15:23, Sakari Ailus wrote:
> Hi Kieran,
> 
> On Tue, Jan 16, 2018 at 02:52:58PM +0000, Kieran Bingham wrote:
>> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>>
>> It can be easy to attempt to register the same notifier twice
>> in mis-handled error cases such as working with -EPROBE_DEFER.
>>
>> This results in odd kernel crashes where the notifier_list becomes
>> corrupted due to adding the same entry twice.
>>
>> Protect against this so that a developer has some sense of the pending
>> failure.
>>
>> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-async.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
>> index 2b08d03b251d..e8476f0755ca 100644
>> --- a/drivers/media/v4l2-core/v4l2-async.c
>> +++ b/drivers/media/v4l2-core/v4l2-async.c
>> @@ -374,6 +374,7 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>>  	struct device *dev =
>>  		notifier->v4l2_dev ? notifier->v4l2_dev->dev : NULL;
>>  	struct v4l2_async_subdev *asd;
>> +	struct v4l2_async_notifier *n;
>>  	int ret;
>>  	int i;
>>  
>> @@ -385,6 +386,19 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>>  
>>  	mutex_lock(&list_lock);
>>  
>> +	/*
>> +	 * Registering the same notifier can occur if a driver incorrectly
>> +	 * handles a -EPROBE_DEFER for example, and will break in a
>> +	 * confusing fashion with linked-list corruption.
>> +	 */
> 
> This would seem fine in the commit message, and it's essentially there
> already. How about simply:
> 
> 	/* Avoid re-registering a notifier. */

Yes, I think I was being my usual overly verbose self trying to say why this is bad.

Your version is simpler and clear.

> 	
> You should actually perform the check before initialising the notifier's
> lists.

I could move the INIT_LIST_HEADs to after the check, and inside the locked
critical section if you think that's appropriate - but I'm not certain it
matters as the driver likely won't work anyway, as it's only going to be here if
it's trying to re-register the device after failing to unregister or some such.

> Although things are likely in a quite bad shape already if this
> happens.

Yes, things are definitely in a bad shape if this happens, and it is not at all
obvious why when you debug :) - That's why I wanted to add this warning.

It's a driver bug - so I don't think it's essential to keep the system running
for long if it happens - just make sure the driver developer knows what has gone
wrong.

I fixed my bug - but it was a real pain to find because of the seemingly random
corruption.

> 
>> +	list_for_each_entry(n, &notifier_list, list) {
>> +		if (n == notifier) {
> 
> if (WARN_ON(n == notifier)) {
> 
> And drop the error message below?
> 

Yes - that sounds reasonable too.

>> +			dev_err(dev, "Notifier has already been registered\n");
>> +			ret = -EEXIST;
>> +			goto err_unlock;
>> +		}
>> +	}
>> +
>>  	for (i = 0; i < notifier->num_subdevs; i++) {
>>  		asd = notifier->subdevs[i];
>>  


--
Kieran
