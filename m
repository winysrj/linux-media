Return-path: <mchehab@pedra>
Received: from smtp-68.nebula.fi ([83.145.220.68]:45878 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab1F0QCb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Jun 2011 12:02:31 -0400
Date: Mon, 27 Jun 2011 19:02:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH/RFC v2] V4L: add two new ioctl()s for multi-size
 videobuffer management
Message-ID: <20110627160224.GF12671@valkosipuli.localdomain>
References: <Pine.LNX.4.64.1106271710490.9394@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1106271710490.9394@axis700.grange>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi, Guennadi!

Many thanks for the patch!

On Mon, Jun 27, 2011 at 05:17:03PM +0200, Guennadi Liakhovetski wrote:
> A possibility to preallocate and initialise buffers of different sizes
> in V4L2 is required for an efficient implementation of asnapshot mode.
> This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> VIDIOC_PREPARE_BUF and defines respective data structures.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
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
>  Documentation/DocBook/media/v4l/v4l2.xml           |    2 +
>  .../DocBook/media/v4l/vidioc-create-bufs.xml       |  153 ++++++++++++++++++++
>  .../DocBook/media/v4l/vidioc-prepare-buf.xml       |   96 ++++++++++++
>  drivers/media/video/v4l2-compat-ioctl32.c          |   68 ++++++++-
>  drivers/media/video/v4l2-ioctl.c                   |   32 ++++
>  include/linux/videodev2.h                          |   16 ++
>  include/media/v4l2-ioctl.h                         |    2 +
>  7 files changed, 361 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index a7fd76d..10fe7c7 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -453,6 +453,7 @@ and discussions on the V4L mailing list.</revremark>
>      &sub-close;
>      &sub-ioctl;
>      <!-- All ioctls go here. -->
> +    &sub-create-bufs;
>      &sub-cropcap;
>      &sub-dbg-g-chip-ident;
>      &sub-dbg-g-register;
> @@ -495,6 +496,7 @@ and discussions on the V4L mailing list.</revremark>
>      &sub-queryctrl;
>      &sub-query-dv-preset;
>      &sub-querystd;
> +    &sub-prepare-buf;
>      &sub-reqbufs;
>      &sub-s-hw-freq-seek;
>      &sub-streamon;
> diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> new file mode 100644
> index 0000000..3003530
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> @@ -0,0 +1,153 @@
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
> +    <para>To allocate device buffers applications initialize all
> +fields of the <structname>v4l2_create_buffers</structname> structure.
> +They set the <structfield>type</structfield> field in the
> +<structname>v4l2_format</structname> structure, embedded in this
> +structure, to the respective stream or buffer type.
> +<structfield>count</structfield> must be set to the number of required
> +buffers. <structfield>memory</structfield> specifies the required I/O
> +method. Applications have two possibilities to specify the size of buffers
> +to be prepared: they can either set the <structfield>size</structfield>
> +field explicitly, or fill in the frame format data in the

... explicitly -> to non-zero value... ?

> +<structfield>format</structfield> field. In the latter case buffer sizes
> +will be calculated automatically by the driver. The
> +<structfield>reserved</structfield> array must be zeroed. When the ioctl
> +is called with a pointer to this structure the driver will attempt to allocate
> +the requested number of buffers and it stores the actual number
> +allocated and the starting index in the <structfield>count</structfield> and
> +the <structfield>index</structfield> fields respectively.

REQBUFS documentation does not mention that the buffer indices would be
limited to VIDEO_MAX_FRAME but they actually are (I think). Do you think we
could mention that the buffer indices obtained by CREATE_BUFS are _not_
limited to that number, for the reasons I pointed to at an earlier review
round of this patch?

Even if the actual implementation would be limited to VIDEO_MAX_FRAME for
now the applications wouldn't start assuming that.

> +<structfield>count</structfield> can be smaller than the number requested,
> +even zero, when the driver runs out of free memory. A larger number is also

As -ENOMEM is a valid error code I don't think there's use for returning
count == 0.

> +possible when the driver requires more buffers to function correctly.</para>

I'm not sure if I still like the idea of telling the user that n buffers are
required for streaming by creating that many buffer objects. The user may
also create more buffers and use them for streaming instead of the ones the
driver created at the first call.

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
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved</structfield>[2]</entry>
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

A stupid question: don't we want to do actual allocation in PREPARE_BUF
instead? Or is this a policy issue rather than something that results from
an actual memory allocation failure?

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
> index 0000000..9532d28
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
> +<constant>VIDIOC_PREPARE_BUF</constant> ioctl
> +to pass ownership of the buffer to the driver before actually enqueuing it, and
> +to prepare it for future I/O.
> +Such preparations may include cache invalidation or cleaning. Performing them
> +in advance saves time during the actual I/O. In case such cache operations are
> +not required, the application can use one of
> +<constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant> and
> +<constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant> flags to skip the respective
> +step.</para>

The flags should be documented as part of struct v4l2_buffer documentation
as they are specific to the structure field rather than the ioctl. Wouldn't
they be valid for QBUF and DQBUF as well --- actually they are more
important there IMO.

PREPARE_BUF only needs to be called right after CREATE_BUFS (or REQBUFS);
otherwise it has no effect, or does it? This should also thus define the
default cache behaviour for QBUF and DQBUF.

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
> index 7c26947..6fcc7e0 100644
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
> @@ -675,6 +709,8 @@ static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp, struct v4l2_ext
>  #define VIDIOC_G_EXT_CTRLS32    _IOWR('V', 71, struct v4l2_ext_controls32)
>  #define VIDIOC_S_EXT_CTRLS32    _IOWR('V', 72, struct v4l2_ext_controls32)
>  #define VIDIOC_TRY_EXT_CTRLS32  _IOWR('V', 73, struct v4l2_ext_controls32)
> +#define VIDIOC_CREATE_BUFS32	_IOWR('V', 92, struct v4l2_create_buffers32)
> +#define VIDIOC_PREPARE_BUF32	_IOWR('V', 93, struct v4l2_buffer32)
>  
>  #define VIDIOC_OVERLAY32	_IOW ('V', 14, s32)
>  #define VIDIOC_STREAMON32	_IOW ('V', 18, s32)
> @@ -693,6 +729,7 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  		struct v4l2_input v2i;
>  		struct v4l2_standard v2s;
>  		struct v4l2_ext_controls v2ecs;
> +		struct v4l2_create_buffers v2crt;
>  		unsigned long vx;
>  		int vi;
>  	} karg;
> @@ -722,6 +759,8 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  	case VIDIOC_S_INPUT32: cmd = VIDIOC_S_INPUT; break;
>  	case VIDIOC_G_OUTPUT32: cmd = VIDIOC_G_OUTPUT; break;
>  	case VIDIOC_S_OUTPUT32: cmd = VIDIOC_S_OUTPUT; break;
> +	case VIDIOC_CREATE_BUFS32: cmd = VIDIOC_CREATE_BUFS; break;
> +	case VIDIOC_PREPARE_BUF32: cmd = VIDIOC_PREPARE_BUF; break;
>  	}
>  
>  	switch (cmd) {
> @@ -746,6 +785,12 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
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
> @@ -818,6 +863,11 @@ static long do_video_ioctl(struct file *file, unsigned int cmd, unsigned long ar
>  		err = put_v4l2_framebuffer32(&karg.v2fb, up);
>  		break;
>  
> +	case VIDIOC_CREATE_BUFS:
> +		err = put_v4l2_create32(&karg.v2crt, up);
> +		break;
> +
> +	case VIDIOC_PREPARE_BUF:
>  	case VIDIOC_G_FMT:
>  	case VIDIOC_S_FMT:
>  	case VIDIOC_TRY_FMT:
> @@ -922,6 +972,8 @@ long v4l2_compat_ioctl32(struct file *file, unsigned int cmd, unsigned long arg)
>  	case VIDIOC_DQEVENT:
>  	case VIDIOC_SUBSCRIBE_EVENT:
>  	case VIDIOC_UNSUBSCRIBE_EVENT:
> +	case VIDIOC_CREATE_BUFS32:
> +	case VIDIOC_PREPARE_BUF32:
>  		ret = do_video_ioctl(file, cmd, arg);
>  		break;
>  
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 213ba7d..40b8d96 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -259,6 +259,8 @@ static const char *v4l2_ioctls[] = {
>  	[_IOC_NR(VIDIOC_DQEVENT)]	   = "VIDIOC_DQEVENT",
>  	[_IOC_NR(VIDIOC_SUBSCRIBE_EVENT)]  = "VIDIOC_SUBSCRIBE_EVENT",
>  	[_IOC_NR(VIDIOC_UNSUBSCRIBE_EVENT)] = "VIDIOC_UNSUBSCRIBE_EVENT",
> +	[_IOC_NR(VIDIOC_CREATE_BUFS)]      = "VIDIOC_CREATE_BUFS",
> +	[_IOC_NR(VIDIOC_PREPARE_BUF)]      = "VIDIOC_PREPARE_BUF",
>  };
>  #define V4L2_IOCTLS ARRAY_SIZE(v4l2_ioctls)
>  
> @@ -2184,6 +2186,36 @@ static long __video_do_ioctl(struct file *file,
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
> index 8a4c309..8807462 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -643,6 +643,9 @@ struct v4l2_buffer {
>  #define V4L2_BUF_FLAG_ERROR	0x0040
>  #define V4L2_BUF_FLAG_TIMECODE	0x0100	/* timecode field is valid */
>  #define V4L2_BUF_FLAG_INPUT     0x0200  /* input field is valid */
> +/* Cache handling flags */
> +#define V4L2_BUF_FLAG_NO_CACHE_INVALIDATE	0x0400
> +#define V4L2_BUF_FLAG_NO_CACHE_CLEAN		0x0800
>  
>  /*
>   *	O V E R L A Y   P R E V I E W
> @@ -1852,6 +1855,16 @@ struct v4l2_dbg_chip_ident {
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
> +	__u32			reserved[4];

I think we should have more reserved fields. What about 8 at least?

It doesn't matter much as long as we keep this under 256 bytes (struct
v4l2_format is 204 bytes). Also the number of reserved fields is different
from the documentation above.

> +};
> +
>  /*
>   *	I O C T L   C O D E S   F O R   V I D E O   D E V I C E S
>   *
> @@ -1942,6 +1955,9 @@ struct v4l2_dbg_chip_ident {
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
> -- 
> 1.7.2.5
> 

Cheers,

-- 
Sakari Ailus
sakari.ailus@iki.fi
