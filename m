Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40098 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751Ab1JXIqv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Oct 2011 04:46:51 -0400
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"mchehab@redhat.com" <mchehab@redhat.com>
Date: Mon, 24 Oct 2011 14:16:43 +0530
Subject: RE: [GIT PULL for v3.2] OMAP_VOUT: Few cleaups and feature addition
Message-ID: <19F8576C6E063C45BE387C64729E739406C1010176@dbde02.ent.ti.com>
References: <1319285184-14605-1-git-send-email-hvaibhav@ti.com>
 <201110240922.45744.laurent.pinchart@ideasonboard.com>
 <19F8576C6E063C45BE387C64729E739406C1010164@dbde02.ent.ti.com>
 <201110241046.14485.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201110241046.14485.laurent.pinchart@ideasonboard.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> Sent: Monday, October 24, 2011 2:16 PM
> To: Hiremath, Vaibhav
> Cc: linux-media@vger.kernel.org; mchehab@redhat.com
> Subject: Re: [GIT PULL for v3.2] OMAP_VOUT: Few cleaups and feature
> addition
> 
> Hi Vaibhav,
> 
> On Monday 24 October 2011 10:18:32 Hiremath, Vaibhav wrote:
> > On Monday, October 24, 2011 12:53 PM Laurent Pinchart wrote:
> > > On Saturday 22 October 2011 14:06:24 hvaibhav@ti.com wrote:
> > > > Hi Mauro,
> > > >
> > > > The following changes since commit
> > > >
> > > > 35a912455ff5640dc410e91279b03e04045265b2: Mauro Carvalho Chehab (1):
> > > >         Merge branch 'v4l_for_linus' into staging/for_v3.2
> > > >
> > > > are available in the git repository at:
> > > >   git://arago-project.org/git/people/vaibhav/ti-psp-omap-video.git
> > > >
> > > > for-linux-media
> > > >
> > > > Archit Taneja (5):
> > > >       OMAP_VOUT: Fix check in reqbuf for buf_size allocation
> > > >       OMAP_VOUT: CLEANUP: Remove redundant code from omap_vout_isr
> > > >       OMAP_VOUT: Fix VSYNC IRQ handling in omap_vout_isr
> > > >       OMAP_VOUT: Add support for DSI panels
> > > >       OMAP_VOUT: Increase MAX_DISPLAYS to a larger value
> > >
> > > What about http://patchwork.linuxtv.org/patch/299/ ? Do you plan to
> push
> > > it
> > > through your tree, or should I push it through mine ?
> >
> > Oops,
> >
> > Missed it... Thanks for reminding me.
> 
> No worries.
> 
> > If you are about to send pull request then go ahead and merge it with
> your
> > patch-sets. OR I can also send another request for this patch alone.
> 
> I've got omap3-isp patches I'm about to send a pull request for, I'll add
> the
> omap_vout patch to the set.
> 

Thanks

Regards,
Vaibhav

> --
> Regards,
> 
> Laurent Pinchart
