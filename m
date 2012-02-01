Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:59283 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2BABoW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jan 2012 20:44:22 -0500
Date: Wed, 1 Feb 2012 02:44:09 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Q] Interleaved formats on the media bus
In-Reply-To: <4F27CF29.5090905@samsung.com>
Message-ID: <Pine.LNX.4.64.1202010159390.31226@axis700.grange>
References: <4F27CF29.5090905@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

On Tue, 31 Jan 2012, Sylwester Nawrocki wrote:

> Hi all,
> 
> Some camera sensors generate data formats that cannot be described using
> current convention of the media bus pixel code naming.
> For instance, interleaved JPEG data and raw VYUY. Moreover interleaving
> is rather vendor specific, IOW I imagine there might be many ways of how
> the interleaving algorithm is designed.
> 
> I'm wondering how to handle this. For sure such an image format will need
> a new vendor-specific fourcc. Should we have also vendor specific media bus code ?
> 
> I would like to avoid vendor specific media bus codes as much as possible.
> For instance defining something like
> 
> V4L2_MBUS_FMT_VYUY_JPEG_1X8

Hmm... Are such sensors not sending this data over something like CSI-2 
with different channel IDs? In which case we just deal with two formats 
cleanly.

Otherwise - I'm a bit sceptical about defining a new format for each pair 
of existing codes. Maybe we should rather try to describe individual 
formats and the way they are interleaved? In any case the end user will 
want them separately, right? So, at some point they will want to know what 
are those two formats, that the camera has sent.

No, I don't know yet how to describe this, proposals are welcome;-)

> for interleaved VYUY and JPEG data might do, except it doesn't tell anything
> about how the data is interleaved.
> 
> So maybe we could add some code describing interleaving (xxxx)
> 
> V4L2_MBUS_FMT_xxxx_VYUY_JPEG_1X8
> 
> or just the sensor name instead ?

As I said above, I would describe formats separately and the way, how they 
are interleaved. BTW, this might be related to recent patches from 
Laurent, introducing data layout in RAM and fixing bytesperline and 
sizeimage calculations.

Thanks
Guennadi

> Thoughts ?
> 
> 
> Regards,
> -- 
> Sylwester Nawrocki
> Samsung Poland R&D Center

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
