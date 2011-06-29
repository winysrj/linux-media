Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52910 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab1F2KaL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 06:30:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: [RFC PATCH] Add support for V4L2_EVENT_SUB_FL_NO_FEEDBACK
Date: Wed, 29 Jun 2011 12:30:26 +0200
Cc: "linux-media" <linux-media@vger.kernel.org>
References: <201106281718.07158.hverkuil@xs4all.nl> <201106291157.02631.laurent.pinchart@ideasonboard.com> <3a51f8dd0eaf0a5f8e3a86c1500648d3.squirrel@webmail.xs4all.nl>
In-Reply-To: <3a51f8dd0eaf0a5f8e3a86c1500648d3.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291230.26516.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Wednesday 29 June 2011 12:06:57 Hans Verkuil wrote:
> > On Tuesday 28 June 2011 17:18:07 Hans Verkuil wrote:
> >> Originally no control events would go to the filehandle that called the
> >> VIDIOC_S_CTRL/VIDIOC_S_EXT_CTRLS ioctls. This was to prevent a feedback
> >> loop.
> >> 
> >> This is now only done if the new V4L2_EVENT_SUB_FL_NO_FEEDBACK flag is
> >> set.
> > 
> > What about doing it the other way around ? Most applications won't want
> > that feedback, you could disable it by default.
> 
> I thought about that, but that's harder to explain since that flag would
> then suppress an exception to the normal handling of event.
> 
> It's easier to say: events are sent to everyone, but if you set this flag,
> then we make this exception.

Events are sent to everyone but you, but if you set this flag, you get them as 
well.

It's not that hard ;-)

> I suspect that most applications do not need to set this flag anyway, only
> applications like qv4l2 that create a control panel need it.

Most applications won't need events for controls they modify themselves. While 
this might not break them, it would still be a waste of resources.

-- 
Regards,

Laurent Pinchart
