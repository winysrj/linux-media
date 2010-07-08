Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52927 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab0GHJkb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Jul 2010 05:40:31 -0400
Received: from eu_spt2 (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0L58003AYG7HM5@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Jul 2010 10:40:29 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L5800BMFG7HOT@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 08 Jul 2010 10:40:29 +0100 (BST)
Date: Thu, 08 Jul 2010 11:39:18 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [RFC v3] Multi-plane buffer support for V4L2 API
In-reply-to: <201007061736.42346.hverkuil@xs4all.nl>
To: 'Hans Verkuil' <hverkuil@xs4all.nl>
Cc: 'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	kyungmin.park@samsung.com
Message-id: <00b301cb1e81$6f85df50$4e919df0$%osciak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-language: pl
Content-transfer-encoding: 7BIT
References: <002401cb139d$1d5df080$5819d180$%osciak@samsung.com>
 <201007050855.12059.hverkuil@xs4all.nl>
 <005401cb1c3e$b6c5d680$24518380$%osciak@samsung.com>
 <201007061736.42346.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ok, I think I have all the information I need for a v4, which will become
quite a major redesign.
I will repeat in this post what we discussed on IRC about for everybody.

>Hans Verkuil <mailto:hverkuil@xs4all.nl> wrote:
>On Monday 05 July 2010 14:36:38 Pawel Osciak wrote:
>>
>> >We will also need to add a new flag to struct v4l2_fmtdesc:
>> >V4L2_FMT_FLAG_MPLANE.
>> >When enumerating the formats userspace needs to determine whether it is a
>> >multiplane format or not.
>> >
>>
>> Wouldn't fourcc found in that struct be enough? Since we agreed that we'd
>> like separate fourcc codes for multiplane formats... Drivers and userspace
>> would have to be aware of them anyway. Or am I missing something?
>
>How to interpret the data in the planes should indeed be determined by the
>fourcc. But for libraries like libv4l it would be very useful if they get
>enough information from V4L to allocate and configure the plane memory. That
>way
>the capture code can be generic and the planes can be fed to the conversion
>code that can convert it to more common formats.
>
>In order to write generic capture/output code you need to know whether
>multiplanar
>is required and also the number of planes.
>
>With this flag you know that you have to use
>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE.
>And through G_FMT with that stream type you can get hold of the number of
>planes.
>
>> >It might also be a good idea to take one of the reserved fields and let
>that
>> >return the number of planes associated with this format. What do you think?
>
>This is not needed, since you get that already through G_FMT.
>
>> Interesting idea. Although, since an application would still need to be
>able
>> to recognize new fourccs, how this could be used?
>
>To write generic capture/output code. That's actually how all existing apps
>work: the capture code is generic, then the interpretation of the data is
>based on the fourcc.
>

As we discussed on IRC, there is no need for that flag after all, as
applications will be able to use v4l2_buf_type while calling ENUM_FMT anyway.

>This actually leads me to a related topic:
>
>V4L2_BUF_TYPE_VIDEO_CAPTURE is effectively a subset of
>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE.
>Would it be difficult to support V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE as well
>for
>simple single plane formats? It would simplify apps if they can always use
>MPLANE for
>capturing.
>

I don't see any problems with that, should be doable out-of-the-box.

>> >Regarding the main multi-plane proposal: as we discussed on IRC that
>should
>> >perhaps be combined with pre-registration.
>> >
>>
>> I've been thinking that maybe it'd be better to agree on a general shape of
>> this, how to incorporate multiplanes into the API in general, etc., while
>> leaving enough reserved fields for pre-registration extensions (and other
>> things).
>>
>> The interest in this topic seems to have diminished somehow, or rather
>people
>> just don't have time for this right now. Moreover, realistically speaking,
>> memory pools are something that will not happen in the foreseeable future
>> I'm afraid.
>> We are afraid that with that, multiplanes would get put off for a long time,
>> or even indefinitely. And this is a huge showstopper for us, we are simply
>> unable to post our multimedia drivers without it.
>
>I've come to the conclusion that the multiplanar API is needed regardless of
>any preregistration API. So there is no need to wait for that IMHO.
>

Thanks, this is my opinion as well. Incremental changes are better than huge 
all-in-ones.

>> >What about mixed mmap and userptr planes?
>>
>> I see it like this: if you negotiated n-plane buffers, queuing more than
>> n planes makes all those additional buffers userptr, whatever main memory
>> type has been agreed on. Do you think it would be sufficient?
>
>Very good idea. But there needs to be a way to tell the application what the
>minimum number of planes is, and how many extra userptr 'planes' there can
>be. And what the size of those extra planes is.
>
>Theoretically you can have:
>
>- X planes with video data whose size is #lines * bytesperline, using the
>main
>  memory type.
>- Y 'planes' with non-video data with some maximum size, but still containing
>  required information so also using the main memory type.
>- Z optional 'planes' with non-video data with some maximum size which assume
>  userptr as the memory type.
>
>All three X, Y and Z values need to be available to the application. The
>question
>is if 'Y' can ever be non-zero. I can't think of an example right now, but I
>learned the hard way that you should never make assumptions.
>
>All this info can be part of struct v4l2_pix_format_mplane, I think.
>

You are right, it's safer to assume Y can be nonzero. But I don't think it's
a problem though. If we want to use the main memory type for Y planes, it has
to be preallocated anyway. The format becomes an X+Y-plane format, and we
simply set bytesused on a Y plane to 0 if it is unused.

But, as you noticed, we need a way to inform the application about the size
of Y planes. So we will add a sizeimage field to each v4l2_plane_format
struct. 


Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center





