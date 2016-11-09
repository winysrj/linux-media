Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:48424 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932322AbcKINp2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 Nov 2016 08:45:28 -0500
Subject: Re: [bug report] [media] vcodec: mediatek: Add Mediatek V4L2 Video
 Decoder Driver
To: Dan Carpenter <dan.carpenter@oracle.com>, tiffany.lin@mediatek.com
References: <20161109132820.GA26677@mwanda>
Cc: linux-media@vger.kernel.org, linux-mediatek@lists.infradead.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <9794dab1-94ba-c384-85c5-edb8831810ff@xs4all.nl>
Date: Wed, 9 Nov 2016 14:45:21 +0100
MIME-Version: 1.0
In-Reply-To: <20161109132820.GA26677@mwanda>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/09/16 14:28, Dan Carpenter wrote:
> Hello Tiffany Lin,
>
> The patch 590577a4e525: "[media] vcodec: mediatek: Add Mediatek V4L2
> Video Decoder Driver" from Sep 2, 2016, leads to the following static
> checker warning:
>
> 	drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c:536 vidioc_vdec_qbuf()
> 	error: buffer overflow 'vq->bufs' 32 <= u32max
>
> drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
>    520  static int vidioc_vdec_qbuf(struct file *file, void *priv,
>    521                              struct v4l2_buffer *buf)
>    522  {
>    523          struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
>    524          struct vb2_queue *vq;
>    525          struct vb2_buffer *vb;
>    526          struct mtk_video_dec_buf *mtkbuf;
>    527          struct vb2_v4l2_buffer  *vb2_v4l2;
>    528
>    529          if (ctx->state == MTK_STATE_ABORT) {
>    530                  mtk_v4l2_err("[%d] Call on QBUF after unrecoverable error",
>    531                                  ctx->id);
>    532                  return -EIO;
>    533          }
>    534
>    535          vq = v4l2_m2m_get_vq(ctx->m2m_ctx, buf->type);
>    536          vb = vq->bufs[buf->index];
>
> Smatch thinks that "buf->index" comes straight from the user without
> being checked and that this is a buffer overflow.  It seems simple
> enough to analyse the call tree.
>
> __video_do_ioctl()
> ->  v4l_qbuf()
>   -> vidioc_vdec_qbuf()
>
> It seems like Smatch is correct.  I looked at a different implementation
> of this and that one wasn't checked either so maybe there is something
> I am not seeing.
>
> This has obvious security implications.  Can someone take a look at
> this?

This is indeed wrong.

The v4l2_m2m_qbuf() call at the end of this function calls in turn 
vb2_qbuf which
will check the index. But if you override vidioc_qbuf (or 
vidioc_prepare), then
you need to check the index value.

I double-checked all cases where vidioc_qbuf was set to a 
driver-specific function
and this is the only driver that doesn't check the index field. In all 
other cases
it is either checked, or it is not used before calling into the vb1/vb2 
framework
which checks this.

So luckily this only concerns this driver.

Regards,

	Hans

>
>    537          vb2_v4l2 = container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
>    538          mtkbuf = container_of(vb2_v4l2, struct mtk_video_dec_buf, vb);
>    539
>    540          if ((buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) &&
>    541              (buf->m.planes[0].bytesused == 0)) {
>    542                  mtkbuf->lastframe = true;
>    543                  mtk_v4l2_debug(1, "[%d] (%d) id=%d lastframe=%d (%d,%d, %d) vb=%p",
>    544                           ctx->id, buf->type, buf->index,
>    545                           mtkbuf->lastframe, buf->bytesused,
>    546                           buf->m.planes[0].bytesused, buf->length,
>    547                           vb);
>    548          }
>    549
>    550          return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
>    551  }
>
> regards,
> dan carpenter
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
