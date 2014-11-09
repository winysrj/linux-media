Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54445 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaKIPgy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Nov 2014 10:36:54 -0500
Date: Sun, 9 Nov 2014 16:36:44 +0100
From: Philipp Zabel <pza@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Grant Likely <grant.likely@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	kernel@pengutronix.de
Subject: Re: [PATCH v5 1/6] of: Decrement refcount of previous endpoint in
 of_graph_get_next_endpoint
Message-ID: <20141109153644.GA3132@pengutronix.de>
References: <1412013819-29181-1-git-send-email-p.zabel@pengutronix.de>
 <1412013819-29181-2-git-send-email-p.zabel@pengutronix.de>
 <Pine.LNX.4.64.1411072255130.4252@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1411072255130.4252@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Fri, Nov 07, 2014 at 11:06:21PM +0100, Guennadi Liakhovetski wrote:
> Hi Philipp,
> 
> Thanks for the patch and sorry for a late reply. I did look at your 
> patches earlier too, but maybe not attentively enough, or maybe I'm 
> misunderstanding something now. In the scan_of_host() function in 
> soc_camera.c as of current -next I see:
> 
> 		epn = of_graph_get_next_endpoint(np, epn);
> 
> which already looks like a refcount leak to me. If epn != NULL, its 
> refcount is incremented, but then immediately the variable gets 
> overwritten, and there's no extra copy of that variable to fix this. If 
> I'm right, then that bug in itself should be fixed, ideally before your 
> patch is applied. But in fact, your patch fixes this, since it modifies 
> of_graph_get_next_endpoint() to return with prev's refcount not 
> incremented, right? Whereas the of_node_put(epn) later down in 
> scan_of_host() decrements refcount of the _next_ endpoint, not the 
> previous one, so, it should be left alone? I.e. AFAICT your modification 
> to of_graph_get_next_endpoint() fixes soc_camera.c with no further 
> modifications to it required?

You are right. With the old implementation, you'd have to do the
epn = of_graph_get_next_endpoint(np, prev); of_node_put(prev); prev = epn;
dance to avoid leaking a reference to the first endpoint. This series
accidentally fixes soc_camera by changing of_graph_get_next_endpoint
to decrement the reference count itself.

regards
Philipp
