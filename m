Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33106 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbbHaOjn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 10:39:43 -0400
Subject: Re: [PATCH v8 16/55] [media] media: Don't accept early-created links
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <cover.1440902901.git.mchehab@osg.samsung.com>
 <31329e1be748d26ce5a90fe050ba15b8d1e5aff1.1440902901.git.mchehab@osg.samsung.com>
 <55E42CB8.6010706@xs4all.nl> <20150831075444.5bc98366@recife.lan>
 <55E43407.6030400@xs4all.nl>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <55E46726.7070003@osg.samsung.com>
Date: Mon, 31 Aug 2015 16:39:34 +0200
MIME-Version: 1.0
In-Reply-To: <55E43407.6030400@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On 08/31/2015 01:01 PM, Hans Verkuil wrote:
> On 08/31/2015 12:54 PM, Mauro Carvalho Chehab wrote:
>> Em Mon, 31 Aug 2015 12:30:16 +0200
>> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
>>
>>> On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
>>>> Links are graph objects that represent the links of two already
>>>> existing objects in the graph.
>>>>
>>>> While with the current implementation, it is possible to create
>>>> the links earlier, It doesn't make any sense to allow linking
>>>> two objects when they are not both created.
>>>>
>>>> So, remove the code that would be handling those early-created
>>>> links and add a BUG_ON() to ensure that.
>>>>
>>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>
>>> The code is OK, so:
>>>
>>> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> But shouldn't this go *after* the omap3isp fixes? After this patch the
>>> omap3isp will call BUG_ON, and that's not what you want.
>>
>> Yes. I'll change the order on my git tree.
>>
>>> It is also not clear if the omap3isp driver is the only one that has this
>>> 'create link before objects' problem. I would expect that the omap4 staging
>>> driver has the same issue and possibly others as well.
>>>
>>> Did someone look at that?
>>
>> I guess other drivers are doing the same.
>>
>> Javier's planning to review the other platform drivers in order to add the 
>> needed fixes there too, and to do more tests with some other platform
>> drivers that he has hardware for testing.
> 
> OK, good. Just wanted to know that.
>

Yes, the omap4iss driver in staging has a similar logic and thus the
same issues than the omap3isp driver. I'll write patches for this as
well but I don't have an OMAP4 board here so testing is appreciated.

As Mauro mentioned, I was reviewing the others driver that are creating
pad links and found more that are creating links before registering:

drivers/media/usb/uvc
drivers/media/platform/vsp1
drivers/media/i2c/smiapp

I'll try to take care of these too.

The other drivers that are creating pad links are doing the right thing
AFAICT by registering the entity with the media device before.

> Perhaps it is a good idea to add a TODO list to the cover letter. This would
> be one item on that list.
>

A TODO list is a good idea indeed.
 
> Regards,
> 
> 	Hans
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
