Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:48308 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab1KZQz2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 11:55:28 -0500
Date: Sat, 26 Nov 2011 18:55:24 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v4][media] Exynos4 JPEG codec v4l2 driver
Message-ID: <20111126165524.GC29805@valkosipuli.localdomain>
References: <1322213893-5462-1-git-send-email-andrzej.p@samsung.com>
 <20111126095625.GA29805@valkosipuli.localdomain>
 <4ED0D9AD.90603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED0D9AD.90603@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sat, Nov 26, 2011 at 01:21:01PM +0100, Sylwester Nawrocki wrote:
...
> Did you have a chance to look at this RFC [1] ? I have reviewed usage 
> of VIDIOC_[S/G]_JPEGCOMP ioctls and there are also some links to previous 
> discussion there. 

I have to admit I had completely missed this RFC. I'll take a look at it.

> 
> > 
> > 2) Define a new control for jpeg quality. Its value range can be what the
> > hardware supports and the user space gets much better information on the
> > capabilities of the hardware and the granularity of the quality setting.
> 
> This was my conclusion as well. That sounds like a most effective and flexible 
> solution. IIRC, Hans also suggested those things might be a perfect candidate
> for a control class.

Sounds like a good idea. Would the class be intended for all compressed
formats or just jpeg? I have to say I don't know much about the
alternatives, except that their compression ratio tends to be much better on
equivalent quality.

> 
> > 
> > I might even favour the second one. I also wonder how many user space
> > applications use this IOCTL, so if we're breaking anything by not supporting
> > it.
> 
> I imagine we could deprecate 'quality' and 'jpeg_markers' fields of v4l2_jpegcompression
> and during deprecation period add support for the controls for these parameters,
> so the application can adapt and fall back to a control based interface once the
> ioctl is removed in the kernel.
> This should be possible for almost all drivers as they virtually use G/S_JPEGCOMP 
> ioctls for image quality only.  
> 
> > 
> > Or we could decide to do option 1 right now and implement 2) later on. I can
> > write a patch to change the documentation.
> 
> The documentation could always be improved. But I personally would like to see these
> ioctls die, as they're really hopeless as a part of public API. I though about
> something like
> 
> /* The ioctls to configure/query selected data segment in a jpeg encoder */  
> #define VIDIOC_G_JPEGCOMP        _IOR('V', 61, struct v4l2_jpegcomp)
> #define VIDIOC_S_JPEGCOMP        _IOW('V', 62, struct v4l2_jpegcomp)
> 
> /**
>  * struct v4l2_jpegcomp - JPEG segment data structure
>  *
>  * @id: field indicating what standard JPEG data segment @data contains
>  * @data: points the segment data
>  * @length: length of the segment
>  */
> struct v4l2_jpegcomp {
> 	__u32 id;		 
> 
>         int  length;
>         void  *data;
> };
> 
> 
> As a side note, our plan was to get merged the S5P JPEG codec in v3.3, with 
> the old jpeg ioctls and then switch to the controls when they're ready, possibly
> in subsequent kernel release. That's why the driver is marked as experimental.

Sounds good to me.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
