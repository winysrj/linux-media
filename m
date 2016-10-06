Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:34762 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964800AbcJFQyu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 6 Oct 2016 12:54:50 -0400
MIME-Version: 1.0
In-Reply-To: <CA+M3ks5vZyrxzF84t2fX0CK33LWq2A-uM=6rDFru-AO0mAyKQA@mail.gmail.com>
References: <1475581644-10600-1-git-send-email-benjamin.gaignard@linaro.org>
 <20161005131959.GE20761@phenom.ffwll.local> <CA+M3ks5vZyrxzF84t2fX0CK33LWq2A-uM=6rDFru-AO0mAyKQA@mail.gmail.com>
From: Rob Clark <robdclark@gmail.com>
Date: Thu, 6 Oct 2016 12:54:48 -0400
Message-ID: <CAF6AEGto6iuNSG3Q3sBk1-wedhkPaJxM=Ru=ZcwfB63GwH7mhw@mail.gmail.com>
Subject: Re: [PATCH v10 0/3] Secure Memory Allocation Framework
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Cc Ma <cc.ma@mediatek.com>,
        Joakim Bech <joakim.bech@linaro.org>,
        Burt Lien <burt.lien@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
        Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

so there is discussion about a "central userspace allocator" (ie. more
like a common userspace API that could be implemented on top of
various devices/APIs) to decide in a generic way which device could
allocate.

  https://github.com/cubanismo/allocator

and I wrote up some rough thoughts/proposal about how the usage might
look.. just rough, so don't try to compile it or anything, and not
consensus yet so it will probably change/evolve..

  https://github.com/robclark/allocator/blob/master/USAGE.md

I think ion could be just another device to share buffers with, which
happens to not impose any specific constraints.  How "liballoc-ion.so"
backend figures out how to map constraints/usage to a heap is a bit
hand-wavey at the moment.

BR,
-R

On Wed, Oct 5, 2016 at 9:40 AM, Benjamin Gaignard
<benjamin.gaignard@linaro.org> wrote:
> because with ion it is up to userland to decide which heap to use
> and until now userland doesn't have any way to get device constraints...
>
> I will prefer let a central allocator (in kernel) decide from the
> attached devices
> which allocator is the best. It is what I have implemented in smaf.
>
> Benjamin
>
>
> 2016-10-05 15:19 GMT+02:00 Daniel Vetter <daniel@ffwll.ch>:
>> On Tue, Oct 04, 2016 at 01:47:21PM +0200, Benjamin Gaignard wrote:
>>> version 10 changes:
>>>  - rebased on kernel 4.8 tag
>>>  - minor typo fix
>>>
>>> version 9 changes:
>>>  - rebased on 4.8-rc5
>>>  - struct dma_attrs doesn't exist anymore so update CMA allocator
>>>    to compile with new dma_*_attr functions
>>>  - add example SMAF use case in cover letter
>>>
>>> version 8 changes:
>>>  - rework of the structures used within ioctl
>>>    by adding a version field and padding to be futur proof
>>>  - rename fake secure moduel to test secure module
>>>  - fix the various remarks done on the previous patcheset
>>>
>>> version 7 changes:
>>>  - rebased on kernel 4.6-rc7
>>>  - simplify secure module API
>>>  - add vma ops to be able to detect mmap/munmap calls
>>>  - add ioctl to get number and allocator names
>>>  - update libsmaf with adding tests
>>>    https://git.linaro.org/people/benjamin.gaignard/libsmaf.git
>>>  - add debug log in fake secure module
>>>
>>> version 6 changes:
>>>  - rebased on kernel 4.5-rc4
>>>  - fix mmapping bug while requested allocation size isn't a a multiple =
of
>>>    PAGE_SIZE (add a test for this in libsmaf)
>>>
>>> version 5 changes:
>>>  - rebased on kernel 4.3-rc6
>>>  - rework locking schema and make handle status use an atomic_t
>>>  - add a fake secure module to allow performing tests without trusted
>>>    environment
>>>
>>> version 4 changes:
>>>  - rebased on kernel 4.3-rc3
>>>  - fix missing EXPORT_SYMBOL for smaf_create_handle()
>>>
>>> version 3 changes:
>>>  - Remove ioctl for allocator selection instead provide the name of
>>>    the targeted allocator with allocation request.
>>>    Selecting allocator from userland isn't the prefered way of working
>>>    but is needed when the first user of the buffer is a software compon=
ent.
>>>  - Fix issues in case of error while creating smaf handle.
>>>  - Fix module license.
>>>  - Update libsmaf and tests to care of the SMAF API evolution
>>>    https://git.linaro.org/people/benjamin.gaignard/libsmaf.git
>>>
>>> version 2 changes:
>>>  - Add one ioctl to allow allocator selection from userspace.
>>>    This is required for the uses case where the first user of
>>>    the buffer is a software IP which can't perform dma_buf attachement.
>>>  - Add name and ranking to allocator structure to be able to sort them.
>>>  - Create a tiny library to test SMAF:
>>>    https://git.linaro.org/people/benjamin.gaignard/libsmaf.git
>>>  - Fix one issue when try to secure buffer without secure module regist=
ered
>>>
>>> SMAF aim to solve two problems: allocating memory that fit with hardwar=
e IPs
>>> constraints and secure those data from bus point of view.
>>>
>>> One example of SMAF usage is camera preview: on SoC you may use either =
an USB
>>> webcam or the built-in camera interface and the frames could be send di=
rectly
>>> to the dipslay Ip or handle by GPU.
>>> Most of USB interfaces and GPU have mmu but almost all built-in camera
>>> interace and display Ips don't have mmu so when selecting how allocate
>>> buffer you need to be aware of each devices constraints (contiguous mem=
roy,
>>> stride, boundary, alignment ...).
>>> ION has solve this problem by let userland decide which allocator (heap=
) to use
>>> but this require to adapt userland for each platform and sometime for e=
ach
>>> use case.
>>>
>>> To be sure to select the best allocation method for devices SMAF implem=
ent
>>> deferred allocation mechanism: memory allocation is only done when the =
first
>>> device effectively required it.
>>> Allocator modules have to implement a match() to let SMAF know if they =
are
>>> compatibles with devices needs.
>>> This patch set provide an example of allocator module which use
>>> dma_{alloc/free/mmap}_attrs() and check if at least one device have
>>> coherent_dma_mask set to DMA_BIT_MASK(32) in match function.
>>>
>>> In the same camera preview use case, SMAF allow to protect the data fro=
m being
>>> read by unauthorized IPs (i.e. a malware to dump camera stream).
>>> Until now I have only see access rights protection at process/thread le=
vel
>>> (PKeys/MPK) or on file (SELinux) but nothing allow to drive data bus fi=
rewalls.
>>> SMAF propose an interface to control and implement those firewalls.
>>> Like IOMMU, firewalls IPs can help to protect memory from malicious/fau=
lty devices
>>> that are attempting DMA attacks.
>>>
>>> Secure modules are responsibles of granting and revoking devices access=
 rights
>>> on the memory. Secure module is also called to check if CPU map memory =
into
>>> kernel and user address spaces.
>>> An example of secure module implementation can be found here:
>>> http://git.linaro.org/people/benjamin.gaignard/optee-sdp.git
>>> This code isn't yet part of the patch set because it depends on generic=
 TEE
>>> which is still under discussion (https://lwn.net/Articles/644646/)
>>>
>>> For allocation part of SMAF code I get inspirated by Sumit Semwal work =
about
>>> constraint aware allocator.
>>
>> semi-random review comment, and a bit late: Why not implement smaf as a
>> new heap in ion? I think consensus is pretty much that we'll be stuck wi=
th
>> ion forever, and I think it's better to have 1 central buffer allocater
>> than lots of them ...
>> -Daniel
>>
>>>
>>> Benjamin Gaignard (3):
>>>   create SMAF module
>>>   SMAF: add CMA allocator
>>>   SMAF: add test secure module
>>>
>>>  drivers/Kconfig                |   2 +
>>>  drivers/Makefile               |   1 +
>>>  drivers/smaf/Kconfig           |  17 +
>>>  drivers/smaf/Makefile          |   3 +
>>>  drivers/smaf/smaf-cma.c        | 186 ++++++++++
>>>  drivers/smaf/smaf-core.c       | 818 +++++++++++++++++++++++++++++++++=
++++++++
>>>  drivers/smaf/smaf-testsecure.c |  90 +++++
>>>  include/linux/smaf-allocator.h |  45 +++
>>>  include/linux/smaf-secure.h    |  65 ++++
>>>  include/uapi/linux/smaf.h      |  85 +++++
>>>  10 files changed, 1312 insertions(+)
>>>  create mode 100644 drivers/smaf/Kconfig
>>>  create mode 100644 drivers/smaf/Makefile
>>>  create mode 100644 drivers/smaf/smaf-cma.c
>>>  create mode 100644 drivers/smaf/smaf-core.c
>>>  create mode 100644 drivers/smaf/smaf-testsecure.c
>>>  create mode 100644 include/linux/smaf-allocator.h
>>>  create mode 100644 include/linux/smaf-secure.h
>>>  create mode 100644 include/uapi/linux/smaf.h
>>>
>>> --
>>> 1.9.1
>>>
>>> _______________________________________________
>>> dri-devel mailing list
>>> dri-devel@lists.freedesktop.org
>>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
>>
>> --
>> Daniel Vetter
>> Software Engineer, Intel Corporation
>> http://blog.ffwll.ch
>
>
>
> --
> Benjamin Gaignard
>
> Graphic Study Group
>
> Linaro.org =E2=94=82 Open source software for ARM SoCs
>
> Follow Linaro: Facebook | Twitter | Blog
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel
