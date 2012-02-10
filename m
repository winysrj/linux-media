Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31650 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173Ab2BJKTp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 05:19:45 -0500
Received: from euspt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LZ6006C7A0VU3@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Feb 2012 10:19:43 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LZ60000TA0VII@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Feb 2012 10:19:43 +0000 (GMT)
Date: Fri, 10 Feb 2012 11:19:42 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [Q] Interleaved formats on the media bus
In-reply-to: <Pine.LNX.4.64.1202100934070.5787@axis700.grange>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Message-id: <4F34EF3E.2090004@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
References: <4F27CF29.5090905@samsung.com> <4116034.kVC1fDZsLk@avalon>
 <4F32FBBB.7020007@gmail.com> <12779203.vQPWKN8eZf@avalon>
 <Pine.LNX.4.64.1202100934070.5787@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/10/2012 09:42 AM, Guennadi Liakhovetski wrote:
> ...thinking about this interleaved data, is there anything else left, that 
> the following scheme would be failing to describe:
> 
> * The data is sent in repeated blocks (periods)

The data is sent in irregular chunks of varying size (few hundred of bytes
for example).

> * Each block can be fully described by a list of format specifiers, each 
> containing
> ** data format code
> ** number of alignment bytes
> ** number of data bytes

Each frame would have its own list of such format specifiers, as the data
chunk sizes vary from frame to frame. Therefore the above is unfortunately
more a frame meta data, rather than a static frame description.

> Can there actually be anything more complicated than that?

There is an embedded data at end of frame (could be also at the beginning)
which describes layout of the interleaved data.

Some data types would have padding bytes.

Even if we somehow find a way to describe the frame on media bus, using a set
of properties, it would be difficult to pass this information to user space.
A similar description would have to be probably exposed to applications, now
everything is described in user space by a single fourcc..


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
