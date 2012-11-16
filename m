Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mnsspb.ru ([84.204.75.2]:56385 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab2KPPBS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 10:01:18 -0500
Date: Fri, 16 Nov 2012 19:02:05 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v5] [media] vivi: Teach it to tune FPS
Message-ID: <20121116150205.GB14917@tugrik.mns.mnsspb.ru>
References: <1350914084-31618-1-git-send-email-kirr@mns.spb.ru>
 <201211161438.09046.hverkuil@xs4all.nl>
 <20121116144841.GA14917@tugrik.mns.mnsspb.ru>
 <201211161551.23525.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201211161551.23525.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 16, 2012 at 03:51:23PM +0100, Hans Verkuil wrote:
> On Fri November 16 2012 15:48:41 Kirill Smelkov wrote:
> > On Fri, Nov 16, 2012 at 02:38:09PM +0100, Hans Verkuil wrote:
> > > On Wed November 7 2012 12:30:01 Kirill Smelkov wrote:
> > [...]
> > 
> > > > diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
> > > > index 37d0af8..5d1b374 100644
> > > > --- a/drivers/media/platform/vivi.c
> > > > +++ b/drivers/media/platform/vivi.c
> > > > @@ -65,8 +65,11 @@ MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
> > > >  /* Global font descriptor */
> > > >  static const u8 *font8x16;
> > > >  
> > > > -/* default to NTSC timeperframe */
> > > > -static const struct v4l2_fract TPF_DEFAULT = {.numerator = 1001, .denominator = 30000};
> > > > +/* timeperframe: min/max and default */
> > > > +static const struct v4l2_fract
> > > > +	tpf_min     = {.numerator = 1,		.denominator = UINT_MAX},  /* 1/infty */
> > > > +	tpf_max     = {.numerator = UINT_MAX,	.denominator = 1},         /* infty */
> > > 
> > > I understand your reasoning here, but I wouldn't go with UINT_MAX here. Something like
> > > 1/1000 tpf (or 1 ms) up to 86400/1 tpf (or once a day). With UINT_MAX I am afraid we
> > > might hit application errors when they manipulate these values. The shortest time
> > > between frames is 1 ms anyway.
> > > 
> > > It's the only comment I have, it looks good otherwise.
> > 
> > Thanks, Let's then merge it with 1/1000 - 1000/1 limit. Ok?
> 
> OK.

Thanks.
