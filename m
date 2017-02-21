Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40835
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932138AbdBUTVS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Feb 2017 14:21:18 -0500
From: Thibault Saunier <thibault.saunier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Inki Dae <inki.dae@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>
Subject: [PATCH v5 0/3] Fixes for colorspace logic in exynos-gsc and s5p-mfc drivers
Date: Tue, 21 Feb 2017 16:20:56 -0300
Message-Id: <20170221192059.29745-1-thibault.saunier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patchset fixes a few issues on the colorspace logic for the exynos-gsc
and s5p-mfc drivers.

We now handle the colorspace in those drivers, and make sure to respect user setting if
possible.

We also now set the 'v4l2_pix_format:field' if userspace passed ANY, avoiding GStreamer
spamming error at us about the driver not following the standard.

This is the fifth version of the patch serie.

Best regards,

Thibault Saunier

Changes in v5:
- Squash commit to always use output colorspace on the capture side
  inside this one
- Fix typo in commit message
- Just adapt the field and never error out.

Changes in v4:
- Reword commit message to better back our assumptions on specifications
- Set the colorspace only if the user passed V4L2_COLORSPACE_DEFAULT, in
  all other cases just use what userspace provided.

Changes in v3:
- Do not check values in the g_fmt functions as Andrzej explained in previous review
- Added 'Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>'
- Do not check values in the g_fmt functions as Andrzej explained in previous review
- Set colorspace if user passed V4L2_COLORSPACE_DEFAULT in
- Do not check values in the g_fmt functions as Andrzej explained in previous review

Changes in v2:
- Fix a silly build error that slipped in while rebasing the patches

Thibault Saunier (3):
  [media] exynos-gsc: Use user configured colorspace if provided
  [media] s5p-mfc: Set colorspace in VIDIO_{G,TRY}_FMT if DEFAULT
    provided
  [media] s5p-mfc: Check and set 'v4l2_pix_format:field' field in
    try_fmt

 drivers/media/platform/exynos-gsc/gsc-core.c | 20 +++++++++++++++-----
 drivers/media/platform/exynos-gsc/gsc-core.h |  1 +
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 17 +++++++++++++++++
 3 files changed, 33 insertions(+), 5 deletions(-)

-- 
2.11.1
