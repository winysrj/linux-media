Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:55166 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758276Ab3DHG2D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Apr 2013 02:28:03 -0400
Received: by mail-ob0-f182.google.com with SMTP id ef5so5356361obb.41
        for <linux-media@vger.kernel.org>; Sun, 07 Apr 2013 23:28:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365056913-25772-1-git-send-email-sumit.semwal@linaro.org>
References: <1365056913-25772-1-git-send-email-sumit.semwal@linaro.org>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Mon, 8 Apr 2013 11:57:41 +0530
Message-ID: <CAO_48GEz037DhpZzQe-Ek2ob=bxX=QXdrv2onw_2zmt7B7BqGA@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] dma-buf: Add support for debugfs
To: Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	linux-media@vger.kernel.org,
	DRI mailing list <dri-devel@lists.freedesktop.org>
Cc: Patch Tracking <patches@linaro.org>,
	linaro-kernel@lists.linaro.org,
	Sumit Semwal <sumit.semwal@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,


On 4 April 2013 11:58, Sumit Semwal <sumit.semwal@linaro.org> wrote:
> The patch series adds a much-missed support for debugfs to dma-buf framework.
>
> Based on the feedback received on v1 of this patch series, support is also
> added to allow exporters to provide name-strings that will prove useful
> while debugging.

Since there're no more comments, I'll add this to my for-next, to
queue it up for 3.10.

Best regards,
~Sumit.
>
> Some more magic can be added for more advanced debugging, but we'll leave that
> for the time being.
>
> Best regards,
> ~Sumit.
>
> ---
> changes since v2: (based on review comments from Laurent Pinchart)
>  - reordered functions to avoid forward declaration
>  - added __exitcall for dma_buf_deinit()
>
> changes since v1:
>  - added patch to replace dma_buf_export() with dma_buf_export_named(), per
>     suggestion from Daniel Vetter.
>  - fixes on init and warnings as reported and corrected by Dave Airlie.
>  - added locking while walking attachment list - reported by Daniel Vetter.
>
> Sumit Semwal (2):
>   dma-buf: replace dma_buf_export() with dma_buf_export_named()
>   dma-buf: Add debugfs support
>
>  Documentation/dma-buf-sharing.txt |   13 ++-
>  drivers/base/dma-buf.c            |  170 ++++++++++++++++++++++++++++++++++++-
>  include/linux/dma-buf.h           |   16 +++-
>  3 files changed, 190 insertions(+), 9 deletions(-)
>
> --
> 1.7.10.4
>



--
Thanks and regards,

Sumit Semwal

Linaro Kernel Engineer - Graphics working group

Linaro.org │ Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
