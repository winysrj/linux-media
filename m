Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:52874 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab1HMVeI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Aug 2011 17:34:08 -0400
Date: Sun, 14 Aug 2011 00:34:04 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, deepthy.ravi@ti.com
Subject: Re: [PATCH] omap3isp: Move platform data definitions from isp.h to
 media/omap3isp.h
Message-ID: <20110813213404.GC7436@valkosipuli.localdomain>
References: <1313181515-11120-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <20110813203739.GA7436@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110813203739.GA7436@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Aug 13, 2011 at 11:37:40PM +0300, Sakari Ailus wrote:
> Hi Laurent,

> On Fri, Aug 12, 2011 at 10:38:35PM +0200, Laurent Pinchart wrote:
> > drivers/media/video/omap3isp/isp.h is not a proper location for a header
> > that needs to be included from board code. Move the platform data
> > definitions to media/omap3isp.h.
> > 
> > Board code still needs to include isp.h to get the struct isp_device
> > definition and access OMAP3 ISP platform callbacks. Those callbacks will
> > be replaced by more generic code.
> 
> Thanks for the patch! I very much agree with the approach.

[clip]

> > +struct isp_platform_data {
> > +	struct isp_v4l2_subdevs_group *subdevs;
> > +	void (*set_constraints)(struct isp_device *isp, bool enable);
> > +};
> 
> I applied this to my rx51 tree (yeah, nasty out-of-tree stuff, for now), and
> get a bunch of errors, mostly because of missing definitions. Have you
> tested the patch somewhere? :-)
> 
> At least these should be present, I think:
> 
> - v4l2_dev_to_isp_device
> - isp_platform_callback
> - ISP_XCLK_*

After reading the patch description and some thought,

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
sakari.ailus@iki.fi
