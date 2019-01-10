Return-Path: <SRS0=KIs1=PS=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC410C43387
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 01:19:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD41E2173B
	for <linux-media@archiver.kernel.org>; Thu, 10 Jan 2019 01:19:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TT9QFKuA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfAJBTo (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 9 Jan 2019 20:19:44 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40959 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbfAJBTn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2019 20:19:43 -0500
Received: by mail-wm1-f65.google.com with SMTP id f188so10268501wmf.5;
        Wed, 09 Jan 2019 17:19:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=+9XA8DO5bM1mA8cUszOvO3NZSoVTJ4TYXNbfwi25Zq0=;
        b=TT9QFKuAygHeTEZ+FjetCFqnrrtIK7FCUdzf8e3yTL9Fw3L3ndhS8CHeejckFbll8M
         eujPgmD63nWhdoHdcd+u/xKVcY8zIhLHCVryHOE3pWK1meISyNKN+MzJVtJpgnRvnhIq
         E7af6ausa03PEeV69qpr0EWYgnhMG1uOd5F1hbp62rsbaMeqJhDBjL37Yc3OhDWtrsCi
         M6nE7tQMQp89jQXXHhLrpWrfbtz3fu65+Mnu6PF2qVluAGDbMaxQ9gIs7FgqQuc4oM9e
         K0r24CJ/fwC3xw+sugEDI5UERWCyVu/CL8gAnXdk9lUWV+628Ag3tSuT6NR2W+sx3XXv
         wpzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+9XA8DO5bM1mA8cUszOvO3NZSoVTJ4TYXNbfwi25Zq0=;
        b=IqBOh/9XyIDa3N9eynZXv71KV84RlPt9wgDoBBJ7Kqg/y1+UzSrIRr7LL38HgkFwj+
         Kq2ND25S9O2bvOFpuM+Dj/PP7fgDuV3b/cFdIS5g4cNZ2xOrEm15GrlnokPjwimiA8K/
         6F+TLCYCjztCHXBOkbnPxD46j93Ok/RJOK82iC1elm4dv7SN9jj8r3/eMD0wD7zopdDP
         pDR3g0YutxOkMKBrLMRieVtIrf73twogNj639F+fc5hdwVUnKWQlVUtSvNgddEzGOjAW
         0+Za5aDNzXVLrZxzXHbIXBm+Yzmp2knB51bVy37VPy8stVJDGPEAW7km/qzVqJOU0A4x
         XEQA==
X-Gm-Message-State: AJcUukfr71wugbG5LBSIdpv9QstE2KCWxk908YLiz41I/PpSD2Rmp3Zu
        bD+Ssm545mop05sYcxzlkSg+anq/
X-Google-Smtp-Source: ALg8bN7jTUyVc4a0vrD8ReJZpYLcaGk+v691pbK33S1brVesn2+mryn0keJxmFmIAEP89THKTYbSKQ==
X-Received: by 2002:a1c:544f:: with SMTP id p15mr7714407wmi.37.1547083181164;
        Wed, 09 Jan 2019 17:19:41 -0800 (PST)
Received: from [172.30.90.141] (sjewanfw1-nat.mentorg.com. [139.181.7.34])
        by smtp.gmail.com with ESMTPSA id n127sm17050701wmd.20.2019.01.09.17.19.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jan 2019 17:19:40 -0800 (PST)
Subject: Re: [RFC PATCH v2] media: rcar-vin: Allow independent VIN link
 enablement
To:     =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc:     linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "open list:MEDIA DRIVERS FOR RENESAS - VIN" 
        <linux-renesas-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20190106212018.16519-1-slongerbeam@gmail.com>
 <20190109224039.GD24252@bigcity.dyn.berto.se>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <da87789d-73e8-663c-a25f-d75e4361ade3@gmail.com>
Date:   Wed, 9 Jan 2019 17:19:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190109224039.GD24252@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org



On 1/9/19 2:40 PM, Niklas Söderlund wrote:
> Hi Steve,
>
> Thanks for your patch, I think it looks good.

Thanks for the Ack! I'm not real familiar with the RFC patch process. 
Should this be submitted again with RFC stripped from the subject line?

Steve

> On 2019-01-06 13:20:18 -0800, Steve Longerbeam wrote:
>> There is a block of code in rvin_group_link_notify() that loops through
>> all entities in the media graph, and prevents enabling a link to a VIN
>> node if any entity is in use. This prevents enabling a VIN link even if
>> there is an in-use entity somewhere in the graph that is independent of
>> the link's pipeline.
>>
>> For example, the code will prevent enabling a link from the first
>> rcar-csi2 receiver to a VIN node even if there is an enabled link
>> somewhere far upstream on the second independent rcar-csi2 receiver
>> pipeline.
>>
>> If this code is meant to prevent modifying a link if any entity in the
>> graph is actively involved in streaming (because modifying the CHSEL
>> register fields can disrupt any/all running streams), then the entities
>> stream counts should be checked rather than the use counts.
>>
>> (There is already such a check in __media_entity_setup_link() that verifies
>> the stream_count of the link's source and sink entities are both zero,
>> but that is insufficient, since there should be no running streams in
>> the entire graph).
>>
>> Modify the media_device_for_each_entity() loop to check the entity
>> stream_count instead of the use_count, and elaborate on the comment.
>> VIN node links can now be enabled even if there are other independent
>> in-use entities that are not streaming.
>>
>> Fixes: c0cc5aef31 ("media: rcar-vin: add link notify for Gen3")
>>
>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
>
>> ---
>> Changes in v2:
>> - bring back the media_device_for_each_entity() loop but check the
>>    stream_count not the use_count.
>> ---
>>   drivers/media/platform/rcar-vin/rcar-core.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
>> index f0719ce24b97..6dd6b11c1b2b 100644
>> --- a/drivers/media/platform/rcar-vin/rcar-core.c
>> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
>> @@ -131,9 +131,13 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
>>   	    !is_media_entity_v4l2_video_device(link->sink->entity))
>>   		return 0;
>>   
>> -	/* If any entity is in use don't allow link changes. */
>> +	/*
>> +	 * Don't allow link changes if any entity in the graph is
>> +	 * streaming, because modifying the CHSEL register fields
>> +	 * can disrupt running streams.
>> +	 */
>>   	media_device_for_each_entity(entity, &group->mdev)
>> -		if (entity->use_count)
>> +		if (entity->stream_count)
>>   			return -EBUSY;
>>   
>>   	mutex_lock(&group->lock);
>> -- 
>> 2.17.1
>>

