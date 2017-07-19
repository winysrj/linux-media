Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35953 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753275AbdGSJ4J (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 19 Jul 2017 05:56:09 -0400
Date: Wed, 19 Jul 2017 12:55:47 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] [media] atomisp2: Array underflow in atomisp_enum_input()
Message-ID: <20170719095547.klmttai63nxbprqy@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The problem here is this code from atomisp_enum_input():

   581          int index = input->index;
   582  
   583          if (index >= isp->input_cnt)
   584                  return -EINVAL;
   585  
   586          if (!isp->inputs[index].camera)
   587                  return -EINVAL;

"input->index" is a u32 which comes from the ioctl.  We want negative
values of "index" to be counted as -EINVAL but they aren't.  I've fixed
this by changing the type of "isp->input_cnt" to unsigned int.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
index d3667132851b..c8e0c4fe3717 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
@@ -275,7 +275,7 @@ struct atomisp_device {
 	 */
 	struct mutex streamoff_mutex;
 
-	int input_cnt;
+	unsigned int input_cnt;
 	struct atomisp_input_subdev inputs[ATOM_ISP_MAX_INPUTS];
 	struct v4l2_subdev *flash;
 	struct v4l2_subdev *motor;
