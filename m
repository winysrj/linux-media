Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:51600 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751210AbeDPT1G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 15:27:06 -0400
Subject: Re: [PATCHv2 4/9] media: add function field to struct
 media_entity_desc
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>
References: <20180416132121.46205-1-hverkuil@xs4all.nl>
 <20180416132121.46205-5-hverkuil@xs4all.nl>
 <20180416150112.5e813d33@vento.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e0fc447d-25aa-744f-4630-894eff900023@xs4all.nl>
Date: Mon, 16 Apr 2018 21:27:01 +0200
MIME-Version: 1.0
In-Reply-To: <20180416150112.5e813d33@vento.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/16/2018 08:01 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 16 Apr 2018 15:21:16 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hansverk@cisco.com>
>>
>> This adds support for 'proper' functions to the existing API.
>> This information was before only available through the new v2
>> API, with this change it's available to both.
>>
>> Yes, the plan is to allow entities to expose multiple functions for
>> multi-function devices, but we do not support it anywhere so this
>> is still vaporware.
> 
> I'm not convinced about that. I would, instead, just keep it as-is
> and be sure that applications stop use the legacy calls.

You can't. First of all, since the new API does not provide the pad index
(fixed in patch 6/9) it is impossible to use the new API with any driver
that supports SETUP_LINK. So any such driver that uses any of the newer
subdevs with a function that is mapped to MEDIA_ENT_T_DEVNODE_UNKNOWN
is currently not reporting that correctly. A good example is the
imx driver. But also others if they are combined with such newer subdevs.

There is nothing wrong with the old API, except for not reporting the
proper function value in field 'type' due to historical concerns.

There is NO WAY we can suddenly prohibit applications from using the old
API since the new API was never usable. And besides that, we have no method
of knowing who uses the old API since such applications are likely custom
for specific hardware.

All that is really missing in the 'old' API (I hate the terms 'old' and
'new', they are misleading) is a proper 'function' field. Let's just add it
and make it consistent with the documentation about entity functions.

> 
>>
>> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
>> ---
>>  drivers/media/media-device.c | 1 +
>>  include/uapi/linux/media.h   | 7 ++++++-
>>  2 files changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>> index 7c3ab37c258a..dca1e5a3e0f9 100644
>> --- a/drivers/media/media-device.c
>> +++ b/drivers/media/media-device.c
>> @@ -115,6 +115,7 @@ static long media_device_enum_entities(struct media_device *mdev,
>>  	if (ent->name)
>>  		strlcpy(entd->name, ent->name, sizeof(entd->name));
>>  	entd->type = ent->function;
>> +	entd->function = ent->function;
>>  	entd->revision = 0;		/* Unused */
> 
> I got confused here, until I went to the code and noticed that
> entd->type is actually touched after this.
> 
> If we're willing to do that, you should add a comment there explaining
> why we need to pass both type and function to userspace.

True.

Regards,

	Hans

> 
>>  	entd->flags = ent->flags;
>>  	entd->group_id = 0;		/* Unused */
>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>> index 86c7dcc9cba3..ac08acffdb65 100644
>> --- a/include/uapi/linux/media.h
>> +++ b/include/uapi/linux/media.h
>> @@ -146,6 +146,10 @@ struct media_device_info {
>>  /* OR with the entity id value to find the next entity */
>>  #define MEDIA_ENT_ID_FLAG_NEXT			(1 << 31)
>>  
>> +/* Appeared in 4.18.0 */
>> +#define MEDIA_ENTITY_DESC_HAS_FUNCTION(media_version) \
>> +	((media_version) >= 0x00041200)
>> +
>>  struct media_entity_desc {
>>  	__u32 id;
>>  	char name[32];
>> @@ -155,8 +159,9 @@ struct media_entity_desc {
>>  	__u32 group_id;
>>  	__u16 pads;
>>  	__u16 links;
>> +	__u32 function;
>>  
>> -	__u32 reserved[4];
>> +	__u32 reserved[3];
>>  
>>  	union {
>>  		/* Node specifications */
> 
> 
> 
> Thanks,
> Mauro
> 
