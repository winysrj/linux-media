Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:41164 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751426AbdFFUkt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 6 Jun 2017 16:40:49 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.13] Various fixes/improvements
Message-ID: <540feb54-cc87-548d-3365-d14fa27c0304@xs4all.nl>
Date: Tue, 6 Jun 2017 22:40:47 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The following changes since commit 6fb05e0dd32e566facb96ea61a48c7488daa5ac3:

  [media] saa7164: fix double fetch PCIe access condition (2017-06-06 16:55:50 -0300)

are available in the git repository at:

  git://linuxtv.org/hverkuil/media_tree.git for-v4.13c

for you to fetch changes up to 44cdbd59e84ad2562b760455ac24c7114672ca8f:

  tc358743: Add support for platforms without IRQ line (2017-06-06 22:31:15 +0200)

----------------------------------------------------------------
Arvind Yadav (1):
      tc358743: Handle return value of clk_prepare_enable

Dave Stevenson (3):
      tc358743: Add enum_mbus_code
      tc358743: Setup default mbus_fmt before registering
      tc358743: Add support for platforms without IRQ line

Hans Verkuil (1):
      cec: improve debug messages

Hugues Fruchet (1):
      atmel-isi: code cleanup

Sakari Ailus (2):
      v4l2-ctrls.c: Implement unlocked variant of v4l2_ctrl_handler_setup()
      v4l2-ctrls: Correctly destroy mutex in v4l2_ctrl_handler_free()

 drivers/media/cec/cec-adap.c             | 28 ++++++++++++++++------------
 drivers/media/i2c/tc358743.c             | 65 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/media/platform/atmel/atmel-isi.c | 24 ++++++++++--------------
 drivers/media/v4l2-core/v4l2-ctrls.c     | 24 +++++++++++++++++++++---
 include/media/v4l2-ctrls.h               | 13 +++++++++++++
 5 files changed, 123 insertions(+), 31 deletions(-)
