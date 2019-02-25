Return-Path: <SRS0=o7tn=RA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62315C4360F
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 11:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CEA0213A2
	for <linux-media@archiver.kernel.org>; Mon, 25 Feb 2019 11:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfBYLZu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Feb 2019 06:25:50 -0500
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:58215 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726701AbfBYLZt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Feb 2019 06:25:49 -0500
Received: from [IPv6:2001:983:e9a7:1:187c:1a74:db21:99] ([IPv6:2001:983:e9a7:1:187c:1a74:db21:99])
        by smtp-cloud8.xs4all.net with ESMTPA
        id yEOIgL5RL4HFnyEOJgK7H8; Mon, 25 Feb 2019 12:25:47 +0100
Subject: Re: [PATCH 4/7] media-entity: set ent_enum->bmap to NULL after
 freeing it
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
References: <20190221142148.3412-1-hverkuil-cisco@xs4all.nl>
 <20190221142148.3412-5-hverkuil-cisco@xs4all.nl>
 <20190222111739.GM3522@pendragon.ideasonboard.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <8723b11e-6e79-7c11-c0c3-93cde4ac02ce@xs4all.nl>
Date:   Mon, 25 Feb 2019 12:25:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <20190222111739.GM3522@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfMIZdIfwzekPCi5bwuGrJwaEC6l3l5eFQJUugKbIGPqRu7MVPCDzfSfNJrTwbdabEsnzlMIMbIHUW0Hs4SU1oo2r745cIKlxy1PumUG/sBvykoZuFyh6
 PlpxUA6G8fuLRq8Tc9Gxl0EfoMhMH+Je/byip9FvV0maS6Pq0QyU9kFeIqwhoy4HCTDqIq2Fbh6wNLFk+LChTj8G9hA/hZXBPCGq3dYzyAiZtglZ4Rzo5oQ5
 xiqXe9TfD9tIhqIn4U5KS2UUPAe8dpto2qKUrS6rCHVb5KKxzIuwJ41i/Pcz86vgsAnBLUPziMntcU6jY6jG+1E9aKZf/4iDAp+alD0Q4x5F3lIVZeOx6but
 cZLpeilg
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 2/22/19 12:17 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Thu, Feb 21, 2019 at 03:21:45PM +0100, Hans Verkuil wrote:
>> Ensure that this pointer is set to NULL after it is freed.
>> The vimc driver has a static media_entity and after
>> unbinding and rebinding the vimc device the media code will
>> try to free this pointer again since it wasn't set to NULL.
> 
> As this fixes a problem in vimc, should you add a Fixes: tag ? To avoid

The Fixes tag is really for cases where a patch introduces a bug, whereas
this was always wrong.

> other similar problems, I think the vimc driver should allocate the
> media_device and other device data dynamically at probe time. Bundling
> them with the platform_device in struct vimc_device isn't a good idea.

It's not actually wrong as such, just unusual. Which actually makes it a
good test case.

Anyway, the upcoming "vimc: add configfs API to configure the topology" patch
makes this dynamic. Waiting for a v2 of that patch.

Regards,

	Hans

> 
>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>> ---
>>  drivers/media/media-entity.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>> index 0b1cb3559140..7b2a2cc95530 100644
>> --- a/drivers/media/media-entity.c
>> +++ b/drivers/media/media-entity.c
>> @@ -88,6 +88,7 @@ EXPORT_SYMBOL_GPL(__media_entity_enum_init);
>>  void media_entity_enum_cleanup(struct media_entity_enum *ent_enum)
>>  {
>>  	kfree(ent_enum->bmap);
>> +	ent_enum->bmap = NULL;
>>  }
>>  EXPORT_SYMBOL_GPL(media_entity_enum_cleanup);
>>  
> 

