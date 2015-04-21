Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26710 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbbDUJba (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 05:31:30 -0400
Date: Tue, 21 Apr 2015 12:31:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Hyun Kwon <hyun.kwon@xilinx.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] v4l: xilinx: harmless buffer overflow
Message-ID: <20150421093110.GD12098@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

My static checker warns that the name of the port can be 15 characters
when you consider the NUL terminator and that's one more than the 14
characters in name[].  Maybe it's an off-by-one?

It's unlikely that we hit the limit and even if we do the overflow will
only affect one of the two bytes of padding so it's harmless.  Still
let's fix it and also change the sprintf() to snprintf().

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index efde88a..98e50e4 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -653,7 +653,7 @@ static const struct v4l2_file_operations xvip_dma_fops = {
 int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
 		  enum v4l2_buf_type type, unsigned int port)
 {
-	char name[14];
+	char name[16];
 	int ret;
 
 	dma->xdev = xdev;
@@ -725,7 +725,7 @@ int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma *dma,
 	}
 
 	/* ... and the DMA channel. */
-	sprintf(name, "port%u", port);
+	snprintf(name, sizeof(name), "port%u", port);
 	dma->dma = dma_request_slave_channel(dma->xdev->dev, name);
 	if (dma->dma == NULL) {
 		dev_err(dma->xdev->dev, "no VDMA channel found\n");
