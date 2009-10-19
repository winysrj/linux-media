Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:33953 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753985AbZJSVIj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Oct 2009 17:08:39 -0400
Message-ID: <4ADCD536.6020105@maxwell.research.nokia.com>
Date: Tue, 20 Oct 2009 00:08:06 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Tomasz Fujak <t.fujak@samsung.com>
CC: linux-media@vger.kernel.org,
	"'Laurent Pinchart'" <laurent.pinchart@ideasonboard.com>,
	"'Hans Verkuil'" <hverkuil@xs4all.nl>,
	"'Zutshi Vimarsh (Nokia-D-MSW/Helsinki)'" <vimarsh.zutshi@nokia.com>,
	"'Ivan Ivanov'" <iivanov@mm-sol.com>,
	"'Cohen David Abraham'" <david.cohen@nokia.com>,
	"'Guru Raj'" <gururaj.nagendra@intel.com>,
	Mike Krufky <mkrufky@linuxtv.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [RFC] Video events, version 2.1
References: <4AD877A0.3080004@maxwell.research.nokia.com> <004301ca50b7$0a02e6c0$1e08b440$%fujak@samsung.com>
In-Reply-To: <004301ca50b7$0a02e6c0$1e08b440$%fujak@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tomasz Fujak wrote:
> Hi,

Hi, Tomasz!

> The event count may be useful for the reason Laurent mentioned. In case we
> don't have dequeue multiple (DQEVENT_MULTIPLE?) a flag should be enough,
> saying if there are any events immediately available. That'd be just one bit
> we could mash into the 'type' field.

We could have also another field for flags. It's nicer to do that than 
use the type field for that --- we're not short of bits here.

> On the other hand I can imagine an event type that come swarming once a
> client registers to them (i.e.: VSYNC). In such a case they may overflow a
> queue and discard potentially useful events (i.e.: a cable detached from the
> output). We could do one of the following:
>  - nothing (let the above happen if the application is not fast enough to
> retrieve events),
>  - suggest using separate event feed for periodic events,
>  - compress periodic events (provide 'compressed' flag, and stamp the event
> with the timestamp of the last of the kind) - thus at most one of a periodic
> event type would reside in the queue,
>  - let the client define the window size,
>  - define event priorities (low, normal, high) and discard overflowing
> events starting with the lowest priorities. I.e.: low for VSYNC, normal for
> picture decoding error and high for cable attach

I think it's up to the driver to define the queue size. Then the queue 
can just overflow when it becomes full. If the client isn't fast enough 
to handle the events buffering them won't help in the end... for 
temporary scheduling delays a deeper queue should do the trick.

Another ioctl would probably be required for queue size setting if it's 
ever needed. This is IMO more or less equivalent to setting the maximum 
allocatable memory for video buffers, which is indeed fixed to video 
drivers themselves.

> Third, the event subscription scheme. What does a subscription call mean:
> "Add these new events to what I already collect" or "Discard whatever I have
> subscribed for and now give me this"?

Add this one / remove this one. The type is a 32-number so we should 
have enough different kind of events. :)

> In the latter use, there are just 27 event types available; can't tell if
> that's enough till we try to enumerate the event types we currently have.
> I've just seen a few of them (DVB, UVC, ACPI), but I think the list would
> grow once people start using the v4l2 events. How big is it going to be?

Let's hope people start using this once it's available...

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
