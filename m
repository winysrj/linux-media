Return-path: <linux-media-owner@vger.kernel.org>
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8281 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754562AbbIXR0i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2015 13:26:38 -0400
Subject: Re: [Question]: What's right way to use struct media_pipeline?
To: Hans Verkuil <hverkuil@xs4all.nl>,
	<laurent.pinchart@ideasonboard.com>
References: <56035829.2080300@nvidia.com> <5603B8B3.3060109@xs4all.nl>
CC: <linux-media@vger.kernel.org>
From: Bryan Wu <pengw@nvidia.com>
Message-ID: <5604324D.70000@nvidia.com>
Date: Thu, 24 Sep 2015 10:26:37 -0700
MIME-Version: 1.0
In-Reply-To: <5603B8B3.3060109@xs4all.nl>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/24/2015 01:47 AM, Hans Verkuil wrote:
> On 09/24/2015 02:55 AM, Bryan Wu wrote:
>> Hi Hans,
>>
>> I found struct media_pipeline actually is completely empty and I assume we use that to control all the entities belonging to one media_pipeline.
>>
>> media_pipeline should contains either all the media_link or all the media_entity. How come an empty struct can provide those information?
> It's basically an empty base class to speak in C++ terminology.
>
> See drivers/media/platform/xilinx/xilinx-dma.h on how it is used there.
>
> Laurent Pinchart knows a lot more about it than I do, though.
>

Hi Laurent,

I have a subdev media entity which have 4 media pads.

pad[0] is sink and pad[1] is source, these 2 pads belong to the first 
media pipeline

pad[2] is sink and pad[3] is source, these 2 pads belong to the second 
media pipeline

Actually our hardware Tegra has 3 these kind of entities, so totally we 
have 6 media pipelines like 6 dma channels.

How to handle that with media pipeline framework? I saw in xilinx driver 
it just has one pipeline which is shared by several DMA channels, right?

-Bryan

>
>> What about following ideas?
>> 1. when media_entity_create_links, it will return a media_link pointer.
>> 2. we save this media_link pointer into the media_pipeline
>> 3. use this media_pipeline for start streaming, stop streaming and validate links.
>>
>> Maybe I miss something during recent media controller changes.
>>
>> Thanks,
>> -Bryan
>>
>> -----------------------------------------------------------------------------------
>> This email message is for the sole use of the intended recipient(s) and may contain
>> confidential information.  Any unauthorized review, use, disclosure or distribution
>> is prohibited.  If you are not the intended recipient, please contact the sender by
>> reply email and destroy all copies of the original message.
>> -----------------------------------------------------------------------------------

