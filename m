Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:55341
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752513AbdBJOSs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Feb 2017 09:18:48 -0500
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
        Andrzej Hajda <a.hajda@samsung.com>,
        Jeongtae Park <jtp.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kamil Debski <kamil@wypas.org>
Subject: [PATCH v3 0/4] Fixes for colorspace logic in exynos-gsc and s5p-mfc drivers
Date: Fri, 10 Feb 2017 11:10:18 -0300
Message-Id: <20170210141022.25412-1-thibault.saunier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This patchset fixes a few issues on the colorspace logic for the exynos-gsc
and s5p-mfc drivers.

We now handle the colorspace in those drivers, and make sure to respect user setting if
possible.

We also now set the 'v4l2_pix_format:field' if userspace passed ANY, avoiding GStreamer
spamming error at us about the driver not following the standard.

This is the third version of the patch serie.

Best regards,

Thibault Saunier

Changes in v3:
- Added 'Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>'
- Do not check values in the g_fmt functions as Andrzej explained in previous review
- Set colorspace if user passed V4L2_COLORSPACE_DEFAULT in

Changes in v2:
- Fix a silly build error that slipped in while rebasing the patches

Javier Martinez Canillas (1):
  [media] exynos-gsc: Use 576p instead 720p as a threshold for
    colorspaces

Thibault Saunier (3):
  [media] exynos-gsc: Respect userspace colorspace setting in try_fmt
  [media] s5p-mfc: Set colorspace in VIDIO_{G,TRY}_FMT
  [media] s5p-mfc: Check and set 'v4l2_pix_format:field' field in
    try_fmt

 drivers/media/platform/exynos-gsc/gsc-core.c | 17 +++++++++++-----
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 29 ++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 5 deletions(-)

-- 
2.11.1

