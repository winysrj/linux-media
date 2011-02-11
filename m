Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46860 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab1BKNGC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Feb 2011 08:06:02 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Michael Jones <michael.jones@matrix-vision.de>
Subject: Re: [RFC] ISP lane shifter support
Date: Fri, 11 Feb 2011 14:06:04 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
References: <4D394675.90304@matrix-vision.de> <Pine.LNX.4.64.1101262218090.6179@axis700.grange> <4D552685.4040406@matrix-vision.de>
In-Reply-To: <4D552685.4040406@matrix-vision.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102111406.05322.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

On Friday 11 February 2011 13:07:33 Michael Jones wrote:
> On 01/27/2011 12:46 AM, Guennadi Liakhovetski wrote:
> > Looking at the "Data-Lane Shifter" table (12.27 in my datasheet, in the
> > "Bridge-Lane Shifter" chapter), I think, the first two columns are fixed
> > by the board design, right? So, our freedom lies only in one line there
> > and is a single parameter - the shift value. The output shifter (VPIN) is
> > independent from this one, but not unrelated. It seems logical to me to
> > relate the former one to CCDC's input pad, and the latter one to CCDC's
> > output pad. AFAIU, Laurent, your implementation in what concerns pad
> > configuration is: let the user configure all interfaces independently,
> > and first when we have to actually activate the pipeline (start
> > streaming or configure video buffers) we can verify, whether all parts
> > fit together.
> 
> I would like to add this lane shifter support.  Would you like me to
> implement it as Guennadi suggested- letting the user set all 3 CCDC pad
> formats arbitrarily and postpone the consistency checks to streamon time?

I've discussed this with Sakari Ailus, and we would implement it with 
different formats on the sensor output and the CCDC input. I'd like to get 
Hans Verkuil's opinion.

-- 
Regards,

Laurent Pinchart
