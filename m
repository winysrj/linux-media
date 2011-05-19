Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49164 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933091Ab1ESNrs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 09:47:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 0/2] V4L: Extended crop/compose API
Date: Thu, 19 May 2011 15:47:49 +0200
Cc: Hans Verkuil <hansverk@cisco.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sakari.ailus@maxwell.research.nokia.com
References: <1304588396-7557-1-git-send-email-t.stanislaws@samsung.com> <201105181431.59580.hansverk@cisco.com> <4DD3C391.3060407@samsung.com>
In-Reply-To: <4DD3C391.3060407@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105191547.50175.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday 18 May 2011 15:03:13 Sylwester Nawrocki wrote:
> On 05/18/2011 02:31 PM, Hans Verkuil wrote:
> > On Wednesday, May 18, 2011 14:06:21 Sylwester Nawrocki wrote:
> >> On 05/16/2011 09:21 AM, Laurent Pinchart wrote:
> >> > On Saturday 14 May 2011 12:50:32 Hans Verkuil wrote:
> >> >> On Friday, May 13, 2011 14:43:08 Laurent Pinchart wrote:
> >> >>>
> >> >>> Thinking some more about it, does it make sense to set both crop and
> >> >>> compose on a single video device node (not talking about mem-to-mem,
> >> >>> where you use the type to multiplex input/output devices on the same
> >> >>> node) ? If so, what would the use cases be ?
> >> 
> >> I can't think of any, one either use crop or compose.
> > 
> > I can: you crop in the video receiver and compose it into a larger
> > buffer.
> > 
> > Actually quite a desirable feature.
> 
> Yes, right. Don't know why I imagined something different.
> And we need it in Samsung capture capture interfaces as well. The H/W
> is capable of cropping and composing with camera interface as a data source
> similarly as it is done with memory buffers.

The same result could be achieved by adding an offset to the buffer address 
and setting the bytesperline field accordingly, but that would only work with 
userptr buffers. As we're working on an API to share buffers between 
subsystems, I agree that composing into a larger buffer is desirable and 
shouldn't be implemented using offset/stride.

-- 
Regards,

Laurent Pinchart
