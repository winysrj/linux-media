Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37761 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbcHQDGw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2016 23:06:52 -0400
Received: by mail-wm0-f46.google.com with SMTP id i5so205318471wmg.0
        for <linux-media@vger.kernel.org>; Tue, 16 Aug 2016 20:05:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <224865a5-947d-9a28-c60a-18fa86bc9329@infradead.org>
References: <224865a5-947d-9a28-c60a-18fa86bc9329@infradead.org>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Wed, 17 Aug 2016 08:35:25 +0530
Message-ID: <CAO_48GEssmiZnPTDNeCgmCEk0VA=+Fne8vpWhOSOe9=1o=9T4w@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: fix kernel-doc warning and typos
To: Randy Dunlap <rdunlap@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy,

On 17 August 2016 at 05:01, Randy Dunlap <rdunlap@infradead.org> wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> Fix dma-buf kernel-doc warning and 2 minor typos in
> fence_array_create().
>
Thanks for your patch, I will queue it up!
> Fixes this warning:
> ..//drivers/dma-buf/fence-array.c:124: warning: No description found for parameter 'signal_on_any'
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc:     Sumit Semwal <sumit.semwal@linaro.org>
> Cc:     linux-media@vger.kernel.org
> Cc:     dri-devel@lists.freedesktop.org
> Cc:     linaro-mm-sig@lists.linaro.org
> ---
>  drivers/dma-buf/fence-array.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> --- lnx-48-rc2.orig/drivers/dma-buf/fence-array.c
> +++ lnx-48-rc2/drivers/dma-buf/fence-array.c
> @@ -106,14 +106,14 @@ const struct fence_ops fence_array_ops =
>   * @fences:            [in]    array containing the fences
>   * @context:           [in]    fence context to use
>   * @seqno:             [in]    sequence number to use
> - * @signal_on_any      [in]    signal on any fence in the array
> + * @signal_on_any:     [in]    signal on any fence in the array
>   *
>   * Allocate a fence_array object and initialize the base fence with fence_init().
>   * In case of error it returns NULL.
>   *
> - * The caller should allocte the fences array with num_fences size
> + * The caller should allocate the fences array with num_fences size
>   * and fill it with the fences it wants to add to the object. Ownership of this
> - * array is take and fence_put() is used on each fence on release.
> + * array is taken and fence_put() is used on each fence on release.
>   *
>   * If @signal_on_any is true the fence array signals if any fence in the array
>   * signals, otherwise it signals when all fences in the array signal.

Best,
Sumit.
