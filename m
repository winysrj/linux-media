Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:34124 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751432AbdLHIqk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 8 Dec 2017 03:46:40 -0500
Subject: Re: [PATCH v9 03/28] rcar-vin: unregister video device on driver
 removal
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        tomoharu.fukawa.eb@renesas.com,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
References: <20171208010842.20047-1-niklas.soderlund+renesas@ragnatech.se>
 <20171208010842.20047-4-niklas.soderlund+renesas@ragnatech.se>
 <1762416.X4GW5MWmCZ@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8e7dc5cf-06ef-8bc8-a767-6b5ac46a5876@xs4all.nl>
Date: Fri, 8 Dec 2017 09:46:34 +0100
MIME-Version: 1.0
In-Reply-To: <1762416.X4GW5MWmCZ@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/08/2017 08:54 AM, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Friday, 8 December 2017 03:08:17 EET Niklas Söderlund wrote:
>> If the video device was registered by the complete() callback it should
>> be unregistered when the driver is removed.
> 
> The .remove() operation indicates device removal, not driver removal (or, the 
> be more precise, it indicates that the device is unbound from the driver). I'd 
> update the commit message accordingly.
> 
>> Protect from printing an uninitialized video device node name by adding a
>> check in rvin_v4l2_unregister() to identify that the video device is
>> registered.
>>
>> Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
>> Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/platform/rcar-vin/rcar-core.c | 2 ++
>>  drivers/media/platform/rcar-vin/rcar-v4l2.c | 3 +++
>>  2 files changed, 5 insertions(+)
>>
>> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c
>> b/drivers/media/platform/rcar-vin/rcar-core.c index
>> f7a4c21909da6923..6d99542ec74b49a7 100644
>> --- a/drivers/media/platform/rcar-vin/rcar-core.c
>> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
>> @@ -272,6 +272,8 @@ static int rcar_vin_remove(struct platform_device *pdev)
>>
>>  	pm_runtime_disable(&pdev->dev);
>>
>> +	rvin_v4l2_unregister(vin);
> 
> Unless I'm mistaken, you're unregistering the video device both here and in 
> the unbound() function. That's messy, but it's not really your fault, the V4L2 
> core is very messy in the first place, and registering video devices in the 
> complete() handler is a bad idea. As that can't be fixed for now,
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Hans, I still would like to hear your opinion on how this should be solved. 
> You've voiced a few weeks ago that register video devices at probe() time 
> isn't a good idea but you've never explained how we should fix the problem. I 
> still firmly believe that video devices should be registered at probe time, 
> and we need to reach an agreement on a technical solution to this problem.

I have tentatively planned to look into this next week. What will very likely
have to happen is that we need to split off allocation from the registration,
just as is done in most other subsystems. Allocation can be done at probe time,
but the final registration step should likely be in the complete().

To what extent that will resolve this specific issue I don't know. It will take
me time to understand this in more detail.

Regards,

	Hans

> 
>>  	v4l2_async_notifier_unregister(&vin->notifier);
>>  	v4l2_async_notifier_cleanup(&vin->notifier);
>>
>> diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c
>> b/drivers/media/platform/rcar-vin/rcar-v4l2.c index
>> 178aecc94962abe2..32a658214f48fa49 100644
>> --- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
>> +++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
>> @@ -841,6 +841,9 @@ static const struct v4l2_file_operations rvin_fops = {
>>
>>  void rvin_v4l2_unregister(struct rvin_dev *vin)
>>  {
>> +	if (!video_is_registered(&vin->vdev))
>> +		return;
>> +
>>  	v4l2_info(&vin->v4l2_dev, "Removing %s\n",
>>  		  video_device_node_name(&vin->vdev));
> 
