Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:62480 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208Ab2IRP0a (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Sep 2012 11:26:30 -0400
Date: Tue, 18 Sep 2012 17:26:24 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RFC] Processing context in the V4L2 subdev and V4L2 controls
 API ?
In-Reply-To: <50588E0E.9000307@samsung.com>
Message-ID: <Pine.LNX.4.64.1209181718090.31203@axis700.grange>
References: <50588E0E.9000307@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

On Tue, 18 Sep 2012, Sylwester Nawrocki wrote:

> Hi All,
> 
> I'm trying to fulfil following requirements with V4L2 API that are specific
> to most of Samsung camera sensors with embedded SoC ISP and also for local 
> SoC camera ISPs:
> 
>  - separate pixel format and pixel resolution needs to be configured
>    in a device for camera preview and capture;

Nice to see this topic come to light again:-) You certainly remember this 
short discussion

http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/40126

and preceding threads, where various related ideas have been discussed, I 
think, we already discussed this back in Warsaw and before that on the ML. 
So, I hope, this time we have a valid use-case for these contexts and they 
finally can be brought to an upstreamable implementation:-)

Good luck!
Guennadi

> 
>  - there is a need to set capture or preview mode in a device explicitly
>    as it makes various adjustments (in firmware) in each operation mode
>    and controls external devices accordingly (e.g. camera Flash);
> 
>  - some devices have more than two use case specific contexts that a user
>    needs to choose from, e.g. video preview, video capture, still preview, 
>    still capture; for each of these modes there are separate settings, 
>    especially pixel resolution and others corresponding to existing v4l2 
>    controls;
> 
>  - some devices can have two processing contexts enabled simultaneously,
>    e.g. a sensor emitting YUYV and JPEG streams simultaneously (please see 
>    discussion [1]).
> 
> This makes me considering making the v4l2 subdev (and maybe v4l2 controls)
> API processing (capture) context aware.
> 
> If I remember correctly introducing processing context, as the per file 
> handle device contexts in case of mem-to-mem devices was considered bad
> idea in past discussions. But this was more about v4ll2 video nodes.
> 
> And I was considering adding context only to v4l2 subdev API, and possibly
> to the (extended) control API. The idea is to extend the subdev (and 
> controls ?) ioctls so it is possible to preconfigure sets of parameters 
> on subdevs, while V4L2 video node parameters would be switched "manually"
> by applications to match a selected subdevs contest. There would also be
> needed an API to select specific context (e.g. a control), or maybe 
> multiple contexts like in case of a sensor from discussion [1].
> 
> I've seen various hacks in some v4l2 drivers trying to fulfil above
> requirements, e.g. abusing struct v4l2_mbus_framefmt::colorspace field
> to select between capture/preview in a device or using 32-bit integer
> control where upper 16-bits are used for pixel width and lower 16 for
> pixel height. This may suggest there something missing at the API.
> 
> Any suggestions, critics, please ?... :)
> 
> --
> 
> Regards,
> Sylwester
> 
> [1] http://www.mail-archive.com/linux-media@vger.kernel.org/msg42707.html
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
