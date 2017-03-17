Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:28449 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751180AbdCQUqd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Mar 2017 16:46:33 -0400
Date: Fri, 17 Mar 2017 23:45:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] Staging: atomisp: fix an uninitialized variable bug
Message-ID: <20170317204505.GC16505@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some error paths in atomisp_css_frame_allocate() which don't
initialize "res" so it could lead us to try release random memory.

Fixes: a49d25364dfb ("staging/atomisp: Add support for the Intel IPU v2")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index d9a5c24633cb..0f01047cdf8e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -4733,7 +4733,7 @@ static int
 atomisp_v4l2_framebuffer_to_css_frame(const struct v4l2_framebuffer *arg,
 					 struct atomisp_css_frame **result)
 {
-	struct atomisp_css_frame *res;
+	struct atomisp_css_frame *res = NULL;
 	unsigned int padded_width;
 	enum atomisp_css_frame_format sh_format;
 	char *tmp_buf = NULL;
