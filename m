Return-path: <linux-media-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:35699 "EHLO muru.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbbGPM6E (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 08:58:04 -0400
Date: Thu, 16 Jul 2015 05:58:00 -0700
From: Tony Lindgren <tony@atomide.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/2] ARM: OMAP2+: Remove legacy OMAP3 ISP instantiation
Message-ID: <20150716125800.GN17550@atomide.com>
References: <1437051319-9904-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1437051319-9904-2-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1437051319-9904-2-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Laurent Pinchart <laurent.pinchart@ideasonboard.com> [150716 05:57]:
> The OMAP3 ISP is now fully supported in DT, remove its instantiation
> from C code.

Please feel to queue this along with the second patch in this series,
this should not cause any merge conflicts:

Acked-by: Tony Lindgren <tony@atomide.com>
