Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41067 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab2CHSFN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2012 13:05:13 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5.3 27/35] omap3isp: Introduce isp_video_check_external_subdevs()
Date: Thu, 08 Mar 2012 19:05:30 +0100
Message-ID: <6081097.ezx1Tdxi38@avalon>
In-Reply-To: <1331226264-6874-1-git-send-email-sakari.ailus@iki.fi>
References: <1513668.GA27SF7oCM@avalon> <1331226264-6874-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Thursday 08 March 2012 19:04:24 Sakari Ailus wrote:
> isp_video_check_external_subdevs() will retrieve external subdev's
> bits-per-pixel and pixel rate for the use of other ISP subdevs at streamon
> time. isp_video_check_external_subdevs() is called after pipeline
> validation.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

