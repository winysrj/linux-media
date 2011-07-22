Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:54451 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab1GVOXP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 10:23:15 -0400
Received: by fxd18 with SMTP id 18so5358720fxd.11
        for <linux-media@vger.kernel.org>; Fri, 22 Jul 2011 07:23:13 -0700 (PDT)
Message-ID: <4E2987CC.5010303@gmail.com>
Date: Fri, 22 Jul 2011 16:23:08 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC 0/3] Frame synchronisation events and support for them in
 the OMAP 3 ISP driver
References: <4E2588AD.4070106@maxwell.research.nokia.com> <4E284C71.7050806@gmail.com> <4E29536A.3010003@maxwell.research.nokia.com>
In-Reply-To: <4E29536A.3010003@maxwell.research.nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/22/2011 12:39 PM, Sakari Ailus wrote:
...
>> On 07/19/2011 03:37 PM, Sakari Ailus wrote:
>>> Hi all,
>>>
>>> The OMAP 3 ISP driver implements an HS_VS event which is triggered when
>>> the reception of a frame begins. This functionality is very, very likely
>>> not specific to OMAP 3 ISP so it should be standardised.
>>>
>>> I have a few patches to do that. Additionally the next expected buffer
>>> sequence number is provided with the event, unlike earlier.
>>>
>>> There are a few open questions, however, and this is why I'm sending the
>>> set as RFC.
>>>
>>>
>>> 1) Other frame synchronisation events. The CCDC block in the OMAP 3 ISP
>>> is able to trigger interrupts at two chosen lines of the image. These
>>> naturally can be translated to events. The driver uses both of them
>>> internally at specific points of the frame. Nevertheless, there might be
>>> some use for these in user space. Other hardware might implement a
>>> number of these which wouldn't be used by the driver itself, but I don't
>>> know of that at the moment. On the other hand high resolution timers are
>>> also available in user space, so doing timing based on ISP provided
>>> events is not quite as important as before --- as long as there's one
>>> frame based event produced at a known time, such as V4L2_EVENT_FRAME_START.
>>
>> I'm curious, have you perhaps tried to measure latency of such up calls
>> to a user space process? I mean this is going to be a real time stuff,
>> with HSYNC periods of 50 us order. Could a user space thread be receiving
>> such periodic events reliably ? From my experience I doubt this can work
>> reliably outside of an interrupt handler even with high priority real time
>> threads.
>>
>> V4L2_EVENT_FRAME_START event seems OK, but HSYNC events in user space
>> sound rather tricky to me :-)
> 
> I think the user space could be interested in just one or two of these
> per frame, not for every line. But how to subscribe them --- if they are
> needed?

Yes, that was my understanding. But still we need much better accuracy than
in case of VSYNC/FRAME_START. It seems really hard to guarantee in Linux
that a specific line event will be received in user space when that actual
line is transmitted. There is much better chance that a FRAME_START event
is received during the time when a frame that triggered it is being processed.
And VSYNC signals last over several horizontal lines (if not tens or thousands)
which makes it easier to receive an event when a VSYNC pulse/period hasn't yet
expired.

> 
> Perhaps it'd be better to start with just one and add more once necessary?

Maybe we could accommodate the struct v4l2_event_subscription::id field for 
a horizontal line number, with a special bit indicating any one ?
But again I'm not convinced to horizontal line events :) There might be
situations when even interrupt handlers are to slow for this.

> 
>> Also HS_VS looks a bit more descriptive than FRAME_START for me.
> 
> HS_VS doesn't really tell which one it is (horizontal or vertical), and
> we already have a VSYNC event but it's used for a different purpose.
> HS_VS is specific to the CCDC block and doesn't have that meaning in
> context of serial interfaces.
> 
> This is why I proposed FRAME_START.

OK, initially I thought it was that HS_VS means a moment when vertical
and horizontal sync (blanking?) signals go off and thus video data 
of the first line in a frame is started to be transmitted.
I agree that HS_VS isn't that relevant in the CSI terminology.

> 
>> But unfortunately I can't come up with a better name, e.g. something like
>> V4L2_EVENT_FRAME_AV_START - frame active video start. Just in case in
>> future there are more specific events added.
> 
> What additional information would AV add which isn't evident from
> FRAME_START?

Given different formats of frame headers across the standards (ITU-R BT.656,
MIPI-CSI2 and the like) it might be not so obvious at which moment the
FRAME_START event is to be triggered. But not being too paranoid I guess
we're perfectly fine with VSYNC and FRAME_START events.

> 
> I admit that there could be differencies in terminology used in this
> area; terms that are meaningful to some might not be to others, or they
> could mean different things to them.

Yes, I entirely agree. So perhaps we're better off with V4L2_EVENT_FRAME_START
name and having the exact meaning described in details in the documentation.

--
Regards,
Sylwester
