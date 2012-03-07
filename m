Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41805 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab2CGKw7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2012 05:52:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5 28/35] omap3isp: Use external rate instead of vpcfg
Date: Wed, 07 Mar 2012 11:53:19 +0100
Message-ID: <2509531.N5XHlDPohC@avalon>
In-Reply-To: <1331051596-8261-28-git-send-email-sakari.ailus@iki.fi>
References: <20120306163239.GN1075@valkosipuli.localdomain> <1331051596-8261-28-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Tuesday 06 March 2012 18:33:09 Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> 
> Access pipe->external_rate instead of isp_ccdc.vpcfg.pixelclk. Also remove
> means to set the value for isp_ccdc_vpcfg.pixelclk.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Very nice.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

This also means that implementing support for the V4L2_CID_PIXEL_RATE control 
is required in the sensor drivers to be used with the OMAP3 ISP. I'll submit 
patches.

-- 
Regards,

Laurent Pinchart

