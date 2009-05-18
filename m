Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kolorific.com ([61.63.28.39]:52864 "EHLO
	mail.kolorific.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbZERDxa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2009 23:53:30 -0400
Subject: Re: [PATCH]saa7134-video.c: poll method lose race condition
From: "figo.zhang" <figo.zhang@kolorific.com>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, g.liakhovetski@gmx.de,
	linux-media@vger.kernel.org, figo1802@126.com, kraxel@bytesex.org,
	Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <1242616075.3747.20.camel@pc07.localdom.local>
References: <1242612794.3442.19.camel@myhost>
	 <1242616075.3747.20.camel@pc07.localdom.local>
Content-Type: text/plain
Date: Mon, 18 May 2009 11:53:25 +0800
Message-Id: <1242618805.3442.45.camel@myhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-05-18 at 05:07 +0200, hermann pitton wrote:
> Am Montag, den 18.05.2009, 10:13 +0800 schrieb figo.zhang:
> > saa7134-video.c: poll method lose race condition
> > 
> > 
> > Signed-off-by: Figo.zhang <figo.zhang@kolorific.com>
> > --- 
> > drivers/media/video/saa7134/saa7134-video.c |    9 ++++++---
> >  1 files changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/video/saa7134/saa7134-video.c b/drivers/media/video/saa7134/saa7134-video.c
> > index 493cad9..95733df 100644
> > --- a/drivers/media/video/saa7134/saa7134-video.c
> > +++ b/drivers/media/video/saa7134/saa7134-video.c
> > @@ -1423,11 +1423,13 @@ video_poll(struct file *file, struct poll_table_struct *wait)
> >  {
> >  	struct saa7134_fh *fh = file->private_data;
> >  	struct videobuf_buffer *buf = NULL;
> > +	unsigned int rc = 0;
> >  
> >  	if (V4L2_BUF_TYPE_VBI_CAPTURE == fh->type)
> >  		return videobuf_poll_stream(file, &fh->vbi, wait);
> >  
> >  	if (res_check(fh,RESOURCE_VIDEO)) {
> > +		mutex_lock(&fh->cap.vb_lock);
> >  		if (!list_empty(&fh->cap.stream))
> >  			buf = list_entry(fh->cap.stream.next, struct videobuf_buffer, stream);
> >  	} else {
> > @@ -1446,13 +1448,14 @@ video_poll(struct file *file, struct poll_table_struct *wait)
> >  	}
> >  
> >  	if (!buf)
> > -		return POLLERR;
> > +		rc = POLLERR;
> >  
> >  	poll_wait(file, &buf->done, wait);
> >  	if (buf->state == VIDEOBUF_DONE ||
> >  	    buf->state == VIDEOBUF_ERROR)
> > -		return POLLIN|POLLRDNORM;
> > -	return 0;
> > +		rc = POLLIN|POLLRDNORM;
> > +	mutex_unlock(&fh->cap.vb_lock);
> > +	return rc;
> >  
> >  err:
> >  	mutex_unlock(&fh->cap.vb_lock);
> > 
> > 
> 
> Can you please give some description on what your patch might do
> something?
> 
> Or are you a robot?
> 
> Then, please give us your serial number, production year, and when we
> can expect you are out of duty and replaced ;)
> 
> Cheers,
> Hermann
> 
> 
> 

hi, I just using the saa7134 chip to do a video capture card. The
saa7134 driver in linux kernel, i found that the poll method have lose 
race condition for "RESOURCE_VIDEO". It have better to add a mutex lock.

