Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:51218
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932418AbdBIUEn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2017 15:04:43 -0500
From: Thibault Saunier <thibault.saunier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        linux-media@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>
Subject: [PATCH v2 0/4] [media] Fixes for colorspace logic in exynos-gsc and s5p-mfc drivers
Date: Thu,  9 Feb 2017 17:04:16 -0300
Message-Id: <20170209200420.3046-1-thibault.saunier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v1:
  - Fix a silly build error that slipped in while rebasing the patches

Javier Martinez Canillas (1):
  [media] exynos-gsc: Use 576p instead 720p as a threshold for
    colorspaces

Thibault Saunier (3):
  [media] exynos-gsc: Respect userspace colorspace setting
  [media] s5p-mfc: Set colorspace in VIDIO_{G,TRY}_FMT
  [media] s5p-mfc: Always check and set 'v4l2_pix_format:field' field

 drivers/media/platform/exynos-gsc/gsc-core.c | 22 +++++++++++----
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c | 42 ++++++++++++++++++++++++++--
 2 files changed, 57 insertions(+), 7 deletions(-)

-- 
2.11.1

