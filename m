Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:44710 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbeIJABb (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Sep 2018 20:01:31 -0400
From: Paul Kocialkowski <contact@paulk.fr>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com, Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Paul Kocialkowski <contact@paulk.fr>
Subject: [PATCH v2 0/4] Follow-up patches for Cedrus v9
Date: Sun,  9 Sep 2018 21:10:11 +0200
Message-Id: <20180909191015.20902-1-contact@paulk.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This brings the requested modifications on top of version 9 of the
Cedrus VPU driver, that implements stateless video decoding using the
Request API.

Changes since v1:
* Added two more commits to fix build issues with non-sunxi configs.

In order to build correctly on non-sunxi platforms, the following commit
is also required to select the sunxi SRAM driver:
* drivers: soc: Allow building the sunxi driver without ARCH_SUNXI

Paul Kocialkowski (4):
  media: cedrus: Fix error reporting in request validation
  media: cedrus: Add TODO file with tasks to complete before unstaging
  media: cedrus: Wrap PHYS_PFN_OFFSET with ifdef and add dedicated
    comment
  media: cedrus: Select the sunxi SRAM driver in Kconfig

 drivers/staging/media/sunxi/cedrus/Kconfig     |  1 +
 drivers/staging/media/sunxi/cedrus/TODO        |  7 +++++++
 drivers/staging/media/sunxi/cedrus/cedrus.c    | 15 ++++++++++++---
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c |  5 +++++
 4 files changed, 25 insertions(+), 3 deletions(-)
 create mode 100644 drivers/staging/media/sunxi/cedrus/TODO

-- 
2.18.0
