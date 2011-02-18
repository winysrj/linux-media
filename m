Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48400 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab1BRLh2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 06:37:28 -0500
Received: by bwz15 with SMTP id 15so620427bwz.19
        for <linux-media@vger.kernel.org>; Fri, 18 Feb 2011 03:37:27 -0800 (PST)
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
 <op.vq2lapd13l0zgt@mnazarewicz-glaptop>
 <201102181131.30920.laurent.pinchart@ideasonboard.com>
Date: Fri, 18 Feb 2011 12:37:24 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vq3jwls93l0zgt@mnazarewicz-glaptop>
In-Reply-To: <201102181131.30920.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 18 Feb 2011 11:31:30 +0100, Laurent Pinchart  
<laurent.pinchart@ideasonboard.com> wrote:

> Hi Michal,
>
> On Friday 18 February 2011 00:09:51 Michal Nazarewicz wrote:
>> >>> On Thu, 17 Feb 2011, Mauro Carvalho Chehab wrote:
>> >>>> There's an additional problem with that: assume that streaming is
>> >>>> happening, and a S_FMT changing the resolution was sent. There's
>> >>>> no way to warrant that the very next frame will have the new
>> >>>> resolution. So, a meta-data with the frame resolution (and format)
>> >>>> would be needed.
>> >>
>> >> Em 17-02-2011 17:26, Guennadi Liakhovetski escreveu:
>> >>> Sorry, we are not going to allow format changes during a running
>> >>> capture. You have to stop streaming, set new formats (possibly
>> >>> switch to another queue) and restart streaming.
>> >>>
>> >>> What am I missing?
>> >
>> > On Thu, 17 Feb 2011, Mauro Carvalho Chehab wrote:
>> >> If you're stopping the stream, the current API will work as-is.
>> >>
>> >> If all of your concerns is about reserving a bigger buffer queue, I
>> >> think that one of the reasons for the CMA allocator it for such  
>> usage.
>>
>> From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>
>> > Not just bigger, say, with our preview / still-shot example, we would
>> > have one queue with a larger number of small buffers for drop-free
>> > preview, and a small number of larger buffers for still images.
>>
>> Ie. waste memory? As in you have both those queues allocated but only
>> one is used at given time?
>
> It's a trade-off between memory and speed. Preallocating still image  
> capture
> buffers will give you better snapshot performances, at the expense of  
> memory.
>
> The basic problems we have here is that taking snapshots is slow with the
> current API if we need to stop capture, free buffers, change the format,
> allocate new buffers (and perform cache management operations) and  
> restart the
> stream. To fix this we're considering a way to preallocate still image  
> capture
> buffers, but I'm open to proposals for other ways to solve the issue :-)

What I'm trying to say is that it would be best if one could configure the
device in such a way that switching between modes would not require the
device to free buffers (even though in user space they could be  
inaccessible).


This is what I have in mind the usage would look like:

1. Open device
		Kernel creates some control structures, the usual stuff.
2. Initialize multi-format (specifying what formats user space will use).
		Kernel calculates amount of memory needed for the most
		demanding format and allocates it.

3. Set format (restricted to one of formats specified in step 2)
		Kernel has memory already allocated, so it only needs to split
		it to buffers needed in given format.
4. Allocate buffers.
		Kernel allocates memory needed for most demanding format
		(calculated in step 2).
		Once memory is allocated, splits it to buffers needed in
		given format.
5. Do the loop... queue, dequeue, all the usual stuff.
		Kernel instructs device to handle buffers, the usual stuff.
6. Free buffers.
		Kernel space destroys the buffers needed for given format
		but DOES NOT free memory.

7. If not done, go to step 3.

8. Finish multi-format mode.
		Kernel actually frees the memory.

9. Close the device.

A V4L device driver could just ignore step 2 and 7 and work in the less  
optimal
mode.


If I understand V4L2 correctly, the API does not allow for step 2 and 8.
In theory, they could be merged with step 1 and 9 respectively, I don't
know id that feasible though.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
