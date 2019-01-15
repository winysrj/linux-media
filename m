Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D2BC43444
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 01:03:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8763620578
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 01:03:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j8A05puo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfAOBDm (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 20:03:42 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35554 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726769AbfAOBDm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 20:03:42 -0500
Received: by mail-wr1-f66.google.com with SMTP id 96so1111133wrb.2;
        Mon, 14 Jan 2019 17:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ZuR3junBJ6TZdgslbZEOU6cCBneCclkEWi9Rhs6tIwE=;
        b=j8A05puoYL4whBevmzOex26zI84I43qLJx/rl7alU/2DMIrUv5S8QprmonaD01T4UA
         +EnZATHMpCHx+yzWdlzCWtVPSKDS+m+oBeLXhWF2gZLl8QDvFO+DYkkXV/kX6R+7VRlE
         V9ux/qcpJPk7wdnxAEXk5Jn9pcJQRGl5hOy4rPQZ8A5maOwnWkIb86gyS0OI6j74DJ0h
         Rk5EpqETK1JV1D7Wy0Y7lf/h6oJBXLUg5fU7OgZpAX/MS6hB6GEUBmoaIxodpFTdmRJp
         IX9qBqpFX9Cuwv7QiC/6FNIyOdyl9W5gQUQ11FlVR416JoUlpSm+4SFac+KgcgmzXKBE
         HGZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZuR3junBJ6TZdgslbZEOU6cCBneCclkEWi9Rhs6tIwE=;
        b=bzLAZKOJrUmq4xjFXmrbxtKVmSNNis6QiEugF25aSaaKgxebVSnDSHIFzjo1y3FNsc
         qaIR2an013qbR5QCBv7g6QTPAZEuOz3D0NT8GPPCwcAnAK29N6guzI29G+z/KpFG3o9d
         14I+wXaC1MD4d6HAAiKBKtWjRSMGM+72cyH7gaIubOSuu3mOlVbYgejwY05/C/It6S0t
         t021BWs7aVyHTH9dyYy+ZWpbOFQT2/vXqdPKjLtPvbmPHq7c4W6148INLtt7T1Xu2eJV
         I3uMxvMFMUYDQfrEWIX/hpMlTGc0EiIHT6vfAgJs14hOzzagTx689NH9yP9prypReeTd
         C30g==
X-Gm-Message-State: AJcUukcdRHopHeRusSwUBFYGPb6OzbF+bjBGplzOQuxt5BRD3BcS5vss
        jtUaZErnx87aHO5anEPmk9venLJl
X-Google-Smtp-Source: ALg8bN6m34FqgyomZortnhoZ8kgPZLBxVjlEA9KGzOZH0TOepFERxtAriEfP8Hue6CwCPA196+l8qA==
X-Received: by 2002:adf:fd87:: with SMTP id d7mr828478wrr.74.1547514219230;
        Mon, 14 Jan 2019 17:03:39 -0800 (PST)
Received: from [172.30.90.180] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id i192sm31968476wmg.7.2019.01.14.17.03.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 17:03:38 -0800 (PST)
Subject: Re: [RFC PATCH v2] media: rcar-vin: Allow independent VIN link
 enablement
From:   Steve Longerbeam <slongerbeam@gmail.com>
To:     =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc:     linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "open list:MEDIA DRIVERS FOR RENESAS - VIN" 
        <linux-renesas-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190106212018.16519-1-slongerbeam@gmail.com>
 <20190109224039.GD24252@bigcity.dyn.berto.se>
 <da87789d-73e8-663c-a25f-d75e4361ade3@gmail.com>
Message-ID: <8ebc5152-1566-b5f5-1fef-2937b4f2e290@gmail.com>
Date:   Mon, 14 Jan 2019 17:03:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <da87789d-73e8-663c-a25f-d75e4361ade3@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 1/9/19 5:19 PM, Steve Longerbeam wrote:
>
>
> On 1/9/19 2:40 PM, Niklas Söderlund wrote:
>> Hi Steve,
>>
>> Thanks for your patch, I think it looks good.
>
> Thanks for the Ack! I'm not real familiar with the RFC patch process. 
> Should this be submitted again with RFC stripped from the subject line?

I've been told there isn't really a process for RFC patch submission. I 
will re-submit and strip off the RFC and add your Reviewed-by.

Steve

>
>
>> On 2019-01-06 13:20:18 -0800, Steve Longerbeam wrote:
>>> There is a block of code in rvin_group_link_notify() that loops through
>>> all entities in the media graph, and prevents enabling a link to a VIN
>>> node if any entity is in use. This prevents enabling a VIN link even if
>>> there is an in-use entity somewhere in the graph that is independent of
>>> the link's pipeline.
>>>
>>> For example, the code will prevent enabling a link from the first
>>> rcar-csi2 receiver to a VIN node even if there is an enabled link
>>> somewhere far upstream on the second independent rcar-csi2 receiver
>>> pipeline.
>>>
>>> If this code is meant to prevent modifying a link if any entity in the
>>> graph is actively involved in streaming (because modifying the CHSEL
>>> register fields can disrupt any/all running streams), then the entities
>>> stream counts should be checked rather than the use counts.
>>>
>>> (There is already such a check in __media_entity_setup_link() that 
>>> verifies
>>> the stream_count of the link's source and sink entities are both zero,
>>> but that is insufficient, since there should be no running streams in
>>> the entire graph).
>>>
>>> Modify the media_device_for_each_entity() loop to check the entity
>>> stream_count instead of the use_count, and elaborate on the comment.
>>> VIN node links can now be enabled even if there are other independent
>>> in-use entities that are not streaming.
>>>
>>> Fixes: c0cc5aef31 ("media: rcar-vin: add link notify for Gen3")
>>>
>>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>>
>>> ---
>>> Changes in v2:
>>> - bring back the media_device_for_each_entity() loop but check the
>>>    stream_count not the use_count.
>>> ---
>>>   drivers/media/platform/rcar-vin/rcar-core.c | 8 ++++++--
>>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c 
>>> b/drivers/media/platform/rcar-vin/rcar-core.c
>>> index f0719ce24b97..6dd6b11c1b2b 100644
>>> --- a/drivers/media/platform/rcar-vin/rcar-core.c
>>> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
>>> @@ -131,9 +131,13 @@ static int rvin_group_link_notify(struct 
>>> media_link *link, u32 flags,
>>> !is_media_entity_v4l2_video_device(link->sink->entity))
>>>           return 0;
>>>   -    /* If any entity is in use don't allow link changes. */
>>> +    /*
>>> +     * Don't allow link changes if any entity in the graph is
>>> +     * streaming, because modifying the CHSEL register fields
>>> +     * can disrupt running streams.
>>> +     */
>>>       media_device_for_each_entity(entity, &group->mdev)
>>> -        if (entity->use_count)
>>> +        if (entity->stream_count)
>>>               return -EBUSY;
>>>         mutex_lock(&group->lock);
>>> -- 
>>> 2.17.1
>>>
>

