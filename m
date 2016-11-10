Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43791 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932825AbcKJNau (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 08:30:50 -0500
Date: Thu, 10 Nov 2016 16:30:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: tiffany.lin@mediatek.com, linux-media@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [bug report] [media] vcodec: mediatek: Add Mediatek V4L2 Video
 Decoder Driver
Message-ID: <20161110120028.GG28558@mwanda>
References: <20161109132820.GA26677@mwanda>
 <9794dab1-94ba-c384-85c5-edb8831810ff@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9794dab1-94ba-c384-85c5-edb8831810ff@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 09, 2016 at 02:45:21PM +0100, Hans Verkuil wrote:
> On 11/09/16 14:28, Dan Carpenter wrote:
> >Hello Tiffany Lin,
> >
> >The patch 590577a4e525: "[media] vcodec: mediatek: Add Mediatek V4L2
> >Video Decoder Driver" from Sep 2, 2016, leads to the following static
> >checker warning:
> >
> >	drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c:536 vidioc_vdec_qbuf()
> >	error: buffer overflow 'vq->bufs' 32 <= u32max
> >
> >drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
> >   520  static int vidioc_vdec_qbuf(struct file *file, void *priv,
> >   521                              struct v4l2_buffer *buf)
> >   522  {
> >   523          struct mtk_vcodec_ctx *ctx = fh_to_ctx(priv);
> >   524          struct vb2_queue *vq;
> >   525          struct vb2_buffer *vb;
> >   526          struct mtk_video_dec_buf *mtkbuf;
> >   527          struct vb2_v4l2_buffer  *vb2_v4l2;
> >   528
> >   529          if (ctx->state == MTK_STATE_ABORT) {
> >   530                  mtk_v4l2_err("[%d] Call on QBUF after unrecoverable error",
> >   531                                  ctx->id);
> >   532                  return -EIO;
> >   533          }
> >   534
> >   535          vq = v4l2_m2m_get_vq(ctx->m2m_ctx, buf->type);
> >   536          vb = vq->bufs[buf->index];
> >
> >Smatch thinks that "buf->index" comes straight from the user without
> >being checked and that this is a buffer overflow.  It seems simple
> >enough to analyse the call tree.
> >
> >__video_do_ioctl()
> >->  v4l_qbuf()
> >  -> vidioc_vdec_qbuf()
> >
> >It seems like Smatch is correct.  I looked at a different implementation
> >of this and that one wasn't checked either so maybe there is something
> >I am not seeing.
> >
> >This has obvious security implications.  Can someone take a look at
> >this?
> 
> This is indeed wrong.
> 
> The v4l2_m2m_qbuf() call at the end of this function calls in turn
> vb2_qbuf which
> will check the index.

There could be an issue before you reach v4l2_m2m_qbuf() because we
set "mtkbuf->lastframe = true;" so we could be corrupting random
memory.

I re-reviewed the other function I looked at earlier and that one was OK
though.

regards,
dan carpenter

