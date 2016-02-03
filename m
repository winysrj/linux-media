Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24481 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbcBCFAb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2016 00:00:31 -0500
Date: Wed, 3 Feb 2016 08:00:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: bparrot@ti.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] media: ti-vpe: Add CAL v4l2 camera capture driver
Message-ID: <20160203050013.GA29993@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Benoit Parrot,

This is a semi-automatic email about new static checker warnings.

The patch 343e89a792a5: "[media] media: ti-vpe: Add CAL v4l2 camera 
capture driver" from Jan 6, 2016, leads to the following Smatch 
complaint:

drivers/media/platform/ti-vpe/cal.c:1349 cal_start_streaming()
	 warn: variable dereferenced before check 'ctx->sensor' (see line 1332)

drivers/media/platform/ti-vpe/cal.c
  1331	
  1332		ret = cal_get_external_info(ctx);
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^
Dereferenced inside function call.

  1333		if (ret < 0)
  1334			goto err;
  1335	
  1336		cal_runtime_get(ctx->dev);
  1337	
  1338		enable_irqs(ctx);
  1339		camerarx_phy_enable(ctx);
  1340		csi2_init(ctx);
  1341		csi2_phy_config(ctx);
  1342		csi2_lane_config(ctx);
  1343		csi2_ctx_config(ctx);
  1344		pix_proc_config(ctx);
  1345		cal_wr_dma_config(ctx, ctx->v_fmt.fmt.pix.bytesperline);
  1346		cal_wr_dma_addr(ctx, addr);
  1347		csi2_ppi_enable(ctx);
  1348	
  1349		if (ctx->sensor) {
                    ^^^^^^^^^^^
Checked too late.

  1350			if (v4l2_subdev_call(ctx->sensor, video, s_stream, 1)) {
  1351				ctx_err(ctx, "stream on failed in subdev\n");

regards,
dan carpenter
