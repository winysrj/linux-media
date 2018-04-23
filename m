Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway21.websitewelcome.com ([192.185.45.154]:37784 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932079AbeDWRho (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 13:37:44 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 5BE22400D741A
        for <linux-media@vger.kernel.org>; Mon, 23 Apr 2018 12:37:44 -0500 (CDT)
Date: Mon, 23 Apr 2018 12:37:41 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-renesas-soc@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>, Jonathan Corbet <corbet@lwn.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH 00/11] fix potential Spectre variant 1 issues
Message-ID: <cover.1524499368.git.gustavo@embeddedor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patchset aims to fix various media platform and media usb
cases where we have user controlled array dereferences that could
be exploited due to the Spectre variant 1 vulnerability. All were
reported by Dan Carpenter.

Notice that given that speculation windows are large, the policy is
to kill the speculation on the first load and not worry if it can be
completed with a dependent load/store [1].

[1] https://marc.info/?l=linux-kernel&m=152449131114778&w=2

Thanks

Gustavo A. R. Silva (11):
  media: tm6000: fix potential Spectre variant 1
  exynos4-is: mipi-csis: fix potential Spectre variant 1
  fsl-viu: fix potential Spectre variant 1
  marvell-ccic: mcam-core: fix potential Spectre variant 1
  omap_vout: fix potential Spectre variant 1
  rcar-v4l2: fix potential Spectre variant 1
  rcar_drif: fix potential Spectre variant 1
  sh_vou: fix potential Spectre variant 1
  vimc-debayer: fix potential Spectre variant 1
  vivid-sdr-cap: fix potential Spectre variant 1
  vsp1_rwpf: fix potential Spectre variant 1

 drivers/media/platform/exynos4-is/mipi-csis.c   | 5 ++++-
 drivers/media/platform/fsl-viu.c                | 8 ++++----
 drivers/media/platform/marvell-ccic/mcam-core.c | 3 +++
 drivers/media/platform/omap/omap_vout.c         | 3 +++
 drivers/media/platform/rcar-vin/rcar-v4l2.c     | 4 +++-
 drivers/media/platform/rcar_drif.c              | 4 +++-
 drivers/media/platform/sh_vou.c                 | 3 +++
 drivers/media/platform/vimc/vimc-debayer.c      | 5 ++++-
 drivers/media/platform/vivid/vivid-sdr-cap.c    | 6 ++++++
 drivers/media/platform/vsp1/vsp1_rwpf.c         | 3 +++
 drivers/media/usb/tm6000/tm6000-video.c         | 2 ++
 11 files changed, 38 insertions(+), 8 deletions(-)

-- 
2.7.4
