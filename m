Return-path: <mchehab@pedra>
Received: from ams-iport-2.cisco.com ([144.254.224.141]:58034 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab1F2K7j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2011 06:59:39 -0400
From: Hans Verkuil <hansverk@cisco.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC PATCH] Add support for V4L2_EVENT_SUB_FL_NO_FEEDBACK
Date: Wed, 29 Jun 2011 12:53:32 +0200
Cc: "Hans Verkuil" <hverkuil@xs4all.nl>,
	"linux-media" <linux-media@vger.kernel.org>
References: <201106281718.07158.hverkuil@xs4all.nl> <3a51f8dd0eaf0a5f8e3a86c1500648d3.squirrel@webmail.xs4all.nl> <201106291230.26516.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201106291230.26516.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106291253.32924.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, June 29, 2011 12:30:26 Laurent Pinchart wrote:
> Hi Hans,
> 
> On Wednesday 29 June 2011 12:06:57 Hans Verkuil wrote:
> > > On Tuesday 28 June 2011 17:18:07 Hans Verkuil wrote:
> > >> Originally no control events would go to the filehandle that called the
> > >> VIDIOC_S_CTRL/VIDIOC_S_EXT_CTRLS ioctls. This was to prevent a feedback
> > >> loop.
> > >> 
> > >> This is now only done if the new V4L2_EVENT_SUB_FL_NO_FEEDBACK flag is
> > >> set.
> > > 
> > > What about doing it the other way around ? Most applications won't want
> > > that feedback, you could disable it by default.
> > 
> > I thought about that, but that's harder to explain since that flag would
> > then suppress an exception to the normal handling of event.
> > 
> > It's easier to say: events are sent to everyone, but if you set this flag,
> > then we make this exception.
> 
> Events are sent to everyone but you, but if you set this flag, you get them 
as 
> well.

I thought about it a bit more, and a better reason for changing this to 
ALLOW_FEEDBACK is that it forces you to think about the consequences of 
setting this flag.

I'll change it.

Regards,

	Hans

> It's not that hard ;-)
> 
> > I suspect that most applications do not need to set this flag anyway, only
> > applications like qv4l2 that create a control panel need it.
> 
> Most applications won't need events for controls they modify themselves. 
While 
> this might not break them, it would still be a waste of resources.
> 
> -- 
> Regards,
> 
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
