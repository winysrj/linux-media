Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34136
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754296AbcJGUju (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Oct 2016 16:39:50 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Inki Dae <inki.dae@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Shuah Khan <shuahkh@osg.samsung.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        linux-media@vger.kernel.org,
        Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 0/3] [media] exynos-gsc: Another round of cleanup and fixes
Date: Fri,  7 Oct 2016 17:39:16 -0300
Message-Id: <1475872759-17969-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

This series contains another set of cleanup and fixes for the exynos-gsc
driver. The patches are on top of the previous posted set [0], although
there's no dependency and the patch-sets can be applied in any order.

Patch 1/3 is a cleanup for the gsc_register_m2m_device() error path

Patch 2/3 fixes a NULL pointer deference that happens when the driver
module is removed due the video device node not being unregistered.

Patch 3/3 fixes a warning due the driver not doing proper cleanup of
the m2m source and destination queues.

[0]: https://lkml.org/lkml/2016/9/30/413

Best regards,
Javier


Javier Martinez Canillas (3):
  [media] exynos-gsc: don't release a non-dynamically allocated
    video_device
  [media] exynos-gsc: unregister video device node on driver removal
  [media] exynos-gsc: cleanup m2m src and dst vb2 queues on STREAMOFF

 drivers/media/platform/exynos-gsc/gsc-m2m.c | 30 ++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

-- 
2.7.4

