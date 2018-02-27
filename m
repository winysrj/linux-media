Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:33182 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752573AbeB0PF5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Feb 2018 10:05:57 -0500
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: niklas.soderlund@ragnatech.se,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH v2 0/3] media: i2c: adv748x: Fix CBUS page issue
Date: Tue, 27 Feb 2018 15:05:47 +0000
Message-Id: <1519743950-28346-1-git-send-email-kieran.bingham+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The ADV748x has 12 pages mapped on to I2C addresses.

The existing implementation only has 11 of these in the map enumeration, and
this can cause an off-by-one error when programming the map addresses.

This short series simplifies the regmap configuration tables, and adds the
missing CBUS page to better model the device, and remove the off by one error.

Once the tables are corrected, we add support for overriding the default map
addresses through the device tree using i2c_new_secondary_device().

Kieran Bingham (3):
  media: i2c: adv748x: Simplify regmap configuration
  media: i2c: adv748x: Add missing CBUS page
  media: i2c: adv748x: Add support for i2c_new_secondary_device

 drivers/media/i2c/adv748x/adv748x-core.c | 185 ++++++++++---------------------
 drivers/media/i2c/adv748x/adv748x.h      |  14 +--
 2 files changed, 58 insertions(+), 141 deletions(-)

-- 
2.7.4
