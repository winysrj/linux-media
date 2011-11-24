Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11862 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab1KXJec (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Nov 2011 04:34:32 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LV5006CGRXI6G40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2011 09:34:30 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LV500NJBRXH1A@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 24 Nov 2011 09:34:30 +0000 (GMT)
Date: Thu, 24 Nov 2011 10:34:29 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [Query] V4L2 Integer (?) menu control
In-reply-to: <20111124085018.GF27136@valkosipuli.localdomain>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	=?ISO-8859-1?Q?R=E9mi_Denis-Courmon?= =?ISO-8859-1?Q?t?=
	<remi@remlab.net>
Message-id: <4ECE0FA5.1040205@samsung.com>
References: <4ECD730E.3080808@gmail.com>
 <20111124085018.GF27136@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you all for the comments.

On 11/24/2011 09:50 AM, Sakari Ailus wrote:
> Hi Sylwester,
> 
> There is not currently, but I have patches for it. The issue is that I need
> them myself but the driver I need them for isn't ready to be released yet.
> And as usual, I assume others than vivo is required to show they're really
> useful so I haven't sent them.

That's great news. Then I might not need to do all the work on my own;)

> 
> Good that you asked so we won't end up writing essentially the same code
> again. I'll try to send the patches today.

All right, there is no rush. I was just looking around how to support the
camera scene mode with m5mols sort of sensors. The scene mode is essentially
a compilation of several different parameters, for some of which there are
standard controls in V4L2 but for many there are not.

I've got a feeling the best way to handle this would be to create controls
for each single parameter and then do a batch set from user space, and keep
the scene mode mappings in user space. The only concern is there is a couple
of ISP-specific parameters involved with that scene mode thing. Perhaps they
just could be set initially to fixed values.

-- 
Regards,
Sylwester

