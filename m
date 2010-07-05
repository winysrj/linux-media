Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:16817 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab0GEMhw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Jul 2010 08:37:52 -0400
Received: from eu_spt1 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L530008P4F1BP@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 05 Jul 2010 13:37:49 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L5300B324F1CV@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 05 Jul 2010 13:37:49 +0100 (BST)
Date: Mon, 05 Jul 2010 14:36:38 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [RFC v3] Multi-plane buffer support for V4L2 API
In-reply-to: <201007050855.12059.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: 'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	kyungmin.park@samsung.com
Message-id: <005401cb1c3e$b6c5d680$24518380$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-language: pl
Content-transfer-encoding: 7BIT
References: <002401cb139d$1d5df080$5819d180$%osciak@samsung.com>
 <201007050855.12059.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

thanks a lot for finding the time to comment on this.

> Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
>On Thursday 24 June 2010 14:59:43 Pawel Osciak wrote:
>> struct v4l2_pix_format_mplane {
>> 	struct v4l2_pix_format			pix_fmt;
>> 	struct v4l2_plane_format		plane_fmt[VIDEO_MAX_PLANES];
>> };
>
>8 planes means that struct v4l2_plane_format can have 20 bytes. That seems
>reasonable. If we make bytesperline a u16 and 'pack' the struct, then we
>have enough reserved fields I think.
>

Good idea, haven't thought of that.

>>
>> b) pass a userspace pointer to a separate array
>>
>> struct v4l2_pix_format_mplane {
>> 	struct v4l2_pix_format			pix_fmt;
>> 	__u32					num_planes;
>> 	/* userspace pointer to an array of size num_planes */
>> 	struct v4l2_plane_format		*plane_fmt;
>> };
>>
>> and then fetch the array separately. The second solution would give us more
>> flexibility for future extensions (if we add a handful of reserved fields
>to the
>> v4l2_plane_format struct).
>
>Due to the complexity of handling userspace pointers I don't think this is
>the
>way to go. In my opinion there is enough spare room in the v4l2_plane_format
>struct.
>

Yes, especially with 16-bit fields.

>>
>> The main discussion point here though was how to select the proper member
>of the
>> fmt union from v4l2_format struct. It is normally being done with the type
>> field. Now, assuming that multiplane pix formats make sense only for
>CAPTURE and
>> OUTPUT types (right?), we would be adding two new v4l2_buf_type members:
>>
>> V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
>> V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE
>>
>> which is not that big of a deal in my opinion after all.
>

Should I take it that you agree to this solution?

>We will also need to add a new flag to struct v4l2_fmtdesc:
>V4L2_FMT_FLAG_MPLANE.
>When enumerating the formats userspace needs to determine whether it is a
>multiplane format or not.
>

Wouldn't fourcc found in that struct be enough? Since we agreed that we'd
like separate fourcc codes for multiplane formats... Drivers and userspace
would have to be aware of them anyway. Or am I missing something?

>It might also be a good idea to take one of the reserved fields and let that
>return the number of planes associated with this format. What do you think?

Interesting idea. Although, since an application would still need to be able
to recognize new fourccs, how this could be used?

>> 2. There are other fields besides bytesperline that some parties are
>interested
>> in having in the plane format struct. Among those we had: sample range
>> (sorry, I am still not sure I remember this one correctly, please correct
>me)
>
>No, that will be handled by new colorspace defines.
>

Ok, thanks for the clarification.

>> and - optionally - memory type-related (more on this further below).
>
>Where 'further below'?
>

Right, sorry about that. I'd originally wanted to cover that topic, but
then I decided that it'd be better to discuss them separately. Forgot
to remove this though.

>>
>> struct v4l2_plane_format {
>> 	__u32			bytesperline;
>> 	/* Anything else? */
>> 	__u32			reserved[?];
>> };
>>
>> Please provide your specific requirements for this struct.
>
>This seems reasonable:
>
>struct v4l2_plane_format {
>	__u16			bytesperline;
>	__u16			reserved[9];
>} __attribute__ ((packed));
>
>

Looks fine to me. I guess nothing else will be put in here for now...

>Regarding the main multi-plane proposal: as we discussed on IRC that should
>perhaps be combined with pre-registration.
>

I've been thinking that maybe it'd be better to agree on a general shape of
this, how to incorporate multiplanes into the API in general, etc., while
leaving enough reserved fields for pre-registration extensions (and other
things).

The interest in this topic seems to have diminished somehow, or rather people
just don't have time for this right now. Moreover, realistically speaking,
memory pools are something that will not happen in the foreseeable future
I'm afraid.
We are afraid that with that, multiplanes would get put off for a long time,
or even indefinitely. And this is a huge showstopper for us, we are simply
unable to post our multimedia drivers without it.

>But thinking about it, you would still need to have a struct v4l2_plane: if
>the
>plane memory is allocated by the kernel, then you still need to get the plane
>info to the application via QUERYBUF. Pre-registration is no help there. So a
>V4L2_MEMORY_MMAP_MPLANE is certainly needed. Whether a
>V4L2_MEMORY_USERPTR_MPLANE
>is needed is less clear: it is likely that in practice you want to
>preregister
>the memory, so there we might want to use a frame memory descriptor thingy
>instead.
>On the other hand, that would make the API asymmetrical, which is not nice.
>

The existence of those memory types is essential for v4l2-ioctl.c code, for
both userptr and mplane. It'd be practically impossible to recognize
multiplanar formats in there without it. It is required for the code to
decide whether it should be copying_from/to_user v4l2_plane structs or not
on QUERYBUF, QBUF and DQBUF (it's similar to ext controls, but they have
their own, separate ioctls).

>Comments? I think I prefer having a symmetrical API, so adding USERPTR_MPLANE
>as
>well. It is probably trivial to do in videobuf2.
>

It is not only trivial, but also makes videobuf simpler. Right now,
qbuf/dqbuf/querybuf code can just use the memory type in the queued struct
to decide what to do. Without it, it'd have to depend on information passed
from driver during format negotiation, i.e. whether the current format is
multiplanar or not. Of course it could be done at buf_setup time (i.e. on
reqbufs), i.e. when drivers tell videobuf how many of how large buffers are
needed and how many planes per buffer. So, for num_planes>1, videobuf could
be assuming that all subsequent qbufs/dqbufs would be of MPLANE type. Still,
this would not allow using multiplane API for 1-plane buffers, which would
become an another inconsistency/lack of symmetry/obscure gotcha. 

>What about mixed mmap and userptr planes?

I see it like this: if you negotiated n-plane buffers, queuing more than
n planes makes all those additional buffers userptr, whatever main memory
type has been agreed on. Do you think it would be sufficient?


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





