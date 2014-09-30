Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48346 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaI3IJ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Sep 2014 04:09:29 -0400
Message-ID: <1412064370.3692.1.camel@pengutronix.de>
Subject: Re: [PATCH v5 1/6] of: Decrement refcount of previous endpoint in
 of_graph_get_next_endpoint
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Grant Likely <grant.likely@linaro.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	kernel@pengutronix.de
Date: Tue, 30 Sep 2014 10:06:10 +0200
In-Reply-To: <20140929221042.GA9895@kroah.com>
References: <1412013819-29181-1-git-send-email-p.zabel@pengutronix.de>
	 <1412013819-29181-2-git-send-email-p.zabel@pengutronix.de>
	 <20140929221042.GA9895@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 29.09.2014, 18:10 -0400 schrieb Greg Kroah-Hartman:
> On Mon, Sep 29, 2014 at 08:03:34PM +0200, Philipp Zabel wrote:
> > Decrementing the reference count of the previous endpoint node allows to
> > use the of_graph_get_next_endpoint function in a for_each_... style macro.
> > All current users of this function that pass a non-NULL prev parameter
> > (that is, soc_camera and imx-drm) are changed to not decrement the passed
> > prev argument's refcount themselves.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> > Changes since v4:
> >  - Folded patches 1-3 into this one
> > ---
> >  drivers/media/platform/soc_camera/soc_camera.c |  3 ++-
> >  drivers/of/base.c                              |  9 +--------
> >  drivers/staging/imx-drm/imx-drm-core.c         | 12 ++----------
> >  3 files changed, 5 insertions(+), 19 deletions(-)
> 
> No objection from me for this, but Grant is in "charge" of
> drivers/of/base.c, so I'll leave it for him to apply.
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thank you. Guennadi, Mauro, could I get your ack on the soc_camera part?

regards
Philipp

