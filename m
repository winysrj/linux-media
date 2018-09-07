Return-path: <linux-media-owner@vger.kernel.org>
Received: from leonov.paulk.fr ([185.233.101.22]:60412 "EHLO leonov.paulk.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726248AbeIGVQE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Sep 2018 17:16:04 -0400
From: Paul Kocialkowski <contact@paulk.fr>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>, linux-sunxi@googlegroups.com,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Paul Kocialkowski <contact@paulk.fr>
Subject: [PATCH 0/2] Follow-up patches for Cedrus v9
Date: Fri,  7 Sep 2018 18:33:45 +0200
Message-Id: <20180907163347.32312-1-contact@paulk.fr>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This brings the requested modifications on top of version 9 of the
Cedrus VPU driver, that implements stateless video decoding using the
Request API.

Paul Kocialkowski (2):
  media: cedrus: Fix error reporting in request validation
  media: cedrus: Add TODO file with tasks to complete before unstaging

 drivers/staging/media/sunxi/cedrus/TODO     |  7 +++++++
 drivers/staging/media/sunxi/cedrus/cedrus.c | 15 ++++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)
 create mode 100644 drivers/staging/media/sunxi/cedrus/TODO

-- 
2.18.0
