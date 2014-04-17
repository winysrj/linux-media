Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w2.samsung.com ([211.189.100.11]:22330 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbaDQC0f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 22:26:35 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout1.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N45009ADLG91800@mailout1.w2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 16 Apr 2014 22:26:33 -0400 (EDT)
Date: Wed, 16 Apr 2014 23:26:26 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	pawel@osciak.com, sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 01/13] vb2: stop_streaming should return void
Message-id: <20140416232626.7ae7ba9e@samsung.com>
In-reply-to: <20140416183825.141e238e@samsung.com>
References: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
 <1397203879-37443-2-git-send-email-hverkuil@xs4all.nl>
 <20140416183825.141e238e@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Em Wed, 16 Apr 2014 18:38:25 -0300
Mauro Carvalho Chehab <m.chehab@samsung.com> escreveu:

> Em Fri, 11 Apr 2014 10:11:07 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > From: Hans Verkuil <hans.verkuil@cisco.com>
> > 

> > --- a/drivers/media/platform/blackfin/bfin_capture.c
> > +++ b/drivers/media/platform/blackfin/bfin_capture.c
> > @@ -427,15 +427,12 @@ static int bcap_start_streaming(struct vb2_queue *vq, unsigned int count)
> >  	return 0;
> >  }
> >  
> > -static int bcap_stop_streaming(struct vb2_queue *vq)
> > +static void bcap_stop_streaming(struct vb2_queue *vq)
> >  {
> >  	struct bcap_device *bcap_dev = vb2_get_drv_priv(vq);
> >  	struct ppi_if *ppi = bcap_dev->ppi;
> >  	int ret;
> >  
> > -	if (!vb2_is_streaming(vq))
> > -		return 0;
> > -
> 
> Why are you dropping this? IMHO, you should be doing, instead:
> 	if (!vb2_is_streaming(vq))
> 		return;
> 
> Except if you're 100% sure that checking it here can be removed. On
> this case, please put this on a separate patch, clearly explaining
> why we can safely remove this.
> 
> Please notice that on other similar parts of this patch, you didn't remove
> the test, just removed the returned parameter.

As I said before, if you need to remove the vb2_is_streaming(vq) check
above, please do it on a separate patch, properly justifying why you're
doing that.

This hunk is still present on your new pull request.


-- 

Regards,
Mauro
