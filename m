Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:34088 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751759AbeAYMZv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 07:25:51 -0500
Date: Thu, 25 Jan 2018 15:25:22 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [bug report] [media] s5p-mfc: use MFC_BUF_FLAG_EOS to identify
 last buffers in decoder capture queue
Message-ID: <20180125122522.vdly5ketvkugq53h@mwanda>
References: <CGME20180123083259epcas3p1fb9a8b4e4ad34eb245fca67d4204cba4@epcas3p1.samsung.com>
 <20180123083245.GA10091@mwanda>
 <e30dedbc-68bc-fae8-ffb7-5cdea05f534d@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e30dedbc-68bc-fae8-ffb7-5cdea05f534d@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 25, 2018 at 10:58:45AM +0100, Andrzej Hajda wrote:
> On 23.01.2018 09:32, Dan Carpenter wrote:
> > Hello Andrzej Hajda,
> >
> > The patch 4d0b0ed63660: "[media] s5p-mfc: use MFC_BUF_FLAG_EOS to
> > identify last buffers in decoder capture queue" from Oct 7, 2015,
> > leads to the following static checker warning:
> >
> > 	drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:658 vidioc_dqbuf()
> > 	error: buffer overflow 'ctx->dst_bufs' 32 user_rl = '0-u32max'
> >
> > drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
> >    635  /* Dequeue a buffer */
> >    636  static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
> >    637  {
> >    638          const struct v4l2_event ev = {
> >    639                  .type = V4L2_EVENT_EOS
> >    640          };
> >    641          struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
> >    642          int ret;
> >    643  
> >    644          if (ctx->state == MFCINST_ERROR) {
> >    645                  mfc_err_limited("Call on DQBUF after unrecoverable error\n");
> >    646                  return -EIO;
> >    647          }
> >    648  
> >    649          switch (buf->type) {
> >    650          case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
> >    651                  return vb2_dqbuf(&ctx->vq_src, buf, file->f_flags & O_NONBLOCK);
> >    652          case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
> >    653                  ret = vb2_dqbuf(&ctx->vq_dst, buf, file->f_flags & O_NONBLOCK);
> >    654                  if (ret)
> >    655                          return ret;
> >    656  
> >    657                  if (ctx->state == MFCINST_FINISHED &&
> >    658                      (ctx->dst_bufs[buf->index].flags & MFC_BUF_FLAG_EOS))
> >                                            ^^^^^^^^^^
> > Smatch is complaining that "buf->index" is not capped.  So far as I can
> > see this is true.  I would have expected it to be checked in
> > check_array_args() or video_usercopy() but I couldn't find the check.
> 
> I did not work in V4L2 area for long time, so I could be wrong, but I
> hope the code is correct, below my explanation.
> User provides only type, memory and reserved fields in buf, other fields
> are filled by vb2_dqbuf (line 653) core function, ie index field is
> copied from buffer which was queued by qbuf.
> And vidioc_qbuf calls vb2_qbuf, which calls vb2_queue_or_prepare_buf,
> which checks index bounds [1].
> 
> So I suppose this code is correct.
> Btw, I have also looked at other drivers and it looks omap driver
> handles it incorrectly, ie it uses index field provided by user -
> possible memory leak. CC Hans and Mauro, since there is no driver
> maintainer of OMAP.
> 
> Btw2, is it possible to check in smatch which fields of passed struct
> given callback can read or fill ? For example here API restrict dqbuf
> callback to read only three fields of buf, and fill the others.
> 
> [1]:
> http://elixir.free-electrons.com/linux/latest/source/drivers/media/v4l2-core/videobuf2-v4l2.c#L165
> [2]:
> http://elixir.free-electrons.com/linux/latest/source/drivers/media/platform/omap/omap_vout.c#L1520
> 
> Regards
> Andrzej

Smatch does track the feilds...  Smatch sees that buf->index is capped
in vidioc_qbuf() but it still complains that buf->index gets set by the
user in the ioctl and not checked before we use it vb2_dqbuf().  The
call tree looks like this:

--> video_usercopy()
    Copies _IOC_SIZE(cmd) bytes to parg.  The _IOC_SIZE() is
    sizeof(struct v4l2_buffer) so all the feilds are reset.  Smatch
    doesn't track how many bytes the users controls, it just marks
    everything in *parg as tainted but it doesn't matter in this case
    since all the feilds are set.
    video_usercopy() calls err = func(file, cmd, parg);

    --> __video_do_ioctl()
        calls info->u.func(ops, file, fh, arg);

        --> v4l_dqbuf()
            calls ops->vidioc_dqbuf(file, fh, p);

            --> vidioc_dqbuf()
                uses unchecked buf->index

Ah...  Hm.  Is it the call to vb2_core_dqbuf() which limits buf->index?
I don't see a path from vb2_core_dqbuf() to vb2_qbuf() but I may have
missed it.

regards,
dan carpenter
