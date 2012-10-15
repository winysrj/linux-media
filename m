Return-path: <linux-media-owner@vger.kernel.org>
Received: from mxout-07.mxes.net ([216.86.168.182]:16662 "EHLO
	mxout-07.mxes.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab2JOSyE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 14:54:04 -0400
Message-ID: <507C5BC4.7060700@cybermato.com>
Date: Mon, 15 Oct 2012 11:53:56 -0700
From: Chris MacGregor <chris@cybermato.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl, remi@remlab.net,
	daniel-gl@gmx.net, sylwester.nawrocki@gmail.com
Subject: Re: [RFC] Timestamps and V4L2
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <20121015160549.GE21261@valkosipuli.retiisi.org.uk> <2316067.OFTCziv4Z5@avalon>
In-Reply-To: <2316067.OFTCziv4Z5@avalon>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, all.

On 10/15/2012 11:45 AM, Laurent Pinchart wrote:
> Hi Sakari,
>
> On Monday 15 October 2012 19:05:49 Sakari Ailus wrote:
>> Hi all,
>>
>> As a summar from the discussion, I think we have reached the following
>> conclusion. Please say if you agree or disagree with what's below. :-)
>>
>> - The drivers will be moved to use monotonic timestamps for video buffers.
>> - The user space will learn about the type of the timestamp through buffer
>> flags.
>> - The timestamp source may be made selectable in the future, but buffer
>> flags won't be the means for this, primarily since they're not available on
>> subdevs. Possible way to do this include a new V4L2 control or a new IOCTL.
> That's my understanding as well. For the concept,
>
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I wasn't able to participate in the discussion that led to this, but I'd 
like to suggest and request now that an explicit requirement (of 
whatever scheme is selected) be that a userspace app have a reasonable 
and straightforward way to translate the timestamps to real wall-clock 
time, ideally with enough precision to allow synchronization of cameras 
across multiple computers.

In the systems I work on, for instance, we are recording real-world 
biological processes, some of which vary based on the time of day, and 
it is important to know when a given frame was captured so that 
information can be stored with the raw frame and the data derived from 
it. For many such purposes, an accuracy measured in multiple seconds (or 
even minutes) is fine.

However, when we are using multiple cameras on multiple computers (e.g., 
two or more BeagleBoard xM's, each with a camera connected), we would 
want to synchronize with an accuracy of less than 1 frame time - e.g. 10 
ms or less.

Thanks very much,
Chris MacGregor
