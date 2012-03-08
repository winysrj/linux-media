Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50650 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2CHOiZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Mar 2012 09:38:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Subject: Re: [PATCH v5.1 34/35] smiapp: Generic SMIA++/SMIA PLL calculator
Date: Thu, 08 Mar 2012 15:38:45 +0100
Message-ID: <2338182.m4p3vRkuCF@avalon>
In-Reply-To: <1331215050-20823-1-git-send-email-sakari.ailus@iki.fi>
References: <1960253.l1xo097dr7@avalon> <1331215050-20823-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Thursday 08 March 2012 15:57:29 Sakari Ailus wrote:
> From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> 
> Calculate PLL configuration based on input data: sensor configuration, board
> properties and sensor-specific limits.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

[snip]

> diff --git a/drivers/media/video/smiapp-pll.c
> b/drivers/media/video/smiapp-pll.c new file mode 100644
> index 0000000..c8ffdc9
> --- /dev/null
> +++ b/drivers/media/video/smiapp-pll.c

[snip]

> +	/*
> +	 * Find pix_div such that a legal pix_div * sys_div results
> +	 * into a value which is not smaller than div, the desired
> +	 * divisor.
> +	 */
> +	for (vt_div = min_vt_div; vt_div <= max_vt_div;
> +	     vt_div += 2 - (vt_div & 1)) {
> +		for (sys_div = min_sys_div;
> +		     sys_div <= max_sys_div;
> +		     sys_div += 2 - (sys_div & 1)) {
> +			int pix_div = DIV_ROUND_UP(vt_div, sys_div);
> +
> +			if (pix_div <
> +			    limits->min_vt_pix_clk_div
> +			    || pix_div
> +			    > limits->max_vt_pix_clk_div) {

Maybe you should get some sleep, I've heard it helps memory ;-)

> +				dev_dbg(dev,
> +					"pix_div %d too small or too big (%d--%d)\n",
> +					pix_div,
> +					limits->min_vt_pix_clk_div,
> +					limits->max_vt_pix_clk_div);
> +				continue;
> +			}
> +
> +			/* Check if this one is better. */
> +			if (pix_div * sys_div
> +			    <= ALIGN(min_vt_div, best_pix_div))
> +				best_pix_div = pix_div;
> +		}
> +		if (best_pix_div < INT_MAX >> 1)
> +			break;
> +	}

-- 
Regards,

Laurent Pinchart

