Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:55744 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928AbcDMWJn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Apr 2016 18:09:43 -0400
Date: Wed, 13 Apr 2016 19:09:37 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: <linux-media@vger.kernel.org>,
	Niklas =?UTF-8?B?U8O2ZGVybHVuZA==?=
	<niklas.soderlund+renesas@ragnatech.se>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 1/2] v4l2-ioctl: simplify code
Message-ID: <20160413190937.4d769daf@recife.lan>
In-Reply-To: <570EBF71.8050506@xs4all.nl>
References: <1458550080-42743-1-git-send-email-hverkuil@xs4all.nl>
	<1458550080-42743-2-git-send-email-hverkuil@xs4all.nl>
	<20160413165714.587c5e7c@recife.lan>
	<570EBF71.8050506@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 13 Apr 2016 23:51:45 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 04/13/2016 09:57 PM, Mauro Carvalho Chehab wrote:
> > Em Mon, 21 Mar 2016 09:47:59 +0100
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>
> >> Instead of a big if at the beginning, just check if g_selection == NULL
> >> and call the cropcap op immediately and return the result.
> >>
> >> No functional changes in this patch.  
> > 
> > Hmm... not true. See below.
> >   
> >>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>  
> > 
> > You forgot to add Miklas review here.
> >   
> >> ---
> >>  drivers/media/v4l2-core/v4l2-ioctl.c | 51 ++++++++++++++++++++----------------
> >>  1 file changed, 29 insertions(+), 22 deletions(-)
> >>
> >> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> >> index 6bf5a3e..3cf8d3a 100644
> >> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> >> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> >> @@ -2160,33 +2160,40 @@ static int v4l_cropcap(const struct v4l2_ioctl_ops *ops,
> >>  				struct file *file, void *fh, void *arg)
> >>  {
> >>  	struct v4l2_cropcap *p = arg;
> >> +	struct v4l2_selection s = { .type = p->type };
> >> +	int ret;
> >>  
> >> -	if (ops->vidioc_g_selection) {
> >> -		struct v4l2_selection s = { .type = p->type };
> >> -		int ret;
> >> +	if (ops->vidioc_g_selection == NULL) {
> >> +		/*
> >> +		 * The determine_valid_ioctls() call already should ensure
> >> +		 * that ops->vidioc_cropcap != NULL, but just in case...
> >> +		 */
> >> +		if (ops->vidioc_cropcap)
> >> +			return ops->vidioc_cropcap(file, fh, p);
> >> +		return -ENOTTY;  
> > 
> > Actually, before this patch, the logic would be doing, instead:
> > 
> >         /* setting trivial pixelaspect */
> >         p->pixelaspect.numerator = 1;
> >         p->pixelaspect.denominator = 1;
> >  
> >         if (ops->vidioc_cropcap)
> >                 return ops->vidioc_cropcap(file, fh, p);
> >  
> >         return 0;
> > 
> > With is not the same as what's there. So, there are actually two
> > differences:
> > 
> > 1) it will now return -ENOTTY if !ops->vidioc_cropcap instead of 0.
> > 
> > (returning -ENOTTY is probably the best, but this is a fixup change,
> > and a functional change, so, should be in a separate patch, if needed)
> > 
> > 2) pixel numerator/denominator is not initialized in the new code.
> > 
> > Ok, maybe all drivers would be setting numerator and denominator to 1
> > as default, so the code won't need to do it, but:
> > 
> > a) This is not a trivial assumption by looking only on this patch;
> > 
> > b) It sounds risky to not setup denominator, as, if a driver is not
> > initializing it, it could cause a division by zero at userspace.
> > 
> > So, I would prefer to keep initializing numerator/denominator here.
> > 
> > As this is just a cleanup patch, I'm skipping it for now.  
> 
> I'm confused, you say you're skipping it, yet it is merged. But patch 2/2
> (v4l2-ioctl: improve cropcap handling) isn't merged.
> 
> I refrain from commenting on the points you raised until I know what's going
> on here.

Sorry, my mistake. I'll revert it. Please send patch 2/2 after
we fix the issues on this one.

> 
> Regards,
> 
> 	Hans
> 
> > 
> > Btw, IMHO, the best here would be to split the logic that it is called
> > if ops->vidioc_g_selection is not NULL on a separate function. That
> > would make the logic even clearer, and would help to show that it will
> > be handling the logic below "setting trivial pixelaspect" the same way.
> > 
> > Regards,
> > Mauro
> >   
> >> +	}
> >>  
> >> -		/* obtaining bounds */
> >> -		if (V4L2_TYPE_IS_OUTPUT(p->type))
> >> -			s.target = V4L2_SEL_TGT_COMPOSE_BOUNDS;
> >> -		else
> >> -			s.target = V4L2_SEL_TGT_CROP_BOUNDS;
> >> +	/* obtaining bounds */
> >> +	if (V4L2_TYPE_IS_OUTPUT(p->type))
> >> +		s.target = V4L2_SEL_TGT_COMPOSE_BOUNDS;
> >> +	else
> >> +		s.target = V4L2_SEL_TGT_CROP_BOUNDS;
> >>  
> >> -		ret = ops->vidioc_g_selection(file, fh, &s);
> >> -		if (ret)
> >> -			return ret;
> >> -		p->bounds = s.r;
> >> +	ret = ops->vidioc_g_selection(file, fh, &s);
> >> +	if (ret)
> >> +		return ret;
> >> +	p->bounds = s.r;
> >>  
> >> -		/* obtaining defrect */
> >> -		if (V4L2_TYPE_IS_OUTPUT(p->type))
> >> -			s.target = V4L2_SEL_TGT_COMPOSE_DEFAULT;
> >> -		else
> >> -			s.target = V4L2_SEL_TGT_CROP_DEFAULT;
> >> +	/* obtaining defrect */
> >> +	if (V4L2_TYPE_IS_OUTPUT(p->type))
> >> +		s.target = V4L2_SEL_TGT_COMPOSE_DEFAULT;
> >> +	else
> >> +		s.target = V4L2_SEL_TGT_CROP_DEFAULT;
> >>  
> >> -		ret = ops->vidioc_g_selection(file, fh, &s);
> >> -		if (ret)
> >> -			return ret;
> >> -		p->defrect = s.r;
> >> -	}
> >> +	ret = ops->vidioc_g_selection(file, fh, &s);
> >> +	if (ret)
> >> +		return ret;
> >> +	p->defrect = s.r;
> >>  
> >>  	/* setting trivial pixelaspect */
> >>  	p->pixelaspect.numerator = 1;  
> > 
> >   
> 


-- 
Thanks,
Mauro
