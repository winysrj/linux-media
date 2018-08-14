Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:34666 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728408AbeHNLIG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 07:08:06 -0400
Date: Tue, 14 Aug 2018 05:21:56 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv17 01/34] Documentation: v4l: document request API
Message-ID: <20180814052156.4c961226@coco.lan>
In-Reply-To: <0203cfbe-ae51-a94b-08c8-0a31a59486f0@xs4all.nl>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
        <20180804124526.46206-2-hverkuil@xs4all.nl>
        <20180809144300.6ea1d040@coco.lan>
        <0203cfbe-ae51-a94b-08c8-0a31a59486f0@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 10 Aug 2018 09:20:48 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> On 08/09/2018 07:43 PM, Mauro Carvalho Chehab wrote:
> > Em Sat,  4 Aug 2018 14:44:53 +0200
> > Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> >   
> >> From: Alexandre Courbot <acourbot@chromium.org>
> >>
> >> Document the request API for V4L2 devices, and amend the documentation
> >> of system calls influenced by it.  
> > 
> > It follows some comments. Most are nitpicks. There are just two ones
> > that aren't:
> > 	- a problem at the tables changes on Documentation/
> > 	- a question with regards to MEDIA_IOC_REQUEST_ALLOC ioctl.  
> 
> I'll fix all the smaller comments and in this reply only address these
> two topics.
> 
> > 
> > I'll keep reviewing this patch series.
> > 
> > PS.: I lost entirely my first review to this doc... I hope I didn't
> > forget anything when re-typing my comments.
> >   
> >>
> >> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> >> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >> ---
> >>  .../media/uapi/mediactl/media-controller.rst  |   1 +
> >>  .../media/uapi/mediactl/media-funcs.rst       |   6 +
> >>  .../uapi/mediactl/media-ioc-request-alloc.rst |  78 ++++++
> >>  .../uapi/mediactl/media-request-ioc-queue.rst |  82 ++++++
> >>  .../mediactl/media-request-ioc-reinit.rst     |  51 ++++
> >>  .../media/uapi/mediactl/request-api.rst       | 247 ++++++++++++++++++
> >>  .../uapi/mediactl/request-func-close.rst      |  49 ++++
> >>  .../uapi/mediactl/request-func-ioctl.rst      |  68 +++++
> >>  .../media/uapi/mediactl/request-func-poll.rst |  77 ++++++
> >>  Documentation/media/uapi/v4l/buffer.rst       |  21 +-
> >>  .../media/uapi/v4l/vidioc-g-ext-ctrls.rst     |  94 ++++---
> >>  Documentation/media/uapi/v4l/vidioc-qbuf.rst  |  32 ++-
> >>  .../media/videodev2.h.rst.exceptions          |   1 +
> >>  13 files changed, 771 insertions(+), 36 deletions(-)
> >>  create mode 100644 Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
> >>  create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
> >>  create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
> >>  create mode 100644 Documentation/media/uapi/mediactl/request-api.rst
> >>  create mode 100644 Documentation/media/uapi/mediactl/request-func-close.rst
> >>  create mode 100644 Documentation/media/uapi/mediactl/request-func-ioctl.rst
> >>  create mode 100644 Documentation/media/uapi/mediactl/request-func-poll.rst
> >>  
> 
> <snip>
> 
> >> +.. c:type:: media_request_alloc
> >> +
> >> +.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
> >> +
> >> +.. flat-table:: struct media_request_alloc
> >> +    :header-rows:  0
> >> +    :stub-columns: 0
> >> +    :widths:       1 1 2
> >> +
> >> +    *  -  __s32
> >> +       -  ``fd``
> >> +       -  The file descriptor of the request.  
> > 
> > It should be mentioned that the struct should be zeroed before calling
> > the Kernel, but I is overkill to have a struct to pass just one value.
> > 
> > I mean, if this has just one value inside the struct, it is a way better
> > to declare it as:
> > 
> > .. c:function:: int ioctl( int fd, MEDIA_IOC_REQUEST_ALLOC, s32 &argp )
> > 
> > Even if we later need more stuff, the size of a new MEDIA_IOC_REQUEST_ALLOC
> > will be bigger, and then (and only then) we can add extra stuff.
> > 
> > Or are you foreseen any new fields there in short term?  
> 
> The first version just had a s32 argument, not a struct. The main reason for
> going back to a struct was indeed to make it easier to add new fields in the
> future. I don't foresee any, but then, you never do.
> 
> I don't have a particularly strong opinion on this one way or another, but
> if we change it back to a s32 argument, then I want the opinion of others as
> well.

I'll comment it on patch 02/34.

> 
> <snip>
> 
> >> @@ -110,15 +130,13 @@ still cause this situation.
> >>  .. flat-table:: struct v4l2_ext_control
> >>      :header-rows:  0
> >>      :stub-columns: 0
> >> -    :widths:       1 1 1 2
> >> +    :widths:       1 1 3  
> > 
> > This is wrong: you can't change widths without changing the preceeding
> > .. tabularcolumns tag.
> > 
> > You probably didn't test PDF generation for this table.
> > 
> > Also, the change is this table doesn't belong to this patch. It is
> > a (doubtful) optimization at the table, not related to requests API.
> >   
> >>  
> >>      * - __u32
> >>        - ``id``
> >> -      -
> >>        - Identifies the control, set by the application.
> >>      * - __u32
> >>        - ``size``
> >> -      -
> >>        - The total size in bytes of the payload of this control. This is
> >>  	normally 0, but for pointer controls this should be set to the
> >>  	size of the memory containing the payload, or that will receive
> >> @@ -135,51 +153,43 @@ still cause this situation.
> >>  	   *length* of the string may well be much smaller.
> >>      * - __u32
> >>        - ``reserved2``\ [1]
> >> -      -
> >>        - Reserved for future extensions. Drivers and applications must set
> >>  	the array to zero.
> >> -    * - union
> >> +    * - union {  
> > 
> > Adding { and } at the end sounds ok...
> >   
> >>        - (anonymous)
> >> -    * -
> >> -      - __s32
> >> +    * - __s32
> >>        - ``value``
> >>        - New value or current value. Valid if this control is not of type
> >>  	``V4L2_CTRL_TYPE_INTEGER64`` and ``V4L2_CTRL_FLAG_HAS_PAYLOAD`` is
> >>  	not set.
> >> -    * -
> >> -      - __s64
> >> +    * - __s64
> >>        - ``value64``
> >>        - New value or current value. Valid if this control is of type
> >>  	``V4L2_CTRL_TYPE_INTEGER64`` and ``V4L2_CTRL_FLAG_HAS_PAYLOAD`` is
> >>  	not set.
> >> -    * -
> >> -      - char *
> >> +    * - char *
> >>        - ``string``
> >>        - A pointer to a string. Valid if this control is of type
> >>  	``V4L2_CTRL_TYPE_STRING``.
> >> -    * -
> >> -      - __u8 *
> >> +    * - __u8 *
> >>        - ``p_u8``
> >>        - A pointer to a matrix control of unsigned 8-bit values. Valid if
> >>  	this control is of type ``V4L2_CTRL_TYPE_U8``.
> >> -    * -
> >> -      - __u16 *
> >> +    * - __u16 *
> >>        - ``p_u16``
> >>        - A pointer to a matrix control of unsigned 16-bit values. Valid if
> >>  	this control is of type ``V4L2_CTRL_TYPE_U16``.
> >> -    * -
> >> -      - __u32 *
> >> +    * - __u32 *
> >>        - ``p_u32``
> >>        - A pointer to a matrix control of unsigned 32-bit values. Valid if
> >>  	this control is of type ``V4L2_CTRL_TYPE_U32``.
> >> -    * -
> >> -      - void *
> >> +    * - void *
> >>        - ``ptr``
> >>        - A pointer to a compound type which can be an N-dimensional array
> >>  	and/or a compound type (the control's type is >=
> >>  	``V4L2_CTRL_COMPOUND_TYPES``). Valid if
> >>  	``V4L2_CTRL_FLAG_HAS_PAYLOAD`` is set for this control.
> >> -
> >> +    * - }  
> > 
> > ... however, removing the extra cell is not, because it will break the
> > indent inside the union's elements. The best way to keep them indented
> > is to use a separate cell (at least on DocBook). 
> > 
> > You could come with some other solution that would add a fixed amount
> > of spaces for all the elements inside the union, but I guess the
> > easiest way to do that is by having a separate column.  
> 
> The problem is that that extra cell makes the table hard to read: the last column
> with the actual description gets squashed leading to narrow hard to read columns.
> 
> The only reason for doing this is a stupid union.
> 
> I'll experiment a bit more with this.

We used this since DocBook for all tables with unions. The conversion
kept this. I remember I did some experiments on that time trying to
do it on some other way, but didn't spend too much time on seeking
for an alternative, as this was not the top priority at the conversion.

I don't doubt that some other way to indent unions (and nested structs)
would be possible.

Anyway, this change is unrelated to Request API itself. For this patch
series, please keep the extra cell. Just touch what's required for the
request API itself.

Feel free to experiment some other options and submit a separate
patch series, if you find a better way. In this case, please double 
check the docs, as I guess there were a lot more tables using this 
trick to indent unions and nested structs.

> 
> >   
> >>  
> >>  .. tabularcolumns:: |p{4.0cm}|p{2.2cm}|p{2.1cm}|p{8.2cm}|
> >>  
> >> @@ -190,12 +200,11 @@ still cause this situation.
> >>  .. flat-table:: struct v4l2_ext_controls
> >>      :header-rows:  0
> >>      :stub-columns: 0
> >> -    :widths:       1 1 2 1
> >> +    :widths:       1 1 3  
> > 
> > Same comments I made for the past table apply here as well.  
> 
> Regards,
> 
> 	Hans



Thanks,
Mauro
