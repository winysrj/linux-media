Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27919 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751953AbdF2Ks5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Jun 2017 06:48:57 -0400
Date: Thu, 29 Jun 2017 13:48:43 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: peter.ujfalusi@ti.com
Cc: linux-media@vger.kernel.org
Subject: [bug report] media: v4l: omap_vout: vrfb: Convert to dmaengine
Message-ID: <20170629104843.23i3hfrl6cax5rul@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Peter Ujfalusi,

The patch 6a1560ecaa8c: "media: v4l: omap_vout: vrfb: Convert to
dmaengine" from May 3, 2017, leads to the following static checker
warning:

	drivers/media/platform/omap/omap_vout_vrfb.c:273 omap_vout_prepare_vrfb()
	error: uninitialized symbol 'flags'.

drivers/media/platform/omap/omap_vout_vrfb.c
   232  int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
   233                             struct videobuf_buffer *vb)
   234  {
   235          struct dma_async_tx_descriptor *tx;
   236          enum dma_ctrl_flags flags;
                                    ^^^^^

   237          struct dma_chan *chan = vout->vrfb_dma_tx.chan;
   238          struct dma_device *dmadev = chan->device;
   239          struct dma_interleaved_template *xt = vout->vrfb_dma_tx.xt;
   240          dma_cookie_t cookie;
   241          enum dma_status status;
   242          enum dss_rotation rotation;
   243          size_t dst_icg;
   244          u32 pixsize;
   245  
   246          if (!is_rotation_enabled(vout))
   247                  return 0;
   248  
   249          /* If rotation is enabled, copy input buffer into VRFB
   250           * memory space using DMA. We are copying input buffer
   251           * into VRFB memory space of desired angle and DSS will
   252           * read image VRFB memory for 0 degree angle
   253           */
   254  
   255          pixsize = vout->bpp * vout->vrfb_bpp;
   256          dst_icg = ((MAX_PIXELS_PER_LINE * pixsize) -
   257                    (vout->pix.width * vout->bpp)) + 1;
   258  
   259          xt->src_start = vout->buf_phy_addr[vb->i];
   260          xt->dst_start = vout->vrfb_context[vb->i].paddr[0];
   261  
   262          xt->numf = vout->pix.height;
   263          xt->frame_size = 1;
   264          xt->sgl[0].size = vout->pix.width * vout->bpp;
   265          xt->sgl[0].icg = dst_icg;
   266  
   267          xt->dir = DMA_MEM_TO_MEM;
   268          xt->src_sgl = false;
   269          xt->src_inc = true;
   270          xt->dst_sgl = true;
   271          xt->dst_inc = true;
   272  
   273          tx = dmadev->device_prep_interleaved_dma(chan, xt, flags);
                                                                   ^^^^^
I'm surprised new versions of GCC don't complain about this.

   274          if (tx == NULL) {
   275                  pr_err("%s: DMA interleaved prep error\n", __func__);
   276                  return -EINVAL;

regards,
dan carpenter
