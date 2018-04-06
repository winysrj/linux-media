Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:35212 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751329AbeDFJdJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 05:33:09 -0400
Date: Fri, 6 Apr 2018 11:33:07 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
To: christian.koenig@amd.com
Cc: dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        David Airlie <airlied@linux.ie>,
        open list <linux-kernel@vger.kernel.org>,
        qemu-devel@nongnu.org,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK"
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2] Add udmabuf misc device
Message-ID: <20180406093307.s7wkhpmddd5d4r7a@sirius.home.kraxel.org>
References: <20180316074650.5415-1-kraxel@redhat.com>
 <7547e99b-0e3c-264e-e52b-40ad5d52b49a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7547e99b-0e3c-264e-e52b-40ad5d52b49a@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hi,

> The pages backing a DMA-buf are not allowed to move (at least not without a
> patch set I'm currently working on), but for certain MM operations to work
> correctly you must be able to modify the page tables entries and move the
> pages backing them around.
> 
> For example try to use fork() with some copy on write pages with this
> approach. You will find that you have only two options to correctly handle
> this.

The fork() issue should go away with shared memory pages (no cow).
I guess this is the reason why vgem is internally backed by shmem.

Hmm.  So I could try to limit the udmabuf driver to shmem too (i.e.
have the ioctl take a shmem filehandle and offset instead of a virtual
address).

But maybe it is better then to just extend vgem, i.e. add support to
create gem objects from existing shmem.

Comments?

cheers,
  Gerd
