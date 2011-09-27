Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3636 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab1I0KvM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 06:51:12 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 3/9 v7] V4L: document the new VIDIOC_CREATE_BUFS and VIDIOC_PREPARE_BUF ioctl()s
Date: Tue, 27 Sep 2011 12:51:01 +0200
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <1314813768-27752-1-git-send-email-g.liakhovetski@gmx.de> <Pine.LNX.4.64.1109080942172.31156@axis700.grange> <Pine.LNX.4.64.1109080945290.31156@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1109080945290.31156@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271251.01367.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, September 08, 2011 09:46:26 Guennadi Liakhovetski wrote:
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 
> v7: added to the experimental list in compat.xml
> 
>  Documentation/DocBook/media/v4l/compat.xml         |    3 +
>  Documentation/DocBook/media/v4l/io.xml             |   17 +++
>  Documentation/DocBook/media/v4l/v4l2.xml           |    2 +
>  .../DocBook/media/v4l/vidioc-create-bufs.xml       |  147 ++++++++++++++++++++
>  .../DocBook/media/v4l/vidioc-prepare-buf.xml       |   96 +++++++++++++
>  5 files changed, 265 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index ce1004a..91f8977 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2478,6 +2478,9 @@ ioctls.</para>
>          <listitem>
>  	  <para>Flash API. <xref linkend="flash-controls" /></para>
>          </listitem>
> +        <listitem>
> +	  <para>&VIDIOC-CREATE-BUFS; and &VIDIOC-PREPARE-BUF; ioctls.</para>
> +        </listitem>
>        </itemizedlist>
>      </section>
>  
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index c57d1ec..74ead1e 100644
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
> +Typically applications shall use this flag if the data captured in the buffer
> +is not going to be touched by the CPU, instead the buffer will, probably, be
> +passed on to a DMA-capable hardware unit for further processing or output.
> +</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant></entry>
> +	    <entry>0x0800</entry>
> +	    <entry>Caches do not have to be cleaned for this buffer.
> +Typically applications shall use this flag for output buffers if the data
> +in this buffer has not been created by the CPU but by some DMA-capable unit,
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
> index 0000000..eb99604
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> @@ -0,0 +1,147 @@
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
> +I/O. It can be used as an alternative or in addition to the
> +<constant>VIDIOC_REQBUFS</constant> ioctl, when a tighter control over buffers
> +is required. This ioctl can be called multiple times to create buffers of
> +different sizes.</para>
> +
> +    <para>To allocate device buffers applications initialize relevant fields of
> +the <structname>v4l2_create_buffers</structname> structure. They set the
> +<structfield>type</structfield> field in the
> +<structname>v4l2_format</structname> structure, embedded in this
> +structure, to the respective stream or buffer type.
> +<structfield>count</structfield> must be set to the number of required buffers.
> +<structfield>memory</structfield> specifies the required I/O method. The
> +<structfield>format</structfield> field shall typically be filled in using
> +either the <constant>VIDIOC_TRY_FMT</constant> or
> +<constant>VIDIOC_G_FMT</constant> ioctl(). Additionally, applications can adjust
> +<structfield>sizeimage</structfield> fields to fit their specific needs. The
> +<structfield>reserved</structfield> array must be zeroed.</para>
> +
> +    <para>When the ioctl is called with a pointer to this structure the driver
> +will attempt to allocate up to the requested number of buffers and store the
> +actual number allocated and the starting index in the
> +<structfield>count</structfield> and the <structfield>index</structfield> fields
> +respectively. On return <structfield>count</structfield> can be smaller than
> +the number requested. The driver may also adjust buffer sizes as it sees fit,

Add: 'provided the size is greater than or equal to sizeimage'.

That's very important!

Otherwise everything looks fine to me.

Regards,

	Hans

> +however, it will not update <structfield>sizeimage</structfield> fields, the
> +user has to use <constant>VIDIOC_QUERYBUF</constant> to retrieve that
> +information.</para>
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
> +	    <entry>&v4l2-format;</entry>
> +	    <entry><structfield>format</structfield></entry>
> +	    <entry>Filled in by the application, preserved by the driver.</entry>
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
> 
