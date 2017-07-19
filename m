Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:20802 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753948AbdGSJ4g (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 05:56:36 -0400
Date: Wed, 19 Jul 2017 12:56:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] [media] atomisp2: array underflow in ap1302_enum_frame_size()
Message-ID: <20170719095618.g36egw4t4t5h4tzh@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The problem is this code from ap1302_enum_frame_size():

   738          int index = fse->index;
   739  
   740          mutex_lock(&dev->input_lock);
   741          context = ap1302_get_context(sd);
   742          if (index >= dev->cntx_res[context].res_num) {
   743                  mutex_unlock(&dev->input_lock);
   744                  return -EINVAL;
   745          }
   746  
   747          res_table = dev->cntx_res[context].res_table;
   748          fse->min_width = res_table[index].width;

"fse->index" is a u32 that come from the user.  We want negative values
of "index" to be treated as -EINVAL but they're not so we can read from
before the start of the res_table[] array.

I've fixed this by making "res_num" a u32.  I made "cur_res" a u32 as
well, just for consistency.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/atomisp/i2c/ap1302.h b/drivers/staging/media/atomisp/i2c/ap1302.h
index 9341232c580d..4d0b181a9671 100644
--- a/drivers/staging/media/atomisp/i2c/ap1302.h
+++ b/drivers/staging/media/atomisp/i2c/ap1302.h
@@ -158,8 +158,8 @@ struct ap1302_res_struct {
 };
 
 struct ap1302_context_res {
-	s32 res_num;
-	s32 cur_res;
+	u32 res_num;
+	u32 cur_res;
 	struct ap1302_res_struct *res_table;
 };
 
