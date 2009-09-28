Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:40022 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901AbZI1WO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 18:14:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: V4L-DVB Summit Day 3
Date: Tue, 29 Sep 2009 00:16:43 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <200909252322.26427.hverkuil@xs4all.nl> <Pine.LNX.4.64.0909261419220.4273@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0909261419220.4273@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909290016.43635.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Saturday 26 September 2009 14:25:07 Guennadi Liakhovetski wrote:
> On Fri, 25 Sep 2009, Hans Verkuil wrote:
> > - implement sensor v4l2_subdev support (Laurent). We are still missing
> > some v4l2_subdev sensor ops for setting up the bus config and data
> > format. Laurent will look into implementing those. An RFC for the bus
> > config already exists and will function as the basis of this.

I volunteered to port the sensor drivers we use with the OMAP3 to v4l2_subdev, 
implementing the missing operations/helpers/whatever on the way, but it 
somehow escaped my mind at the time that it included the bus config and data 
format operations :-)

> Good, obviously, I'm veryinterested in both these APIs, and I hope Laurent
> will have a look at my earlier imagebus proposal and use that API as a
> basis for the data format API. My RFC, probably, didn't cover all possible
> cases, but it should be a reasonable starting point with easy enough
> extensibility. I did get a couple of positive feedbacks regarding that
> API, and I have converted the whole soc-camera stack to it and am working
> on some new drivers with that API. So far I didn't have a single case
> where I would have to amend or extend it.

Your RFC will be used as a starting point (actually more than a starting 
point, as there has been lots of discussions around it already). My plan is to 
reuse what's available in RFCs as-is, port the drivers, see how everything 
shatters to pieces (hopefully it won't :-)), and post RFCs to fix the problems 
if required. You will of course be included in the discussion.

-- 
Regards,

Laurent Pinchart
