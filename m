Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:34625 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726565AbeK2UG3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Nov 2018 15:06:29 -0500
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: [PATCH v2 0/1] media: cedrus: Remove global IRQ spin lock from the driver
Date: Thu, 29 Nov 2018 10:00:47 +0100
Message-Id: <20181129090048.16482-1-paul.kocialkowski@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changes since v1:
* Reworked commit message as suggested by Maxime.

Paul Kocialkowski (1):
  media: cedrus: Remove global IRQ spin lock from the driver

 drivers/staging/media/sunxi/cedrus/cedrus.c       |  1 -
 drivers/staging/media/sunxi/cedrus/cedrus.h       |  2 --
 drivers/staging/media/sunxi/cedrus/cedrus_dec.c   |  9 ---------
 drivers/staging/media/sunxi/cedrus/cedrus_hw.c    | 13 +------------
 drivers/staging/media/sunxi/cedrus/cedrus_video.c |  5 -----
 5 files changed, 1 insertion(+), 29 deletions(-)

-- 
2.19.1
