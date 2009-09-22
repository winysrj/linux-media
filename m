Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:52300 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752134AbZIVCPa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Sep 2009 22:15:30 -0400
Subject: Re: Bug in S2 API...
From: hermann pitton <hermann-pitton@arcor.de>
To: Markus Rechberger <mrechberger@gmail.com>
Cc: linux-media@vger.kernel.org
In-Reply-To: <d9def9db0909210302m44f8ed77wfca6be3693491233@mail.gmail.com>
References: <d9def9db0909202040u3138670ahede6078ef1a177c@mail.gmail.com>
	 <1253504805.3255.3.camel@pc07.localdom.local>
	 <d9def9db0909202109m54453573kc90f0c3e5d942e2@mail.gmail.com>
	 <1253506233.3255.6.camel@pc07.localdom.local>
	 <d9def9db0909202142j542136e3raea8e171a19f7e73@mail.gmail.com>
	 <1253508863.3255.10.camel@pc07.localdom.local>
	 <d9def9db0909210302m44f8ed77wfca6be3693491233@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 04:00:52 +0200
Message-Id: <1253584852.3279.11.camel@pc07.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

Am Montag, den 21.09.2009, 12:02 +0200 schrieb Markus Rechberger:
> ----
> in dvb-frontend.c:
>  ----
>          if(cmd == FE_GET_PROPERTY) {
> 
>                  tvps = (struct dtv_properties __user *)parg;
>                  dprintk("%s() properties.num = %d\n", __func__, tvps->num);
>                  dprintk("%s() properties.props = %p\n", __func__, tvps->props);
>                  ...
>                  if (copy_from_user(tvp, tvps->props, tvps->num *
>  sizeof(struct dtv_property)))
>  ----
> 
> 
> > OK,
> >
> > thought I'll have never to care for it again.
> >
> > ENUM calls should never be W.
> >
> > Hit me for all I missed.
> >
> > Cheers,
> > Hermann
> 
> you are not seeing the point of it it seems

you are right, I do not see your point at all, but I was wrong for the
get calls.

We had such discussions on v4l ioctls previously.

The result was to keep them as is and not to change IOR to IOWR to keep
compatibility.

This is six years back.

If you point me to a bug ever caused by it, I'll happily try to look it
up again.

Cheers,
Hermann

> Documentation/ioctl-number.txt
> 
> ----
> If you are adding new ioctl's to the kernel, you should use the _IO
> macros defined in <linux/ioctl.h>:
> 
>     _IO    an ioctl with no parameters
>     _IOW   an ioctl with write parameters (copy_from_user)
>     _IOR   an ioctl with read parameters  (copy_to_user)
>     _IOWR  an ioctl with both write and read parameters.
> ----
> copy from user is required in order to copy the keys for the requested
> elements into the kernel.
> copy to user is finally used to play them back.
> 
> Markus

