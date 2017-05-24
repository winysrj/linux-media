Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26331 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750846AbdEXN7z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 May 2017 09:59:55 -0400
Date: Wed, 24 May 2017 21:58:59 +0800
From: kbuild test robot <lkp@intel.com>
To: Hyungwoo Yang <hyungwoo.yang@intel.com>
Cc: kbuild-all@01.org, linux-media@vger.kernel.org,
        sakari.ailus@linux.intel.com, jian.xu.zheng@intel.com,
        hyungwoo.yang@intel.com
Subject: [PATCH] i2c: fix semicolon.cocci warnings
Message-ID: <20170524135854.GA20860@intel17.lkp.intel.com>
References: <201705242154.G3cmvxX9%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1495583908-2479-1-git-send-email-hyungwoo.yang@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/i2c/ov13858.c:1319:2-3: Unneeded semicolon


 Remove unneeded semicolon.

Generated by: scripts/coccinelle/misc/semicolon.cocci

CC: Hyungwoo Yang <hyungwoo.yang@intel.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---

 ov13858.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/ov13858.c
+++ b/drivers/media/i2c/ov13858.c
@@ -1316,7 +1316,7 @@ static int ov13858_set_ctrl(struct v4l2_
 			 "ctrl(id:0x%x,val:0x%x) is not handled\n",
 			 ctrl->id, ctrl->val);
 		break;
-	};
+	}
 
 	pm_runtime_put(&client->dev);
 
