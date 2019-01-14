Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14880C43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 13:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E383620651
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 13:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726600AbfANNjD (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 08:39:03 -0500
Received: from mail.bootlin.com ([62.4.15.54]:51429 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbfANNjD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 08:39:03 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 7934F20742; Mon, 14 Jan 2019 14:39:00 +0100 (CET)
Received: from localhost.localdomain (aaubervilliers-681-1-45-241.w90-88.abo.wanadoo.fr [90.88.163.241])
        by mail.bootlin.com (Postfix) with ESMTPSA id 08D0B206F9;
        Mon, 14 Jan 2019 14:39:00 +0100 (CET)
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com
Cc:     Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Randy Li <ayaka@soulik.info>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH RFC 0/3] media: Ensure access to dma-buf-imported reference buffers
Date:   Mon, 14 Jan 2019 14:38:35 +0100
Message-Id: <20190114133839.29967-1-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This is a first attempt at implementing proper access to buffers
imported with dma-buf and used as reference frames for decoding
subsequent frames.

The main concern associated with this scenario was that memory could be
liberated while the buffer is not in a queued state. After careful
checking, it appears that this is not the case as the refcount is
always increased when importing the buffer. It is only decreased when
the same buffer is queued with a different dma-buf fd or when all
buffers are liberated. In the meantime (when decoding using the frame as
a reference happens), the buffer is thus guaranteed to stay alive.

However, buffers imported with dma-buf require calls to dma-buf-specific
map/unmap memops before they are accessed. This introduces the plumbing
for allowing that.

One major issue is that it cannot be done in atomic context, where
the job is marked as completed. To solve this, a new m2m operation
(job_done) is introduced which allows releasing access to the
reference buffers from the m2m worker thread.

Since this series touches the core of vb2 and m2m and may not be the
best way to implement this, it is marked as RFC.

This series is based on the series starting with:
  media: cedrus: Cleanup duplicate declarations from cedrus_dec header

Paul Kocialkowski (4):
  media: vb2: Add helpers to access unselected buffers
  media: v4l2-mem2mem: Add an optional job_done operation
  media: cedrus: Request access to reference buffers when decoding
  media: cedrus: Remove completed item from TODO list (dma-buf
    references)

 .../media/common/videobuf2/videobuf2-core.c   | 46 +++++++++++++++++++
 drivers/media/v4l2-core/v4l2-mem2mem.c        |  8 +++-
 drivers/staging/media/sunxi/cedrus/TODO       |  5 --
 drivers/staging/media/sunxi/cedrus/cedrus.c   |  1 +
 drivers/staging/media/sunxi/cedrus/cedrus.h   |  1 +
 .../staging/media/sunxi/cedrus/cedrus_dec.c   | 18 ++++++++
 .../staging/media/sunxi/cedrus/cedrus_dec.h   |  1 +
 .../staging/media/sunxi/cedrus/cedrus_mpeg2.c |  8 ++++
 include/media/v4l2-mem2mem.h                  |  4 ++
 include/media/videobuf2-core.h                | 15 ++++++
 10 files changed, 100 insertions(+), 7 deletions(-)

-- 
2.20.1

