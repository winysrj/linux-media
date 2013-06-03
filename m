Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:2935 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab3FCMPD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Jun 2013 08:15:03 -0400
Received: from alastor.dyndns.org (166.80-203-20.nextgentel.com [80.203.20.166])
	(authenticated bits=0)
	by smtp-vbr19.xs4all.nl (8.13.8/8.13.8) with ESMTP id r53CEo5t014015
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-media@vger.kernel.org>; Mon, 3 Jun 2013 14:14:52 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
Received: from tschai.localnet (tschai.lan [192.168.1.10])
	(Authenticated sender: hans)
	by alastor.dyndns.org (Postfix) with ESMTPSA id 4765B35E003C
	for <linux-media@vger.kernel.org>; Mon,  3 Jun 2013 14:14:50 +0200 (CEST)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [RFC] Add query/get/set matrix ioctls
Date: Mon, 3 Jun 2013 14:14:49 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201306031414.49392.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

When working on the Motion Detection API, I realized that my proposal for
two new G/S_MD_BLOCKS ioctls was too specific for the motion detection use
case.

The Motion Detection RFC can be found here:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg62085.html

What I was really attempting to do was to create an API to pass a matrix
to the hardware.

This is also related to a long-standing request to add support for
arrays to the control API. Adding such support to the control API is in my
opinion a very bad idea since the control API is meant to provide all
meta data necessary in order to create e.g. control panels. Adding array
support to the control API would make that very difficult, particularly
with respect to GUI design.

So instead this proposal creates a new API to query, get and set matrices:


/* Define to which motion detection region each element belongs.
 * Each element is a __u8. */
#define V4L2_MATRIX_TYPE_MD_REGION     (1)
/* Define the motion detection threshold for each element.
 * Each element is a __u16. */
#define V4L2_MATRIX_TYPE_MD_THRESHOLD  (2)

/**
 * struct v4l2_query_matrix - VIDIOC_QUERY_MATRIX argument
 * @type:       matrix type
 * @index:      matrix index of the given type
 * @columns:    number of columns in the matrix
 * @rows:       number of rows in the matrix
 * @elem_min:   minimum matrix element value
 * @elem_max:   maximum matrix element value
 * @elem_size:  size in bytes each matrix element
 * @reserved:   future extensions, applications and drivers must zero this.
 */
struct v4l2_query_matrix {
        __u32 type;
        __u32 index;
        __u32 columns;
        __u32 rows;
        __s64 elem_min;
        __s64 elem_max;
        __u32 elem_size;
        __u32 reserved[23];
} __attribute__ ((packed));

/**
 * struct v4l2_matrix - VIDIOC_G/S_MATRIX argument
 * @type:       matrix type
 * @index:      matrix index of the given type
 * @rect:       which part of the matrix to get/set
 * @matrix:     pointer to the matrix of size (in bytes):
 *              elem_size * rect.width * rect.height
 * @reserved:   future extensions, applications and drivers must zero this.
 */
struct v4l2_matrix {
        __u32 type;
        __u32 index;
        struct v4l2_rect rect;
        void __user *matrix;
        __u32 reserved[12];
} __attribute__ ((packed));


/* Experimental, these three ioctls may change over the next couple of kernel
   versions. */
#define VIDIOC_QUERY_MATRIX     _IORW('V', 103, struct v4l2_query_matrix)
#define VIDIOC_G_MATRIX         _IORW('V', 104, struct v4l2_matrix)
#define VIDIOC_S_MATRIX         _IORW('V', 105, struct v4l2_matrix)


Each matrix has a type (which describes the meaning of the matrix) and an
index (allowing for multiple matrices of the same type).

QUERY_MATRIX will return the number of columns and rows in the full matrix,
the size (in bytes) of each element and the minimum and maximum value of
each element. Some matrix types may have non-integer elements, in which case
the minimum and maximum values are ignored.

With S_MATRIX and G_MATRIX you can get/set a (part of a) matrix. The rect
struct will give the part of the matrix that you want to set or retrieve, and
the matrix pointer points to the matrix data.

Currently only two matrix types are defined, see the motion detection RFC for
details.

This approach is basically the same as proposed in the motion detection RFC,
but it is much more general.

Discussion points:

1) I'm using elem_size to allow for any element size. An alternative would be to
define specific element types (e.g. U8, S8, U16, S16, etc.), but I feel that
that is overkill. It is easier to associate each matrix type with a specific
element type in the documentation for each type. For allocation purposes it
is more useful to know the element size than the element type. But perhaps
elem_size can be dropped altogether, or, alternatively, both an elem_size and
elem_type should be defined.

2) Per-driver matrix types are probably necessary as well: for example while
colorspace conversion matrices are in principle generic, in practice the
precise format of the elements is hardware specific. This isn't a problem
as long as it is a well-defined private matrix type.

Comments? Questions?

	Hans
