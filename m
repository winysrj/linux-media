Return-Path: <SRS0=yUb4=PN=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E91A4C43387
	for <linux-media@archiver.kernel.org>; Sat,  5 Jan 2019 00:49:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7A1621872
	for <linux-media@archiver.kernel.org>; Sat,  5 Jan 2019 00:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbfAEAtD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 4 Jan 2019 19:49:03 -0500
Received: from relay1.mentorg.com ([192.94.38.131]:64065 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfAEAtD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2019 19:49:03 -0500
Received: from svr-orw-mbx-02.mgc.mentorg.com ([147.34.90.202])
        by relay1.mentorg.com with esmtps (TLSv1.2:ECDHE-RSA-AES256-SHA384:256)
        id 1gfa8m-0007P0-8n from Steve_Longerbeam@mentor.com ; Fri, 04 Jan 2019 16:48:40 -0800
Received: from [172.30.89.159] (147.34.91.1) by svr-orw-mbx-02.mgc.mentorg.com
 (147.34.90.202) with Microsoft SMTP Server (TLS) id 15.0.1320.4; Fri, 4 Jan
 2019 16:48:37 -0800
Subject: Re: [RFC PATCH] media: rcar-vin: Allow independent VIN link
 enablement
To:     Steve Longerbeam <slongerbeam@gmail.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
CC:     <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "open list:MEDIA DRIVERS FOR RENESAS - VIN" 
        <linux-renesas-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20181225232725.15935-1-slongerbeam@gmail.com>
 <20181227005125.GK19796@bigcity.dyn.berto.se>
 <fb6f58b2-3c19-455a-96dc-8e7314e1c8ce@gmail.com>
From:   Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <bc2b1307-4d89-26b5-c248-6cc74bffa88e@mentor.com>
Date:   Fri, 4 Jan 2019 16:48:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <fb6f58b2-3c19-455a-96dc-8e7314e1c8ce@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: svr-orw-mbx-04.mgc.mentorg.com (147.34.90.204) To
 svr-orw-mbx-02.mgc.mentorg.com (147.34.90.202)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

How about a patch that simply replaces the entity use_count check with a 
stream_count check?

As in:

diff --git a/drivers/media/platform/rcar-vin/rcar-core.c 
b/drivers/media/platform/rcar-vin/rcar-core.c
index f0719ce24b97..aef8d8dab6ab 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -131,9 +131,13 @@ static int rvin_group_link_notify(struct media_link 
*link, u32 flags,
!is_media_entity_v4l2_video_device(link->sink->entity))
          return 0;

-    /* If any entity is in use don't allow link changes. */
+    /*
+     * Don't allow link changes if any entity in the graph is
+     * streaming, modifying the CHSEL register fields can disrupt
+     * running streams.
+     */
      media_device_for_each_entity(entity, &group->mdev)
-        if (entity->use_count)
+        if (entity->stream_count)
              return -EBUSY;

      mutex_lock(&group->lock);


And that might be overkilll, maybe only the stream_count's of the VIN 
entities need to be checked.

Steve



On 12/29/18 3:37 PM, Steve Longerbeam wrote:
> Hi Niklas,
>
> On 12/26/18 4:51 PM, Niklas Söderlund wrote:
>> Hi Steve,
>>
>> Thanks for your patch.
>>
>> On 2018-12-25 15:27:25 -0800, Steve Longerbeam wrote:
>>> There is a block of code in rvin_group_link_notify() that prevents
>>> enabling a link to a VIN node if any entity in the media graph is
>>> in use. This prevents enabling a VIN link even if there is an in-use
>>> entity somewhere in the graph that is independent of the link's
>>> pipeline.
>>>
>>> For example, the code block will prevent enabling a link from
>>> the first rcar-csi2 receiver to a VIN node even if there is an
>>> enabled link somewhere far upstream on the second independent
>>> rcar-csi2 receiver pipeline.
>> Unfortunately this is by design and needed due to the hardware design.
>> The different VIN endpoints shares a configuration register which
>> controls the routing from the CSI-2 receivers to the VIN (register name
>> CHSEL). Modifying the CHSEL register which is what happens when a link
>> is enabled/disabled can have side effects on running streams even if
>> they are not shown to be dependent in the media graph.
>
> Ok, understood, modifying CHSEL register can adversely affect running 
> streams.
>
>>
>> There is a CHSEL register in VIN0 which controls the routing from all
>> CSI-2 receivers to VIN0-3 and a CHSEL register in VIN4 which controls
>> the same for VIN4-7.
>>
>>> If this code block is meant to prevent modifying a link if the
>>> link is actively involved in streaming, there is already such a
>>> check in __media_entity_setup_link() that verifies the stream_count
>>> of the link's source and sink entities are both zero.
>> For the reason above the check in __media_entity_setup_link() is not
>> enough :-( This register sharing is my least favorite thing about the
>> VIN on Gen3 and forces the driver to become more complex as all VIN
>> instances needs to know about each other and interact.
>>
>
> Given above I understand why the stream count checks in 
> __media_entity_setup_link() are insufficient, because only the 
> requested link's source stream count is checked, and not the other 
> CSI-2 receiver for example.
>
> But why check the use counts of every entity upstream from the VIN 
> sources? Why not check only the VIN source entities stream counts 
> (both CSI-2 receivers and/or parallel devices), and ignore entities 
> upstream from those?
>
> And why are the use counts checked, it seems it should be the stream 
> counts that should be checked.
>
>>> Remove the code block so that VIN node links can be enabled even if
>>> there are other independent in-use entities.
>> There is room for some improvement in this area disregarding the odd
>> hardware design. It *could* be allowed to change a link terminating in
>> VIN4-7 even if there is a stream running for one or more in VIN0-3.
>>
>> I would be interested to test such a patch but to allow any link change
>> which is allowed by __media_entity_setup_link() is unfortunately not
>> possible, as I understand it. Maybe someone more clever then me can find
>> ways to unlock even more then just the split between VIN0-3 and VIn4-7.
>>
>> In essence the CHSEL register can not be changed if it's involved in a
>> running pipeline even if the end result would be that the running
>> pipeline would look the same. This is possible as there are multiple
>> CHSEL settings where the same source is connected to a specific VIN
>> while other members of the "subgroup of VINs" (e.g. VIN0-3) is routed to
>> something else for the two CHSEL settings.
>
> Right, so rvin_group_link_notify() determines whether the requested 
> VIN link enable will result in a valid set of CSI2->VIN links for the 
> given hardware, using the CHSEL bitmask tables. Which is why it seems 
> it is the stream counts that should be checked as mentioned above, 
> rather than the use counts, because the CHSEL bitmask checks are 
> validating the set of enabled links, and the only remaining checks are 
> to verify no streams are running on either CSI-2 receiver.
>
> Steve
>
>
>>> Fixes: c0cc5aef31 ("media: rcar-vin: add link notify for Gen3")
>>>
>>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>>> ---
>>>   drivers/media/platform/rcar-vin/rcar-core.c | 6 ------
>>>   1 file changed, 6 deletions(-)
>>>
>>> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c 
>>> b/drivers/media/platform/rcar-vin/rcar-core.c
>>> index f0719ce24b97..b2c9a876969e 100644
>>> --- a/drivers/media/platform/rcar-vin/rcar-core.c
>>> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
>>> @@ -116,7 +116,6 @@ static int rvin_group_link_notify(struct 
>>> media_link *link, u32 flags,
>>>                           struct rvin_group, mdev);
>>>       unsigned int master_id, channel, mask_new, i;
>>>       unsigned int mask = ~0;
>>> -    struct media_entity *entity;
>>>       struct video_device *vdev;
>>>       struct media_pad *csi_pad;
>>>       struct rvin_dev *vin = NULL;
>>> @@ -131,11 +130,6 @@ static int rvin_group_link_notify(struct 
>>> media_link *link, u32 flags,
>>> !is_media_entity_v4l2_video_device(link->sink->entity))
>>>           return 0;
>>>   -    /* If any entity is in use don't allow link changes. */
>>> -    media_device_for_each_entity(entity, &group->mdev)
>>> -        if (entity->use_count)
>>> -            return -EBUSY;
>>> -
>>>       mutex_lock(&group->lock);
>>>         /* Find the master VIN that controls the routes. */
>>> -- 
>>> 2.17.1
>>>
>

