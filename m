Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:35076 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbbGFLko (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jul 2015 07:40:44 -0400
Received: by wgjx7 with SMTP id x7so137576332wgj.2
        for <linux-media@vger.kernel.org>; Mon, 06 Jul 2015 04:40:41 -0700 (PDT)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, daniel.vetter@ffwll.ch,
	robdclark@gmail.com, treding@nvidia.com, sumit.semwal@linaro.org,
	tom.cooksey@arm.com
Cc: tom.gall@linaro.org, linaro-mm-sig@lists.linaro.org,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v2 0/2] RFC: Secure Memory Allocation Framework
Date: Mon,  6 Jul 2015 13:40:25 +0200
Message-Id: <1436182827-6218-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

Benjamin Gaignard (2):
  create SMAF module
  SMAF: add CMA allocator

 drivers/Kconfig                |   2 +
 drivers/Makefile               |   1 +
 drivers/smaf/Kconfig           |  11 +
 drivers/smaf/Makefile          |   2 +
 drivers/smaf/smaf-cma.c        | 200 +++++++++++
 drivers/smaf/smaf-core.c       | 751 +++++++++++++++++++++++++++++++++++++++++
 include/linux/smaf-allocator.h |  54 +++
 include/linux/smaf-secure.h    |  62 ++++
 include/uapi/linux/smaf.h      |  61 ++++
 9 files changed, 1144 insertions(+)
 create mode 100644 drivers/smaf/Kconfig
 create mode 100644 drivers/smaf/Makefile
 create mode 100644 drivers/smaf/smaf-cma.c
 create mode 100644 drivers/smaf/smaf-core.c
 create mode 100644 include/linux/smaf-allocator.h
 create mode 100644 include/linux/smaf-secure.h
 create mode 100644 include/uapi/linux/smaf.h

-- 
1.9.1

