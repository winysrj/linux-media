Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44091 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933347AbbFWWfH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2015 18:35:07 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kamil Debski <kamil@wypas.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [URGENT FOR v4.1] [PATCH v2] vb2: Don't WARN when v4l2_buffer.bytesused is 0 for multiplanar buffers
Date: Wed, 24 Jun 2015 01:35:04 +0300
Message-ID: <1670891.xNAi0XVAL4@avalon>
In-Reply-To: <CAP3TMiHyy7oVr447ubJzDU1Yw=Lwz=vkFVwB9pmdWGjtj9UzGw@mail.gmail.com>
References: <1434715358-28325-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <CAP3TMiGz4Gwd_SnkaPkj0PwuDdZZtPOp2foWn+9gY-khuqgSeA@mail.gmail.com> <CAP3TMiHyy7oVr447ubJzDU1Yw=Lwz=vkFVwB9pmdWGjtj9UzGw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On Tuesday 23 June 2015 13:51:37 Kamil Debski wrote:
> Hi,
> 
> Just to let you know - the patch that is applied to media_tree/master
> [1] and media_tree/fixes [2] is v1 and not v2. I think it should be
> v2.

Thank you for noticing that.

Mauro, is rebasing an option ? Otherwise I can send a fix to fix the fix :)-

> [1]
> http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?id=77a3c6fd90c94f635
> edb00d4a65f485687538791 [2]
> http://git.linuxtv.org/cgit.cgi/media_tree.git/commit/?h=fixes&id=2c7e2e565
> 651c930387effb16ecb8f2f4b42bd45
> On 19 June 2015 at 13:05, Kamil Debski <kamil@wypas.org> wrote:
> > Hi Laurent,
> > 
> > First - thank you so much for the patch. I had a look into the code
> > and it looks good. You have my Ack.
> > 
> > Thank and best wishes,
> > Kamil Debski
> > 
> > On 19 June 2015 at 13:04, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >> On 06/19/2015 02:02 PM, Laurent Pinchart wrote:
> >>> Commit f61bf13b6a07 ("[media] vb2: add allow_zero_bytesused flag to the
> >>> vb2_queue struct") added a WARN_ONCE to catch usage of a deprecated API
> >>> using a zero value for v4l2_buffer.bytesused.
> >>> 
> >>> However, the condition is checked incorrectly, as the v4L2_buffer
> >>> bytesused field is supposed to be ignored for multiplanar buffers. This
> >>> results in spurious warnings when using the multiplanar API.
> >>> 
> >>> Fix it by checking v4l2_buffer.bytesused for uniplanar buffers and
> >>> v4l2_plane.bytesused for multiplanar buffers.
> >>> 
> >>> Fixes: f61bf13b6a07 ("[media] vb2: add allow_zero_bytesused flag to the
> >>> vb2_queue struct") Signed-off-by: Laurent Pinchart
> >>> <laurent.pinchart+renesas@ideasonboard.com>>> 
> >> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
> > 
> > Acked-by: Kamil Debski <kamil@wypas.org>
> > 
> >> Thanks!
> >> 
> >>         Hans
> >>> 
> >>> ---
> >>> 
> >>>  drivers/media/v4l2-core/videobuf2-core.c | 33
> >>>  ++++++++++++++++++++++---------- 1 file changed, 23 insertions(+), 10
> >>>  deletions(-)
> >>> 
> >>> Changes since v1:
> >>> 
> >>> - Rename __check_once to check_once
> >>> - Drop __read_mostly on check_once
> >>> - Use pr_warn instead of pr_warn_once
> >>> 
> >>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c
> >>> b/drivers/media/v4l2-core/videobuf2-core.c index
> >>> d835814a24d4..4eaf2f4f0294 100644
> >>> --- a/drivers/media/v4l2-core/videobuf2-core.c
> >>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
> >>> @@ -1242,6 +1242,23 @@ void vb2_discard_done(struct vb2_queue *q)
> >>> 
> >>>  }
> >>>  EXPORT_SYMBOL_GPL(vb2_discard_done);
> >>> 
> >>> +static void vb2_warn_zero_bytesused(struct vb2_buffer *vb)
> >>> +{
> >>> +     static bool check_once;
> >>> +
> >>> +     if (check_once)
> >>> +             return;
> >>> +
> >>> +     check_once = true;
> >>> +     __WARN();
> >>> +
> >>> +     pr_warn("use of bytesused == 0 is deprecated and will be removed
> >>> in the future,\n"); +     if (vb->vb2_queue->allow_zero_bytesused)
> >>> +             pr_warn("use VIDIOC_DECODER_CMD(V4L2_DEC_CMD_STOP)
> >>> instead.\n"); +     else
> >>> +             pr_warn("use the actual size instead.\n");
> >>> +}
> >>> +
> >>> 
> >>>  /**
> >>>  
> >>>   * __fill_vb2_buffer() - fill a vb2_buffer with information provided in
> >>>   a
> >>>   * v4l2_buffer by the userspace. The caller has already verified that
> >>>   struct
> >>> 
> >>> @@ -1252,16 +1269,6 @@ static void __fill_vb2_buffer(struct vb2_buffer
> >>> *vb, const struct v4l2_buffer *b>>> 
> >>>  {
> >>>  
> >>>       unsigned int plane;
> >>> 
> >>> -     if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> >>> -             if (WARN_ON_ONCE(b->bytesused == 0)) {
> >>> -                     pr_warn_once("use of bytesused == 0 is deprecated
> >>> and will be removed in the future,\n"); -                     if
> >>> (vb->vb2_queue->allow_zero_bytesused)
> >>> -                             pr_warn_once("use
> >>> VIDIOC_DECODER_CMD(V4L2_DEC_CMD_STOP) instead.\n"); -                  
> >>>   else
> >>> -                             pr_warn_once("use the actual size
> >>> instead.\n"); -             }
> >>> -     }
> >>> -
> >>> 
> >>>       if (V4L2_TYPE_IS_MULTIPLANAR(b->type)) {
> >>>       
> >>>               if (b->memory == V4L2_MEMORY_USERPTR) {
> >>>               
> >>>                       for (plane = 0; plane < vb->num_planes; ++plane) {
> >>> 
> >>> @@ -1302,6 +1309,9 @@ static void __fill_vb2_buffer(struct vb2_buffer
> >>> *vb, const struct v4l2_buffer *b>>> 
> >>>                               struct v4l2_plane *pdst =
> >>>                               &v4l2_planes[plane];
> >>>                               struct v4l2_plane *psrc =
> >>>                               &b->m.planes[plane];
> >>> 
> >>> +                             if (psrc->bytesused == 0)
> >>> +                                     vb2_warn_zero_bytesused(vb);
> >>> +
> >>> 
> >>>                               if (vb->vb2_queue->allow_zero_bytesused)
> >>>                               
> >>>                                       pdst->bytesused = psrc->bytesused;
> >>>                               
> >>>                               else
> >>> 
> >>> @@ -1336,6 +1346,9 @@ static void __fill_vb2_buffer(struct vb2_buffer
> >>> *vb, const struct v4l2_buffer *b>>> 
> >>>               }
> >>>               
> >>>               if (V4L2_TYPE_IS_OUTPUT(b->type)) {
> >>> 
> >>> +                     if (b->bytesused == 0)
> >>> +                             vb2_warn_zero_bytesused(vb);
> >>> +
> >>> 
> >>>                       if (vb->vb2_queue->allow_zero_bytesused)
> >>>                       
> >>>                               v4l2_planes[0].bytesused = b->bytesused;
> >>>                       
> >>>                       else

-- 
Regards,

Laurent Pinchart

