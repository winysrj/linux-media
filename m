Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:15508 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752933AbcKJEbj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 9 Nov 2016 23:31:39 -0500
Message-ID: <1478752290.2580.6.camel@mtksdaap41>
Subject: Re: [bug report] [media] vcodec: mediatek: Add Mediatek V4L2 Video
 Decoder Driver
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        <linux-media@vger.kernel.org>, <linux-mediatek@lists.infradead.org>
Date: Thu, 10 Nov 2016 12:31:30 +0800
In-Reply-To: <9794dab1-94ba-c384-85c5-edb8831810ff@xs4all.nl>
References: <20161109132820.GA26677@mwanda>
         <9794dab1-94ba-c384-85c5-edb8831810ff@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, Dan,

On Wed, 2016-11-09 at 14:45 +0100, Hans Verkuil wrote:
> On 11/09/16 14:28, Dan Carpenter wrote:
> > Hello Tiffany Lin,
> >
> > The patch 590577a4e525: "[media] vcodec: mediatek: Add Mediatek V4L2
> > Video Decoder Driver" from Sep 2, 2016, leads to the following static
> > checker warning:
> >
> > 	drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c:536 vidioc_vdec_qbuf()
> > 	error: buffer overflow 'vq->bufs' 32 <= u32max
> >
> > drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
> >    520  static int vidioc_vdec_qbuf(struct file *file, void *priv,
> >    521                              struct v4l2_buffer *buf)
> >    522  {
> >    523          struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> >    524          struct vb2_queue *vq;
> >    525          struct vb2_buffer *vb;
> >    526          struct mtk_video_dec_buf *mtkbuf;
> >    527          struct vb2_v4l2_buffer  *vb2_v4l2;
> >    528
> >    529          if (ctx->state == MTK_STATE_ABORT) {
> >    530                  mtk_v4l2_err("[%d] Call on QBUF after unrecoverable error",
> >    531                                  ctx->id);
> >    532                  return -EIO;
> >    533          }
> >    534
> >    535          vq = v4l2_m2m_get_vq(ctx->m2m_ctx, buf->type);
> >    536          vb = vq->bufs[buf->index];
> >
> > Smatch thinks that "buf->index" comes straight from the user without
> > being checked and that this is a buffer overflow.  It seems simple
> > enough to analyse the call tree.
> >
> > __video_do_ioctl()
> > ->  v4l_qbuf()
> >   -> vidioc_vdec_qbuf()
> >
> > It seems like Smatch is correct.  I looked at a different implementation
> > of this and that one wasn't checked either so maybe there is something
> > I am not seeing.
> >
> > This has obvious security implications.  Can someone take a look at
> > this?
> 
> This is indeed wrong.
> 
> The v4l2_m2m_qbuf() call at the end of this function calls in turn 
> vb2_qbuf which
> will check the index. But if you override vidioc_qbuf (or 
> vidioc_prepare), then
> you need to check the index value.
> 
> I double-checked all cases where vidioc_qbuf was set to a 
> driver-specific function
> and this is the only driver that doesn't check the index field. In all 
> other cases
> it is either checked, or it is not used before calling into the vb1/vb2 
> framework
> which checks this.
> 
> So luckily this only concerns this driver.

Thanks for point out this issue.
As Hans' mentioned, our driver access index field in v4l2_buffer before
framework check buffer index.
We will prepare patch for this issue.


best regards,
Tiffany


> 
> Regards,
> 
> 	Hans
> 
> >
> >    537          vb2_v4l2 = container_of(vb, struct vb2_v4l2_buffer, vb2_buf);
> >    538          mtkbuf = container_of(vb2_v4l2, struct mtk_video_dec_buf, vb);
> >    539
> >    540          if ((buf->type == V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE) &&
> >    541              (buf->m.planes[0].bytesused == 0)) {
> >    542                  mtkbuf->lastframe = true;
> >    543                  mtk_v4l2_debug(1, "[%d] (%d) id=%d lastframe=%d (%d,%d, %d) vb=%p",
> >    544                           ctx->id, buf->type, buf->index,
> >    545                           mtkbuf->lastframe, buf->bytesused,
> >    546                           buf->m.planes[0].bytesused, buf->length,
> >    547                           vb);
> >    548          }
> >    549
> >    550          return v4l2_m2m_qbuf(file, ctx->m2m_ctx, buf);
> >    551  }
> >
> > regards,
> > dan carpenter
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >


