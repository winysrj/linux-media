Return-Path: <SRS0=xT8T=PG=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DEEEC43387
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 23:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40F5520873
	for <linux-media@archiver.kernel.org>; Sat, 29 Dec 2018 23:37:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rNP3bp42"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727951AbeL2XhO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sat, 29 Dec 2018 18:37:14 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45201 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbeL2XhO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 29 Dec 2018 18:37:14 -0500
Received: by mail-pg1-f193.google.com with SMTP id y4so11430590pgc.12;
        Sat, 29 Dec 2018 15:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=uqX7Otn3BK/n1fZcX8DjG5XYCzJVyo6d5WSXBFTlq20=;
        b=rNP3bp42G63UJmRGVoMp878VFtuPNk8HeITZfSB+q99nDL6+iMUO+K7kFm9AeUju5W
         pm6yxMZkKPELlh9bPiIWOlPJk+FDnHA2NWbR8q19w+GJqB7qAadTRjQC3r6ep6tXR+eN
         WbmTGEdzcGUtxm0OjcASA9SdfTCBaBNK+goQHqLmxHQgb/trUVXQL4KUHmKolNxQ4ChZ
         x3W27JH9ihfswMbqBBFWyHNinjq+3Jn6WIIrToco8Zctal0TmAbxDXFnL8PWYapUKYBQ
         LuZkxX2ej8H/zYkrpCetE+duimGpMPAuQQ5ZenXGX4HkeTCUwZx6B9lQmr5Sfm6I9Qdf
         dhoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=uqX7Otn3BK/n1fZcX8DjG5XYCzJVyo6d5WSXBFTlq20=;
        b=HGBdBdnNd2q3CXz3rOeKu+ax5a/qYuV06lKN39WfrHyWzZMjmWzwPCeT/jclnHJDf5
         wx8gzz3emalzQWXWcKTFHP3PKG8ppVa9+5NQ2t2uh5UViNRdfN3VmraXy73lgRTgUJWC
         QeS0o54Bi1AbkZgzzjcyOqajBy/MjTISzd145iNaepwoD/fX3m4D8GhkJ00tJuqzrdCQ
         X6dtCRjsLVMWBto+aik60v0lud9N58GSbOQW7wQSSEoJNfSp1swriHZMBoaQMCRurNus
         Q1kXE/e/rNXax9dEWSQa5wtgB93yErTkc3r5NxUsFnuKmKX/IeK52KApRZXTAhKMEsnq
         /S6A==
X-Gm-Message-State: AJcUukeK2r3DBZZaUFMOdedyHevim/VQznH/BNNnhlmelvt4P9p8Ewre
        CVpMYXwl0VnFL0sKDVKhh8Qs5Xkz
X-Google-Smtp-Source: ALg8bN6/tows8fPB6TkSbGPrNMFfhtrj/1X740FivQKhZyO2j24+4PS7GsgtlZosfPyvaMCfFXi7fQ==
X-Received: by 2002:a63:f658:: with SMTP id u24mr3043245pgj.267.1546126632651;
        Sat, 29 Dec 2018 15:37:12 -0800 (PST)
Received: from [192.168.1.102] (c-73-170-90-28.hsd1.ca.comcast.net. [73.170.90.28])
        by smtp.gmail.com with ESMTPSA id x186sm65266917pfb.59.2018.12.29.15.37.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Dec 2018 15:37:11 -0800 (PST)
Subject: Re: [RFC PATCH] media: rcar-vin: Allow independent VIN link
 enablement
To:     =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>
Cc:     linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "open list:MEDIA DRIVERS FOR RENESAS - VIN" 
        <linux-renesas-soc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20181225232725.15935-1-slongerbeam@gmail.com>
 <20181227005125.GK19796@bigcity.dyn.berto.se>
From:   Steve Longerbeam <slongerbeam@gmail.com>
Message-ID: <fb6f58b2-3c19-455a-96dc-8e7314e1c8ce@gmail.com>
Date:   Sat, 29 Dec 2018 15:37:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20181227005125.GK19796@bigcity.dyn.berto.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Niklas,

On 12/26/18 4:51 PM, Niklas Söderlund wrote:
> Hi Steve,
>
> Thanks for your patch.
>
> On 2018-12-25 15:27:25 -0800, Steve Longerbeam wrote:
>> There is a block of code in rvin_group_link_notify() that prevents
>> enabling a link to a VIN node if any entity in the media graph is
>> in use. This prevents enabling a VIN link even if there is an in-use
>> entity somewhere in the graph that is independent of the link's
>> pipeline.
>>
>> For example, the code block will prevent enabling a link from
>> the first rcar-csi2 receiver to a VIN node even if there is an
>> enabled link somewhere far upstream on the second independent
>> rcar-csi2 receiver pipeline.
> Unfortunately this is by design and needed due to the hardware design.
> The different VIN endpoints shares a configuration register which
> controls the routing from the CSI-2 receivers to the VIN (register name
> CHSEL). Modifying the CHSEL register which is what happens when a link
> is enabled/disabled can have side effects on running streams even if
> they are not shown to be dependent in the media graph.

Ok, understood, modifying CHSEL register can adversely affect running 
streams.

>
> There is a CHSEL register in VIN0 which controls the routing from all
> CSI-2 receivers to VIN0-3 and a CHSEL register in VIN4 which controls
> the same for VIN4-7.
>
>> If this code block is meant to prevent modifying a link if the
>> link is actively involved in streaming, there is already such a
>> check in __media_entity_setup_link() that verifies the stream_count
>> of the link's source and sink entities are both zero.
> For the reason above the check in __media_entity_setup_link() is not
> enough :-( This register sharing is my least favorite thing about the
> VIN on Gen3 and forces the driver to become more complex as all VIN
> instances needs to know about each other and interact.
>

Given above I understand why the stream count checks in 
__media_entity_setup_link() are insufficient, because only the requested 
link's source stream count is checked, and not the other CSI-2 receiver 
for example.

But why check the use counts of every entity upstream from the VIN 
sources? Why not check only the VIN source entities stream counts (both 
CSI-2 receivers and/or parallel devices), and ignore entities upstream 
from those?

And why are the use counts checked, it seems it should be the stream 
counts that should be checked.

>> Remove the code block so that VIN node links can be enabled even if
>> there are other independent in-use entities.
> There is room for some improvement in this area disregarding the odd
> hardware design. It *could* be allowed to change a link terminating in
> VIN4-7 even if there is a stream running for one or more in VIN0-3.
>
> I would be interested to test such a patch but to allow any link change
> which is allowed by __media_entity_setup_link() is unfortunately not
> possible, as I understand it. Maybe someone more clever then me can find
> ways to unlock even more then just the split between VIN0-3 and VIn4-7.
>
> In essence the CHSEL register can not be changed if it's involved in a
> running pipeline even if the end result would be that the running
> pipeline would look the same. This is possible as there are multiple
> CHSEL settings where the same source is connected to a specific VIN
> while other members of the "subgroup of VINs" (e.g. VIN0-3) is routed to
> something else for the two CHSEL settings.

Right, so rvin_group_link_notify() determines whether the requested VIN 
link enable will result in a valid set of CSI2->VIN links for the given 
hardware, using the CHSEL bitmask tables. Which is why it seems it is 
the stream counts that should be checked as mentioned above, rather than 
the use counts, because the CHSEL bitmask checks are validating the set 
of enabled links, and the only remaining checks are to verify no streams 
are running on either CSI-2 receiver.

Steve


>> Fixes: c0cc5aef31 ("media: rcar-vin: add link notify for Gen3")
>>
>> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
>> ---
>>   drivers/media/platform/rcar-vin/rcar-core.c | 6 ------
>>   1 file changed, 6 deletions(-)
>>
>> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
>> index f0719ce24b97..b2c9a876969e 100644
>> --- a/drivers/media/platform/rcar-vin/rcar-core.c
>> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
>> @@ -116,7 +116,6 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
>>   						struct rvin_group, mdev);
>>   	unsigned int master_id, channel, mask_new, i;
>>   	unsigned int mask = ~0;
>> -	struct media_entity *entity;
>>   	struct video_device *vdev;
>>   	struct media_pad *csi_pad;
>>   	struct rvin_dev *vin = NULL;
>> @@ -131,11 +130,6 @@ static int rvin_group_link_notify(struct media_link *link, u32 flags,
>>   	    !is_media_entity_v4l2_video_device(link->sink->entity))
>>   		return 0;
>>   
>> -	/* If any entity is in use don't allow link changes. */
>> -	media_device_for_each_entity(entity, &group->mdev)
>> -		if (entity->use_count)
>> -			return -EBUSY;
>> -
>>   	mutex_lock(&group->lock);
>>   
>>   	/* Find the master VIN that controls the routes. */
>> -- 
>> 2.17.1
>>

