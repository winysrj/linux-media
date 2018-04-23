Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway32.websitewelcome.com ([192.185.145.108]:42100 "EHLO
        gateway32.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932311AbeDWTOC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 15:14:02 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway32.websitewelcome.com (Postfix) with ESMTP id A7DF563C72
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 14:14:01 -0500 (CDT)
Subject: Re: [PATCH 00/11] fix potential Spectre variant 1 issues
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        =?UTF-8?Q?Niklas_S=c3=b6derlund?= <niklas.soderlund@ragnatech.se>,
        Jonathan Corbet <corbet@lwn.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
References: <cover.1524499368.git.gustavo@embeddedor.com>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <96bd3e25-9503-d23d-4e3c-091e68b6bf8f@embeddedor.com>
Date: Mon, 23 Apr 2018 14:13:58 -0500
MIME-Version: 1.0
In-Reply-To: <cover.1524499368.git.gustavo@embeddedor.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Please, drop this series. Further analysis is required as it seems all 
these are False Positives.

Sorry for the noise.

Thanks
--
Gustavo

On 04/23/2018 12:37 PM, Gustavo A. R. Silva wrote:
> This patchset aims to fix various media platform and media usb
> cases where we have user controlled array dereferences that could
> be exploited due to the Spectre variant 1 vulnerability. All were
> reported by Dan Carpenter.
> 
> Notice that given that speculation windows are large, the policy is
> to kill the speculation on the first load and not worry if it can be
> completed with a dependent load/store [1].
> 
> [1] https://marc.info/?l=linux-kernel&m=152449131114778&w=2
> 
> Thanks
> 
> Gustavo A. R. Silva (11):
>    media: tm6000: fix potential Spectre variant 1
>    exynos4-is: mipi-csis: fix potential Spectre variant 1
>    fsl-viu: fix potential Spectre variant 1
>    marvell-ccic: mcam-core: fix potential Spectre variant 1
>    omap_vout: fix potential Spectre variant 1
>    rcar-v4l2: fix potential Spectre variant 1
>    rcar_drif: fix potential Spectre variant 1
>    sh_vou: fix potential Spectre variant 1
>    vimc-debayer: fix potential Spectre variant 1
>    vivid-sdr-cap: fix potential Spectre variant 1
>    vsp1_rwpf: fix potential Spectre variant 1
> 
>   drivers/media/platform/exynos4-is/mipi-csis.c   | 5 ++++-
>   drivers/media/platform/fsl-viu.c                | 8 ++++----
>   drivers/media/platform/marvell-ccic/mcam-core.c | 3 +++
>   drivers/media/platform/omap/omap_vout.c         | 3 +++
>   drivers/media/platform/rcar-vin/rcar-v4l2.c     | 4 +++-
>   drivers/media/platform/rcar_drif.c              | 4 +++-
>   drivers/media/platform/sh_vou.c                 | 3 +++
>   drivers/media/platform/vimc/vimc-debayer.c      | 5 ++++-
>   drivers/media/platform/vivid/vivid-sdr-cap.c    | 6 ++++++
>   drivers/media/platform/vsp1/vsp1_rwpf.c         | 3 +++
>   drivers/media/usb/tm6000/tm6000-video.c         | 2 ++
>   11 files changed, 38 insertions(+), 8 deletions(-)
> 
