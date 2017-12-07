Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:1921 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750744AbdLGHlj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 7 Dec 2017 02:41:39 -0500
Date: Thu, 7 Dec 2017 09:41:33 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Kieran Bingham <kbingham@kernel.org>
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        jacopo@jmondi.org, niklas.soderlund@ragnatech.se,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH v5] v4l2-async: Match parent devices
Message-ID: <20171207074133.lfz7yumr2je3tvec@kekkonen.localdomain>
References: <1512572319-20179-1-git-send-email-kbingham@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1512572319-20179-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 06, 2017 at 02:58:39PM +0000, Kieran Bingham wrote:
> From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> Devices supporting multiple endpoints on a single device node must set
> their subdevice fwnode to the endpoint to allow distinct comparisons.
> 
> Adapt the match_fwnode call to compare against the provided fwnodes
> first, but to also perform a cross reference comparison against the
> parent fwnodes of each other.
> 
> This allows notifiers to pass the endpoint for comparison and still
> support existing subdevices which store their default parent device
> node.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> ---
> 
> Hi Sakari,
> 
> Since you signed-off on this patch - it has had to be reworked due to the
> changes on the of_node_full_name() functionality.
> 
> I believe it is correct now to *just* do the pointer matching, as that matches
> the current implementation, and converting to device_nodes will be just as
> equal as the fwnodes, as they are simply containers.
> 
> Let me know if you are happy to maintain your SOB on this patch - and if we need
> to work towards getting this integrated upstream, especially in light of your new
> endpoint matching work.

I'd really want to avoid resorting to matching opportunistically --- please
see my reply to Niklas on "[RFC 1/1] v4l: async: Use endpoint node, not
device node, for fwnode match".

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
