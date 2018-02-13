Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42902 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S965942AbeBMWwa (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Feb 2018 17:52:30 -0500
Date: Wed, 14 Feb 2018 00:52:27 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund+renesas@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] videodev2.h: add helper to validate colorspace
Message-ID: <20180213225227.kf42gxdizb7srykw@valkosipuli.retiisi.org.uk>
References: <20180213220847.10856-1-niklas.soderlund+renesas@ragnatech.se>
 <2862017.uVaJOSAbcn@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2862017.uVaJOSAbcn@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Niklas,

On Wed, Feb 14, 2018 at 12:23:05AM +0200, Laurent Pinchart wrote:
> Hi Niklas,
> 
> Thank you for the patch.
> 
> On Wednesday, 14 February 2018 00:08:47 EET Niklas Söderlund wrote:
> > There is no way for drivers to validate a colorspace value, which could
> > be provided by user-space by VIDIOC_S_FMT for example. Add a helper to
> > validate that the colorspace value is part of enum v4l2_colorspace.
> > 
> > Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> > ---
> >  include/uapi/linux/videodev2.h | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > Hi,
> > 
> > I hope this is the correct header to add this helper to. I think it's
> > since if it's in uapi not only can v4l2 drivers use it but tools like
> > v4l-compliance gets access to it and can be updated to use this instead
> > of the hard-coded check of just < 0xff as it was last time I checked.
> > 
> > // Niklas
> > 
> > diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> > index 9827189651801e12..843afd7c5b000553 100644
> > --- a/include/uapi/linux/videodev2.h
> > +++ b/include/uapi/linux/videodev2.h
> > @@ -238,6 +238,11 @@ enum v4l2_colorspace {
> >  	V4L2_COLORSPACE_DCI_P3        = 12,
> >  };
> > 
> > +/* Determine if a colorspace is defined in enum v4l2_colorspace */
> > +#define V4L2_COLORSPACE_IS_VALID(colorspace)		\
> > +	(((colorspace) >= V4L2_COLORSPACE_DEFAULT) &&	\
> > +	 ((colorspace) <= V4L2_COLORSPACE_DCI_P3))
> > +
> 
> This looks pretty good to me. I'd remove the parentheses around each test 
> though.

Agreed.

> 
> One potential issue is that if this macro operates on an unsigned value (for 
> instance an u32, which is the type used for the colorspace field in various 
> structures) the compiler will generate a warning:
> 
> enum.c: In function ‘test_4’:                                                                                                                                                                             
> enum.c:30:16: warning: comparison of unsigned expression >= 0 is always true 
> [-Wtype-limits]                                                                                                              
>   return V4L2_COLORSPACE_IS_VALID(colorspace);
> 
> Dropping the first check would fix that, but wouldn't catch invalid values 
> when operating on a signed type, such as int or enum v4l2_colorspace.

How about simply casting it to u32 first (and removing the first test)?

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
