Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:36009 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750863AbeBIMUp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Feb 2018 07:20:45 -0500
Subject: Re: [PATCHv2 11/15] media-device.c: zero reserved field
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180208083655.32248-1-hverkuil@xs4all.nl>
 <20180208083655.32248-12-hverkuil@xs4all.nl>
 <20180209121700.67gibke64bgcewkn@valkosipuli.retiisi.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8203381a-c3f1-d836-4ed1-54874ac7845e@xs4all.nl>
Date: Fri, 9 Feb 2018 13:20:41 +0100
MIME-Version: 1.0
In-Reply-To: <20180209121700.67gibke64bgcewkn@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/09/18 13:17, Sakari Ailus wrote:
> On Thu, Feb 08, 2018 at 09:36:51AM +0100, Hans Verkuil wrote:
>> MEDIA_IOC_SETUP_LINK didn't zero the reserved field of the media_link_desc
>> struct. Do so in media_device_setup_link().
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/media-device.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>> index e79f72b8b858..afbf23a19e16 100644
>> --- a/drivers/media/media-device.c
>> +++ b/drivers/media/media-device.c
>> @@ -218,6 +218,8 @@ static long media_device_setup_link(struct media_device *mdev,
>>  	if (link == NULL)
>>  		return -EINVAL;
>>  
>> +	memset(linkd->reserved, 0, sizeof(linkd->reserved));
>> +
> 
> Doesn't media_device_enum_links() need the same for its reserved field?

enum_links() already zeroes this (actually the whole media_link_desc struct is zeroed).

Regards,

	Hans

> 
>>  	/* Setup the link on both entities. */
>>  	return __media_entity_setup_link(link, linkd->flags);
>>  }
>> -- 
>> 2.15.1
>>
> 
