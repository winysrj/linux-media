Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:38851 "EHLO
	mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbcCUHf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Mar 2016 03:35:27 -0400
Received: by mail-wm0-f45.google.com with SMTP id l68so110468791wml.1
        for <linux-media@vger.kernel.org>; Mon, 21 Mar 2016 00:35:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1458545443-3302-1-git-send-email-daniel.vetter@ffwll.ch>
References: <CAO_48GGT48RZaLjg9C+51JyPKzYkkDCFCTrMgfUB+PxQyV8d+Q@mail.gmail.com>
 <1458545443-3302-1-git-send-email-daniel.vetter@ffwll.ch>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Mon, 21 Mar 2016 13:05:06 +0530
Message-ID: <CAO_48GHemzZqAtcwupr_hugn23gQW2D1wuW8jdEOvsH6n=_3cA@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: Update docs for SYNC ioctl
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: DRI Development <dri-devel@lists.freedesktop.org>,
	Chris Wilson <chris@chris-wilson.co.uk>,
	Tiago Vignatti <tiago.vignatti@intel.com>,
	=?UTF-8?Q?St=C3=A9phane_Marchesin?= <marcheu@chromium.org>,
	David Herrmann <dh.herrmann@gmail.com>,
	Daniel Vetter <daniel.vetter@intel.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
	intel-gfx@lists.freedesktop.org, devel@driverdev.osuosl.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 21 March 2016 at 13:00, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
> Just a bit of wording polish plus mentioning that it can fail and must
> be restarted.
>
> Requested by Sumit.
>
> Cc: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Tiago Vignatti <tiago.vignatti@intel.com>
> Cc: Stéphane Marchesin <marcheu@chromium.org>
> Cc: David Herrmann <dh.herrmann@gmail.com>
> Cc: Sumit Semwal <sumit.semwal@linaro.org>
> Cc: Daniel Vetter <daniel.vetter@intel.com>
> CC: linux-media@vger.kernel.org
> Cc: dri-devel@lists.freedesktop.org
> Cc: linaro-mm-sig@lists.linaro.org
> Cc: intel-gfx@lists.freedesktop.org
> Cc: devel@driverdev.osuosl.org
> Signed-off-by: Daniel Vetter <daniel.vetter@intel.com>
Acked-by: Sumit Semwal <sumit.semwal@linaro.org>

> ---
>  Documentation/dma-buf-sharing.txt | 11 ++++++-----
>  drivers/dma-buf/dma-buf.c         |  2 +-
>  2 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
> index 32ac32e773e1..5c4e3e586ec8 100644
> --- a/Documentation/dma-buf-sharing.txt
> +++ b/Documentation/dma-buf-sharing.txt
> @@ -352,7 +352,8 @@ Being able to mmap an export dma-buf buffer object has 2 main use-cases:
>
>     No special interfaces, userspace simply calls mmap on the dma-buf fd, making
>     sure that the cache synchronization ioctl (DMA_BUF_IOCTL_SYNC) is *always*
> -   used when the access happens. This is discussed next paragraphs.
> +   used when the access happens. Note that DMA_BUF_IOCTL_SYNC can fail with
> +   -EGAIN or -EINTR, in which case it must be restarted.
>
>     Some systems might need some sort of cache coherency management e.g. when
>     CPU and GPU domains are being accessed through dma-buf at the same time. To
> @@ -366,10 +367,10 @@ Being able to mmap an export dma-buf buffer object has 2 main use-cases:
>         want (with the new data being consumed by the GPU or say scanout device)
>       - munmap once you don't need the buffer any more
>
> -    Therefore, for correctness and optimal performance, systems with the memory
> -    cache shared by the GPU and CPU i.e. the "coherent" and also the
> -    "incoherent" are always required to use SYNC_START and SYNC_END before and
> -    after, respectively, when accessing the mapped address.
> +    For correctness and optimal performance, it is always required to use
> +    SYNC_START and SYNC_END before and after, respectively, when accessing the
> +    mapped address. Userspace cannot on coherent access, even when there are
> +    systems where it just works without calling these ioctls.
>
>  2. Supporting existing mmap interfaces in importers
>
> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> index 774a60f4309a..4a2c07ee6677 100644
> --- a/drivers/dma-buf/dma-buf.c
> +++ b/drivers/dma-buf/dma-buf.c
> @@ -612,7 +612,7 @@ EXPORT_SYMBOL_GPL(dma_buf_begin_cpu_access);
>   * @dmabuf:    [in]    buffer to complete cpu access for.
>   * @direction: [in]    length of range for cpu access.
>   *
> - * This call must always succeed.
> + * Can return negative error values, returns 0 on success.
>   */
>  int dma_buf_end_cpu_access(struct dma_buf *dmabuf,
>                            enum dma_data_direction direction)
> --
> 2.8.0.rc3
>

Best regards,
Sumit.
