Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:51437 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754972Ab1G1K3P (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jul 2011 06:29:15 -0400
Date: Thu, 28 Jul 2011 12:28:52 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH v3] V4L: add two new ioctl()s for multi-size videobuffer
 management
In-Reply-To: <4E300E73.4040402@samsung.com>
Message-ID: <Pine.LNX.4.64.1107281228220.20737@axis700.grange>
References: <Pine.LNX.4.64.1107201025120.12084@axis700.grange>
 <4E300E73.4040402@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

On Wed, 27 Jul 2011, Sylwester Nawrocki wrote:

> Hi Gueannadi,
> 
> On 07/20/2011 10:43 AM, Guennadi Liakhovetski wrote:
> > A possibility to preallocate and initialise buffers of different sizes
> > in V4L2 is required for an efficient implementation of asnapshot mode.
> > This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> > VIDIOC_PREPARE_BUF and defines respective data structures.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> > 
> > It's been almost a month since v2, the only comments were a request to 
> > increase the reserved space in the new ioctl() and to improve 
> > documentation. The reserved field is increased in this version, 
> > documentation also has been improved in multiple locations. I think, 
> > documentation can be further improved at any time, but if there are no 
> > objections against the actual contents of this patch, maybe we can commit 
> > this version. I still don't see v3.0;-), so, maybe we even can push it for 
> > 3.1. A trivial comparison with v2 shows the size of the reserved field as 
> > the only change in the API, and the compatibility fix as the only two 
> > functional changes.
> > 
> > v3: addressed multiple comments by Sakari Ailus
> > 
> > 1. increased reserved field in "struct v4l2_create_buffers" to 8 32-bit 
> >    ints
> > 2. multiple documentation fixes and improvements
> > 3. fixed misplaced "case VIDIOC_PREPARE_BUF" in ioctl 32-bit compatibility 
> >    processing
> > 
> > v2:
> > 
> > 1. add preliminary Documentation
> > 2. add flag V4L2_BUFFER_FLAG_NO_CACHE_CLEAN
> > 3. remove VIDIOC_DESTROY_BUFS
> > 4. rename SUBMIT to VIDIOC_PREPARE_BUF
> > 5. add reserved field to struct v4l2_create_buffers
> > 6. cache handling flags moved to struct v4l2_buffer for processing during 
> >    VIDIOC_PREPARE_BUF
> > 7. VIDIOC_PREPARE_BUF now uses struct v4l2_buffer as its argument
> > 
> > 
> >  Documentation/DocBook/media/v4l/io.xml             |   17 +++
> >  Documentation/DocBook/media/v4l/v4l2.xml           |    2 +
> >  .../DocBook/media/v4l/vidioc-create-bufs.xml       |  152 ++++++++++++++++++++
> >  .../DocBook/media/v4l/vidioc-prepare-buf.xml       |   96 ++++++++++++
> >  drivers/media/video/v4l2-compat-ioctl32.c          |   68 ++++++++-
> >  drivers/media/video/v4l2-ioctl.c                   |   32 ++++
> >  include/linux/videodev2.h                          |   16 ++
> >  include/media/v4l2-ioctl.h                         |    2 +
> >  8 files changed, 377 insertions(+), 8 deletions(-)
> >  create mode 100644 Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> >  create mode 100644 Documentation/DocBook/media/v4l/vidioc-prepare-buf.xml
> > 
> > diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> > index 227e7ac..6249d0e 100644
> > --- a/Documentation/DocBook/media/v4l/io.xml
> > +++ b/Documentation/DocBook/media/v4l/io.xml
> > @@ -927,6 +927,23 @@ ioctl is called.</entry>
> >  Applications set or clear this flag before calling the
> >  <constant>VIDIOC_QBUF</constant> ioctl.</entry>
> >  	  </row>
> > +	  <row>
> > +	    <entry><constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant></entry>
> > +	    <entry>0x0400</entry>
> > +	    <entry>Caches do not have to be invalidated for this buffer.
> > +Typically applications shall use this flag, if the data, captured in the buffer
> > +is not going to br touched by the CPU, instead the buffer will, probably, be
> > +passed on to a DMA-capable hardware unit for further processing or output.
> > +</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry><constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant></entry>
> > +	    <entry>0x0800</entry>
> > +	    <entry>Caches do not have to be cleaned for this buffer.
> > +Typically applications shall use this flag for output buffers, if the data
> > +in this buffer has not been created by the CPU, but by some DMA-capable unit,
> > +in which case caches have not been used.</entry>
> > +	  </row>
> >  	</tbody>
> >        </tgroup>
> >      </table>
> > diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> > index 0d05e87..06bb179 100644
> > --- a/Documentation/DocBook/media/v4l/v4l2.xml
> > +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> > @@ -462,6 +462,7 @@ and discussions on the V4L mailing list.</revremark>
> >      &sub-close;
> >      &sub-ioctl;
> >      <!-- All ioctls go here. -->
> > +    &sub-create-bufs;
> >      &sub-cropcap;
> >      &sub-dbg-g-chip-ident;
> >      &sub-dbg-g-register;
> > @@ -504,6 +505,7 @@ and discussions on the V4L mailing list.</revremark>
> >      &sub-queryctrl;
> >      &sub-query-dv-preset;
> >      &sub-querystd;
> > +    &sub-prepare-buf;
> >      &sub-reqbufs;
> >      &sub-s-hw-freq-seek;
> >      &sub-streamon;
> > diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> > new file mode 100644
> > index 0000000..5f0158c
> > --- /dev/null
> > +++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> > @@ -0,0 +1,152 @@
> > +<refentry id="vidioc-create-bufs">
> > +  <refmeta>
> > +    <refentrytitle>ioctl VIDIOC_CREATE_BUFS</refentrytitle>
> > +    &manvol;
> > +  </refmeta>
> > +
> > +  <refnamediv>
> > +    <refname>VIDIOC_CREATE_BUFS</refname>
> > +    <refpurpose>Create buffers for Memory Mapped or User Pointer I/O</refpurpose>
> > +  </refnamediv>
> > +
> > +  <refsynopsisdiv>
> > +    <funcsynopsis>
> > +      <funcprototype>
> > +	<funcdef>int <function>ioctl</function></funcdef>
> > +	<paramdef>int <parameter>fd</parameter></paramdef>
> > +	<paramdef>int <parameter>request</parameter></paramdef>
> > +	<paramdef>struct v4l2_create_buffers *<parameter>argp</parameter></paramdef>
> > +      </funcprototype>
> > +    </funcsynopsis>
> > +  </refsynopsisdiv>
> > +
> > +  <refsect1>
> > +    <title>Arguments</title>
> > +
> > +    <variablelist>
> > +      <varlistentry>
> > +	<term><parameter>fd</parameter></term>
> > +	<listitem>
> > +	  <para>&fd;</para>
> > +	</listitem>
> > +      </varlistentry>
> > +      <varlistentry>
> > +	<term><parameter>request</parameter></term>
> > +	<listitem>
> > +	  <para>VIDIOC_CREATE_BUFS</para>
> > +	</listitem>
> > +      </varlistentry>
> > +      <varlistentry>
> > +	<term><parameter>argp</parameter></term>
> > +	<listitem>
> > +	  <para></para>
> > +	</listitem>
> > +      </varlistentry>
> > +    </variablelist>
> > +  </refsect1>
> > +
> > +  <refsect1>
> > +    <title>Description</title>
> > +
> > +    <para>This ioctl is used to create buffers for <link linkend="mmap">memory
> > +mapped</link> or <link linkend="userp">user pointer</link>
> > +I/O. It can be used as an alternative to the <constant>VIDIOC_REQBUFS</constant>
> > +ioctl, when a tighter control over buffers is required. This ioctl can be called
> > +multiple times to create buffers of different sizes.
> 
> It looks like there is a </para> tag missing, that line should be:
> 
> +multiple times to create buffers of different sizes. </para>
> 
> Otherwise the compilation fails.

Right, will be fixed.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
