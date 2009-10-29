Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:54329 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbZJ2LLN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Oct 2009 07:11:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: finalising soc-camera conversion to v4l2-subdev
Date: Thu, 29 Oct 2009 12:11:16 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
References: <Pine.LNX.4.64.0910281653010.4524@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0910281653010.4524@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910291211.16665.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Wednesday 28 October 2009 17:37:09 Guennadi Liakhovetski wrote:
> Hi all
> 
> As some of you will know, soc-camera framework is undergoing a conversion to
> the v4l2-subdev API. Most of the legacy soc-camera client API has been
> ported over to v4l2-subdev. Final conversion is blocked by missing
> functionality in the current v4l2 subsystem. Namely video bus configuration
> and data format negotiation. And from the progress of respective RFCs it
> looks like this could take a while to get them into the mainline, which is
> also understandable, given the amount of work. So, the question is - can we
> work out a way to finalise the porting yet before the final versions of
> those RFCs make it upstream? OTOH, we certainly do not want to have to
> create a solution, which will have to be thrown away completely later.

Right, but we could design a temporary solution that goes in the right 
direction and "fix" the code later. In that case the temporary solution must 
be clearly marked as such, as we don't want to keep it around for API and ABI 
compatibility reasons.

> We could decide to
> 
> 1. make bus configuration optional. If no data provided - use defaults.

Would that really work ?

> 2. use something like the proposed imagebus API for data format negotiation.
> Even if it will be eventually strongly modified for new "Media Controller &
> Co." APIs, it already exists, so, the time has already been spent on it, and
> mainlining it will not require much more time. But I'm open to other ideas
> too.
> 
> OR
> 
> 3. use some intermediate solution - something, that we think will later
> allow an easy enough extension to the new APIs when they appear.

2 and 3 are similar in my opinion. The current imagebus API proposal controls 
whole subdevices while it should act at the pad level. Pads will be introduced 
with the media controller, so we could

- use a subdev-level imagebus API, allowing the soc-camera conversion to 
subdev, and port the code to pad level latter, or

- introduce subdev pads operations now and use them for the imagebus API

The second solution would take more time as we need to agree on the subdev 
pads operations. I'm ok with the first solution, as long as you agree to port 
the code to the new subdev pads operations later :-)

-- 
Regards,

Laurent Pinchart
