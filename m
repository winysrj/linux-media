Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1123 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbaELNsZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 May 2014 09:48:25 -0400
Message-ID: <5370D0FE.1080804@xs4all.nl>
Date: Mon, 12 May 2014 15:47:42 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC ATTN] Multi-dimensional matrices
References: <5370AB45.9080008@xs4all.nl> <20140512095605.3dc2f7d5@recife.lan>
In-Reply-To: <20140512095605.3dc2f7d5@recife.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/12/2014 02:56 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 12 May 2014 13:06:45 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> Hi all,
>>
>> During the mini-summit we discussed multi-dimensional matrix support.
>> My proposal only added support for 2D matrices. It turns out that there
>> is at least one case where a 3D matrix is used (a 17x17x17 matrix which
>> maps an RGB value to another RGB value, with R, G and B being the matrix
>> indices).
>>
>> I was requested to look into this a bit more and how it should be supported.
>>
>> One option is to support any number of dimensions by using a pointer to an
>> array of dimension sizes:
>>
>> 	__u32 dimensions;
>> 	__u32 *dims;
>>
>> The problem with this IMHO is that this complicates using the VIDIOC_QUERY_EXT_CTRL
>> ioctl: you always need to supply a separate array when you call this ioctl,
>> and remember to set 'dimensions' to the size of your array. And be able to
>> handle the case where there are more dimensions than the size of your array
>> at which time you need to resize it and call the ioctl again.
> 
> I see.
> 
>>
>> My problem with that is that I think that that is simply not worth the trouble.
>>
>> I agree that supporting 3D matrices makes sense, and perhaps 4D as well (in
>> case ARGB values are used as indices into the 4D matrix). But I think it is unlikely
>> that 5D or up matrices will be seen in actual hardware (if only because of
>> the size of the data involved), and if those will appear then it is always
>> possible to implement them as a 4D matrix of a struct that contains the
>> remaining dimensions. E.g.:
>>
>> struct my_drv_type {
>> 	__u32 m[2][3];
>> };
>>
>> struct my_drv_type ctrl_matrix[4][3][2][2];
>>
>> This really is a 6D matrix '__u32 m[4][3][2][2][2][3];'.
>>
>> In other words, I am really opposed to add support for any number of dimensions,
>> I think that is overengineering and I believe that there are alternative solutions
>> should we encounter hardware that does something so strange.
>>
>> So the rest of my RFC outlines my proposal for extending the number of dimensions
>> to a fixed number. For the sake of argument I'm going with 4 dimensions.
>>
>> In my current proposal the v4l2_query_ext_ctrl struct has two fields describing
>> the dimensions of the matrix: width and height.
>>
>> A 1D matrix (aka array) means that one of the two will be set to 1. These fields
>> are always >= 1. The number of elements in the matrix will always be width * height.
>>
>> If we go to a higher number of dimensions then you do need a new 'elems' or 'elements'
>> field that has the total number of elements in the matrix (for a 2D matrix that would
>> be width * height). It just becomes too cumbersome in applications to always have to
>> multiply all the dimension sizes to get the number of elements.
>>
>> The approach I want to take is to replace 'width' and 'height' by this:
>>
>> 	#define V4L2_CTRL_MAX_DIMS 4
>>
>> 	__u32 elems;
>> 	__u32 dimensions;
>> 	__u32 dims[V4L2_CTRL_MAX_DIMS];
>>
>> So if 'dimensions' is 2, then dims[0] would be the height and dims[1] the width.
>> For 3D [0] would be depth, [1] height, [2] width.
>>
>> The remaining dims values would be 0.
> 
> I really don't like this approach. mapping a 1D array as a 4D
> array sounds a really crappy design API. Also, whatever random
> value we use for the number of dimensions, it would be just an
> arbitrary number that we'll need to live with that forever.

Huh? The 'dimensions' field is the maximum number of dimensions used
for the control. So an array sets 'dimensions' to 1 and dims[0] to the
size of the array. dims[1...maxdim-1] are all set to 0.

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
> 
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

What would be the benefit of this as opposed to passing the dimensions as a separate
array? As userspace you still need to provide a pointer to an array to contain the
dimensions. I don't see the advantage of parameterizing the ioctl define.

Dealing with struct containing pointers is just painful, both for the application
and for the driver/v4l2 core. Which I don't mind if there is a clear and compelling
reason for it.

I just don't see that reason here. If everyone thinks that allowing for any number
of dimensions is the way to go, then I'll implement it. But I truly believe that
that's overengineering. So I'd like to see some more opinions.

Regards,

	Hans

> 
>>
>> An option might be to drop the dimensions field and let the apps loop over the
>> dims values until they encounter a 0. I think having a dimensions field would be
>> the way to go, though. It's too cumbersome for apps otherwise.
>>
>> If someone has better suggestions for the field names, then I'm open to that. The
>> same with the number of supported dimensions. It's 4 in this example, but if
>> someone thinks 40 might be better, then that's fine by me :-)
>>
>> Personally I think that it should be a value between 4 and 8. We know there is a
>> use-case for 3, so let's go one up at least. And above 8 I think it becomes really
>> silly.
>>
>> I have implemented this in this tree:
>>
>> http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/log/?h=propapi-part4
>>
>> That tree also includes all other changes I was requested to make.
>>
>> Before I can finish this I need to have feedback. Once we have agreement I'll make
>> a new patch series that will include updated documentation for this so we can
>> finally merge this.
>>
>> Regards,
>>
>> 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

