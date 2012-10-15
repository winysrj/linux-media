Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42451 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab2JOSpA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 14:45:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl, remi@remlab.net,
	daniel-gl@gmx.net, sylwester.nawrocki@gmail.com
Subject: Re: [RFC] Timestamps and V4L2
Date: Mon, 15 Oct 2012 20:45:45 +0200
Message-ID: <2316067.OFTCziv4Z5@avalon>
In-Reply-To: <20121015160549.GE21261@valkosipuli.retiisi.org.uk>
References: <20120920202122.GA12025@valkosipuli.retiisi.org.uk> <20121015160549.GE21261@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Monday 15 October 2012 19:05:49 Sakari Ailus wrote:
> Hi all,
> 
> As a summar from the discussion, I think we have reached the following
> conclusion. Please say if you agree or disagree with what's below. :-)
> 
> - The drivers will be moved to use monotonic timestamps for video buffers.
> - The user space will learn about the type of the timestamp through buffer
> flags.
> - The timestamp source may be made selectable in the future, but buffer
> flags won't be the means for this, primarily since they're not available on
> subdevs. Possible way to do this include a new V4L2 control or a new IOCTL.

That's my understanding as well. For the concept,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

