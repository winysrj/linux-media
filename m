Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:49715 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726388AbeGKLtw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 07:49:52 -0400
Subject: Re: [PATCHv5 01/12] media: add 'index' to struct media_v2_pad
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hansverk@cisco.com>
References: <20180629114331.7617-1-hverkuil@xs4all.nl>
 <4833769.fujQdFkPkF@avalon> <360b9ee9-8e29-1c34-0887-182f5c91be38@xs4all.nl>
 <2727885.HQxqLs6WZl@avalon>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bd92bfe7-cc0c-f40a-479c-b2cfaef88473@xs4all.nl>
Date: Wed, 11 Jul 2018 13:45:52 +0200
MIME-Version: 1.0
In-Reply-To: <2727885.HQxqLs6WZl@avalon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/07/18 13:33, Laurent Pinchart wrote:
> Hi Hans,
> 
> On Monday, 9 July 2018 16:40:51 EEST Hans Verkuil wrote:
>> On 09/07/18 14:55, Laurent Pinchart wrote:
>>> On Friday, 29 June 2018 14:43:20 EEST Hans Verkuil wrote:
>>>> From: Hans Verkuil <hansverk@cisco.com>
>>>>
>>>> The v2 pad structure never exposed the pad index, which made it
>>>> impossible
>>>> to call the MEDIA_IOC_SETUP_LINK ioctl, which needs that information.
>>>>
>>>> It is really trivial to just expose this information, so implement this.
>>>>
>>>> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
>>>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>>> ---
>>>>
>>>>  drivers/media/media-device.c |  1 +
>>>>  include/uapi/linux/media.h   | 12 +++++++++++-
>>>>  2 files changed, 12 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>>>> index 47bb2254fbfd..047d38372a27 100644
>>>> --- a/drivers/media/media-device.c
>>>> +++ b/drivers/media/media-device.c
>>>> @@ -331,6 +331,7 @@ static long media_device_get_topology(struct
>>>> media_device *mdev, void *arg)
>>>>  		kpad.id = pad->graph_obj.id;
>>>>  		kpad.entity_id = pad->entity->graph_obj.id;
>>>>  		kpad.flags = pad->flags;
>>>> +		kpad.index = pad->index;
>>>>
>>>>  		if (copy_to_user(upad, &kpad, sizeof(kpad)))
>>>>  			ret = -EFAULT;
>>>> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
>>>> index 86c7dcc9cba3..f6338bd57929 100644
>>>> --- a/include/uapi/linux/media.h
>>>> +++ b/include/uapi/linux/media.h
>>>> @@ -305,11 +305,21 @@ struct media_v2_interface {
>>>>  	};
>>>>  } __attribute__ ((packed));
>>>>
>>>> +/*
>>>> + * Appeared in 4.19.0.
>>>> + *
>>>> + * The media_version argument comes from the media_version field in
>>>> + * struct media_device_info.
>>>> + */
>>>> +#define MEDIA_V2_PAD_HAS_INDEX(media_version) \
>>>> +	((media_version) >= ((4 << 16) | (19 << 8) | 0))
>>>
>>> I agree that we need tn index field, but I don't think we need to care
>>> about backward compatibility. The lack of an index field makes it clear
>>> that the API has never been properly used, as it was impossible to do so.
>>
>> We do need to care: there is no reason why a v4l2 application can't be used
>> on an older kernel. Most v4l2 applications copy the V4L2 headers to the
>> application (in fact, that's what v4l-utils does) and so they need to know
>> if a field is actually filled in by whatever kernel is used. In most cases
>> they can just check against 0, but that happens to be a valid index :-(
>>
>> So this is really needed. Same for the flags field.
> 
> You're right. I was thinking we could detect this on the kernel side by 
> checking the ioctl argument size if we added the index field to the 
> media_v2_pad structure instead of replacing one of the reserved fields, but 
> media_v2_pad is not passed directly to the G_TOPOLOGY ioctl, so that won't 
> help.
> 
> I wonder whether we shouldn't just define
> 
> #define MEDIA_V2_IS_BROKEN(media_version) \
> 	((media_version) < ((4 << 16) | (19 << 8) | 0))
> 
> as in practice applications should really avoid the G_TOPOLOGY ioctl without 
> this patch series. Having multiple version-based macros to check for features 
> won't be very helpful, and could be counter-productive as applications might 
> incorrectly decide to still use the API to retrieve some information when they 
> should really avoid it.

G_TOPOLOGY is still useful if all you want is to retrieve the topology.
Only if you need to modify routing is it indeed useless.

I prefer to keep the current defines: it is clear what they do whereas
'IS_BROKEN' just makes people wonder why it is broken.

> And, while at it, should we use KERNEL_VERSION() instead of hardcoding it ?
> 
> #define MEDIA_V2_IS_BROKEN(media_version) \
> 	((media_version) < KERNEL_VERSION(4, 19, 0))

It's not clear if you are actually allowed to use KERNEL_VERSION in userspace
headers. The only header in the kernel where this is used is actually media.h:

#define MEDIA_API_VERSION                    KERNEL_VERSION(0, 1, 0)

And that define is a legacy define that probably nobody uses.

There is no other header that does this. So I prefer not to depend on this,
and in fact I think the MEDIA_API_VERSION should also be rewritten so it
doesn't depend on KERNEL_VERSION anymore.

Regards,

	Hans

> 
> Still thinking out loud, the fact that we can't change the size of the 
> structures pointed to by media_v2_topology bothers me. We could add a version 
> field to media_v2_topology that would be set by applications to tell the 
> kernel which version of the API they expect. On the other hand, maybe we'll 
> just do a media_v3_topology when the need arises...
> 
> (And I still really don't like the use of media_v2_link to describe the 
> association between an entity and an interface, I think a media_v2_association 
> structure would have been cleaner :-().
> 
>>>>  struct media_v2_pad {
>>>>  	__u32 id;
>>>>  	__u32 entity_id;
>>>>  	__u32 flags;
>>>> -	__u32 reserved[5];
>>>> +	__u32 index;
>>>> +	__u32 reserved[4];
>>>>  } __attribute__ ((packed));
>>>>  
>>>>  struct media_v2_link {
> 
