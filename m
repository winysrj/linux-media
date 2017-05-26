Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:38408 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S943705AbdEZP2J (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 26 May 2017 11:28:09 -0400
Subject: [PATCH 05/11] atomisp2: off by one in atomisp_s_input()
From: Alan Cox <alan@llwyncelyn.cymru>
To: mchehab@kernel.org, linux-media@vger.kernel.org
Date: Fri, 26 May 2017 16:28:05 +0100
Message-ID: <149581248013.17585.510088085248801167.stgit@builder>
In-Reply-To: <149581243155.17585.8164899156710160858.stgit@builder>
References: <149581243155.17585.8164899156710160858.stgit@builder>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Dan Carpenter <dan.carpenter@oracle.com>

The isp->inputs[] array has isp->input_cnt elements which have been
initialized so this > should be >=.

This bug is harmless.  The check against ATOM_ISP_MAX_INPUTS prevents us
from reading beyond the end of the array.  The uninitialized elements
are zeroed out so we will end up returning -EINVAL a few lines later
because the .camera pointer is NULL.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
index 6064bb8..aa0526e 100644
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
