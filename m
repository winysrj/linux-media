Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:33210 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755131AbdCJIyP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 03:54:15 -0500
Received: by mail-wr0-f177.google.com with SMTP id u48so60593574wrc.0
        for <linux-media@vger.kernel.org>; Fri, 10 Mar 2017 00:54:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1488491084-17252-9-git-send-email-labbott@redhat.com>
References: <1488491084-17252-1-git-send-email-labbott@redhat.com> <1488491084-17252-9-git-send-email-labbott@redhat.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Fri, 10 Mar 2017 14:23:53 +0530
Message-ID: <CAO_48GEHxuMMwZO71ytaVhRkapMYaAWBWd1gW+ktspnQg=b8Sw@mail.gmail.com>
Subject: Re: [RFC PATCH 08/12] cma: Store a name in the cma structure
To: Laura Abbott <labbott@redhat.com>
Cc: Riley Andrews <riandrews@android.com>,
        =?UTF-8?B?QXJ2ZSBIau+/vW5uZXbvv71n?= <arve@android.com>,
        Rom Lemarchand <romlem@google.com>, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Brian Starkey <brian.starkey@arm.com>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Mark Brown <broonie@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laura,

Thanks for the patch.

On 3 March 2017 at 03:14, Laura Abbott <labbott@redhat.com> wrote:
>
> Frameworks that may want to enumerate CMA heaps (e.g. Ion) will find it
> useful to have an explicit name attached to each region. Store the name
> in each CMA structure.
>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
>  drivers/base/dma-contiguous.c |  5 +++--
>  include/linux/cma.h           |  4 +++-
>  mm/cma.c                      | 11 +++++++++--
>  mm/cma.h                      |  1 +
>  mm/cma_debug.c                |  2 +-
>  5 files changed, 17 insertions(+), 6 deletions(-)
>
<snip>
> +const char *cma_get_name(const struct cma *cma)
> +{
> +       return cma->name ? cma->name : "(undefined)";
> +}
> +
Would it make sense to perhaps have the idx stored as the name,
instead of 'undefined'? That would make sure that the various cma
names are still unique.

>  static unsigned long cma_bitmap_aligned_mask(const struct cma *cma,
>                                              int align_order)
>  {
> @@ -168,6 +173,7 @@ core_initcall(cma_init_reserved_areas);
>   */
>  int __init cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
>                                  unsigned int order_per_bit,
> +                                const char *name,
>                                  struct cma **res_cma)
>  {

Best regards,
Sumit.
