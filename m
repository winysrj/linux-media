Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:33358 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab1KPGxK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 01:53:10 -0500
Date: Wed, 16 Nov 2011 08:53:06 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sakari.ailus@maxwell.research.nokia.com
Subject: Re: [PATCH 0/9] as3645a: set of fixes up
Message-ID: <20111116065306.GB27021@valkosipuli.localdomain>
References: <1321374065-20063-3-git-send-email-laurent.pinchart@ideasonboard.com>
 <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1321379276.git.andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 15, 2011 at 07:49:52PM +0200, Andy Shevchenko wrote:
> This series incorporates Sakari's comments and couple of fixes from my version
> of the driver.
> 
> Andy Shevchenko (9):
>   as3645a: mention lm3555 as a clone of that chip
>   as3645a: print vendor and revision of the chip
>   as3645a: remove unused code
>   as3645a: No error, no message.
>   as3645a: move limits to the platform_data
>   as3645a: free resources in case of error properly
>   as3645a: use struct dev_pm_ops
>   as3645a: use pr_err macro instead of printk KERN_ERR
>   as3645a: use the same timeout for hw and sw strobes
> 
>  drivers/media/video/as3645a.c |   76 ++++++++++++++++++-----------------------
>  include/media/as3645a.h       |   32 +++++++----------
>  2 files changed, 46 insertions(+), 62 deletions(-)

Thanks for the patches, Andy!

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
