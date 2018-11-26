Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58669 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbeK0FMi (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Nov 2018 00:12:38 -0500
From: Michael Tretter <m.tretter@pengutronix.de>
To: hverkuil@xs4all.nl
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        Michael Tretter <m.tretter@pengutronix.de>
Subject: [PATCH 0/2] Fix v4l2-pci-skeleton driver
Date: Mon, 26 Nov 2018 19:01:22 +0100
Message-Id: <20181126180124.15161-1-m.tretter@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This series fixes the v4l2-pci-skeleton driver to make it usable as a
reference for new v4l2 drivers again.

The driver was skipped when replacing vb2_buffer with vb2_v4l2_buffers for
v4l2 drivers. Moreover, VIDEO_PCI_SKELETON did not ensure that it is
actually build.

Michael Tretter (2):
  [media] v4l2-pci-skeleton: depend on CONFIG_SAMPLES
  [media] v4l2-pci-skeleton: replace vb2_buffer with vb2_v4l2_buffer

 drivers/media/v4l2-core/Kconfig |  1 +
 samples/v4l/v4l2-pci-skeleton.c | 11 ++++++-----
 2 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.19.1
