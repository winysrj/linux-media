Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:38664 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbbCSRdZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Mar 2015 13:33:25 -0400
Date: Thu, 19 Mar 2015 10:28:44 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-omap@vger.kernel.org, sre@kernel.org, pali.rohar@gmail.com,
	laurent.pinchart@ideasonboard.com, t-kristo@ti.com,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 0/3] OMAP 3 ISP (and N9/N950 primary camera support)
 dts changes
Message-ID: <20150319172843.GH31346@atomide.com>
References: <1426722625-4132-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1426722625-4132-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Sakari Ailus <sakari.ailus@iki.fi> [150318 16:51]:
> Hi folks,
> 
> Since v1, I've rebased the set on Tero Kristo's PRCM / SCM cleanup patchset
> here:
> 
> <URL:http://www.spinics.net/lists/linux-omap/msg116949.html>
> 
> v1 can be found here:
> 
> <URL:http://www.spinics.net/lists/linux-omap/msg116753.html>
> 
> Changes since v1:
> 
> - Fixed phy reference (number to name) in the example,
> 
> - Dropped the first patch. This is already done by Tero's patch "ARM: dts:
>   omap3: merge control module features under scrm node".

Applying these into omap-for-v4.1/dt thanks.

Tony
