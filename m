Return-path: <linux-media-owner@vger.kernel.org>
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53848 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756568Ab1H3UjZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Aug 2011 16:39:25 -0400
Date: Tue, 30 Aug 2011 21:39:06 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	devicetree-discuss@lists.ozlabs.org,
	Sylwester Nawrocki <snjw23@gmail.com>,
	Tuukka Toivonen <tuukka.toivonen@intel.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [ANN] Meeting minutes of the Cambourne meeting
Message-ID: <20110830203906.GC14976@sirena.org.uk>
References: <201107261647.19235.laurent.pinchart@ideasonboard.com>
 <20110830201929.GS2061@opensource.wolfsonmicro.com>
 <CACxGe6v0Tm8oz5+vcrdjzk3x0DdvBoyeqEv=aZv=XEA=Ev7WpQ@mail.gmail.com>
 <201108302237.22468.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108302237.22468.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 30, 2011 at 10:37:21PM +0200, Laurent Pinchart wrote:
> On Tuesday 30 August 2011 22:35:59 Grant Likely wrote:

> > Yes. Aggregate devices are sufficiently complex that there is a strong
> > argument for using a node to describe one.

> Is there any document or sample implementation ?

ASoC.  Unfortunately there are several rather annoying problems in the
Linux device model which make this substantially less straightforward
than it might otherwise be, the main ones being waiting for everything
to probe and making sure everything suspends and resumes in the correct
order.
