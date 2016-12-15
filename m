Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:49916 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754132AbcLOXGd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 18:06:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: sakari.ailus@linux.intel.com, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] media: omap3isp change to devm for resources
Date: Fri, 16 Dec 2016 01:06:10 +0200
Message-ID: <3421880.AmHR8TnS5I@avalon>
In-Reply-To: <03073060-1166-7f61-8b3f-287a9f148b40@osg.samsung.com>
References: <cover.1481829721.git.shuahkh@osg.samsung.com> <2731467.skKvVxvkgN@avalon> <03073060-1166-7f61-8b3f-287a9f148b40@osg.samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Thursday 15 Dec 2016 15:51:41 Shuah Khan wrote:
> On 12/15/2016 03:33 PM, Laurent Pinchart wrote:
> > Hi Shuah,
> > 
> > Thank you for the patch.
> > 
> > Sakari has submitted a similar patch as part of his kref series. Please
> > use it as a base point and rework it if you want to get it merged
> > separately. I've reviewed the patch and left quite a few comments that
> > need to be addressed.
>
> I really don't mind if Sakari uses this patch as is and makes the changes
> you requested and submits devm removal as an independent patch.
> 
> My intent behind sending this one is to help him out since I already did
> this patch that is on top of 4.9-rc8 without any dependencies on Sakari's
> RFC patch.

I've only seen your reply to Sakari's patch after replying to this one. Thank 
you for providing your version, I'll let Sakari merge both and resubmit.

> > On Thursday 15 Dec 2016 12:40:08 Shuah Khan wrote:
> >> Using devm resources that have external dependencies such as a dev
> >> for a file handler could result in devm resources getting released
> >> durin unbind while an application has the file open holding pointer
> >> to the devm resource. This results in use-after-free errors when the
> >> application exits.
> >> 
> >> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> >> ---
> >> 
> >>  drivers/media/platform/omap3isp/isp.c         | 71 +++++++++++++--------
> >>  drivers/media/platform/omap3isp/ispccp2.c     | 10 +++-
> >>  drivers/media/platform/omap3isp/isph3a_aewb.c | 21 +++++---
> >>  drivers/media/platform/omap3isp/isph3a_af.c   | 21 +++++---
> >>  drivers/media/platform/omap3isp/isphist.c     |  5 +-
> >>  5 files changed, 92 insertions(+), 36 deletions(-)

-- 
Regards,

Laurent Pinchart

