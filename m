Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57910 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951Ab2JYUWA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 16:22:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Omar Ramirez Luna <omar.luna@linaro.org>,
	linux-omap@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] ARM: OMAP2+: Move plat/iovmm.h to include/linux/omap-iommu.h
Date: Thu, 25 Oct 2012 22:22:48 +0200
Message-ID: <1351198976.2hJjhe5gKC@avalon>
In-Reply-To: <20121025165643.GP11928@atomide.com>
References: <20121025001913.2082.31062.stgit@muffinssi.local> <1466344.HbU9q5zM1q@avalon> <20121025165643.GP11928@atomide.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tony,

On Thursday 25 October 2012 09:56:44 Tony Lindgren wrote:
> * Laurent Pinchart <laurent.pinchart@ideasonboard.com> [121025 01:39]:
> > I still think you should split this in two files, omap-iommu.h and omap-
> > iovmm.h. The later would just be arch/arm/plat-omap/include/plat/iovmm.h
> > moved to include/linux.h.
> 
> Can you please explain a bit more why you're thinking a separate
> omap-iovmm.h is needed in addtion to omap-iommu.h?

The IOVMM API is layered top of the IOMMU API. It's really a separate API, so 
two header files make sense. This patch creates a hybrid omap-iommu.h header 
with mixed definitions, it just doesn't feel right :-) I won't insist for a 
split though, if you think it's better to have a single header we can keep it 
that way.

> My reasoning for not adding it is that neither intel nor amd needs
> more than intel-iommu.h and amd-iommu.h. And hopefully the iommu
> framework will eventually provide the API needed. And I'd rather
> not be the person introducing this second new file into
> include/linux :)
> 
> Joerg and Ohad, do you have any opinions on this?

-- 
Regards,

Laurent Pinchart

