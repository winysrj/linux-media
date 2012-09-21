Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1265 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab2IUM0X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 08:26:23 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [RFC] Processing context in the V4L2 subdev and V4L2 controls API ?
Date: Fri, 21 Sep 2012 14:26:17 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	"Seung-Woo Kim" <sw0312.kim@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <50588E0E.9000307@samsung.com>
In-Reply-To: <50588E0E.9000307@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209211426.17235.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue September 18 2012 17:06:54 Sylwester Nawrocki wrote:
> Hi All,
> 
> I'm trying to fulfil following requirements with V4L2 API that are specific
> to most of Samsung camera sensors with embedded SoC ISP and also for local 
> SoC camera ISPs:
> 
>  - separate pixel format and pixel resolution needs to be configured
>    in a device for camera preview and capture;
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
> idea in past discussions.

I don't remember this. Controls can already be per-filehandle for m2m devices,
so for m2m devices I see no problem. For other devices it is a different matter,
though. The current V4L2 API does not allow per-filehandle contexts there.

> But this was more about v4ll2 video nodes.
> 
> And I was considering adding context only to v4l2 subdev API, and possibly
> to the (extended) control API. The idea is to extend the subdev (and 
> controls ?) ioctls so it is possible to preconfigure sets of parameters 
> on subdevs, while V4L2 video node parameters would be switched "manually"
> by applications to match a selected subdevs contest. There would also be
> needed an API to select specific context (e.g. a control), or maybe 
> multiple contexts like in case of a sensor from discussion [1].

We discussed the context idea before. The problem is how to implement it
in a way that still keeps things from becoming overly complex.

What I do not want to see is an API with large structs that contain the whole
context. That's a nightmare to maintain in the long run. So you want to be
able to use the existing API as much as possible and build up the context
bit by bit.

I don't think using a control to select contexts is a good idea. I think this
warrants one or more new ioctls.

What contexts would you need? What context operations do you need?

I would probably define a default or baseline context that all drivers have,
then create a CLONE_CONTEXT ioctl (cloning an existing context into a new one)
and an EDIT_CONTEXT ioctl (to edit an existing context) and any subsequent
ioctls will apply to that context. After the FINISH_CONTEXT ioctl the context
is finalized and any subsequent ioctls will apply again to the baseline context.
With APPLY_CONTEXT you apply a context to the baseline context and activate it.

Whether this context information is stored in the file handle (making it fh
specific) or globally is an interesting question to which I don't have an
answer.

This is just a quick brainstorm, but I think something like this might be
feasible.

> I've seen various hacks in some v4l2 drivers trying to fulfil above
> requirements, e.g. abusing struct v4l2_mbus_framefmt::colorspace field
> to select between capture/preview in a device or using 32-bit integer
> control where upper 16-bits are used for pixel width and lower 16 for
> pixel height.

Where is that? And what do you mean with pixel width and height? It this
used to define a pixel aspect ratio? Is this really related to context?

> This may suggest there something missing at the API.
> 
> Any suggestions, critics, please ?... :)

Regards,

	Hans
