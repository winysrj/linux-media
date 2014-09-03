Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:13428 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbaICU5j (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Sep 2014 16:57:39 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBC00AZ4FK1TQ10@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 03 Sep 2014 16:57:37 -0400 (EDT)
Date: Wed, 03 Sep 2014 17:57:33 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 04/46] [media] vivid-vid-out: use memdup_user()
Message-id: <20140903175733.4dc2428c.m.chehab@samsung.com>
In-reply-to: <54077EEB.4040701@xs4all.nl>
References: <cover.1409775488.git.m.chehab@samsung.com>
 <8e3336dbdbd26a56fb6817a4dc7cb31d860e8c5d.1409775488.git.m.chehab@samsung.com>
 <54077EEB.4040701@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 03 Sep 2014 22:49:47 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 09/03/2014 10:32 PM, Mauro Carvalho Chehab wrote:
> > Instead of allocating and coping from __user, do it using
> > one atomic call. That makes the code simpler. Also,
> 
> Also what?

I added a comment about IS_ERR(new_bitmap), and returning
the error, but then I realized that the above is good enough,
but I forgot the "Also, " at the above line. Thanks for
pointing it.

> 
> Anyway, looks good to me:
> 
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!
Mauro
> 
> Regards,
> 
> 	Hans
> 
> > 
> > Found by coccinelle.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > 
> > diff --git a/drivers/media/platform/vivid/vivid-vid-out.c b/drivers/media/platform/vivid/vivid-vid-out.c
> > index c983461f29d5..8ed9f6d9f505 100644
> > --- a/drivers/media/platform/vivid/vivid-vid-out.c
> > +++ b/drivers/media/platform/vivid/vivid-vid-out.c
> > @@ -897,14 +897,10 @@ int vidioc_s_fmt_vid_out_overlay(struct file *file, void *priv,
> >  		return ret;
> >  
> >  	if (win->bitmap) {
> > -		new_bitmap = kzalloc(bitmap_size, GFP_KERNEL);
> > +		new_bitmap = memdup_user(win->bitmap, bitmap_size);
> >  
> > -		if (new_bitmap == NULL)
> > -			return -ENOMEM;
> > -		if (copy_from_user(new_bitmap, win->bitmap, bitmap_size)) {
> > -			kfree(new_bitmap);
> > -			return -EFAULT;
> > -		}
> > +		if (IS_ERR(new_bitmap))
> > +			return PTR_ERR(new_bitmap);
> >  	}
> >  
> >  	dev->overlay_out_top = win->w.top;
> > 
> 
