Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38491 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab1KXNpU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 08:45:20 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LV6006LJ3JH6G70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2011 13:45:18 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LV600CIH3JHDY@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2011 13:45:17 +0000 (GMT)
Date: Thu, 24 Nov 2011 14:45:17 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC 1/2] v4l: Add a global color alpha control
In-reply-to: <201111241249.00601.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, mchehab@redhat.com,
	m.szyprowski@samsung.com, jonghun.han@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4ECE4A6D.90209@samsung.com>
References: <1322131997-26195-1-git-send-email-s.nawrocki@samsung.com>
 <201111241209.12377.laurent.pinchart@ideasonboard.com>
 <4ECE2D0A.8060209@samsung.com> <201111241249.00601.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/24/2011 12:49 PM, Hans Verkuil wrote:
> On Thursday, November 24, 2011 12:39:54 Sylwester Nawrocki wrote:
>> On 11/24/2011 12:09 PM, Laurent Pinchart wrote:
>>> On Thursday 24 November 2011 12:00:45 Hans Verkuil wrote:
>>>> On Thursday, November 24, 2011 11:53:16 Sylwester Nawrocki wrote:
...
> How about V4L2_CID_ALPHA_COMPONENT?

This one seems the best fit for me. I'll redo the patches and send
them out tomorrow. Unless someone comes up with even better name.

Thanks for your comment Hans and Laurent!

--
Regards,
Sylwester
