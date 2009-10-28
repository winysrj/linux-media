Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:57505 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbZJ1POA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2009 11:14:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFC] Global video buffers pool
Date: Wed, 28 Oct 2009 16:14:40 +0100
Cc: Stefan.Kost@nokia.com, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl, sakari.ailus@maxwell.research.nokia.com,
	david.cohen@nokia.com, antti.koskipaa@nokia.com,
	vimarsh.zutshi@nokia.com
References: <200909161746.39754.laurent.pinchart@ideasonboard.com> <200909282354.25563.laurent.pinchart@ideasonboard.com> <Pine.LNX.4.64.0910270828040.4828@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.0910270828040.4828@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910281614.41060.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Tuesday 27 October 2009 08:49:15 Guennadi Liakhovetski wrote:
> Hi
> 
> This is a general comment to the whole "(contiguous) video buffer" work:
> having given a talk at the ELC-E in Grenoble on soc-camera, I mentioned
> briefly a few related RFCs, including this one. I've got a couple of
> comments back, including the following ones (which is to say, opinions are
> not mine and may or may not be relevant, I'm just fulfilling my promise to
> pass them on;)):
> 
> 1) has been requested to move this discussion to a generic mailing list
> like LKML.
>
> 2) the reason for (1) was, obviously, to consider making such a buffer
> pool also available to other subsystems, of which video / framebuffer
> drivers have been mentioned as likely interested parties.

Those are good ideas. The global video buffers pool will sooner or later (and 
my guess is sooner) need to interact with X buffers (either for Xv rendering, 
or opengl textures). This needs to be discussed globally on the LKML.
 
> (btw, not sure if this has also been mentioned among those wishes - what
> about DVB? Can they also use such buffers?)

If I'm not mistaken DVB uses read/write syscalls to transfer data from/to the 
driver. A video buffers pool wouldn't fit well in that scheme.

-- 
Regards,

Laurent Pinchart
