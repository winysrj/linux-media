Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:56954 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab1GUP5r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2011 11:57:47 -0400
Received: by fxd18 with SMTP id 18so3757631fxd.11
        for <linux-media@vger.kernel.org>; Thu, 21 Jul 2011 08:57:46 -0700 (PDT)
Message-ID: <4E284C71.7050806@gmail.com>
Date: Thu, 21 Jul 2011 17:57:37 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RFC 0/3] Frame synchronisation events and support for them in
 the OMAP 3 ISP driver
References: <4E2588AD.4070106@maxwell.research.nokia.com>
In-Reply-To: <4E2588AD.4070106@maxwell.research.nokia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 07/19/2011 03:37 PM, Sakari Ailus wrote:
> Hi all,
> 
> The OMAP 3 ISP driver implements an HS_VS event which is triggered when
> the reception of a frame begins. This functionality is very, very likely
> not specific to OMAP 3 ISP so it should be standardised.
> 
> I have a few patches to do that. Additionally the next expected buffer
> sequence number is provided with the event, unlike earlier.
> 
> There are a few open questions, however, and this is why I'm sending the
> set as RFC.
> 
> 
> 1) Other frame synchronisation events. The CCDC block in the OMAP 3 ISP
> is able to trigger interrupts at two chosen lines of the image. These
> naturally can be translated to events. The driver uses both of them
> internally at specific points of the frame. Nevertheless, there might be
> some use for these in user space. Other hardware might implement a
> number of these which wouldn't be used by the driver itself, but I don't
> know of that at the moment. On the other hand high resolution timers are
> also available in user space, so doing timing based on ISP provided
> events is not quite as important as before --- as long as there's one
> frame based event produced at a known time, such as V4L2_EVENT_FRAME_START.

I'm curious, have you perhaps tried to measure latency of such up calls
to a user space process? I mean this is going to be a real time stuff,
with HSYNC periods of 50 us order. Could a user space thread be receiving
such periodic events reliably ? From my experience I doubt this can work
reliably outside of an interrupt handler even with high priority real time
threads.

V4L2_EVENT_FRAME_START event seems OK, but HSYNC events in user space
sound rather tricky to me :-)

Also HS_VS looks a bit more descriptive than FRAME_START for me.
But unfortunately I can't come up with a better name, e.g. something like
V4L2_EVENT_FRAME_AV_START - frame active video start. Just in case in
future there are more specific events added.

> 
> Frame end events may be produced as well. This is not exactly the same
> as just dequeueing the buffer at video node since the hardware may be
> able to produce events even in cases there are no buffers and if the
> very hardware block that processes the frame is not outputting it to
> memory, handling by further blocks takes more time, and thus delays the
> finishing of the buffer from the driver's queue. This is the reason why
> the name of the struct related to the event is v4l2_event_frame_sync
> rather than v4l2_event_frame_start.
> 
> 2) Buffer sequence number location in the struct v4l2_event. the patches
> create a new structure called v4l2_event_frame_sync which contains just
> one field, buffer_sequence. Should buffer_sequence be part of this
> struct, or should it be part of v4l2_event directly, as the id field?
> Both buffer_sequence and id refer to another rather widely used concept
> in V4L2.
> 
> 
> Besides this, the first patch in the series moves the documentation of
> structs inside v4l2_event to VIDIOC_DQEVENT documentation. I think it
> belongs there rather than to VIDIOC_SUBSCRIBE_EVENT, since that's not
> where they are being used.
> 

--
Regards,
Sylwester
