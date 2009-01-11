Return-path: <linux-media-owner@vger.kernel.org>
Received: from cinke.fazekas.hu ([195.199.244.225]:59986 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbZAKPWX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Jan 2009 10:22:23 -0500
Date: Sun, 11 Jan 2009 16:22:15 +0100 (CET)
From: Marton Balint <cus@fazekas.hu>
To: Trent Piepho <xyzzy@speakeasy.org>
cc: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH] cx88: fix unexpected video resize when setting tv norm
In-Reply-To: <Pine.LNX.4.58.0901101325420.1626@shell2.speakeasy.net>
Message-ID: <Pine.LNX.4.64.0901111543070.13850@cinke.fazekas.hu>
References: <571b3176dc82a7206ade.1231614963@roadrunner.athome>
 <Pine.LNX.4.58.0901101325420.1626@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 10 Jan 2009, Trent Piepho wrote:
> On Sat, 10 Jan 2009, Marton Balint wrote:
> > Cx88_set_tvnorm sets the size of the video to fixed 320x240. This is ugly at
> > least, but also can cause problems, if it happens during an active video
> > transfer. With this patch, cx88_set_scale will save the last requested video
> > size, and cx88_set_tvnorm will scale the video to this size.
> >
> > diff -r 985ecd81d993 -r 571b3176dc82 linux/drivers/media/video/cx88/cx88.h
> > @@ -352,6 +352,9 @@
> >  	u32                        input;
> >  	u32                        astat;
> >  	u32			   use_nicam;
> > +	unsigned int		   last_width;
> > +	unsigned int		   last_height;
> > +	enum v4l2_field		   last_field;
> 
> Instead of adding these extra fields to the core, maybe it would be better
> to just add w/h/field as arguments to set_tvnorm?  I have a patch to do
> this, but there are still problems.

I think you're right, it's probably better that way.

> Changing norms during capture has more problems.  I'm not sure if v4l2 even
> allows it.  Even if allowed, I don't think the cx88 driver should try to
> support it.

What the other drivers do?

> So I think the best thing would be to have S_STD return -EBUSY if there is
> an ongoing capture.  Maybe even have v4l2-dev take care of that if
> possible.

It sounds reasonable. As a special case, changing the norm to the 
current norm should be allowed, or not? Mplayer will print out error 
messages, if it's not allowed.

Regards,
  Marton.
