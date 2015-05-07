Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36435 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbbEGMVW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 May 2015 08:21:22 -0400
Received: by wizk4 with SMTP id k4so240263947wiz.1
        for <linux-media@vger.kernel.org>; Thu, 07 May 2015 05:21:21 -0700 (PDT)
From: Federico Vaga <federico.vaga@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] sta2x11: use monotonic timestamp
Date: Thu, 07 May 2015 14:21:19 +0200
Message-ID: <2347103.pAouf8C2Rx@number-5>
In-Reply-To: <554B05C8.3010309@xs4all.nl>
References: <554B0496.7050902@xs4all.nl> <554B05C8.3010309@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 07 May 2015 08:27:20 Hans Verkuil wrote:
> Added Federico to the CC-list.

Fine for me 

Acked-by: Federico Vaga <federico.vaga@gmail.com>

> On 05/07/2015 08:22 AM, Hans Verkuil wrote:
> > V4L2 drivers should use MONOTONIC timestamps instead of gettimeofday,
> > which is affected by daylight savings time.
> > 
> > diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c
> > b/drivers/media/pci/sta2x11/sta2x11_vip.c index d384a6b..59b3a36 100644
> > --- a/drivers/media/pci/sta2x11/sta2x11_vip.c
> > +++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
> > @@ -813,7 +813,7 @@ static irqreturn_t vip_irq(int irq, struct sta2x11_vip
> > *vip)> 
> >  		/* Disable acquisition */
> >  		reg_write(vip, DVP_CTL, reg_read(vip, DVP_CTL) & ~DVP_CTL_ENA);
> >  		/* Remove the active buffer from the list */
> > 
> > -		do_gettimeofday(&vip->active->vb.v4l2_buf.timestamp);
> > +		v4l2_get_timestamp(&vip->active->vb.v4l2_buf.timestamp);
> > 
> >  		vip->active->vb.v4l2_buf.sequence = vip->sequence++;
> >  		vb2_buffer_done(&vip->active->vb, VB2_BUF_STATE_DONE);
> >  	
> >  	}
> > 
> > @@ -864,6 +864,7 @@ static int sta2x11_vip_init_buffer(struct sta2x11_vip
> > *vip)> 
> >  	vip->vb_vidq.buf_struct_size = sizeof(struct vip_buffer);
> >  	vip->vb_vidq.ops = &vip_video_qops;
> >  	vip->vb_vidq.mem_ops = &vb2_dma_contig_memops;
> > 
> > +	vip->vb_vidq.timestamp_flags = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
> > 
> >  	err = vb2_queue_init(&vip->vb_vidq);
> >  	if (err)
> >  	
> >  		return err;
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Federico Vaga
