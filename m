Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:42536 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755223AbbHYNrH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 09:47:07 -0400
Message-ID: <55DC7133.2000808@xs4all.nl>
Date: Tue, 25 Aug 2015 15:44:19 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v7 21/44] [media] dvbdev: add support for interfaces
References: <cover.1440359643.git.mchehab@osg.samsung.com>	<276e4618235b47251f512337560f68657b414e24.1440359643.git.mchehab@osg.samsung.com>	<55DC1E41.7080706@xs4all.nl> <20150825070439.3340611f@recife.lan>
In-Reply-To: <20150825070439.3340611f@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/25/15 12:04, Mauro Carvalho Chehab wrote:
> Em Tue, 25 Aug 2015 09:50:25 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 08/23/2015 10:17 PM, Mauro Carvalho Chehab wrote:
>>> Now that the infrastruct for that is set, add support for
>>> interfaces.
>>>
>>> Please notice that we're missing two links:
>>> 	DVB FE intf    -> tuner
>>> 	DVB demux intf -> dvr
>>>
>>> Those should be added latter, after having the entire graph
>>
>> s/latter/later/
>>
>>> set. With the current infrastructure, those should be added
>>> at dvb_create_media_graph(), but it would also require some
>>> extra core changes, to allow the function to enumerate the
>>> interfaces.
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>
>>> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
>>> index 65f59f2124b4..747372ba4fe1 100644
>>> --- a/drivers/media/dvb-core/dvbdev.c
>>> +++ b/drivers/media/dvb-core/dvbdev.c
>>> @@ -180,14 +180,35 @@ skip:
>>>  	return -ENFILE;
>>>  }
>>>  
>>> -static void dvb_register_media_device(struct dvb_device *dvbdev,
>>> -				      int type, int minor)
>>> +static void dvb_create_media_entity(struct dvb_device *dvbdev,
>>> +				       int type, int minor)
>>>  {
>>>  #if defined(CONFIG_MEDIA_CONTROLLER_DVB)
>>>  	int ret = 0, npads;
>>>  
>>> -	if (!dvbdev->adapter->mdev)
>>> +	switch (type) {
>>> +	case DVB_DEVICE_FRONTEND:
>>> +		npads = 2;
>>> +		break;
>>> +	case DVB_DEVICE_DEMUX:
>>> +		npads = 2;
>>> +		break;
>>> +	case DVB_DEVICE_CA:
>>> +		npads = 2;
>>> +		break;
>>> +	case DVB_DEVICE_NET:
>>> +		/*
>>> +		 * We should be creating entities for the MPE/ULE
>>> +		 * decapsulation hardware (or software implementation).
>>> +		 *
>>> +		 * However, as the number of for the MPE/ULE may not be fixed,
>>> +		 * and we don't have yet dynamic support for PADs at the
>>> +		 * Media Controller.
>>
>> However what? You probably want to add something like:
>>
>> However, ... at the Media Controller, we don't make this entity yet.
> 
> What about this:
> 		 * However, the number of for the MPE/ULE decaps may not be
> 		 * fixed. As we don't have yet dynamic support for PADs at
> 		 * the Media Controller, let's not create those yet.

I'd be explicit:

s/those/decap entities/

Other than that this is OK.

Regards,

	Hans
