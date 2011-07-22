Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:19111 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab1GVKjo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 06:39:44 -0400
Message-ID: <4E29536A.3010003@maxwell.research.nokia.com>
Date: Fri, 22 Jul 2011 13:39:38 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC 0/3] Frame synchronisation events and support for them in
 the OMAP 3 ISP driver
References: <4E2588AD.4070106@maxwell.research.nokia.com> <4E284C71.7050806@gmail.com>
In-Reply-To: <4E284C71.7050806@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sylwester Nawrocki wrote:
> Hi Sakari,

Hi Sylwester,

Thanks for the comments.

> On 07/19/2011 03:37 PM, Sakari Ailus wrote:
>> Hi all,
>>
>> The OMAP 3 ISP driver implements an HS_VS event which is triggered when
>> the reception of a frame begins. This functionality is very, very likely
>> not specific to OMAP 3 ISP so it should be standardised.
>>
>> I have a few patches to do that. Additionally the next expected buffer
>> sequence number is provided with the event, unlike earlier.
>>
>> There are a few open questions, however, and this is why I'm sending the
>> set as RFC.
>>
>>
>> 1) Other frame synchronisation events. The CCDC block in the OMAP 3 ISP
>> is able to trigger interrupts at two chosen lines of the image. These
>> naturally can be translated to events. The driver uses both of them
>> internally at specific points of the frame. Nevertheless, there might be
>> some use for these in user space. Other hardware might implement a
>> number of these which wouldn't be used by the driver itself, but I don't
>> know of that at the moment. On the other hand high resolution timers are
>> also available in user space, so doing timing based on ISP provided
>> events is not quite as important as before --- as long as there's one
>> frame based event produced at a known time, such as V4L2_EVENT_FRAME_START.
> 
> I'm curious, have you perhaps tried to measure latency of such up calls
> to a user space process? I mean this is going to be a real time stuff,
> with HSYNC periods of 50 us order. Could a user space thread be receiving
> such periodic events reliably ? From my experience I doubt this can work
> reliably outside of an interrupt handler even with high priority real time
> threads.
> 
> V4L2_EVENT_FRAME_START event seems OK, but HSYNC events in user space
> sound rather tricky to me :-)

I think the user space could be interested in just one or two of these
per frame, not for every line. But how to subscribe them --- if they are
needed?

Perhaps it'd be better to start with just one and add more once necessary?

> Also HS_VS looks a bit more descriptive than FRAME_START for me.

HS_VS doesn't really tell which one it is (horizontal or vertical), and
we already have a VSYNC event but it's used for a different purpose.
HS_VS is specific to the CCDC block and doesn't have that meaning in
context of serial interfaces.

This is why I proposed FRAME_START.

> But unfortunately I can't come up with a better name, e.g. something like
> V4L2_EVENT_FRAME_AV_START - frame active video start. Just in case in
> future there are more specific events added.

What additional information would AV add which isn't evident from
FRAME_START?

I admit that there could be differencies in terminology used in this
area; terms that are meaningful to some might not be to others, or they
could mean different things to them.

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
