Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:45041 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1HQMNV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 08:13:21 -0400
Date: Wed, 17 Aug 2011 15:13:16 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Pawel Osciak <pawel@osciak.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1/6 v4] V4L: add two new ioctl()s for multi-size
 videobuffer management
Message-ID: <20110817121316.GJ7436@valkosipuli.localdomain>
References: <Pine.LNX.4.64.1108042329460.31239@axis700.grange>
 <Pine.LNX.4.64.1108050908590.26715@axis700.grange>
 <4E3D8B03.3090601@iki.fi>
 <Pine.LNX.4.64.1108171033510.18317@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1108171033510.18317@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Aug 17, 2011 at 10:41:51AM +0200, Guennadi Liakhovetski wrote:
> On Sat, 6 Aug 2011, Sakari Ailus wrote:
> 
> > Guennadi Liakhovetski wrote:
> > > A possibility to preallocate and initialise buffers of different sizes
> > > in V4L2 is required for an efficient implementation of asnapshot mode.
> > > This patch adds two new ioctl()s: VIDIOC_CREATE_BUFS and
> > > VIDIOC_PREPARE_BUF and defines respective data structures.
> > > 
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > ---
> > 
> > Hi Guennadi,
> 
> [snip]
> 
> > > +    <para>When the I/O method is not supported the ioctl
> > > +returns an &EINVAL;.</para>
> > > +
> > > +    <table pgwide="1" frame="none" id="v4l2-create-buffers">
> > > +      <title>struct <structname>v4l2_create_buffers</structname></title>
> > > +      <tgroup cols="3">
> > > +	&cs-str;
> > > +	<tbody valign="top">
> > > +	  <row>
> > > +	    <entry>__u32</entry>
> > > +	    <entry><structfield>index</structfield></entry>
> > > +	    <entry>The starting buffer index, returned by the driver.</entry>
> > > +	  </row>
> > > +	  <row>
> > > +	    <entry>__u32</entry>
> > > +	    <entry><structfield>count</structfield></entry>
> > > +	    <entry>The number of buffers requested or granted.</entry>
> > > +	  </row>
> > > +	  <row>
> > > +	    <entry>__u32</entry>
> > > +	    <entry><structfield>type</structfield></entry>
> > > +	    <entry>V4L2 buffer type: one of <constant>V4L2_BUF_TYPE_*</constant>
> > > +values.</entry>
> > 
> > &v4l2-buf-type;
> > 
> > here?
> 
> No idea and I don't care all that much, tbh. I certainly copy-pasted those 
> constructs from other documents, and yes, they are inconsistent across 
> v4l: some use my version, some yours, others <xref linkend=...>. I'm happy 
> with either or none of those. Just tell me _something_, that's 
> approapriate.

Links are being used in other parts of V4L2 documentation. I think
PREPARE_BUF documentation should use them, too, rather than duplicating
parts of definitions.

> > 
> > > +	  </row>
> > > +	  <row>
> > > +	    <entry>__u32</entry>
> > > +	    <entry><structfield>memory</structfield></entry>
> > > +	    <entry>Applications set this field to
> > > +<constant>V4L2_MEMORY_MMAP</constant> or
> > > +<constant>V4L2_MEMORY_USERPTR</constant>.</entry>
> > 
> > &v4l2-memory;
> 
> [snip]
> 
> > > +    <para>Applications can optionally call the
> > > +<constant>VIDIOC_PREPARE_BUF</constant> ioctl to pass ownership of the buffer
> > > +to the driver before actually enqueuing it, using the
> > > +<constant>VIDIOC_QBUF</constant> ioctl, and to prepare it for future I/O.
> > 
> > s/<constant>VIDIOC_QBUF</constant>/&VIDIOC_QBUF;/
> 
> *shrug*
> 
> > > > +Such preparations may include cache invalidation or cleaning. Performing them
> > > +in advance saves time during the actual I/O. In case such cache operations are
> > > +not required, the application can use one of
> > > +<constant>V4L2_BUF_FLAG_NO_CACHE_INVALIDATE</constant> and
> > > +<constant>V4L2_BUF_FLAG_NO_CACHE_CLEAN</constant> flags to skip the respective
> > > +step.</para>
> > > +
> > > +    <para>The <structname>v4l2_buffer</structname> structure is
> > 
> > s/<structname>v4l2_buffer</structname>/&v4l2-buffer;/
> 
> "structname" seems to be more precise, but well...

It's precise but precision isn't everything: giving the user a link to the
definition of e.g. v4l2_buffer is more useful than forcing him or her to
look for it elsewhere in the documentation. These are small issues but the
usability of the documentation counts a lot.

Regards,

-- 
Sakari Ailus
sakari.ailus@iki.fi
