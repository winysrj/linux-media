Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51763 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752558AbdBMTHg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 14:07:36 -0500
Date: Mon, 13 Feb 2017 22:07:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hugues.fruchet@st.com
Cc: linux-media@vger.kernel.org
Subject: [bug report] [media] st-delta: add mjpeg support
Message-ID: <20170213190704.GA7539@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hugues Fruchet,

The patch 433ff5b4a29b: "[media] st-delta: add mjpeg support" from
Feb 2, 2017, leads to the following static checker warning:

	drivers/media/platform/sti/delta/delta-mjpeg-dec.c:415 delta_mjpeg_decode()
	error: uninitialized symbol 'data_offset'.

drivers/media/platform/sti/delta/delta-mjpeg-dec.c
   378          unsigned int data_offset;
                             ^^^^^^^^^^^
   379          struct mjpeg_header *header = &ctx->header_struct;
   380  
   381          if (!ctx->header) {
   382                  ret = delta_mjpeg_read_header(pctx, au.vaddr, au.size,
   383                                                header, &data_offset);
                                                               ^^^^^^^^^^^
It's not immediately clear that "data_offset" must be set on the
success path.

   384                  if (ret) {
   385                          pctx->stream_errors++;
   386                          goto err;
   387                  }
   388                  if (header->frame_width * header->frame_height >
   389                      DELTA_MJPEG_MAX_RESO) {
   390                          dev_err(delta->dev,
   391                                  "%s  stream resolution too large: %dx%d > %d pixels budget\n",
   392                                  pctx->name,
   393                                  header->frame_width,
   394                                  header->frame_height, DELTA_MJPEG_MAX_RESO);
   395                          ret = -EINVAL;
   396                          goto err;
   397                  }
   398                  ctx->header = header;
   399                  goto out;
   400          }
   401  
   402          if (!ctx->ipc_hdl) {
   403                  ret = delta_mjpeg_ipc_open(pctx);
   404                  if (ret)
   405                          goto err;
   406          }
   407  
   408          ret = delta_mjpeg_read_header(pctx, au.vaddr, au.size,
   409                                        ctx->header, &data_offset);
   410          if (ret) {
   411                  pctx->stream_errors++;
   412                  goto err;
   413          }
   414  
   415          au.paddr += data_offset;
                ^^^^^^^^^^^^^^^^^^^^^^^
   416          au.vaddr += data_offset;

regards,
dan carpenter
