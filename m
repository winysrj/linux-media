Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:47674 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286AbbHYN44 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Aug 2015 09:56:56 -0400
Message-ID: <55DC7381.9090600@xs4all.nl>
Date: Tue, 25 Aug 2015 15:54:09 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Hyun Kwon <hyun.kwon@xilinx.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?windows-1252?Q?S=F6ren_Brink?= =?windows-1252?Q?mann?=
	<soren.brinkmann@xilinx.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Markus Elfring <elfring@users.sourceforge.net>,
	Lars-Peter Clausen <lars@metafoo.de>,
	linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 25/44] [media] replace all occurrences of MEDIA_ENT_T_DEVNODE_V4L
References: <cover.1440359643.git.mchehab@osg.samsung.com>	<23e2f9440a259e1162e15dba7e6261dbc4c521c6.1440359643.git.mchehab@osg.samsung.com>	<55DC340C.8030503@xs4all.nl> <20150825083236.37659d22@recife.lan>
In-Reply-To: <20150825083236.37659d22@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/25/15 13:32, Mauro Carvalho Chehab wrote:
> Em Tue, 25 Aug 2015 11:23:24 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> On 08/23/15 22:17, Mauro Carvalho Chehab wrote:
>>> Now that interfaces and entities are distinct, it makes no sense
>>> of keeping something named as MEDIA_ENT_T_DEVNODE.
>>>
>>> This change was done with this script:
>>>
>>> 	for i in $(git grep -l MEDIA_ENT_T|grep -v uapi/linux/media.h); do sed s,MEDIA_ENT_T_DEVNODE_V4L,MEDIA_ENT_T_V4L2_VIDEO, <$i >a && mv a $i; done
>>>
>>> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>>>
>>> diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
>>> index 5872f8bbf774..910243d4edb8 100644
>>> --- a/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
>>> +++ b/Documentation/DocBook/media/v4l/media-ioc-enum-entities.xml
>>> @@ -183,7 +183,7 @@
>>>  	    <entry>Unknown device node</entry>
>>>  	  </row>
>>>  	  <row>
>>> -	    <entry><constant>MEDIA_ENT_T_DEVNODE_V4L</constant></entry>
>>> +	    <entry><constant>MEDIA_ENT_T_V4L2_VIDEO</constant></entry>
>>>  	    <entry>V4L video, radio or vbi device node</entry>
>>>  	  </row>
>>
>> OK, this makes no sense and that ties in with my confusion of the previous patch.
>>
>> These are not device nodes, in the new scheme these are DMA entities (I know,
>> naming TDB) that have an associated interface.
> 
> Yes. Well, DMA is a bad name. It won't cover USB devices, where the DMA
> engine is outside the V4L2 drivers, nor it would work for RDS radio data,
> with may not need any DMA at all on no-USB devices, as the data flows via
> the I2C bus.
> 
>> I think a much better approach would be to add entity type(s) for such DMA
>> engines in patch 24, then use that new name in existing drivers and split
>> up the existing DEVNODE_V4L media_entity into a media_entity and a
>> media_intf_devnode:
> 
> Sorry, but I didn't get. That's precisely what I did ;)
> 
>> The current media_entity defined in struct video_device has to be replaced
>> by media_intf_devnode, and the DMA entity has to be added as a new entity
>> to these drivers.
> 
> If I do this way, it would break bisectability. I need first to replace
> the names, but keep them as entities, and then add the interfaces.
> 
>>
>> This reflects these two action items from our meeting:
>>
>> Migration: add v4l-subdev media_interface: Laurent
>> Migration: add explicit DMA Engine entity: Laurent
>>
>> Unless Laurent says differently I think this is something you'll have to
>> do given Laurent's workload.
> 
> Yes. The above action items are covered on this series.
> 
> What patch 24 does is to define the new namespace, moving the legacy
> symbols kept due to backward compatibility on a separate part of the
> header.
> 
> Then, patches 25-38 replace the occurrences of the deprecated names
> by the new ones.
> 
> Nothing is touched at the interfaces yet, to avoid breaking bisectability.

I don't follow why that would break bisect.

> Then, the next patches add interfaces support at the V4L side.

So this is not yet included in this patch series? That would explain
my confusion. If it is, then I need to take another look on Friday.

Regards,

	Hans
