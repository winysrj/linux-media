Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:36654 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab2CGRyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 12:54:14 -0500
Date: Wed, 7 Mar 2012 19:54:09 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5 28/35] omap3isp: Use external rate instead of vpcfg
Message-ID: <20120307175409.GE1476@valkosipuli.localdomain>
References: <20120306163239.GN1075@valkosipuli.localdomain>
 <1331051596-8261-28-git-send-email-sakari.ailus@iki.fi>
 <2509531.N5XHlDPohC@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2509531.N5XHlDPohC@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 07, 2012 at 11:53:19AM +0100, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patch.
> 
> On Tuesday 06 March 2012 18:33:09 Sakari Ailus wrote:
> > From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> > 
> > Access pipe->external_rate instead of isp_ccdc.vpcfg.pixelclk. Also remove
> > means to set the value for isp_ccdc_vpcfg.pixelclk.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> 
> Very nice.
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> This also means that implementing support for the V4L2_CID_PIXEL_RATE control 
> is required in the sensor drivers to be used with the OMAP3 ISP. I'll submit 
> patches.

Thanks!

Let's see how we deal with the affected drivers...

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
