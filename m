Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36775 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263AbaC1R7k (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 13:59:40 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode
Date: Fri, 28 Mar 2014 19:01:38 +0100
Message-ID: <7890812.mee88PGtyI@avalon>
In-Reply-To: <Pine.LNX.4.64.1403281838400.24601@axis700.grange>
References: <Pine.LNX.4.64.1403272206410.18471@axis700.grange> <22889282.D1rkAPVGhe@avalon> <Pine.LNX.4.64.1403281838400.24601@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Friday 28 March 2014 18:44:04 Guennadi Liakhovetski wrote:
> On Fri, 28 Mar 2014, Laurent Pinchart wrote:
> > On Thursday 27 March 2014 22:34:07 Guennadi Liakhovetski wrote:
> > > It turns out, that 64-bit compilations sometimes align structs within
> > > other structs on 32-bit boundaries, but in other cases alignment is done
> > > on 64-bit boundaries, adding padding if necessary.
> > 
> > You make it sound like the behaviour is random, I'm pretty sure it isn't
> > :-)
>
> I didn't mean it was random, I just meant it is not be as simple as "align
> always." E.g. if there are only 32-bit fields in the embedded struct, it
> won't be aligned, below I explain a bit with pointers. I just don't know
> the exact logic, that's used there.

The logic is basically that fields are aligned within structures to a multiple 
of their native access size, and structures are aligned to a multiple of the 
access size of the largest field. If a structure on a 64-bit systems contains 
a pointer the pointer field will be aligned to a multiple of 8 bytes within 
the structure, and instances of the structure will be aligned to multiples of 
8 bytes as well. If that structure is embedded inside another structure, it 
will be placed on an 8 bytes boundary, possibly creating a gap if the fields 
before the structure don't add up to a multiple of 8 bytes. This is what 
happens here.

> > > This is done, for example when the embedded struct contains a pointer.
> > > This is the case with struct v4l2_window, which is embedded into struct
> > > v4l2_format, and that one is embedded into struct v4l2_create_buffers.
> > > Unlike some other structs, used as a part of the kernel ABI as ioctl()
> > > arguments, that are packed, these structs aren't packed. This isn't a
> > > problem per se, but it turns out, that the ioctl-compat code for
> > > VIDIOC_CREATE_BUFS contains a bug, that triggers in such 64-bit builds.
> > > That code wrongly assumes, that in struct v4l2_create_buffers, struct
> > > v4l2_format immediately follows the __u32 memory field, which in fact
> > > isn't the case. This bug wasn't visible until now, because until
> > > recently hardly any applications used this ioctl() and mostly embedded
> > > 32-bit only drivers implemented it. This is changing now with addition
> > > of this ioctl() to some USB drivers, e.g. UVC. This patch fixes the bug
> > > by copying parts of struct v4l2_create_buffers separately.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > > 
> > > It's probably too late for 3.14, but maybe after pushing it into 3.15 we
> > > have to send it to stable.
> > > 
> > > diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > > b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c index 04b2daf..28f87d7
> > > 100644
> > > --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > > +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > > @@ -213,8 +213,9 @@ static int get_v4l2_format32(struct v4l2_format *kp,
> > > struct v4l2_format32 __user static int get_v4l2_create32(struct
> > > v4l2_create_buffers *kp, struct v4l2_create_buffers32 __user *up) {
> > > 
> > >  	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_create_buffers32))
> > >  	||
> > > 
> > > -	    copy_from_user(kp, up, offsetof(struct v4l2_create_buffers32,
> > > format.fmt)))
> > > -			return -EFAULT;
> > > +	    copy_from_user(kp, up, offsetof(struct v4l2_create_buffers32,
> > > format)) ||
> > > +	    get_user(kp->format.type, &up->format.type))
> > > +		return -EFAULT;
> > > 
> > >  	return __get_v4l2_format32(&kp->format, &up->format);
> > >  
> > >  }
> > 
> > I'm fine with the patch as it is, but wouldn't it be simpler to move the
> > get_user() inside the __get_v4l2_format32() function ? You could also then
> > remove that call from get_v4l2_format32() as well.
> 
> This would duplicate the call to access_ok(), but it could be done, sure.

You don't need to call access_ok() inside __get_v4l2_format32(), both 
get_v4l2_format32() and get_v4l2_create32() perform an access_ok() check that 
can be left in place.

-- 
Regards,

Laurent Pinchart

