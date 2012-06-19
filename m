Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56919 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2FSTzy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jun 2012 15:55:54 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	airlied@redhat.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, sumit.semwal@ti.com, daeinki@gmail.com,
	daniel.vetter@ffwll.ch, robdclark@gmail.com, pawel@osciak.com,
	linaro-mm-sig@lists.linaro.org, hverkuil@xs4all.nl,
	remi@remlab.net, subashrp@gmail.com, mchehab@redhat.com,
	g.liakhovetski@gmx.de, linux-doc@vger.kernel.org
Subject: Re: [PATCHv7 02/15] Documentation: media: description of DMABUF importing in V4L2
Date: Tue, 19 Jun 2012 21:56:04 +0200
Message-ID: <1434318.6p4M9j2usm@avalon>
In-Reply-To: <1339681069-8483-3-git-send-email-t.stanislaws@samsung.com>
References: <1339681069-8483-1-git-send-email-t.stanislaws@samsung.com> <1339681069-8483-3-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

Thanks for the patch.

On Thursday 14 June 2012 15:37:36 Tomasz Stanislawski wrote:
> This patch adds description and usage examples for importing
> DMABUF file descriptor in V4L2.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: linux-doc@vger.kernel.org

I just have a couple of minor comments, after taking them into account you can 
add

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/DocBook/media/v4l/compat.xml         |    4 +
>  Documentation/DocBook/media/v4l/io.xml             |  179 +++++++++++++++++
>  .../DocBook/media/v4l/vidioc-create-bufs.xml       |    3 +-
>  Documentation/DocBook/media/v4l/vidioc-qbuf.xml    |   15 ++
>  Documentation/DocBook/media/v4l/vidioc-reqbufs.xml |   47 ++---
>  5 files changed, 225 insertions(+), 23 deletions(-)
> 

[snip]

> diff --git a/Documentation/DocBook/media/v4l/io.xml
> b/Documentation/DocBook/media/v4l/io.xml index fd6aca2..f55b0ab 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml

[snip]

> +    <example>
> +      <title>Initiating streaming I/O with DMABUF file descriptors</title>
> +
> +      <programlisting>
> +&v4l2-requestbuffers; reqbuf;
> +
> +memset (&amp;reqbuf, 0, sizeof (reqbuf));
> +reqbuf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +reqbuf.memory = V4L2_MEMORY_DMABUF;

You need to set reqbuf.count to a non-zero value.

> +
> +if (ioctl (fd, &VIDIOC-REQBUFS;, &amp;reqbuf) == -1) {
> +	if (errno == EINVAL)
> +		printf ("Video capturing or DMABUF streaming is not supported\n");
> +	else
> +		perror ("VIDIOC_REQBUFS");
> +
> +	exit (EXIT_FAILURE);
> +}
> +      </programlisting>
> +    </example>
> +
> +    <para>Buffer (plane) file is passed on the fly with the &VIDIOC-QBUF;

s/file/file descriptor/

> +ioctl. In case of multiplanar buffers, every plane can be associated with a
> +different DMABUF descriptor.Although buffers are commonly cycled,

s/descriptor./descriptor. /

> applications +can pass different DMABUF descriptor at each

s/pass/pass a/

> <constant>VIDIOC_QBUF</constant> +call.</para>
> +
> +    <example>
> +      <title>Queueing DMABUF using single plane API</title>
> +
> +      <programlisting>
> +int buffer_queue(int v4lfd, int index, int dmafd)
> +{
> +	&v4l2-buffer; buf;
> +
> +	memset(&amp;buf, 0, sizeof buf);
> +	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
> +	buf.memory = V4L2_MEMORY_DMABUF;
> +	buf.index = index;
> +	buf.m.fd = dmafd;
> +
> +	if (ioctl (v4lfd, &VIDIOC-QBUF;, &amp;buf) == -1) {
> +		perror ("VIDIOC_QBUF");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +      </programlisting>
> +    </example>
> +
> +    <example>
> +      <title>Queueing DMABUF using multi plane API</title>
> +
> +      <programlisting>
> +int buffer_queue_mp(int v4lfd, int index, int dmafd[], int n_planes)
> +{
> +	&v4l2-buffer; buf;
> +	&v4l2-plane; planes[VIDEO_MAX_PLANES];
> +	int i;
> +
> +	memset(&amp;buf, 0, sizeof buf);
> +	buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +	buf.memory = V4L2_MEMORY_DMABUF;
> +	buf.index = index;
> +	buf.m.planes = planes;
> +	buf.length = n_planes;
> +
> +	memset(&amp;planes, 0, sizeof planes);
> +
> +	for (i = 0; i &lt; n_planes; ++i)
> +		buf.m.planes[i].m.fd = dmafd[i];
> +
> +	if (ioctl (v4lfd, &VIDIOC-QBUF;, &amp;buf) == -1) {
> +		perror ("VIDIOC_QBUF");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> +      </programlisting>
> +    </example>
> +
> +    <para>Filled or displayed buffers are dequeued with the
> +&VIDIOC-DQBUF; ioctl. The driver can unlock the buffer at any
> +time between the completion of the DMA and this ioctl. The memory is
> +also unlocked when &VIDIOC-STREAMOFF; is called, &VIDIOC-REQBUFS;, or
> +when the device is closed.</para>
> +
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
> +&VIDIOC-STREAMON; and &VIDIOC-STREAMOFF; ioctls. Note that
> +<constant>VIDIOC_STREAMOFF</constant> removes all buffers from both queues
> and +unlocks all buffers as a side effect. Since there is no notion of
> doing +anything "now" on a multitasking system, if an application needs to
> synchronize +with another event it should examine the &v4l2-buffer;
> +<structfield>timestamp</structfield> of captured buffers, or set the field
> +before enqueuing buffers for output.</para>
> +
> +    <para>Drivers implementing DMABUF importing I/O must support the
> +<constant>VIDIOC_REQBUFS</constant>, <constant>VIDIOC_QBUF</constant>,
> +<constant>VIDIOC_DQBUF</constant>, <constant>VIDIOC_STREAMON</constant> and
> +<constant>VIDIOC_STREAMOFF</constant> ioctl, the

s/ioctl/ioctls/
s/, the/, and the/

> <function>select()</function> +and <function>poll()</function>
> function.</para>

s/function/functions/

> +
> +  </section>
> +
>    <section id="async">
>      <title>Asynchronous I/O</title>
> 
> @@ -673,6 +829,14 @@ memory, set by the application. See <xref
> linkend="userp" /> for details. <structname>v4l2_buffer</structname>
> structure.</entry>
>  	  </row>
>  	  <row>
> +	    <entry></entry>
> +	    <entry>int</entry>
> +	    <entry><structfield>fd</structfield></entry>
> +	    <entry>For the single-plane API and when
> +<structfield>memory</structfield> is
> <constant>V4L2_MEMORY_DMABUF</constant> this +is the file descriptor
> associated with a DMABUF buffer.</entry>
> +	  </row>
> +	  <row>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>length</structfield></entry>
>  	    <entry></entry>
> @@ -748,6 +912,15 @@ should set this to 0.</entry>
>  	      </entry>
>  	  </row>
>  	  <row>
> +	    <entry></entry>
> +	    <entry>int</entry>
> +	    <entry><structfield>fd</structfield></entry>
> +	    <entry>When the memory type in the containing &v4l2-buffer; is
> +		<constant>V4L2_MEMORY_DMABUF</constant>, this is a file
> +		descriptor associated with a DMABUF buffer, similar to the
> +		<structfield>fd</structfield> field in &v4l2-buffer;.</entry>
> +	  </row>
> +	  <row>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>data_offset</structfield></entry>
>  	    <entry></entry>
> @@ -982,6 +1155,12 @@ pointer</link> I/O.</entry>
>  	    <entry>3</entry>
>  	    <entry>[to do]</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_MEMORY_DMABUF</constant></entry>
> +	    <entry>4</entry>
> +	    <entry>The buffer is used for <link linkend="dmabuf">DMA shared
> +buffer</link> I/O.</entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml index
> 765549f..4444c66 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> @@ -103,7 +103,8 @@ information.</para>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>memory</structfield></entry>
>  	    <entry>Applications set this field to
> -<constant>V4L2_MEMORY_MMAP</constant> or
> +<constant>V4L2_MEMORY_MMAP</constant>,
> +<constant>V4L2_MEMORY_DMABUF</constant> or
>  <constant>V4L2_MEMORY_USERPTR</constant>. See <xref linkend="v4l2-memory"
>  /></entry>
>  	  </row>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml index 9caa49a..cb5f5ff
> 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-qbuf.xml
> @@ -112,6 +112,21 @@ they cannot be swapped out to disk. Buffers remain
> locked until dequeued, until the &VIDIOC-STREAMOFF; or &VIDIOC-REQBUFS;
> ioctl is called, or until the device is closed.</para>
> 
> +    <para>To enqueue a <link linkend="dmabuf">DMABUF</link> buffer
> applications +set the <structfield>memory</structfield> field to
> +<constant>V4L2_MEMORY_DMABUF</constant> and the
> <structfield>m.fd</structfield>

s/$/ field/

> +to a file descriptor associated with a
> DMABUF buffer. When the multi-planar API is +used and

s/and//

> <structfield>m.fd</structfield> of the passed array of &v4l2-plane; +have
> to be used instead. When <constant>VIDIOC_QBUF</constant> is called with a
> +pointer to this structure the driver sets the
> +<constant>V4L2_BUF_FLAG_QUEUED</constant> flag and clears the
> +<constant>V4L2_BUF_FLAG_MAPPED</constant> and
> +<constant>V4L2_BUF_FLAG_DONE</constant> flags in the
> +<structfield>flags</structfield> field, or it returns an error code.  This
> +ioctl locks the buffer. Buffers remain locked until dequeued,
> +until the &VIDIOC-STREAMOFF; or &VIDIOC-REQBUFS; ioctl is called, or until
> the +device is closed.</para>
> +
>      <para>Applications call the <constant>VIDIOC_DQBUF</constant>
>  ioctl to dequeue a filled (capturing) or displayed (output) buffer
>  from the driver's outgoing queue. They just set the

-- 
Regards,

Laurent Pinchart

