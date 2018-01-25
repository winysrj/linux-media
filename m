Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-3.cisco.com ([173.38.203.53]:25171 "EHLO
        aer-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbeAYKYK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Jan 2018 05:24:10 -0500
Subject: Re: [bug report] [media] s5p-mfc: use MFC_BUF_FLAG_EOS to identify
 last buffers in decoder capture queue
To: Andrzej Hajda <a.hajda@samsung.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
References: <CGME20180123083259epcas3p1fb9a8b4e4ad34eb245fca67d4204cba4@epcas3p1.samsung.com>
 <20180123083245.GA10091@mwanda>
 <e30dedbc-68bc-fae8-ffb7-5cdea05f534d@samsung.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <4012a45f-6848-4bb9-61cc-5be4529c5ddc@cisco.com>
Date: Thu, 25 Jan 2018 11:14:29 +0100
MIME-Version: 1.0
In-Reply-To: <e30dedbc-68bc-fae8-ffb7-5cdea05f534d@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/25/2018 10:58 AM, Andrzej Hajda wrote:
> On 23.01.2018 09:32, Dan Carpenter wrote:
>> Hello Andrzej Hajda,
>>
>> The patch 4d0b0ed63660: "[media] s5p-mfc: use MFC_BUF_FLAG_EOS to
>> identify last buffers in decoder capture queue" from Oct 7, 2015,
>> leads to the following static checker warning:
>>
>> 	drivers/media/platform/s5p-mfc/s5p_mfc_dec.c:658 vidioc_dqbuf()
>> 	error: buffer overflow 'ctx->dst_bufs' 32 user_rl = '0-u32max'
>>
>> drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
>>    635  /* Dequeue a buffer */
>>    636  static int vidioc_dqbuf(struct file *file, void *priv, struct v4l2_buffer *buf)
>>    637  {
>>    638          const struct v4l2_event ev = {
>>    639                  .type = V4L2_EVENT_EOS
>>    640          };
>>    641          struct s5p_mfc_ctx *ctx = fh_to_ctx(priv);
>>    642          int ret;
>>    643  
>>    644          if (ctx->state == MFCINST_ERROR) {
>>    645                  mfc_err_limited("Call on DQBUF after unrecoverable error\n");
>>    646                  return -EIO;
>>    647          }
>>    648  
>>    649          switch (buf->type) {
>>    650          case V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE:
>>    651                  return vb2_dqbuf(&ctx->vq_src, buf, file->f_flags & O_NONBLOCK);
>>    652          case V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE:
>>    653                  ret = vb2_dqbuf(&ctx->vq_dst, buf, file->f_flags & O_NONBLOCK);
>>    654                  if (ret)
>>    655                          return ret;
>>    656  
>>    657                  if (ctx->state == MFCINST_FINISHED &&
>>    658                      (ctx->dst_bufs[buf->index].flags & MFC_BUF_FLAG_EOS))
>>                                            ^^^^^^^^^^
>> Smatch is complaining that "buf->index" is not capped.  So far as I can
>> see this is true.  I would have expected it to be checked in
>> check_array_args() or video_usercopy() but I couldn't find the check.
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

Ouch, vidioc_dqbuf in drivers/media/platform/omap/omap_vout.c is really, really
bad code. I'm not sure how it could ever work to be honest. For one, b->index
should be returned by the driver, not set by userspace.

Luckily this driver is almost never used anymore.

Mauro, Laurent, I wonder if we just should use this reason to move this driver
to staging for one kernel release and then delete it. Rather than trying to
fix this crappy code.

Regards,

	Hans

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
>>
>>    659                          v4l2_event_queue_fh(&ctx->fh, &ev);
>>    660                  return 0;
>>    661          default:
>>    662                  return -EINVAL;
>>    663          }
>>    664  }
>>
>>
>> regards,
>> dan carpenter
>>
>>
>>
> 
