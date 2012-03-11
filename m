Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40357 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2CKQcM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Mar 2012 12:32:12 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5.4 35/35] smiapp: Add driver
Date: Sun, 11 Mar 2012 17:32:30 +0100
Message-ID: <3170989.o5epYuKlVd@avalon>
In-Reply-To: <1331477156-3989-1-git-send-email-sakari.ailus@iki.fi>
References: <4F5CB0C0.3010802@iki.fi> <1331477156-3989-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Sunday 11 March 2012 16:45:56 Sakari Ailus wrote:
> Add driver for SMIA++/SMIA image sensors. The driver exposes the sensor as
> three subdevs, pixel array, binner and scaler --- in case the device has a
> scaler.
> 
> Currently it relies on the board code for external clock handling. There is
> no fast way out of this dependency before the ISP drivers (omap3isp) among
> others will be able to export that clock through the clock framework
> instead.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
