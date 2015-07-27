Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36594 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527AbbG0KMX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jul 2015 06:12:23 -0400
Received: by lbbqi7 with SMTP id qi7so49965138lbb.3
        for <linux-media@vger.kernel.org>; Mon, 27 Jul 2015 03:12:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1436531290-23191-1-git-send-email-benjamin.gaignard@linaro.org>
References: <1436531290-23191-1-git-send-email-benjamin.gaignard@linaro.org>
Date: Mon, 27 Jul 2015 12:12:21 +0200
Message-ID: <CA+M3ks7X++to23mXjRaB_wUJUo0TDLFh2hMbziEGeMDkVBx-7w@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] RFC: Secure Memory Allocation Framework
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Rob Clark <robdclark@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Tom Cooksey <tom.cooksey@arm.com>,
	Daniel Stone <daniel.stone@collabora.com>
Cc: Tom Gall <tom.gall@linaro.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This thread doesn't get any feedback...

What would be great is to know if this framework proposal fir with
your platform needs.

Maybe I haven't copy the good mailing lists so if you think there is
better ones do not hesitate to forward.

Regards,
Benjamin


2015-07-10 14:28 GMT+02:00 Benjamin Gaignard <benjamin.gaignard@linaro.org>:
> version 3 changes:
>  - Remove ioctl for allocator selection instead provide the name of
>    the targeted allocator with allocation request.
>    Selecting allocator from userland isn't the prefered way of working
>    but is needed when the first user of the buffer is a software component.
>  - Fix issues in case of error while creating smaf handle.
>  - Fix module license.
>  - Update libsmaf and tests to care of the SMAF API evolution
>    https://git.linaro.org/people/benjamin.gaignard/libsmaf.git
>
> version 2 changes:
>  - Add one ioctl to allow allocator selection from userspace.
>    This is required for the uses case where the first user of
>    the buffer is a software IP which can't perform dma_buf attachement.
>  - Add name and ranking to allocator structure to be able to sort them.
>  - Create a tiny library to test SMAF:
>    https://git.linaro.org/people/benjamin.gaignard/libsmaf.git
>  - Fix one issue when try to secure buffer without secure module registered
>
> The outcome of the previous RFC about how do secure data path was the need
> of a secure memory allocator (https://lkml.org/lkml/2015/5/5/551)
>
> SMAF goal is to provide a framework that allow allocating and securing
> memory by using dma_buf. Each platform have it own way to perform those two
> features so SMAF design allow to register helper modules to perform them.
>
> To be sure to select the best allocation method for devices SMAF implement
> deferred allocation mechanism: memory allocation is only done when the first
> device effectively required it.
> Allocator modules have to implement a match() to let SMAF know if they are
> compatibles with devices needs.
> This patch set provide an example of allocator module which use
> dma_{alloc/free/mmap}_attrs() and check if at least one device have
> coherent_dma_mask set to DMA_BIT_MASK(32) in match function.
> I have named smaf-cma.c like it is done for drm_gem_cma_helper.c even if
> a better name could be found for this file.
>
> Secure modules are responsibles of granting and revoking devices access rights
> on the memory. Secure module is also called to check if CPU map memory into
> kernel and user address spaces.
> An example of secure module implementation can be found here:
> http://git.linaro.org/people/benjamin.gaignard/optee-sdp.git
> This code isn't yet part of the patch set because it depends on generic TEE
> which is still under discussion (https://lwn.net/Articles/644646/)
>
> For allocation part of SMAF code I get inspirated by Sumit Semwal work about
> constraint aware allocator.
>
> Benjamin Gaignard (2):
>   create SMAF module
>   SMAF: add CMA allocator
>
>  drivers/Kconfig                |   2 +
>  drivers/Makefile               |   1 +
>  drivers/smaf/Kconfig           |  11 +
>  drivers/smaf/Makefile          |   2 +
>  drivers/smaf/smaf-cma.c        | 200 +++++++++++
>  drivers/smaf/smaf-core.c       | 735 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/smaf-allocator.h |  54 +++
>  include/linux/smaf-secure.h    |  62 ++++
>  include/uapi/linux/smaf.h      |  52 +++
>  9 files changed, 1119 insertions(+)
>  create mode 100644 drivers/smaf/Kconfig
>  create mode 100644 drivers/smaf/Makefile
>  create mode 100644 drivers/smaf/smaf-cma.c
>  create mode 100644 drivers/smaf/smaf-core.c
>  create mode 100644 include/linux/smaf-allocator.h
>  create mode 100644 include/linux/smaf-secure.h
>  create mode 100644 include/uapi/linux/smaf.h
>
> --
> 1.9.1
>



-- 
Benjamin Gaignard

Graphic Working Group

Linaro.org │ Open source software for ARM SoCs

Follow Linaro: Facebook | Twitter | Blog
