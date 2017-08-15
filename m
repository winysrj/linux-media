Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34135 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751224AbdHOLX5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Aug 2017 07:23:57 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: p.zabel@pengutronix.de, mchehab@kernel.org,
        prabhakar.csengg@gmail.com, laurent.pinchart@ideasonboard.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 0/3] constify media platform_device_id
Date: Tue, 15 Aug 2017 16:53:39 +0530
Message-Id: <1502796222-9681-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

platform_device_id are not supposed to change at runtime. All functions
working with platform_device_id provided by <linux/platform_device.h>
work with const platform_device_id. So mark the non-const structs as const.

Arvind Yadav (3):
  [PATCH 1/3] [media] coda: constify platform_device_id
  [PATCH 2/3] [media] davinci: constify platform_device_id
  [PATCH 3/3] [media] omap3isp: constify platform_device_id

 drivers/media/platform/coda/coda-common.c  | 2 +-
 drivers/media/platform/davinci/vpbe_osd.c  | 2 +-
 drivers/media/platform/davinci/vpbe_venc.c | 2 +-
 drivers/media/platform/omap3isp/isp.c      | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.7.4
