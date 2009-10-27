Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:48604 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756124AbZJ0HtH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 03:49:07 -0400
Date: Tue, 27 Oct 2009 08:49:15 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
cc: Stefan.Kost@nokia.com, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl, sakari.ailus@maxwell.research.nokia.com,
	david.cohen@nokia.com, antti.koskipaa@nokia.com,
	vimarsh.zutshi@nokia.com
Subject: Re: [RFC] Global video buffers pool
In-Reply-To: <200909282354.25563.laurent.pinchart@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.0910270828040.4828@axis700.grange>
References: <200909161746.39754.laurent.pinchart@ideasonboard.com>
 <D019E777779A4345963526A1797F28D409E78C5B57@NOK-EUMSG-02.mgdnok.nokia.com>
 <200909282354.25563.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

This is a general comment to the whole "(contiguous) video buffer" work: 
having given a talk at the ELC-E in Grenoble on soc-camera, I mentioned 
briefly a few related RFCs, including this one. I've got a couple of 
comments back, including the following ones (which is to say, opinions are 
not mine and may or may not be relevant, I'm just fulfilling my promise to 
pass them on;)):

1) has been requested to move this discussion to a generic mailing list 
like LKML.

2) the reason for (1) was, obviously, to consider making such a buffer 
pool also available to other subsystems, of which video / framebuffer 
drivers have been mentioned as likely interested parties.

(btw, not sure if this has also been mentioned among those wishes - what 
about DVB? Can they also use such buffers?)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
