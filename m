Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22690 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab2AaLXY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jan 2012 06:23:24 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LYN00CWPUAY2640@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 Jan 2012 11:23:22 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LYN00BPRUAXIR@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 Jan 2012 11:23:22 +0000 (GMT)
Date: Tue, 31 Jan 2012 12:23:21 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [Q] Interleaved formats on the media bus
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Message-id: <4F27CF29.5090905@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Some camera sensors generate data formats that cannot be described using
current convention of the media bus pixel code naming.

For instance, interleaved JPEG data and raw VYUY. Moreover interleaving
is rather vendor specific, IOW I imagine there might be many ways of how
the interleaving algorithm is designed.

I'm wondering how to handle this. For sure such an image format will need
a new vendor-specific fourcc. Should we have also vendor specific media bus code ?

I would like to avoid vendor specific media bus codes as much as possible.
For instance defining something like

V4L2_MBUS_FMT_VYUY_JPEG_1X8

for interleaved VYUY and JPEG data might do, except it doesn't tell anything
about how the data is interleaved.

So maybe we could add some code describing interleaving (xxxx)

V4L2_MBUS_FMT_xxxx_VYUY_JPEG_1X8

or just the sensor name instead ?

Thoughts ?


Regards,
-- 
Sylwester Nawrocki
Samsung Poland R&D Center
