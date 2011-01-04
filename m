Return-path: <mchehab@gaivota>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4793 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1ADHxW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Jan 2011 02:53:22 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH] [media] Add multi-planar API documentation
Date: Tue, 4 Jan 2011 08:53:09 +0100
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
References: <1294114845-5862-1-git-send-email-pawel@osciak.com>
In-Reply-To: <1294114845-5862-1-git-send-email-pawel@osciak.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101040853.09377.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Tuesday, January 04, 2011 05:20:45 Pawel Osciak wrote:
> Add DocBook documentation for the new multi-planar API extensions to the
> Video for Linux 2 API DocBook.
> 
> Signed-off-by: Pawel Osciak <pawel@osciak.com>
> ---
>  Documentation/DocBook/media-entities.tmpl     |    4 +
>  Documentation/DocBook/v4l/common.xml          |    2 +
>  Documentation/DocBook/v4l/compat.xml          |   11 +
>  Documentation/DocBook/v4l/dev-capture.xml     |   13 +-
>  Documentation/DocBook/v4l/dev-output.xml      |   13 +-
>  Documentation/DocBook/v4l/func-mmap.xml       |   10 +-
>  Documentation/DocBook/v4l/func-munmap.xml     |    3 +-
>  Documentation/DocBook/v4l/io.xml              |  242 +++++++++++++++++++++----
>  Documentation/DocBook/v4l/pixfmt.xml          |  114 +++++++++++-
>  Documentation/DocBook/v4l/planar-apis.xml     |   79 ++++++++
>  Documentation/DocBook/v4l/v4l2.xml            |   21 ++-
>  Documentation/DocBook/v4l/vidioc-enum-fmt.xml |    2 +
>  Documentation/DocBook/v4l/vidioc-g-fmt.xml    |   15 ++-
>  Documentation/DocBook/v4l/vidioc-qbuf.xml     |   24 ++-
>  Documentation/DocBook/v4l/vidioc-querybuf.xml |   14 +-
>  Documentation/DocBook/v4l/vidioc-querycap.xml |   14 ++
>  16 files changed, 515 insertions(+), 66 deletions(-)
>  create mode 100644 Documentation/DocBook/v4l/planar-apis.xml
> 
> diff --git a/Documentation/DocBook/media-entities.tmpl b/Documentation/DocBook/media-entities.tmpl
> index be34dcb..74923d7 100644
> --- a/Documentation/DocBook/media-entities.tmpl
> +++ b/Documentation/DocBook/media-entities.tmpl
> @@ -129,6 +129,7 @@
>  <!ENTITY v4l2-audioout "struct&nbsp;<link linkend='v4l2-audioout'>v4l2_audioout</link>">
>  <!ENTITY v4l2-bt-timings "struct&nbsp;<link linkend='v4l2-bt-timings'>v4l2_bt_timings</link>">
>  <!ENTITY v4l2-buffer "struct&nbsp;<link linkend='v4l2-buffer'>v4l2_buffer</link>">
> +<!ENTITY v4l2-plane "struct&nbsp;<link linkend='v4l2-plane'>v4l2_plane</link>">
>  <!ENTITY v4l2-capability "struct&nbsp;<link linkend='v4l2-capability'>v4l2_capability</link>">
>  <!ENTITY v4l2-captureparm "struct&nbsp;<link linkend='v4l2-captureparm'>v4l2_captureparm</link>">
>  <!ENTITY v4l2-clip "struct&nbsp;<link linkend='v4l2-clip'>v4l2_clip</link>">
> @@ -167,6 +168,8 @@
>  <!ENTITY v4l2-output "struct&nbsp;<link linkend='v4l2-output'>v4l2_output</link>">
>  <!ENTITY v4l2-outputparm "struct&nbsp;<link linkend='v4l2-outputparm'>v4l2_outputparm</link>">
>  <!ENTITY v4l2-pix-format "struct&nbsp;<link linkend='v4l2-pix-format'>v4l2_pix_format</link>">
> +<!ENTITY v4l2-pix-format-mplane "struct&nbsp;<link linkend='v4l2-pix-format-mplane'>v4l2_pix_format_mplane</link>">
> +<!ENTITY v4l2-plane-pix-format "struct&nbsp;<link linkend='v4l2-plane-pix-format'>v4l2_plane_pix_format</link>">
>  <!ENTITY v4l2-queryctrl "struct&nbsp;<link linkend='v4l2-queryctrl'>v4l2_queryctrl</link>">
>  <!ENTITY v4l2-querymenu "struct&nbsp;<link linkend='v4l2-querymenu'>v4l2_querymenu</link>">
>  <!ENTITY v4l2-rect "struct&nbsp;<link linkend='v4l2-rect'>v4l2_rect</link>">
> @@ -202,6 +205,7 @@
>  <!-- Subsections -->
>  <!ENTITY sub-biblio SYSTEM "v4l/biblio.xml">
>  <!ENTITY sub-common SYSTEM "v4l/common.xml">
> +<!ENTITY sub-planar-apis SYSTEM "v4l/planar-apis.xml">
>  <!ENTITY sub-compat SYSTEM "v4l/compat.xml">
>  <!ENTITY sub-controls SYSTEM "v4l/controls.xml">
>  <!ENTITY sub-dev-capture SYSTEM "v4l/dev-capture.xml">
> diff --git a/Documentation/DocBook/v4l/common.xml b/Documentation/DocBook/v4l/common.xml
> index cea23e1..dbab79c 100644
> --- a/Documentation/DocBook/v4l/common.xml
> +++ b/Documentation/DocBook/v4l/common.xml
> @@ -846,6 +846,8 @@ conversion routine or library for integration into applications.</para>
>      </section>
>    </section>
>  
> +  &sub-planar-apis;
> +
>    <section id="crop">
>      <title>Image Cropping, Insertion and Scaling</title>
>  
> diff --git a/Documentation/DocBook/v4l/compat.xml b/Documentation/DocBook/v4l/compat.xml
> index c9ce61d..1461878 100644
> --- a/Documentation/DocBook/v4l/compat.xml
> +++ b/Documentation/DocBook/v4l/compat.xml
> @@ -2353,6 +2353,17 @@ that used it. It was originally scheduled for removal in 2.6.35.
>  	</listitem>
>        </orderedlist>
>      </section>
> +    <section>
> +      <title>V4L2 in Linux 2.6.38</title>
> +      <orderedlist>
> +        <listitem>
> +          <para>Muti-planar API added. Does not affect the compatibility of

Typo: Muti -> Multi

> +          current drivers and applications. See
> +          <link linkend="planar-apis">multi-planar API</link>
> +          for details.</para>
> +        </listitem>
> +      </orderedlist>
> +    </section>
>  
>      <section id="other">
>        <title>Relation of V4L2 to other Linux multimedia APIs</title>
> diff --git a/Documentation/DocBook/v4l/dev-capture.xml b/Documentation/DocBook/v4l/dev-capture.xml
> index 32807e4..2237c66 100644
> --- a/Documentation/DocBook/v4l/dev-capture.xml
> +++ b/Documentation/DocBook/v4l/dev-capture.xml
> @@ -18,7 +18,8 @@ files are used for video output devices.</para>
>      <title>Querying Capabilities</title>
>  
>      <para>Devices supporting the video capture interface set the
> -<constant>V4L2_CAP_VIDEO_CAPTURE</constant> flag in the
> +<constant>V4L2_CAP_VIDEO_CAPTURE</constant> or
> +<constant>V4L2_CAP_VIDEO_CAPTURE_MPLANE</constant> flag in the
>  <structfield>capabilities</structfield> field of &v4l2-capability;
>  returned by the &VIDIOC-QUERYCAP; ioctl. As secondary device functions
>  they may also support the <link linkend="overlay">video overlay</link>
> @@ -64,9 +65,11 @@ linkend="crop" />.</para>
>  
>      <para>To query the current image format applications set the
>  <structfield>type</structfield> field of a &v4l2-format; to
> -<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant> and call the
> +<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant> or
> +<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant> and call the
>  &VIDIOC-G-FMT; ioctl with a pointer to this structure. Drivers fill
> -the &v4l2-pix-format; <structfield>pix</structfield> member of the
> +the &v4l2-pix-format; <structfield>pix</structfield> or the
> +&v4l2-pix-format-mplane; <structfield>pix_mp</structfield> member of the
>  <structfield>fmt</structfield> union.</para>
>  
>      <para>To request different parameters applications set the
> @@ -84,8 +87,8 @@ adjust the parameters and finally return the actual parameters as
>  without disabling I/O or possibly time consuming hardware
>  preparations.</para>
>  
> -    <para>The contents of &v4l2-pix-format; are discussed in <xref
> -linkend="pixfmt" />. See also the specification of the
> +    <para>The contents of &v4l2-pix-format; and &v4l2-pix-format-mplane;
> +are discussed in <xref linkend="pixfmt" />. See also the specification of the
>  <constant>VIDIOC_G_FMT</constant>, <constant>VIDIOC_S_FMT</constant>
>  and <constant>VIDIOC_TRY_FMT</constant> ioctls for details. Video
>  capture devices must implement both the
> diff --git a/Documentation/DocBook/v4l/dev-output.xml b/Documentation/DocBook/v4l/dev-output.xml
> index 63c3c20..919e22c 100644
> --- a/Documentation/DocBook/v4l/dev-output.xml
> +++ b/Documentation/DocBook/v4l/dev-output.xml
> @@ -17,7 +17,8 @@ files are used for video capture devices.</para>
>      <title>Querying Capabilities</title>
>  
>      <para>Devices supporting the video output interface set the
> -<constant>V4L2_CAP_VIDEO_OUTPUT</constant> flag in the
> +<constant>V4L2_CAP_VIDEO_OUTPUT</constant> or
> +<constant>V4L2_CAP_VIDEO_OUTPUT_MPLANE</constant> flag in the
>  <structfield>capabilities</structfield> field of &v4l2-capability;
>  returned by the &VIDIOC-QUERYCAP; ioctl. As secondary device functions
>  they may also support the <link linkend="raw-vbi">raw VBI
> @@ -60,9 +61,11 @@ linkend="crop" />.</para>
>  
>      <para>To query the current image format applications set the
>  <structfield>type</structfield> field of a &v4l2-format; to
> -<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant> and call the
> +<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant> or
> +<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE</constant> and call the
>  &VIDIOC-G-FMT; ioctl with a pointer to this structure. Drivers fill
> -the &v4l2-pix-format; <structfield>pix</structfield> member of the
> +the &v4l2-pix-format; <structfield>pix</structfield> or the
> +&v4l2-pix-format-mplane; <structfield>pix_mp</structfield> member of the
>  <structfield>fmt</structfield> union.</para>
>  
>      <para>To request different parameters applications set the
> @@ -80,8 +83,8 @@ adjust the parameters and finally return the actual parameters as
>  without disabling I/O or possibly time consuming hardware
>  preparations.</para>
>  
> -    <para>The contents of &v4l2-pix-format; are discussed in <xref
> -linkend="pixfmt" />. See also the specification of the
> +    <para>The contents of &v4l2-pix-format; and &v4l2-pix-format-mplane;
> +are discussed in <xref linkend="pixfmt" />. See also the specification of the
>  <constant>VIDIOC_G_FMT</constant>, <constant>VIDIOC_S_FMT</constant>
>  and <constant>VIDIOC_TRY_FMT</constant> ioctls for details. Video
>  output devices must implement both the
> diff --git a/Documentation/DocBook/v4l/func-mmap.xml b/Documentation/DocBook/v4l/func-mmap.xml
> index 2e2fc39..92eb176 100644
> --- a/Documentation/DocBook/v4l/func-mmap.xml
> +++ b/Documentation/DocBook/v4l/func-mmap.xml
> @@ -45,7 +45,10 @@ just specify a <constant>NULL</constant> pointer here.</para>
>  	<listitem>
>  	  <para>Length of the memory area to map. This must be the
>  same value as returned by the driver in the &v4l2-buffer;
> -<structfield>length</structfield> field.</para>
> +<structfield>length</structfield> field for

for -> for the

> +single-planar API, and the same value as returned by the driver
> +in the &v4l2-plane; <structfield>length</structfield> field for the
> +multi-planar API.</para>
>  	</listitem>
>        </varlistentry>
>        <varlistentry>
> @@ -106,7 +109,10 @@ flag.</para>
>  	<listitem>
>  	  <para>Offset of the buffer in device memory. This must be the
>  same value as returned by the driver in the &v4l2-buffer;
> -<structfield>m</structfield> union <structfield>offset</structfield> field.</para>
> +<structfield>m</structfield> union <structfield>offset</structfield> field for

for -> for the

> +single-planar API, and the same value as returned by the driver
> +in the &v4l2-plane; <structfield>m</structfield> union
> +<structfield>mem_offset</structfield> field for the multi-planar API.</para>
>  	</listitem>
>        </varlistentry>
>      </variablelist>
> diff --git a/Documentation/DocBook/v4l/func-munmap.xml b/Documentation/DocBook/v4l/func-munmap.xml
> index 502ed49..e2c4190 100644
> --- a/Documentation/DocBook/v4l/func-munmap.xml
> +++ b/Documentation/DocBook/v4l/func-munmap.xml
> @@ -37,7 +37,8 @@
>  	  <para>Length of the mapped buffer. This must be the same
>  value as given to <function>mmap()</function> and returned by the
>  driver in the &v4l2-buffer; <structfield>length</structfield>
> -field.</para>
> +field for the single-planar API and in the &v4l2-plane;
> +<structfield>length</structfield> field for the multi-planar API.</para>
>  	</listitem>
>        </varlistentry>
>      </variablelist>
> diff --git a/Documentation/DocBook/v4l/io.xml b/Documentation/DocBook/v4l/io.xml
> index d424886..26fdd7c 100644
> --- a/Documentation/DocBook/v4l/io.xml
> +++ b/Documentation/DocBook/v4l/io.xml
> @@ -121,18 +121,22 @@ mapped.</para>
>      <para>Before applications can access the buffers they must map
>  them into their address space with the &func-mmap; function. The
>  location of the buffers in device memory can be determined with the
> -&VIDIOC-QUERYBUF; ioctl. The <structfield>m.offset</structfield> and
> -<structfield>length</structfield> returned in a &v4l2-buffer; are
> -passed as sixth and second parameter to the
> -<function>mmap()</function> function. The offset and length values
> -must not be modified. Remember the buffers are allocated in physical
> -memory, as opposed to virtual memory which can be swapped out to disk.
> -Applications should free the buffers as soon as possible with the
> -&func-munmap; function.</para>
> +&VIDIOC-QUERYBUF; ioctl. In single-planar API case, the

in -> in the

> +<structfield>m.offset</structfield> and <structfield>length</structfield>
> +returned in a &v4l2-buffer; are passed as sixth and second parameter to the
> +<function>mmap()</function> function. When using multi-planar API,

using -> using the

> +struct &v4l2-buffer; contains an array of &v4l2-plane; structures, each
> +containing its own <structfield>m.offset</structfield> and
> +<structfield>length</structfield>. When using multi-planar API, every

using the

> +plane of every buffer has to be mapped separately, so the number of
> +calls to &func-mmap; should be equal to number of buffers times number of
> +planes in each buffer. The offset and length values must not be modified.
> +Remember, the buffers are allocated in physical memory, as opposed to virtual
> +memory, which can be swapped out to disk. Applications should free the buffers
> +as soon as possible with the &func-munmap; function.</para>
>  
>      <example>
> -      <title>Mapping buffers</title>
> -
> +      <title>Mapping buffers in single-planar API</title>

in -> in the

>        <programlisting>
>  &v4l2-requestbuffers; reqbuf;
>  struct {
> @@ -201,6 +205,88 @@ for (i = 0; i &lt; reqbuf.count; i++)
>        </programlisting>
>      </example>
>  
> +    <example>
> +      <title>Mapping buffers in multi-planar API</title>

in the

> +      <programlisting>
> +&v4l2-requestbuffers; reqbuf;
> +/* Our current format uses 3 planes per buffer */
> +#define FMT_NUM_PLANES = 3;
> +
> +struct {
> +	void *start[FMT_NUM_PLANES];
> +	size_t length[FMT_NUM_PLANES];
> +} *buffers;
> +unsigned int i, j;
> +
> +memset (&amp;reqbuf, 0, sizeof (reqbuf));

No space before (

> +reqbuf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE;
> +reqbuf.memory = V4L2_MEMORY_MMAP;
> +reqbuf.count = 20;
> +
> +if (-1 == ioctl (fd, &VIDIOC-REQBUFS;, &amp;reqbuf)) {

Ditto. Same below.

It's also better to do 'if (ioctl() < 0) {'

> +	if (errno == EINVAL)
> +		printf ("Video capturing or mmap-streaming is not supported\n");
> +	else
> +		perror ("VIDIOC_REQBUFS");
> +
> +	exit (EXIT_FAILURE);
> +}
> +
> +/* We want at least five buffers. */
> +
> +if (reqbuf.count &lt; 5) {
> +	/* You may need to free the buffers here. */
> +	printf ("Not enough buffer memory\n");
> +	exit (EXIT_FAILURE);
> +}
> +
> +buffers = calloc (reqbuf.count, sizeof (*buffers));
> +assert (buffers != NULL);
> +
> +for (i = 0; i &lt; reqbuf.count; i++) {
> +	&v4l2-buffer; buffer;
> +	&v4l2-plane; planes[FMT_NUM_PLANES];
> +
> +	memset (&amp;buffer, 0, sizeof (buffer));
> +	buffer.type = reqbuf.type;
> +	buffer.memory = V4L2_MEMORY_MMAP;
> +	buffer.index = i;
> +	/* length in struct v4l2_buffer in multi-planar API stores the size
> +	 * of planes array. */
> +	buffer.length = FMT_NUM_PLANES;
> +	buffer.m.planes = planes;
> +
> +	if (-1 == ioctl (fd, &VIDIOC-QUERYBUF;, &amp;buffer)) {
> +		perror ("VIDIOC_QUERYBUF");
> +		exit (EXIT_FAILURE);
> +	}
> +
> +	/* Every plane has to be mapped separately */
> +	for (j = 0; j &lt; FMT_NUM_PLANES; j++) {
> +		buffers[i].length[j] = buffer.m.planes[j].length; /* remember for munmap() */
> +
> +		buffers[i].start[j] = mmap (NULL, buffer.m.planes[j].length,
> +				 PROT_READ | PROT_WRITE, /* recommended */
> +				 MAP_SHARED,             /* recommended */
> +				 fd, buffer.m.planes[j].m.offset);
> +
> +		if (MAP_FAILED == buffers[i].start[j]) {
> +			/* If you do not exit here you should unmap() and free()
> +			   the buffers and planes mapped so far. */
> +			perror ("mmap");
> +			exit (EXIT_FAILURE);
> +		}
> +	}
> +}
> +
> +/* Cleanup. */
> +
> +for (i = 0; i &lt; reqbuf.count; i++)
> +	for (j = 0; j &lt; FMT_NUM_PLANES; j++)
> +		munmap (buffers[i].start[j], buffers[i].length[j]);
> +      </programlisting>
> +    </example>
> +
>      <para>Conceptually streaming drivers maintain two buffer queues, an incoming
>  and an outgoing queue. They separate the synchronous capture or output
>  operation locked to a video clock from the application which is
> @@ -286,13 +372,13 @@ pointer method (not only memory mapping) is supported must be
>  determined by calling the &VIDIOC-REQBUFS; ioctl.</para>
>  
>      <para>This I/O method combines advantages of the read/write and
> -memory mapping methods. Buffers are allocated by the application
> +memory mapping methods. Buffers (planes) are allocated by the application
>  itself, and can reside for example in virtual or shared memory. Only
>  pointers to data are exchanged, these pointers and meta-information
> -are passed in &v4l2-buffer;. The driver must be switched
> -into user pointer I/O mode by calling the &VIDIOC-REQBUFS; with the
> -desired buffer type. No buffers are allocated beforehands,
> -consequently they are not indexed and cannot be queried like mapped
> +are passed in &v4l2-buffer; (or in &v4l2-plane; in multi-planar API case).

in the multi-planar

> +The driver must be switched into user pointer I/O mode by calling the
> +&VIDIOC-REQBUFS; with the desired buffer type. No buffers (planes) are allocated
> +beforehand, consequently they are not indexed and cannot be queried like mapped
>  buffers with the <constant>VIDIOC_QUERYBUF</constant> ioctl.</para>
>  
>      <example>
> @@ -316,7 +402,7 @@ if (ioctl (fd, &VIDIOC-REQBUFS;, &amp;reqbuf) == -1) {
>        </programlisting>
>      </example>
>  
> -    <para>Buffer addresses and sizes are passed on the fly with the
> +    <para>Buffer (plane) addresses and sizes are passed on the fly with the
>  &VIDIOC-QBUF; ioctl. Although buffers are commonly cycled,
>  applications can pass different addresses and sizes at each
>  <constant>VIDIOC_QBUF</constant> call. If required by the hardware the
> @@ -396,11 +482,18 @@ rest should be evident.</para>
>      <title>Buffers</title>
>  
>      <para>A buffer contains data exchanged by application and
> -driver using one of the Streaming I/O methods. Only pointers to
> -buffers are exchanged, the data itself is not copied. These pointers,
> -together with meta-information like timestamps or field parity, are
> -stored in a struct <structname>v4l2_buffer</structname>, argument to
> -the &VIDIOC-QUERYBUF;, &VIDIOC-QBUF; and &VIDIOC-DQBUF; ioctl.</para>
> +driver using one of the Streaming I/O methods. In multi-planar API, the

In the

> +data is held in planes, while the buffer structure acts as a container
> +for the planes. Only pointers to buffers (planes) are exchanged, the data
> +itself is not copied. These pointers, together with meta-information like
> +timestamps or field parity, are stored in a struct
> +<structname>v4l2_buffer</structname>, argument to
> +the &VIDIOC-QUERYBUF;, &VIDIOC-QBUF; and &VIDIOC-DQBUF; ioctl.
> +In multi-planar API, some plane-specific members of struct

In the

> +<structname>v4l2_buffer</structname>, such as pointers and sizes for each
> +plane, are stored in struct <structname>v4l2_plane</structname> instead.
> +In that case, struct <structname>v4l2_buffer</structname> contains an array of
> +plane structures.</para>
>  
>        <para>Nominally timestamps refer to the first data byte transmitted.
>  In practice however the wide range of hardware covered by the V4L2 API
> @@ -551,26 +644,39 @@ in accordance with the selected I/O method.</entry>
>  	    <entry></entry>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>offset</structfield></entry>
> -	    <entry>When <structfield>memory</structfield> is
> -<constant>V4L2_MEMORY_MMAP</constant> this is the offset of the buffer
> -from the start of the device memory. The value is returned by the
> -driver and apart of serving as parameter to the &func-mmap; function
> -not useful for applications. See <xref linkend="mmap" /> for details.</entry>
> +	    <entry>For single-planar API and when

For the

> +<structfield>memory</structfield> is <constant>V4L2_MEMORY_MMAP</constant> this
> +is the offset of the buffer from the start of the device memory. The value is
> +returned by the driver and apart of serving as parameter to the &func-mmap;
> +function not useful for applications. See <xref linkend="mmap" /> for details
> +	  </entry>
>  	  </row>
>  	  <row>
>  	    <entry></entry>
>  	    <entry>unsigned long</entry>
>  	    <entry><structfield>userptr</structfield></entry>
> -	    <entry>When <structfield>memory</structfield> is
> -<constant>V4L2_MEMORY_USERPTR</constant> this is a pointer to the
> -buffer (casted to unsigned long type) in virtual memory, set by the
> -application. See <xref linkend="userp" /> for details.</entry>
> +	    <entry>For single-planar API and when

For the

> +<structfield>memory</structfield> is <constant>V4L2_MEMORY_USERPTR</constant>
> +this is a pointer to the buffer (casted to unsigned long type) in virtual
> +memory, set by the application. See <xref linkend="userp" /> for details.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry></entry>
> +	    <entry>struct v4l2_plane</entry>
> +	    <entry><structfield>*planes</structfield></entry>
> +	    <entry>When using multi-planar API, contains a userspace pointer

using the

> +	    to an array of &v4l2-plane;. The size of the array should be put
> +	    in the <structfield>length</structfield> field of this
> +	    <structname>v4l2_buffer</structname> structure.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>length</structfield></entry>
>  	    <entry></entry>
> -	    <entry>Size of the buffer (not the payload) in bytes.</entry>
> +	    <entry>Size of the buffer (not the payload) in bytes for

for the

> +	    single-planar API. For multi-planar API should contain the number

For the

> +	    of elements in the <structfield>planes</structfield> array.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> @@ -596,6 +702,64 @@ should set this to 0.</entry>
>        </tgroup>
>      </table>
>  
> +    <table frame="none" pgwide="1" id="v4l2-plane">
> +      <title>struct <structname>v4l2_plane</structname></title>
> +      <tgroup cols="4">
> +        &cs-ustr;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>bytesused</structfield></entry>
> +	    <entry></entry>
> +	    <entry>The number of bytes occupied by data in the plane
> +	    (its payload).</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>length</structfield></entry>
> +	    <entry></entry>
> +	    <entry>Size in bytes of the plane (not its payload).</entry>
> +	  </row>
> +	  <row>
> +	    <entry>union</entry>
> +	    <entry><structfield>m</structfield></entry>
> +	    <entry></entry>
> +	    <entry></entry>
> +	  </row>
> +	  <row>
> +	    <entry></entry>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>mem_offset</structfield></entry>
> +	    <entry>When memory type in the containing &v4l2-buffer; is

When the

> +	      <constant>V4L2_MEMORY_MMAP</constant>, this is the value that
> +	      should be passed to &func-mmap;, analogically to the

analogically -> similar

> +	      <structfield>offset</structfield> field in &v4l2-buffer;.</entry>
> +	  </row>
> +	  <row>
> +	    <entry></entry>
> +	    <entry>__unsigned long</entry>
> +	    <entry><structfield>userptr</structfield></entry>
> +	    <entry>When memory type in the containing &v4l2-buffer; is

When the

> +	      <constant>V4L2_MEMORY_USERPTR</constant>, a userspace pointer

a userspace -> this is a userspace

> +	      to memory allocated for this plane by an application.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>data_offset</structfield></entry>
> +	    <entry></entry>
> +	    <entry>Offset in bytes to video data in the plane, if applicable.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved[11]</structfield></entry>
> +	    <entry></entry>
> +	    <entry>Reserved for future use. Should be zero.</entry>

Who zeroes this? Driver and/or application?

> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +
>      <table frame="none" pgwide="1" id="v4l2-buf-type">
>        <title>enum v4l2_buf_type</title>
>        <tgroup cols="3">
> @@ -604,13 +768,25 @@ should set this to 0.</entry>
>  	  <row>
>  	    <entry><constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant></entry>
>  	    <entry>1</entry>
> -	    <entry>Buffer of a video capture stream, see <xref
> +	    <entry>Buffer of a video capture stream, single-planar API see <xref

	    <entry>Buffer of a single-plane video capture stream, see <xref

> +		linkend="capture" />.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant></entry>
> +	    <entry>9</entry>
> +	    <entry>Buffer of a video capture stream, multi-planar API, see <xref

	    <entry>Buffer of a multi-planar video capture stream, see <xref

>  		linkend="capture" />.</entry>
>  	  </row>
>  	  <row>
>  	    <entry><constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant></entry>
>  	    <entry>2</entry>
> -	    <entry>Buffer of a video output stream, see <xref
> +	    <entry>Buffer of a video output stream, single-planar API, see <xref

Ditto

> +		linkend="output" />.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE</constant></entry>
> +	    <entry>10</entry>
> +	    <entry>Buffer of a video output stream, multi-planar API, see <xref

Ditto

>  		linkend="output" />.</entry>
>  	  </row>
>  	  <row>
> diff --git a/Documentation/DocBook/v4l/pixfmt.xml b/Documentation/DocBook/v4l/pixfmt.xml
> index cfffc88..1f27928 100644
> --- a/Documentation/DocBook/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/v4l/pixfmt.xml
> @@ -2,12 +2,16 @@
>  
>    <para>The V4L2 API was primarily designed for devices exchanging
>  image data with applications. The
> -<structname>v4l2_pix_format</structname> structure defines the format
> -and layout of an image in memory. Image formats are negotiated with
> -the &VIDIOC-S-FMT; ioctl. (The explanations here focus on video
> +<structname>v4l2_pix_format</structname> and <structname>v4l2_pix_format_mplane
> +</structname> structures define the format and layout of an image in memory.
> +The former is used with single-planar API, while the latter with its

The former is used with the single-planar API, while the latter is used with the

> +multi-planar version (see <xref linkend="planar-apis"/>). Image formats are
> +negotiated with the &VIDIOC-S-FMT; ioctl. (The explanations here focus on video
>  capturing and output, for overlay frame buffer formats see also
>  &VIDIOC-G-FBUF;.)</para>
>  
> +<section>
> +  <title>Single-planar format structure</title>
>    <table pgwide="1" frame="none" id="v4l2-pix-format">
>      <title>struct <structname>v4l2_pix_format</structname></title>
>      <tgroup cols="3">
> @@ -106,6 +110,96 @@ set this field to zero.</entry>
>        </tbody>
>      </tgroup>
>    </table>
> +</section>
> +
> +<section>
> +  <title>Multi-planar format structures</title>
> +  <para>The <structname>v4l2_plane_pix_format</structname> structures define
> +    size and layout for each of the planes in a multi-planar format.
> +    The <structname>v4l2_pix_format_mplane</structname> structure contains
> +    information common to all planes (such as image width and height) and
> +    an array of <structname>v4l2_plane_pix_format</structname> structures,
> +    describing all planes of that format.</para>
> +  <table pgwide="1" frame="none" id="v4l2-plane-pix-format">
> +    <title>struct <structname>vl42_plane_pix_format</structname></title>
> +    <tgroup cols="3">
> +      &cs-str;
> +      <tbody valign="top">
> +        <row>
> +          <entry>__u32</entry>
> +          <entry><structfield>sizeimage</structfield></entry>
> +          <entry>Maximum size in bytes required for image data in this plane.
> +          </entry>
> +        </row>
> +        <row>
> +          <entry>__u16</entry>
> +          <entry><structfield>bytesperline</structfield></entry>
> +          <entry>Distance in bytes between the leftmost pixels in two adjacent
> +            lines.</entry>
> +        </row>
> +        <row>
> +          <entry>__u16</entry>
> +          <entry><structfield>reserved[7]</structfield></entry>
> +          <entry>Reserved for future extensions. Should be zero.</entry>

Who zeroes this? Driver and/or application?

> +        </row>
> +      </tbody>
> +    </tgroup>
> +  </table>
> +  <table pgwide="1" frame="none" id="v4l2-pix-format-mplane">
> +    <title>struct <structname>v4l2_pix_format_mplane</structname></title>
> +    <tgroup cols="3">
> +      &cs-str;
> +      <tbody valign="top">
> +        <row>
> +          <entry>__u32</entry>
> +          <entry><structfield>width</structfield></entry>
> +          <entry>Image width in pixels.</entry>
> +        </row>
> +        <row>
> +          <entry>__u32</entry>
> +          <entry><structfield>height</structfield></entry>
> +          <entry>Image height in pixels.</entry>
> +        </row>
> +        <row>
> +          <entry>__u32</entry>
> +          <entry><structfield>pixelformat</structfield></entry>
> +          <entry>The pixel format. Both single- and multi-planar four character
> +codes can be used.</entry>
> +        </row>
> +        <row>
> +          <entry>&v4l2-field;</entry>
> +          <entry><structfield>field</structfield></entry>
> +          <entry>See &v4l2-pix-format;.</entry>
> +        </row>
> +        <row>
> +          <entry>&v4l2-colorspace;</entry>
> +          <entry><structfield>colorspace</structfield></entry>
> +          <entry>See &v4l2-pix-format;.</entry>
> +        </row>
> +        <row>
> +          <entry>&v4l2-plane-pix-format;</entry>
> +          <entry><structfield>plane_fmt[VIDEO_MAX_PLANES]</structfield></entry>
> +          <entry>An array of structures describing format of each plane this
> +          pixel format consists of. The number of valid entries in this array
> +          has to be put in the <structfield>num_planes</structfield>
> +          field.</entry>
> +        </row>
> +        <row>
> +          <entry>__u8</entry>
> +          <entry><structfield>num_planes</structfield></entry>
> +          <entry>Number of planes (i.e. separate memory buffers) for this format
> +          and the number of valid entries in the
> +          <structfield>plane_fmt</structfield> array.</entry>
> +        </row>
> +        <row>
> +          <entry>__u8</entry>
> +          <entry><structfield>reserved[11]</structfield></entry>
> +          <entry>Reserved for future extensions. Should be zero.</entry>

Who zeroes this? Driver and/or application?

> +        </row>
> +      </tbody>
> +    </tgroup>
> +  </table>
> +</section>
>  
>    <section>
>      <title>Standard Image Formats</title>
> @@ -142,11 +236,19 @@ leftmost pixel of the second row from the top, and so on. The last row
>  has just as many pad bytes after it as the other rows.</para>
>  
>      <para>In V4L2 each format has an identifier which looks like
> -<constant>PIX_FMT_XXX</constant>, defined in the <filename>videodev2.h</filename>
> -header file. These identifiers
> -represent <link linkend="v4l2-fourcc">four character codes</link>
> +<constant>PIX_FMT_XXX</constant>, defined in the <link
> +linkend="videodev">videodev.h</link> header file. These identifiers
> +represent <link linkend="v4l2-fourcc">four character (FourCC) codes</link>
>  which are also listed below, however they are not the same as those
>  used in the Windows world.</para>
> +
> +    <para>For some formats, data is stored in separate, discontiguous
> +memory buffers. Those formats are identified by a separate set of FourCC codes
> +and are referred to as "multi-planar formats". For example, a YUV422 frame is
> +normally stored in one memory buffer, but it can also be placed in two or three
> +separate buffers, with Y component in one buffer and CbCr components in another
> +in the 2-planar version and with each component in its own buffer in the

and -> or

> +3-planar case. Those sub-buffers are referred to as "planes".</para>
>    </section>
>  
>    <section id="colorspaces">
> diff --git a/Documentation/DocBook/v4l/planar-apis.xml b/Documentation/DocBook/v4l/planar-apis.xml
> new file mode 100644
> index 0000000..ce89831
> --- /dev/null
> +++ b/Documentation/DocBook/v4l/planar-apis.xml
> @@ -0,0 +1,79 @@
> +<section id="planar-apis">
> +  <title>Single- and multi-planar APIs</title>
> +
> +  <para>Some devices require data for each input or output video frame
> +  to be placed in discontiguous memory buffers. In such cases one
> +  video frame has to be addressed using more than one memory address, i.e. one
> +  pointer per "plane". A plane is a sub-buffer of current frame. For examples
> +  of such formats see <xref linkend="pixfmt" />.</para>
> +
> +  <para>Initially, V4L2 API did not support multi-planar buffers and a set of
> +  extensions has been introduced to handle them. Those extensions constitute
> +  what is being referred to as the "multi-planar API".</para>
> +
> +  <para>Some of the V4L2 API calls and structures are interpreted differently,
> +  depending on whether single- or multi-planar API is being used. An application
> +  can choose whether to use one or the other by passing a corresponding buffer
> +  type to its ioctl calls. Multi-planar versions of buffer types are suffixed with
> +  an `_MPLANE' string. For a list of available multi-planar buffer types
> +  see &v4l2-buf-type;.
> +  </para>
> +
> +  <section>
> +    <title>Multi-planar formats</title>
> +    <para>Multi-planar API introduces new multi-planar formats. Those formats
> +    use a separate set of FourCC codes. It is important to distinguish between
> +    the multi-planar API and a multi-planar format. Multi-planar API calls can
> +    handle all single-planar formats as well, while single-planar API cannot

while -> while the

> +    handle multi-planar formats. Applications do not have to switch between APIs
> +    when handling both single- and multi-planar devices and should use the
> +    multi-planar API version for both single- and multi-planar formats.
> +    Drivers that do not support multi-planar API can still be handled with it,
> +    utilizing a compatibility layer built into standard V4L2 ioctl handling.
> +    </para>
> +  </section>
> +
> +  <section>
> +    <title>Single and multi-planar API compatibility layer</title>
> +    <para>In most cases, applications can use the multi-planar API with older

'In most cases': I know why, but we really need to work on converting those
drivers that still do not use video_ioctl2 :-(

Perhaps a footnote explaining this might be useful here.

> +    drivers that support only its single-planar version and vice versa.
> +    Appropriate conversion is done seamlessly for both applications and drivers
> +    in the V4L2 core. The general rule of thumb is: as long as an application
> +    uses formats that a driver supports, it can use either API (although use
> +    of multi-planar formats is only possible with the multi-planar API). The
> +    list of formats supported by a driver can be obtained using the
> +    &VIDIOC-ENUM-FMT; call. It is possible, but discouraged, for a driver or
> +    an application to support and use both versions of the API.</para>
> +  </section>
> +
> +  <section>
> +    <title>Calls that distinguish between single and multi-planar APIs</title>
> +    <variablelist>
> +      <varlistentry>
> +        <term>&VIDIOC-QUERYCAP;</term>
> +        <listitem>Two additional multi-planar capabilities are added. They can
> +        be set together with non-multi-planar ones for devices that support both
> +        APIs.</listitem>

What happens if a driver supports only single-planar API, but the core adds
transparent support for multi-planar API? Are the MPLANE caps set or not?
I can't remember what we decided to do. Ditto for the other way around (driver
does only multi-planar, but core adds single-planar support).

> +      </varlistentry>
> +      <varlistentry>
> +        <term>&VIDIOC-G-FMT;, &VIDIOC-S-FMT;, &VIDIOC-TRY-FMT;</term>
> +        <listitem>New structures for describing multi-planar formats are added:
> +        &v4l2-pix-format-mplane; and &v4l2-plane-pix-format;. Drivers may
> +        define new multi-planar formats, which have distinct FourCC codes from
> +        the existing single-planar ones.
> +        </listitem>
> +      </varlistentry>
> +      <varlistentry>
> +        <term>&VIDIOC-QBUF;, &VIDIOC-DQBUF;, &VIDIOC-QUERYBUF;</term>
> +        <listitem>A new &v4l2-plane; structure for describing planes is added.
> +        Arrays of this structure are passed in the new
> +        <structfield>m.planes</structfield> field of &v4l2-buffer;.
> +        </listitem>
> +      </varlistentry>
> +      <varlistentry>
> +        <term>&VIDIOC-REQBUFS;</term>
> +        <listitem>Will allocate multi-planar buffers as requested.</listitem>
> +      </varlistentry>
> +    </variablelist>
> +  </section>
> +</section>
> diff --git a/Documentation/DocBook/v4l/v4l2.xml b/Documentation/DocBook/v4l/v4l2.xml
> index 839e93e..906819f 100644
> --- a/Documentation/DocBook/v4l/v4l2.xml
> +++ b/Documentation/DocBook/v4l/v4l2.xml
> @@ -85,6 +85,17 @@ Remote Controller chapter.</contrib>
>  	  </address>
>  	</affiliation>
>        </author>
> +
> +      <author>
> +      	<firstname>Pawel</firstname>
> +	<surname>Osciak</surname>
> +	<contrib>Designed and documented the multi-planar API.</contrib>
> +	<affiliation>
> +	  <address>
> +	    <email>pawel AT osciak.com</email>
> +	  </address>
> +	</affiliation>
> +      </author>
>      </authorgroup>
>  
>      <copyright>
> @@ -101,7 +112,8 @@ Remote Controller chapter.</contrib>
>        <year>2009</year>
>        <year>2010</year>
>        <holder>Bill Dirks, Michael H. Schimek, Hans Verkuil, Martin
> -Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Chehab</holder>
> +Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Chehab,
> +	Pawel Osciak</holder>
>      </copyright>
>      <legalnotice>
>      <para>Except when explicitly stated as GPL, programming examples within
> @@ -115,6 +127,13 @@ structs, ioctls) must be noted in more detail in the history chapter
>  applications. -->
>  
>        <revision>
> +	<revnumber>2.6.38</revnumber>
> +	<authorinitials>po</authorinitials>
> +	<revremark>Added the <link linkend="planar-apis">multi-planar API</link>.
> +	</revremark>
> +      </revision>
> +
> +      <revision>
>  	<revnumber>2.6.37</revnumber>
>  	<date>2010-08-06</date>
>  	<authorinitials>hv</authorinitials>
> diff --git a/Documentation/DocBook/v4l/vidioc-enum-fmt.xml b/Documentation/DocBook/v4l/vidioc-enum-fmt.xml
> index 960d446..71d373b 100644
> --- a/Documentation/DocBook/v4l/vidioc-enum-fmt.xml
> +++ b/Documentation/DocBook/v4l/vidioc-enum-fmt.xml
> @@ -76,7 +76,9 @@ pixelformat</structfield> field.</entry>
>  	    <entry>Type of the data stream, set by the application.
>  Only these types are valid here:
>  <constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>,
> +<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant>,
>  <constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant>,
> +<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE</constant>,
>  <constant>V4L2_BUF_TYPE_VIDEO_OVERLAY</constant>, and custom (driver
>  defined) types with code <constant>V4L2_BUF_TYPE_PRIVATE</constant>
>  and higher.</entry>
> diff --git a/Documentation/DocBook/v4l/vidioc-g-fmt.xml b/Documentation/DocBook/v4l/vidioc-g-fmt.xml
> index 7c7d1b7..a4ae59b 100644
> --- a/Documentation/DocBook/v4l/vidioc-g-fmt.xml
> +++ b/Documentation/DocBook/v4l/vidioc-g-fmt.xml
> @@ -60,11 +60,13 @@ application.</para>
>  <structfield>type</structfield> field of a struct
>  <structname>v4l2_format</structname> to the respective buffer (stream)
>  type. For example video capture devices use
> -<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>. When the application
> +<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE</constant> or
> +<constant>V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE</constant>. When the application
>  calls the <constant>VIDIOC_G_FMT</constant> ioctl with a pointer to
>  this structure the driver fills the respective member of the
>  <structfield>fmt</structfield> union. In case of video capture devices
> -that is the &v4l2-pix-format; <structfield>pix</structfield> member.
> +that is either the &v4l2-pix-format; <structfield>pix</structfield> or
> +the &v4l2-pix-format-mplane; <structfield>pix_mp</structfield> member.
>  When the requested buffer type is not supported drivers return an
>  &EINVAL;.</para>
>  
> @@ -134,6 +136,15 @@ devices.</entry>
>  	  </row>
>  	  <row>
>  	    <entry></entry>
> +	    <entry>&v4l2-pix-format-mplane;</entry>
> +	    <entry><structfield>pix_mp</structfield></entry>
> +	    <entry>Definition of an image format, see <xref
> +		linkend="pixfmt" />, used by video capture and output
> +devices that support the <link linkend="planar-apis">multi-planar
> +version of the API</link>.</entry>
> +	  </row>
> +	  <row>
> +	    <entry></entry>
>  	    <entry>&v4l2-window;</entry>
>  	    <entry><structfield>win</structfield></entry>
>  	    <entry>Definition of an overlaid image, see <xref
> diff --git a/Documentation/DocBook/v4l/vidioc-qbuf.xml b/Documentation/DocBook/v4l/vidioc-qbuf.xml
> index ab691eb..c9e3537 100644
> --- a/Documentation/DocBook/v4l/vidioc-qbuf.xml
> +++ b/Documentation/DocBook/v4l/vidioc-qbuf.xml
> @@ -64,7 +64,8 @@ zero to the number of buffers allocated with &VIDIOC-REQBUFS;
>  contents of the struct <structname>v4l2_buffer</structname> returned
>  by a &VIDIOC-QUERYBUF; ioctl will do as well. When the buffer is
>  intended for output (<structfield>type</structfield> is
> -<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant> or
> +<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT</constant>,
> +<constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE</constant>, or
>  <constant>V4L2_BUF_TYPE_VBI_OUTPUT</constant>) applications must also
>  initialize the <structfield>bytesused</structfield>,
>  <structfield>field</structfield> and
> @@ -75,7 +76,11 @@ supports capturing from specific video inputs and you want to specify a video
>  input, then <structfield>flags</structfield> should be set to
>  <constant>V4L2_BUF_FLAG_INPUT</constant> and the field
>  <structfield>input</structfield> must be initialized to the desired input.
> -The <structfield>reserved</structfield> field must be set to 0.
> +The <structfield>reserved</structfield> field must be set to 0. When using
> +the <link linkend="planar-apis">multi-planar API</link>, the
> +<structfield>m.planes</structfield> field must contain a userspace pointer
> +to an array of &v4l2-plane; filled in and the <structfield>length</structfield>

to a filled-in array of

> +field must be set to the number of elements in that array.
>  </para>
>  
>      <para>To enqueue a <link linkend="mmap">memory mapped</link>
> @@ -93,10 +98,13 @@ structure the driver sets the
>  buffer applications set the <structfield>memory</structfield>
>  field to <constant>V4L2_MEMORY_USERPTR</constant>, the
>  <structfield>m.userptr</structfield> field to the address of the
> -buffer and <structfield>length</structfield> to its size.
> -When <constant>VIDIOC_QBUF</constant> is called with a pointer to this
> -structure the driver sets the <constant>V4L2_BUF_FLAG_QUEUED</constant>
> -flag and clears the <constant>V4L2_BUF_FLAG_MAPPED</constant> and
> +buffer and <structfield>length</structfield> to its size. When multi-planar

When the

> +API is used, <structfield>m.userptr</structfield> and
> +<structfield>length</structfield> members of the passed array of &v4l2-plane;
> +have to be used instead. When <constant>VIDIOC_QBUF</constant> is called with
> +a pointer to this structure the driver sets the
> +<constant>V4L2_BUF_FLAG_QUEUED</constant> flag and clears the
> +<constant>V4L2_BUF_FLAG_MAPPED</constant> and
>  <constant>V4L2_BUF_FLAG_DONE</constant> flags in the
>  <structfield>flags</structfield> field, or it returns an error code.
>  This ioctl locks the memory pages of the buffer in physical memory,
> @@ -115,7 +123,9 @@ remaining fields or returns an error code. The driver may also set
>  <constant>V4L2_BUF_FLAG_ERROR</constant> in the <structfield>flags</structfield>
>  field. It indicates a non-critical (recoverable) streaming error. In such case
>  the application may continue as normal, but should be aware that data in the
> -dequeued buffer might be corrupted.</para>
> +dequeued buffer might be corrupted. When using the multi-planar API, the
> +planes array does not have to be passed; the <structfield>m.planes</structfield>
> +member must be set to NULL in that case.</para>
>  
>      <para>By default <constant>VIDIOC_DQBUF</constant> blocks when no
>  buffer is in the outgoing queue. When the
> diff --git a/Documentation/DocBook/v4l/vidioc-querybuf.xml b/Documentation/DocBook/v4l/vidioc-querybuf.xml
> index e649805..aad79a6 100644
> --- a/Documentation/DocBook/v4l/vidioc-querybuf.xml
> +++ b/Documentation/DocBook/v4l/vidioc-querybuf.xml
> @@ -61,6 +61,10 @@ buffer at any time after buffers have been allocated with the
>  to the number of buffers allocated with &VIDIOC-REQBUFS;
>      (&v4l2-requestbuffers; <structfield>count</structfield>) minus one.
>  The <structfield>reserved</structfield> field should to set to 0.
> +When using the <link linkend="planar-apis">multi-planar API</link>, the
> +<structfield>m.planes</structfield> field must contain a userspace pointer to an
> +array of &v4l2-plane; and the <structfield>length</structfield> field has
> +to be set to the number of elements in that array.
>  After calling <constant>VIDIOC_QUERYBUF</constant> with a pointer to
>      this structure drivers return an error code or fill the rest of
>  the structure.</para>
> @@ -70,11 +74,13 @@ the structure.</para>
>  <constant>V4L2_BUF_FLAG_QUEUED</constant> and
>  <constant>V4L2_BUF_FLAG_DONE</constant> flags will be valid. The
>  <structfield>memory</structfield> field will be set to the current
> -I/O method, the <structfield>m.offset</structfield>
> +I/O method. For single-planar API, the <structfield>m.offset</structfield>

For the

>  contains the offset of the buffer from the start of the device memory,
> -the <structfield>length</structfield> field its size. The driver may
> -or may not set the remaining fields and flags, they are meaningless in
> -this context.</para>
> +the <structfield>length</structfield> field its size. For multi-planar API,

For the

> +fields <structfield>m.mem_offset</structfield> and
> +<structfield>length</structfield> in <structfield>m.planes</structfield> array

in -> in the

> +elements will be used instead. The driver may or may not set the remaining
> +fields and flags, they are meaningless in this context.</para>
>  
>      <para>The <structname>v4l2_buffer</structname> structure is
>      specified in <xref linkend="buffer" />.</para>
> diff --git a/Documentation/DocBook/v4l/vidioc-querycap.xml b/Documentation/DocBook/v4l/vidioc-querycap.xml
> index d499da9..5192bca 100644
> --- a/Documentation/DocBook/v4l/vidioc-querycap.xml
> +++ b/Documentation/DocBook/v4l/vidioc-querycap.xml
> @@ -146,12 +146,26 @@ this array to zero.</entry>
>  linkend="capture">Video Capture</link> interface.</entry>
>  	  </row>
>  	  <row>
> +	    <entry><constant>V4L2_CAP_VIDEO_CAPTURE_MPLANE</constant></entry>
> +	    <entry>0x00001000</entry>
> +	    <entry>The device supports the <link
> +linkend="capture">Video Capture</link> interface through the
> +<link linkend="planar-apis">multi-planar API</link>.</entry>
> +	  </row>
> +	  <row>
>  	    <entry><constant>V4L2_CAP_VIDEO_OUTPUT</constant></entry>
>  	    <entry>0x00000002</entry>
>  	    <entry>The device supports the <link
>  linkend="output">Video Output</link> interface.</entry>
>  	  </row>
>  	  <row>
> +	    <entry><constant>V4L2_CAP_VIDEO_OUTPUT_MPLANE</constant></entry>
> +	    <entry>0x00002000</entry>
> +	    <entry>The device supports the <link
> +linkend="output">Video Output</link> interface through the
> +<link linkend="planar-apis">multi-planar API</link>.</entry>
> +	  </row>
> +	  <row>
>  	    <entry><constant>V4L2_CAP_VIDEO_OVERLAY</constant></entry>
>  	    <entry>0x00000004</entry>
>  	    <entry>The device supports the <link
> 

Thank you for the documentation!

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
