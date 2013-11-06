Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:16442 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab3KFQOA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Nov 2013 11:14:00 -0500
Date: Wed, 6 Nov 2013 19:13:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: p.zabel@pengutronix.de
Cc: linux-media@vger.kernel.org
Subject: re: [media] coda: update CODA7541 to firmware 1.4.50
Message-ID: <20131106161342.GD15603@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Philipp Zabel,

This is a semi-automatic email about new static checker warnings.

The patch 5677e3b04d3b: "[media] coda: update CODA7541 to firmware 
1.4.50" from Jun 21, 2013, leads to the following Smatch complaint:

drivers/media/platform/coda.c:1530 coda_alloc_framebuffers()
	 error: we previously assumed 'ctx->codec' could be null (see line 1521)

drivers/media/platform/coda.c
  1520	
  1521		if (ctx->codec && ctx->codec->src_fourcc == V4L2_PIX_FMT_H264)
                    ^^^^^^^^^^
Patch introduces a new NULL check.

  1522			height = round_up(height, 16);
  1523		ysize = round_up(q_data->width, 8) * height;
  1524	
  1525		/* Allocate frame buffers */
  1526		for (i = 0; i < ctx->num_internal_frames; i++) {
  1527			size_t size;
  1528	
  1529			size = q_data->sizeimage;
  1530			if (ctx->codec->src_fourcc == V4L2_PIX_FMT_H264 &&
                            ^^^^^^^^^^^^^^^^^^^^^^
Patch introduces a new unchecked dereference.

  1531			    dev->devtype->product != CODA_DX6)
  1532				ctx->internal_frames[i].size += ysize/4;

regards,
dan carpenter
