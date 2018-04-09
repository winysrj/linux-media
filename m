Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:59868 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751609AbeDIJfJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Apr 2018 05:35:09 -0400
Date: Mon, 9 Apr 2018 06:35:02 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] v4l: omap3isp: Enable driver compilation on ARM with
 COMPILE_TEST
Message-ID: <20180409063502.730fc019@vento.lan>
In-Reply-To: <20180407114008.6707-1-laurent.pinchart@ideasonboard.com>
References: <20180407114008.6707-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat,  7 Apr 2018 14:40:08 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> The omap3isp driver can't be compiled on non-ARM platforms but has no
> compile-time dependency on OMAP. It however requires common clock
> framework support, which isn't provided by all ARM platforms.
> 
> Drop the OMAP dependency when COMPILE_TEST is set and add ARM and
> COMMON_CLK dependencies.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  drivers/media/platform/Kconfig | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> Hi Mauro,
> 
> While we continue the discussions on whether the ARM IOMMU functions should be
> stubbed in the omap3isp driver itself or not, I propose already merging this
> patch that will extend build coverage for the omap3isp driver. Extending
> compilation to non-ARM platforms can then be added on top, depending on the
> result of the discussion.

Ok, I'll add it before the patch with the approach proposed by Arnd.

> You might have noticed the 0-day build bot report reporting that the driver
> depends on the common clock framework (build failure on openrisc). The issue
> affects ARM as well as not all ARM platforms use the common clock framework.
> I've thus also added a dependency on COMMON_CLK. Note that this dependency can
> prevent compilation on x86 platforms.

Actually, it doesn't. COMMON_CLK can be selected on x86. It actually
doesn't depend on anything. So, build failures due to that happens
only with randconfigs.

So, it is fine to make OMAP3ISP depending on COMMON_CLK.

Thanks,
Mauro
