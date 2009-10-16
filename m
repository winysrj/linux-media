Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:27524 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758921AbZJPMgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 08:36:16 -0400
Message-ID: <4AD86854.8060803@maxwell.research.nokia.com>
Date: Fri, 16 Oct 2009 15:34:28 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	Ivan Ivanov <iivanov@mm-sol.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Guru Raj <gururaj.nagendra@intel.com>
Subject: Re: [RFC] Video events, version 2
References: <4AD5CBD6.4030800@maxwell.research.nokia.com> <200910152337.06794.hverkuil@xs4all.nl> <4AD82293.5040504@maxwell.research.nokia.com> <200910161024.13340.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200910161024.13340.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> On Friday 16 October 2009 09:36:51 Sakari Ailus wrote:
>> Hans Verkuil wrote:
>>> On Thursday 15 October 2009 23:11:33 Laurent Pinchart wrote:
>>>> For efficiency reasons a V4L2_G_EVENTS ioctl could also be provided to
>>>> retrieve multiple events.
>>>>
>>>> struct v4l2_events {
>>>> 	__u32 count;
>>>> 	struct v4l2_event __user *events;
>>>> };
>>>>
>>>> #define VIDIOC_G_EVENTS _IOW('V', xx, struct v4l2_events)
>>> Hmm. Premature optimization. Perhaps as a future extension.
>> That *could* save one ioctl sometimes --- then you'd no there are no
>> more events coming right now. But just one should be supported IMO,
>> VIDIOC_G_EVENT or VIDIOC_G_EVENTS.
> 
> I forgot to mention in my last mail that we should add a flag to the 
> v4l2_event structure to report if more events are pending (or even possible a 
> pending event count).

Then the V4L (or driver) would have to check the queue for that type of 
events. OTOH, the queue size could be quite small and it'd never 
overflow since the maximum size is number of different event types.

Can there be situations when the first or last event timestamp of 
certain event would be necessary? If we put count there, then we need to 
make a decision which one is useful for the userspace. The last one is 
obviously useful for the AF/AEWB algorightms. I currently see no use for 
the first one, but that doesn't mean there couldn't be use for it.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
