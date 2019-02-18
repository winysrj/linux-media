Return-Path: <SRS0=xMd0=QZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E33C43381
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 23:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 35AE22176F
	for <linux-media@archiver.kernel.org>; Mon, 18 Feb 2019 23:43:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="bAjKnAjS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731047AbfBRXnt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 18 Feb 2019 18:43:49 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:37212 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfBRXnt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Feb 2019 18:43:49 -0500
Received: from pendragon.ideasonboard.com (91-152-6-44.elisa-laajakaista.fi [91.152.6.44])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 79D8E53B;
        Tue, 19 Feb 2019 00:43:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550533426;
        bh=7rx9h20t6bx48havxWNBB9s9Ohnsk0pTpJsU1kC76Ng=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bAjKnAjS/0J5yXSSy+gNGJ68p2JNt/X6ogQ5tGz8D3ocMNBY/+tR6KZPMN8oFR1Fk
         +wfjP6n78ZdbAOTNcqUDuV4iXivO31l6xb60fMqKtn4jiXExx9/m/aXqFwj8HfECTa
         SUM4sc1nqsYB4lGXEypFJCanI5dq70OH5VI8BZ9Y=
Date:   Tue, 19 Feb 2019 01:43:42 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v4 5/7] media: vsp1: Refactor
 vsp1_video_complete_buffer() for later reuse
Message-ID: <20190218234342.GD5082@pendragon.ideasonboard.com>
References: <20190217024852.23328-1-laurent.pinchart+renesas@ideasonboard.com>
 <20190217024852.23328-6-laurent.pinchart+renesas@ideasonboard.com>
 <7b388ea1-fc35-01b9-64a4-7710068cb5e1@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7b388ea1-fc35-01b9-64a4-7710068cb5e1@ideasonboard.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Kieran,

On Sun, Feb 17, 2019 at 08:35:25PM +0000, Kieran Bingham wrote:
> On 17/02/2019 02:48, Laurent Pinchart wrote:
> > The vsp1_video_complete_buffer() function completes the current buffer
> > and returns a pointer to the next buffer. Split the code that completes
> > the buffer to a separate function for later reuse, and rename
> > vsp1_video_complete_buffer() to vsp1_video_complete_next_buffer().
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> This looks good to me - except perhaps the documentation /might/ need
> some refresh. With or without updates there, the code changes look good
> to me:
> 
> Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
> 
> > ---
> >  drivers/media/platform/vsp1/vsp1_video.c | 35 ++++++++++++++----------
> >  1 file changed, 20 insertions(+), 15 deletions(-)
> > 
> > diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
> > index 328d686189be..cfbab16c4820 100644
> > --- a/drivers/media/platform/vsp1/vsp1_video.c
> > +++ b/drivers/media/platform/vsp1/vsp1_video.c
> > @@ -300,8 +300,22 @@ static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
> >   * Pipeline Management
> >   */
> >  
> > +static void vsp1_video_complete_buffer(struct vsp1_video *video,
> > +				       struct vsp1_vb2_buffer *buffer)
> > +{
> > +	struct vsp1_pipeline *pipe = video->rwpf->entity.pipe;
> > +	unsigned int i;
> > +
> > +	buffer->buf.sequence = pipe->sequence;
> > +	buffer->buf.vb2_buf.timestamp = ktime_get_ns();
> > +	for (i = 0; i < buffer->buf.vb2_buf.num_planes; ++i)
> > +		vb2_set_plane_payload(&buffer->buf.vb2_buf, i,
> > +				      vb2_plane_size(&buffer->buf.vb2_buf, i));
> > +	vb2_buffer_done(&buffer->buf.vb2_buf, VB2_BUF_STATE_DONE);
> > +}
> > +
> >  /*
> > - * vsp1_video_complete_buffer - Complete the current buffer
> > + * vsp1_video_complete_next_buffer - Complete the current buffer
> 
> Should the brief be updated?
> It looks quite odd to call the function "complete next buffer" but with
> a brief saying "complete the current buffer".
> 
> Technically it's still correct, but it's more like
> "Complete the current buffer and return the next buffer"
> or such.

Good point. I'll update the brief to that.

> >   * @video: the video node
> >   *
> >   * This function completes the current buffer by filling its sequence number,
> 
> Is this still accurate enough to keep the text as is ?

It's still true, isn't it ?

> > @@ -310,13 +324,11 @@ static int vsp1_video_pipeline_setup_partitions(struct vsp1_pipeline *pipe)
> >   * Return the next queued buffer or NULL if the queue is empty.
> >   */
> >  static struct vsp1_vb2_buffer *
> > -vsp1_video_complete_buffer(struct vsp1_video *video)
> > +vsp1_video_complete_next_buffer(struct vsp1_video *video)
> >  {
> > -	struct vsp1_pipeline *pipe = video->rwpf->entity.pipe;
> > -	struct vsp1_vb2_buffer *next = NULL;
> > +	struct vsp1_vb2_buffer *next;
> >  	struct vsp1_vb2_buffer *done;
> >  	unsigned long flags;
> > -	unsigned int i;
> >  
> >  	spin_lock_irqsave(&video->irqlock, flags);
> >  
> > @@ -327,21 +339,14 @@ vsp1_video_complete_buffer(struct vsp1_video *video)
> >  
> >  	done = list_first_entry(&video->irqqueue,
> >  				struct vsp1_vb2_buffer, queue);
> > -
> >  	list_del(&done->queue);
> >  
> > -	if (!list_empty(&video->irqqueue))
> > -		next = list_first_entry(&video->irqqueue,
> > +	next = list_first_entry_or_null(&video->irqqueue,
> 
> That's a nice way to save a line.
> 
> >  					struct vsp1_vb2_buffer, queue);
> >  
> >  	spin_unlock_irqrestore(&video->irqlock, flags);
> >  
> > -	done->buf.sequence = pipe->sequence;
> > -	done->buf.vb2_buf.timestamp = ktime_get_ns();
> > -	for (i = 0; i < done->buf.vb2_buf.num_planes; ++i)
> > -		vb2_set_plane_payload(&done->buf.vb2_buf, i,
> > -				      vb2_plane_size(&done->buf.vb2_buf, i));
> > -	vb2_buffer_done(&done->buf.vb2_buf, VB2_BUF_STATE_DONE);
> > +	vsp1_video_complete_buffer(video, done);
> >  
> >  	return next;
> >  }
> > @@ -352,7 +357,7 @@ static void vsp1_video_frame_end(struct vsp1_pipeline *pipe,
> >  	struct vsp1_video *video = rwpf->video;
> >  	struct vsp1_vb2_buffer *buf;
> >  
> > -	buf = vsp1_video_complete_buffer(video);
> > +	buf = vsp1_video_complete_next_buffer(video);
> >  	if (buf == NULL)
> >  		return;
> >  

-- 
Regards,

Laurent Pinchart
