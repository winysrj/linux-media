Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:46553 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab2DFM3f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2012 08:29:35 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, subashrp@gmail.com
Subject: Re: [PATCH 02/11] Documentation: media: description of DMABUF importing in V4L2
Date: Fri, 06 Apr 2012 14:29:39 +0200
Message-ID: <2361050.zIXeqySOhx@avalon>
In-Reply-To: <1333634408-4960-3-git-send-email-t.stanislaws@samsung.com>
References: <1333634408-4960-1-git-send-email-t.stanislaws@samsung.com> <1333634408-4960-3-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thanks for the patch.

On Thursday 05 April 2012 15:59:59 Tomasz Stanislawski wrote:
> This patch adds description and usage examples for importing
> DMABUF file descriptor in V4L2.

[snip]

> diff --git a/Documentation/DocBook/media/v4l/io.xml
> b/Documentation/DocBook/media/v4l/io.xml index b815929..2a32363 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -472,6 +472,160 @@ rest should be evident.</para>
>        </footnote></para>
>    </section>
> 
> +  <section id="dmabuf">
> +    <title>Streaming I/O (DMA buffer importing)</title>

This section is very similar to the Streaming I/O (User Pointers) section. Do 
you think we should merge the two ?

> +    <note>
> +      <title>Experimental</title>
> +      <para>This is an <link linkend="experimental"> experimental </link>
> +      interface and may change in the future.</para>
> +    </note>
> +
> +<para>The DMABUF framework was introduced to provide a generic mean for
> sharing buffers between multiple HW devices. Some device drivers provide
> an API that may be capable to export a DMA buffer as a DMABUF file
> descriptor. The other device drivers may be configured to use such a
> buffer. They implements an API for importing of DMABUF. This section
> describes the support of DMABUF importing in V4L2.</para>

I would rephrase this as follows:

<para>The DMABUF framework provides a generic mean for sharing buffers between
 multiple devices. Device drivers that support DMABUF can export a DMA buffer 
to userspace as a file descriptor (known as the exporter role), import a DMA 
buffer from userspace using a file descriptor previously exported for a 
different or the same device (known as the importer role), or both. This 
section describes the DMABUF importer role API in V4L2.</para>

> +    <para>Input and output devices support this I/O method when the
> +<constant>V4L2_CAP_STREAMING</constant> flag in the
> +<structfield>capabilities</structfield> field of &v4l2-capability; returned
> by the &VIDIOC-QUERYCAP; ioctl is set. If the particular importing buffer
> via DMABUF file descriptors method is supported must be determined by
> calling the &VIDIOC-REQBUFS; ioctl.</para>

What about

<para>Input and output devices support the streaming I/O method when the 
<constant>V4L2_CAP_STREAMING</constant> flag in the 
<structfield>capabilities</structfield> field of &v4l2-capability; returned by 
the &VIDIOC-QUERYCAP; ioctl is set. Whether importing DMA buffers through 
DMABUF file descriptors is supported is determined by calling the &VIDIOC-
REQBUFS; ioctl with the memory type set to 
<constant>V4L2_MEMORY_DMABUF</constant>.</para>

> +    <para>This I/O method is dedicated for sharing DMA buffers between V4L
> and other APIs. Buffers (planes) are allocated by the application itself
> using a client API. The buffers must be exported as DMABUF file descriptor.

I would say that "Buffers (planes) are allocated by a driver on behalf of the 
application, and exported to the application as file descriptors using an API 
specific to the allocator driver."

> Only those file descriptor are exchanged, these files and meta-information
> are passed in &v4l2-buffer; (or in &v4l2-plane; in the multi-planar API
> case).  The driver must be switched into DMABUF I/O mode by calling the
> &VIDIOC-REQBUFS; with the desired buffer type. No buffers (planes) are
> allocated beforehand, consequently they are not indexed and cannot be
> queried like mapped buffers with the <constant>VIDIOC_QUERYBUF</constant>
> ioctl.</para>

[snip]

> +    <para>Filled or displayed buffers are dequeued with the
> +&VIDIOC-DQBUF; ioctl. The driver can unpin the buffer at any
> +time between the completion of the DMA and this ioctl. The memory is
> +also unpinned when &VIDIOC-STREAMOFF; is called, &VIDIOC-REQBUFS;, or
> +when the device is closed.</para>
>
> +    <para>For capturing applications it is customary to enqueue a
> +number of empty buffers, to start capturing and enter the read loop.
> +Here the application waits until a filled buffer can be dequeued, and
> +re-enqueues the buffer when the data is no longer needed. Output
> +applications fill and enqueue buffers, when enough buffers are stacked
> +up output is started. In the write loop, when the application
> +runs out of free buffers it must wait until an empty buffer can be
> +dequeued and reused. Two methods exist to suspend execution of the
> +application until one or more buffers can be dequeued. By default
> +<constant>VIDIOC_DQBUF</constant> blocks when no buffer is in the
> +outgoing queue. When the <constant>O_NONBLOCK</constant> flag was
> +given to the &func-open; function, <constant>VIDIOC_DQBUF</constant>
> +returns immediately with an &EAGAIN; when no buffer is available. The
> +&func-select; or &func-poll; function are always available.</para>
> +
> +    <para>To start and stop capturing or output applications call the
> +&VIDIOC-STREAMON; and &VIDIOC-STREAMOFF; ioctl.

s/ioctl/ioctls.

> + Note <constant>VIDIOC_STREAMOFF</constant> removes all buffers from both

s/Note/Note that/

> + queues and unlocks/unpins all buffers as a side effect. Since there is no
> + notion of doing anything "now" on a multitasking system, if an application
> + needs to synchronize with another event it should examine the &v4l2-
> + buffer; <structfield>timestamp</structfield> of captured buffers, or set
> + the field before enqueuing buffers for output.</para>
> +
> +    <para>Drivers implementing user pointer I/O must support the
> +<constant>VIDIOC_REQBUFS</constant>, <constant>VIDIOC_QBUF</constant>,
> +<constant>VIDIOC_DQBUF</constant>, <constant>VIDIOC_STREAMON</constant> and
> +<constant>VIDIOC_STREAMOFF</constant> ioctl, the
> <function>select()</function> and <function>poll()</function>
> function.</para>
> +
> +  </section>
> +
>    <section id="async">
>      <title>Asynchronous I/O</title>
> 
> @@ -671,6 +825,14 @@ memory, set by the application. See <xref
> linkend="userp" /> for details. <structname>v4l2_buffer</structname>
> structure.</entry>
>  	  </row>
>  	  <row>
> +	    <entry></entry>
> +	    <entry>int</entry>
> +	    <entry><structfield>fd</structfield></entry>
> +	    <entry>For the single-planar API and when

s/single-planar/single-plane/

> +<structfield>memory</structfield> is
> <constant>V4L2_MEMORY_DMABUF</constant> this is the file descriptor
> associated with a DMABUF buffer.</entry>
> +	  </row>
> +	  <row>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>length</structfield></entry>
>  	    <entry></entry>

[snip]

> diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml index 9caa49a..d4f212f
> 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> @@ -112,6 +112,21 @@ they cannot be swapped out to disk. Buffers remain
> locked until dequeued, until the &VIDIOC-STREAMOFF; or &VIDIOC-REQBUFS;
> ioctl is called, or until the device is closed.</para>
> 
> +    <para>To enqueue a <link linkend="dmabuf">DMABUF</link> buffer
> applications set the <structfield>memory</structfield> field to
> <constant>V4L2_MEMORY_DMABUF</constant>, the <structfield>m.fd</structfield>

s/,/ and/

> +field to the file descriptor to a DMABUF buffer.

"to a file descriptor associated with a DMABUF buffer."

> When the multi-planar API is used, <structfield>m.fd</structfield> of the
> passed array of &v4l2-plane; have to be used instead. When
> <constant>VIDIOC_QBUF</constant> is called with a pointer to this structure
> the driver sets the
> +<constant>V4L2_BUF_FLAG_QUEUED</constant> flag and clears the
> +<constant>V4L2_BUF_FLAG_MAPPED</constant> and
> +<constant>V4L2_BUF_FLAG_DONE</constant> flags in the
> +<structfield>flags</structfield> field, or it returns an error code.  This
> +ioctl may pin and lock the buffer. Buffers remain locked/pinned until
> dequeued, until the &VIDIOC-STREAMOFF; or &VIDIOC-REQBUFS; ioctl is called,
> or until the device is closed.</para>

I'm not sure if we should really mention memory pinning, especially if the 
ioctl "may" pin and lock the buffer instead of "must" or "will". BTW, what 
difference do you make between "pin" and "lock" in this context ?

>      <para>Applications call the <constant>VIDIOC_DQBUF</constant>
>  ioctl to dequeue a filled (capturing) or displayed (output) buffer
>  from the driver's outgoing queue. They just set the
> diff --git a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
> b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml index 7be4b1d..d758622
> 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-reqbufs.xml
> @@ -50,11 +50,14 @@
> 
>      <para>This ioctl is used to initiate <link linkend="mmap">memory
>  mapped</link> or <link linkend="userp">user pointer</link>
> -I/O. Memory mapped buffers are located in device memory and must be
> +I/O or <link linkend="dmabuf">DMABUF file descriptors</link>.

<para>This ioctl is used to initiate <link linkend="mmap">memory 
mapped</link>, <link linkend="userp">user pointer</link> or <link 
linkend="dmabuf">DMABUF</link> based I/O.

> +Memory mapped buffers are located in device memory and must be
>  allocated with this ioctl before they can be mapped into the
>  application's address space. User buffers are allocated by
>  applications themselves, and this ioctl is merely used to switch the
> -driver into user pointer I/O mode and to setup some internal 
structures.</para>
> +driver into user pointer I/O mode and to setup some internal structures.

> +A DMABUF file descriptor is a generic carrier for HW allocated buffers
> +dedicated to share them between multimedia APIs.</para>

What about

Similarly, DMABUF buffers are allocated by applications through a device 
driver, and this ioctl only configures the driver into DMABUF I/O mode without 
performing any direct allocation.</para>

>      <para>To allocate device buffers applications initialize all
>  fields of the <structname>v4l2_requestbuffers</structname> structure.
> @@ -103,6 +106,7 @@ as the &v4l2-format; <structfield>type</structfield>
> field. See <xref <entry><structfield>memory</structfield></entry>
>  	    <entry>Applications set this field to
>  <constant>V4L2_MEMORY_MMAP</constant> or

s/ or/,/

> +<constant>V4L2_MEMORY_DMABUF</constant> or
>  <constant>V4L2_MEMORY_USERPTR</constant>.</entry>
>  	  </row>
>  	  <row>
-- 
Regards,

Laurent Pinchart

