Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14260 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab2IUQhe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Sep 2012 12:37:34 -0400
Received: from eusync1.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAP009K6KVE7Y30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Sep 2012 17:38:02 +0100 (BST)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MAP000VAKUJ0L20@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 21 Sep 2012 17:37:32 +0100 (BST)
Message-id: <505C97CB.40709@samsung.com>
Date: Fri, 21 Sep 2012 18:37:31 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 6/6] DocBook: various updates w.r.t. v4l2_buffer and
 multiplanar.
References: <1348065460-1624-1-git-send-email-hverkuil@xs4all.nl>
 <499780c9daeee902db65382be3bdf481d205e99c.1348064901.git.hans.verkuil@cisco.com>
In-reply-to: <499780c9daeee902db65382be3bdf481d205e99c.1348064901.git.hans.verkuil@cisco.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/19/2012 04:37 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Clarify the behavior of v4l2_buffer in the multiplanar case,
> including fixing a false statement: you can't set m.planes to NULL
> when calling DQBUF.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

I'm not sure what was main argument for not requiring applications to 
pass the planes array in to VIDIOC_DQBUF. Maybe, to avoid copying the 
planes array so performance is improved when applications don't need 
all information from struct v4l2_plane after each DQBUF. So I'm not 
sure about DQBUF. But improving querybuf sounds like a reasonable thing 
to do. So far num_planes have had to be passed in by applications, as 
returned from S_FMT/G_FMT. There seems to be no way to verify how many
planes are valid based on VIDIOC_QUERYBUF output.

Anyway, both changes shouldn't be a big deal for existing applications. 
They should just make sure the pointer to the planes array is passed, 
which most probably already do. I'm OK with this change, it shouldn't 
be a big issue for applications using s5p drivers. 

> ---
>  Documentation/DocBook/media/v4l/io.xml              |    6 ++++--
>  Documentation/DocBook/media/v4l/vidioc-qbuf.xml     |    3 +--
>  Documentation/DocBook/media/v4l/vidioc-querybuf.xml |   11 +++++++----
>  3 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index 1885cc0..c6d39fe 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -677,8 +677,10 @@ memory, set by the application. See <xref linkend="userp" /> for details.
>  	    <entry><structfield>length</structfield></entry>
>  	    <entry></entry>
>  	    <entry>Size of the buffer (not the payload) in bytes for the
> -	    single-planar API. For the multi-planar API should contain the
> -	    number of elements in the <structfield>planes</structfield> array.
> +	    single-planar API. For the multi-planar API the application sets
> +	    this to the number of elements in the <structfield>planes</structfield>
> +	    array. The driver will fill in the actual number of valid elements in
> +	    that array.
>  	    </entry>
>  	  </row>
>  	  <row>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> index 6a821a6..2d37abe 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> @@ -121,8 +121,7 @@ remaining fields or returns an error code. The driver may also set
>  field. It indicates a non-critical (recoverable) streaming error. In such case
>  the application may continue as normal, but should be aware that data in the
>  dequeued buffer might be corrupted. When using the multi-planar API, the
> -planes array does not have to be passed; the <structfield>m.planes</structfield>
> -member must be set to NULL in that case.</para>
> +planes array must be passed in as well.</para>
>  
>      <para>By default <constant>VIDIOC_DQBUF</constant> blocks when no
>  buffer is in the outgoing queue. When the
> diff --git a/Documentation/DocBook/media/v4l/vidioc-querybuf.xml b/Documentation/DocBook/media/v4l/vidioc-querybuf.xml
> index 6e414d7..a597155 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-querybuf.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-querybuf.xml
> @@ -48,8 +48,8 @@
>    <refsect1>
>      <title>Description</title>
>  
> -    <para>This ioctl is part of the <link linkend="mmap">memory
> -mapping</link> I/O method. It can be used to query the status of a
> +    <para>This ioctl is part of the <link linkend="mmap">streaming
> +</link> I/O method. It can be used to query the status of a
>  buffer at any time after buffers have been allocated with the
>  &VIDIOC-REQBUFS; ioctl.</para>
>  
> @@ -71,6 +71,7 @@ the structure.</para>
>  
>      <para>In the <structfield>flags</structfield> field the
>  <constant>V4L2_BUF_FLAG_MAPPED</constant>,
> +<constant>V4L2_BUF_FLAG_PREPARED</constant>,
>  <constant>V4L2_BUF_FLAG_QUEUED</constant> and
>  <constant>V4L2_BUF_FLAG_DONE</constant> flags will be valid. The
>  <structfield>memory</structfield> field will be set to the current
> @@ -79,8 +80,10 @@ contains the offset of the buffer from the start of the device memory,
>  the <structfield>length</structfield> field its size. For the multi-planar API,
>  fields <structfield>m.mem_offset</structfield> and
>  <structfield>length</structfield> in the <structfield>m.planes</structfield>
> -array elements will be used instead. The driver may or may not set the remaining
> -fields and flags, they are meaningless in this context.</para>
> +array elements will be used instead and the <structfield>length</structfield>
> +field of &v4l2-buffer; is set to the number of filled-in array elements.
> +The driver may or may not set the remaining fields and flags, they are
> +meaningless in this context.</para>
>  
>      <para>The <structname>v4l2_buffer</structname> structure is
>      specified in <xref linkend="buffer" />.</para>

Regards,
Sylwester
