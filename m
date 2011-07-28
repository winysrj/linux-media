Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3035 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab1G1G6H (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 02:58:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH v3] V4L: add two new ioctl()s for multi-size videobuffer management
Date: Thu, 28 Jul 2011 08:56:55 +0200
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <Pine.LNX.4.64.1107201025120.12084@axis700.grange> <CAMm-=zB3dOJyCy7ZhqiTQkeL2b=Dvtz8geMR8zbHYBCVR6=pEw@mail.gmail.com>
In-Reply-To: <CAMm-=zB3dOJyCy7ZhqiTQkeL2b=Dvtz8geMR8zbHYBCVR6=pEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107280856.55731.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, July 28, 2011 06:11:38 Pawel Osciak wrote:
> Hi Guennadi,
> 
> On Wed, Jul 20, 2011 at 01:43, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > A possibility to preallocate and initialise buffers of different sizes
> > in V4L2 is required for an efficient implementation of asnapshot mode.
> > This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> > VIDIOC_PREPARE_BUF and defines respective data structures.
> >
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> >
> <snip>
> 
> This looks nicer, I like how we got rid of destroy and gave up on
> making holes, it would've given us a lot of headaches. I'm thinking
> about some issues though and also have some comments/questions further
> below.
> 
> Already mentioned by others mixing of REQBUFS and CREATE_BUFS.
> Personally I'd like to allow mixing, including REQBUFS for non-zero,
> because I think it would be easy to do. I think it could work in the
> same way as REQBUFS for !=0 works currently (at least in vb2), if we
> already have some buffers allocated and they are not in use, we free
> them and a new set is allocated. So I guess it could just stay this
> way. REQBUFS(0) would of course free everything.
> 
> Passing format to CREATE_BUFS will make vb2 a bit format-aware, as it
> would have to pass it forward to the driver somehow. The obvious way
> would be just vb2 calling the driver's s_fmt handler, but that won't
> work, as you can't pass indexes to s_fmt. So we'd have to implement a
> new driver callback for setting formats per index. I guess there is no
> way around it, unless we actually take the format struct out of
> CREATE_BUFS and somehow do it via S_FMT. The single-planar structure
> is full already though, the only way would be to use
> v4l2_pix_format_mplane instead with plane count = 1 (or more if
> needed).

I just got an idea for this: use TRY_FMT. That will do exactly what
you want. In fact, perhaps we should remove the format struct from
CREATE_BUFS and use __u32 sizes[VIDEO_MAX_PLANES] instead. Let the
application call TRY_FMT and initialize the sizes array instead of
putting that into vb2. We may need a num_planes field as well. If the
sizes are all 0 (or num_planes is 0), then the driver can use the current
format, just as it does with REQBUFS.

Or am I missing something?

> Another thing is the case of passing size to CREATE_BUFS. vb2, when
> allocating buffers, gets their sizes from the driver (via
> queue_setup), it never "suggest" any particular size. So that flow
> would have to be changed as well. I guess vb2 could pass the size to
> queue_setup in a similar way as it does with buffer count. This would
> mean though that the ioctl would fail if the driver didn't agree to
> the given size. Right now I don't see an option to "negotiate" the
> size with the driver via this option.

I think the driver can always increase the size if needed and return the
new size.

> 
> The more I think of it though, why do we need the size argument? It's
> not needed in the existing flows (that use S_FMT) and, more
> importantly, I don't think the application can know more than the
> driver can, so why giving that option? The driver should know the size
> for a format at least as well as the application... Also, is there a
> real use case of providing just size, will the driver know which
> format to use given a size?

There are cases where you want a larger buffer size than the format
really required. The most common case being 1920x1080 formats where you
want to capture in a 1920x1088 buffer (since 1088 is a multiple of 16
and is more suitable for MPEG et al encoding).

So, yes, you do want the option to set the size explicitly.

> 
> 
> > +    <para>To allocate device buffers applications initialize all
> > +fields of the <structname>v4l2_create_buffers</structname> structure.
> > +They set the <structfield>type</structfield> field in the
> > +<structname>v4l2_format</structname> structure, embedded in this
> > +structure, to the respective stream or buffer type.
> > +<structfield>count</structfield> must be set to the number of required
> > +buffers. <structfield>memory</structfield> specifies the required I/O
> > +method. Applications have two possibilities to specify the size of buffers
> > +to be prepared: they can either set the <structfield>size</structfield>
> > +field explicitly to a non-zero value, or fill in the frame format data in the
> > +<structfield>format</structfield> field. In the latter case buffer sizes
> > +will be calculated automatically by the driver. The
> 
> Technically, we shouldn't say "applications initialize all fields" in
> the first sentence if they do not have to initialize both size and
> format fields at the same time.
> 
> > +<structfield>reserved</structfield> array must be zeroed. When the ioctl
> > +is called with a pointer to this structure the driver will attempt to allocate
> > +up to the requested number of buffers and store the actual number allocated
> > +and the starting index in the <structfield>count</structfield> and
> > +the <structfield>index</structfield> fields respectively.
> > +<structfield>count</structfield> can be smaller than the number requested.
> > +-ENOMEM is returned, if the driver runs out of free memory.</para>
> > +    <para>When the I/O method is not supported the ioctl
> > +returns an &EINVAL;.</para>
> > +
> > +    <table pgwide="1" frame="none" id="v4l2-create-buffers">
> > +      <title>struct <structname>v4l2_create_buffers</structname></title>
> > +      <tgroup cols="3">
> > +       &cs-str;
> > +       <tbody valign="top">
> > +         <row>
> > +           <entry>__u32</entry>
> > +           <entry><structfield>index</structfield></entry>
> > +           <entry>The starting buffer index, returned by the driver.</entry>
> > +         </row>
> > +         <row>
> > +           <entry>__u32</entry>
> > +           <entry><structfield>count</structfield></entry>
> > +           <entry>The number of buffers requested or granted.</entry>
> > +         </row>
> > +         <row>
> > +           <entry>&v4l2-memory;</entry>
> > +           <entry><structfield>memory</structfield></entry>
> > +           <entry>Applications set this field to
> > +<constant>V4L2_MEMORY_MMAP</constant> or
> > +<constant>V4L2_MEMORY_USERPTR</constant>.</entry>
> > +         </row>
> > +         <row>
> > +           <entry>__u32</entry>
> > +           <entry><structfield>size</structfield></entry>
> > +           <entry>Explicit size of buffers, being created.</entry>
> > +         </row>
> > +         <row>
> > +           <entry>&v4l2-format;</entry>
> > +           <entry><structfield>format</structfield></entry>
> > +           <entry>Application has to set the <structfield>type</structfield>
> > +field, other fields should be used, if the application wants to allocate buffers
> > +for a specific frame format.</entry>
> > +         </row>
> > +         <row>
> > +           <entry>__u32</entry>
> > +           <entry><structfield>reserved</structfield>[8]</entry>
> > +           <entry>A place holder for future extensions.</entry>
> > +         </row>
> > +       </tbody>
> > +      </tgroup>
> > +    </table>
> > +  </refsect1>
> > +
> > +  <refsect1>
> > +    &return-value;
> > +
> > +    <variablelist>
> > +      <varlistentry>
> > +       <term><errorcode>ENOMEM</errorcode></term>
> > +       <listitem>
> > +         <para>No memory to allocate buffers for <link linkend="mmap">memory
> > +mapped</link> I/O.</para>
> > +       </listitem>
> > +      </varlistentry>
> > +      <varlistentry>
> > +       <term><errorcode>EINVAL</errorcode></term>
> > +       <listitem>
> > +         <para>The buffer type (<structfield>type</structfield> field) or the
> > +requested I/O method (<structfield>memory</structfield>) is not
> > +supported.</para>
> > +       </listitem>
> > +      </varlistentry>
> > +    </variablelist>
> > +  </refsect1>
> > +</refentry>
> > +
> 
> What happens if the driver does not agree to the provided size? EINVAL?
> 
> > +<!--
> > +Local Variables:
> > +mode: sgml
> > +sgml-parent-document: "v4l2.sgml"
> > +indent-tabs-mode: nil
> > +End:
> > +-->
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> > new file mode 100644
> > index 0000000..509e752
> > --- /dev/null
> > +++ b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> > @@ -0,0 +1,96 @@
> > +<refentry id="vidioc-prepare-buf">
> > +  <refmeta>
> > +    <refentrytitle>ioctl VIDIOC_PREPARE_BUF</refentrytitle>
> > +    &manvol;
> > +  </refmeta>
> > +
> > +  <refnamediv>
> > +    <refname>VIDIOC_PREPARE_BUF</refname>
> > +    <refpurpose>Prepare a buffer for I/O</refpurpose>
> > +  </refnamediv>
> > +
> > +  <refsynopsisdiv>
> > +    <funcsynopsis>
> > +      <funcprototype>
> > +       <funcdef>int <function>ioctl</function></funcdef>
> > +       <paramdef>int <parameter>fd</parameter></paramdef>
> > +       <paramdef>int <parameter>request</parameter></paramdef>
> > +       <paramdef>struct v4l2_buffer *<parameter>argp</parameter></paramdef>
> > +      </funcprototype>
> > +    </funcsynopsis>
> > +  </refsynopsisdiv>
> > +
> > +  <refsect1>
> > +    <title>Arguments</title>
> > +
> > +    <variablelist>
> > +      <varlistentry>
> > +       <term><parameter>fd</parameter></term>
> > +       <listitem>
> > +         <para>&fd;</para>
> > +       </listitem>
> > +      </varlistentry>
> > +      <varlistentry>
> > +       <term><parameter>request</parameter></term>
> > +       <listitem>
> > +         <para>VIDIOC_PREPARE_BUF</para>
> > +       </listitem>
> > +      </varlistentry>
> > +      <varlistentry>
> > +       <term><parameter>argp</parameter></term>
> > +       <listitem>
> > +         <para></para>
> > +       </listitem>
> > +      </varlistentry>
> > +    </variablelist>
> > +  </refsect1>
> > +
> > +  <refsect1>
> > +    <title>Description</title>
> > +
> > +    <para>Applications can optionally call the
> > +<constant>VIDIOC_PREPARE_BUF</constant> ioctl to pass ownership of the buffer
> > +to the driver before actually enqueuing it, using the
> > +<constant>VIDIOC_QBUF</constant> ioctl, and to prepare it for future I/O.
> > +Such preparations may include cache invalidation or cleaning. Performing them
> > +in advance saves time during the actual I/O. In case such cache operations are
> > +not required, the application can use one of
> > +<constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant> and
> > +<constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant> flags to skip the respective
> > +step.</para>
> > +
> 
> I'm probably forgetting something, but why would we want to do both
> PREPARE_BUF and QBUF? Why not queue in advance?

QBUF both prepares the buffer and makes it available for use with DMA. You don't want
that. You just want to prepare it (that's the part that is expensive) and postpone
the actual queuing until the buffer is needed to e.g. take a snapshot.

Regards,

	Hans

> Could you give a full sequence of ioctls how it will be used
> (including streamons, etc.)? I'm trying to picture how passing of both
> types of buffers will have to look like between vb2 and a driver.
> 
> <snip>
> 
> --
> Best regards,
> Pawel Osciak
> 
> 
