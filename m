Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:3189 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729224AbeGaJqO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jul 2018 05:46:14 -0400
Date: Tue, 31 Jul 2018 16:06:14 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: kbuild-all@01.org, Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, Marco Felsch <m.felsch@pengutronix.de>
Subject: [RFC PATCH ragnatech] media: tvp5150: tvp5150_volatile_reg() can be
 static
Message-ID: <20180731080614.GA8270@lkp-wsm-ep2.lkp.intel.com>
References: <201807311618.wWANbjTp%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201807311618.wWANbjTp%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Fixes: 07dff5b8c030 ("media: tvp5150: convert register access to regmap")
Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
---
 tvp5150.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
index b3c7b65..2bd9500 100644
--- a/drivers/media/i2c/tvp5150.c
+++ b/drivers/media/i2c/tvp5150.c
@@ -1321,7 +1321,7 @@ static const struct regmap_range tvp5150_readable_ranges[] = {
 	},
 };
 
-bool tvp5150_volatile_reg(struct device *dev, unsigned int reg)
+static bool tvp5150_volatile_reg(struct device *dev, unsigned int reg)
 {
 	switch (reg) {
 	case TVP5150_VERT_LN_COUNT_MSB:
