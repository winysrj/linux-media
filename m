Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2712 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab1HCPai (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Aug 2011 11:30:38 -0400
Message-ID: <f94be2f6fed71ddc3e717bd84c027d01.squirrel@webmail.xs4all.nl>
In-Reply-To: <8f4c70b8d38860d2403645fa773d8d42.squirrel@webmail.xs4all.nl>
References: <Pine.LNX.4.64.1107201025120.12084@axis700.grange>
    <CAMm-=zB3dOJyCy7ZhqiTQkeL2b=Dvtz8geMR8zbHYBCVR6=pEw@mail.gmail.com>
    <201107280856.55731.hverkuil@xs4all.nl>
    <Pine.LNX.4.64.1108020919290.29918@axis700.grange>
    <8f4c70b8d38860d2403645fa773d8d42.squirrel@webmail.xs4all.nl>
Date: Wed, 3 Aug 2011 17:29:28 +0200
Subject: Re: [PATCH v3] V4L: add two new ioctl()s for multi-size  
 videobuffer management
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Cc: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
	"Pawel Osciak" <pawel@osciak.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>,
	"Sakari Ailus" <sakari.ailus@iki.fi>,
	"Sakari Ailus" <sakari.ailus@maxwell.research.nokia.com>,
	"Laurent Pinchart" <laurent.pinchart@ideasonboard.com>,
	"Mauro Carvalho Chehab" <mchehab@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> On Thu, 28 Jul 2011, Hans Verkuil wrote:
>>
>>> On Thursday, July 28, 2011 06:11:38 Pawel Osciak wrote:
>>> > Hi Guennadi,
>>> >
>>> > On Wed, Jul 20, 2011 at 01:43, Guennadi Liakhovetski
>>> > <g.liakhovetski@gmx.de> wrote:
>>> > > A possibility to preallocate and initialise buffers of different
>>> sizes
>>> > > in V4L2 is required for an efficient implementation of asnapshot
>>> mode.
>>> > > This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
>>> > > VIDIOC_PREPARE_BUF and defines respective data structures.
>>> > >
>>> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>>> > > ---
>>> > >
>>> > <snip>
>>> >
>>> > This looks nicer, I like how we got rid of destroy and gave up on
>>> > making holes, it would've given us a lot of headaches. I'm thinking
>>> > about some issues though and also have some comments/questions
>>> further
>>> > below.
>>> >
>>> > Already mentioned by others mixing of REQBUFS and CREATE_BUFS.
>>> > Personally I'd like to allow mixing, including REQBUFS for non-zero,
>>> > because I think it would be easy to do. I think it could work in the
>>> > same way as REQBUFS for !=0 works currently (at least in vb2), if we
>>> > already have some buffers allocated and they are not in use, we free
>>> > them and a new set is allocated. So I guess it could just stay this
>>> > way. REQBUFS(0) would of course free everything.
>>> >
>>> > Passing format to CREATE_BUFS will make vb2 a bit format-aware, as it
>>> > would have to pass it forward to the driver somehow. The obvious way
>>> > would be just vb2 calling the driver's s_fmt handler, but that won't
>>> > work, as you can't pass indexes to s_fmt. So we'd have to implement a
>>> > new driver callback for setting formats per index. I guess there is
>>> no
>>> > way around it, unless we actually take the format struct out of
>>> > CREATE_BUFS and somehow do it via S_FMT. The single-planar structure
>>> > is full already though, the only way would be to use
>>> > v4l2_pix_format_mplane instead with plane count = 1 (or more if
>>> > needed).
>>>
>>> I just got an idea for this: use TRY_FMT. That will do exactly what
>>> you want. In fact, perhaps we should remove the format struct from
>>> CREATE_BUFS and use __u32 sizes[VIDEO_MAX_PLANES] instead. Let the
>>> application call TRY_FMT and initialize the sizes array instead of
>>> putting that into vb2. We may need a num_planes field as well. If the
>>> sizes are all 0 (or num_planes is 0), then the driver can use the
>>> current
>>> format, just as it does with REQBUFS.
>>>
>>> Or am I missing something?
>>
>> ...After more thinking and looking at the vb2 code, this began to feel
>> wrong to me. This introduces an asymmetry, which doesn't necessarily
>> look
>> good to me. At present we have the TRY_FMT and S_FMT ioctl()s, which
>> among
>> other tasks calculate sizeimage and bytesperline - either per plane or
>> total.
>
> Correct.
>
>> Besides we also have the REQBUFS call, that internally calls the
>> .queue_setup() queue method. In that method the _driver_ has a chance to
>> calculate for the _current format_ the number of planes (again?...) and
>> buffer sizes for each plane.
>
> Correct. Usually the driver will update some internal datastructure
> whenever S_FMT is called to store the sizeimage/bytesperline etc. so
> queue_setup can refer to those values.
>
>> This suggests, that the latter calculation
>> can be different from the former.
>
> No, it can't (shouldn't). For USERPTR mode applications always need to
> rely on sizeimage anyway, so doing anything different in queue_setup is
> something I would consider a driver bug.
>
>> Now you're suggesting to use TRY_FMT to calculate the number of planes
>> and
>> per-plane sizeofimage, and then use _only_ this information to set up
>> the
>> buffers from the CREATE_BUFS ioctl(). So, are we now claiming, that this
>> information alone (per-plane-sizeofimage) should be dufficient to set up
>> buffers?
>
> Yes. Again, if it is not sufficient, then USERPTR wouldn't work :-)

Ouch. While this is correct with respect to the sizes, it is a different
matter when it comes to e.g. start addresses.

The prime example is the Samsung hardware where some multiplanar formats
need to be allocated from specific memory banks. So trying to pass just
sizes to CREATE_BUFS would not carry enough information for the samsung
driver to decide whether or not to allocate from specific memory banks or
if any memory will do.

So either we go back to using v4l2_format, or we add a fourcc describing
the pixelformat. I *think* this may be sufficient, but I do not know for
sure.

Regards,

       Hans

