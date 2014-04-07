Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yh0-f54.google.com ([209.85.213.54]:38619 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaDGK2m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 06:28:42 -0400
Received: by mail-yh0-f54.google.com with SMTP id f73so5541930yha.41
        for <linux-media@vger.kernel.org>; Mon, 07 Apr 2014 03:28:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BAY176-W225B62F958527124202669A9680@phx.gbl>
References: <BAY176-W225B62F958527124202669A9680@phx.gbl>
From: Pawel Osciak <pawel@osciak.com>
Date: Mon, 7 Apr 2014 19:27:56 +0900
Message-ID: <CAMm-=zDKUoFN7OiGpL3c=7KCkmYNhiyns20t8H7Pz_=qgaeHMw@mail.gmail.com>
Subject: Re: videobuf2-vmalloc suspect for corrupted data
To: Divneil Wadhawan <divneil@outlook.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Divneil,

On Mon, Apr 7, 2014 at 6:56 PM, Divneil Wadhawan <divneil@outlook.com> wrote:
> Hi,
>
> I have a V4L2 capture driver accepting a malloc'ed buffer.
> The driver is using vb2_vmalloc_memops (../drivers/media/v4l2-core/videobuf2-vmalloc.c) for user-space to kvaddr translation.
> Randomly, corrupted data is received by user-app.
>
> So, the question is regarding the handling of get_userptr, put_userptr by v4l2-core:
>
> const struct vb2_mem_ops vb2_vmalloc_memops = {
>          ........
>          .get_userptr    = vb2_vmalloc_get_userptr, (get_user_pages() and vm_map_ram())
>          .put_userptr    = vb2_vmalloc_put_userptr, (set_page_dirty_lock() and put_page())
>           .....
> };
>
> The driver prepares for the transaction by virtue of v4l2-core calling get_userptr (QBUF)
> After data is filled, driver puts on a done list (DQBUF)
>
> We never mark the pages as dirty (or put_userptr) after a transaction is complete.
> Here, in v4l2 core (videobuf2-core.c) , we conditionally put_userptr - when a QBUF with a different userptr on same index, or releasing buffers.
>
> Is it correct? Probably seems to be the reason for corrupted data.

This is an optimization and requires the mapping of userspace buffer
to v4l2_buffer index to not change.
Is it possible that your userspace is not always queuing the same
userptr memory areas with the same v4l2_buffer index values?
In other words, if you have 2 buffers in use, under userspace mapping
at addr1 and addr2, if you queue addr1 with index=0 and addr2 with
index=1 initially,
you should always keep queuing addr1 with index=0 and never 1, etc.

Also, what architecture are you running this on?

> Regards,
> Divneil                                           --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Best regards,
Pawel Osciak
