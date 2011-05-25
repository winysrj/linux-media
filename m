Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.8]:49570 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab1EYMLy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 May 2011 08:11:54 -0400
Date: Wed, 25 May 2011 14:11:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: Scott Jiang <scott.jiang.linux@gmail.com>,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	linux-media@vger.kernel.org
Subject: Re: v4l2_mbus_framefmt and v4l2_pix_format
In-Reply-To: <4DDCECDD.2030304@samsung.com>
Message-ID: <Pine.LNX.4.64.1105251355280.13724@axis700.grange>
References: <BANLkTikPGEgWH-ExjnSuH8-n0f2q54EJGQ@mail.gmail.com>
 <Pine.LNX.4.64.1105251202530.13724@axis700.grange> <4DDCECDD.2030304@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 25 May 2011, Sylwester Nawrocki wrote:

> Hi Guennadi,
> 
> On 05/25/2011 12:11 PM, Guennadi Liakhovetski wrote:
> > Hi Scott
> > 
> > On Wed, 25 May 2011, Scott Jiang wrote:
> > 
> >> Hi Hans and Laurent,
> >>
> >> I got fmt info from a video data source subdev, I thought there should
> >> be a helper function to convert these two format enums.
> >> However, v4l2_fill_pix_format didn't do this, why? Should I do this in
> >> bridge driver one by one?
> > 
> > Because various camera hosts (bridges) can produce different pixel formats 
> > in memory from the same mediabus code. However, there is a very common way 
> > to handle such video data in the bridge: store it in RAM in a "natural" 
> > way. This mode is called in soc-camera the pass-through mode and there is 
> > an API to handle this mode in drivers/media/video/soc_mediabus.c. If this 
> 
> Sorry about getting off the topic a bit.
> 
> As some media bus formats require different conversion process in the bridge
> to obtain specific format in memory (fourcc) I was wondering whether it would
> be reasonable to indicate the "natural" fourccs for the applications when
> enumerating formats supported by the bridge/DMA with VIDIOC_ENUM_FMT?
> So applications are aware what are the "natural" formats and which require
> lossy conversion. And in this way could choose formats that yield better
> quality. 

Yes, in principle this seems like a good idea to me. Of course, somebody 
will have to teach the user-space to use this information:)

> Now there are following flags available for struct v4l2_fmtdesc::flags
> 
> V4L2_FMT_FLAG_COMPRESSED
> V4L2_FMT_FLAG_EMULATED
> 
> I thought about something like V4L2_FMT_HW_EMULATED or V4L2_FMT_FLAG_LOW_QUALITY.
> 
> I not happy with those exact names but I hope that gives a basic idea what
> I am talking about.  
> Possibly I am missing other ways to achieve the same.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
