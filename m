Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46986 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbeAWIdA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Jan 2018 03:33:00 -0500
Date: Tue, 23 Jan 2018 11:32:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: a.hajda@samsung.com
Cc: linux-media@vger.kernel.org
Subject: [bug report] [media] s5p-mfc: use MFC_BUF_FLAG_EOS to identify last
 buffers in decoder capture queue
Message-ID: <20180123083245.GA10091@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Andrzej Hajda,

The patch 4d0b0ed63660: "[media] s5p-mfc: use MFC_BUF_FLAG_EOS to
identify last buffers in decoder capture queue" from Oct 7, 2015,
leads to the following static checker warning:

	drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:658 vidioc_dqbuf()
	error: buffer overflow 'ctx->dst_bufs' 32 user_rl = '0-u32max'

drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
   635  /* Dequeue a buffer */
   636  static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
   637  {
   638          const struct v4l2_event ev = {
   639                  .type = V4L2_EVENT_EOS
   640          };
   641          struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
   642          int ret;
   643  
   644          if (ctx->state == MFCINST_ERROR) {
   645                  mfc_err_limited("Call on DQBUF after unrecoverable error\n");
   646                  return -EIO;
   647          }
   648  
   649          switch (buf->type) {
   650          case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
   651                  return vb2_dqbuf(&ctx->vq_src, buf, file->f_flags & O_NONBLOCK);
   652          case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
   653                  ret = vb2_dqbuf(&ctx->vq_dst, buf, file->f_flags & O_NONBLOCK);
   654                  if (ret)
   655                          return ret;
   656  
   657                  if (ctx->state == MFCINST_FINISHED &&
   658                      (ctx->dst_bufs[buf->index].flags & MFC_BUF_FLAG_EOS))
                                           ^^^^^^^^^^
Smatch is complaining that "buf->index" is not capped.  So far as I can
see this is true.  I would have expected it to be checked in
check_array_args() or video_usercopy() but I couldn't find the check.

   659                          v4l2_event_queue_fh(&ctx->fh, &ev);
   660                  return 0;
   661          default:
   662                  return -EINVAL;
   663          }
   664  }


regards,
dan carpenter
