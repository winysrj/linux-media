Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:27512 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933975Ab2JYQ4w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 12:56:52 -0400
Date: Thu, 25 Oct 2012 09:56:44 -0700
From: Tony Lindgren <tony@atomide.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-arm-kernel@lists.infradead.org,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Omar Ramirez Luna <omar.luna@linaro.org>,
	linux-omap@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3/6] ARM: OMAP2+: Move plat/iovmm.h to
 include/linux/omap-iommu.h
Message-ID: <20121025165643.GP11928@atomide.com>
References: <20121025001913.2082.31062.stgit@muffinssi.local>
 <20121025002056.2082.45221.stgit@muffinssi.local>
 <1466344.HbU9q5zM1q@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1466344.HbU9q5zM1q@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Laurent Pinchart <laurent.pinchart@ideasonboard.com> [121025 01:39]:
> 
> I still think you should split this in two files, omap-iommu.h and omap-
> iovmm.h. The later would just be arch/arm/plat-omap/include/plat/iovmm.h moved 
> to include/linux.h.

Can you please explain a bit more why you're thinking a separate
omap-iovmm.h is needed in addtion to omap-iommu.h?

My reasoning for not adding it is that neither intel nor amd needs
more than intel-iommu.h and amd-iommu.h. And hopefully the iommu
framework will eventually provide the API needed. And I'd rather
not be the person introducing this second new file into
include/linux :)

Joerg and Ohad, do you have any opinions on this?

Regards,

Tony
