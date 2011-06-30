Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:51327 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1F3F3A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Jun 2011 01:29:00 -0400
Date: Thu, 30 Jun 2011 08:28:56 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hansverk@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH] Add support for V4L2_EVENT_SUB_FL_NO_FEEDBACK
Message-ID: <20110630052856.GH12671@valkosipuli.localdomain>
References: <201106281718.07158.hverkuil@xs4all.nl>
 <3a51f8dd0eaf0a5f8e3a86c1500648d3.squirrel@webmail.xs4all.nl>
 <201106291230.26516.laurent.pinchart@ideasonboard.com>
 <201106291253.32924.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106291253.32924.hansverk@cisco.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, Jun 29, 2011 at 12:53:32PM +0200, Hans Verkuil wrote:
> On Wednesday, June 29, 2011 12:30:26 Laurent Pinchart wrote:
> > Hi Hans,
> > 
> > On Wednesday 29 June 2011 12:06:57 Hans Verkuil wrote:
> > > > On Tuesday 28 June 2011 17:18:07 Hans Verkuil wrote:
> > > >> Originally no control events would go to the filehandle that called the
> > > >> VIDIOC_S_CTRL/VIDIOC_S_EXT_CTRLS ioctls. This was to prevent a feedback
> > > >> loop.
> > > >> 
> > > >> This is now only done if the new V4L2_EVENT_SUB_FL_NO_FEEDBACK flag is
> > > >> set.
> > > > 
> > > > What about doing it the other way around ? Most applications won't want
> > > > that feedback, you could disable it by default.
> > > 
> > > I thought about that, but that's harder to explain since that flag would
> > > then suppress an exception to the normal handling of event.
> > > 
> > > It's easier to say: events are sent to everyone, but if you set this flag,
> > > then we make this exception.
> > 
> > Events are sent to everyone but you, but if you set this flag, you get them 
> as 
> > well.
> 
> I thought about it a bit more, and a better reason for changing this to 
> ALLOW_FEEDBACK is that it forces you to think about the consequences of 
> setting this flag.
> 
> I'll change it.

Thanks. I just read the thread, and agree to the conclusion. Doing it the
other way around might help producing a number of ill behaving applications.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
