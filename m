Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:47216 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab0KSQQW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 11:16:22 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Aguirre, Sergio" <saaguirre@ti.com>
Subject: Re: [omap3isp] Prefered patch base for latest code? (was: "RE: Translation faults with OMAP ISP")
Date: Fri, 19 Nov 2010 17:16:21 +0100
Cc: David Cohen <david.cohen@nokia.com>,
	ext Lane Brooks <lane@brooks.nu>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <4CE16AA2.3000208@brooks.nu> <20101119151219.GC11586@esdhcp04381.research.nokia.com> <A24693684029E5489D1D202277BE8944850C085C@dlee02.ent.ti.com>
In-Reply-To: <A24693684029E5489D1D202277BE8944850C085C@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011191716.23102.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Sergio,

On Friday 19 November 2010 17:07:09 Aguirre, Sergio wrote:
> Hi David and Laurent,
> 
> <snip>
> 
> > > Don't forget that Lane is using an older version of the OMAP3 ISP
> > > driver. The bug might have been fixed in the latest code.
> > 
> > Hm. We did fix some iommu faults.
> > Maybe it's better to test a newer version instead.
> > If you still see that bug using an up-to-date version, please report it
> > and I can try to help you. :)
> 
> How close is this tree from the latest internal version you guys work with?
> 
> http://meego.gitorious.com/maemo-multimedia/omap3isp-rx51/commits/devel

There's less differences between gitorious and our internal tree than between 
linuxtv and our internal tree.

> I have been basing my patches on top of this tree:
> 
> http://git.linuxtv.org/pinchartl/media.git?h=refs/heads/media-0004-omap3isp
> 
> Would it be better to be based on the gitorious tree instead?
> 
> What do you think?

I will push a big patch that ports all the changes made to the MC and V4L2 
core, as well as omap3-isp driver, during public review to our internal tree 
early next week (should be on Monday). The trees will then get in sync. The 
gitorious tree will be updated as well.

Unless you want your patches to be applied before Monday, which won't happen 
anyway, please base them on the linuxtv tree :-)

-- 
Regards,

Laurent Pinchart
