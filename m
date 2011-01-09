Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:46456 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913Ab1AIBMR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Jan 2011 20:12:17 -0500
Subject: Re: user accesses in ivtv-fileops.c:ivtv_v4l2_write ?
From: Andy Walls <awalls@md.metrocast.net>
To: "Dr. David Alan Gilbert" <linux@treblig.org>
Cc: hverkuil@xs4all.nl, ivtv-devel@ivtvdriver.org,
	linux-media@vger.kernel.org
In-Reply-To: <20110109003404.GB21550@gallifrey>
References: <20101128174022.GA4401@gallifrey>
	 <1292118578.21588.13.camel@localhost> <20101212175737.GA30695@gallifrey>
	 <20110109003404.GB21550@gallifrey>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 Jan 2011 19:14:12 -0500
Message-ID: <1294532052.2435.5.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2011-01-09 at 00:34 +0000, Dr. David Alan Gilbert wrote:
> Hi Andy,
>   It looks like we missed something in that copy from user
> patch from the end of last year:
> 
> +void ivtv_write_vbi_from_user(struct ivtv *itv,
> +                             const struct v4l2_sliced_vbi_data __user *sliced,
> +                             size_t cnt)
> +{
> +       struct vbi_cc cc = { .odd = { 0x80, 0x80 }, .even = { 0x80, 0x80 } };
> +       int found_cc = 0;
> +       size_t i;
> +       struct v4l2_sliced_vbi_data d;
> +
> +       for (i = 0; i < cnt; i++) {
> +               if (copy_from_user(&d, sliced + i,
> +                                  sizeof(struct v4l2_sliced_vbi_data)))
> +                       break;
> +               ivtv_write_vbi_line(itv, sliced + i, &cc, &found_cc);
                                           ^^^^^^^^^^
What was I thinking?  ---------------------+

Decent plan; failed execution. :(


> 
> sparse is giving me:
> drivers/media/video/ivtv/ivtv-vbi.c:177:49: warning: incorrect type in argument 2 (different address spaces)
> drivers/media/video/ivtv/ivtv-vbi.c:177:49:    expected struct v4l2_sliced_vbi_data const *d
> drivers/media/video/ivtv/ivtv-vbi.c:177:49:    got struct v4l2_sliced_vbi_data const [noderef] <asn:1>*
> 
> and I think the point is that while you've copied the data I think
> you're still passing the user pointer to ivtv_write_vbi_line and it 
> should be:
> 
>                ivtv_write_vbi_line(itv, &d, &cc, &found_cc);
> 
> 
> What do you think?

Yes, it looks like I gooned that one up. :)

That's what I get for trying to fix things with the kids running around
before bedtime.

I assume that you have made the replacement and tested that sparse is
satisfied?

Regards,
Andy

