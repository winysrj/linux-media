Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:37675 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760051Ab3DDNKN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Apr 2013 09:10:13 -0400
Date: Thu, 4 Apr 2013 16:10:09 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Mike Turquette <mturquette@linaro.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v2 0/2] OMAP3 ISP common clock framework support
Message-ID: <20130404131009.GI10541@valkosipuli.retiisi.org.uk>
References: <1365076301-6542-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365076301-6542-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, Apr 04, 2013 at 01:51:39PM +0200, Laurent Pinchart wrote:
> Hello,
> 
> Here's the second version of the common clock framework support for the OMAP3
> ISP and MT9P031 drivers. They finally get rid of the last isp_platform_callback
> operation, and thus of the isp_platform_callback structure completely, as well
> as the only platform callback from the mt9p031 driver.
> 
> As with v1 the patches depend on Mike Turquette's common clock framework
> reentrancy patches:
> 
>   clk: abstract locking out into helper functions
>   clk: allow reentrant calls into the clk framework
> 
> v6 of those two patches has been posted to LKML and LAKML.
> 
> Changes since v1 are:
> 
> - Remove the unusued isp_xclk_init_data structure
> - Move a variable declaration inside a loop

Thanks! For the set:

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
