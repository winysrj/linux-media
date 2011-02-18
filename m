Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45287 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754634Ab1BRNTs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 08:19:48 -0500
Received: by bwz15 with SMTP id 15so702040bwz.19
        for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 05:19:46 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>,
	"Hans Verkuil" <hansverk@cisco.com>, "Qing Xu" <qingx@marvell.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Neil Johnson" <realdealneil@gmail.com>,
	"Robert Jarzmik" <robert.jarzmik@free.fr>,
	"Uwe Taeubert" <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Eino-Ville Talvala" <talvala@stanford.edu>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
References: <4D5D9B57.3090809@gmail.com>
 <201102181131.30920.laurent.pinchart@ideasonboard.com>
 <op.vq3jwls93l0zgt@mnazarewicz-glaptop>
 <201102181357.26382.laurent.pinchart@ideasonboard.com>
Date: Fri, 18 Feb 2011 14:19:44 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vq3om6es3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <201102181357.26382.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 18 Feb 2011 13:57:25 +0100, Laurent Pinchart  
<laurent.pinchart@ideasonboard.com> wrote:

> Hi Michal,
>
> On Friday 18 February 2011 12:37:24 Michal Nazarewicz wrote:
>
> [snip]
>
>> What I'm trying to say is that it would be best if one could configure  
>> the device in such a way that switching between modes would not require
>> the device to free buffers (even though in user space they could be
>> inaccessible).
>>
>>
>> This is what I have in mind the usage would look like:
>>
>> 1. Open device
>> 		Kernel creates some control structures, the usual stuff.
>> 2. Initialize multi-format (specifying what formats user space will  
>> use).
>> 		Kernel calculates amount of memory needed for the most
>> 		demanding format and allocates it.
>
> Don't forget that applications can also use USERPTR. We need a  
> low-latency solution for that as well.

That would probably work best if user provided one big buffer.  Again,
I don't know how this maps to V4L API.

>
>> 3. Set format (restricted to one of formats specified in step 2)
>> 		Kernel has memory already allocated, so it only needs to split
>> 		it to buffers needed in given format.
>> 4. Allocate buffers.
>> 		Kernel allocates memory needed for most demanding format
>> 		(calculated in step 2).
>> 		Once memory is allocated, splits it to buffers needed in
>> 		given format.
>> 5. Do the loop... queue, dequeue, all the usual stuff.
>> 		Kernel instructs device to handle buffers, the usual stuff.
>
> When buffers are queued cache needs to be cleaned. This is an expensive
> operation, and we need to be able to pre-queue (or at least pre-clean)
> buffers.

Cache operations are always needed, aren't they?  Whatever you do, you
will always have to handle cache coherency (in one way or another) so
there's nothing we can do about it, or is there?

>> 6. Free buffers.
>> 		Kernel space destroys the buffers needed for given format
>> 		but DOES NOT free memory.
>>
>> 7. If not done, go to step 3.
>>
>> 8. Finish multi-format mode.
>> 		Kernel actually frees the memory.
>>
>> 9. Close the device.
>>
>> A V4L device driver could just ignore step 2 and 7 and work in the less
>> optimal mode.
>>
>> If I understand V4L2 correctly, the API does not allow for step 2 and 8.
>> In theory, they could be merged with step 1 and 9 respectively, I don't
>> know id that feasible though.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
