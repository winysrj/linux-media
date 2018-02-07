Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753696AbeBGRfE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 7 Feb 2018 12:35:04 -0500
From: Kieran Bingham <kbingham@kernel.org>
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Subject: [PATCH 0/2] media: i2c: adv748x: Fix CBUS page issue
Date: Wed,  7 Feb 2018 17:34:44 +0000
Message-Id: <1518024886-842-1-git-send-email-kbingham@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>

The ADV748x has 12 pages mapped on to I2C addresses.

The existing implementation only has 11 of these in the map enumeration, and
this can cause an off-by-one error when programming the map addresses.

This short series simplifies the regmap configuration tables, and adds the
missing CBUS page to better model the device, and remove the off by one error.


Kieran Bingham (2):
  media: i2c: adv748x: Simplify regmap configuration
  media: i2c: adv748x: Add missing CBUS page.

 drivers/media/i2c/adv748x/adv748x-core.c | 114 +++++++------------------------
 drivers/media/i2c/adv748x/adv748x.h      |   2 +
 2 files changed, 27 insertions(+), 89 deletions(-)

-- 
2.7.4
