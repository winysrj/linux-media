Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57233 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab1KYRBr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 12:01:47 -0500
Received: by ggnr5 with SMTP id r5so3658201ggn.19
        for <linux-media@vger.kernel.org>; Fri, 25 Nov 2011 09:01:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201111221138.40499.hverkuil@xs4all.nl>
References: <1321939597-6239-1-git-send-email-pawel@osciak.com>
 <1321939597-6239-3-git-send-email-pawel@osciak.com> <201111221138.40499.hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Fri, 25 Nov 2011 09:01:05 -0800
Message-ID: <CAMm-=zCcEZQBE2Fyf=-wYoi_Q3asr_4sZfwnAX8+9u6nMSP68g@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] vb2: add support for app_offset field of the
 v4l2_plane struct
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, mingchen@quicinc.com,
	Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,
Thanks for comments.

On Tue, Nov 22, 2011 at 02:38, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Pawel!
>
> Thanks for doing this work, but I have a few comments...
>
> On Tuesday, November 22, 2011 06:26:37 Pawel Osciak wrote:
>> The app_offset can only be set by userspace and will be passed by vb2 to
>> the driver.
(..,)
>
> I'd like to see this implemented in vivi and preferably one other driver.
>

Yes, I just wanted to show how the V4L2 API would change and make sure
people agreed before starting to implement in drivers. Looks like no
one is questioning it.

> What also needs to be clarified is how this affects queue_setup (should the
> sizes include the app_offset or not?) and e.g. vb2_plane_size (again, is the
> size with or without app_offset?).
>
> Should app_offset handling be enforced (i.e. should all vb2 drivers support
> it?) or should it be optional? If optional, then app_offset should be set to
> 0 somehow.
>

There are several design questions:
1. Enforcing handling of app_offset.
I would prefer enforcing it. If we don't, we'll need some kind of new
capability if forcing to 0 or would have to otherwise communicate it
(zero it out in kernel when setting the format maybe). I'd like to try
enforcing while hiding it in vb2 layer, so the drivers would not have
to be concerned about that. Note also that this applies only to
multiplanar drivers.
2. Allocation - additional memory must be allocated for mmap and one
problem is that the hardware will usually need buffer_addr +
app_offset to be page-aligned, so we'd be "wasting" up to a page per
buffer for this. Not a big deal probably though.
3. Handling in vb2
For mmap, vb2 (i.e. allocators) would have to allocate this memory in
addition to the required buffer size, provided by the driver. I hope
it could be made transparent to drivers by returning addresses to
buffers after app_offset to them only. So only the allocator would
need to be aware of both, but it's internal to vb2 as well.
4. queue_setup
I would like to make it oblivious to app_offset and keep and handle it
only in vb2 and allocators. Need to see how it works out by
implementing though.
5. And other things most probably. I will go ahead and start
implementing to see what less obvious subtleties I might be missing.

> This code in __qbuf_userptr should probably also be modified as this
> currently does not take app_offset into account.
>
>                /* Check if the provided plane buffer is large enough */
>                if (planes[plane].length < q->plane_sizes[plane]) {
>                        ret = -EINVAL;
>                        goto err;
>                }
>
>

As for userptr, at first I thought that the correct behavior would be
to ignore that app memory entirely, i.e. make vb2 give pointers after
app_offset, but this won't fly with for more advanced allocators that
may need the app memory as well. Will rethink.

> I think there are some subtleties that we don't know about yet, so implementing
> this in a real driver would hopefully bring those subtleties out in the open.
>

Yes, I will implement it in vivi as a pilot now and add support in all
drivers once we have everything sorted out.

-- 
Best regards,
Pawel Osciak
