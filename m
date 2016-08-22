Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34809 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932301AbcHVPVv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 11:21:51 -0400
Received: by mail-pf0-f170.google.com with SMTP id p64so33427578pfb.1
        for <linux-media@vger.kernel.org>; Mon, 22 Aug 2016 08:21:48 -0700 (PDT)
From: Sumit Semwal <sumit.semwal@linaro.org>
To: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-doc@vger.kernel.org
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org,
        markus.heiser@darmarit.de, jani.nikula@linux.intel.com,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH v2 1/2] Documentation: move dma-buf documentation to rst
Date: Mon, 22 Aug 2016 20:41:44 +0530
Message-Id: <1471878705-3963-2-git-send-email-sumit.semwal@linaro.org>
In-Reply-To: <1471878705-3963-1-git-send-email-sumit.semwal@linaro.org>
References: <1471878705-3963-1-git-send-email-sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Branch out dma-buf related documentation into its own rst file to allow
adding it to the sphinx documentation generated.

While at it, move dma-buf-sharing.txt into rst as the dma-buf guide too;
adjust MAINTAINERS accordingly.

v2:
- Removed authorship as suggested by Jani,
- Address review comments from Jonathan Corbet and Markus Heiser.

Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
---
 Documentation/DocBook/device-drivers.tmpl |  41 ---
 Documentation/dma-buf-sharing.txt         | 482 ----------------------------
 Documentation/dma-buf/guide.rst           | 507 ++++++++++++++++++++++++++++++
 Documentation/dma-buf/intro.rst           |  82 +++++
 MAINTAINERS                               |   2 +-
 5 files changed, 590 insertions(+), 524 deletions(-)
 delete mode 100644 Documentation/dma-buf-sharing.txt
 create mode 100644 Documentation/dma-buf/guide.rst
 create mode 100644 Documentation/dma-buf/intro.rst

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 9c10030eb2be..a93fbffa9742 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -128,47 +128,6 @@ X!Edrivers/base/interface.c
 !Edrivers/base/platform.c
 !Edrivers/base/bus.c
      </sect1>
-     <sect1>
-       <title>Buffer Sharing and Synchronization</title>
-       <para>
-         The dma-buf subsystem provides the framework for sharing buffers
-         for hardware (DMA) access across multiple device drivers and
-         subsystems, and for synchronizing asynchronous hardware access.
-       </para>
-       <para>
-         This is used, for example, by drm "prime" multi-GPU support, but
-         is of course not limited to GPU use cases.
-       </para>
-       <para>
-         The three main components of this are: (1) dma-buf, representing
-         a sg_table and exposed to userspace as a file descriptor to allow
-         passing between devices, (2) fence, which provides a mechanism
-         to signal when one device as finished access, and (3) reservation,
-         which manages the shared or exclusive fence(s) associated with
-         the buffer.
-       </para>
-       <sect2><title>dma-buf</title>
-!Edrivers/dma-buf/dma-buf.c
-!Iinclude/linux/dma-buf.h
-       </sect2>
-       <sect2><title>reservation</title>
-!Pdrivers/dma-buf/reservation.c Reservation Object Overview
-!Edrivers/dma-buf/reservation.c
-!Iinclude/linux/reservation.h
-       </sect2>
-       <sect2><title>fence</title>
-!Edrivers/dma-buf/fence.c
-!Iinclude/linux/fence.h
-!Edrivers/dma-buf/seqno-fence.c
-!Iinclude/linux/seqno-fence.h
-!Edrivers/dma-buf/fence-array.c
-!Iinclude/linux/fence-array.h
-!Edrivers/dma-buf/reservation.c
-!Iinclude/linux/reservation.h
-!Edrivers/dma-buf/sync_file.c
-!Iinclude/linux/sync_file.h
-       </sect2>
-     </sect1>
      <sect1><title>Device Drivers DMA Management</title>
 !Edrivers/base/dma-coherent.c
 !Edrivers/base/dma-mapping.c
diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
deleted file mode 100644
index ca44c5820585..000000000000
--- a/Documentation/dma-buf-sharing.txt
+++ /dev/null
@@ -1,482 +0,0 @@
-                    DMA Buffer Sharing API Guide
-                    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-
-                            Sumit Semwal
-                <sumit dot semwal at linaro dot org>
-                 <sumit dot semwal at ti dot com>
-
-This document serves as a guide to device-driver writers on what is the dma-buf
-buffer sharing API, how to use it for exporting and using shared buffers.
-
-Any device driver which wishes to be a part of DMA buffer sharing, can do so as
-either the 'exporter' of buffers, or the 'user' of buffers.
-
-Say a driver A wants to use buffers created by driver B, then we call B as the
-exporter, and A as buffer-user.
-
-The exporter
-- implements and manages operations[1] for the buffer
-- allows other users to share the buffer by using dma_buf sharing APIs,
-- manages the details of buffer allocation,
-- decides about the actual backing storage where this allocation happens,
-- takes care of any migration of scatterlist - for all (shared) users of this
-   buffer,
-
-The buffer-user
-- is one of (many) sharing users of the buffer.
-- doesn't need to worry about how the buffer is allocated, or where.
-- needs a mechanism to get access to the scatterlist that makes up this buffer
-   in memory, mapped into its own address space, so it can access the same area
-   of memory.
-
-dma-buf operations for device dma only
---------------------------------------
-
-The dma_buf buffer sharing API usage contains the following steps:
-
-1. Exporter announces that it wishes to export a buffer
-2. Userspace gets the file descriptor associated with the exported buffer, and
-   passes it around to potential buffer-users based on use case
-3. Each buffer-user 'connects' itself to the buffer
-4. When needed, buffer-user requests access to the buffer from exporter
-5. When finished with its use, the buffer-user notifies end-of-DMA to exporter
-6. when buffer-user is done using this buffer completely, it 'disconnects'
-   itself from the buffer.
-
-
-1. Exporter's announcement of buffer export
-
-   The buffer exporter announces its wish to export a buffer. In this, it
-   connects its own private buffer data, provides implementation for operations
-   that can be performed on the exported dma_buf, and flags for the file
-   associated with this buffer. All these fields are filled in struct
-   dma_buf_export_info, defined via the DEFINE_DMA_BUF_EXPORT_INFO macro.
-
-   Interface:
-      DEFINE_DMA_BUF_EXPORT_INFO(exp_info)
-      struct dma_buf *dma_buf_export(struct dma_buf_export_info *exp_info)
-
-   If this succeeds, dma_buf_export allocates a dma_buf structure, and
-   returns a pointer to the same. It also associates an anonymous file with this
-   buffer, so it can be exported. On failure to allocate the dma_buf object,
-   it returns NULL.
-
-   'exp_name' in struct dma_buf_export_info is the name of exporter - to
-   facilitate information while debugging. It is set to KBUILD_MODNAME by
-   default, so exporters don't have to provide a specific name, if they don't
-   wish to.
-
-   DEFINE_DMA_BUF_EXPORT_INFO macro defines the struct dma_buf_export_info,
-   zeroes it out and pre-populates exp_name in it.
-
-
-2. Userspace gets a handle to pass around to potential buffer-users
-
-   Userspace entity requests for a file-descriptor (fd) which is a handle to the
-   anonymous file associated with the buffer. It can then share the fd with other
-   drivers and/or processes.
-
-   Interface:
-      int dma_buf_fd(struct dma_buf *dmabuf, int flags)
-
-   This API installs an fd for the anonymous file associated with this buffer;
-   returns either 'fd', or error.
-
-3. Each buffer-user 'connects' itself to the buffer
-
-   Each buffer-user now gets a reference to the buffer, using the fd passed to
-   it.
-
-   Interface:
-      struct dma_buf *dma_buf_get(int fd)
-
-   This API will return a reference to the dma_buf, and increment refcount for
-   it.
-
-   After this, the buffer-user needs to attach its device with the buffer, which
-   helps the exporter to know of device buffer constraints.
-
-   Interface:
-      struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf,
-                                                struct device *dev)
-
-   This API returns reference to an attachment structure, which is then used
-   for scatterlist operations. It will optionally call the 'attach' dma_buf
-   operation, if provided by the exporter.
-
-   The dma-buf sharing framework does the bookkeeping bits related to managing
-   the list of all attachments to a buffer.
-
-Until this stage, the buffer-exporter has the option to choose not to actually
-allocate the backing storage for this buffer, but wait for the first buffer-user
-to request use of buffer for allocation.
-
-
-4. When needed, buffer-user requests access to the buffer
-
-   Whenever a buffer-user wants to use the buffer for any DMA, it asks for
-   access to the buffer using dma_buf_map_attachment API. At least one attach to
-   the buffer must have happened before map_dma_buf can be called.
-
-   Interface:
-      struct sg_table * dma_buf_map_attachment(struct dma_buf_attachment *,
-                                         enum dma_data_direction);
-
-   This is a wrapper to dma_buf->ops->map_dma_buf operation, which hides the
-   "dma_buf->ops->" indirection from the users of this interface.
-
-   In struct dma_buf_ops, map_dma_buf is defined as
-      struct sg_table * (*map_dma_buf)(struct dma_buf_attachment *,
-                                                enum dma_data_direction);
-
-   It is one of the buffer operations that must be implemented by the exporter.
-   It should return the sg_table containing scatterlist for this buffer, mapped
-   into caller's address space.
-
-   If this is being called for the first time, the exporter can now choose to
-   scan through the list of attachments for this buffer, collate the requirements
-   of the attached devices, and choose an appropriate backing storage for the
-   buffer.
-
-   Based on enum dma_data_direction, it might be possible to have multiple users
-   accessing at the same time (for reading, maybe), or any other kind of sharing
-   that the exporter might wish to make available to buffer-users.
-
-   map_dma_buf() operation can return -EINTR if it is interrupted by a signal.
-
-
-5. When finished, the buffer-user notifies end-of-DMA to exporter
-
-   Once the DMA for the current buffer-user is over, it signals 'end-of-DMA' to
-   the exporter using the dma_buf_unmap_attachment API.
-
-   Interface:
-      void dma_buf_unmap_attachment(struct dma_buf_attachment *,
-                                    struct sg_table *);
-
-   This is a wrapper to dma_buf->ops->unmap_dma_buf() operation, which hides the
-   "dma_buf->ops->" indirection from the users of this interface.
-
-   In struct dma_buf_ops, unmap_dma_buf is defined as
-      void (*unmap_dma_buf)(struct dma_buf_attachment *,
-                            struct sg_table *,
-                            enum dma_data_direction);
-
-   unmap_dma_buf signifies the end-of-DMA for the attachment provided. Like
-   map_dma_buf, this API also must be implemented by the exporter.
-
-
-6. when buffer-user is done using this buffer, it 'disconnects' itself from the
-   buffer.
-
-   After the buffer-user has no more interest in using this buffer, it should
-   disconnect itself from the buffer:
-
-   - it first detaches itself from the buffer.
-
-   Interface:
-      void dma_buf_detach(struct dma_buf *dmabuf,
-                          struct dma_buf_attachment *dmabuf_attach);
-
-   This API removes the attachment from the list in dmabuf, and optionally calls
-   dma_buf->ops->detach(), if provided by exporter, for any housekeeping bits.
-
-   - Then, the buffer-user returns the buffer reference to exporter.
-
-   Interface:
-     void dma_buf_put(struct dma_buf *dmabuf);
-
-   This API then reduces the refcount for this buffer.
-
-   If, as a result of this call, the refcount becomes 0, the 'release' file
-   operation related to this fd is called. It calls the dmabuf->ops->release()
-   operation in turn, and frees the memory allocated for dmabuf when exported.
-
-NOTES:
-- Importance of attach-detach and {map,unmap}_dma_buf operation pairs
-   The attach-detach calls allow the exporter to figure out backing-storage
-   constraints for the currently-interested devices. This allows preferential
-   allocation, and/or migration of pages across different types of storage
-   available, if possible.
-
-   Bracketing of DMA access with {map,unmap}_dma_buf operations is essential
-   to allow just-in-time backing of storage, and migration mid-way through a
-   use-case.
-
-- Migration of backing storage if needed
-   If after
-   - at least one map_dma_buf has happened,
-   - and the backing storage has been allocated for this buffer,
-   another new buffer-user intends to attach itself to this buffer, it might
-   be allowed, if possible for the exporter.
-
-   In case it is allowed by the exporter:
-    if the new buffer-user has stricter 'backing-storage constraints', and the
-    exporter can handle these constraints, the exporter can just stall on the
-    map_dma_buf until all outstanding access is completed (as signalled by
-    unmap_dma_buf).
-    Once all users have finished accessing and have unmapped this buffer, the
-    exporter could potentially move the buffer to the stricter backing-storage,
-    and then allow further {map,unmap}_dma_buf operations from any buffer-user
-    from the migrated backing-storage.
-
-   If the exporter cannot fulfill the backing-storage constraints of the new
-   buffer-user device as requested, dma_buf_attach() would return an error to
-   denote non-compatibility of the new buffer-sharing request with the current
-   buffer.
-
-   If the exporter chooses not to allow an attach() operation once a
-   map_dma_buf() API has been called, it simply returns an error.
-
-Kernel cpu access to a dma-buf buffer object
---------------------------------------------
-
-The motivation to allow cpu access from the kernel to a dma-buf object from the
-importers side are:
-- fallback operations, e.g. if the devices is connected to a usb bus and the
-  kernel needs to shuffle the data around first before sending it away.
-- full transparency for existing users on the importer side, i.e. userspace
-  should not notice the difference between a normal object from that subsystem
-  and an imported one backed by a dma-buf. This is really important for drm
-  opengl drivers that expect to still use all the existing upload/download
-  paths.
-
-Access to a dma_buf from the kernel context involves three steps:
-
-1. Prepare access, which invalidate any necessary caches and make the object
-   available for cpu access.
-2. Access the object page-by-page with the dma_buf map apis
-3. Finish access, which will flush any necessary cpu caches and free reserved
-   resources.
-
-1. Prepare access
-
-   Before an importer can access a dma_buf object with the cpu from the kernel
-   context, it needs to notify the exporter of the access that is about to
-   happen.
-
-   Interface:
-      int dma_buf_begin_cpu_access(struct dma_buf *dmabuf,
-				   enum dma_data_direction direction)
-
-   This allows the exporter to ensure that the memory is actually available for
-   cpu access - the exporter might need to allocate or swap-in and pin the
-   backing storage. The exporter also needs to ensure that cpu access is
-   coherent for the access direction. The direction can be used by the exporter
-   to optimize the cache flushing, i.e. access with a different direction (read
-   instead of write) might return stale or even bogus data (e.g. when the
-   exporter needs to copy the data to temporary storage).
-
-   This step might fail, e.g. in oom conditions.
-
-2. Accessing the buffer
-
-   To support dma_buf objects residing in highmem cpu access is page-based using
-   an api similar to kmap. Accessing a dma_buf is done in aligned chunks of
-   PAGE_SIZE size. Before accessing a chunk it needs to be mapped, which returns
-   a pointer in kernel virtual address space. Afterwards the chunk needs to be
-   unmapped again. There is no limit on how often a given chunk can be mapped
-   and unmapped, i.e. the importer does not need to call begin_cpu_access again
-   before mapping the same chunk again.
-
-   Interfaces:
-      void *dma_buf_kmap(struct dma_buf *, unsigned long);
-      void dma_buf_kunmap(struct dma_buf *, unsigned long, void *);
-
-   There are also atomic variants of these interfaces. Like for kmap they
-   facilitate non-blocking fast-paths. Neither the importer nor the exporter (in
-   the callback) is allowed to block when using these.
-
-   Interfaces:
-      void *dma_buf_kmap_atomic(struct dma_buf *, unsigned long);
-      void dma_buf_kunmap_atomic(struct dma_buf *, unsigned long, void *);
-
-   For importers all the restrictions of using kmap apply, like the limited
-   supply of kmap_atomic slots. Hence an importer shall only hold onto at most 2
-   atomic dma_buf kmaps at the same time (in any given process context).
-
-   dma_buf kmap calls outside of the range specified in begin_cpu_access are
-   undefined. If the range is not PAGE_SIZE aligned, kmap needs to succeed on
-   the partial chunks at the beginning and end but may return stale or bogus
-   data outside of the range (in these partial chunks).
-
-   Note that these calls need to always succeed. The exporter needs to complete
-   any preparations that might fail in begin_cpu_access.
-
-   For some cases the overhead of kmap can be too high, a vmap interface
-   is introduced. This interface should be used very carefully, as vmalloc
-   space is a limited resources on many architectures.
-
-   Interfaces:
-      void *dma_buf_vmap(struct dma_buf *dmabuf)
-      void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr)
-
-   The vmap call can fail if there is no vmap support in the exporter, or if it
-   runs out of vmalloc space. Fallback to kmap should be implemented. Note that
-   the dma-buf layer keeps a reference count for all vmap access and calls down
-   into the exporter's vmap function only when no vmapping exists, and only
-   unmaps it once. Protection against concurrent vmap/vunmap calls is provided
-   by taking the dma_buf->lock mutex.
-
-3. Finish access
-
-   When the importer is done accessing the CPU, it needs to announce this to
-   the exporter (to facilitate cache flushing and unpinning of any pinned
-   resources). The result of any dma_buf kmap calls after end_cpu_access is
-   undefined.
-
-   Interface:
-      void dma_buf_end_cpu_access(struct dma_buf *dma_buf,
-				  enum dma_data_direction dir);
-
-
-Direct Userspace Access/mmap Support
-------------------------------------
-
-Being able to mmap an export dma-buf buffer object has 2 main use-cases:
-- CPU fallback processing in a pipeline and
-- supporting existing mmap interfaces in importers.
-
-1. CPU fallback processing in a pipeline
-
-   In many processing pipelines it is sometimes required that the cpu can access
-   the data in a dma-buf (e.g. for thumbnail creation, snapshots, ...). To avoid
-   the need to handle this specially in userspace frameworks for buffer sharing
-   it's ideal if the dma_buf fd itself can be used to access the backing storage
-   from userspace using mmap.
-
-   Furthermore Android's ION framework already supports this (and is otherwise
-   rather similar to dma-buf from a userspace consumer side with using fds as
-   handles, too). So it's beneficial to support this in a similar fashion on
-   dma-buf to have a good transition path for existing Android userspace.
-
-   No special interfaces, userspace simply calls mmap on the dma-buf fd, making
-   sure that the cache synchronization ioctl (DMA_BUF_IOCTL_SYNC) is *always*
-   used when the access happens. Note that DMA_BUF_IOCTL_SYNC can fail with
-   -EAGAIN or -EINTR, in which case it must be restarted.
-
-   Some systems might need some sort of cache coherency management e.g. when
-   CPU and GPU domains are being accessed through dma-buf at the same time. To
-   circumvent this problem there are begin/end coherency markers, that forward
-   directly to existing dma-buf device drivers vfunc hooks. Userspace can make
-   use of those markers through the DMA_BUF_IOCTL_SYNC ioctl. The sequence
-   would be used like following:
-     - mmap dma-buf fd
-     - for each drawing/upload cycle in CPU 1. SYNC_START ioctl, 2. read/write
-       to mmap area 3. SYNC_END ioctl. This can be repeated as often as you
-       want (with the new data being consumed by the GPU or say scanout device)
-     - munmap once you don't need the buffer any more
-
-    For correctness and optimal performance, it is always required to use
-    SYNC_START and SYNC_END before and after, respectively, when accessing the
-    mapped address. Userspace cannot rely on coherent access, even when there
-    are systems where it just works without calling these ioctls.
-
-2. Supporting existing mmap interfaces in importers
-
-   Similar to the motivation for kernel cpu access it is again important that
-   the userspace code of a given importing subsystem can use the same interfaces
-   with a imported dma-buf buffer object as with a native buffer object. This is
-   especially important for drm where the userspace part of contemporary OpenGL,
-   X, and other drivers is huge, and reworking them to use a different way to
-   mmap a buffer rather invasive.
-
-   The assumption in the current dma-buf interfaces is that redirecting the
-   initial mmap is all that's needed. A survey of some of the existing
-   subsystems shows that no driver seems to do any nefarious thing like syncing
-   up with outstanding asynchronous processing on the device or allocating
-   special resources at fault time. So hopefully this is good enough, since
-   adding interfaces to intercept pagefaults and allow pte shootdowns would
-   increase the complexity quite a bit.
-
-   Interface:
-      int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *,
-		       unsigned long);
-
-   If the importing subsystem simply provides a special-purpose mmap call to set
-   up a mapping in userspace, calling do_mmap with dma_buf->file will equally
-   achieve that for a dma-buf object.
-
-3. Implementation notes for exporters
-
-   Because dma-buf buffers have invariant size over their lifetime, the dma-buf
-   core checks whether a vma is too large and rejects such mappings. The
-   exporter hence does not need to duplicate this check.
-
-   Because existing importing subsystems might presume coherent mappings for
-   userspace, the exporter needs to set up a coherent mapping. If that's not
-   possible, it needs to fake coherency by manually shooting down ptes when
-   leaving the cpu domain and flushing caches at fault time. Note that all the
-   dma_buf files share the same anon inode, hence the exporter needs to replace
-   the dma_buf file stored in vma->vm_file with it's own if pte shootdown is
-   required. This is because the kernel uses the underlying inode's address_space
-   for vma tracking (and hence pte tracking at shootdown time with
-   unmap_mapping_range).
-
-   If the above shootdown dance turns out to be too expensive in certain
-   scenarios, we can extend dma-buf with a more explicit cache tracking scheme
-   for userspace mappings. But the current assumption is that using mmap is
-   always a slower path, so some inefficiencies should be acceptable.
-
-   Exporters that shoot down mappings (for any reasons) shall not do any
-   synchronization at fault time with outstanding device operations.
-   Synchronization is an orthogonal issue to sharing the backing storage of a
-   buffer and hence should not be handled by dma-buf itself. This is explicitly
-   mentioned here because many people seem to want something like this, but if
-   different exporters handle this differently, buffer sharing can fail in
-   interesting ways depending upong the exporter (if userspace starts depending
-   upon this implicit synchronization).
-
-Other Interfaces Exposed to Userspace on the dma-buf FD
-------------------------------------------------------
-
-- Since kernel 3.12 the dma-buf FD supports the llseek system call, but only
-  with offset=0 and whence=SEEK_END|SEEK_SET. SEEK_SET is supported to allow
-  the usual size discover pattern size = SEEK_END(0); SEEK_SET(0). Every other
-  llseek operation will report -EINVAL.
-
-  If llseek on dma-buf FDs isn't support the kernel will report -ESPIPE for all
-  cases. Userspace can use this to detect support for discovering the dma-buf
-  size using llseek.
-
-Miscellaneous notes
--------------------
-
-- Any exporters or users of the dma-buf buffer sharing framework must have
-  a 'select DMA_SHARED_BUFFER' in their respective Kconfigs.
-
-- In order to avoid fd leaks on exec, the FD_CLOEXEC flag must be set
-  on the file descriptor.  This is not just a resource leak, but a
-  potential security hole.  It could give the newly exec'd application
-  access to buffers, via the leaked fd, to which it should otherwise
-  not be permitted access.
-
-  The problem with doing this via a separate fcntl() call, versus doing it
-  atomically when the fd is created, is that this is inherently racy in a
-  multi-threaded app[3].  The issue is made worse when it is library code
-  opening/creating the file descriptor, as the application may not even be
-  aware of the fd's.
-
-  To avoid this problem, userspace must have a way to request O_CLOEXEC
-  flag be set when the dma-buf fd is created.  So any API provided by
-  the exporting driver to create a dmabuf fd must provide a way to let
-  userspace control setting of O_CLOEXEC flag passed in to dma_buf_fd().
-
-- If an exporter needs to manually flush caches and hence needs to fake
-  coherency for mmap support, it needs to be able to zap all the ptes pointing
-  at the backing storage. Now linux mm needs a struct address_space associated
-  with the struct file stored in vma->vm_file to do that with the function
-  unmap_mapping_range. But the dma_buf framework only backs every dma_buf fd
-  with the anon_file struct file, i.e. all dma_bufs share the same file.
-
-  Hence exporters need to setup their own file (and address_space) association
-  by setting vma->vm_file and adjusting vma->vm_pgoff in the dma_buf mmap
-  callback. In the specific case of a gem driver the exporter could use the
-  shmem file already provided by gem (and set vm_pgoff = 0). Exporters can then
-  zap ptes by unmapping the corresponding range of the struct address_space
-  associated with their own file.
-
-References:
-[1] struct dma_buf_ops in include/linux/dma-buf.h
-[2] All interfaces mentioned above defined in include/linux/dma-buf.h
-[3] https://lwn.net/Articles/236486/
diff --git a/Documentation/dma-buf/guide.rst b/Documentation/dma-buf/guide.rst
new file mode 100644
index 000000000000..7407d255e9da
--- /dev/null
+++ b/Documentation/dma-buf/guide.rst
@@ -0,0 +1,507 @@
+
+.. _dma-buf-guide:
+
+============================
+DMA Buffer Sharing API Guide
+============================
+
+This document serves as a guide to device-driver writers on what is the dma-buf
+buffer sharing API, how to use it for exporting and using shared buffers.
+
+Any device driver which wishes to be a part of DMA buffer sharing, can do so as
+either the 'exporter' of buffers, or the 'user' of buffers.
+
+Say a driver A wants to use buffers created by driver B, then we call B as the
+exporter, and A as buffer-user.
+
+The exporter
+
+* implements and manages operations for the buffer via
+  :c:type:`struct dma_buf_ops <dma_buf_ops>`
+* allows other users to share the buffer by using dma_buf sharing APIs,
+* manages the details of buffer allocation,
+* decides about the actual backing storage where this allocation happens,
+* takes care of any migration of scatterlist - for all (shared) users of this
+  buffer,
+
+The buffer-user
+
+* is one of (many) sharing users of the buffer.
+* doesn't need to worry about how the buffer is allocated, or where.
+* needs a mechanism to get access to the scatterlist that makes up this buffer
+  in memory, mapped into its own address space, so it can access the same area
+  of memory.
+
+dma-buf operations for device dma only
+======================================
+
+The dma_buf buffer sharing API usage contains the following steps:
+
+1. Exporter announces that it wishes to export a buffer
+2. Userspace gets the file descriptor associated with the exported buffer, and
+   passes it around to potential buffer-users based on use case
+3. Each buffer-user 'connects' itself to the buffer
+4. When needed, buffer-user requests access to the buffer from exporter
+5. When finished with its use, the buffer-user notifies end-of-DMA to exporter
+6. when buffer-user is done using this buffer completely, it 'disconnects'
+   itself from the buffer.
+
+
+Exporter's announcement of buffer export
+----------------------------------------
+
+The buffer exporter announces its wish to export a buffer. In this, it
+connects its own private buffer data, provides implementation for operations
+that can be performed on the exported :c:type:`dma_buf`, and flags for the file
+associated with this buffer. All these fields are filled in struct
+:c:type:`dma_buf_export_info`, defined via the DEFINE_DMA_BUF_EXPORT_INFO macro.
+
+Interface:
+   :c:type:`DEFINE_DMA_BUF_EXPORT_INFO(exp_info) <DEFINE_DMA_BUF_EXPORT_INFO>`
+
+   :c:func:`struct dma_buf *dma_buf_export(struct dma_buf_export_info *exp_info)<dma_buf_export>`
+
+If this succeeds, dma_buf_export allocates a dma_buf structure, and
+returns a pointer to the same. It also associates an anonymous file with this
+buffer, so it can be exported. On failure to allocate the dma_buf object,
+it returns NULL.
+
+``exp_name`` in struct dma_buf_export_info is the name of exporter - to
+facilitate information while debugging. It is set to ``KBUILD_MODNAME`` by
+default, so exporters don't have to provide a specific name, if they don't
+wish to.
+
+DEFINE_DMA_BUF_EXPORT_INFO macro defines the struct dma_buf_export_info,
+zeroes it out and pre-populates exp_name in it.
+
+Userspace gets a handle to pass around to potential buffer-users
+----------------------------------------------------------------
+
+Userspace entity requests for a file-descriptor (fd) which is a handle to the
+anonymous file associated with the buffer. It can then share the fd with other
+drivers and/or processes.
+
+Interface:
+   :c:func:`int dma_buf_fd(struct dma_buf *dmabuf, int flags) <dma_buf_fd>`
+
+This API installs an fd for the anonymous file associated with this buffer;
+returns either ``fd``, or error.
+
+Each buffer-user 'connects' itself to the buffer
+------------------------------------------------
+
+Each buffer-user now gets a reference to the buffer, using the fd passed to it.
+
+Interface:
+   :c:func:`struct dma_buf *dma_buf_get(int fd) <dma_buf_get>`
+
+This API will return a reference to the dma_buf, and increment refcount forit.
+
+After this, the buffer-user needs to attach its device with the buffer, which
+helps the exporter to know of device buffer constraints.
+
+Interface:
+   :c:func:`struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf, struct device *dev) <dma_buf_attach>`
+
+This API returns reference to an attachment structure, which is then used
+for scatterlist operations. It will optionally call the 'attach' dma_buf
+operation, if provided by the exporter.
+
+The dma-buf sharing framework does the bookkeeping bits related to managing
+the list of all attachments to a buffer.
+
+.. note::
+
+ Until this stage, the buffer-exporter has the option to choose not to actually
+ allocate the backing storage for this buffer, but wait for the first
+ buffer-user to request use of buffer for allocation.
+
+When needed, buffer-user requests access to the buffer
+------------------------------------------------------
+
+Whenever a buffer-user wants to use the buffer for any DMA, it asks for
+access to the buffer using dma_buf_map_attachment API. At least one attach to
+the buffer must have happened before map_dma_buf can be called.
+
+Interface:
+   :c:func:`struct sg_table * dma_buf_map_attachment(struct dma_buf_attachment *, enum dma_data_direction) <dma_buf_map_attachment>`
+
+This is a wrapper to dma_buf->ops->map_dma_buf operation, which hides the
+``dma_buf->ops->`` indirection from the users of this interface.
+
+In struct :c:type:`dma_buf_ops`, ``map_dma_buf`` is defined as
+    ``struct sg_table * (*map_dma_buf)(struct dma_buf_attachment *, enum dma_data_direction);``
+
+It is one of the buffer operations that must be implemented by the exporter.
+It should return the sg_table containing scatterlist for this buffer, mapped
+into caller's address space.
+
+If this is being called for the first time, the exporter can now choose to
+scan through the list of attachments for this buffer, collate the requirements
+of the attached devices, and choose an appropriate backing storage for the
+buffer.
+
+Based on enum :c:type:`dma_data_direction`, it might be possible to have multiple users
+accessing at the same time (for reading, maybe), or any other kind of sharing
+that the exporter might wish to make available to buffer-users.
+
+``map_dma_buf()`` operation can return -EINTR if it is interrupted by a signal.
+
+
+When finished, the buffer-user notifies end-of-DMA to exporter
+--------------------------------------------------------------
+
+Once the DMA for the current buffer-user is over, it signals 'end-of-DMA' to
+the exporter using the dma_buf_unmap_attachment API.
+
+Interface:
+   :c:func:`void dma_buf_unmap_attachment(struct dma_buf_attachment *, struct sg_table *) <dma_buf_unmap_attachment>`
+
+This is a wrapper to dma_buf->ops->unmap_dma_buf() operation, which hides the
+"dma_buf->ops->" indirection from the users of this interface.
+
+In struct dma_buf_ops, unmap_dma_buf is defined as
+   ``void (*unmap_dma_buf)(struct dma_buf_attachment *, struct sg_table *, enum dma_data_direction)``
+
+``unmap_dma_buf()`` signifies the end-of-DMA for the attachment provided. Like
+``map_dma_buf``, this API also must be implemented by the exporter.
+
+
+when buffer-user is done using this buffer, it 'disconnects' itself from the buffer.
+------------------------------------------------------------------------------------
+
+After the buffer-user has no more interest in using this buffer, it should
+disconnect itself from the buffer:
+
+   * it first detaches itself from the buffer.
+
+   Interface:
+      :c:func:`void dma_buf_detach(struct dma_buf *dmabuf, struct dma_buf_attachment *dmabuf_attach) <dma_buf_detach>`
+
+   This API removes the attachment from the list in dmabuf, and optionally calls
+   ``dma_buf->ops->detach()``, if provided by exporter, for any housekeeping bits.
+
+   * Then, the buffer-user returns the buffer reference to exporter.
+
+   Interface:
+     :c:func:`void dma_buf_put(struct dma_buf *dmabuf) <dma_buf_put>`
+
+   This API then reduces the refcount for this buffer.
+
+   If, as a result of this call, the refcount becomes 0, the 'release' file
+   operation related to this fd is called. It calls the
+   ``dmabuf->ops->release()`` operation in turn, and frees the memory allocated
+   for dmabuf when exported.
+
+NOTES
+-----
+
+Importance of attach-detach and {map,unmap}_dma_buf operation pairs
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+  The attach-detach calls allow the exporter to figure out backing-storage
+  constraints for the currently-interested devices. This allows preferential
+  allocation, and/or migration of pages across different types of storage
+  available, if possible.
+
+  Bracketing of DMA access with {map,unmap}_dma_buf operations is essential
+  to allow just-in-time backing of storage, and migration mid-way through a
+  use-case.
+
+Migration of backing storage if needed
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+  If after
+
+  * at least one map_dma_buf has happened,
+  * and the backing storage has been allocated for this buffer,
+
+  another new buffer-user intends to attach itself to this buffer, it might
+  be allowed, if possible for the exporter.
+
+  In case it is allowed by the exporter:
+
+  * if the new buffer-user has stricter 'backing-storage constraints', and the
+    exporter can handle these constraints, the exporter can just stall on the
+    map_dma_buf until all outstanding access is completed (as signalled by
+    unmap_dma_buf).
+
+  * Once all users have finished accessing and have unmapped this buffer, the
+    exporter could potentially move the buffer to the stricter backing-storage,
+    and then allow further {map,unmap}_dma_buf operations from any buffer-user
+    from the migrated backing-storage.
+
+  * If the exporter cannot fulfill the backing-storage constraints of the new
+    buffer-user device as requested, dma_buf_attach() would return an error to
+    denote non-compatibility of the new buffer-sharing request with the current
+    buffer.
+
+
+  If the exporter chooses not to allow an attach() operation once a
+  map_dma_buf() API has been called, it simply returns an error.
+
+Kernel cpu access to a dma-buf buffer object
+============================================
+
+The motivation to allow cpu access from the kernel to a dma-buf object from the
+importers side are:
+
+* fallback operations, e.g. if the devices is connected to a usb bus and the
+  kernel needs to shuffle the data around first before sending it away.
+
+* full transparency for existing users on the importer side, i.e. userspace
+  should not notice the difference between a normal object from that subsystem
+  and an imported one backed by a dma-buf. This is really important for drm
+  opengl drivers that expect to still use all the existing upload/download
+  paths.
+
+Access to a dma_buf from the kernel context involves three steps:
+
+1. Prepare access, which invalidate any necessary caches and make the object
+   available for cpu access.
+
+2. Access the object page-by-page with the dma_buf map apis
+
+3. Finish access, which will flush any necessary cpu caches and free reserved
+   resources.
+
+Prepare access
+--------------
+
+Before an importer can access a dma_buf object with the cpu from the kernel
+context, it needs to notify the exporter of the access that is about to
+happen.
+
+Interface:
+   :c:func:`int dma_buf_begin_cpu_access(struct dma_buf *dmabuf, enum dma_data_direction direction) <dma_buf_begin_cpu_access>`
+
+This allows the exporter to ensure that the memory is actually available for
+cpu access - the exporter might need to allocate or swap-in and pin the
+backing storage. The exporter also needs to ensure that cpu access is
+coherent for the access direction. The direction can be used by the exporter
+to optimize the cache flushing, i.e. access with a different direction (read
+instead of write) might return stale or even bogus data (e.g. when the
+exporter needs to copy the data to temporary storage).
+
+This step might fail, e.g. in oom conditions.
+
+Access the buffer
+-----------------
+
+To support dma_buf objects residing in highmem cpu access is page-based using
+an api similar to kmap. Accessing a dma_buf is done in aligned chunks of
+``PAGE_SIZE`` size. Before accessing a chunk it needs to be mapped, which returns
+a pointer in kernel virtual address space. Afterwards the chunk needs to be
+unmapped again. There is no limit on how often a given chunk can be mapped
+and unmapped, i.e. the importer does not need to call ``begin_cpu_access()`` again
+before mapping the same chunk again.
+
+Interfaces:
+   :c:func:`void *dma_buf_kmap(struct dma_buf *, unsigned long) <dma_buf_kmap>`
+
+   :c:func:`void dma_buf_kunmap(struct dma_buf *, unsigned long, void *) <dma_buf_kunmap>`
+
+There are also atomic variants of these interfaces. Like for kmap they
+facilitate non-blocking fast-paths. Neither the importer nor the exporter (in
+the callback) is allowed to block when using these.
+
+Interfaces:
+   :c:func:`void *dma_buf_kmap_atomic(struct dma_buf *, unsigned long) <dma_buf_kmap_atomic>`
+
+   :c:func:`void dma_buf_kunmap_atomic(struct dma_buf *, unsigned long, void *) <dma_buf_kunmap_atomic>`
+
+For importers all the restrictions of using kmap apply, like the limited
+supply of kmap_atomic slots. Hence an importer shall only hold onto at most 2
+atomic dma_buf kmaps at the same time (in any given process context).
+
+``dma_buf kmap`` calls outside of the range specified in ``begin_cpu_access`` are
+undefined. If the range is not ``PAGE_SIZE`` aligned, kmap needs to succeed on
+the partial chunks at the beginning and end but may return stale or bogus
+data outside of the range (in these partial chunks).
+
+Note that these calls need to always succeed. The exporter needs to complete
+any preparations that might fail in ``begin_cpu_access()``.
+
+For some cases the overhead of kmap can be too high, a vmap interface
+is introduced. This interface should be used very carefully, as vmalloc
+space is a limited resources on many architectures.
+
+Interfaces:
+   :c:func:`void *dma_buf_vmap(struct dma_buf *dmabuf) <dma_buf_vmap>`
+
+   :c:func:`void dma_buf_vunmap(struct dma_buf *dmabuf, void *vaddr) <dma_buf_vunmap>`
+
+The vmap call can fail if there is no vmap support in the exporter, or if it
+runs out of vmalloc space. Fallback to kmap should be implemented. Note that
+the dma-buf layer keeps a reference count for all vmap access and calls down
+into the exporter's vmap function only when no vmapping exists, and only
+unmaps it once. Protection against concurrent vmap/vunmap calls is provided
+by taking the ``dma_buf->lock`` mutex.
+
+Finish access
+-------------
+
+When the importer is done accessing the CPU, it needs to announce this to
+the exporter (to facilitate cache flushing and unpinning of any pinned
+resources). The result of any dma_buf kmap calls after end_cpu_access is
+undefined.
+
+Interface:
+   :c:func:`void dma_buf_end_cpu_access(struct dma_buf *dma_buf, enum dma_data_direction dir) <dma_buf_end_cpu_access>`
+
+
+Direct Userspace Access/mmap Support
+====================================
+
+Being able to mmap an export dma-buf buffer object has 2 main use-cases:
+
+* CPU fallback processing in a pipeline and
+* supporting existing mmap interfaces in importers.
+
+CPU fallback processing in a pipeline
+-------------------------------------
+
+In many processing pipelines it is sometimes required that the cpu can access
+the data in a dma-buf (e.g. for thumbnail creation, snapshots, ...). To avoid
+the need to handle this specially in userspace frameworks for buffer sharing
+it's ideal if the dma_buf ``fd`` itself can be used to access the backing storage
+from userspace using mmap.
+
+Furthermore Android's ION framework already supports this (and is otherwise
+rather similar to dma-buf from a userspace consumer side with using fds as
+handles, too). So it's beneficial to support this in a similar fashion on
+dma-buf to have a good transition path for existing Android userspace.
+
+No special interfaces, userspace simply calls mmap on the dma-buf fd, making
+sure that the cache synchronization ioctl (``DMA_BUF_IOCTL_SYNC``) is *always*
+used when the access happens. Note that ``DMA_BUF_IOCTL_SYNC`` can fail with
+-EAGAIN or -EINTR, in which case it must be restarted.
+
+Some systems might need some sort of cache coherency management e.g. when
+CPU and GPU domains are being accessed through dma-buf at the same time. To
+circumvent this problem there are begin/end coherency markers, that forward
+directly to existing dma-buf device drivers vfunc hooks. Userspace can make
+use of those markers through the ``DMA_BUF_IOCTL_SYNC`` ioctl. The sequence
+would be used like following:
+
+  * mmap dma-buf fd
+  * for each drawing/upload cycle in CPU
+
+    1. SYNC_START ioctl,
+    2. read/write to mmap area
+    3. SYNC_END ioctl.
+
+    This can be repeated as often as you want (with the new data being
+    consumed by the GPU or say scanout device)
+
+  * munmap once you don't need the buffer any more
+
+For correctness and optimal performance, it is always required to use
+``SYNC_START`` and ``SYNC_END`` before and after, respectively, when accessing the
+mapped address. Userspace cannot rely on coherent access, even when there
+are systems where it just works without calling these ioctls.
+
+Supporting existing mmap interfaces in importers
+------------------------------------------------
+
+Similar to the motivation for kernel cpu access it is again important that
+the userspace code of a given importing subsystem can use the same interfaces
+with a imported dma-buf buffer object as with a native buffer object. This is
+especially important for drm where the userspace part of contemporary OpenGL,
+X, and other drivers is huge, and reworking them to use a different way to
+mmap a buffer rather invasive.
+
+The assumption in the current dma-buf interfaces is that redirecting the
+initial mmap is all that's needed. A survey of some of the existing
+subsystems shows that no driver seems to do any nefarious thing like syncing
+up with outstanding asynchronous processing on the device or allocating
+special resources at fault time. So hopefully this is good enough, since
+adding interfaces to intercept pagefaults and allow pte shootdowns would
+increase the complexity quite a bit.
+
+Interface:
+   :c:func:`int dma_buf_mmap(struct dma_buf *, struct vm_area_struct *, unsigned long) <dma_buf_mmap>`
+
+If the importing subsystem simply provides a special-purpose mmap call to set
+up a mapping in userspace, calling ``do_mmap`` with ``dma_buf->file`` will equally
+achieve that for a dma-buf object.
+
+Implementation notes for exporters
+----------------------------------
+
+Because dma-buf buffers have invariant size over their lifetime, the dma-buf
+core checks whether a vma is too large and rejects such mappings. The
+exporter hence does not need to duplicate this check.
+
+Because existing importing subsystems might presume coherent mappings for
+userspace, the exporter needs to set up a coherent mapping. If that's not
+possible, it needs to fake coherency by manually shooting down ptes when
+leaving the cpu domain and flushing caches at fault time. Note that all the
+``dma_buf`` files share the same anon inode, hence the exporter needs to replace
+the ``dma_buf`` file stored in ``vma->vm_file`` with it's own if pte shootdown is
+required. This is because the kernel uses the underlying inode's address_space
+for vma tracking (and hence pte tracking at shootdown time with
+``unmap_mapping_range``).
+
+If the above shootdown dance turns out to be too expensive in certain
+scenarios, we can extend dma-buf with a more explicit cache tracking scheme
+for userspace mappings. But the current assumption is that using mmap is
+always a slower path, so some inefficiencies should be acceptable.
+
+Exporters that shoot down mappings (for any reasons) shall not do any
+synchronization at fault time with outstanding device operations.
+Synchronization is an orthogonal issue to sharing the backing storage of a
+buffer and hence should not be handled by dma-buf itself. This is explicitly
+mentioned here because many people seem to want something like this, but if
+different exporters handle this differently, buffer sharing can fail in
+interesting ways depending upong the exporter (if userspace starts depending
+upon this implicit synchronization).
+
+Other Interfaces Exposed to Userspace on the dma-buf FD
+-------------------------------------------------------
+
+* Since kernel 3.12 the dma-buf FD supports the llseek system call, but only
+  with offset=0 and whence=SEEK_END|SEEK_SET. SEEK_SET is supported to allow
+  the usual size discover pattern size = SEEK_END(0); SEEK_SET(0). Every other
+  llseek operation will report -EINVAL.
+
+  If llseek on dma-buf FDs isn't support the kernel will report -ESPIPE for all
+  cases. Userspace can use this to detect support for discovering the dma-buf
+  size using llseek.
+
+Miscellaneous notes
+-------------------
+
+* Any exporters or users of the dma-buf buffer sharing framework must have
+  a 'select DMA_SHARED_BUFFER' in their respective Kconfigs.
+
+* In order to avoid fd leaks on exec, the FD_CLOEXEC flag must be set
+  on the file descriptor.  This is not just a resource leak, but a
+  potential security hole.  It could give the newly exec'd application
+  access to buffers, via the leaked fd, to which it should otherwise
+  not be permitted access.
+
+The problem with doing this via a separate fcntl() call, versus doing it
+atomically when the fd is created, is that this is inherently racy in a
+multi-threaded app (See `here <https://lwn.net/Articles/236486/>`_). The issue
+is made worse when it is library code opening/creating the file descriptor,
+as the application may not even be aware of the fd's.
+
+To avoid this problem, userspace must have a way to request ``O_CLOEXEC``
+flag be set when the dma-buf fd is created.  So any API provided by
+the exporting driver to create a dmabuf fd must provide a way to let
+userspace control setting of ``O_CLOEXEC`` flag passed in to ``dma_buf_fd()``.
+
+* If an exporter needs to manually flush caches and hence needs to fake
+  coherency for mmap support, it needs to be able to zap all the ptes pointing
+  at the backing storage. Now linux mm needs a struct address_space associated
+  with the struct file stored in ``vma->vm_file`` to do that with the function
+  unmap_mapping_range. But the dma_buf framework only backs every dma_buf fd
+  with the ``anon_file`` struct file, i.e. all dma_bufs share the same file.
+
+Hence exporters need to setup their own file (and address_space) association
+by setting ``vma->vm_file`` and adjusting ``vma->vm_pgoff`` in the ``dma_buf`` mmap
+callback. In the specific case of a gem driver the exporter could use the
+shmem file already provided by gem (and set vm_pgoff = 0). Exporters can then
+zap ptes by unmapping the corresponding range of the struct address_space
+associated with their own file.
diff --git a/Documentation/dma-buf/intro.rst b/Documentation/dma-buf/intro.rst
new file mode 100644
index 000000000000..4ecdbea50e75
--- /dev/null
+++ b/Documentation/dma-buf/intro.rst
@@ -0,0 +1,82 @@
+==================================
+Buffer Sharing and Synchronization
+==================================
+
+
+Introduction
+------------
+
+The dma-buf subsystem provides the framework for sharing buffers for
+hardware (DMA) access across multiple device drivers and subsystems, and
+for synchronizing asynchronous hardware access.
+
+This is used, for example, by drm "prime" multi-GPU support, but is of
+course not limited to GPU use cases.
+
+The three main components of this are:
+
+* dma-buf_: represents an sg_table, and is exposed to userspace as a file
+  descriptor to allow passing between devices,
+
+* fence_: which provides a mechanism to signal when one device has finished
+  access, and
+
+* reservation_: manages the shared or exclusive fence(s) associated with the
+  buffer.
+
+Please refer to :ref:`dma-buf-guide` for more details.
+
+.. _dma-buf:
+
+dma-buf
+~~~~~~~
+
+.. kernel-doc:: drivers/dma-buf/dma-buf.c
+   :export:
+
+.. kernel-doc:: include/linux/dma-buf.h
+   :internal:
+
+.. _fence:
+
+fence
+~~~~~
+
+.. kernel-doc:: drivers/dma-buf/fence.c
+   :export:
+
+.. kernel-doc:: include/linux/fence.h
+   :internal:
+
+.. kernel-doc:: drivers/dma-buf/fence-array.c
+   :export:
+
+.. kernel-doc:: include/linux/fence-array.h
+   :internal:
+
+.. kernel-doc:: drivers/dma-buf/seqno-fence.c
+   :export:
+
+.. kernel-doc:: include/linux/seqno-fence.h
+   :internal:
+
+.. kernel-doc:: drivers/dma-buf/sync_file.c
+   :export:
+
+.. kernel-doc:: include/linux/sync_file.h
+   :internal:
+
+.. _reservation:
+
+reservation
+~~~~~~~~~~~
+
+.. kernel-doc:: drivers/dma-buf/reservation.c
+   :doc: Reservation Object Overview
+
+.. kernel-doc:: drivers/dma-buf/reservation.c
+   :export:
+
+.. kernel-doc:: include/linux/reservation.h
+   :internal:
+
diff --git a/MAINTAINERS b/MAINTAINERS
index 0bbe4b105c34..dd422c6e54fe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3838,7 +3838,7 @@ F:	drivers/dma-buf/
 F:	include/linux/dma-buf*
 F:	include/linux/reservation.h
 F:	include/linux/*fence.h
-F:	Documentation/dma-buf-sharing.txt
+F:	Documentation/dma-buf/
 T:	git git://git.linaro.org/people/sumitsemwal/linux-dma-buf.git
 
 SYNC FILE FRAMEWORK
-- 
2.7.4

