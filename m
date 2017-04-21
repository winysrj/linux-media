Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:36800 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1041430AbdDUQkr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 21 Apr 2017 12:40:47 -0400
Received: by mail-wr0-f174.google.com with SMTP id c55so58126733wrc.3
        for <linux-media@vger.kernel.org>; Fri, 21 Apr 2017 09:40:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1492540034-5466-1-git-send-email-labbott@redhat.com>
References: <1492540034-5466-1-git-send-email-labbott@redhat.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Fri, 21 Apr 2017 21:01:03 +0530
Message-ID: <CAO_48GGoyD++0GgRbP8HXXDwEX8cwNvWRh+61WZg03vhEetCPQ@mail.gmail.com>
Subject: Re: [PATCHv4 00/12] Ion cleanup in preparation for moving out of staging
To: Laura Abbott <labbott@redhat.com>
Cc: Riley Andrews <riandrews@android.com>,
        =?UTF-8?B?QXJ2ZSBIau+/vW5uZXbvv71n?= <arve@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rom Lemarchand <romlem@google.com>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laura,

Thanks much for this series!

On 18 April 2017 at 23:57, Laura Abbott <labbott@redhat.com> wrote:
> Hi,
>
> This is v4 of the series to cleanup to Ion. Greg took some of the patches
> that weren't CMA related already. There was a minor bisectability problem
> with the CMA APIs so this is a new version to address that. I also
> addressed some minor comments on the patch to collapse header files.

For the series, please feel free to apply my
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>

>
> Thanks,
> Laura
>
> Laura Abbott (12):
>   cma: Store a name in the cma structure
>   cma: Introduce cma_for_each_area
>   staging: android: ion: Use CMA APIs directly
>   staging: android: ion: Stop butchering the DMA address
>   staging: android: ion: Break the ABI in the name of forward progress
>   staging: android: ion: Get rid of ion_phys_addr_t
>   staging: android: ion: Collapse internal header files
>   staging: android: ion: Rework heap registration/enumeration
>   staging: android: ion: Drop ion_map_kernel interface
>   staging: android: ion: Remove ion_handle and ion_client
>   staging: android: ion: Set query return value
>   staging/android: Update Ion TODO list
>
>  arch/powerpc/kvm/book3s_hv_builtin.c            |   3 +-
>  drivers/base/dma-contiguous.c                   |   5 +-
>  drivers/staging/android/TODO                    |  21 +-
>  drivers/staging/android/ion/Kconfig             |  32 +
>  drivers/staging/android/ion/Makefile            |  11 +-
>  drivers/staging/android/ion/compat_ion.c        | 152 -----
>  drivers/staging/android/ion/compat_ion.h        |  29 -
>  drivers/staging/android/ion/ion-ioctl.c         |  55 +-
>  drivers/staging/android/ion/ion.c               | 812 ++----------------=
------
>  drivers/staging/android/ion/ion.h               | 386 ++++++++---
>  drivers/staging/android/ion/ion_carveout_heap.c |  21 +-
>  drivers/staging/android/ion/ion_chunk_heap.c    |  16 +-
>  drivers/staging/android/ion/ion_cma_heap.c      | 120 ++--
>  drivers/staging/android/ion/ion_heap.c          |  68 --
>  drivers/staging/android/ion/ion_page_pool.c     |   3 +-
>  drivers/staging/android/ion/ion_priv.h          | 453 -------------
>  drivers/staging/android/ion/ion_system_heap.c   |  39 +-
>  drivers/staging/android/uapi/ion.h              |  36 +-
>  include/linux/cma.h                             |   6 +-
>  mm/cma.c                                        |  31 +-
>  mm/cma.h                                        |   1 +
>  mm/cma_debug.c                                  |   2 +-
>  22 files changed, 524 insertions(+), 1778 deletions(-)
>  delete mode 100644 drivers/staging/android/ion/compat_ion.c
>  delete mode 100644 drivers/staging/android/ion/compat_ion.h
>  delete mode 100644 drivers/staging/android/ion/ion_priv.h
>
> --
> 2.7.4
>



--=20
Thanks and regards,

Sumit Semwal
Linaro Mobile Group - Kernel Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
