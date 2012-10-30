Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:20856 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754637Ab2J3Q3p (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Oct 2012 12:29:45 -0400
Date: Tue, 30 Oct 2012 09:29:38 -0700
From: Tony Lindgren <tony@atomide.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Omar Ramirez Luna <omar.luna@linaro.org>,
	linux-omap@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] ARM: OMAP2+: Move plat/iovmm.h to
 include/linux/omap-iommu.h
Message-ID: <20121030162938.GH11908@atomide.com>
References: <20121025001913.2082.31062.stgit@muffinssi.local>
 <20121025213935.GD11928@atomide.com>
 <CAK=WgbaCM+MWiHARvdfaGL6w0c7g4_keAm0ADw1vkSeiZ0CZPw@mail.gmail.com>
 <6561916.t72K1L6jg4@avalon>
 <CAK=WgbY2-Ajm-2OSheOgLCd4589WKDSqqKjzHkE5Ogyp4puJ3g@mail.gmail.com>
 <20121026180039.GM11908@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121026180039.GM11908@atomide.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Tony Lindgren <tony@atomide.com> [121026 11:02]:
> * Ohad Ben-Cohen <ohad@wizery.com> [121026 02:56]:
> > Hi Laurent,
> > 
> > On Fri, Oct 26, 2012 at 11:35 AM, Laurent Pinchart
> > <laurent.pinchart@ideasonboard.com> wrote:
> > > That's on my to-do list, as well as porting the OMAP3 ISP driver to videobuf2,
> > > adding DT support, moving to the common clock framework (when that will be
> > > available for the OMAP3), supporting missing V4L2 features, ... All this in my
> > > spare time of course, otherwise it wouldn't be fun, would it ? ;-)
> > 
> > Hmm, seems like a short to-do list ;)
> 
> Sounds Laurent will take care of it :)
> 
> > > I would also like to move the tidspbridge to the DMA API, but I think we'll
> > > need to move step by step there, and using the OMAP IOMMU and IOVMM APIs as an
> > > intermediate step would allow splitting patches in reviewable chunks. I know
> > > it's a step backwards in term of OMAP IOMMU usage, but that's in my opinion a
> > > temporary nuisance to make the leap easier.
> > 
> > Since tidspbridge is in staging I guess it's not a problem, though it
> > sounds to me like using the correct API in the first place is going to
> > make less churn.
> 
> Not related to these patches, but also sounds like we may need to drop
> some staging/tidspbridge code to be able to move forward with the
> ARM common zImage plans. See the "[GIT PULL] omap plat header removal
> for v3.8 merge window, part1" thread for more info.

OK so are people happy with the patches in this series?

Please everybody ack if no more comments so we can move on
towards getting CONFIG_MULTIPLATFORM to work for omaps.

Regards,

Tony
