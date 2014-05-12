Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1755 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaELLHg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 May 2014 07:07:36 -0400
Message-ID: <5370AB45.9080008@xs4all.nl>
Date: Mon, 12 May 2014 13:06:45 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC ATTN] Multi-dimensional matrices
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

During the mini-summit we discussed multi-dimensional matrix support.
My proposal only added support for 2D matrices. It turns out that there
is at least one case where a 3D matrix is used (a 17x17x17 matrix which
maps an RGB value to another RGB value, with R, G and B being the matrix
indices).

I was requested to look into this a bit more and how it should be supported.

One option is to support any number of dimensions by using a pointer to an
array of dimension sizes:

	__u32 dimensions;
	__u32 *dims;

The problem with this IMHO is that this complicates using the VIDIOC_QUERY_EXT_CTRL
ioctl: you always need to supply a separate array when you call this ioctl,
and remember to set 'dimensions' to the size of your array. And be able to
handle the case where there are more dimensions than the size of your array
at which time you need to resize it and call the ioctl again.

My problem with that is that I think that that is simply not worth the trouble.

I agree that supporting 3D matrices makes sense, and perhaps 4D as well (in
case ARGB values are used as indices into the 4D matrix). But I think it is unlikely
that 5D or up matrices will be seen in actual hardware (if only because of
the size of the data involved), and if those will appear then it is always
possible to implement them as a 4D matrix of a struct that contains the
remaining dimensions. E.g.:

struct my_drv_type {
	__u32 m[2][3];
};

struct my_drv_type ctrl_matrix[4][3][2][2];

This really is a 6D matrix '__u32 m[4][3][2][2][2][3];'.

In other words, I am really opposed to add support for any number of dimensions,
I think that is overengineering and I believe that there are alternative solutions
should we encounter hardware that does something so strange.

So the rest of my RFC outlines my proposal for extending the number of dimensions
to a fixed number. For the sake of argument I'm going with 4 dimensions.

In my current proposal the v4l2_query_ext_ctrl struct has two fields describing
the dimensions of the matrix: width and height.

A 1D matrix (aka array) means that one of the two will be set to 1. These fields
are always >= 1. The number of elements in the matrix will always be width * height.

If we go to a higher number of dimensions then you do need a new 'elems' or 'elements'
field that has the total number of elements in the matrix (for a 2D matrix that would
be width * height). It just becomes too cumbersome in applications to always have to
multiply all the dimension sizes to get the number of elements.

The approach I want to take is to replace 'width' and 'height' by this:

	#define V4L2_CTRL_MAX_DIMS 4

	__u32 elems;
	__u32 dimensions;
	__u32 dims[V4L2_CTRL_MAX_DIMS];

So if 'dimensions' is 2, then dims[0] would be the height and dims[1] the width.
For 3D [0] would be depth, [1] height, [2] width.

The remaining dims values would be 0.

An option might be to drop the dimensions field and let the apps loop over the
dims values until they encounter a 0. I think having a dimensions field would be
the way to go, though. It's too cumbersome for apps otherwise.

If someone has better suggestions for the field names, then I'm open to that. The
same with the number of supported dimensions. It's 4 in this example, but if
someone thinks 40 might be better, then that's fine by me :-)

Personally I think that it should be a value between 4 and 8. We know there is a
use-case for 3, so let's go one up at least. And above 8 I think it becomes really
silly.

I have implemented this in this tree:

http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/log/?h=propapi-part4

That tree also includes all other changes I was requested to make.

Before I can finish this I need to have feedback. Once we have agreement I'll make
a new patch series that will include updated documentation for this so we can
finally merge this.

Regards,

	Hans
