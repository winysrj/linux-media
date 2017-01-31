Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:40724 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752193AbdAaOUs (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 31 Jan 2017 09:20:48 -0500
Date: Tue, 31 Jan 2017 22:20:27 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH] [media] media: fix semicolon.cocci warnings
Message-ID: <20170131142027.GA7484@intel11.lkp.intel.com>
References: <201701312222.8i09esDk%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201701312222.8i09esDk%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/i2c/et8ek8/et8ek8_driver.c:1112:3-4: Unneeded semicolon


 Remove unneeded semicolon.

Generated by: scripts/coccinelle/misc/semicolon.cocci

CC: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---

 et8ek8_driver.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/et8ek8/et8ek8_driver.c
+++ b/drivers/media/i2c/et8ek8/et8ek8_driver.c
@@ -1109,7 +1109,7 @@ static int et8ek8_g_priv_mem(struct v4l2
 			if (!(status & 0x08))
 				break;
 			usleep_range(1000, 2000);
-		};
+		}
 
 		if (i == 1000)
 			return -EIO;
