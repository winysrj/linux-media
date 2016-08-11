Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38541 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbcHKMtj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Aug 2016 08:49:39 -0400
Received: by mail-wm0-f41.google.com with SMTP id o80so13950405wme.1
        for <linux-media@vger.kernel.org>; Thu, 11 Aug 2016 05:49:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB6B88B-C9E4-4213-A8A2-7BB39EC9B5F6@darmarit.de>
References: <1470912480-32304-1-git-send-email-sumit.semwal@linaro.org>
 <1470912480-32304-4-git-send-email-sumit.semwal@linaro.org> <CAB6B88B-C9E4-4213-A8A2-7BB39EC9B5F6@darmarit.de>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 11 Aug 2016 18:19:17 +0530
Message-ID: <CAO_48GG6HqpQLjpZt-qDo1mh_re4_DAZUc0hZJ1EuoJKa=ee1A@mail.gmail.com>
Subject: Re: [RFC 3/4] Documentation: move dma-buf documentation to rst
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linaro MM SIG Mailman List <linaro-mm-sig@lists.linaro.org>,
	linux-doc@vger.kernel.org, Jon Corbet <corbet@lwn.net>,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

On 11 August 2016 at 17:28, Markus Heiser <markus.heiser@darmarit.de> wrote:
> Hi Sumit,
>
> I haven't compiled your patch yet, just my 2cent about the
> reStructuredText (reST) ASCII markup ...
>
Thanks very much for your detailed review comments - highly appreciated!

> Here are some handy links about reST and the Sphinx markup constructs,
> we have not yet added to the documentation (sorry):
>
> * reST primer:    http://www.sphinx-doc.org/en/stable/rest.html
> * reST quickref:  http://docutils.sourceforge.net/docs/user/rst/quickref.html
> * Sphinx markup constructs: http://www.sphinx-doc.org/en/stable/markup/index.html
> * Sphinx domains: http://www.sphinx-doc.org/en/stable/domains.html
> * Sphinx cross references:  http://www.sphinx-doc.org/en/stable/markup/inline.html#cross-referencing-arbitrary-locations
>
> Am 11.08.2016 um 12:47 schrieb Sumit Semwal <sumit.semwal@linaro.org>:
>
>> Branch out dma-buf related documentation into its own rst file to allow
>> adding it to the sphinx documentation generated.
>>
>> While at it, move dma-buf-sharing.txt into rst as the dma-buf guide too.
>>
>> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
> ...
>> +dma-buf operations for device dma only
>> +======================================
>> +
>> +The dma_buf buffer sharing API usage contains the following steps:
>> +
>> +1. Exporter announces that it wishes to export a buffer
>> +2. Userspace gets the file descriptor associated with the exported buffer, and
>> +   passes it around to potential buffer-users based on use case
>> +3. Each buffer-user 'connects' itself to the buffer
>> +4. When needed, buffer-user requests access to the buffer from exporter
>> +5. When finished with its use, the buffer-user notifies end-of-DMA to exporter
>> +6. when buffer-user is done using this buffer completely, it 'disconnects'
>> +   itself from the buffer.
>> +
>> +
>> +1. Exporter's announcement of buffer export
>> +-------------------------------------------
>
> I can't recommend numbering the (sub-) sections explicit, even if you here
> wanted to numerate the steps. Most often section numbers are controlled by
> the subordinate toctree directive and this might not fit to the step
> numbers.
>
> * http://www.sphinx-doc.org/en/stable/markup/toctree.html?highlight=toc#the-toc-tree
>
>> +
>> +   The buffer exporter announces its wish to export a buffer. In this, it
>> +   connects its own private buffer data, provides implementation for operations
>> +   that can be performed on the exported :c:type:`dma_buf`, and flags for the file
>> +   associated with this buffer. All these fields are filled in struct
>> +   :c:type:`dma_buf_export_info`, defined via the DEFINE_DMA_BUF_EXPORT_INFO macro.
>> +
>
> In restructuredText whitespace are markups.
>
> Do not indent if you don't want to create a (indented) block. I recommend to drop
> the two spaces in front of the paragraphs.
>
> IMHO you have to decide if you like to use sectioning (drop the to spaces)
> or stay with the two spaces and use an enumeration list. If you wan't to stay
> with the enumeration write:
>
> |1. Exporter's announcement of buffer export
> |
> |   The buffer exporter announces its wish to export a buffer. In this, it
> |   connects its own private buffer ..
> |   ...
>
>
Understood; will correct.

>> +   Interface:
>> +      :c:type:`DEFINE_DMA_BUF_EXPORT_INFO(exp_info) <DEFINE_DMA_BUF_EXPORT_INFO>`
>
> If haven't tested your patch, but I guess this will result in a Warning.
>
> the markup ":c:type" is a reference to a typedef description
>
> * http://www.sphinx-doc.org/en/stable/domains.html#role-c:type
>
> If the description is given, you can use the short form
>
> :c:type:`DEFINE_DMA_BUF_EXPORT_INFO`
>
> but I think, this is a function, not a typedef.
>
I did test it before sending out the RFC, and didn't get any warnings.
This, btw, is a macro, so I guess that's why no warning.

While on this topic, in my experimentation, if I just use the short
form, the resultant text doesn't include the "(exp_info)" part as
shown above.

>> +
>> +      :c:func:`struct dma_buf *dma_buf_export(struct dma_buf_export_info *exp_info)<dma_buf_export>`
>
> short form to refer
>
>  :c:func:`dma_buf_export()`
>
When I last tried the short form, it only gave me a link to the full
definition, and I wanted to have the arguments also shown here, so
that the explanation below was easier. Though I think I tried without
the (), so will try again and let you know.

>> +
>> +   If this succeeds, dma_buf_export allocates a dma_buf structure, and
>> +   returns a pointer to the same. It also associates an anonymous file with this
>> +   buffer, so it can be exported. On failure to allocate the dma_buf object,
>> +   it returns NULL.
>> +
>> +   'exp_name' in struct dma_buf_export_info is the name of exporter - to
>> +   facilitate information while debugging. It is set to KBUILD_MODNAME by
>
> If you want to render a constant in a monospace font you can use the
> inline markup ``KBUILD_MODNAME``, but if you want.
>
Thanks, will do.

>> +   default, so exporters don't have to provide a specific name, if they don't
>> +   wish to.
>> +
>> +   DEFINE_DMA_BUF_EXPORT_INFO macro defines the struct dma_buf_export_info,
>> +   zeroes it out and pre-populates exp_name in it.
>> +
>> +2. Userspace gets a handle to pass around to potential buffer-users
>> +-------------------------------------------------------------------
>> +
>> +   Userspace entity requests for a file-descriptor (fd) which is a handle to the
>> +   anonymous file associated with the buffer. It can then share the fd with other
>> +   drivers and/or processes.
>> +
>> +   Interface:
>> +      :c:func:`int dma_buf_fd(struct dma_buf *dmabuf, int flags) <dma_buf_fd>`
>> +
>> +   This API installs an fd for the anonymous file associated with this buffer;
>> +   returns either 'fd', or error.
>
> I recommend to markup source code objects uniform with ``fd``.
>
Ok.
>> +
>> +3. Each buffer-user 'connects' itself to the buffer
>> +---------------------------------------------------
>> +
>> +   Each buffer-user now gets a reference to the buffer, using the fd passed to
>> +   it.
>> +
>> +   Interface:
>> +      :c:func:`struct dma_buf *dma_buf_get(int fd) <dma_buf_get>`
>> +
>> +   This API will return a reference to the dma_buf, and increment refcount for
>> +   it.
>> +
>> +   After this, the buffer-user needs to attach its device with the buffer, which
>> +   helps the exporter to know of device buffer constraints.
>> +
>> +   Interface:
>> +      :c:func:`struct dma_buf_attachment *dma_buf_attach(struct dma_buf *dmabuf, struct device *dev) <dma_buf_attach>`
>> +
>> +   This API returns reference to an attachment structure, which is then used
>> +   for scatterlist operations. It will optionally call the 'attach' dma_buf
>> +   operation, if provided by the exporter.
>> +
>> +   The dma-buf sharing framework does the bookkeeping bits related to managing
>> +   the list of all attachments to a buffer.
>> +
>> +.. note:: Until this stage, the buffer-exporter has the option to choose not to
>> +   actually allocate the backing storage for this buffer, but wait for the
>> +   first buffer-user to request use of buffer for allocation.
>
> Use newlines ... which are markups in reST ;)
>
> .. note::
>
>  Until this stage, the buffer-exporter has the option to choose not to
>  actually allocate the backing storage for this buffer, but wait for the
>  first buffer-user to request use of buffer for allocation.
>
>
Ok :), will correct.

>> +6. when buffer-user is done using this buffer, it 'disconnects' itself from the buffer.
>> +---------------------------------------------------------------------------------------
>> +
>> +   After the buffer-user has no more interest in using this buffer, it should
>> +   disconnect itself from the buffer:
>> +
>> +   * it first detaches itself from the buffer.
>> +
>> +   Interface:
>> +      :c:func:`void dma_buf_detach(struct dma_buf *dmabuf, struct dma_buf_attachment *dmabuf_attach) <dma_buf_detach>`
>> +
>> +   This API removes the attachment from the list in dmabuf, and optionally calls
>> +   dma_buf->ops->detach(), if provided by exporter, for any housekeeping bits.
>> +
>> +   * Then, the buffer-user returns the buffer reference to exporter.
>> +
>> +   Interface:
>> +     :c:func:`void dma_buf_put(struct dma_buf *dmabuf) <dma_buf_put>`
>> +
>> +   This API then reduces the refcount for this buffer.
>> +
>> +   If, as a result of this call, the refcount becomes 0, the 'release' file
>> +   operation related to this fd is called. It calls the dmabuf->ops->release()
>> +   operation in turn, and frees the memory allocated for dmabuf when exported.
>> +
>> +NOTES:
>> +------
>> +
>
> I can't recommend to use colons in titles.
>
Ok, will remove them.

>> +* **Importance of attach-detach and {map,unmap}_dma_buf operation pairs**
>> +
>> +   The attach-detach calls allow the exporter to figure out backing-storage
>
> only 2 spaces are needed here ... whitespaces are markups ;)
>
Right, got the message;)

>> +   constraints for the currently-interested devices. This allows preferential
>> +   allocation, and/or migration of pages across different types of storage
>> +   available, if possible.
>> +
>> +   Bracketing of DMA access with {map,unmap}_dma_buf operations is essential
>> +   to allow just-in-time backing of storage, and migration mid-way through a
>> +   use-case.
>
>> +
>> +* **Migration of backing storage if needed**
>> +
>
> I can't recommend this style, using a list and a first  bold line to emulate
> something what looks like a subsection .. use subsections or leave the bold line.
>
Yes, that's right; will correct.
>
>
>> +   If after
>> +
>> +   * at least one map_dma_buf has happened,
>> +   * and the backing storage has been allocated for this buffer,
>> +
>> +   another new buffer-user intends to attach itself to this buffer, it might
>> +   be allowed, if possible for the exporter.
>> +
>> +   In case it is allowed by the exporter:
>> +
>> +   * if the new buffer-user has stricter 'backing-storage constraints', and the
>> +     exporter can handle these constraints, the exporter can just stall on the
>> +     map_dma_buf until all outstanding access is completed (as signalled by
>> +     unmap_dma_buf).
>> +
>> +   * Once all users have finished accessing and have unmapped this buffer, the
>> +     exporter could potentially move the buffer to the stricter backing-storage,
>> +     and then allow further {map,unmap}_dma_buf operations from any buffer-user
>> +     from the migrated backing-storage.
>> +
>> +   * If the exporter cannot fulfill the backing-storage constraints of the new
>> +     buffer-user device as requested, dma_buf_attach() would return an error to
>> +     denote non-compatibility of the new buffer-sharing request with the current
>> +     buffer.
>> +
>> +
>> +   If the exporter chooses not to allow an attach() operation once a
>> +   map_dma_buf() API has been called, it simply returns an error.
>> +
>> +Kernel cpu access to a dma-buf buffer object
>> +============================================
>> +
>> +The motivation to allow cpu access from the kernel to a dma-buf object from the
>> +importers side are:
>> +
>> +* fallback operations, e.g. if the devices is connected to a usb bus and the
>> +  kernel needs to shuffle the data around first before sending it away.
>> +* full transparency for existing users on the importer side, i.e. userspace
>> +  should not notice the difference between a normal object from that subsystem
>> +  and an imported one backed by a dma-buf. This is really important for drm
>> +  opengl drivers that expect to still use all the existing upload/download
>> +  paths.
>
> I is recommended to separate blocks (in this case the list item blocks) with
> a newline. E.g.
>
> * first lorem
>  ipsum
>
> * second lorem
>  ipsum
>
> If you have only one-liners, it is OK to write
>
> * first
> * second
>

Understood, good tip for me.
>> +
>> +Access to a dma_buf from the kernel context involves three steps:
>> +
>> +1. Prepare access, which invalidate any necessary caches and make the object
>> +   available for cpu access.
>> +2. Access the object page-by-page with the dma_buf map apis
>> +3. Finish access, which will flush any necessary cpu caches and free reserved
>> +   resources.
>> +:`void dma_buf_end_cpu_access(struct dma_buf *dma_buf, enum dma_data_direction dir) <dma_buf_end_cpu_access>`
>> +
>> +
>> +Direct Userspace Access/mmap Support
>> +====================================
>> +
>> +Being able to mmap an export dma-buf buffer object has 2 main use-cases:
>> +* CPU fallback processing in a pipeline and
>> +* supporting existing mmap interfaces in importers.
>> +
>
> Insert a newline in front of the list.
>
Ok.

>> +1. CPU fallback processing in a pipeline
>> +----------------------------------------
>> +
>> +   In many processing pipelines it is sometimes required that the cpu can access
>> +   the data in a dma-buf (e.g. for thumbnail creation, snapshots, ...). To avoid
>> +   the need to handle this specially in userspace frameworks for buffer sharing
>> +   it's ideal if the dma_buf fd itself can be used to access the backing storage
>> +   from userspace using mmap.
>> +
>> +   Furthermore Android's ION framework already supports this (and is otherwise
>> +   rather similar to dma-buf from a userspace consumer side with using fds as
>> +   handles, too). So it's beneficial to support this in a similar fashion on
>> +   dma-buf to have a good transition path for existing Android userspace.
>> +
>> +   No special interfaces, userspace simply calls mmap on the dma-buf fd, making
>> +   sure that the cache synchronization ioctl (DMA_BUF_IOCTL_SYNC) is *always*
>> +   used when the access happens. Note that DMA_BUF_IOCTL_SYNC can fail with
>> +   -EAGAIN or -EINTR, in which case it must be restarted.
>> +
>> +   Some systems might need some sort of cache coherency management e.g. when
>> +   CPU and GPU domains are being accessed through dma-buf at the same time. To
>> +   circumvent this problem there are begin/end coherency markers, that forward
>> +   directly to existing dma-buf device drivers vfunc hooks. Userspace can make
>> +   use of those markers through the DMA_BUF_IOCTL_SYNC ioctl. The sequence
>> +   would be used like following:
>> +
>> +     * mmap dma-buf fd
>> +     * for each drawing/upload cycle in CPU
>> +
>> +       1. SYNC_START ioctl,
>> +       2. read/write to mmap area
>> +       3. SYNC_END ioctl.
>> +
>> +       This can be repeated as often as you want (with the new data being
>> +       consumed by the GPU or say scanout device)
>> +     * munmap once you don't need the buffer any more
>> +
>
> see above, use newline to separate last list item from the one before
>
Ok.
>> +    For correctness and optimal performance, it is always required to use
>> +    SYNC_START and SYNC_END before and after, respectively, when accessing the
>> +    mapped address. Userspace cannot rely on coherent access, even when there
>> +    are systems where it just works without calling these ioctls.
>> +
>>
>> +Introduction
>> +------------
>> +
>> +The dma-buf subsystem provides the framework for sharing buffers for
>> +hardware (DMA) access across multiple device drivers and subsystems, and
>> +for synchronizing asynchronous hardware access.
>> +
>> +This is used, for example, by drm "prime" multi-GPU support, but is of
>> +course not limited to GPU use cases.
>> +
>> +The three main components of this are:
>> +
>> +* dma-buf_: represents an sg_table, and is exposed to userspace as a file
>> +  descriptor to allow passing between devices,
>> +
>> +* fence_: which provides a mechanism to signal when one device has finished
>> +  access, and
>> +
>> +* reservation_: manages the shared or exclusive fence(s) associated with the
>> +  buffer.
>> +
>> +Please refer to :ref:`DMA buffer sharing guide <dma-buf-guide>` for more details.
>
> alternative you can use the short form :ref:`dma-buf-guide`, depends on the
> context from which you refer and the targets title.
>
Will try that out.

> But over all, I wan't say: thanks for your work :)
>
Thanks to you too, appreciate you taking time to read through this whole doc! :)
> -- Markus --
>
>
BR,
Sumit.



-- 
Thanks and regards,

Sumit Semwal
Linaro Mobile Group - Kernel Team Lead
Linaro.org │ Open source software for ARM SoCs
