Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55492 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757485AbcCVAQO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 20:16:14 -0400
Subject: Re: [RFC PATCH 1/3] [media] v4l2-mc.h: Add a S-Video C input PAD to
 demod enum
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
 <1457550566-5465-2-git-send-email-javier@osg.samsung.com>
 <56EC2294.603@xs4all.nl> <56EC3BF3.5040100@xs4all.nl>
 <20160321114045.00f200a0@recife.lan> <56F00DAA.8000701@xs4all.nl>
 <56F01AE7.6070508@xs4all.nl> <20160321145034.6fa4e677@recife.lan>
 <56F038A0.1010004@xs4all.nl> <56F03C40.4090909@osg.samsung.com>
 <56F0461A.1070809@xs4all.nl> <56F04969.6070908@osg.samsung.com>
 <20160321182047.3f52e119@recife.lan>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56F08EC4.5050105@osg.samsung.com>
Date: Mon, 21 Mar 2016 21:16:04 -0300
MIME-Version: 1.0
In-Reply-To: <20160321182047.3f52e119@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Mauro,

On 03/21/2016 06:20 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 21 Mar 2016 16:20:09 -0300
> Javier Martinez Canillas <javier@osg.samsung.com> escreveu:
> 
>>> BTW, if the tvp5150 needs to know which composite connector is connected
>>> to which hardware pin, then you still may need to be explicit w.r.t. the
>>> number of pads. I just thought of that.
>>>  
>>
>> The tvp5150 doesn't care about that, as Mauro said is just a mux so you can
>> have logic in the .link_setup that does the mux depending on the remote
>> entity (that's in fact how I implemented and is currently in mainline).
>>
>> Now, the user needs to know which entity is mapped to which input pin.
>> All its know from the HW documentation is that for example the left
>> RCA connector is AIP1A and the one inf the right is connected to AIP1B.
>>
>> So there could be a convention that the composite connected to AIP1A pin
>> (the default) is Composite0 and the connected to AIP1B is Composite1.
> 
> 
> We should avoid a convention here... instead, we should support
> properties via the properties API to export enough info for userspace
> to know what physical connectors correspond to each "connection" entity.
> 
> As we've discussed previously, such properties can be:
> 	- connector's name
> 	- color
> 	- position
> etc...
>

Right, I forgot about the properties API.
 
> 
> Regards,
> Mauro
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
