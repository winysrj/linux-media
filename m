Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44920 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754952AbZJ1QhD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2009 12:37:03 -0400
Date: Wed, 28 Oct 2009 17:37:09 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: finalising soc-camera conversion to v4l2-subdev
Message-ID: <Pine.LNX.4.64.0910281653010.4524@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

As some of you will know, soc-camera framework is undergoing a conversion 
to the v4l2-subdev API. Most of the legacy soc-camera client API has been 
ported over to v4l2-subdev. Final conversion is blocked by missing 
functionality in the current v4l2 subsystem. Namely video bus 
configuration and data format negotiation. And from the progress of 
respective RFCs it looks like this could take a while to get them into the 
mainline, which is also understandable, given the amount of work. So, the 
question is - can we work out a way to finalise the porting yet before the 
final versions of those RFCs make it upstream? OTOH, we certainly do not 
want to have to create a solution, which will have to be thrown away 
completely later.

We could decide to

1. make bus configuration optional. If no data provided - use defaults.

2. use something like the proposed imagebus API for data format 
negotiation. Even if it will be eventually strongly modified for new 
"Media Controller & Co." APIs, it already exists, so, the time has already 
been spent on it, and mainlining it will not require much more time. But 
I'm open to other ideas too.

OR

3. use some intermediate solution - something, that we think will later 
allow an easy enough extension to the new APIs when they appear.

Opinions?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
