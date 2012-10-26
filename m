Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50584 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab2JZFvR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Oct 2012 01:51:17 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so3306538iea.19
        for <linux-media@vger.kernel.org>; Thu, 25 Oct 2012 22:51:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121025213935.GD11928@atomide.com>
References: <20121025001913.2082.31062.stgit@muffinssi.local>
 <1466344.HbU9q5zM1q@avalon> <20121025165643.GP11928@atomide.com>
 <1351198976.2hJjhe5gKC@avalon> <20121025213935.GD11928@atomide.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 26 Oct 2012 07:50:56 +0200
Message-ID: <CAK=WgbaCM+MWiHARvdfaGL6w0c7g4_keAm0ADw1vkSeiZ0CZPw@mail.gmail.com>
Subject: Re: [PATCH 3/6] ARM: OMAP2+: Move plat/iovmm.h to include/linux/omap-iommu.h
To: Tony Lindgren <tony@atomide.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-arm-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Omar Ramirez Luna <omar.luna@linaro.org>,
	linux-omap@vger.kernel.org, Ido Yariv <ido@wizery.com>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 25, 2012 at 11:39 PM, Tony Lindgren <tony@atomide.com> wrote:
>> > Joerg and Ohad, do you have any opinions on this?

I agree that there's some merit in having a separate header file for
IOVMM, since it's a different layer from the IOMMU API.

But in reality it's tightly coupled with OMAP's IOMMU, and ideally it
really should go away and be replaced with the DMA API.

For this reason, and for the fact that anyway there's only a single
user for it (omap3isp) and there will never be any more, maybe we
shouldn't pollute include/linux anymore.

Anyone volunteering to remove IOVMM and adapt omap3isp to the DMA API
instead ? ;)

Thanks,
Ohad.
