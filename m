Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.31]:4367 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731781AbeHCQLH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 3 Aug 2018 12:11:07 -0400
Date: Fri, 3 Aug 2018 17:14:29 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Ping-chung Chen <ping-chung.chen@intel.com>
Cc: linux-media@vger.kernel.org, andy.yeh@intel.com, jim.lai@intel.com,
        tfiga@chromium.org, grundler@chromium.org, rajmohan.mani@intel.com
Subject: Re: [RESEND PATCH v4] media: imx208: Add imx208 camera sensor driver
Message-ID: <20180803141428.jno2jgjo5xqca7gg@kekkonen.localdomain>
References: <1533265497-16718-1-git-send-email-ping-chung.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1533265497-16718-1-git-send-email-ping-chung.chen@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ping-chung,

On Fri, Aug 03, 2018 at 11:04:57AM +0800, Ping-chung Chen wrote:
> From: "Chen, Ping-chung" <ping-chung.chen@intel.com>
> 
> Add a V4L2 sub-device driver for the Sony IMX208 image sensor.
> This is a camera sensor using the I2C bus for control and the
> CSI-2 bus for data.
> 
> Signed-off-by: Ping-Chung Chen <ping-chung.chen@intel.com>
> ---
> since v1:
> -- Update the function media_entity_pads_init for upstreaming.
> -- Change the structure name mutex as imx208_mx.
> -- Refine the control flow of test pattern function.
> -- vflip/hflip control support (will impact the output bayer order)
> -- support 4 bayer orders output (via change v/hflip)
>     - SRGGB10(default), SGRBG10, SGBRG10, SBGGR10
> -- Simplify error handling in the set_stream function.
> since v2:
> -- Refine coding style.
> -- Fix the if statement to use pm_runtime_get_if_in_use().
> -- Print more error log during error handling.
> -- Remove mutex_destroy() from imx208_free_controls().
> -- Add more comments.
> since v3:
> -- Set explicit indices to link frequencies.

Could you add support for obtaining the link frequencies from firmware,
please?

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
