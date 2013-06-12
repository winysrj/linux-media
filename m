Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3242 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab3FLOrv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jun 2013 10:47:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andrzej Hajda <a.hajda@samsung.com>
Subject: Re: [RFC] Add query/get/set matrix ioctls
Date: Wed, 12 Jun 2013 16:47:31 +0200
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	"linux-media" <linux-media@vger.kernel.org>
References: <201306031414.49392.hverkuil@xs4all.nl> <201306121035.07587.hverkuil@xs4all.nl> <51B880B4.8090806@samsung.com>
In-Reply-To: <51B880B4.8090806@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306121647.31253.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed June 12 2013 16:07:48 Andrzej Hajda wrote:
> Hi Hans and Sylwester,
> 
> I would like to add my two cents.
> 
> On 06/12/2013 10:35 AM, Hans Verkuil wrote:
> > On Tue 11 June 2013 23:33:42 Sylwester Nawrocki wrote:
> >> Hi Hans,
> >>
> >> On 06/03/2013 02:14 PM, Hans Verkuil wrote:
> >>> Hi all,
> >>>
> >>> When working on the Motion Detection API, I realized that my proposal for
> >>> two new G/S_MD_BLOCKS ioctls was too specific for the motion detection use
> >>> case.
> >>>
> >>> The Motion Detection RFC can be found here:
> >>>
> >>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg62085.html
> >>>
> >>> What I was really attempting to do was to create an API to pass a matrix
> >>> to the hardware.
> >>>
> >>> This is also related to a long-standing request to add support for
> >>> arrays to the control API. Adding such support to the control API is in my
> >>> opinion a very bad idea since the control API is meant to provide all
> >>> meta data necessary in order to create e.g. control panels. Adding array
> >>> support to the control API would make that very difficult, particularly
> >>> with respect to GUI design.
> >>>
> >>> So instead this proposal creates a new API to query, get and set matrices:
> >>
> >> This looks very interesting, one use case that comes immediately to mind is
> >> configuring the quantization/Huffman tables in a hardware JPEG codec. 
> >> The only
> >> thing left would have probably been setting up the comment segments, 
> >> consisting
> >> of arbitrary byte strings.
> > 
> > Actually, I realized that that can be handled as well since those segments
> > are 1-dimensional matrices of unsigned chars.
> 
> Treating array of chars as matrix seems for me to be an abuse. Why not
> treat any blob of data as a matrix of chars with one row?
> Additionally passing string from/to driver via VIDIOC_G/S_MATRIX seems
> awkward.

It's not a string. If it was a string, then we could use a control. It is
literally a blob of data that can be inserted into a comment segment.

The alternative is to create a new ioctl to do just this, but that's a lot
of work and it can be just as well by this ioctl. Since we assign this a
specific type ('JPEG_COMMENT' or something) we can prevent it from being
abused.

> 
> > 
> >>
> >> This is even more nice than your previous proposal ;) Quite generic - but
> >> I was wondering, what if we went one step further and defined QUERY/GET/
> >> SET_PROPERTY ioctls, where the type (matrix or anything else) would be
> >> also configurable ? :-) Just brainstorming, if memory serves me well few
> >> people suggested something like this in the past.
> > 
> > The problem with that is that you basically create a meta-ioctl. Why not
> > just create an ioctl for whatever you want to do? After all, an ioctl is
> > basically a type (the command number) and a pointer. And with a property
> > ioctl you really just wrap that into another ioctl.
> 
> Those ioctls would share similar scheme (QUERY/SET/GET) and similar
> purpose - passing some properties between user space and kernel, I think
> this could be a good reason to use three ioctls instead of 3xN.

On the outside it looks like you have just three ioctls, but in the kernel
you promptly have a switch on the type that effectively acts as an ioctl
command. So you gain nothing, it's just an obfuscation layer.

Say you have two ioctls:

S_FOO(struct v4l2_foo *p)
S_BAR(struct v4l2_bar *p)

With properties you would implement it like this:

struct v4l2_prop {
	__u32 type;
	union {
		struct v4l2_foo foo;
		struct v4l2_bar bar;
	};
};

S_PROP(struct v4l2_prop)

What does that gain you? It looks shorter, but in the kernel you have to
do a switch (type) everywhere you deal with properties. That's no different
than using switch (cmd) when dealing with an ioctl.


> 
> > 
> >> So for the starters we could have matrix type and carefully be adding in
> >> the future anything what's needed ?
> >>
> >>> /* Define to which motion detection region each element belongs.
> >>>   * Each element is a __u8. */
> >>> #define V4L2_MATRIX_TYPE_MD_REGION     (1)
> >>> /* Define the motion detection threshold for each element.
> >>>   * Each element is a __u16. */
> >>> #define V4L2_MATRIX_TYPE_MD_THRESHOLD  (2)
> >>>
> >>> /**
> >>>   * struct v4l2_query_matrix - VIDIOC_QUERY_MATRIX argument
> >>>   * @type:       matrix type
> >>>   * @index:      matrix index of the given type
> >>>   * @columns:    number of columns in the matrix
> >>>   * @rows:       number of rows in the matrix
> >>>   * @elem_min:   minimum matrix element value
> >>>   * @elem_max:   maximum matrix element value
> >>>   * @elem_size:  size in bytes each matrix element
> >>>   * @reserved:   future extensions, applications and drivers must zero this.
> >>>   */
> >>> struct v4l2_query_matrix {
> >>>          __u32 type;
> >>>          __u32 index;
> >>>          __u32 columns;
> >>>          __u32 rows;
> >>>          __s64 elem_min;
> >>>          __s64 elem_max;
> >>>          __u32 elem_size;
> >>>          __u32 reserved[23];
> >>> } __attribute__ ((packed));
> >>>
> >>> /**
> >>>   * struct v4l2_matrix - VIDIOC_G/S_MATRIX argument
> >>>   * @type:       matrix type
> >>>   * @index:      matrix index of the given type
> >>>   * @rect:       which part of the matrix to get/set
> >>>   * @matrix:     pointer to the matrix of size (in bytes):
> >>>   *              elem_size * rect.width * rect.height
> >>>   * @reserved:   future extensions, applications and drivers must zero this.
> >>>   */
> >>> struct v4l2_matrix {
> >>>          __u32 type;
> >>>          __u32 index;
> >>>          struct v4l2_rect rect;
> >>>          void __user *matrix;
> >>>          __u32 reserved[12];
> >>> } __attribute__ ((packed));
> >>>
> >>>
> >>> /* Experimental, these three ioctls may change over the next couple of kernel
> >>>     versions. */
> >>> #define VIDIOC_QUERY_MATRIX     _IORW('V', 103, struct v4l2_query_matrix)
> >>> #define VIDIOC_G_MATRIX         _IORW('V', 104, struct v4l2_matrix)
> >>> #define VIDIOC_S_MATRIX         _IORW('V', 105, struct v4l2_matrix)
> >>>
> >>>
> >>> Each matrix has a type (which describes the meaning of the matrix) and an
> >>> index (allowing for multiple matrices of the same type).
> >>
> >> I'm just wondering how this could be used to specify coefficients 
> >> associated with
> >> selection rectangles for auto focus ?
> > 
> > I've been thinking about this. The problem is that sometimes you want to
> > associate a matrix with some other object (a selection rectangle, a video
> > input, perhaps a video buffer, etc.). A simple index may not be enough. So
> > how about replacing the index field with a union:
> > 
> > 	union {
> > 		__u32 reserved[4];
> > 	} ref;
> > 
> > The precise contents of the union will be defined by the matrix type. Apps
> > should probably zero ref to allow adding additional 'reference' fields in
> > the future. So to refer to a selection rectangle you would add:
> > 
> > 	struct {
> > 		__u32 type;
> > 		__u32 target;
> > 	};
> > 
> > to the union.
> > 
> >> This API would be used only for 
> >> passing a
> >> set of coefficients, assuming the individual rectangles are passed 
> >> somehow else ?
> > 
> > Yes.
> > 
> 
> It will make AF setting dispersed across three APIs:
> 
> 1. Set V4L2_CID_AUTO_FOCUS_AREA to rectangle.
> 2. Set rectangles via selection API.
> 3. Set coefficients via matrix API.
> 4. Trigger V4L2_CID_AUTO_FOCUS_START.
> 
> Passing coefficients via selection API (I hope u32 would be enough for
> now) or passing rectangles together with coefficients via matrix API
> could make it little shorter and we could avoid to create object references.

The problem is always how to find a balance between generic API components
and specific API components. Adding coefficients to the selection API makes
a generic API suddenly specific to one particular type of driver, something
that most other drivers implementing the selection API do not need.

Ditto for passing rectangles via the matrix API.

So you have two alternatives: either create a custom ioctl for you driver
that sets both the rectangle and coefficients in one go, or have two smaller
building blocks that you combine to achieve the result you want. The latter
is much more the Unix philisophy.

BTW, can you give (or point to) some background information regarding these
autofocus coefficients? What are they and how are they used?

Regards,

	Hans
