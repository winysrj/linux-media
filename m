Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:51939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab3CFPOa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Mar 2013 10:14:30 -0500
Date: Wed, 6 Mar 2013 16:14:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: "corbet@lwn.net" <corbet@lwn.net>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Libin Yang <lbyang@marvell.com>
Subject: RE: [REVIEW PATCH V4 09/12] [media] marvell-ccic: use unsigned int
 type replace int type
In-Reply-To: <477F20668A386D41ADCC57781B1F70430D9D8DAA8D@SC-VEXCH1.marvell.com>
Message-ID: <Pine.LNX.4.64.1303061613370.7010@axis700.grange>
References: <1360238687-15768-1-git-send-email-twang13@marvell.com>
 <1360238687-15768-10-git-send-email-twang13@marvell.com>
 <Pine.LNX.4.64.1303051134220.25837@axis700.grange>
 <477F20668A386D41ADCC57781B1F70430D9D8DAA8D@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 6 Mar 2013, Albert Wang wrote:

> Hi, Guennadi
> 
> 
> >-----Original Message-----
> >From: Guennadi Liakhovetski [mailto:g.liakhovetski@gmx.de]
> >Sent: Tuesday, 05 March, 2013 18:43
> >To: Albert Wang
> >Cc: corbet@lwn.net; linux-media@vger.kernel.org; Libin Yang
> >Subject: Re: [REVIEW PATCH V4 09/12] [media] marvell-ccic: use unsigned int type
> >replace int type
> >
> >I'm not against this patch, but I don't see a lot of meaning in it either,
> >apart from the .irq part - that makes the type match *request_*irq()
> >prototypes. Apart from that... Using "int i" for a simple iterator, that
> >doesn't go beyond INT_MAX is kinda traditional, I think. You change int
> >frame to unsigned, but if you look at mcam_buffer_done(), as it is called
> >from mcam_frame_tasklet(), the
> >
> >		int bufno = cam->next_buf;
> >
> >variable is used for its second parameter (int frame). And ->next_buf is
> >declared as (signed) int, and can indeed be negative in
> >mcam_reset_buffers():
> >
> >	cam->next_buf = -1;
> >
> >So... You might need to be more careful with those changes, if you
> >_really_ need them. Otherwise, unless there are real reasons, like
> >matching an existing API, avoiding warnings, I'd really just drop all
> >this, perhaps, apart from ->irq.
> >
> Actually, this patch is prepared for [PATCH 12/12] [media] marvell-ccic: 
> add 3 frame buffers support in DMA_CONTIG mode
> In that patch we need do that calculate with frame:
> buf = cam->vb_bufs[(frame + (MAX_FRAME_BUFS - 1)) % MAX_FRAME_BUFS];
> 
> So we think frame should be unsigned from the original meaning.
> 
> But sometimes buffer number may be negative for some special design, I leave them alone.
> 
> So how about we change to keep buffer number with original definition if 
> you think there is no meaning to change it and just change frame number 
> and irq?

Sounds good to me!

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
