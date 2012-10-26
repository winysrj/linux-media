Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55457 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab2JZJek (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Oct 2012 05:34:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Tony Lindgren <tony@atomide.com>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Omar Ramirez Luna <omar.luna@linaro.org>,
	linux-omap@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] ARM: OMAP2+: Move plat/iovmm.h to include/linux/omap-iommu.h
Date: Fri, 26 Oct 2012 11:35:22 +0200
Message-ID: <6561916.t72K1L6jg4@avalon>
In-Reply-To: <CAK=WgbaCM+MWiHARvdfaGL6w0c7g4_keAm0ADw1vkSeiZ0CZPw@mail.gmail.com>
References: <20121025001913.2082.31062.stgit@muffinssi.local> <20121025213935.GD11928@atomide.com> <CAK=WgbaCM+MWiHARvdfaGL6w0c7g4_keAm0ADw1vkSeiZ0CZPw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ohad,

On Friday 26 October 2012 07:50:56 Ohad Ben-Cohen wrote:
> On Thu, Oct 25, 2012 at 11:39 PM, Tony Lindgren <tony@atomide.com> wrote:
> >> > Joerg and Ohad, do you have any opinions on this?
> 
> I agree that there's some merit in having a separate header file for
> IOVMM, since it's a different layer from the IOMMU API.
> 
> But in reality it's tightly coupled with OMAP's IOMMU, and ideally it
> really should go away and be replaced with the DMA API.
> 
> For this reason, and for the fact that anyway there's only a single
> user for it (omap3isp) and there will never be any more, maybe we
> shouldn't pollute include/linux anymore.
> 
> Anyone volunteering to remove IOVMM and adapt omap3isp to the DMA API
> instead ? ;)

That's on my to-do list, as well as porting the OMAP3 ISP driver to videobuf2, 
adding DT support, moving to the common clock framework (when that will be 
available for the OMAP3), supporting missing V4L2 features, ... All this in my 
spare time of course, otherwise it wouldn't be fun, would it ? ;-)

I would also like to move the tidspbridge to the DMA API, but I think we'll 
need to move step by step there, and using the OMAP IOMMU and IOVMM APIs as an 
intermediate step would allow splitting patches in reviewable chunks. I know 
it's a step backwards in term of OMAP IOMMU usage, but that's in my opinion a 
temporary nuisance to make the leap easier.

-- 
Regards,

Laurent Pinchart

