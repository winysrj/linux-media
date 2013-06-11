Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:41628 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab3FKVdr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Jun 2013 17:33:47 -0400
Received: by mail-bk0-f52.google.com with SMTP id d7so3820065bkh.11
        for <linux-media@vger.kernel.org>; Tue, 11 Jun 2013 14:33:46 -0700 (PDT)
Message-ID: <51B797B6.5080302@gmail.com>
Date: Tue, 11 Jun 2013 23:33:42 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [RFC] Add query/get/set matrix ioctls
References: <201306031414.49392.hverkuil@xs4all.nl>
In-Reply-To: <201306031414.49392.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 06/03/2013 02:14 PM, Hans Verkuil wrote:
> Hi all,
>
> When working on the Motion Detection API, I realized that my proposal for
> two new G/S_MD_BLOCKS ioctls was too specific for the motion detection use
> case.
>
> The Motion Detection RFC can be found here:
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg62085.html
>
> What I was really attempting to do was to create an API to pass a matrix
> to the hardware.
>
> This is also related to a long-standing request to add support for
> arrays to the control API. Adding such support to the control API is in my
> opinion a very bad idea since the control API is meant to provide all
> meta data necessary in order to create e.g. control panels. Adding array
> support to the control API would make that very difficult, particularly
> with respect to GUI design.
>
> So instead this proposal creates a new API to query, get and set matrices:

This looks very interesting, one use case that comes immediately to mind is
configuring the quantization/Huffman tables in a hardware JPEG codec. 
The only
thing left would have probably been setting up the comment segments, 
consisting
of arbitrary byte strings.

This is even more nice than your previous proposal ;) Quite generic - but
I was wondering, what if we went one step further and defined QUERY/GET/
SET_PROPERTY ioctls, where the type (matrix or anything else) would be
also configurable ? :-) Just brainstorming, if memory serves me well few
people suggested something like this in the past.
So for the starters we could have matrix type and carefully be adding in
the future anything what's needed ?

> /* Define to which motion detection region each element belongs.
>   * Each element is a __u8. */
> #define V4L2_MATRIX_TYPE_MD_REGION     (1)
> /* Define the motion detection threshold for each element.
>   * Each element is a __u16. */
> #define V4L2_MATRIX_TYPE_MD_THRESHOLD  (2)
>
> /**
>   * struct v4l2_query_matrix - VIDIOC_QUERY_MATRIX argument
>   * @type:       matrix type
>   * @index:      matrix index of the given type
>   * @columns:    number of columns in the matrix
>   * @rows:       number of rows in the matrix
>   * @elem_min:   minimum matrix element value
>   * @elem_max:   maximum matrix element value
>   * @elem_size:  size in bytes each matrix element
>   * @reserved:   future extensions, applications and drivers must zero this.
>   */
> struct v4l2_query_matrix {
>          __u32 type;
>          __u32 index;
>          __u32 columns;
>          __u32 rows;
>          __s64 elem_min;
>          __s64 elem_max;
>          __u32 elem_size;
>          __u32 reserved[23];
> } __attribute__ ((packed));
>
> /**
>   * struct v4l2_matrix - VIDIOC_G/S_MATRIX argument
>   * @type:       matrix type
>   * @index:      matrix index of the given type
>   * @rect:       which part of the matrix to get/set
>   * @matrix:     pointer to the matrix of size (in bytes):
>   *              elem_size * rect.width * rect.height
>   * @reserved:   future extensions, applications and drivers must zero this.
>   */
> struct v4l2_matrix {
>          __u32 type;
>          __u32 index;
>          struct v4l2_rect rect;
>          void __user *matrix;
>          __u32 reserved[12];
> } __attribute__ ((packed));
>
>
> /* Experimental, these three ioctls may change over the next couple of kernel
>     versions. */
> #define VIDIOC_QUERY_MATRIX     _IORW('V', 103, struct v4l2_query_matrix)
> #define VIDIOC_G_MATRIX         _IORW('V', 104, struct v4l2_matrix)
> #define VIDIOC_S_MATRIX         _IORW('V', 105, struct v4l2_matrix)
>
>
> Each matrix has a type (which describes the meaning of the matrix) and an
> index (allowing for multiple matrices of the same type).

I'm just wondering how this could be used to specify coefficients 
associated with
selection rectangles for auto focus ? This API would be used only for 
passing a
set of coefficients, assuming the individual rectangles are passed 
somehow else ?

> QUERY_MATRIX will return the number of columns and rows in the full matrix,
> the size (in bytes) of each element and the minimum and maximum value of
> each element. Some matrix types may have non-integer elements, in which case
> the minimum and maximum values are ignored.

I guess min/max could be made unions with a possibility to define other 
types ?
Why should we limit ourselves to integers only ? However anything 
(sensible?)
that comes to my mind ATM are rational numbers only.

> With S_MATRIX and G_MATRIX you can get/set a (part of a) matrix. The rect
> struct will give the part of the matrix that you want to set or retrieve, and
> the matrix pointer points to the matrix data.
>
> Currently only two matrix types are defined, see the motion detection RFC for
> details.
>
> This approach is basically the same as proposed in the motion detection RFC,
> but it is much more general.
>
> Discussion points:
>
> 1) I'm using elem_size to allow for any element size. An alternative would be to
> define specific element types (e.g. U8, S8, U16, S16, etc.), but I feel that
> that is overkill. It is easier to associate each matrix type with a specific
> element type in the documentation for each type. For allocation purposes it
> is more useful to know the element size than the element type. But perhaps
> elem_size can be dropped altogether, or, alternatively, both an elem_size and
> elem_type should be defined.

IMHO it makes sense to keep elem_size, for allocation purposes etc. And the
element type could be probably derived from the matrix type ?

> 2) Per-driver matrix types are probably necessary as well: for example while
> colorspace conversion matrices are in principle generic, in practice the
> precise format of the elements is hardware specific. This isn't a problem
> as long as it is a well-defined private matrix type.

Sounds reasonable.


Regards,
Sylwester
