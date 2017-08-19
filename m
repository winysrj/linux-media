Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:36469 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751368AbdHSTU4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 19 Aug 2017 15:20:56 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: hans.verkuil@cisco.com, mchehab@kernel.org, matrandg@cisco.com
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH 0/6] constify media i2c_device_id
Date: Sun, 20 Aug 2017 00:50:41 +0530
Message-Id: <1503170447-18533-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

i2c_device_id are not supposed to change at runtime. All functions
working with i2c_device_id provided by <linux/i2c.h> work with
const i2c_device_id. So mark the non-const structs as const.

Arvind Yadav (6):
  [PATCH 1/6] [media] ad9389b: constify i2c_device_id
  [PATCH 2/6] [media] adv7511: constify i2c_device_id
  [PATCH 3/6] [media] adv7842: constify i2c_device_id
  [PATCH 4/6] [media] saa7127: constify i2c_device_id
  [PATCH 5/6] [media] tc358743: constify i2c_device_id
  [PATCH 6/6] [media] ths8200: constify i2c_device_id

 drivers/media/i2c/ad9389b.c  | 2 +-
 drivers/media/i2c/adv7511.c  | 2 +-
 drivers/media/i2c/adv7842.c  | 2 +-
 drivers/media/i2c/saa7127.c  | 2 +-
 drivers/media/i2c/tc358743.c | 2 +-
 drivers/media/i2c/ths8200.c  | 2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.7.4
