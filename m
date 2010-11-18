Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63410 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759022Ab0KRPwO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Nov 2010 10:52:14 -0500
Received: by wwa36 with SMTP id 36so3485005wwa.1
        for <linux-media@vger.kernel.org>; Thu, 18 Nov 2010 07:52:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201011181017.39379.hverkuil@xs4all.nl>
References: <1289983174-2835-1-git-send-email-m.szyprowski@samsung.com>
 <1289983174-2835-2-git-send-email-m.szyprowski@samsung.com> <201011181017.39379.hverkuil@xs4all.nl>
From: Pawel Osciak <pawel@osciak.com>
Date: Thu, 18 Nov 2010 07:51:46 -0800
Message-ID: <AANLkTinEoxms1wpuOLg6C-w-rKDc-rd1p3Pzcb1W_y-S@mail.gmail.com>
Subject: Re: [PATCH 1/7] v4l: add videobuf2 Video for Linux 2 driver framework
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Thu, Nov 18, 2010 at 01:17, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Marek!
>
> Some comments below...
>
> On Wednesday, November 17, 2010 09:39:28 Marek Szyprowski wrote:
>> From: Pawel Osciak <p.osciak@samsung.com>
>> +/**
>> + * struct vb2_mem_ops - memory handling/memory allocator operations
>> + * @alloc:   allocate video memory and, optionally, allocator private data,
>> + *           return NULL on failure or a pointer to allocator private,
>> + *           per-buffer data on success, NULL on failure; the returned
>> + *           private structure will then be passed as buf_priv argument
>> + *           to other ops in this structure
>> + * @put:     inform the allocator that the buffer will no longer be used;
>> + *           usually will result in the allocator freeing the buffer (if
>> + *           no other users of this buffer are present); the buf_priv
>> + *           argument is the allocator private per-buffer structure
>> + *           previously returned from the alloc callback
>> + * @get_userptr: acquire userspace memory for a hardware operation; used for
>> + *            USERPTR memory types; vaddr is the address passed to the
>> + *            videobuf layer when queuing a video buffer of USERPTR type;
>> + *            should return an allocator private per-buffer structure
>> + *            associated with the buffer on success, NULL on failure;
>> + *            the returned private structure will then be passed as buf_priv
>> + *            argument to other ops in this structure
>> + * @put_userptr: inform the allocator that a USERPTR buffer will no longer
>> + *            be used
>
> 'get' and 'put' imply reference counting. However, I don't believe that's the
> case for USERPTR. If I am right, then I would like to see different names for
> these callbacks.

Actually, they are intended for reference counting. The idea is to
allow using the same memory for creating pipelines. Please take a look
at the second patch in the series, generic implementations of get()
and put() are in there.


-- 
Best regards,
Pawel Osciak
