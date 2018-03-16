Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41546 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbeCPH4n (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Mar 2018 03:56:43 -0400
Date: Fri, 16 Mar 2018 08:56:42 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: dri-devel@lists.freedesktop.org, qemu-devel@nongnu.org,
        David Airlie <airlied@linux.ie>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Shuah Khan <shuah@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK"
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v2] Add udmabuf misc device
Message-ID: <20180316075642.GB11982@kroah.com>
References: <20180316074650.5415-1-kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180316074650.5415-1-kraxel@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 16, 2018 at 08:46:49AM +0100, Gerd Hoffmann wrote:
> --- /dev/null
> +++ b/tools/testing/selftests/drivers/dma-buf/udmabuf.c
> @@ -0,0 +1,69 @@
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <malloc.h>

No license text at all?  Come on, I already made one commit in the tree
that touched 11k files, I don't want to have to do it again :)

thanks,

greg k-h
