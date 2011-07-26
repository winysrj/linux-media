Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3858 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab1GZKmq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 06:42:46 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v3] V4L: add two new ioctl()s for multi-size videobuffer management
Date: Tue, 26 Jul 2011 12:41:55 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>
References: <Pine.LNX.4.64.1107201025120.12084@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1107201025120.12084@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107261241.55671.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just some typos/documentation improvements:

On Wednesday, July 20, 2011 10:43:08 Guennadi Liakhovetski wrote:
> A possibility to preallocate and initialise buffers of different sizes
> in V4L2 is required for an efficient implementation of asnapshot mode.
> This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> VIDIOC_PREPARE_BUF and defines respective data structures.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> It's been almost a month since v2, the only comments were a request to 
> increase the reserved space in the new ioctl() and to improve 
> documentation. The reserved field is increased in this version, 
> documentation also has been improved in multiple locations. I think, 
> documentation can be further improved at any time, but if there are no 
> objections against the actual contents of this patch, maybe we can commit 
> this version. I still don't see v3.0;-), so, maybe we even can push it for 
> 3.1. A trivial comparison with v2 shows the size of the reserved field as 
> the only change in the API, and the compatibility fix as the only two 
> functional changes.
> 
> v3: addressed multiple comments by Sakari Ailus
> 
> 1. increased reserved field in "struct v4l2_create_buffers" to 8 32-bit 
>    ints
> 2. multiple documentation fixes and improvements
> 3. fixed misplaced "case VIDIOC_PREPARE_BUF" in ioctl 32-bit compatibility 
>    processing
> 
> v2:
> 
> 1. add preliminary Documentation
> 2. add flag V4L2_BUFFER_FLAG_NO_CACHE_CLEAN
> 3. remove VIDIOC_DESTROY_BUFS
> 4. rename SUBMIT to VIDIOC_PREPARE_BUF
> 5. add reserved field to struct v4l2_create_buffers
> 6. cache handling flags moved to struct v4l2_buffer for processing during 
>    VIDIOC_PREPARE_BUF
> 7. VIDIOC_PREPARE_BUF now uses struct v4l2_buffer as its argument
> 
> 
>  Documentation/DocBook/media/v4l/io.xml             |   17 +++
>  Documentation/DocBook/media/v4l/v4l2.xml           |    2 +
>  .../DocBook/media/v4l/vidioc-create-bufs.xml       |  152 ++++++++++++++++++++
>  .../DocBook/media/v4l/vidioc-prepare-buf.xml       |   96 ++++++++++++
>  drivers/media/video/v4l2-compat-ioctl32.c          |   68 ++++++++-
>  drivers/media/video/v4l2-ioctl.c                   |   32 ++++
>  include/linux/videodev2.h                          |   16 ++
>  include/media/v4l2-ioctl.h                         |    2 +
>  8 files changed, 377 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index 227e7ac..6249d0e 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -927,6 +927,23 @@ ioctl is called.</entry>
>  Applications set or clear this flag before calling the
>  <constant>VIDIOC_QBUF</constant> ioctl.</entry>
>  	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant></entry>
> +	    <entry>0x0400</entry>
> +	    <entry>Caches do not have to be invalidated for this buffer.
> +Typically applications shall use this flag, if the data, captured in the buffer

The two commas can be removed in the line above.

> +is not going to br touched by the CPU, instead the buffer will, probably, be

typo: br -> be

> +passed on to a DMA-capable hardware unit for further processing or output.
> +</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant></entry>
> +	    <entry>0x0800</entry>
> +	    <entry>Caches do not have to be cleaned for this buffer.
> +Typically applications shall use this flag for output buffers, if the data

Comma can be removed.

> +in this buffer has not been created by the CPU, but by some DMA-capable unit,

Comma before 'but' can be removed.

> +in which case caches have not been used.</entry>
> +	  </row>
>  	</tbody>
>        </tgroup>
>      </table>
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index 0d05e87..06bb179 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -462,6 +462,7 @@ and discussions on the V4L mailing list.</revremark>
>      &sub-close;
>      &sub-ioctl;
>      <!-- All ioctls go here. -->
> +    &sub-create-bufs;
>      &sub-cropcap;
>      &sub-dbg-g-chip-ident;
>      &sub-dbg-g-register;
> @@ -504,6 +505,7 @@ and discussions on the V4L mailing list.</revremark>
>      &sub-queryctrl;
>      &sub-query-dv-preset;
>      &sub-querystd;
> +    &sub-prepare-buf;
>      &sub-reqbufs;
>      &sub-s-hw-freq-seek;
>      &sub-streamon;
> diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> new file mode 100644
> index 0000000..5f0158c
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> @@ -0,0 +1,152 @@
> +<refentry id="vidioc-create-bufs">
> +  <refmeta>
> +    <refentrytitle>ioctl VIDIOC_CREATE_BUFS</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +
> +  <refnamediv>
> +    <refname>VIDIOC_CREATE_BUFS</refname>
> +    <refpurpose>Create buffers for Memory Mapped or User Pointer I/O</refpurpose>
> +  </refnamediv>
> +
> +  <refsynopsisdiv>
> +    <funcsynopsis>
> +      <funcprototype>
> +	<funcdef>int <function>ioctl</function></funcdef>
> +	<paramdef>int <parameter>fd</parameter></paramdef>
> +	<paramdef>int <parameter>request</parameter></paramdef>
> +	<paramdef>struct v4l2_create_buffers *<parameter>argp</parameter></paramdef>
> +      </funcprototype>
> +    </funcsynopsis>
> +  </refsynopsisdiv>
> +
> +  <refsect1>
> +    <title>Arguments</title>
> +
> +    <variablelist>
> +      <varlistentry>
> +	<term><parameter>fd</parameter></term>
> +	<listitem>
> +	  <para>&fd;</para>
> +	</listitem>
> +      </varlistentry>
> +      <varlistentry>
> +	<term><parameter>request</parameter></term>
> +	<listitem>
> +	  <para>VIDIOC_CREATE_BUFS</para>
> +	</listitem>
> +      </varlistentry>
> +      <varlistentry>
> +	<term><parameter>argp</parameter></term>
> +	<listitem>
> +	  <para></para>
> +	</listitem>
> +      </varlistentry>
> +    </variablelist>
> +  </refsect1>
> +
> +  <refsect1>
> +    <title>Description</title>
> +
> +    <para>This ioctl is used to create buffers for <link linkend="mmap">memory
> +mapped</link> or <link linkend="userp">user pointer</link>
> +I/O. It can be used as an alternative to the <constant>VIDIOC_REQBUFS</constant>
> +ioctl, when a tighter control over buffers is required. This ioctl can be called
> +multiple times to create buffers of different sizes.
> +
> +    <para>To allocate device buffers applications initialize all
> +fields of the <structname>v4l2_create_buffers</structname> structure.
> +They set the <structfield>type</structfield> field in the
> +<structname>v4l2_format</structname> structure, embedded in this
> +structure, to the respective stream or buffer type.
> +<structfield>count</structfield> must be set to the number of required
> +buffers. <structfield>memory</structfield> specifies the required I/O
> +method. Applications have two possibilities to specify the size of buffers
> +to be prepared: they can either set the <structfield>size</structfield>
> +field explicitly to a non-zero value, or fill in the frame format data in the
> +<structfield>format</structfield> field. In the latter case buffer sizes
> +will be calculated automatically by the driver. The
> +<structfield>reserved</structfield> array must be zeroed. When the ioctl
> +is called with a pointer to this structure the driver will attempt to allocate
> +up to the requested number of buffers and store the actual number allocated
> +and the starting index in the <structfield>count</structfield> and
> +the <structfield>index</structfield> fields respectively.
> +<structfield>count</structfield> can be smaller than the number requested.
> +-ENOMEM is returned, if the driver runs out of free memory.</para>
> +    <para>When the I/O method is not supported the ioctl
> +returns an &EINVAL;.</para>
> +
> +    <table pgwide="1" frame="none" id="v4l2-create-buffers">
> +      <title>struct <structname>v4l2_create_buffers</structname></title>
> +      <tgroup cols="3">
> +	&cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>index</structfield></entry>
> +	    <entry>The starting buffer index, returned by the driver.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>count</structfield></entry>
> +	    <entry>The number of buffers requested or granted.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>&v4l2-memory;</entry>
> +	    <entry><structfield>memory</structfield></entry>
> +	    <entry>Applications set this field to
> +<constant>V4L2_MEMORY_MMAP</constant> or
> +<constant>V4L2_MEMORY_USERPTR</constant>.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>size</structfield></entry>
> +	    <entry>Explicit size of buffers, being created.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>&v4l2-format;</entry>
> +	    <entry><structfield>format</structfield></entry>
> +	    <entry>Application has to set the <structfield>type</structfield>
> +field, other fields should be used, if the application wants to allocate buffers
> +for a specific frame format.</entry>

This sentence doesn't make sense to me.

I suggest:

	    <entry>The application must always set the <structfield>type</structfield>
field of &v4l2-format. The other fields only need to be set if the application set the
<structfield>size</structfield> field to 0. In that case the driver will allocated
buffers for that specific frame format.</entry>

> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved</structfield>[8]</entry>
> +	    <entry>A place holder for future extensions.</entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +  </refsect1>
> +
> +  <refsect1>
> +    &return-value;
> +
> +    <variablelist>
> +      <varlistentry>
> +	<term><errorcode>ENOMEM</errorcode></term>
> +	<listitem>
> +	  <para>No memory to allocate buffers for <link linkend="mmap">memory
> +mapped</link> I/O.</para>
> +	</listitem>
> +      </varlistentry>
> +      <varlistentry>
> +	<term><errorcode>EINVAL</errorcode></term>
> +	<listitem>
> +	  <para>The buffer type (<structfield>type</structfield> field) or the
> +requested I/O method (<structfield>memory</structfield>) is not
> +supported.</para>
> +	</listitem>
> +      </varlistentry>
> +    </variablelist>
> +  </refsect1>
> +</refentry>
> +
> +<!--
> +Local Variables:
> +mode: sgml
> +sgml-parent-document: "v4l2.sgml"
> +indent-tabs-mode: nil
> +End:
> +-->
> diff --git a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> new file mode 100644
> index 0000000..509e752
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> @@ -0,0 +1,96 @@
> +<refentry id="vidioc-prepare-buf">
> +  <refmeta>
> +    <refentrytitle>ioctl VIDIOC_PREPARE_BUF</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +
> +  <refnamediv>
> +    <refname>VIDIOC_PREPARE_BUF</refname>
> +    <refpurpose>Prepare a buffer for I/O</refpurpose>
> +  </refnamediv>
> +
> +  <refsynopsisdiv>
> +    <funcsynopsis>
> +      <funcprototype>
> +	<funcdef>int <function>ioctl</function></funcdef>
> +	<paramdef>int <parameter>fd</parameter></paramdef>
> +	<paramdef>int <parameter>request</parameter></paramdef>
> +	<paramdef>struct v4l2_buffer *<parameter>argp</parameter></paramdef>
> +      </funcprototype>
> +    </funcsynopsis>
> +  </refsynopsisdiv>
> +
> +  <refsect1>
> +    <title>Arguments</title>
> +
> +    <variablelist>
> +      <varlistentry>
> +	<term><parameter>fd</parameter></term>
> +	<listitem>
> +	  <para>&fd;</para>
> +	</listitem>
> +      </varlistentry>
> +      <varlistentry>
> +	<term><parameter>request</parameter></term>
> +	<listitem>
> +	  <para>VIDIOC_PREPARE_BUF</para>
> +	</listitem>
> +      </varlistentry>
> +      <varlistentry>
> +	<term><parameter>argp</parameter></term>
> +	<listitem>
> +	  <para></para>
> +	</listitem>
> +      </varlistentry>
> +    </variablelist>
> +  </refsect1>
> +
> +  <refsect1>
> +    <title>Description</title>
> +
> +    <para>Applications can optionally call the
> +<constant>VIDIOC_PREPARE_BUF</constant> ioctl to pass ownership of the buffer
> +to the driver before actually enqueuing it, using the
> +<constant>VIDIOC_QBUF</constant> ioctl, and to prepare it for future I/O.
> +Such preparations may include cache invalidation or cleaning. Performing them
> +in advance saves time during the actual I/O. In case such cache operations are
> +not required, the application can use one of
> +<constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant> and
> +<constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant> flags to skip the respective
> +step.</para>
> +
> +    <para>The <structname>v4l2_buffer</structname> structure is
> +specified in <xref linkend="buffer" />.</para>
> +  </refsect1>
> +
> +  <refsect1>
> +    &return-value;
> +
> +    <variablelist>
> +      <varlistentry>
> +	<term><errorcode>EBUSY</errorcode></term>
> +	<listitem>
> +	  <para>File I/O is in progress.</para>
> +	</listitem>
> +      </varlistentry>
> +      <varlistentry>
> +	<term><errorcode>EINVAL</errorcode></term>
> +	<listitem>
> +	  <para>The buffer <structfield>type</structfield> is not
> +supported, or the <structfield>index</structfield> is out of bounds,
> +or no buffers have been allocated yet, or the
> +<structfield>userptr</structfield> or
> +<structfield>length</structfield> are invalid.</para>
> +	</listitem>
> +      </varlistentry>
> +    </variablelist>
> +  </refsect1>
> +</refentry>
> +
> +<!--
> +Local Variables:
> +mode: sgml
> +sgml-parent-document: "v4l2.sgml"
> +indent-tabs-mode: nil
> +End:
> +-->
> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
> index 61979b7..4105f69 100644
> --- a/drivers/media/video/v4l2-compat-ioctl32.c
> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
> @@ -159,11 +159,16 @@ struct v4l2_format32 {
>  	} fmt;
>  };
>  
> -static int get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
> +struct v4l2_create_buffers32 {
> +	__u32			index;		/* output: buffers index...index + count - 1 have been created */
> +	__u32			count;
> +	enum v4l2_memory        memory;
> +	__u32			size;		/* Explicit size, e.g., for compressed streams */
> +	struct v4l2_format32	format;		/* "type" is used always, the rest if size == 0 */
> +};
> +
> +static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
>  {
> -	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_format32)) ||
> -			get_user(kp->type, &up->type))
> -			return -EFAULT;
>  	switch (kp->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> @@ -192,11 +197,24 @@ static int get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user
>  	}
>  }
>  
> -static int put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
> +static int get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
> +{
> +	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_format32)) ||
> +			get_user(kp->type, &up->type))
> +			return -EFAULT;
> +	return __get_v4l2_format32(kp, up);
> +}
> +
> +static int get_v4l2_create32(struct v4l2_create_buffers *kp, struct v4l2_create_buffers32 __user *up)
> +{
> +	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_create_buffers32)) ||
> +	    copy_from_user(kp, up, offsetof(struct v4l2_create_buffers32, format.fmt)))
> +			return -EFAULT;
> +	return __get_v4l2_format32(&kp->format, &up->format);
> +}
> +
> +static int __put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
>  {
> -	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_format32)) ||
> -		put_user(kp->type, &up->type))
> -		return -EFAULT;
>  	switch (kp->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> @@ -225,6 +243,22 @@ static int put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user
>  	}
>  }
>  
> +static int put_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
> +{
> +	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_format32)) ||
> +		put_user(kp->type, &up->type))
> +		return -EFAULT;
> +	return __put_v4l2_format32(kp, up);
> +}
> +
> +static int put_v4l2_create32(struct v4l2_create_buffers *kp, struct v4l2_create_buffers32 __user *up)
> +{
> +	if (!access_ok(VERIFY_WRITE, up, sizeof(struct v4l2_create_buffers32)) ||
> +	    copy_to_user(up, kp, offsetof(struct v4l2_create_buffers32, format.fmt)))
> +			return -EFAULT;
> +	return __put_v4l2_format32(&kp->format, &up->format);
> +}
> +
>  struct v4l2_standard32 {
>  	__u32		     index;
>  	__u32		     id[2]; /* __u64 would get the alignment wrong */
> @@ -702,6 +736,8 @@ static int put_v4l2_event32(struct v4l2_event *kp, struct v4l2_event32 __user *u
>  #define VIDIOC_S_EXT_CTRLS32    _IOWR('V', 72, struct v4l2_ext_controls32)
>  #define VIDIOC_TRY_EXT_CTRLS32  _IOWR('V', 73, struct v4l2_ext_controls32)
>  #define	VIDIOC_DQEVENT32	_IOR ('V', 89, struct v4l2_event32)
> +#define VIDIOC_CREATE_BUFS32	_IOWR('V', 92, struct v4l2_create_buffers32)
> +#define VIDIOC_PREPARE_BUF32	_IOWR('V', 93, struct v4l2_buffer32)
>  
>  #define VIDIOC_OVERLAY32	_IOW ('V', 14, s32)
>  #define VIDIOC_STREAMON32	_IOW ('V', 18, s32)
> @@ -721,6 +757,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  		struct v4l2_standard v2s;
>  		struct v4l2_ext_controls v2ecs;
>  		struct v4l2_event v2ev;
> +		struct v4l2_create_buffers v2crt;
>  		unsigned long vx;
>  		int vi;
>  	} karg;
> @@ -751,6 +788,8 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  	case VIDIOC_S_INPUT32: cmd = VIDIOC_S_INPUT; break;
>  	case VIDIOC_G_OUTPUT32: cmd = VIDIOC_G_OUTPUT; break;
>  	case VIDIOC_S_OUTPUT32: cmd = VIDIOC_S_OUTPUT; break;
> +	case VIDIOC_CREATE_BUFS32: cmd = VIDIOC_CREATE_BUFS; break;
> +	case VIDIOC_PREPARE_BUF32: cmd = VIDIOC_PREPARE_BUF; break;
>  	}
>  
>  	switch (cmd) {
> @@ -775,6 +814,12 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  		compatible_arg = 0;
>  		break;
>  
> +	case VIDIOC_CREATE_BUFS:
> +		err = get_v4l2_create32(&karg.v2crt, up);
> +		compatible_arg = 0;
> +		break;
> +
> +	case VIDIOC_PREPARE_BUF:
>  	case VIDIOC_QUERYBUF:
>  	case VIDIOC_QBUF:
>  	case VIDIOC_DQBUF:
> @@ -860,6 +905,11 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  		err = put_v4l2_format32(&karg.v2f, up);
>  		break;
>  
> +	case VIDIOC_CREATE_BUFS:
> +		err = put_v4l2_create32(&karg.v2crt, up);
> +		break;
> +
> +	case VIDIOC_PREPARE_BUF:
>  	case VIDIOC_QUERYBUF:
>  	case VIDIOC_QBUF:
>  	case VIDIOC_DQBUF:
> @@ -959,6 +1009,8 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
>  	case VIDIOC_DQEVENT32:
>  	case VIDIOC_SUBSCRIBE_EVENT:
>  	case VIDIOC_UNSUBSCRIBE_EVENT:
> +	case VIDIOC_CREATE_BUFS32:
> +	case VIDIOC_PREPARE_BUF32:
>  		ret = do_video_ioctl(file, cmd, arg);
>  		break;
>  
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 002ce13..7824152 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -260,6 +260,8 @@ static const char *v4l2_ioctls[] = {
>  	[_IOC_NR(VIDIOC_DQEVENT)]	   = "VIDIOC_DQEVENT",
>  	[_IOC_NR(VIDIOC_SUBSCRIBE_EVENT)]  = "VIDIOC_SUBSCRIBE_EVENT",
>  	[_IOC_NR(VIDIOC_UNSUBSCRIBE_EVENT)] = "VIDIOC_UNSUBSCRIBE_EVENT",
> +	[_IOC_NR(VIDIOC_CREATE_BUFS)]      = "VIDIOC_CREATE_BUFS",
> +	[_IOC_NR(VIDIOC_PREPARE_BUF)]      = "VIDIOC_PREPARE_BUF",
>  };
>  #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
>  
> @@ -2216,6 +2218,36 @@ static long __video_do_ioctl(struct file *file,
>  		dbgarg(cmd, "type=0x%8.8x", sub->type);
>  		break;
>  	}
> +	case VIDIOC_CREATE_BUFS:
> +	{
> +		struct v4l2_create_buffers *create = arg;
> +
> +		if (!ops->vidioc_create_bufs)
> +			break;
> +		ret = check_fmt(ops, create->format.type);
> +		if (ret)
> +			break;
> +
> +		if (create->size)
> +			CLEAR_AFTER_FIELD(create, count);
> +
> +		ret = ops->vidioc_create_bufs(file, fh, create);
> +
> +		dbgarg(cmd, "count=%d\n", create->count);
> +		break;
> +	}
> +	case VIDIOC_PREPARE_BUF:
> +	{
> +		struct v4l2_buffer *b = arg;
> +
> +		if (!ops->vidioc_prepare_buf)
> +			break;
> +
> +		ret = ops->vidioc_prepare_buf(file, fh, b);
> +
> +		dbgarg(cmd, "index=%d", b->index);
> +		break;
> +	}
>  	default:
>  	{
>  		bool valid_prio = true;
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index fca24cc..0b594c7 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -653,6 +653,9 @@ struct v4l2_buffer {
>  #define V4L2_BUF_FLAG_ERROR	0x0040
>  #define V4L2_BUF_FLAG_TIMECODE	0x0100	/* timecode field is valid */
>  #define V4L2_BUF_FLAG_INPUT     0x0200  /* input field is valid */
> +/* Cache handling flags */
> +#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0400
> +#define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x0800
>  
>  /*
>   *	O V E R L A Y   P R E V I E W
> @@ -2092,6 +2095,16 @@ struct v4l2_dbg_chip_ident {
>  	__u32 revision;    /* chip revision, chip specific */
>  } __attribute__ ((packed));
>  
> +/* VIDIOC_CREATE_BUFS */
> +struct v4l2_create_buffers {
> +	__u32			index;		/* output: buffers index...index + count - 1 have been created */
> +	__u32			count;
> +	enum v4l2_memory        memory;
> +	__u32			size;		/* Explicit size, e.g., for compressed streams */
> +	struct v4l2_format	format;		/* "type" is used always, the rest if size == 0 */
> +	__u32			reserved[8];
> +};
> +
>  /*
>   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
>   *
> @@ -2182,6 +2195,9 @@ struct v4l2_dbg_chip_ident {
>  #define	VIDIOC_SUBSCRIBE_EVENT	 _IOW('V', 90, struct v4l2_event_subscription)
>  #define	VIDIOC_UNSUBSCRIBE_EVENT _IOW('V', 91, struct v4l2_event_subscription)
>  
> +#define VIDIOC_CREATE_BUFS	_IOWR('V', 92, struct v4l2_create_buffers)
> +#define VIDIOC_PREPARE_BUF	 _IOW('V', 93, struct v4l2_buffer)
> +
>  /* Reminder: when adding new ioctls please add support for them to
>     drivers/media/video/v4l2-compat-ioctl32.c as well! */
>  
> diff --git a/include/media/v4l2-ioctl.h b/include/media/v4l2-ioctl.h
> index dd9f1e7..4d1c74a 100644
> --- a/include/media/v4l2-ioctl.h
> +++ b/include/media/v4l2-ioctl.h
> @@ -122,6 +122,8 @@ struct v4l2_ioctl_ops {
>  	int (*vidioc_qbuf)    (struct file *file, void *fh, struct v4l2_buffer *b);
>  	int (*vidioc_dqbuf)   (struct file *file, void *fh, struct v4l2_buffer *b);
>  
> +	int (*vidioc_create_bufs)(struct file *file, void *fh, struct v4l2_create_buffers *b);
> +	int (*vidioc_prepare_buf)(struct file *file, void *fh, struct v4l2_buffer *b);
>  
>  	int (*vidioc_overlay) (struct file *file, void *fh, unsigned int i);
>  	int (*vidioc_g_fbuf)   (struct file *file, void *fh,
> 

Regards,

	Hans
