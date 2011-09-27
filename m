Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:59795 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab1I0Pce (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 11:32:34 -0400
Received: from epcpsbgm1.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LS600IBGTU8QJC0@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Wed, 28 Sep 2011 00:32:32 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LS6003UXTU35N70@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Wed, 28 Sep 2011 00:32:32 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl, sakari.ailus@iki.fi
References: <1314793703-32345-1-git-send-email-t.stanislaws@samsung.com>
 <201109231513.22342.laurent.pinchart@ideasonboard.com>
 <4E7CA433.1000402@samsung.com>
 <201109271317.07571.laurent.pinchart@ideasonboard.com>
 <4E81DAE7.60509@samsung.com>
In-reply-to: <4E81DAE7.60509@samsung.com>
Subject: RE: [PATCH 2/4] v4l: add documentation for selection API
Date: Tue, 27 Sep 2011 17:32:26 +0200
Message-id: <003401cc7d2a$abe23990$03a6acb0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz and Laurent,

I have commented on the MFC case below.

> From: Tomasz Stanislawski [mailto:t.stanislaws@samsung.com]
> 
> Hi Laurent,
> 
> On 09/27/2011 01:17 PM, Laurent Pinchart wrote:
> > Hi Tomasz,
> >
> > On Friday 23 September 2011 17:22:27 Tomasz Stanislawski wrote:
> >> On 09/23/2011 03:13 PM, Laurent Pinchart wrote:
> >
> 

[snip]
> 
> >>>>>
> >>>>> How would an application remove them ?
> >>>>
> >>>> The application may use memset if it recognizes fourcc. The idea of
> >>>> padding target was to provide information about artifacts introduced
> the
> >>>> hardware. If the image is decoded directly to framebuffer then the
> >>>> application could remove artifacts. We could introduce some V4L2
> >>>> control to inform if the padding are is filled with zeros to avoid
> >>>> redundant memset.
> >>>> What do you think?
> >>>
> >>> OK, I understand this better now. I'm still not sure how applications
> >>> will be able to cope with that. memset'ing the garbage area won't look
> >>> good on the screen.
> >>
> >> The memset is just a simple and usually fast solution. The application
> >> could fill the padding area with any pattern or background color.
> >>
> >>> Does your hardware have different compose and padding rectangles ?
> >>
> >> I assume that you mean active and padded targets for composing, right?
> >> The answer is yes. The MFC inserts data to the image that dimensions are
> >> multiples of 128x32. The movie inside could be any size that fits to the
> >> buffer. The area that contains the movie frame is the active rectangle.
> >> The padded is filled with zeros. For MFC the bounds and padded rectangle
> >> are the same.
> >>
> >> Hmm...
> >>
> >> Does it violate 'no margin requirement', doesn't it?
> >
> > Seems so :-)
> >
> 
> For S5P MFC is it not possible to satisfy 'no margin' requirement in all
> cases. The default rectangle is not equal to the bound rectangle in all
> cases. BTW, the MFC is mem2mem device so its API may change.
> To sum up for MFC following inequalities are satisfied:
> 
> active <= padded == bound
> 
> Do you think that 'no margin' requirement should be downgraded to a
> recommendation status?

In case of MFC it will be active == padded <= bound as MFC does not fill the
region outside the active zone with zeroes. That pixels are not modified.

The 'no margin requirement' as I understand should not be imposed. I can imagine
other hardware than MFC that may have the default crop other than the full buffer
size. This will be especially common in case of various tiled image formats.
In MFC we have 128x32 tiles, but the movie size can be any number (If I remember
correctly).


[snip]


Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


