Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:20287 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaCFPRf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 Mar 2014 10:17:35 -0500
Date: Thu, 06 Mar 2014 12:17:21 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Grant Likely <grant.likely@linaro.org>,
	Rob Herring <robh+dt@kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v6 0/8] Move device tree graph parsing helpers to drivers/of
Message-id: <20140306121721.6186dafb@samsung.com>
In-reply-to: <20140306141657.GB21483@n2100.arm.linux.org.uk>
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
 <53170C00.20200@ti.com> <1394030554.8754.31.camel@paszta.hi.pengutronix.de>
 <20140306141657.GB21483@n2100.arm.linux.org.uk>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 06 Mar 2014 14:16:57 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> escreveu:

> On Wed, Mar 05, 2014 at 03:42:34PM +0100, Philipp Zabel wrote:
> > Am Mittwoch, den 05.03.2014, 13:35 +0200 schrieb Tomi Valkeinen:
> > > Hi,
> > > 
> > > On 05/03/14 11:20, Philipp Zabel wrote:
> > > > Hi,
> > > > 
> > > > this version of the OF graph helper move series further addresses a few of
> > > > Tomi's and Sylwester's comments.
> > > > 
> > > > Changes since v5:
> > > >  - Fixed spelling errors and a wrong device node name in the link section
> > > >  - Added parentless previous endpoint's full name to warning
> > > >  - Fixed documentation comment for of_graph_parse_endpoint
> > > >  - Unrolled for-loop in of_graph_get_remote_port_parent
> > > > 
> > > > Philipp Zabel (8):
> > > >   [media] of: move graph helpers from drivers/media/v4l2-core to
> > > >     drivers/of
> > > >   Documentation: of: Document graph bindings
> > > >   of: Warn if of_graph_get_next_endpoint is called with the root node
> > > >   of: Reduce indentation in of_graph_get_next_endpoint
> > > >   [media] of: move common endpoint parsing to drivers/of
> > > >   of: Implement simplified graph binding for single port devices
> > > >   of: Document simplified graph binding for single port devices
> > > >   of: Warn if of_graph_parse_endpoint is called with the root node
> > > 
> > > So, as I've pointed out, I don't agree with the API, as it's too limited
> > > and I can't use it, but as this series is (mostly) about moving the
> > > current API to a common place, it's fine for me.
> > > 
> > > Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > 
> > Thanks. I'll be happy to help expanding the API to parse ports
> > individually, once this gets accepted.
> > 
> > Mauro, Guennadi, are you fine with how this turned out? I'd like to get
> > your acks again, for the changed location.

>From my side, there's nothing on such code that is V4L2 specific.
Moving it to drivers/of makes sense on my eyes.

Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
> I'll need those acks before I can even think about queuing up the
> imx-drm bits.
> 
> Another way to deal with this is if this gets pulled into the V4L tree
> from Philipp's git tree, I can also pull that in myself.  What mustn't
> happen is for these to be committed independently as patches.

If everyone agrees, I actually prefer have this patch applied on my tree,
in order to avoid some potential merge conflicts at the merge window,
as we might have other drivers and changes there touching on those API
calls (I'm aware of a series of patches from Sylwester with some DT
stuff on it. Not sure if it would be affected by such changes or not).

-- 

Cheers,
Mauro
