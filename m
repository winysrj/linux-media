Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:35522 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754329AbeGGVJZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 7 Jul 2018 17:09:25 -0400
Subject: Re: [PATCH v5 15/17] media: platform: Switch to
 v4l2_async_notifier_add_subdev
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Steve Longerbeam <slongerbeam@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1530298220-5097-1-git-send-email-steve_longerbeam@mentor.com>
 <1530298220-5097-16-git-send-email-steve_longerbeam@mentor.com>
 <20180702112327.3rzfxmhghoakbcyz@valkosipuli.retiisi.org.uk>
From: Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <83f950df-7f5b-2dda-3f48-ac25d67e5069@gmail.com>
Date: Sat, 7 Jul 2018 14:09:21 -0700
MIME-Version: 1.0
In-Reply-To: <20180702112327.3rzfxmhghoakbcyz@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,


On 07/02/2018 04:23 AM, Sakari Ailus wrote:
> On Fri, Jun 29, 2018 at 11:49:59AM -0700, Steve Longerbeam wrote:
>> diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
>> index a96f53c..8464ceb 100644
>> --- a/drivers/media/platform/davinci/vpif_capture.c
>> +++ b/drivers/media/platform/davinci/vpif_capture.c
>> @@ -1553,7 +1553,7 @@ vpif_capture_get_pdata(struct platform_device *pdev)
>>   					    sizeof(*chan->inputs),
>>   					    GFP_KERNEL);
>>   		if (!chan->inputs)
>> -			return NULL;
>> +			goto err_cleanup;
>>   
>>   		chan->input_count++;
>>   		chan->inputs[i].input.type = V4L2_INPUT_TYPE_CAMERA;
>> @@ -1587,28 +1587,30 @@ vpif_capture_get_pdata(struct platform_device *pdev)
>>   			rem->name, rem);
>>   		sdinfo->name = rem->full_name;
>>   
>> -		pdata->asd[i] = devm_kzalloc(&pdev->dev,
>> -					     sizeof(struct v4l2_async_subdev),
>> -					     GFP_KERNEL);
>> -		if (!pdata->asd[i]) {
>> +		pdata->asd[i] = v4l2_async_notifier_add_fwnode_subdev(
>> +			&vpif_obj.notifier, of_fwnode_handle(rem),
>> +			sizeof(struct v4l2_async_subdev));
>> +		if (IS_ERR(pdata->asd[i])) {
>>   			of_node_put(rem);
>> -			pdata = NULL;
>> -			goto done;
>> +			goto err_cleanup;
>>   		}
>>   
>> -		pdata->asd[i]->match_type = V4L2_ASYNC_MATCH_FWNODE;
>> -		pdata->asd[i]->match.fwnode = of_fwnode_handle(rem);
>> -		of_node_put(rem);
>> +		of_node_put(endpoint);
> You end up putting the same endpoint twice in the successful case.
>
> One way to address that would be to get the OF node's remote port parent
> (i.e. the device) immediately so you can forget OF node use counts in error
> handling.
>

Thanks for catching. I ended up doing what you suggested, moved the get
of remote port parent to just after getting local endpoint node, and removed
node puts in the done and cleanup paths, in vpif_capture_get_pdata().

Steve
