Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:57456 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab3FITM1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Jun 2013 15:12:27 -0400
Received: by mail-bk0-f48.google.com with SMTP id jf17so2931917bkc.7
        for <linux-media@vger.kernel.org>; Sun, 09 Jun 2013 12:12:26 -0700 (PDT)
Message-ID: <51B4D396.3010808@gmail.com>
Date: Sun, 09 Jun 2013 21:12:22 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hj210.choi@samsung.com, arun.kk@samsung.com,
	shaik.ameer@samsung.com, kyungmin.park@samsung.com
Subject: Re: [REVIEW PATCH v2 10/11] media: Change media device link_notify
 behaviour
References: <1370011047-11488-1-git-send-email-s.nawrocki@samsung.com> <1370011047-11488-11-git-send-email-s.nawrocki@samsung.com> <20130606001114.GA3103@valkosipuli.retiisi.org.uk>
In-Reply-To: <20130606001114.GA3103@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/06/2013 02:11 AM, Sakari Ailus wrote:
> Hi Sylwester,
>
> Thanks for the patch!

And thanks for taking time to review!

> On Fri, May 31, 2013 at 04:37:26PM +0200, Sylwester Nawrocki wrote:
> ...
>> @@ -547,25 +547,17 @@ int __media_entity_setup_link(struct media_link *link, u32 flags)
>>
>>   	mdev = source->parent;
>>
>> -	if ((flags&  MEDIA_LNK_FL_ENABLED)&&  mdev->link_notify) {
>> -		ret = mdev->link_notify(link->source, link->sink,
>> -					MEDIA_LNK_FL_ENABLED);
>> +	if (mdev->link_notify) {
>> +		ret = mdev->link_notify(link, flags,
>> +					MEDIA_DEV_NOTIFY_PRE_LINK_CH);
>>   		if (ret<  0)
>>   			return ret;
>>   	}
>>
>>   	ret = __media_entity_setup_link_notify(link, flags);
>> -	if (ret<  0)
>> -		goto err;
>>
>> -	if (!(flags&  MEDIA_LNK_FL_ENABLED)&&  mdev->link_notify)
>> -		mdev->link_notify(link->source, link->sink, 0);
>> -
>> -	return 0;
>> -
>> -err:
>> -	if ((flags&  MEDIA_LNK_FL_ENABLED)&&  mdev->link_notify)
>> -		mdev->link_notify(link->source, link->sink, 0);
>> +	if (mdev->link_notify)
>> +		mdev->link_notify(link, flags, MEDIA_DEV_NOTIFY_POST_LINK_CH);
>
> This changes the behaviour of link_notify() so that the flags will be the
> same independently of whether there was an error. I wonder if that's
> intentional.

Yes, that's intentional. However I failed to update the omap3isp driver
link_notify handler properly to handle the link set up error case. I'll
correct that in next iteration.

> I'd think that in the case of error the flags wouldn't change from what they
> were, i.e. the flags argument would be "link->flags" instead of "flags".

The idea was to allow the link_notify handler to determine when link state
change succeeded, and when not. So the 'flags' link_notify() argument
indicates what was the intended state, while the actual state can be
determined by checking link->flags.

I considered not introducing the 'notification' argument and just comparing
'flags' and 'link->flags', but those look same before and after a call to
__media_entity_setup_link_notify() in error case.

>>   	return ret;
>>   }
>
> ...
>
>> diff --git a/include/media/media-device.h b/include/media/media-device.h
>> index eaade98..353c4ee 100644
>> --- a/include/media/media-device.h
>> +++ b/include/media/media-device.h
>> @@ -45,6 +45,7 @@ struct device;
>>    * @entities:	List of registered entities
>>    * @lock:	Entities list lock
>>    * @graph_mutex: Entities graph operation lock
>> + * @link_notify: Link state change notification callback
>>    *
>>    * This structure represents an abstract high-level media device. It allows easy
>>    * access to entities and provides basic media device-level support. The
>> @@ -75,10 +76,14 @@ struct media_device {
>>   	/* Serializes graph operations. */
>>   	struct mutex graph_mutex;
>>
>> -	int (*link_notify)(struct media_pad *source,
>> -			   struct media_pad *sink, u32 flags);
>> +	int (*link_notify)(struct media_link *link, unsigned int flags,
>> +			   unsigned int notification);
>
> media_link->flags is unsigned long. The patch doesn't break anything, but it
> switches from u32/unsigned long to unsigned int/unsigned long for the field.
>
> How about making media_link->flags unsigned int (or unsigned long) at the
> same time, or not changing it? This could be fixed in a separate patch as
> well (which I'm not necessarily expect from you now). There are probably a
> number of places that would need to be changed.

Hmm, OK, I'll revert this 'flags' type change. I guess it's best to use
'unsigned int' all over, but I'll leave it out for a separate patch, for
someone to write. :)


Thanks,
Sylwester
