Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36334 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab2CELfy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Mar 2012 06:35:54 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com
Subject: Re: [PATCH v4 34/34] rm680: Add camera init
Date: Mon, 05 Mar 2012 12:36:13 +0100
Message-ID: <1463492.hYzTZPMTCH@avalon>
In-Reply-To: <1330709442-16654-34-git-send-email-sakari.ailus@iki.fi>
References: <20120302173219.GA15695@valkosipuli.localdomain> <1330709442-16654-34-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Friday 02 March 2012 19:30:42 Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> 
> This currently introduces an extra file to the arch/arm/mach-omap2
> directory: board-rm680-camera.c. Keeping the device tree in mind, the
> context of the file could be represented as static data with one exception:
> the external clock to the sensor.
> 
> This external clock is provided by the OMAP 3 SoC and required by the
> sensor. The issue is that the clock originates from the ISP and not from
> PRCM block as the other clocks and thus is not supported by the clock
> framework. Otherwise the sensor driver could just clk_get() and clk_enable()
> it, just like the regulators and gpios.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart

