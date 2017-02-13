Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:34991 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752020AbdBMOpT (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 09:45:19 -0500
Received: by mail-wm0-f54.google.com with SMTP id v186so159710347wmd.0
        for <linux-media@vger.kernel.org>; Mon, 13 Feb 2017 06:45:18 -0800 (PST)
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: linaro-kernel@lists.linaro.org, arnd@arndb.de, labbott@redhat.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, daniel.vetter@ffwll.ch,
        laurent.pinchart@ideasonboard.com, robdclark@gmail.com,
        akpm@linux-foundation.org, hverkuil@xs4all.nl
Cc: broonie@kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [RFC simple allocator v2 0/2] Simple allocator
Date: Mon, 13 Feb 2017 15:45:04 +0100
Message-Id: <1486997106-23277-1-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

version 2:
- rebase code on 4.10-rc7
- fix bug in CMA allocator
- do more tests with wayland dmabuf protocol:
  https://git.linaro.org/people/benjamin.gaignard/simple_allocator.git

The goal of this RFC is to understand if a common ioctl for specific memory
regions allocations is needed/welcome.

Obviously it will not replace allocation done in linux kernel frameworks like
v4l2, drm/kms or others, but offer an alternative when you don't want/need to
use them for buffer allocation.
To keep a compatibility with what already exist allocated buffers are exported
in userland as dmabuf file descriptor (like ION is doing).

"Unix Device Memory Allocator" project [1] wants to create a userland library
which may allow to select, depending of the devices constraint, the best
back-end for allocation. With this RFC I would to propose to have common ioctl
for a maximum of allocators to avoid to duplicated back-ends for this library.

One of the issues that lead me to propose this RFC it is that since the beginning
it is a problem to allocate contiguous memory (CMA) without using v4l2 or
drm/kms so the first allocator available in this RFC use CMA memory.

An other question is: do we have others memory regions that could be interested
by this new framework ? I have in mind that some title memory regions could use
it or replace ION heaps (system, carveout, etc...).
Maybe it only solve CMA allocation issue, in this case there is no need to create
a new framework but only a dedicated ioctl.

Maybe the first thing to do is to change the name and the location of this 
module, suggestions are welcome.

I have testing this code with the following program:

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>

#include "simple-allocator.h"

#define LENGTH 1024*16

void main (void)
{
	struct simple_allocate_data data;
	int fd = open("/dev/cma0", O_RDWR, 0);
	int ret;
	void *mem;

	if (fd < 0) {
		printf("Can't open /dev/cma0\n");
		return;
	}

	memset(&data, 0, sizeof(data));

	data.length = LENGTH;
	data.flags = O_RDWR | O_CLOEXEC;

	ret = ioctl(fd, SA_IOC_ALLOC, &data);
	if (ret) {
		printf("Buffer allocation failed\n");
		goto end;
	}

	mem = mmap(0, LENGTH, PROT_READ | PROT_WRITE, MAP_SHARED, data.fd, 0);
	if (mem == MAP_FAILED) {
		printf("mmap failed\n");
	}

	memset(mem, 0xFF, LENGTH);
	munmap(mem, LENGTH);

	printf("test simple allocator CMA OK\n");
end:
	close(fd);
}

[1] https://github.com/cubanismo/allocator


Benjamin Gaignard (2):
  Create Simple Allocator module
  add CMA simple allocator module

 Documentation/simple-allocator.txt              |  81 ++++++++++
 drivers/Kconfig                                 |   2 +
 drivers/Makefile                                |   1 +
 drivers/simpleallocator/Kconfig                 |  17 +++
 drivers/simpleallocator/Makefile                |   2 +
 drivers/simpleallocator/simple-allocator-cma.c  | 187 ++++++++++++++++++++++++
 drivers/simpleallocator/simple-allocator-priv.h |  33 +++++
 drivers/simpleallocator/simple-allocator.c      | 180 +++++++++++++++++++++++
 include/uapi/linux/simple-allocator.h           |  35 +++++
 9 files changed, 538 insertions(+)
 create mode 100644 Documentation/simple-allocator.txt
 create mode 100644 drivers/simpleallocator/Kconfig
 create mode 100644 drivers/simpleallocator/Makefile
 create mode 100644 drivers/simpleallocator/simple-allocator-cma.c
 create mode 100644 drivers/simpleallocator/simple-allocator-priv.h
 create mode 100644 drivers/simpleallocator/simple-allocator.c
 create mode 100644 include/uapi/linux/simple-allocator.h

-- 
1.9.1
