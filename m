Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11439 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051Ab1ESOF6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 10:05:58 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from spt2.w1.samsung.com ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LLG00IP74HWFR70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 19 May 2011 15:05:56 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LLG00FG94HU0Y@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 19 May 2011 15:05:55 +0100 (BST)
Date: Thu, 19 May 2011 16:05:59 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [PATCH 0/2] V4L: Extended crop/compose API
In-reply-to: <201105191547.50175.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: 'Hans Verkuil' <hansverk@cisco.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	sakari.ailus@maxwell.research.nokia.com
Message-id: <000401cc162d$e13d1d80$a3b75880$%szyprowski@samsung.com>
Content-language: pl
References: <1304588396-7557-1-git-send-email-t.stanislaws@samsung.com>
 <201105181431.59580.hansverk@cisco.com> <4DD3C391.3060407@samsung.com>
 <201105191547.50175.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello,

On Thursday, May 19, 2011 3:48 PM Laurent Pinchart wrote:

> On Wednesday 18 May 2011 15:03:13 Sylwester Nawrocki wrote:
> > On 05/18/2011 02:31 PM, Hans Verkuil wrote:
> > > On Wednesday, May 18, 2011 14:06:21 Sylwester Nawrocki wrote:
> > >> On 05/16/2011 09:21 AM, Laurent Pinchart wrote:
> > >> > On Saturday 14 May 2011 12:50:32 Hans Verkuil wrote:
> > >> >> On Friday, May 13, 2011 14:43:08 Laurent Pinchart wrote:
> > >> >>>
> > >> >>> Thinking some more about it, does it make sense to set both crop
> and
> > >> >>> compose on a single video device node (not talking about mem-to-
> mem,
> > >> >>> where you use the type to multiplex input/output devices on the
> same
> > >> >>> node) ? If so, what would the use cases be ?
> > >>
> > >> I can't think of any, one either use crop or compose.
> > >
> > > I can: you crop in the video receiver and compose it into a larger
> > > buffer.
> > >
> > > Actually quite a desirable feature.
> >
> > Yes, right. Don't know why I imagined something different.
> > And we need it in Samsung capture capture interfaces as well. The H/W
> > is capable of cropping and composing with camera interface as a data
> > source similarly as it is done with memory buffers.
> 
> The same result could be achieved by adding an offset to the buffer address
> and setting the bytesperline field accordingly, but that would only work
> with userptr buffers.

Playing with offset and bytesperline to achieve composing effect should be
considered only as a huge hack. Please note that there is a bunch of pixel
formats that have no clear definition of bytesperline at all - like macro
block formats or some (multi)planar ones. We would really like to have a
generic solution for the composing problem.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


