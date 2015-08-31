Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:52651 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753032AbbHaNtX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 09:49:23 -0400
Message-ID: <55E45B2B.8010404@xs4all.nl>
Date: Mon, 31 Aug 2015 15:48:27 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v8 49/55] [media] media-device: add support for MEDIA_IOC_G_TOPOLOGY
 ioctl
References: <cover.1440902901.git.mchehab@osg.samsung.com>	<8e914e59660fc35b074b72e39dc1b1200d52617b.1440902901.git.mchehab@osg.samsung.com>	<55E44CC7.2020801@xs4all.nl> <20150831104045.58119a87@recife.lan>
In-Reply-To: <20150831104045.58119a87@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/31/2015 03:40 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 31 Aug 2015 14:47:03 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 08/30/2015 05:07 AM, Mauro Carvalho Chehab wrote:
>>> Add support for the new MEDIA_IOC_G_TOPOLOGY ioctl, according
>>> with the RFC for the MC next generation.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>
>>> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
>>> index 5b2c9f7fcd45..a91e1ec076a6 100644
>>> --- a/drivers/media/media-device.c
>>> +++ b/drivers/media/media-device.c
>>> @@ -232,6 +232,136 @@ static long media_device_setup_link(struct media_device *mdev,
>>>  	return ret;
>>>  }
>>>  
>>> +static long __media_device_get_topology(struct media_device *mdev,
>>> +				      struct media_v2_topology *topo)
>>> +{
>>> +	struct media_entity *entity;
>>> +	struct media_interface *intf;
>>> +	struct media_pad *pad;
>>> +	struct media_link *link;
>>> +	struct media_v2_entity uentity;
>>> +	struct media_v2_interface uintf;
>>> +	struct media_v2_pad upad;
>>> +	struct media_v2_link ulink;
>>> +	int ret = 0, i;
>>> +
>>> +	topo->topology_version = mdev->topology_version;
>>> +
>>> +	/* Get entities and number of entities */
>>> +	i = 0;
>>> +	media_device_for_each_entity(entity, mdev) {
>>> +		i++;
>>> +
>>> +		if (ret || !topo->entities)
>>> +			continue;
>>
>> I would add:
>>
>> 		if (i > topo->num_entities)
>> 			continue;
>>
>> The copy_to_user can succeed, even if i > num_entities depending on how the
>> memory was allocated. So I would always check num_entities and refuse to go
>> beyond it.
> 
> I think that the best is:
> 
> 	if (i > topo->num_entities) {
> 		ret = -ENOSPC;
> 		continue;
> 	}

Agreed.

Regards,

	Hans

