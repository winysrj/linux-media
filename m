Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:53976 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224Ab2AQUWm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Jan 2012 15:22:42 -0500
Date: Tue, 17 Jan 2012 22:22:39 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teturtia@gmail.com, dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@gmail.com, riverful@gmail.com
Subject: Re: [PATCH 19/23] omap3isp: Default error handling for ccp2, csi2,
 preview and resizer
Message-ID: <20120117202239.GG13236@valkosipuli.localdomain>
References: <4F0DFE92.80102@iki.fi>
 <1326317220-15339-19-git-send-email-sakari.ailus@iki.fi>
 <201201161550.08193.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201161550.08193.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 16, 2012 at 03:50:07PM +0100, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thanks for the patch.
> 
> On Wednesday 11 January 2012 22:26:56 Sakari Ailus wrote:
> > Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> > ---
> >  drivers/media/video/omap3isp/ispccp2.c    |    2 ++
> >  drivers/media/video/omap3isp/ispcsi2.c    |    2 ++
> >  drivers/media/video/omap3isp/isppreview.c |    2 ++
> >  drivers/media/video/omap3isp/ispresizer.c |    2 ++
> >  drivers/media/video/omap3isp/ispvideo.c   |   18 ++++++++----------
> >  5 files changed, 16 insertions(+), 10 deletions(-)
> 
> [snip]
> 
> Does the below code belong to this patch ? The commit message doesn't explain 
> why this is needed.

I separated these changes from the rest. I'll send a new patchset in the
near future.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
