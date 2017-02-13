Return-path: <linux-media-owner@vger.kernel.org>
Received: from fllnx210.ext.ti.com ([198.47.19.17]:10269 "EHLO
        fllnx210.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752628AbdBMNHJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 08:07:09 -0500
From: Benoit Parrot <bparrot@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        <linux-media@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jyri Sarha <jsarha@ti.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [Patch 0/2] media: ti-vpe: allow user specified stride
Date: Mon, 13 Feb 2017 07:06:56 -0600
Message-ID: <20170213130658.31907-1-bparrot@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch series enables user specified buffer stride to be used
instead of always forcing the stride from the driver side.

Benoit Parrot (2):
  media: ti-vpe: vpdma: add support for user specified stride
  media: ti-vpe: vpe: allow use of user specified stride

 drivers/media/platform/ti-vpe/vpdma.c | 14 ++++----------
 drivers/media/platform/ti-vpe/vpdma.h |  6 +++---
 drivers/media/platform/ti-vpe/vpe.c   | 34 ++++++++++++++++++++++++----------
 3 files changed, 31 insertions(+), 23 deletions(-)

-- 
2.9.0
