Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:63343 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752669Ab2JYAZO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Oct 2012 20:25:14 -0400
Date: Wed, 24 Oct 2012 17:25:09 -0700
From: Tony Lindgren <tony@atomide.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Omar Ramirez Luna <omar.luna@linaro.org>,
	linux-omap@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] ARM: OMAP2+: Move plat/iovmm.h to
 include/linux/omap-iommu.h
Message-ID: <20121025002508.GH11928@atomide.com>
References: <20121018202707.11834.1438.stgit@muffinssi.local>
 <2071397.IU49JkAq1T@avalon>
 <20121024223412.GM5605@atomide.com>
 <2126833.cqGngBPXg2@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2126833.cqGngBPXg2@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Laurent Pinchart <laurent.pinchart@ideasonboard.com> [121024 16:54]:
> On Wednesday 24 October 2012 15:34:12 Tony Lindgren wrote:
> > 
> > BTW, doing a test compile on v3.7-rc2, I'm seeing the following warnings
> > for omap3isp for isp_video_ioctl_ops:
> > 
> > drivers/media/platform/omap3isp/ispvideo.c:1213: warning: initialization
> > from incompatible pointer type
> > drivers/media/platform/omap3isp/ispccdc.c:2303: warning: initialization
> > from incompatible pointer type
> > drivers/media/platform/omap3isp/ispccdc.c:2304: warning: initialization
> > from incompatible pointer type
> > drivers/media/platform/omap3isp/isph3a_aewb.c:282: warning: initialization
> > from incompatible pointer type
> > drivers/media/platform/omap3isp/isph3a_aewb.c:283: warning: initialization
> > from incompatible pointer type
> > drivers/media/platform/omap3isp/isph3a_af.c:347: warning: initialization
> > from incompatible pointer type
> > drivers/media/platform/omap3isp/isph3a_af.c:348: warning: initialization
> > from incompatible pointer type
> > drivers/media/platform/omap3isp/isphist.c:453: warning: initialization from
> > incompatible pointer type
> > drivers/media/platform/omap3isp/isphist.c:454: warning: initialization from
> > incompatible pointer type
> 
> I've just sent a pull request to linux-media for v3.7 with fixes for those.

OK thanks!

Tony
