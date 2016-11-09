Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:32928 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932904AbcKIN3H (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 08:29:07 -0500
Date: Wed, 9 Nov 2016 16:28:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: tiffany.lin@mediatek.com
Cc: linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org
Subject: [bug report] [media] vcodec: mediatek: Add Mediatek V4L2 Video
 Decoder Driver
Message-ID: <20161109132820.GA26677@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Tiffany Lin,

The patch 590577a4e525: "[media] vcodec: mediatek: Add Mediatek V4L2
Video Decoder Driver" from Sep 2, 2016, leads to the following static
checker warning:

	drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c:536 vidioc_vdec_qbuf()
	error: buffer overflow 'vq->bufs' 32 <= u32max

drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
   520  static int vidioc_vdec_qbuf(struct file *file, void *priv,
   521                              struct v4l2_buffer *buf)
   522  {
   523          struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
   524          struct vb2_queue *vq;
   525          struct vb2_buffer *vb;
   526          struct mtk_video_dec_buf *mtkbuf;
   527          struct vb2_v4l2_buffer  *vb2_v4l2;
   528  
   529          if (ctx->state == MTK_STATE_ABORT) {
   530                  mtk_v4l2_err("[%d] Call on QBUF after unrecoverable error",
   531                                  ctx->id);
   532                  return -EIO;
   533          }
   534  
   535          vq = v4l2_m2m_get_vq(ctx->m2m_ctx, buf->type);
   536          vb = vq->bufs[buf->index];

Smatch thinks that "buf->index" comes straight from the user without
being checked and that this is a buffer overflow.  It seems simple
enough to analyse the call tree.

__video_do_ioctl()
->  v4l_qbuf()
  -> vidioc_vdec_qbuf()

It seems like Smatch is correct.  I looked at a different implementation
of this and that one wasn't checked either so maybe there is something
I am not seeing.

This has obvious security implications.  Can someone take a look at
this?

   537          vb2_v4l2 = container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
   538          mtkbuf = container_of(vb2_v4l2, struct mtk_video_dec_buf, vb);
   539  
   540          if ((buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) &&
   541              (buf->m.planes[0].bytesused == 0)) {
   542                  mtkbuf->lastframe = true;
   543                  mtk_v4l2_debug(1, "[%d] (%d) id=%d lastframe=%d (%d,%d, %d) vb=%p",
   544                           ctx->id, buf->type, buf->index,
   545                           mtkbuf->lastframe, buf->bytesused,
   546                           buf->m.planes[0].bytesused, buf->length,
   547                           vb);
   548          }
   549  
   550          return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
   551  }

regards,
dan carpenter
