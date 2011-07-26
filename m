Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:57279 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1GZLod (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jul 2011 07:44:33 -0400
Date: Tue, 26 Jul 2011 14:44:28 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH v3] V4L: add two new ioctl()s for multi-size
 videobuffer management
Message-ID: <20110726114427.GC32507@valkosipuli.localdomain>
References: <Pine.LNX.4.64.1107201025120.12084@axis700.grange>
 <Pine.LNX.4.64.1107201641030.12084@axis700.grange>
 <20110720151946.GH29320@valkosipuli.localdomain>
 <201107261305.29863.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107261305.29863.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Guennadi,

On Tue, Jul 26, 2011 at 01:05:29PM +0200, Hans Verkuil wrote:
> On Wednesday, July 20, 2011 17:19:46 Sakari Ailus wrote:
> > On Wed, Jul 20, 2011 at 04:47:46PM +0200, Guennadi Liakhovetski wrote:
> > > On Wed, 20 Jul 2011, Sakari Ailus wrote:
> > > 
> > > > Hi, Guennadi!
> > > > 
> > > > Thanks for the patch!
> > > > 
> > > > On Wed, Jul 20, 2011 at 10:43:08AM +0200, Guennadi Liakhovetski wrote:
> > > > > A possibility to preallocate and initialise buffers of different sizes
> > > > > in V4L2 is required for an efficient implementation of asnapshot mode.
> > > > > This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> > > > > VIDIOC_PREPARE_BUF and defines respective data structures.
> > > > > 
> > > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > > > ---
> > > > > 
> > > > > It's been almost a month since v2, the only comments were a request to 
> > > > > increase the reserved space in the new ioctl() and to improve 
> > > > > documentation. The reserved field is increased in this version, 
> > > > > documentation also has been improved in multiple locations. I think, 
> > > > > documentation can be further improved at any time, but if there are no 
> > > > > objections against the actual contents of this patch, maybe we can commit 
> > > > > this version. I still don't see v3.0;-), so, maybe we even can push it for 
> > > > > 3.1. A trivial comparison with v2 shows the size of the reserved field as 
> > > > > the only change in the API, and the compatibility fix as the only two 
> > > > > functional changes.
> > > > > 
> > > > > v3: addressed multiple comments by Sakari Ailus
> > > > > 
> > > > > 1. increased reserved field in "struct v4l2_create_buffers" to 8 32-bit 
> > > > >    ints
> > > > > 2. multiple documentation fixes and improvements
> > > > > 3. fixed misplaced "case VIDIOC_PREPARE_BUF" in ioctl 32-bit compatibility 
> > > > >    processing
> > > > > 
> > > > > v2:
> > > > > 
> > > > > 1. add preliminary Documentation
> > > > > 2. add flag V4L2_BUFFER_FLAG_NO_CACHE_CLEAN
> > > > > 3. remove VIDIOC_DESTROY_BUFS
> > > > > 4. rename SUBMIT to VIDIOC_PREPARE_BUF
> > > > > 5. add reserved field to struct v4l2_create_buffers
> > > > > 6. cache handling flags moved to struct v4l2_buffer for processing during 
> > > > >    VIDIOC_PREPARE_BUF
> > > > > 7. VIDIOC_PREPARE_BUF now uses struct v4l2_buffer as its argument
> > > > > 
> > > > > 
> > > > >  Documentation/DocBook/media/v4l/io.xml             |   17 +++
> > > > >  Documentation/DocBook/media/v4l/v4l2.xml           |    2 +
> > > > >  .../DocBook/media/v4l/vidioc-create-bufs.xml       |  152 ++++++++++++++++++++
> > > > >  .../DocBook/media/v4l/vidioc-prepare-buf.xml       |   96 ++++++++++++
> > > > >  drivers/media/video/v4l2-compat-ioctl32.c          |   68 ++++++++-
> > > > >  drivers/media/video/v4l2-ioctl.c                   |   32 ++++
> > > > >  include/linux/videodev2.h                          |   16 ++
> > > > >  include/media/v4l2-ioctl.h                         |    2 +
> > > > >  8 files changed, 377 insertions(+), 8 deletions(-)
> > > > >  create mode 100644 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> > > > >  create mode 100644 Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> > > > > 
> > > > > diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> > > > > index 227e7ac..6249d0e 100644
> > > > > --- a/Documentation/DocBook/media/v4l/io.xml
> > > > > +++ b/Documentation/DocBook/media/v4l/io.xml
> > > > > @@ -927,6 +927,23 @@ ioctl is called.</entry>
> > > > >  Applications set or clear this flag before calling the
> > > > >  <constant>VIDIOC_QBUF</constant> ioctl.</entry>
> > > > >  	  </row>
> > > > > +	  <row>
> > > > > +	    <entry><constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant></entry>
> > > > > +	    <entry>0x0400</entry>
> > > > > +	    <entry>Caches do not have to be invalidated for this buffer.
> > > > > +Typically applications shall use this flag, if the data, captured in the buffer
> > > > > +is not going to br touched by the CPU, instead the buffer will, probably, be
> > > > > +passed on to a DMA-capable hardware unit for further processing or output.
> > > > > +</entry>
> > > > > +	  </row>
> > > > > +	  <row>
> > > > > +	    <entry><constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant></entry>
> > > > > +	    <entry>0x0800</entry>
> > > > > +	    <entry>Caches do not have to be cleaned for this buffer.
> > > > > +Typically applications shall use this flag for output buffers, if the data
> > > > > +in this buffer has not been created by the CPU, but by some DMA-capable unit,
> > > > > +in which case caches have not been used.</entry>
> > > > > +	  </row>
> > > > >  	</tbody>
> > > > >        </tgroup>
> > > > >      </table>
> > > > > diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> > > > > index 0d05e87..06bb179 100644
> > > > > --- a/Documentation/DocBook/media/v4l/v4l2.xml
> > > > > +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> > > > > @@ -462,6 +462,7 @@ and discussions on the V4L mailing list.</revremark>
> > > > >      &sub-close;
> > > > >      &sub-ioctl;
> > > > >      <!-- All ioctls go here. -->
> > > > > +    &sub-create-bufs;
> > > > >      &sub-cropcap;
> > > > >      &sub-dbg-g-chip-ident;
> > > > >      &sub-dbg-g-register;
> > > > > @@ -504,6 +505,7 @@ and discussions on the V4L mailing list.</revremark>
> > > > >      &sub-queryctrl;
> > > > >      &sub-query-dv-preset;
> > > > >      &sub-querystd;
> > > > > +    &sub-prepare-buf;
> > > > >      &sub-reqbufs;
> > > > >      &sub-s-hw-freq-seek;
> > > > >      &sub-streamon;
> > > > > diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> > > > > new file mode 100644
> > > > > index 0000000..5f0158c
> > > > > --- /dev/null
> > > > > +++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> > > > > @@ -0,0 +1,152 @@
> > > > > +<refentry id="vidioc-create-bufs">
> > > > > +  <refmeta>
> > > > > +    <refentrytitle>ioctl VIDIOC_CREATE_BUFS</refentrytitle>
> > > > > +    &manvol;
> > > > > +  </refmeta>
> > > > > +
> > > > > +  <refnamediv>
> > > > > +    <refname>VIDIOC_CREATE_BUFS</refname>
> > > > > +    <refpurpose>Create buffers for Memory Mapped or User Pointer I/O</refpurpose>
> > > > > +  </refnamediv>
> > > > > +
> > > > > +  <refsynopsisdiv>
> > > > > +    <funcsynopsis>
> > > > > +      <funcprototype>
> > > > > +	<funcdef>int <function>ioctl</function></funcdef>
> > > > > +	<paramdef>int <parameter>fd</parameter></paramdef>
> > > > > +	<paramdef>int <parameter>request</parameter></paramdef>
> > > > > +	<paramdef>struct v4l2_create_buffers *<parameter>argp</parameter></paramdef>
> > > > > +      </funcprototype>
> > > > > +    </funcsynopsis>
> > > > > +  </refsynopsisdiv>
> > > > > +
> > > > > +  <refsect1>
> > > > > +    <title>Arguments</title>
> > > > > +
> > > > > +    <variablelist>
> > > > > +      <varlistentry>
> > > > > +	<term><parameter>fd</parameter></term>
> > > > > +	<listitem>
> > > > > +	  <para>&fd;</para>
> > > > > +	</listitem>
> > > > > +      </varlistentry>
> > > > > +      <varlistentry>
> > > > > +	<term><parameter>request</parameter></term>
> > > > > +	<listitem>
> > > > > +	  <para>VIDIOC_CREATE_BUFS</para>
> > > > > +	</listitem>
> > > > > +      </varlistentry>
> > > > > +      <varlistentry>
> > > > > +	<term><parameter>argp</parameter></term>
> > > > > +	<listitem>
> > > > > +	  <para></para>
> > > > > +	</listitem>
> > > > > +      </varlistentry>
> > > > > +    </variablelist>
> > > > > +  </refsect1>
> > > > > +
> > > > > +  <refsect1>
> > > > > +    <title>Description</title>
> > > > > +
> > > > > +    <para>This ioctl is used to create buffers for <link linkend="mmap">memory
> > > > > +mapped</link> or <link linkend="userp">user pointer</link>
> > > > > +I/O. It can be used as an alternative to the <constant>VIDIOC_REQBUFS</constant>
> > > > > +ioctl, when a tighter control over buffers is required. This ioctl can be called
> > > > > +multiple times to create buffers of different sizes.
> 
> I realized that it is not clear from the documentation whether it is possible to call
> VIDIOC_REQBUFS and make additional calls to VIDIOC_CREATE_BUFS afterwards.

That's actually a must if one wants to release buffers. Currently no other
method than requesting 0 buffers using REQBUFS is provided (apart from
closing the file handle).

> I can't remember whether the code allows it or not, but it should be clearly documented.

I would guess no user application would have to call REQBUFS with other than
zero buffers when using CREATE_BUFS. This must be an exception if mixing
REQBUFS and CREATE_BUFS is not allowed in general. That said, I don't see a
reason to prohibit either, but perhaps Guennadi has more informed opinion
on this.

> > > > > +
> > > > > +    <para>To allocate device buffers applications initialize all
> > > > > +fields of the <structname>v4l2_create_buffers</structname> structure.
> > > > > +They set the <structfield>type</structfield> field in the
> > > > > +<structname>v4l2_format</structname> structure, embedded in this
> > > > > +structure, to the respective stream or buffer type.
> > > > > +<structfield>count</structfield> must be set to the number of required
> > > > > +buffers. <structfield>memory</structfield> specifies the required I/O
> > > > > +method. Applications have two possibilities to specify the size of buffers
> > > > > +to be prepared: they can either set the <structfield>size</structfield>
> > > > > +field explicitly to a non-zero value, or fill in the frame format data in the
> > > > > +<structfield>format</structfield> field. In the latter case buffer sizes
> > > > > +will be calculated automatically by the driver. The
> > > > > +<structfield>reserved</structfield> array must be zeroed. When the ioctl
> > > > > +is called with a pointer to this structure the driver will attempt to allocate
> > > > > +up to the requested number of buffers and store the actual number allocated
> > > > > +and the starting index in the <structfield>count</structfield> and
> > > > > +the <structfield>index</structfield> fields respectively.
> > > > > +<structfield>count</structfield> can be smaller than the number requested.
> > > > > +-ENOMEM is returned, if the driver runs out of free memory.</para>
> > > > 
> > > > No need to mention -ENOMEM here. It's already in the return values below;
> > > > the same goes for the EINVAL just below.
> > > 
> > > Yes, incremental patches welcome.
> > > 
> > > > 
> > > > > +    <para>When the I/O method is not supported the ioctl
> > > > > +returns an &EINVAL;.</para>
> > > > > +
> > > > > +    <table pgwide="1" frame="none" id="v4l2-create-buffers">
> > > > > +      <title>struct <structname>v4l2_create_buffers</structname></title>
> > > > > +      <tgroup cols="3">
> > > > > +	&cs-str;
> > > > > +	<tbody valign="top">
> > > > > +	  <row>
> > > > > +	    <entry>__u32</entry>
> > > > > +	    <entry><structfield>index</structfield></entry>
> > > > > +	    <entry>The starting buffer index, returned by the driver.</entry>
> > > > > +	  </row>
> > > > > +	  <row>
> > > > > +	    <entry>__u32</entry>
> > > > > +	    <entry><structfield>count</structfield></entry>
> > > > > +	    <entry>The number of buffers requested or granted.</entry>
> > > > > +	  </row>
> > > > > +	  <row>
> > > > > +	    <entry>&v4l2-memory;</entry>
> > > > > +	    <entry><structfield>memory</structfield></entry>
> > > > > +	    <entry>Applications set this field to
> > > > > +<constant>V4L2_MEMORY_MMAP</constant> or
> > > > > +<constant>V4L2_MEMORY_USERPTR</constant>.</entry>
> > > > > +	  </row>
> > > > > +	  <row>
> > > > > +	    <entry>__u32</entry>
> > > > > +	    <entry><structfield>size</structfield></entry>
> > > > > +	    <entry>Explicit size of buffers, being created.</entry>
> > > > > +	  </row>
> > > > > +	  <row>
> > > > > +	    <entry>&v4l2-format;</entry>
> > > > > +	    <entry><structfield>format</structfield></entry>
> > > > > +	    <entry>Application has to set the <structfield>type</structfield>
> > > > > +field, other fields should be used, if the application wants to allocate buffers
> > > > > +for a specific frame format.</entry>
> > > > > +	  </row>
> > > > > +	  <row>
> > > > > +	    <entry>__u32</entry>
> > > > > +	    <entry><structfield>reserved</structfield>[8]</entry>
> > > > > +	    <entry>A place holder for future extensions.</entry>
> > > > > +	  </row>
> > > > > +	</tbody>
> > > > > +      </tgroup>
> > > > > +    </table>
> > > > > +  </refsect1>
> > > > > +
> > > > > +  <refsect1>
> > > > > +    &return-value;
> > > > > +
> > > > > +    <variablelist>
> > > > > +      <varlistentry>
> > > > > +	<term><errorcode>ENOMEM</errorcode></term>
> > > > > +	<listitem>
> > > > > +	  <para>No memory to allocate buffers for <link linkend="mmap">memory
> > > > > +mapped</link> I/O.</para>
> > > > > +	</listitem>
> > > > > +      </varlistentry>
> > > > > +      <varlistentry>
> > > > > +	<term><errorcode>EINVAL</errorcode></term>
> > > > > +	<listitem>
> > > > > +	  <para>The buffer type (<structfield>type</structfield> field) or the
> > > > > +requested I/O method (<structfield>memory</structfield>) is not
> > > > > +supported.</para>
> > > > > +	</listitem>
> > > > > +      </varlistentry>
> > > > > +    </variablelist>
> > > > > +  </refsect1>
> > > > > +</refentry>
> > > > > +
> > > > > +<!--
> > > > > +Local Variables:
> > > > > +mode: sgml
> > > > > +sgml-parent-document: "v4l2.sgml"
> > > > > +indent-tabs-mode: nil
> > > > > +End:
> > > > > +-->
> > > > > diff --git a/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> > > > > new file mode 100644
> > > > > index 0000000..509e752
> > > > > --- /dev/null
> > > > > +++ b/Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> > > > > @@ -0,0 +1,96 @@
> > > > > +<refentry id="vidioc-prepare-buf">
> > > > > +  <refmeta>
> > > > > +    <refentrytitle>ioctl VIDIOC_PREPARE_BUF</refentrytitle>
> > > > > +    &manvol;
> > > > > +  </refmeta>
> > > > > +
> > > > > +  <refnamediv>
> > > > > +    <refname>VIDIOC_PREPARE_BUF</refname>
> > > > > +    <refpurpose>Prepare a buffer for I/O</refpurpose>
> > > > > +  </refnamediv>
> > > > > +
> > > > > +  <refsynopsisdiv>
> > > > > +    <funcsynopsis>
> > > > > +      <funcprototype>
> > > > > +	<funcdef>int <function>ioctl</function></funcdef>
> > > > > +	<paramdef>int <parameter>fd</parameter></paramdef>
> > > > > +	<paramdef>int <parameter>request</parameter></paramdef>
> > > > > +	<paramdef>struct v4l2_buffer *<parameter>argp</parameter></paramdef>
> > > > 
> > > > I'm not sure if we want to use struct v4l2_buffer here. It's an obvious
> > > > choice, but there's an issue in using it.
> > > > 
> > > > The struct is almost full i.e. there are very few reserved fields in it,
> > > > namely two, counting the input field which was unused AFAIR. There are now
> > > > three ioctls using it as their argument.
> > > > 
> > > > Future functionality which would be nice:
> > > > 
> > > > - Format counters. Every format set by S_FMT (or gotten by G_FMT) should
> > > >   come with a counter value so that the user would know the format of
> > > >   dequeued buffers when setting the format on-the-fly. Currently there are
> > > >   only bytesperline and length, but the format can't be explicitly
> > > >   determined from those.
> 
> Actually, the index field will give you that information. When you create the
> buffers you know that range [index, index + count - 1] is associated with that
> specific format.

Some hardware is able to change the format while streaming is ongoing (for
example: OMAP 3). The problem is that the user should be able to know which
frame has the new format.

Of course one could stop streaming but this would mean lost frames.

A flag has been proposed to this previously. That's one option but forces
the user to keep track of the changes since only one change is allowed until
it has taken effect.

> > > > - Binding to generic DMA buffers. This can likely be achieved by using the m
> > > >   union in struct v4l2_buffer. (Speaking of which: these buffers likely have
> > > >   a cache behaviour defined for them, e.g. they might be non-cacheable. This
> > > >   probably has no effect on the cache flags in V4L2 but it might still be
> > > >   good to keep this in mind.)
> 
> That will definitely be done through the 'm' union.
> 
> > > > I don't have an obvious replacement for it either. There are two options I
> > > > can see: Create a new struct v4l2_ext_buffer which contains the old
> > > > v4l2_buffer plus a bunch of reserved fields, or use the two last fields to
> > > > hold a pointer to an extension struct, v4l2_buffer_ext. The new structure
> > > > would later be used to contain the reserved fields.
> > > > 
> > > > I admit that this is not an issue right now, myt point is that I don't want
> > > > this to be an issue in the future either.
> > > 
> > > Good, then we'll address it, when it becomes an issue.
> > 
> > Defining v4l2_ext_buffer will mean there's a new ioctl. I think we should be
> > a little more future proof if we can. Extending the current v4l2_buffer by
> > another structure with a pointer from v4l2_buffer doesn't need this.
> > 
> > I would like to have someone else's opinion on what to do with this. The
> > resolution might as well be to accept the situation and resolve it when
> > there's an absolute need to.
> 
> Trying to define a new structure when we don't know if we need one, let alone
> what should be in there, doesn't seem useful to me. Especially since it would
> require yet another struct. I'm with Guennadi on this one.

Then this is settled on my behalf.

[clip]

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
