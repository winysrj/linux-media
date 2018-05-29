Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:36265 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933697AbeE2M3o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 08:29:44 -0400
Received: by mail-io0-f194.google.com with SMTP id d73-v6so17343970iog.3
        for <linux-media@vger.kernel.org>; Tue, 29 May 2018 05:29:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180529104855.vvrfdtbgrsqj27ga@sirius.home.kraxel.org>
References: <20180525140808.12714-1-kraxel@redhat.com> <20180529082327.GF3438@phenom.ffwll.local>
 <20180529084406.GI3438@phenom.ffwll.local> <20180529104855.vvrfdtbgrsqj27ga@sirius.home.kraxel.org>
From: Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Tue, 29 May 2018 14:29:43 +0200
Message-ID: <CAKMK7uEUrgKkmPTtku5otN++H3SW7xLaGEn0S9nGEpGAA_Uy+A@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH v3] Add udmabuf misc device
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Shuah Khan <shuah@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK"
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 29, 2018 at 12:48 PM, Gerd Hoffmann <kraxel@redhat.com> wrote:
>   Hi,
>
>> > > qemu test branch:
>> > >   https://git.kraxel.org/cgit/qemu/log/?h=sirius/udmabuf
>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
>> > > + if (!shmem_mapping(file_inode(ubuf->filp)->i_mapping))
>> > > +         goto err_free_ubuf;
>>
>> Can/should we test here that the memfd has a locked down size here?
>
> Makes sense.  Suggested way to check that?  unstatic memfd_get_seals()
> function (mm/shmem.c)?  Or is there some better way?
>
> Also which seals should we require?  Is F_SEAL_SHRINK enough?

Yes I think that's enough.

Hm ... I think we also need to prevent the F_SEAL_WRITE, because
there's no way to stop dma from tampering with the buffer once it's a
dma-buf. Otherwise evil userspace could create a memfd, F_SEAL_SHRINK
it, make a dma-buf out of it, F_SEAL_WRITE it, hand it to some
unsuspecting priviledged service and then pull it over the table with
a few dma-buf writes.

>> On that: Link to userspace patches/git tree using this would be nice.
>
> See above.

Ow, I was blind :-)

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
