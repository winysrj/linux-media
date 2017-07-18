Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60742 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751402AbdGRTkx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 18 Jul 2017 15:40:53 -0400
Date: Tue, 18 Jul 2017 22:40:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>, pavel@ucw.cz,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 6/7] omap3isp: Correctly put the last iterated endpoint
 fwnode always
Message-ID: <20170718194049.2c4tfqvm32c5w572@valkosipuli.retiisi.org.uk>
References: <20170717220116.17886-1-sakari.ailus@linux.intel.com>
 <20170717220116.17886-7-sakari.ailus@linux.intel.com>
 <5887799.m7Z6mdmlWv@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5887799.m7Z6mdmlWv@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 18, 2017 at 11:40:22AM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the patch.
> 
> On Tuesday 18 Jul 2017 01:01:15 Sakari Ailus wrote:
> > Put the last endpoint fwnode if there are too many endpoints to handle.
> > Also tell the user about about the condition.
> > 
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> There are so many refcount-related issues with fwnodes, I wonder whether we 
> could/should teach a static analyzer about that.

This will be actually soon replaced by a convenience function in the
frameworks in my recent RFC patchset.

I'll drop this patch (as I'll do the first one).

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
