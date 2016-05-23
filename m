Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35646 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbcEWIJT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2016 04:09:19 -0400
Received: by mail-wm0-f47.google.com with SMTP id a136so7898106wme.0
        for <linux-media@vger.kernel.org>; Mon, 23 May 2016 01:09:18 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, zoltan.kuscsik@linaro.org,
	sumit.semwal@linaro.org, cc.ma@mediatek.com,
	pascal.brand@linaro.org, joakim.bech@linaro.org,
	dan.caprita@windriver.com, emil.l.velikov@gmail.com
Cc: linaro-mm-sig@lists.linaro.org,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v8 0/3] Secure Memory Allocation Framework
Date: Mon, 23 May 2016 10:09:00 +0200
Message-Id: <1463990943-10068-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

version 8 chanegs:
 - rework of the structures used within ioctl
   by adding a version field and padding to be futur proof
 - rename fake secure moduel to test secure module
 - fix the various remarks done on the previous patcheset

version 7 changes:
 - rebased on kernel 4.6-rc7
 - simplify secure module API
 - add vma ops to be able to detect mmap/munmap calls
 - add ioctl to get number and allocator names
 - update libsmaf with adding tests
   https://git.linaro.org/people/benjamin.gaignard/libsmaf.git
 - add debug log in fake secure module

version 6 changes:
 - rebased on kernel 4.5-rc4
 - fix mmapping bug while requested allocation size isn't a a multiple of
   PAGE_SIZE (add a test for this in libsmaf)

version 5 changes:
 - rebased on kernel 4.3-rc6
 - rework locking schema and make handle status use an atomic_t
 - add a fake secure module to allow performing tests without trusted
   environment

version 4 changes:
 - rebased on kernel 4.3-rc3
 - fix missing EXPORT_SYMBOL for smaf_create_handle()

version 3 changes:
 - Remove ioctl for allocator selection instead provide the name of
   the targeted allocator with allocation request.
   Selecting allocator from userland isn't the prefered way of working
   but is needed when the first user of the buffer is a software component.
 - Fix issues in case of error while creating smaf handle.
 - Fix module license.
 - Update libsmaf and tests to care of the SMAF API evolution
   https://git.linaro.org/people/benjamin.gaignard/libsmaf.git

version 2 changes:
 - Add one ioctl to allow allocator selection from userspace.
   This is required for the uses case where the first user of
   the buffer is a software IP which can't perform dma_buf attachement.
 - Add name and ranking to allocator structure to be able to sort them.
 - Create a tiny library to test SMAF:
   https://git.linaro.org/people/benjamin.gaignard/libsmaf.git
 - Fix one issue when try to secure buffer without secure module registered

The outcome of the previous RFC about how do secure data path was the need
of a secure memory allocator (https://lkml.org/lkml/2015/5/5/551)

SMAF goal is to provide a framework that allow allocating and securing
memory by using dma_buf. Each platform have it own way to perform those two
features so SMAF design allow to register helper modules to perform them.

To be sure to select the best allocation method for devices SMAF implement
deferred allocation mechanism: memory allocation is only done when the first
device effectively required it.
Allocator modules have to implement a match() to let SMAF know if they are
compatibles with devices needs.
This patch set provide an example of allocator module which use
dma_{alloc/free/mmap}_attrs() and check if at least one device have
coherent_dma_mask set to DMA_BIT_MASK(32) in match function.
I have named smaf-cma.c like it is done for drm_gem_cma_helper.c even if
a better name could be found for this file.

Secure modules are responsibles of granting and revoking devices access rights
on the memory. Secure module is also called to check if CPU map memory into
kernel and user address spaces.
An example of secure module implementation can be found here:
http://git.linaro.org/people/benjamin.gaignard/optee-sdp.git
This code isn't yet part of the patch set because it depends on generic TEE
which is still under discussion (https://lwn.net/Articles/644646/)

For allocation part of SMAF code I get inspirated by Sumit Semwal work about
constraint aware allocator.

Benjamin Gaignard (3):
  create SMAF module
  SMAF: add CMA allocator
  SMAF: add test secure module

 drivers/Kconfig                |   2 +
 drivers/Makefile               |   1 +
 drivers/smaf/Kconfig           |  17 +
 drivers/smaf/Makefile          |   3 +
 drivers/smaf/smaf-cma.c        | 188 ++++++++++
 drivers/smaf/smaf-core.c       | 818 +++++++++++++++++++++++++++++++++++++++++
 drivers/smaf/smaf-testsecure.c |  90 +++++
 include/linux/smaf-allocator.h |  45 +++
 include/linux/smaf-secure.h    |  65 ++++
 include/uapi/linux/smaf.h      |  85 +++++
 10 files changed, 1314 insertions(+)
 create mode 100644 drivers/smaf/Kconfig
 create mode 100644 drivers/smaf/Makefile
 create mode 100644 drivers/smaf/smaf-cma.c
 create mode 100644 drivers/smaf/smaf-core.c
 create mode 100644 drivers/smaf/smaf-testsecure.c
 create mode 100644 include/linux/smaf-allocator.h
 create mode 100644 include/linux/smaf-secure.h
 create mode 100644 include/uapi/linux/smaf.h

-- 
1.9.1

