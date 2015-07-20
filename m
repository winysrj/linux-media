Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:44726 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565AbbGTNTa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2015 09:19:30 -0400
Received: from tschai.fritz.box (localhost [127.0.0.1])
	by tschai.lan (Postfix) with ESMTPSA id EEECB2A0095
	for <linux-media@vger.kernel.org>; Mon, 20 Jul 2015 15:18:23 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: [PATCH 0/5] zoran: convert to the control framework
Date: Mon, 20 Jul 2015 15:18:17 +0200
Message-Id: <1437398302-6211-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Convert the zoran driver to the control framework. As a result of that
it is now also possible to drop the legacy control ops from three
subdev drivers that were only used by the zoran driver.

Regards,

	Hans

Hans Verkuil (5):
  zoran: remove unnecessary memset
  zoran: remove unused read/write functions
  zoran: use standard core lock
  zoran: convert to the control framework and to v4l2_fh
  bt819/saa7110/vpx3220: remove legacy control ops

 drivers/media/i2c/bt819.c              |  11 --
 drivers/media/i2c/saa7110.c            |  11 --
 drivers/media/i2c/vpx3220.c            |   7 -
 drivers/media/pci/zoran/zoran.h        |   7 +-
 drivers/media/pci/zoran/zoran_card.c   |  11 +-
 drivers/media/pci/zoran/zoran_driver.c | 344 +++++++--------------------------
 6 files changed, 83 insertions(+), 308 deletions(-)

-- 
2.1.4

