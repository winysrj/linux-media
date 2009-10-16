Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:51157 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbZJPI4j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 04:56:39 -0400
Message-ID: <4AD834E8.5090209@maxwell.research.nokia.com>
Date: Fri, 16 Oct 2009 11:55:04 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Zutshi Vimarsh <vimarsh.zutshi@nokia.com>,
	Ivan Ivanov <iivanov@mm-sol.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Guru Raj <gururaj.nagendra@intel.com>
Subject: Re: [RFC] Video events, version 2
References: <4AD5CBD6.4030800@maxwell.research.nokia.com>    <200910141948.33666.hverkuil@xs4all.nl>    <200910152311.33709.laurent.pinchart@ideasonboard.com>    <200910152337.06794.hverkuil@xs4all.nl>    <4AD82293.5040504@maxwell.research.nokia.com> <7c87abde6f2f45f29d56c6b112de169d.squirrel@webmail.xs4all.nl>
In-Reply-To: <7c87abde6f2f45f29d56c6b112de169d.squirrel@webmail.xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
[clip]
> I'm not keen on using pointers insides structures unless there is a very
> good reason to do so. In practice it complicates the driver code
> substantially due to all the kernel-to-userspace copies that need to be
> done that are normally handled by video_ioctl2. In addition it requires
> custom code in the compat-ioctl32 part as well.

VIDIOC_DQEVENT then.

[clip]
>> The size of the structure is now 96 bytes. I guess we could make that
>> around 128 to allow a bit more space for data without really affecting
>> performance.
> 
> With 'big unions' I didn't mean the memory size. I think 64 bytes (16
> longs) is a decent size. I was talking about the union definition in the
> videodev2.h header.

That was a badly placed comment, but I meant the memory size. I have 
currently no opinion on whether to use union or not.

[clip]
>>> That said, I think the initial implementation should be that the
>>> subscribe
>>> ioctl gets a struct with the event type and a few reserved fields so
>>> that
>>> in the future we can use one of the reserved fields as a configuration
>>> parameter. So for now we just have some default watermark that is set by
>>> the
>>> driver.
>> I'd like to think a queue size defined by the driver is fine at this
>> point. It's probably depending on the driver rather than application how
>> long the queue should to be. At some point old events start becoming
>> uninteresting...
> 
> Question: will we drop old events or new events? Or make this
> configurable? Or driver dependent?

This should the same than for video buffers. I guess it's undefined? I'd 
let the driver decide at this point.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
