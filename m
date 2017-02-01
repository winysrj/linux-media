Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:44665
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750990AbdBAUFm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 1 Feb 2017 15:05:42 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>,
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
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 0/2] [media] exynos-gsc: Fix support for NV21 and NV61 formats
Date: Wed,  1 Feb 2017 17:05:20 -0300
Message-Id: <1485979523-32404-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Commit 652bb68018a5 ("[media] exynos-gsc: do proper bytesperline and
sizeimage calculation") fixed corrupted frames for most exynos-gsc
formats, but even after that patch two issues were still remaining:

1) Frames were still not correct for NV21 and NV61 formats.
2) Y42B format didn't work when used as output (only as input).

This patch series fixes (1).

Best regards,
Javier


Thibault Saunier (2):
  [media] exynos-gsc: Do not swap cb/cr for semi planar formats
  [media] exynos-gsc: Add support for NV{16,21,61}M pixel formats

 drivers/media/platform/exynos-gsc/gsc-core.c | 29 ++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

-- 
2.7.4

