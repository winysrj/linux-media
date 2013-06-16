Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47336 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755792Ab3FPWKF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 16 Jun 2013 18:10:05 -0400
Date: Mon, 17 Jun 2013 01:09:59 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	laurent.pinchart@ideasonboard.com
Subject: Re: [RFC] Add query/get/set matrix ioctls
Message-ID: <20130616220958.GA2064@valkosipuli.retiisi.org.uk>
References: <201306031414.49392.hverkuil@xs4all.nl>
 <201306121035.07587.hverkuil@xs4all.nl>
 <20130612122627.GM3103@valkosipuli.retiisi.org.uk>
 <201306121457.21950.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306121457.21950.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Jun 12, 2013 at 02:57:21PM +0200, Hans Verkuil wrote:
> On Wed 12 June 2013 14:26:27 Sakari Ailus wrote:
> > Hi Hans,
> > 
> > Thanks for the RFC!
> > 
> > On Wed, Jun 12, 2013 at 10:35:07AM +0200, Hans Verkuil wrote:
> > > On Tue 11 June 2013 23:33:42 Sylwester Nawrocki wrote:
> > > > Hi Hans,
> > > > 
> > > > On 06/03/2013 02:14 PM, Hans Verkuil wrote:
> > > > > Hi all,
> > > > >
> > > > > When working on the Motion Detection API, I realized that my proposal for
> > > > > two new G/S_MD_BLOCKS ioctls was too specific for the motion detection use
> > > > > case.
> > > > >
> > > > > The Motion Detection RFC can be found here:
> > > > >
> > > > > http://www.mail-archive.com/linux-media@vger.kernel.org/msg62085.html
> > > > >
> > > > > What I was really attempting to do was to create an API to pass a matrix
> > > > > to the hardware.
> > > > >
> > > > > This is also related to a long-standing request to add support for
> > > > > arrays to the control API. Adding such support to the control API is in my
> > > > > opinion a very bad idea since the control API is meant to provide all
> > > > > meta data necessary in order to create e.g. control panels. Adding array
> > > > > support to the control API would make that very difficult, particularly
> > > > > with respect to GUI design.
> > > > >
> > > > > So instead this proposal creates a new API to query, get and set matrices:
> > > > 
> > > > This looks very interesting, one use case that comes immediately to mind is
> > > > configuring the quantization/Huffman tables in a hardware JPEG codec. 
> > > > The only
> > > > thing left would have probably been setting up the comment segments, 
> > > > consisting
> > > > of arbitrary byte strings.
> > > 
> > > Actually, I realized that that can be handled as well since those segments
> > > are 1-dimensional matrices of unsigned chars.
> > > 
> > > > 
> > > > This is even more nice than your previous proposal ;) Quite generic - but
> > > > I was wondering, what if we went one step further and defined QUERY/GET/
> > > > SET_PROPERTY ioctls, where the type (matrix or anything else) would be
> > > > also configurable ? :-) Just brainstorming, if memory serves me well few
> > > > people suggested something like this in the past.
> > 
> > Interesting idea. This approach could be used on the Media controller
> > interface as well.
> 
> What is needed for the MC (if memory serves) is something simple to list what
> effectively are capabilities of entities. Basically just a list of integers.
> That's quite different from this highly generic proposal.

I think I should have said "property API" instead. That's what I meant. This
could be prototyped and discussed. Which device nodes that API could
eventually use is another matter.

>From API design point of view it's somewhat odd that a device (especially
when it comes to embedded systems) is visible in the system as a large
number of device nodes. I know there are a huge number of reasons why it's
so currently but if I were to create a new API, that's one thing I would
correct.

But in the context of matrix IOCTLs, this begins to be off-topic.

> > > The problem with that is that you basically create a meta-ioctl. Why not
> > > just create an ioctl for whatever you want to do? After all, an ioctl is
> > > basically a type (the command number) and a pointer. And with a property
> > > ioctl you really just wrap that into another ioctl.
> > 
> > Is this a problem?
> 
> I think so, yes. It seems to me that this just adds an unnecessary indirection
> that everyone (userspace and kernelspace) has to cope with.
> 
> I don't see any advantage of going in this direction.

To some extent one could claim the controls API does exactly that: it
provides a generic way to access properties of certain kind. I like controls
and extended controls even more: the standard API makes many other things
easier in user space, including enumeration.

> > One of the benefits is that you could send multiple IOCTL commands to the
> > device at one go (if the interface is designed as such, and I think it
> > should be).
> 
> There are other ways this can be done (we discussed that in the past) without
> introducing complex new ioctls. And the reality is that this doesn't really

Could you refresh my memory a bit? I remember synchronisation of applying
configurations being discussed, and, well, most of the time that certainly
isn't an issue, but if you wish to ensure two configuration parameters on
different subdevs take effect at the same time, there's no fully generic way
to do that in the API: you have to rely on timing to some extent.

> help you much: the real complexity will be in handling such ioctl sets in a
> driver.

Very, very true. I still maintain there are cases where this a) could be
done and b) would be nice and useful. The configuration of different
omap3isp blocks, for instance, now passed to the driver using private ioctls.

> > It would be easier to model extensions to the V4L2 API using that kind of
> > model; currently we have a bunch of IOCTLs that certainly do show the age of
> > the API. With the property API, everything will be... properties you can
> > access using set and get operations, and probably enum as well.
> 
> It's easy to model extension today as well: just add a new ioctl. How is that
> any different than adding a new property type, except instead of just filling
> in one struct to pass with the ioctl, I now have to fill in two: one for the
> property encapsulation struct, one for the actual payload struct. Yes, it
> looks like you have just a few property ioctls, but the reality is that the
> complexity has just been moved to the property side of things.

I'm not claiming it'd magically fixed everything, but it'd be worth
prototyping. I wish I had time for that (and well, to do a bunch of other
pending things as well). :-P

> > 
> > I think this is a logical extension of the V4L2 control API.
> > 
> > I have to admit designing that kind of an API isn't trivial either: more
> > focus will be needed on what the properties are attached to: is that a
> > device or a subdev pad, for instance. This way it might be possible to
> > address such things at generic level rather than at the level of a single
> > IOCTL as we're doing (or rather avoid doing) right now.
> 
> That's a problem that is unrelated to 'property' usage. Actually, that's
> easier for 'non-property' ioctls since there you know how it is going to be
> used, so there is no need to be generic.
> 
> BTW, I've been making the assumption that a property can hold any type of
> data, not just 'simple' types. So it can hold a v4l2_format struct for example
> (or something of similar complexity).

I don't think properties should --- instead they should contain information
related to the fields of the struct. The structs combine together
information which is valid for a certain use case, and are unchangeable from
then on. There are many upsides from this but also downsides. The full
picture is not visible without at least prototyping a property-based API.

> > 
> > > > So for the starters we could have matrix type and carefully be adding in
> > > > the future anything what's needed ?
> > > > 
> > > > > /* Define to which motion detection region each element belongs.
> > > > >   * Each element is a __u8. */
> > > > > #define V4L2_MATRIX_TYPE_MD_REGION     (1)
> > > > > /* Define the motion detection threshold for each element.
> > > > >   * Each element is a __u16. */
> > > > > #define V4L2_MATRIX_TYPE_MD_THRESHOLD  (2)
> > > > >
> > > > > /**
> > > > >   * struct v4l2_query_matrix - VIDIOC_QUERY_MATRIX argument
> > > > >   * @type:       matrix type
> > > > >   * @index:      matrix index of the given type
> > > > >   * @columns:    number of columns in the matrix
> > > > >   * @rows:       number of rows in the matrix
> > > > >   * @elem_min:   minimum matrix element value
> > > > >   * @elem_max:   maximum matrix element value
> > > > >   * @elem_size:  size in bytes each matrix element
> > > > >   * @reserved:   future extensions, applications and drivers must zero this.
> > > > >   */
> > > > > struct v4l2_query_matrix {
> > > > >          __u32 type;
> > > > >          __u32 index;
> > > > >          __u32 columns;
> > > > >          __u32 rows;
> > > > >          __s64 elem_min;
> > > > >          __s64 elem_max;
> > > > >          __u32 elem_size;
> > > > >          __u32 reserved[23];
> > > > > } __attribute__ ((packed));
> > > > >
> > > > > /**
> > > > >   * struct v4l2_matrix - VIDIOC_G/S_MATRIX argument
> > > > >   * @type:       matrix type
> > > > >   * @index:      matrix index of the given type
> > > > >   * @rect:       which part of the matrix to get/set
> > > > >   * @matrix:     pointer to the matrix of size (in bytes):
> > > > >   *              elem_size * rect.width * rect.height
> > > > >   * @reserved:   future extensions, applications and drivers must zero this.
> > > > >   */
> > > > > struct v4l2_matrix {
> > > > >          __u32 type;
> > > > >          __u32 index;
> > > > >          struct v4l2_rect rect;
> > > > >          void __user *matrix;
> > > > >          __u32 reserved[12];
> > > > > } __attribute__ ((packed));
> > > > >
> > > > >
> > > > > /* Experimental, these three ioctls may change over the next couple of kernel
> > > > >     versions. */
> > > > > #define VIDIOC_QUERY_MATRIX     _IORW('V', 103, struct v4l2_query_matrix)
> > > > > #define VIDIOC_G_MATRIX         _IORW('V', 104, struct v4l2_matrix)
> > > > > #define VIDIOC_S_MATRIX         _IORW('V', 105, struct v4l2_matrix)
> > > > >
> > > > >
> > > > > Each matrix has a type (which describes the meaning of the matrix) and an
> > > > > index (allowing for multiple matrices of the same type).
> > > > 
> > > > I'm just wondering how this could be used to specify coefficients 
> > > > associated with
> > > > selection rectangles for auto focus ?
> > > 
> > > I've been thinking about this. The problem is that sometimes you want to
> > > associate a matrix with some other object (a selection rectangle, a video
> > > input, perhaps a video buffer, etc.). A simple index may not be enough. So
> > > how about replacing the index field with a union:
> > > 
> > > 	union {
> > > 		__u32 reserved[4];
> > > 	} ref;
> > 
> > ...which is a proof of what I wrote above. :-)
> 
> Is it?

Indeed to be more precise, to some of that: here, we do have the same
problem locally that the property API would need to resolve globally. But
the problem itself is the same.

That said, a property API would and could not fix any issues today, and not
even next year. To be more practical, the question in the meantime is:
should V4L2 be extended to provide functionality that would match better
with the idea of the property-based API or not? The difficulty in that
approach would more likely be in defining an object model that would make
sense in the general case.

I'm not against adding a partial implementation of a property-based API to
V4L2 (i.e. what you're proposing in thie RFC) but I think we need to go
through the content thoroughly (I'll reply again to the original RFC).

I'd like to get Laurent's opinion, too.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
