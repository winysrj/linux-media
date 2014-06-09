Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40911 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750956AbaFIN6j (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Jun 2014 09:58:39 -0400
Date: Mon, 9 Jun 2014 16:58:02 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC ATTN] Multi-dimensional matrices
Message-ID: <20140609135802.GM2073@valkosipuli.retiisi.org.uk>
References: <5370AB45.9080008@xs4all.nl>
 <20140512095605.3dc2f7d5@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140512095605.3dc2f7d5@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro and Hans,

On Mon, May 12, 2014 at 09:56:05AM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 12 May 2014 13:06:45 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
> > Hi all,
> > 
> > During the mini-summit we discussed multi-dimensional matrix support.
> > My proposal only added support for 2D matrices. It turns out that there
> > is at least one case where a 3D matrix is used (a 17x17x17 matrix which
> > maps an RGB value to another RGB value, with R, G and B being the matrix
> > indices).
> > 
> > I was requested to look into this a bit more and how it should be supported.
> > 
> > One option is to support any number of dimensions by using a pointer to an
> > array of dimension sizes:
> > 
> > 	__u32 dimensions;
> > 	__u32 *dims;
> > 
> > The problem with this IMHO is that this complicates using the VIDIOC_QUERY_EXT_CTRL
> > ioctl: you always need to supply a separate array when you call this ioctl,
> > and remember to set 'dimensions' to the size of your array. And be able to
> > handle the case where there are more dimensions than the size of your array
> > at which time you need to resize it and call the ioctl again.
> 
> I see.
> 
> > 
> > My problem with that is that I think that that is simply not worth the trouble.
> > 
> > I agree that supporting 3D matrices makes sense, and perhaps 4D as well (in
> > case ARGB values are used as indices into the 4D matrix). But I think it is unlikely
> > that 5D or up matrices will be seen in actual hardware (if only because of
> > the size of the data involved), and if those will appear then it is always
> > possible to implement them as a 4D matrix of a struct that contains the
> > remaining dimensions. E.g.:
> > 
> > struct my_drv_type {
> > 	__u32 m[2][3];
> > };
> > 
> > struct my_drv_type ctrl_matrix[4][3][2][2];
> > 
> > This really is a 6D matrix '__u32 m[4][3][2][2][2][3];'.
> > 
> > In other words, I am really opposed to add support for any number of dimensions,
> > I think that is overengineering and I believe that there are alternative solutions
> > should we encounter hardware that does something so strange.
> > 
> > So the rest of my RFC outlines my proposal for extending the number of dimensions
> > to a fixed number. For the sake of argument I'm going with 4 dimensions.
> > 
> > In my current proposal the v4l2_query_ext_ctrl struct has two fields describing
> > the dimensions of the matrix: width and height.
> > 
> > A 1D matrix (aka array) means that one of the two will be set to 1. These fields
> > are always >= 1. The number of elements in the matrix will always be width * height.
> > 
> > If we go to a higher number of dimensions then you do need a new 'elems' or 'elements'
> > field that has the total number of elements in the matrix (for a 2D matrix that would
> > be width * height). It just becomes too cumbersome in applications to always have to
> > multiply all the dimension sizes to get the number of elements.
> > 
> > The approach I want to take is to replace 'width' and 'height' by this:
> > 
> > 	#define V4L2_CTRL_MAX_DIMS 4
> > 
> > 	__u32 elems;
> > 	__u32 dimensions;
> > 	__u32 dims[V4L2_CTRL_MAX_DIMS];
> > 
> > So if 'dimensions' is 2, then dims[0] would be the height and dims[1] the width.
> > For 3D [0] would be depth, [1] height, [2] width.
> > 
> > The remaining dims values would be 0.
> 
> I really don't like this approach. mapping a 1D array as a 4D
> array sounds a really crappy design API. Also, whatever random
> value we use for the number of dimensions, it would be just an
> arbitrary number that we'll need to live with that forever.
> 
> I can see only two sane approaches: either add support for just
> arrays (e. g. 1D), in a way that a 2D matrix would be an array of
> array, a 3D would be an array of array of array, and so on, or
> we should allow supporting an arbitrary number of dimensions.
> 
> There is an alternative: we could use the support for not fixed
> size ioctls, like what's done at input subsystem (see, for example,
> how EVIOCGKEY is handled at drivers/input/evdev.c):
> 
> #define EVIOCGKEY(len)		_IOC(_IOC_READ, 'E', 0x18, len)		/* get global key state */
> 
> And the code that handles it gets the size via:
> 
> 	size = _IOC_SIZE(cmd);
> 
> We could do something similar, like:
> 
> struct v4l2_query_ext_ctrl {
>  __u32 id;
>  __u32 type;
>  char name[32];
>  __s64 minimum;
>  __s64 maximum;
>  __u64 step;
>  __s64 default_value;
>  __u32 flags;
>  __u32 elem_size;
>  __u32 reserved[18];
>  __u32 n_dimensions;
>  __u32 *dimensions;
> }  __attribute__((packed));
> 
> #define VIDIOC_QUERY_EXT_CTRL(len) _IOC(_IOC_READ|_IOC_WRITE, 'V', 103, sizeof(struct v4l2_query_ext_ctrl) + (len - 1) * sizeof(__u32 *))

To just enumerate the controls, the user would have to call different IOCTLs
to even know what kind of controls exist. I would expect that certain
controls could have different dimensions depending on the hardware. Flash
current, for instance: multiple independent LEDs controlled by the same
controller should be an array rather than a single integer. I think it'd be
highly preferrable to have a single IOCTL to enumerate and query all
controls without first having to know what kind of controls you want to know
about.

> That would provide an API that could easily be extended to the max number
> of dimensions that we'll need in the future.
> 
> Let me give an example:
> 
> Assume that now we only add support for 1D. Both Kernel and
> userspace will use only len = 1 on the above IOCTL.
> 
> When we latter add 2D support, applications using len=1 are the ones
> not prepared for the newer 2D controls. Provided that we hide them to
> the application, backward support is warranted.
> 
> If latter this application adds support for the newer 2D controls,
> it would be just a matter of using VIDIOC_QUERY_EXT_CTRL(2) ioctl.
> So, forward compatibility is also provided.

We could do this, yes, but my view is that this might be unnecessarily
complex and visible in places where it wouldn't really need to be.

This is the first time we're implementing support for non-scalar controls
after probably more than ten years of being entirely happy having no
dimensions at all. The fact that we've coped so far without (well, some
number of private IOCTLs could have been avoided this way) tells that
dimensions aren't very common.

I expect the number of non-scalar controls to stay relatively small compared
to the scalar controls. Thus I don't see much value in implementing this at
the level of IOCTL argument struct size --- even regular, existing controls
will benefit from the extended query control IOCTL in form of minimum and
maximum values for 64-bit integer controls and hopefully a litte later,
control unit as well.

There's definitely use for 1-dimensional arrays (I'd need them, for one),
two-dimensional ones, too, and three-dimensional use case has been imagined.
Four dimensions seems unlikely to have practical applications.

Even if we noticed that, oops, four was too few, we could add a new IOCTL
using the same name and renaming the old. Thus old code would still be using
four as maximum while newer binaries would be using more. The size would be
part of the IOCTL argument struct size as it is on your proposal, but we'd
only need to use that option if it turned out that four (or whichever number
se used first) was too small.

I'm also not worried about the performance implications since queryctrl
performance is not critical at all (when compared to e.g. s_ext_ctrls) and
copying a few extra bytes won't significantly affect it.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
