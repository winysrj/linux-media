Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40050 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368AbbDHLdc (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 8 Apr 2015 07:33:32 -0400
Message-ID: <55251209.1030004@linux.intel.com>
Date: Wed, 08 Apr 2015 14:33:29 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 1/1] media: Correctly notify about the failed
 pipeline validation
References: <1423748591-19402-1-git-send-email-sakari.ailus@linux.intel.com> <20150408082342.1ff93eef@recife.lan>
In-Reply-To: <20150408082342.1ff93eef@recife.lan>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Mauro Carvalho Chehab wrote:
> Em Thu, 12 Feb 2015 15:43:11 +0200
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
>> On the place of the source entity name, the sink entity name was printed.
>>
>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>> ---
>>  drivers/media/media-entity.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/media/media-entity.c b/drivers/media/media-entity.c
>> index defe4ac..d894481 100644
>> --- a/drivers/media/media-entity.c
>> +++ b/drivers/media/media-entity.c
>> @@ -283,9 +283,9 @@ __must_check int media_entity_pipeline_start(struct media_entity *entity,
>>  			if (ret < 0 && ret != -ENOIOCTLCMD) {
>>  				dev_dbg(entity->parent->dev,
>>  					"link validation failed for \"%s\":%u -> \"%s\":%u, error %d\n",
>> -					entity->name, link->source->index,
>> -					link->sink->entity->name,
>> -					link->sink->index, ret);
>> +					link->source->entity->name,
>> +					link->source->index,
>> +					entity->name, link->sink->index, ret);
> 
> This should likely be reviewed by Laurent, but the above code
> seems weird to me...
> 
> 1) Why should it print the link source, instead of the sink?
> I suspect that the code here should take into account the chosen
> pad:
> 
>                         struct media_pad *pad = link->sink->entity == entity
>                                                 ? link->sink : link->source;

Link validation is only performed on sink pads. This is checked a few
lines above this, so the pad here is always the sink pad. Instead of
link->sink->index I could have used pad->index but the pad and thus the
integer value is the same.

> 
> 2) Assuming that your patch is right, why are you printing the
> link->sink->index, instead of link->source->index?

The source pad index is prited as well. The end result is, after the patch:

	source entity:source pad -> sink entity:sink pad

Before it was:

	sink entity:source pad -> sink entity:sink pad

Which indeed was wrong.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
