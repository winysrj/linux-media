Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57598 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442Ab3FRQsL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jun 2013 12:48:11 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Add query/get/set matrix ioctls
Date: Tue, 18 Jun 2013 18:48:25 +0200
Message-ID: <10552983.kFupgzaCcY@avalon>
In-Reply-To: <20130612122627.GM3103@valkosipuli.retiisi.org.uk>
References: <201306031414.49392.hverkuil@xs4all.nl> <201306121035.07587.hverkuil@xs4all.nl> <20130612122627.GM3103@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'll jump in, sorry for the late review.

On Wednesday 12 June 2013 15:26:27 Sakari Ailus wrote:
> On Wed, Jun 12, 2013 at 10:35:07AM +0200, Hans Verkuil wrote:
> > On Tue 11 June 2013 23:33:42 Sylwester Nawrocki wrote:
> > > On 06/03/2013 02:14 PM, Hans Verkuil wrote:
> > > > Hi all,
> > > > 
> > > > When working on the Motion Detection API, I realized that my proposal
> > > > for two new G/S_MD_BLOCKS ioctls was too specific for the motion
> > > > detection use case.
> > > > 
> > > > The Motion Detection RFC can be found here:
> > > > 
> > > > http://www.mail-archive.com/linux-media@vger.kernel.org/msg62085.html
> > > > 
> > > > What I was really attempting to do was to create an API to pass a
> > > > matrix to the hardware.
> > > > 
> > > > This is also related to a long-standing request to add support for
> > > > arrays to the control API. Adding such support to the control API is
> > > > in my opinion a very bad idea since the control API is meant to
> > > > provide all meta data necessary in order to create e.g. control
> > > > panels. Adding array support to the control API would make that very
> > > > difficult, particularly with respect to GUI design.
> > > > 
> > > > So instead this proposal creates a new API to query, get and set
> > > > matrices:
> > >
> > > This looks very interesting, one use case that comes immediately to mind
> > > is configuring the quantization/Huffman tables in a hardware JPEG codec.
> > > The only thing left would have probably been setting up the comment
> > > segments, consisting of arbitrary byte strings.
> > 
> > Actually, I realized that that can be handled as well since those segments
> > are 1-dimensional matrices of unsigned chars.
> > 
> > > This is even more nice than your previous proposal ;) Quite generic -
> > > but I was wondering, what if we went one step further and defined
> > > QUERY/GET/SET_PROPERTY ioctls, where the type (matrix or anything else)
> > > would be also configurable ? :-) Just brainstorming, if memory serves me
> > > well few people suggested something like this in the past.
> 
> Interesting idea. This approach could be used on the Media controller
> interface as well.
> 
> > The problem with that is that you basically create a meta-ioctl. Why not
> > just create an ioctl for whatever you want to do? After all, an ioctl is
> > basically a type (the command number) and a pointer. And with a property
> > ioctl you really just wrap that into another ioctl.
> 
> Is this a problem?
> 
> One of the benefits is that you could send multiple IOCTL commands to the
> device at one go (if the interface is designed as such, and I think it
> should be).

That's where the real value of a property API would be. Setting properties one 
at a time would be pretty much equivalent to what we do today, it would just 
be a different way to express ioctls. Setting several properties in one go, 
however, would allow us not only to modify several controls in one go, but to 
completely reconfigure a pipeline, including formats, selection rectangles and 
links, in an atomic way.

Let's not deny it, achieving this won't be easy, but I think we won't be able 
to delay such an architecture evolution for many years. The KMS is already 
moving to an atomic mode setting API based on properties, and the line between 
capture devices, codecs, processing engines and display devices is getting 
thinner every day. Video pipelines are composed of several devices in most of 
today's SoCs, and we will need a way to handle dynamic runtime configuration.

The matrix ioctls proposal looks pretty good to me by itself, but I do believe 
we will need a property-like API, and that we should stop adding too many new 
ioctls before we really think this through.

> It would be easier to model extensions to the V4L2 API using that kind of
> model; currently we have a bunch of IOCTLs that certainly do show the age of
> the API. With the property API, everything will be... properties you can
> access using set and get operations, and probably enum as well.
> 
> I think this is a logical extension of the V4L2 control API.
> 
> I have to admit designing that kind of an API isn't trivial either: more
> focus will be needed on what the properties are attached to: is that a
> device or a subdev pad, for instance. This way it might be possible to
> address such things at generic level rather than at the level of a single
> IOCTL as we're doing (or rather avoid doing) right now.
> 
> > > So for the starters we could have matrix type and carefully be adding in
> > > the future anything what's needed ?
> > > 
> > > > /* Define to which motion detection region each element belongs.
> > > >   * Each element is a __u8. */
> > > > #define V4L2_MATRIX_TYPE_MD_REGION     (1)
> > > > /* Define the motion detection threshold for each element.
> > > >   * Each element is a __u16. */
> > > > #define V4L2_MATRIX_TYPE_MD_THRESHOLD  (2)
> > > > 
> > > > /**
> > > >   * struct v4l2_query_matrix - VIDIOC_QUERY_MATRIX argument
> > > >   * @type:       matrix type
> > > >   * @index:      matrix index of the given type
> > > >   * @columns:    number of columns in the matrix
> > > >   * @rows:       number of rows in the matrix
> > > >   * @elem_min:   minimum matrix element value
> > > >   * @elem_max:   maximum matrix element value
> > > >   * @elem_size:  size in bytes each matrix element
> > > >   * @reserved:   future extensions, applications and drivers must zero
> > > >   this.
> > > >   */
> > > > struct v4l2_query_matrix {
> > > >          __u32 type;
> > > >          __u32 index;
> > > >          __u32 columns;
> > > >          __u32 rows;
> > > >          __s64 elem_min;
> > > >          __s64 elem_max;
> > > >          __u32 elem_size;
> > > >          __u32 reserved[23];
> > > > } __attribute__ ((packed));
> > > > 
> > > > /**
> > > >   * struct v4l2_matrix - VIDIOC_G/S_MATRIX argument
> > > >   * @type:       matrix type
> > > >   * @index:      matrix index of the given type
> > > >   * @rect:       which part of the matrix to get/set
> > > >   * @matrix:     pointer to the matrix of size (in bytes):
> > > >   *              elem_size * rect.width * rect.height
> > > >   * @reserved:   future extensions, applications and drivers must zero
> > > >   this.
> > > >   */
> > > > struct v4l2_matrix {
> > > >          __u32 type;
> > > >          __u32 index;
> > > >          struct v4l2_rect rect;
> > > >          void __user *matrix;
> > > >          __u32 reserved[12];
> > > > } __attribute__ ((packed));
> > > > 
> > > > 
> > > > /* Experimental, these three ioctls may change over the next couple of
> > > > kernel versions. */
> > > > 
> > > > #define VIDIOC_QUERY_MATRIX     _IORW('V', 103, struct
> > > > v4l2_query_matrix)
> > > > #define VIDIOC_G_MATRIX         _IORW('V', 104, struct v4l2_matrix)
> > > > #define VIDIOC_S_MATRIX         _IORW('V', 105, struct v4l2_matrix)
> > > > 
> > > > 
> > > > Each matrix has a type (which describes the meaning of the matrix) and
> > > > an index (allowing for multiple matrices of the same type).
> > > 
> > > I'm just wondering how this could be used to specify coefficients
> > > associated with selection rectangles for auto focus ?
> > 
> > I've been thinking about this. The problem is that sometimes you want to
> > associate a matrix with some other object (a selection rectangle, a video
> > input, perhaps a video buffer, etc.). A simple index may not be enough. So
> > 
> > how about replacing the index field with a union:
> > 	union {
> > 		__u32 reserved[4];
> > 	} ref;
> 
> ...which is a proof of what I wrote above. :-)

-- 
Regards,

Laurent Pinchart

