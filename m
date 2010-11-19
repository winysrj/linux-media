Return-path: <mchehab@gaivota>
Received: from bear.ext.ti.com ([192.94.94.41]:59367 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755684Ab0KSQXw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 11:23:52 -0500
From: "Aguirre, Sergio" <saaguirre@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: David Cohen <david.cohen@nokia.com>,
	ext Lane Brooks <lane@brooks.nu>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 19 Nov 2010 10:23:45 -0600
Subject: RE: [omap3isp] Prefered patch base for latest code? (was: "RE:
 Translation faults with OMAP ISP")
Message-ID: <A24693684029E5489D1D202277BE8944850C08AF@dlee02.ent.ti.com>
References: <4CE16AA2.3000208@brooks.nu>
 <20101119151219.GC11586@esdhcp04381.research.nokia.com>
 <A24693684029E5489D1D202277BE8944850C085C@dlee02.ent.ti.com>
 <201011191716.23102.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201011191716.23102.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi Laurent,

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Friday, November 19, 2010 10:16 AM
> To: Aguirre, Sergio
> Cc: David Cohen; ext Lane Brooks; linux-media@vger.kernel.org
> Subject: Re: [omap3isp] Prefered patch base for latest code? (was: "RE:
> Translation faults with OMAP ISP")
> 
> Hi Sergio,
> 
> On Friday 19 November 2010 17:07:09 Aguirre, Sergio wrote:
> > Hi David and Laurent,
> >
> > <snip>
> >
> > > > Don't forget that Lane is using an older version of the OMAP3 ISP
> > > > driver. The bug might have been fixed in the latest code.
> > >
> > > Hm. We did fix some iommu faults.
> > > Maybe it's better to test a newer version instead.
> > > If you still see that bug using an up-to-date version, please report
> it
> > > and I can try to help you. :)
> >
> > How close is this tree from the latest internal version you guys work
> with?
> >
> > http://meego.gitorious.com/maemo-multimedia/omap3isp-rx51/commits/devel
> 
> There's less differences between gitorious and our internal tree than
> between
> linuxtv and our internal tree.

Ok, I guess I can treat above tree as an "omap3isp-next" tree then, to have
a sneak preview of what's coming ;)

> 
> > I have been basing my patches on top of this tree:
> >
> > http://git.linuxtv.org/pinchartl/media.git?h=refs/heads/media-0004-
> omap3isp
> >
> > Would it be better to be based on the gitorious tree instead?
> >
> > What do you think?
> 
> I will push a big patch that ports all the changes made to the MC and V4L2
> core, as well as omap3-isp driver, during public review to our internal
> tree
> early next week (should be on Monday). The trees will then get in sync.
> The
> gitorious tree will be updated as well.
> 
> Unless you want your patches to be applied before Monday, which won't
> happen
> anyway, please base them on the linuxtv tree :-)

Ok, sure. It's better for me, since the gitorious devel tree includes rx51
support which I don't even have a device to try it out :P

I'll continue to be based on media-0004-omap3isp branch then, and just watch
devel branch to know if I'm not doing something conflicting.

Regards,
Sergio
> 
> --
> Regards,
> 
> Laurent Pinchart
