Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43798 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab2CNJkU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Mar 2012 05:40:20 -0400
Received: by gghe5 with SMTP id e5so1571265ggh.19
        for <linux-media@vger.kernel.org>; Wed, 14 Mar 2012 02:40:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1331717620-30200-1-git-send-email-ajaykumar.rs@samsung.com>
References: <1331717620-30200-1-git-send-email-ajaykumar.rs@samsung.com>
Date: Wed, 14 Mar 2012 18:40:19 +0900
Message-ID: <CAH9JG2XD-1SYA4yK2b2piFVp3TLenjNPaYqvnNDH-hitsKnbcw@mail.gmail.com>
Subject: Re: [PATCH 0/1] media: video: s5p-g2d: Add Support for FIMG2D v4
 style H/W
From: Kyungmin Park <kyungmin.park@samsung.com>
To: Ajay Kumar <ajaykumar.rs@samsung.com>
Cc: linux-media@vger.kernel.org, k.debski@samsung.com,
	kgene.kim@samsung.com, s.nawrocki@samsung.com,
	es10.choi@samsung.com, sachin.kamat@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 3/14/12, Ajay Kumar <ajaykumar.rs@samsung.com> wrote:
> The existing G2D driver supports only FIMG2D v3 style H/W.
> This Patch modifies the existing G2D driver to
> support FIMG2D v4 style H/W. FIMG2D v4 is present in
> Exynos4x12 and Exynos52x0 boards.
>
> Differences between FIMG2Dv3 and FIMG2Dv4:
> 	--Default register values for SRC and DST type is different in v4.
> 	--The stretching(Scaling) logic is different in v4.
> 	--CACHECTRL_REG Register is not present in v4.
>
> Even though Exynos4x12 and Exynos52x0 have same FIMG2D v4 H/W, the source
> clock
> for fimg2d is present only in Exynos4x12. Exynos52x0 uses only gating clock.
> So, 3 type-id are defined inside the driver to distinguish between
> Exynos4210,
> Exynos4x12 and Exynos52x0.

It's not clear. I can't see the v4.0 at Spec.
exynos4210 uses v3.0
exynos4x12 uses v4.1

which SoC uses the v4.0?

Do you want to use v4.0 for exynos4x12 and v4.1 for exynos5250?

Thank you,
Kyungmin Park

>
> Ajay Kumar (1):
>   [PATCH 1/1]media: video: s5p-g2d: Add support for FIMG2D v4 H/W logic
>
>  drivers/media/video/s5p-g2d/g2d-hw.c   |   54 ++++++++++++++++++++++++++--
>  drivers/media/video/s5p-g2d/g2d-regs.h |    4 ++
>  drivers/media/video/s5p-g2d/g2d.c      |   61
> +++++++++++++++++++++++---------
>  drivers/media/video/s5p-g2d/g2d.h      |   10 +++++-
>  4 files changed, 107 insertions(+), 22 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
