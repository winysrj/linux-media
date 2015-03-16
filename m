Return-path: <linux-media-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:34133 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbCPHny (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 03:43:54 -0400
Date: Mon, 16 Mar 2015 16:43:12 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Josh Wu <josh.wu@atmel.com>
Subject: Re: [PATCH/RFC 4/4] soc-camera: Skip v4l2 clock registration if host
 doesn't provide clk ops
Message-ID: <20150316074306.GA18193@verge.net.au>
References: <1425883176-29859-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1425883176-29859-5-git-send-email-laurent.pinchart@ideasonboard.com>
 <Pine.LNX.4.64.1503151845220.13027@axis700.grange>
 <1634321.iE70ufz1gl@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1634321.iE70ufz1gl@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Mon, Mar 16, 2015 at 02:00:25AM +0200, Laurent Pinchart wrote:
> Hi Guennadi,
> 
> On Sunday 15 March 2015 18:56:44 Guennadi Liakhovetski wrote:
> > On Mon, 9 Mar 2015, Laurent Pinchart wrote:
> > > If the soc-camera host doesn't provide clock start and stop operations
> > > registering a v4l2 clock is pointless. Don't do it.
> > 
> > This can introduce breakage only for camera-host drivers, that don't
> > provide .clock_start() or .clock_stop(). After your other 3 patches from
> > this patch set there will be one such driver in the tree - rcar_vin.c. I
> > wouldn't mind this patch as long as we can have an ack from an rcar_vin.c
> > maintainer. Since I don't see one in MAINTAINERS, who can ack this? Simon?
> 
> I don't think we have an official maintainer. Maybe a Tested-by would be 
> enough in this case ?

I am quite happy to act as the maintainer of last resort for Renesas IP
blocks and to be listed in MAINTAINERS if that is helpful.

With regards to testing, I am also happy to help there, though in this
case I would appreciate some help with a test case.
