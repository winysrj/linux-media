Return-Path: <SRS0=yxRx=RK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5ECFC43381
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 09:23:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 770CA20835
	for <linux-media@archiver.kernel.org>; Thu,  7 Mar 2019 09:23:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfCGJXI (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 7 Mar 2019 04:23:08 -0500
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:46993 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725747AbfCGJXI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Mar 2019 04:23:08 -0500
Received: from [192.168.2.10] ([212.251.195.8])
        by smtp-cloud7.xs4all.net with ESMTPA
        id 1pF1h7uDsLMwI1pF4hxRP2; Thu, 07 Mar 2019 10:23:06 +0100
Subject: Re: [PATCHv2 4/9] media-entity: set ent_enum->bmap to NULL after
 freeing it
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org,
        Helen Koike <helen.koike@collabora.com>
References: <20190305095847.21428-1-hverkuil-cisco@xs4all.nl>
 <20190305095847.21428-5-hverkuil-cisco@xs4all.nl>
 <20190305193913.GF14928@pendragon.ideasonboard.com>
From:   Hans Verkuil <hverkuil-cisco@xs4all.nl>
Message-ID: <8ea050d7-8827-9432-9737-3a704ea8cfe4@xs4all.nl>
Date:   Thu, 7 Mar 2019 10:23:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190305193913.GF14928@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfLLnPb69C9wxvWkvrTuPLrR0car1320cS+d2SbnE2Ucnv90ao1g/2Hxnpx9MInRab4LDulSgsKyD8tIphQaR9/w22O7Qfq85yTSiiXcJLJIB531Ac01I
 Kaw7ewITtwGc4YSOOnVmEl3WoerGF1zhOPx1kLUSAw6OYxtZC4axBBQ4DJeJnDmge9igLjuoRe0LnLwpqYRoCjTn1h7z2QXC5Pi/hvmb9DkCbwokxqggU0rQ
 NafcBPJfkRWh/I368oGCTJDS9kIkkwK5P/a1gJZsTrc=
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/5/19 8:39 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Tue, Mar 05, 2019 at 10:58:42AM +0100, hverkuil-cisco@xs4all.nl wrote:
>> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>>
>> Ensure that this pointer is set to NULL after it is freed.
>> The vimc driver has a static media_entity and after
>> unbinding and rebinding the vimc device the media code will
>> try to free this pointer again since it wasn't set to NULL.
> 
> I still think the problem lies in the vimc driver. Reusing static
> structures is really asking for trouble. I'm however not opposed to
> merging this patch, as you mentioned the problem will be fixed in vimc
> too. I still wonder, though, if merging this couldn't make it easier for
> drivers to do the wrong thing.

I'm keeping this patch :-)

I don't think that what vimc is doing is wrong in principle, just very unusual.

Also I think it makes the mc framework more robust by properly zeroing this
pointer.

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

