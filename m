Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pl0-f66.google.com ([209.85.160.66]:38465 "EHLO
        mail-pl0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbeHDSks (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Aug 2018 14:40:48 -0400
Subject: Re: [PATCH v6 03/17] media: v4l2: async: Add
 v4l2_async_notifier_add_subdev
To: jacopo mondi <jacopo@jmondi.org>
Cc: linux-media@vger.kernel.org,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sebastian Reichel <sre@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1531175957-1973-1-git-send-email-steve_longerbeam@mentor.com>
 <1531175957-1973-4-git-send-email-steve_longerbeam@mentor.com>
 <20180803151346.GG4528@w540>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <e465780e-823c-c59e-29d1-f62f3a0e1673@gmail.com>
Date: Sat, 4 Aug 2018 09:39:30 -0700
MIME-Version: 1.0
In-Reply-To: <20180803151346.GG4528@w540>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,


On 08/03/2018 08:13 AM, jacopo mondi wrote:
> Hi Steven,
>     I've a small remark, which is probably not only related to your
>     patches but was there alreay... Anyway, please read below..
>
>
> On Mon, Jul 09, 2018 at 03:39:03PM -0700, Steve Longerbeam wrote:
>> <snip>
>> +static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>> +{
>>   	struct v4l2_async_subdev *asd;
>>   	int ret;
>>   	int i;
>> @@ -399,29 +445,25 @@ static int __v4l2_async_notifier_register(struct v4l2_async_notifier *notifier)
>>
>>   	mutex_lock(&list_lock);
>>
>> -	for (i = 0; i < notifier->num_subdevs; i++) {
>> -		asd = notifier->subdevs[i];
>> +	if (notifier->subdevs) {
>> +		for (i = 0; i < notifier->num_subdevs; i++) {
>> +			asd = notifier->subdevs[i];
>>
>> -		switch (asd->match_type) {
>> -		case V4L2_ASYNC_MATCH_CUSTOM:
>> -		case V4L2_ASYNC_MATCH_DEVNAME:
>> -		case V4L2_ASYNC_MATCH_I2C:
>> -		case V4L2_ASYNC_MATCH_FWNODE:
>> -			if (v4l2_async_notifier_has_async_subdev(
>> -				    notifier, asd, i)) {
>> -				dev_err(dev,
>> -					"asd has already been registered or in notifier's subdev list\n");
>> -				ret = -EEXIST;
>> +			ret = v4l2_async_notifier_asd_valid(notifier, asd, i);
>> +			if (ret)
>>   				goto err_unlock;
>> -			}
>> -			break;
>> -		default:
>> -			dev_err(dev, "Invalid match type %u on %p\n",
>> -				asd->match_type, asd);
>> -			ret = -EINVAL;
>> -			goto err_unlock;
>> +
>> +			list_add_tail(&asd->list, &notifier->waiting);
>> +		}
>> +	} else {
>> +		i = 0;
>> +		list_for_each_entry(asd, &notifier->asd_list, asd_list) {
>> +			ret = v4l2_async_notifier_asd_valid(notifier, asd, i++);
> Here the call stack looks like this, if I'm not mistaken:
>
> list_for_each_entry(asd, notifier->asd_list, i) {
>          v4l2_async_notifier_asd_valid(notifier, asd, i):
>                  v4l2_async_notifier_has_async_subdev(notifier, asd, i):
>                          list_for_each_entry(asd_y, notifier->asd_list, j) {
>                                  if (j >= i) break;
>                                  if (asd == asd_y) return true;
>                          }
> }
>
> Which is an optimization of O(n^2), but still bad.
>
> This was there already there, it was:

Agreed, it should be safe to remove the check for duplicate
asd's at notifier registration, since this check is done now
in v4l2_async_notifier_add_subdev().

Steve

> for (i = 0; i < notifier->num_subdevs; i++) {
>          v4l2_async_notifier_has_async_subdev(notifier, notifier->subdevs[i], i):
>                  for (j = 0; j < i; j++) {
>                          if (notifier->subdevs[i] == notifier->subdevs[j])
>                                  return true;
>                          }
>                  }
> }
>
> We're not talking high performances here, but I see no reason to go through
> the list twice, as after switching to use your here introduced
> v4l2_async_notifier_add_subdev() async subdevices are tested at endpoint
> parsing time in v4l2_async_notifier_fwnode_parse_endpoint(), which
> guarantees we can't have doubles later, at notifier registration time.
>
> If I'm not wrong, this can be anyway optimized later.
>
> Thanks
>     j
>
>
