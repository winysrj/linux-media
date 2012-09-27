Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:50661 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751121Ab2I0X7k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Sep 2012 19:59:40 -0400
Date: Thu, 27 Sep 2012 16:59:37 -0700
From: Tony Lindgren <tony@atomide.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>, paul@pwsan.com
Subject: Re: [PATCH] omap3isp: Replace cpu_is_omap3630() with ISP revision
 check
Message-ID: <20120927235936.GV4840@atomide.com>
References: <20120926220018.GJ4840@atomide.com>
 <1348756698-23128-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348756698-23128-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Laurent Pinchart <laurent.pinchart@ideasonboard.com> [120927 07:38]:
> Drivers must not rely on cpu_is_omap* macros (they will soon become
> private). Use the ISP revision instead to identify the hardware.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Great, thanks for fixing this:

Acked-by: Tony Lindgren <tony@atomide.com>
