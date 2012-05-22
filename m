Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28777 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab2EVQan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 May 2012 12:30:43 -0400
Date: Tue, 22 May 2012 18:30:32 +0200
From: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Paulo Assis <pj.assis@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Problems with the gspca_ov519 driver
Message-ID: <20120522163032.GC1927@vicerveza.homeunix.net>
References: <20120522110018.GX1927@vicerveza.homeunix.net>
 <CAPueXH6uN4UQO_WL_pc9wBoZV=v_7AVtQKcruKY=BCMeJOw-2Q@mail.gmail.com>
 <4FBBA515.7010006@redhat.com>
 <20120522152703.GA1927@vicerveza.homeunix.net>
 <4FBBBEA2.5050200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4FBBBEA2.5050200@redhat.com>
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 22, 2012 at 06:28:18PM +0200, Hans de Goede wrote:
> Hi,
> 
> On 05/22/2012 05:27 PM, Lluís Batlle i Rossell wrote:
> >Is this over linux 3.4 mainline? Because I can't get the patch applied over it.
> 
> No it is against:
> http://git.linuxtv.org/media_tree.git/shortlog/refs/heads/staging/for_v3.5
> 
> But it should be trivial to backport, the patch is only 3 lines.

I tried to, but I couldn't find any match for
"video_drvdata". I'll check again.

Thank you.

> >
> >Regards,
> >Lluís.
> >
> >On Tue, May 22, 2012 at 04:39:17PM +0200, Hans de Goede wrote:
> >>Hi,
> >>
> >>On 05/22/2012 04:08 PM, Paulo Assis wrote:
> >>>Hi,
> >>>This bug also causes the camera to crash when changing fps in
> >>>guvcview, uvc devices (at least all the ones I tested) require the
> >>>stream to be restarted for fps to change, so in the case of this
> >>>driver after STREAMOFF the camera just becomes unresponsive.
> >>>
> >>>Regards,
> >>>Paulo
> >>>
> >>>2012/5/22 Lluís Batlle i Rossell<viric@viric.name>:
> >>>>Hello,
> >>>>
> >>>>I'm trying to get video using v4l2 ioctls from a gspca_ov519 camera, and after
> >>>>STREAMOFF all buffers are still flagged as QUEUED, and QBUF fails.  DQBUF also
> >>>>fails (blocking for a 3 sec timeout), after streamoff. So I'm stuck, after
> >>>>STREAMOFF, unable to get pictures coming in again. (Linux 3.3.5).
> >>>>
> >>>>As an additional note, pinchartl on irc #v4l says to favour a moving of gspca to
> >>>>vb2. I don't know what it means.
> >>>>
> >>>>Can someone take care of the bug, or should I consider the camera 'non working'
> >>>>in linux?
> >>
> >>We talked about this on irc, attached it a patch which should fix this, feedback
> >>appreciated.
> >>
> >>Regards,
> >>
> >>Hans
> >
> >> From b0eefa00c72e9dfe9eaa5f425c0d346b19ea01cd Mon Sep 17 00:00:00 2001
> >>From: Hans de Goede<hdegoede@redhat.com>
> >>Date: Tue, 22 May 2012 16:24:05 +0200
> >>Subject: [PATCH] gspca-core: Fix buffers staying in queued state after a
> >>  stream_off
> >>
> >>Signed-off-by: Hans de Goede<hdegoede@redhat.com>
> >>---
> >>  drivers/media/video/gspca/gspca.c |    4 +++-
> >>  1 file changed, 3 insertions(+), 1 deletion(-)
> >>
> >>diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
> >>index 137166d..31721ea 100644
> >>--- a/drivers/media/video/gspca/gspca.c
> >>+++ b/drivers/media/video/gspca/gspca.c
> >>@@ -1653,7 +1653,7 @@ static int vidioc_streamoff(struct file *file, void *priv,
> >>  				enum v4l2_buf_type buf_type)
> >>  {
> >>  	struct gspca_dev *gspca_dev = video_drvdata(file);
> >>-	int ret;
> >>+	int i, ret;
> >>
> >>  	if (buf_type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> >>  		return -EINVAL;
> >>@@ -1678,6 +1678,8 @@ static int vidioc_streamoff(struct file *file, void *priv,
> >>  	wake_up_interruptible(&gspca_dev->wq);
> >>
> >>  	/* empty the transfer queues */
> >>+	for (i = 0; i<  gspca_dev->nframes; i++)
> >>+		gspca_dev->frame[i].v4l2_buf.flags&= ~BUF_ALL_FLAGS;
> >>  	atomic_set(&gspca_dev->fr_q, 0);
> >>  	atomic_set(&gspca_dev->fr_i, 0);
> >>  	gspca_dev->fr_o = 0;
> >>--
> >>1.7.10
> >>
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
