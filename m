Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55299 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761058AbcAKQrs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 11:47:48 -0500
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Nikhil Devshatwar <nikhil.nd@ti.com>,
	Kukjin Kim <kgene@kernel.org>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Andrzej Hajda <a.hajda@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-samsung-soc@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	"Prabhakar\"" <prabhakar.csengg@gmail.com>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: [PATCH v2 0/8] [media] Check v4l2_of_parse_endpoint() ret val in all drivers
Date: Mon, 11 Jan 2016 13:47:08 -0300
Message-Id: <1452530844-30609-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

When discussing a patch [0] with Laurent Pinchart for another series I
mentioned to him that most callers of v4l2_of_parse_endpoint() weren't
checking the return value. This is likely due the function kernel-doc
stating incorrectly that the return value is always 0 but can return a
negative error code on failure.

This trivial patch series fixes the function kernel-doc and add proper
error checking in all the drivers that are currently not doing so.

This is the second version of the series that fixes some minot issues
pointed out by Sakari Ailus. The v1 of the series can be found in [1].

[0]: https://lkml.org/lkml/2016/1/6/307
[1]: https://lkml.org/lkml/2016/1/7/508

Best regards,
Javier

Changes in v2:
- Assign pdata to NULL in case v4l2_of_parse_endpoint() fails before kzalloc.
  Suggested by Sakari Ailus.
- Assign pdata to NULL in case v4l2_of_parse_endpoint() fails before kzalloc.
  Suggested by Sakari Ailus.

Javier Martinez Canillas (8):
  [media] v4l: of: Correct v4l2_of_parse_endpoint() kernel-doc
  [media] adv7604: Check v4l2_of_parse_endpoint() return value
  [media] s5c73m3: Check v4l2_of_parse_endpoint() return value
  [media] s5k5baf: Check v4l2_of_parse_endpoint() return value
  [media] tvp514x: Check v4l2_of_parse_endpoint() return value
  [media] tvp7002: Check v4l2_of_parse_endpoint() return value
  [media] exynos4-is: Check v4l2_of_parse_endpoint() return value
  [media] omap3isp: Check v4l2_of_parse_endpoint() return value

 drivers/media/i2c/adv7604.c                   |  7 ++++++-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c      |  4 +++-
 drivers/media/i2c/s5k5baf.c                   |  5 ++++-
 drivers/media/i2c/tvp514x.c                   |  6 ++++--
 drivers/media/i2c/tvp7002.c                   |  6 ++++--
 drivers/media/platform/exynos4-is/media-dev.c |  8 +++++++-
 drivers/media/platform/exynos4-is/mipi-csis.c | 10 +++++++---
 drivers/media/platform/omap3isp/isp.c         |  5 ++++-
 drivers/media/v4l2-core/v4l2-of.c             |  2 +-
 9 files changed, 40 insertions(+), 13 deletions(-)

-- 
2.4.3

