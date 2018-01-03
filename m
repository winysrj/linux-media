Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:19337 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750831AbeACVGO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 Jan 2018 16:06:14 -0500
Date: Wed, 3 Jan 2018 23:06:08 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Fabio Estevam <fabio.estevam@nxp.com>
Cc: mchehab@kernel.org, slongerbeam@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] media: ov5640: Check the return value from
 clk_prepare_enable()
Message-ID: <20180103210608.d5dkbscb4h3fz5uk@kekkonen.localdomain>
References: <1514998627-23843-1-git-send-email-fabio.estevam@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1514998627-23843-1-git-send-email-fabio.estevam@nxp.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

On Wed, Jan 03, 2018 at 02:57:07PM -0200, Fabio Estevam wrote:
> clk_prepare_enable() may fail, so we should better check its return value
> and propagate it in the case of error.
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>

Thanks for the patch. This particular issue appears to have been addressed
by Huguet's patch "media: ov5640: check chip id".

-- 
Kind regards,

Sakari Ailus
sakari.ailus@linux.intel.com
