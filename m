Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764471Ab3DDVZZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Apr 2013 17:25:25 -0400
Date: Thu, 4 Apr 2013 18:25:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, sakari.ailus@iki.fi,
	Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 0/2] OMAP3 ISP common clock framework support
Message-ID: <20130404182508.6f1baaa2@redhat.com>
In-Reply-To: <1365073719-8038-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1365073719-8038-1-git-send-email-laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu,  4 Apr 2013 13:08:37 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> Hello,
> 
> These two patches implement support for the common clock framework in the OMAP3
> ISP and MT9P031 drivers. They finally get rid of the last isp_platform_callback
> operation, and thus of the isp_platform_callback structure completely, as well
> as the only platform callback from the mt9p031 driver.
> 
> The patches depend on Mike Turquette's common clock framework reentrancy
> patches:
> 
>   clk: abstract locking out into helper functions
>   clk: allow reentrant calls into the clk framework
> 
> v6 of those two patches has been posted to LKML and LAKML.
> 
> Mauro, how would you like to proceed with merging these ? 

As discussed on IRC, just add those two patches on a branch based on
master. When asking me to pull from it, say that it should be a topic
branch that will depend on Mike's patches.

I'll hold them on a separate branch, sending them upstream only after
receiving an email from you or Mike that his patches got merged there
already.

> Mike, will the above
> two patches make it to v3.10 ? If so could you please provide a stable branch
> that Mauro could merge ?

Regards,
Mauro

> 
> Laurent Pinchart (2):
>   omap3isp: Use the common clock framework
>   mt9p031: Use the common clock framework
> 
>  drivers/media/i2c/mt9p031.c           |  22 ++-
>  drivers/media/platform/omap3isp/isp.c | 277 +++++++++++++++++++++++++---------
>  drivers/media/platform/omap3isp/isp.h |  22 ++-
>  include/media/mt9p031.h               |   2 -
>  include/media/omap3isp.h              |  10 +-
>  5 files changed, 240 insertions(+), 93 deletions(-)
> 


-- 

Cheers,
Mauro
