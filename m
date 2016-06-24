Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:56382 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbcFXRbB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 13:31:01 -0400
Date: Fri, 24 Jun 2016 19:30:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 01/24] v4l: Add metadata buffer type and format
In-Reply-To: <a9c9ec51-15c3-675b-55cd-9b471b0ec20a@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1606241929430.23461@axis700.grange>
References: <1466449842-29502-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1466449842-29502-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <fcc32004-82dd-45af-a737-019f81dea8e0@xs4all.nl> <a9c9ec51-15c3-675b-55cd-9b471b0ec20a@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Fri, 24 Jun 2016, Hans Verkuil wrote:

> On 06/24/2016 05:57 PM, Hans Verkuil wrote:
> > On 06/20/2016 09:10 PM, Laurent Pinchart wrote:
> >> The metadata buffer type is used to transfer metadata between userspace
> >> and kernelspace through a V4L2 buffers queue. It comes with a new
> >> metadata capture capability and format description.
> >>
> >> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > 
> > I am willing to Ack this, provided Sakari and Guennadi Ack this as well. They know
> > more about metadata handling in various types of hardware than I do, so I feel
> > their Acks are important here.
> 
> Actually, I would like to see more about how applications can associate frames with
> metadata (if such a correspondence exists).

I think Laurent mentioned this in one of his patches, that the sequence 
number should be used to establish a correspondence, and this is also what 
my UVC patch does.

Thanks
Guennadi

> There was an irc discussion about that here:
> 
> https://linuxtv.org/irc/irclogger_log/v4l?date=2016-06-24,Fri
> 
> Guennadi's uvc patches may be useful as a testbed for figuring this out.
> 
> Regards,
> 
> 	Hans
> 
