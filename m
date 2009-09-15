Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:40911 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbZIOLfi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 07:35:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: Re: RFCv2: Media controller proposal
Date: Tue, 15 Sep 2009 13:36:34 +0200
Cc: "Patrick Boettcher" <pboettcher@kernellabs.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
References: <200909100913.09065.hverkuil@xs4all.nl> <alpine.LRH.1.10.0909101604280.5940@pub3.ifh.de> <2830b427fef295eeb166dbd2065392ce.squirrel@webmail.xs4all.nl>
In-Reply-To: <2830b427fef295eeb166dbd2065392ce.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909151336.34871.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 10 September 2009 17:00:40 Hans Verkuil wrote:
> > On Thu, 10 Sep 2009, Hans Verkuil wrote:
> > > > Could entities not be completely addressed (configuration ioctls)
> > > > through the mc-node?
> > >
> > > Not sure what you mean.
> >
> > Instead of having a device node for each entity, the ioctls for each
> > entities are done on the media controller-node address an entity by ID.
> 
> I definitely don't want to go there. Use device nodes (video, fb, alsa,
> dvb, etc) for streaming the actual media as we always did and use the
> media controller for controlling the board. It keeps everything nicely
> separate and clean.

I agree with this, but I think it might be what Patrick meant as well.

Beside enumeration and link setup, the media controller device will allow 
direct access to entities to get/set controls and formats. As such its API 
will overlap with the V4L2 control and format API. This is not a problem at 
all, both having different use cases (control/format at the V4L2 level are 
meant for "simple" applications in a backward-compatible fashion, and 
control/format at the media controller level are meant for power users).

V4L2 devices will be used for streaming video as that's what they do best. We 
don't want a video streaming API at the media controller level (not completely 
true, as we are toying with the idea of shared video buffers, but that's for 
later).

In the long term I can imagine the V4L2 control/format ioctls being deprecated 
and all control/format access being done through the media controller. That's 
very long term though.

-- 
Laurent Pinchart
