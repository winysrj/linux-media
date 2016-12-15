Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:47948 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755591AbcLOLmt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 06:42:49 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@osg.samsung.com, shuahkh@osg.samsung.com
Subject: Re: [RFC v3 21/21] omap3isp: Don't rely on devm for memory resource management
Date: Thu, 15 Dec 2016 13:42:44 +0200
Message-ID: <3081773.GUJA4mrXhH@avalon>
In-Reply-To: <20161215113956.GF16630@valkosipuli.retiisi.org.uk>
References: <1472255009-28719-1-git-send-email-sakari.ailus@linux.intel.com> <1551037.Hfmqsgr3In@avalon> <20161215113956.GF16630@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Thursday 15 Dec 2016 13:39:56 Sakari Ailus wrote:
> On Thu, Dec 15, 2016 at 01:23:50PM +0200, Laurent Pinchart wrote:
> > On Saturday 27 Aug 2016 02:43:29 Sakari Ailus wrote:
> >> devm functions are fine for managing resources that are directly related
> >> to the device at hand and that have no other dependencies. However, a
> >> process holding a file handle to a device created by a driver for a
> >> device may result in the file handle left behind after the device is long
> >> gone. This will result in accessing released (and potentially
> >> reallocated) memory.
> >> 
> >> Instead, rely on the media device which will stick around until all
> >> users are gone.
> > 
> > Could you move this patch to the beginning of the series to show that
> > converting the driver away from devm_* isn't enough to fix the problem
> > that the series tries to address ?
> 
> Unfortunately not. The patch depends on the previous patch; the
> isp_release() function is called once the last user of the device nodes (MC,
> V4L2 and V4L2 sub-dev) is gone.

You can split that part out. The devm_* removal is independent and could be 
moved to the beginning of the series.

> I'll also see what could be done based on Mauro's suggestion to move
> streamoff to device removal. That could fix a number of problems (but not
> all of them).

I'll reply to that separately but it's not the best idea.

> >> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >> ---
> >> 
> >>  drivers/media/platform/omap3isp/isp.c         | 38 +++++++++++++-------
> >>  drivers/media/platform/omap3isp/ispccp2.c     |  3 ++-
> >>  drivers/media/platform/omap3isp/isph3a_aewb.c | 20 +++++++++-----
> >>  drivers/media/platform/omap3isp/isph3a_af.c   | 20 +++++++++-----
> >>  drivers/media/platform/omap3isp/isphist.c     |  5 ++--
> >>  drivers/media/platform/omap3isp/ispstat.c     |  2 ++
> >>  6 files changed, 63 insertions(+), 25 deletions(-)

-- 
Regards,

Laurent Pinchart

