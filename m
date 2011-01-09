Return-path: <mchehab@pedra>
Received: from mx.treblig.org ([80.68.94.177]:41407 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848Ab1AIQdV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 9 Jan 2011 11:33:21 -0500
Date: Sun, 9 Jan 2011 16:33:17 +0000
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: hverkuil@xs4all.nl, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org
Subject: Re: user accesses in ivtv-fileops.c:ivtv_v4l2_write ?
Message-ID: <20110109163317.GA19223@gallifrey>
References: <20101128174022.GA4401@gallifrey> <1292118578.21588.13.camel@localhost> <20101212175737.GA30695@gallifrey> <20110109003404.GB21550@gallifrey> <1294532052.2435.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294532052.2435.5.camel@localhost>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

* Andy Walls (awalls@md.metrocast.net) wrote:
> On Sun, 2011-01-09 at 00:34 +0000, Dr. David Alan Gilbert wrote:
> > Hi Andy,
> >   It looks like we missed something in that copy from user
> > patch from the end of last year:
> > 
> > +void ivtv_write_vbi_from_user(struct ivtv *itv,
> > +                             const struct v4l2_sliced_vbi_data __user *sliced,
> > +                             size_t cnt)
> > +{
> > +       struct vbi_cc cc = { .odd = { 0x80, 0x80 }, .even = { 0x80, 0x80 } };
> > +       int found_cc = 0;
> > +       size_t i;
> > +       struct v4l2_sliced_vbi_data d;
> > +
> > +       for (i = 0; i < cnt; i++) {
> > +               if (copy_from_user(&d, sliced + i,
> > +                                  sizeof(struct v4l2_sliced_vbi_data)))
> > +                       break;
> > +               ivtv_write_vbi_line(itv, sliced + i, &cc, &found_cc);
>                                            ^^^^^^^^^^
> What was I thinking?  ---------------------+
> 
> Decent plan; failed execution. :(

Sorry for not spotting it when you sent it out last time!

> > sparse is giving me:
> > drivers/media/video/ivtv/ivtv-vbi.c:177:49: warning: incorrect type in argument 2 (different address spaces)
> > drivers/media/video/ivtv/ivtv-vbi.c:177:49:    expected struct v4l2_sliced_vbi_data const *d
> > drivers/media/video/ivtv/ivtv-vbi.c:177:49:    got struct v4l2_sliced_vbi_data const [noderef] <asn:1>*
> > 
> > and I think the point is that while you've copied the data I think
> > you're still passing the user pointer to ivtv_write_vbi_line and it 
> > should be:
> > 
> >                ivtv_write_vbi_line(itv, &d, &cc, &found_cc);
> > 
> > 
> > What do you think?
> 
> Yes, it looks like I gooned that one up. :)
> 
> That's what I get for trying to fix things with the kids running around
> before bedtime.
> 
> I assume that you have made the replacement and tested that sparse is
> satisfied?

Yes, seems happy - of course I thought I did last time :-)

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
