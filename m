Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46469 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751127AbdEVMbs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 May 2017 08:31:48 -0400
Date: Mon, 22 May 2017 15:30:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] atomisp2: off by one in atomisp_s_input()
Message-ID: <20170522123032.ikxms4grh7wmgj5d@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The isp->inputs[] array has isp->input_cnt elements which have been
initialized so this > should be >=.

This bug is harmless.  The check against ATOM_ISP_MAX_INPUTS prevents us
from reading beyond the end of the array.  The uninitialized elements
are zeroed out so we will end up returning -EINVAL a few lines later
because the .camera pointer is NULL.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
index 6064bb823a47..aa0526ebaff1 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
@@ -683,7 +683,7 @@ static int atomisp_s_input(struct file *file, void *fh, unsigned int input)
 	int ret;
 
 	rt_mutex_lock(&isp->mutex);
-	if (input >= ATOM_ISP_MAX_INPUTS || input > isp->input_cnt) {
+	if (input >= ATOM_ISP_MAX_INPUTS || input >= isp->input_cnt) {
 		dev_dbg(isp->dev, "input_cnt: %d\n", isp->input_cnt);
 		ret = -EINVAL;
 		goto error;
