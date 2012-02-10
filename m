Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:10174 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759059Ab2BJKbz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 05:31:55 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LZ6003XIAL5Z130@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Feb 2012 10:31:53 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZ600BCZAL4L7@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Feb 2012 10:31:53 +0000 (GMT)
Date: Fri, 10 Feb 2012 11:31:52 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [Q] Interleaved formats on the media bus
In-reply-to: <4F34EF3E.2090004@samsung.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Message-id: <4F34F218.6000509@samsung.com>
References: <4F27CF29.5090905@samsung.com> <4116034.kVC1fDZsLk@avalon>
 <4F32FBBB.7020007@gmail.com> <12779203.vQPWKN8eZf@avalon>
 <Pine.LNX.4.64.1202100934070.5787@axis700.grange>
 <4F34EF3E.2090004@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/10/2012 11:19 AM, Sylwester Nawrocki wrote:
> On 02/10/2012 09:42 AM, Guennadi Liakhovetski wrote:
> Even if we somehow find a way to describe the frame on media bus, using a set
> of properties, it would be difficult to pass this information to user space.
> A similar description would have to be probably exposed to applications, now
> everything is described in user space by a single fourcc..

OK, we could associate a fourcc with an entry of some static table entry,
thus avoiding vendor specific media bus codes and leaving only vendor/sensor
specific fourcc. But still I'm not sure we can come up with a capable enough
frame description.

Thanks,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
