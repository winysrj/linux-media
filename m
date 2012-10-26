Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:60471 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756698Ab2JZJys (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Oct 2012 05:54:48 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so3474720iea.19
        for <linux-media@vger.kernel.org>; Fri, 26 Oct 2012 02:54:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6561916.t72K1L6jg4@avalon>
References: <20121025001913.2082.31062.stgit@muffinssi.local>
 <20121025213935.GD11928@atomide.com> <CAK=WgbaCM+MWiHARvdfaGL6w0c7g4_keAm0ADw1vkSeiZ0CZPw@mail.gmail.com>
 <6561916.t72K1L6jg4@avalon>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 26 Oct 2012 11:54:28 +0200
Message-ID: <CAK=WgbY2-Ajm-2OSheOgLCd4589WKDSqqKjzHkE5Ogyp4puJ3g@mail.gmail.com>
Subject: Re: [PATCH 3/6] ARM: OMAP2+: Move plat/iovmm.h to include/linux/omap-iommu.h
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tony Lindgren <tony@atomide.com>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Omar Ramirez Luna <omar.luna@linaro.org>,
	linux-omap@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Fri, Oct 26, 2012 at 11:35 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> That's on my to-do list, as well as porting the OMAP3 ISP driver to videobuf2,
> adding DT support, moving to the common clock framework (when that will be
> available for the OMAP3), supporting missing V4L2 features, ... All this in my
> spare time of course, otherwise it wouldn't be fun, would it ? ;-)

Hmm, seems like a short to-do list ;)

> I would also like to move the tidspbridge to the DMA API, but I think we'll
> need to move step by step there, and using the OMAP IOMMU and IOVMM APIs as an
> intermediate step would allow splitting patches in reviewable chunks. I know
> it's a step backwards in term of OMAP IOMMU usage, but that's in my opinion a
> temporary nuisance to make the leap easier.

Since tidspbridge is in staging I guess it's not a problem, though it
sounds to me like using the correct API in the first place is going to
make less churn.

Thanks,
Ohad.
