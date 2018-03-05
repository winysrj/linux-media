Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:49527 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933618AbeCEJfs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Mar 2018 04:35:48 -0500
From: Maxime Ripard <maxime.ripard@bootlin.com>
To: Yong Deng <yong.deng@magewell.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Mylene Josserand <mylene.josserand@bootlin.com>
Subject: [PATCH 0/7] media: sun6i: Various fixes and improvements
Date: Mon,  5 Mar 2018 10:35:27 +0100
Message-Id: <20180305093535.11801-1-maxime.ripard@bootlin.com>
In-Reply-To: <1519697113-32202-1-git-send-email-yong.deng@magewell.com>
References: <1519697113-32202-1-git-send-email-yong.deng@magewell.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Yong,

Here are a bunch of patches I came up with after testing your last
(v8) version of the CSI patches.

There's some improvements (patches 1 and 7) and fixes for
regressions found in the v8 compared to the v7 (patches 2, 3, 4 and
5), and one fix that we discussed for the signals polarity for the
parallel interface (patch 6).

Feel free to squash them in your serie for the v9.
Thanks!
Maxime

Maxime Ripard (7):
  media: sun6i: Fill dma_pfn_offset to accomodate for the RAM offset
  media: sun6i: Reduce the error level
  media: sun6i: Pass the sun6i_csi_dev pointer to our helpers
  media: sun6i: Don't emit a warning when the configured format isn't
    found
  media: sun6i: Support the YUYV format properly
  media: sun6i: Invert the polarities
  media: sun6i: Expose controls on the v4l2_device

 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.c | 85 ++++++++++++++--------
 drivers/media/platform/sunxi/sun6i-csi/sun6i_csi.h |  2 +
 .../media/platform/sunxi/sun6i-csi/sun6i_video.c   |  6 ++
 3 files changed, 63 insertions(+), 30 deletions(-)

-- 
2.14.3
