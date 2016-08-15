Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:46897 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbcHOIRk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 04:17:40 -0400
Subject: Re: [PATCH 2/3] soc-camera/rcar-vin: remove obsolete driver
To: =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1470038065-30789-1-git-send-email-hverkuil@xs4all.nl>
 <1470038065-30789-3-git-send-email-hverkuil@xs4all.nl>
 <3585190.qMTDhgQKz3@avalon> <20160801204130.GF3672@bigcity.dyn.berto.se>
 <6432f1b4-0e27-dcbc-1067-f717bf1a3d66@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5a2fca17-71f5-3d54-a037-b839fea21eaf@xs4all.nl>
Date: Mon, 15 Aug 2016 10:17:35 +0200
MIME-Version: 1.0
In-Reply-To: <6432f1b4-0e27-dcbc-1067-f717bf1a3d66@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/02/2016 09:35 AM, Hans Verkuil wrote:
> 
> 
> On 08/01/2016 10:41 PM, Niklas Söderlund wrote:
>> On 2016-08-01 11:31:11 +0300, Laurent Pinchart wrote:
>>> Hi Hans,
>>>
>>> Thank you for the patch.
>>>
>>> On Monday 01 Aug 2016 09:54:24 Hans Verkuil wrote:
>>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>>
>>>> This driver has been replaced by the non-soc-camera rcar-vin driver.
>>>> The soc-camera framework is being deprecated, so drop this older
>>>> rcar-vin driver in favor of the newer version that does not rely on
>>>> this deprecated framework.
>>>>
>>>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>>> Cc: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>>>
>>> I'm all for removal of dead code :-)
>>>
>>> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>>>
>>> But please get Niklas' ack to confirm that the new driver supports all the 
>>> feature available in the old one.
>>
>> I'm all for removing this code. And I do believe the new driver supports 
>> (almost, see 1) all features this one do. There are however two known 
>> issues with the new driver which maybe should be resolved before the old 
>> one is removed.
>>
>> 1. The soc-camera driver call g_std to determine video standard if field 
>>    is V4L2_FIELD_INTERLACED. The new driver dose not.
>>
>>    I'm preparing a patch which restores this functionality and hope to 
>>    post it soon.
> 
> Shouldn't be a problem to get that in for 4.9.
> 
>>
>> 2. There is a error in the DT parsing code where of_node_put() is called 
>>    twice resulting in a nice backtrace while booting if the debug config 
>>    options are enabled.
>>
>>    There is a fix for this in the Gen3 enablement series but maybe I 
>>    should break it out from there and post it separately?
> 
> Yes please. It sounds as if this should be backported to 4.8-rcX as well?

Just to be certain: no patches for these two issues have been posted yet,
right?

We're getting very close to being able to drop soc-camera as a framework, and
I'd love to finish that for 4.9.

Regards,

	Hans

> 
>>
>> I would like to solve issue no 1 before we remove the soc-camera driver, 
>> hopefully we can do so shortly.
> 
> The removal of the old driver is for 4.9, so there is a lot of time.
> 
> Regards,
> 
> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
