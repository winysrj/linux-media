Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59688 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753178AbdA3LIN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 06:08:13 -0500
Received: from avalon.localnet (unknown [91.179.29.12])
        by galahad.ideasonboard.com (Postfix) with ESMTPSA id 9EBD320098
        for <linux-media@vger.kernel.org>; Mon, 30 Jan 2017 11:57:19 +0100 (CET)
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: [GIT PULL FOR v4.11] Sensors changes
Date: Mon, 30 Jan 2017 12:58:21 +0200
Message-ID: <1545226.9Z0Ll854RB@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

The following changes since commit 40eca140c404505c09773d1c6685d818cb55ab1a:

  [media] mn88473: add DVB-T2 PLP support (2016-12-27 14:00:15 -0200)

are available in the git repository at:

  git://linuxtv.org/pinchartl/media.git sensors/next

for you to fetch changes up to ab21fe9d7e3748e42445a43d24c67e8b42abff01:

  ov9650: use msleep() for uncritical long delay (2017-01-30 12:57:14 +0200)

----------------------------------------------------------------
Laurent Pinchart (1):
      v4l: mt9v032: Remove unneeded gpiod NULL check

Nicholas Mc Guire (1):
      ov9650: use msleep() for uncritical long delay

 drivers/media/i2c/mt9v032.c | 3 +--
 drivers/media/i2c/ov9650.c  | 4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

-- 
Regards,

Laurent Pinchart

