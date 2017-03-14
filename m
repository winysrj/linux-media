Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37947 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751080AbdCNH4A (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Mar 2017 03:56:00 -0400
Date: Tue, 14 Mar 2017 10:52:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Varsha Rao <rvarsha016@gmail.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org
Subject: [patch] staging: atomisp: missing break statement in switch
Message-ID: <20170314075202.GB6061@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Static analysis tools suggest that we probably want a break statement
here before then next cast statement.  Looks true to me.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
index e3d4d0e0ed9c..ac7598291b95 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
@@ -1132,7 +1132,7 @@ static int ov5693_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 		break;
 	case V4L2_CID_FOCUS_STATUS:
 		ret = ov5693_q_focus_status(&dev->sd, &ctrl->val);
-
+		break;
 	case V4L2_CID_BIN_FACTOR_HORZ:
 		ret = ov5693_g_bin_factor_x(&dev->sd, &ctrl->val);
 		break;
