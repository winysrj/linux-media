Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:60360 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab1HQImA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 04:42:00 -0400
Date: Wed, 17 Aug 2011 10:41:51 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sakari Ailus <sakari.ailus@iki.fi>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/6 v4] V4L: add two new ioctl()s for multi-size videobuffer
 management
In-Reply-To: <4E3D8B03.3090601@iki.fi>
Message-ID: <Pine.LNX.4.64.1108171033510.18317@axis700.grange>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange>
 <Pine.LNX.4.64.1108050908590.26715@axis700.grange> <4E3D8B03.3090601@iki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 6 Aug 2011, Sakari Ailus wrote:

> Guennadi Liakhovetski wrote:
> > A possibility to preallocate and initialise buffers of different sizes
> > in V4L2 is required for an efficient implementation of asnapshot mode.
> > This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> > VIDIOC_PREPARE_BUF and defines respective data structures.
> > 
> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > ---
> 
> Hi Guennadi,

[snip]

> > +    <para>When the I/O method is not supported the ioctl
> > +returns an &EINVAL;.</para>
> > +
> > +    <table pgwide="1" frame="none" id="v4l2-create-buffers">
> > +      <title>struct <structname>v4l2_create_buffers</structname></title>
> > +      <tgroup cols="3">
> > +	&cs-str;
> > +	<tbody valign="top">
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>index</structfield></entry>
> > +	    <entry>The starting buffer index, returned by the driver.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>count</structfield></entry>
> > +	    <entry>The number of buffers requested or granted.</entry>
> > +	  </row>
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>type</structfield></entry>
> > +	    <entry>V4L2 buffer type: one of <constant>V4L2_BUF_TYPE_*</constant>
> > +values.</entry>
> 
> &v4l2-buf-type;
> 
> here?

No idea and I don't care all that much, tbh. I certainly copy-pasted those 
constructs from other documents, and yes, they are inconsistent across 
v4l: some use my version, some yours, others <xref linkend=...>. I'm happy 
with either or none of those. Just tell me _something_, that's 
approapriate.

> 
> > +	  </row>
> > +	  <row>
> > +	    <entry>__u32</entry>
> > +	    <entry><structfield>memory</structfield></entry>
> > +	    <entry>Applications set this field to
> > +<constant>V4L2_MEMORY_MMAP</constant> or
> > +<constant>V4L2_MEMORY_USERPTR</constant>.</entry>
> 
> &v4l2-memory;

[snip]

> > +    <para>Applications can optionally call the
> > +<constant>VIDIOC_PREPARE_BUF</constant> ioctl to pass ownership of the buffer
> > +to the driver before actually enqueuing it, using the
> > +<constant>VIDIOC_QBUF</constant> ioctl, and to prepare it for future I/O.
> 
> s/<constant>VIDIOC_QBUF</constant>/&VIDIOC_QBUF;/

*shrug*

> > > +Such preparations may include cache invalidation or cleaning. Performing them
> > +in advance saves time during the actual I/O. In case such cache operations are
> > +not required, the application can use one of
> > +<constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant> and
> > +<constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant> flags to skip the respective
> > +step.</para>
> > +
> > +    <para>The <structname>v4l2_buffer</structname> structure is
> 
> s/<structname>v4l2_buffer</structname>/&v4l2-buffer;/

"structname" seems to be more precise, but well...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
