Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:32453 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab2BBLON (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 06:14:13 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LYR006LVJ7L8N40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 02 Feb 2012 11:14:09 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LYR001G1J7LIH@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 02 Feb 2012 11:14:09 +0000 (GMT)
Date: Thu, 02 Feb 2012 12:14:08 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [Q] Interleaved formats on the media bus
In-reply-to: <201202021055.19705.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Message-id: <4F2A7000.7080201@samsung.com>
References: <4F27CF29.5090905@samsung.com>
 <20120201100007.GA841@valkosipuli.localdomain> <4F2924F8.3040408@samsung.com>
 <201202021055.19705.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 02/02/2012 10:55 AM, Laurent Pinchart wrote:
> Do all those sensors interleave the data in the same way ? This sounds quite 

No, each one uses it's own interleaving method.

> hackish and vendor-specific to me, I'm not sure if we should try to generalize 
> that. Maybe vendor-specific media bus format codes would be the way to go. I 
> don't expect ISPs to understand the format, they will likely be configured in 
> pass-through mode. Instead of adding explicit support for all those weird 
> formats to all ISP drivers, it might make sense to add a "binary blob" media 
> bus code to be used by the ISP.

This could work, except that there is no way to match a fourcc with media bus
code. Different fourcc would map to same media bus code, making it impossible
for the brigde to handle multiple sensors or one sensor supporting multiple
interleaved formats. Moreover there is a need to map media bus code to the
MIPI-CSI data ID. What if one sensor sends "binary" blob with MIPI-CSI
"User Define Data 1" and the other with "User Define Data 2" ?

Maybe we could create e.g. V4L2_MBUS_FMT_USER?, for each MIPI-CSI User Defined
data identifier, but as I remember it was decided not to map MIPI-CSI data
codes directly onto media bus pixel codes.


Thanks,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
