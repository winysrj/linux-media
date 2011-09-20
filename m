Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:52355 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752033Ab1ITXxD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 19:53:03 -0400
Date: Tue, 20 Sep 2011 16:52:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Deepthy Ravi <deepthy.ravi@ti.com>, mchehab@infradead.org,
	hvaibhav@ti.com, linux-media@vger.kernel.org,
	linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	m.szyprowski@samsung.com, g.liakhovetski@gmx.de,
	santosh.shilimkar@ti.com, khilman@deeprootsystems.com,
	david.woodhouse@intel.com, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 5/5] omap2plus_defconfig: Enable omap3isp and MT9T111
 sensor drivers
Message-ID: <20110920235254.GM2937@atomide.com>
References: <1316530612-23075-1-git-send-email-deepthy.ravi@ti.com>
 <1316530612-23075-6-git-send-email-deepthy.ravi@ti.com>
 <201109210113.49151.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109210113.49151.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Laurent Pinchart <laurent.pinchart@ideasonboard.com> [110920 15:40]:
> >  CONFIG_REGULATOR_TPS65023=y
> >  CONFIG_REGULATOR_TPS6507X=y
> > +CONFIG_MEDIA_SUPPORT=y
> > +CONFIG_MEDIA_CONTROLLER=y
> > +CONFIG_VIDEO_DEV=y
> > +CONFIG_VIDEO_V4L2_COMMON=y
> > +CONFIG_VIDEO_ALLOW_V4L1=y
> > +CONFIG_VIDEO_V4L1_COMPAT=y
> > +CONFIG_VIDEO_V4L2_SUBDEV_API=y
> > +CONFIG_VIDEO_MEDIA=y
> > +CONFIG_VIDEO_MT9T111=y
> > +CONFIG_VIDEO_OMAP3=y
> 
> Shouldn't they be compiled as modules instead ?

Yes, let's not apply this.

Tony
