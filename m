Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:57088 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab2BEAEi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2012 19:04:38 -0500
Date: Sun, 5 Feb 2012 01:04:30 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>,
	"Seung-Woo Kim/Mobile S/W Platform Lab(DMC)/E4"
	<sw0312.kim@samsung.com>, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [Q] Interleaved formats on the media bus
In-Reply-To: <4F2D5231.4000703@iki.fi>
Message-ID: <Pine.LNX.4.64.1202050046050.3770@axis700.grange>
References: <4F27CF29.5090905@samsung.com> <20120201100007.GA841@valkosipuli.localdomain>
 <4F2924F8.3040408@samsung.com> <4F2D14ED.8080105@iki.fi> <4F2D4E2D.1030107@gmail.com>
 <4F2D5231.4000703@iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 4 Feb 2012, Sakari Ailus wrote:

> Hi Sylwester,
> 
> Sylwester Nawrocki wrote:
> > On 02/04/2012 12:22 PM, Sakari Ailus wrote:

[snip]

> >> I'd be much in favour or using a separate channel ID as Guennadi asked;
> >> that way you could quite probably save one memory copy as well. But if
> >> the hardware already exists and behaves badly there's usually not much
> >> you can do about it.
> > 
> > As I explained above I suspect that the sensor sends each image data type
> > on separate channels (I'm not 100% sure) but the bridge is unable to DMA
> > it into separate memory regions.
> > 
> > Currently we have no support in V4L2 for specifying separate image data 
> > format per MIPI-CSI2 channel. Maybe the solution is just about that - 
> > adding support for virtual channels and a possibility to specify an image 
> > format separately per each channel ?
> > Still, there would be nothing telling how the channels are interleaved :-/
> 
> _If_ the sensor sends YUV and compressed JPEG data in separate CSI-2
> channels then definitely the correct way to implement this is to take
> this kind of setup into account in the frame format description --- we
> do need that quite badly.
> 
> However, this doesn't really help you with your current problem, and
> perhaps just creating a custom format for your sensor driver is the best
> way to go for the time being.

As fas as I understand, the problem is not the sensor but the bridge. So, 
following your logic you would have to create a new format for each sensor 
with similar capabilities, if you want to connect it to this bridge. This 
doesn't seem like a good idea to me.

May I again do some shameless self-advertising: soc-camera had to deal 
with this kind of problem since some time and we have a solution for it.

The problem is actually not _quite_ identical, it has nothing to do with 
interleaved formats, but I think, essentially the problem is: how to 
configure bridges to process some generic (video) data when no specialised 
support for this data format is available or implemented yet. This is what 
we call a pass-through mode. All bridges I've met so far have a capability 
to receive and store in memory some generic video data, for which you 
basically just configure the number of bytes per line and the number of 
lines per frame.

The solution, that we use in soc-camera is to define format descriptors, 
that can be used to calculate those generic parameters for each supported 
format. I am talking about the mbus_fmt[] array and the 
soc_mbus_bytes_per_line() function in soc_mediabus.c. So, my suggestion 
would be to use something similar for this case too: use some high-level 
description for this format, including any channel information, that 
advanced bridges can use to properly separate the date, and a function, 
that interprets that high-level description and provides the low-level 
details like bytes-per-line, necessary to configure bridges, unable to 
handle the data natively. Ideally, of course, I would suggest to convert 
that file to a generic API, usable for all V4L2 drivers (basically, just 
rename a couple of structs and functions) and extend it to handle 
interleaved formats.

> But. When someone attaches this kind of
> sensor to another CSI-2 receiver that can separate the data from
> different channels, I think we should start working towards for a
> correct solution which this driver also should support.

Exactly.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
