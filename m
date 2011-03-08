Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:33959 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab1CHMw7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Mar 2011 07:52:59 -0500
Date: Tue, 08 Mar 2011 14:49:52 +0200 (EET)
Message-Id: <20110308.144952.775404351479802545.Hiroshi.DOYU@nokia.com>
To: dacohen@gmail.com, tony@atomide.com
Cc: linux-omap@vger.kernel.org, fernando.lugo@ti.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [PATCH 0/3] omap: iovmm: Fix IOVMM check for fixed 'da'
From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
In-Reply-To: <1299588365-2749-1-git-send-email-dacohen@gmail.com>
References: <1299588365-2749-1-git-send-email-dacohen@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

From: ext David Cohen <dacohen@gmail.com>
Subject: [PATCH 0/3] omap: iovmm: Fix IOVMM check for fixed 'da'
Date: Tue, 8 Mar 2011 14:46:02 +0200

> IOVMM driver checks input 'da == 0' when mapping address to determine whether
> user wants fixed 'da' or not. At the same time, it doesn't disallow address
> 0x0 to be used, what creates an ambiguous situation. This patch set moves
> fixed 'da' check to the input flags.
> It also fixes da_start value for ISP IOMMU instance.
> 
> David Cohen (2):
>   omap3: change ISP's IOMMU da_start address
>   omap: iovmm: don't check 'da' to set IOVMF_DA_FIXED/IOVMF_DA_ANON
>     flags
> 
> Michael Jones (1):
>   omap: iovmm: disallow mapping NULL address
> 
>  arch/arm/mach-omap2/omap-iommu.c |    2 +-
>  arch/arm/plat-omap/iovmm.c       |   28 ++++++++++++++++++----------
>  2 files changed, 19 insertions(+), 11 deletions(-)

Based on the previous discussion, those look ok for me.
