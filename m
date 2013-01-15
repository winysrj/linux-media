Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:55163 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390Ab3AOBKb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jan 2013 20:10:31 -0500
Received: by mail-pb0-f51.google.com with SMTP id ro12so2472859pbb.38
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2013 17:10:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1357652634-17668-1-git-send-email-laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
References: <1357652634-17668-1-git-send-email-laurent.pinchart@ideasonboard.com>
Message-ID: <20130115011015.23734.75232@quantum>
Subject: Re: [PATCH 0/2] OMAP3 ISP: Simplify clock usage
Date: Mon, 14 Jan 2013 17:10:15 -0800
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quoting Laurent Pinchart (2013-01-08 05:43:52)
> Hello,
> 
> Now that the OMAP3 supports the common clock framework, clock rate
> back-propagation is available for the ISP clocks. Instead of setting the
> cam_mclk parent clock rate to control the cam_mclk clock rate, we can mark the
> dpll4_m5x2_ck_3630 and cam_mclk clocks as supporting back-propagation, and set
> the cam_mclk rate directly. This simplifies the ISP clocks configuration.
>

I'm pleased to see this feature get used on OMAP.  Plus your driver gets
a negative diffstat :)

Reviewed-by: Mike Turquette <mturquette@linaro.org>
 
> Laurent Pinchart (2):
>   ARM: OMAP3: clock: Back-propagate rate change from cam_mclk to
>     dpll4_m5
>   omap3isp: Set cam_mclk rate directly
> 
>  arch/arm/mach-omap2/cclock3xxx_data.c |   10 +++++++++-
>  drivers/media/platform/omap3isp/isp.c |   18 ++----------------
>  drivers/media/platform/omap3isp/isp.h |    8 +++-----
>  3 files changed, 14 insertions(+), 22 deletions(-)
> 
> -- 
> Regards,
> 
> Laurent Pinchart
