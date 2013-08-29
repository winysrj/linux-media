Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:40927 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754994Ab3H2Hxa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Aug 2013 03:53:30 -0400
From: Inki Dae <inki.dae@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linaro-kernel@lists.linaro.org
Cc: maarten.lankhorst@canonical.com, sumit.semwal@linaro.org,
	kyungmin.park@samsung.com, myungjoo.ham@samsung.com,
	Inki Dae <inki.dae@samsung.com>
Subject: [PATCH v8 0/2] Introduce buffer synchronization framework
Date: Thu, 29 Aug 2013 16:53:19 +0900
Message-id: <1377762801-14057-1-git-send-email-inki.dae@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

This patch set introduces a buffer synchronization framework based
on DMA BUF[1] and based on ww-mutexes[2] for lock mechanism, and
has been rebased on linux-next.

The purpose of this framework is to provide not only buffer access
control to CPU and CPU, and CPU and DMA, and DMA and DMA but also
easy-to-use interfaces for device drivers and user application.
In addtion, this patch set suggests a way for enhancing performance.

Changelog v8:
Consider the write-and-then-read ordering pointed out by David Herrmann,
- The ordering issue means that a task don't take a lock to the dmabuf
  so this task would be stalled even though this task requested a lock to
  the dmabuf between other task unlocked and tries to lock the dmabuf
  again. For this, we have added a wait event mechanism using only generic
  APIs, wait_event_timeout and wake_up functions.

  The below is how to handle the ordering issue using this mechanism:
  1. Check if there is a sync object added prior to current task's one.
  2. If exists, it unlocks the dmabuf so that other task can take a lock
     to the dmabuf first.
  3. Wait for the wake up event from other task: current task will be
     waked up when other task unlocks the dmabuf.
  4. Take a lock to the dmabuf again.
- Code cleanups.

Changelog v7:
Fix things pointed out by Konrad Rzeszutek Wilk,
- Use EXPORT_SYMBOL_GPL instead of EXPORT_SYMBOL.
- Make sure to unlock and unreference all dmabuf objects
  when dmabuf_sync_fini() is called.
- Add more comments.
- Code cleanups.

Changelog v6:
- Fix sync lock to multiple reads.
- Add select system call support.
  . Wake up poll_wait when a dmabuf is unlocked.
- Remove unnecessary the use of mutex lock.
- Add private backend ops callbacks.
  . This ops has one callback for device drivers to clean up their
    sync object resource when the sync object is freed. For this,
    device drivers should implement the free callback properly.
- Update document file.

Changelog v5:
- Rmove a dependence on reservation_object: the reservation_object is used
  to hook up to ttm and dma-buf for easy sharing of reservations across
  devices. However, the dmabuf sync can be used for all dma devices; v4l2
  and drm based drivers, so doesn't need the reservation_object anymore.
  With regared to this, it adds 'void *sync' to dma_buf structure.
- All patches are rebased on mainline, Linux v3.10.

Changelog v4:
- Add user side interface for buffer synchronization mechanism and update
  descriptions related to the user side interface.

Changelog v3:
- remove cache operation relevant codes and update document file.

Changelog v2:
- use atomic_add_unless to avoid potential bug.
- add a macro for checking valid access type.
- code clean.

For generic user mode interface, we have used fcntl and select system
call[3]. As you know, user application sees a buffer object as a dma-buf
file descriptor. So fcntl() call with the file descriptor means to lock
some buffer region being managed by the dma-buf object. And select() call
means to wait for the completion of CPU or DMA access to the dma-buf
without locking. For more detail, you can refer to the dma-buf-sync.txt
in Documentation/

There are some cases user-space process needs this buffer synchronization
framework. One of which is to primarily enhance GPU rendering performance
in case that 3D app draws somthing in a buffer using CPU, and other process
composes the buffer with its own backbuffer using GPU.

In case of 3D app, the app calls glFlush to submit 3d commands to GPU driver
instead of glFinish for more performance. The reason, we call glFlush, is
that glFinish blocks caller's task until the execution of the 3d commands is
completed. So that makes GPU and CPU more idle. As a result, 3d rendering
performance with glFinish is quite lower than glFlush.

However, the use of glFlush has one issue that the the buffer shared with
GPU could be broken when CPU accesses the buffer just after glFlush because
CPU cannot be aware of the completion of GPU access to the buffer.
Of course, the app can be aware of that time using eglWaitGL but this function
is valid only in case of the same context.

The below summarizes how app's window is displayed on Tizen[4] platform:
1. X client requests a window buffer to Xorg.
2. X client draws something in the window buffer using CPU.
3. X client requests SWAP to Xorg.
4. Xorg notifies a damage event to Composite Manager.
5. Composite Manager gets the window buffer (front buffer) through
   DRI2GetBuffers.
6. Composite Manager composes the window buffer and its own back buffer
   using GPU. At this time, eglSwapBuffers is called: internally, 3d
   commands are flushed to gpu driver.
7. Composite Manager requests SWAP to Xorg.
8. Xorg performs drm page flip. At this time, the window buffer is
   displayed on screen.

Web app based on HTML5 also has the same issue. Web browser and Web app
are different process. The Web app can draw something in its own buffer using
CPU, and then the Web Browser can compose the buffer with its own back buffer.

Thus, in such cases, a shared buffer could be broken as one process draws
something in a buffer using CPU, when other process composes the buffer with
its own buffer using GPU without any locking mechanism. That is why we need
user land locking interface, fcntl system call.

And last one is a deferred page flip issue. This issue is that a window
buffer rendered can be displayed on screen in about 32ms in worst case:
assume that the gpu rendering is completed within 16ms.
That can be incurred when compositing a pixmap buffer with a window buffer
using GPU and when vsync is just started. At this time, Xorg waits for
a vblank event to get a window buffer so 3d rendering will be delayed
up to about 16ms. As a result, the window buffer would be displayed in
about two vsyncs (about 32ms) and in turn, that would show slow
responsiveness.

For this, we could enhance the responsiveness with locking mechanism: skipping
one vblank wait. I guess Android, Chrome OS, and other platforms are using
their own locking mechanisms with similar reason; Android sync driver, KDS, and
DMA fence.

The below shows the deferred page flip issue in worst case:

               |------------ <- vsync signal
               |<------ DRI2GetBuffers
               |
               |
               |
               |------------ <- vsync signal
               |<------ Request gpu rendering
          time |
               |
               |<------ Request page flip (deferred)
               |------------ <- vsync signal
               |<------ Displayed on screen
               |
               |
               |
               |------------ <- vsync signal

Thanks,
Inki Dae

References:
[1] http://lwn.net/Articles/470339/
[2] https://patchwork.kernel.org/patch/2625361/
[3] http://linux.die.net/man/2/fcntl
[4] https://www.tizen.org/

Inki Dae (2):
  dmabuf-sync: Add a buffer synchronization framework
  dma-buf: Add user interfaces for dmabuf sync support

 Documentation/dma-buf-sync.txt |  286 ++++++++++++
 drivers/base/Kconfig           |    7 +
 drivers/base/Makefile          |    1 +
 drivers/base/dma-buf.c         |   85 ++++
 drivers/base/dmabuf-sync.c     |  943 ++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-buf.h        |   16 +
 include/linux/dmabuf-sync.h    |  257 +++++++++++
 7 files changed, 1595 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/dma-buf-sync.txt
 create mode 100644 drivers/base/dmabuf-sync.c
 create mode 100644 include/linux/dmabuf-sync.h

-- 
1.7.5.4

