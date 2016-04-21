Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34284 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbcDUTO6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2016 15:14:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH/RFC 1/2] v4l: Add meta-data video device type
Date: Thu, 21 Apr 2016 22:15:12 +0300
Message-ID: <27064764.ckB5ZcOUBB@avalon>
In-Reply-To: <571875BF.8080500@xs4all.nl>
References: <1461199227-22506-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1461199227-22506-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <571875BF.8080500@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the review.

On Thursday 21 Apr 2016 08:39:59 Hans Verkuil wrote:
> Hi Laurent,
> 
> Thanks for the patch!
> 
> Some, mostly small, comments follow:
> 
> On 04/21/2016 02:40 AM, Laurent Pinchart wrote:
> > The meta-data video device is used to transfer meta-data between
> > userspace and kernelspace through a V4L2 buffers queue. It comes with a
> > new meta-data capture capability, buffer type and format description.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> > 
> >  Documentation/DocBook/media/v4l/dev-meta.xml  | 100 +++++++++++++++++++++
> >  Documentation/DocBook/media/v4l/v4l2.xml      |   1 +
> >  drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  19 +++++
> >  drivers/media/v4l2-core/v4l2-dev.c            |  21 +++++-
> >  drivers/media/v4l2-core/v4l2-ioctl.c          |  39 ++++++++++
> >  drivers/media/v4l2-core/videobuf2-v4l2.c      |   3 +
> >  include/media/v4l2-dev.h                      |   3 +-
> >  include/media/v4l2-ioctl.h                    |   8 +++
> >  include/uapi/linux/media.h                    |   2 +
> >  include/uapi/linux/videodev2.h                |  14 ++++
> >  10 files changed, 208 insertions(+), 2 deletions(-)
> >  create mode 100644 Documentation/DocBook/media/v4l/dev-meta.xml
> > 
> > diff --git a/Documentation/DocBook/media/v4l/dev-meta.xml
> > b/Documentation/DocBook/media/v4l/dev-meta.xml new file mode 100644
> > index 000000000000..ddc685186015
> > --- /dev/null
> > +++ b/Documentation/DocBook/media/v4l/dev-meta.xml
> > @@ -0,0 +1,100 @@
> > +  <title>Meta-Data Interface</title>
> > +
> > +  <note>
> > +    <title>Experimental</title>
> > +    <para>This is an <link linkend="experimental"> experimental </link>
> > +    interface and may change in the future.</para>
> > +  </note>
> > +
> > +  <para>
> > +Meta-data refers to any non-image data that supplements video frames with
> > +additional information. This may include statistics computed over the
> > image +or frame capture parameters supplied by the image source. This
> > interface is +intended for transfer of meta-data to userspace and control
> > of that operation. +  </para>
> > +
> > +  <para>
> > +Meta-data devices are accessed through character device special files
> > named +<filename>/dev/v4l-meta0</filename> to
> > <filename>/dev/v4l-meta255</filename> +with major number 81 and
> > dynamically allocated minor numbers 0 to 255. +  </para>
> > +
> > +  <section>
> > +    <title>Querying Capabilities</title>
> > +
> > +    <para>
> > +Devices supporting the meta-data interface set the
> > +<constant>V4L2_CAP_META_CAPTURE</constant> flag in the
> > +<structfield>capabilities</structfield> field of &v4l2-capability;
> > +returned by the &VIDIOC-QUERYCAP; ioctl. That flag means the device can
> > capture +meta-data to memory.
> > +    </para>
> > +    <para>
> > +At least one of the read/write, streaming or asynchronous I/O methods
> > must
> 
> I think we can drop 'asynchronous I/O' since that's never been used. I
> assume this is copy-and-pasted and we should probably just remove any
> reference to async IO.

Agreed. I'll fix it.

> > +be supported.
> > +    </para>
> > +  </section>
> > +
> > +  <section>
> > +    <title>Data Format Negotiation</title>
> > +
> > +    <para>
> > +The meta-data device uses the <link linkend="format">format</link> ioctls
> > to +select the capture format. The meta-data buffer content format is
> > bound to that +selectable format. In addition to the basic
> > +<link linkend="format">format</link> ioctls, the &VIDIOC-ENUM-FMT; ioctl
> > +must be supported as well.
> > +    </para>
> > +
> > +    <para>
> > +To use the <link linkend="format">format</link> ioctls applications set
> > the +<structfield>type</structfield> field of a &v4l2-format; to
> > +<constant>V4L2_BUF_TYPE_META_CAPTURE</constant> and use the
> > &v4l2-meta-format; +<structfield>meta</structfield> member of the
> > <structfield>fmt</structfield> +union as needed per the desired
> > operation.
> > +Currently there are two fields, <structfield>pixelformat</structfield>
> > and
> 
> Shouldn't that be metaformat? Since there are no pixels here? It was a bit
> dubious to call it pixelformat for SDR as well, but at least there you
> still have discrete samples which might be called pixels with some
> imagination. But certainly doesn't apply to meta data.

How about dataformat ? Or just format ?

> > +<structfield>buffersize</structfield>, of struct &v4l2-meta-format; that
> > are +used. Content of the <structfield>pixelformat</structfield> is the
> > V4L2 FourCC +code of the data format. The
> > <structfield>buffersize</structfield> field is the +maximum buffer size
> > in bytes required for data transfer, set by the driver in +order to
> > inform applications.
> > +    </para>
> > +
> > +    <table pgwide="1" frame="none" id="v4l2-meta-format">
> > +      <title>struct <structname>v4l2_meta_format</structname></title>
> > +      <tgroup cols="3">
> > +        &cs-str;
> > +        <tbody valign="top">
> > +          <row>
> > +            <entry>__u32</entry>
> > +            <entry><structfield>pixelformat</structfield></entry>
> > +            <entry>
> > +The data format or type of compression, set by the application. This is a
> > +little endian <link linkend="v4l2-fourcc">four character code</link>.
> > +V4L2 defines meta-data formats in <xref linkend="meta-formats" />.
> > +           </entry>
> > +          </row>
> > +          <row>
> > +            <entry>__u32</entry>
> > +            <entry><structfield>buffersize</structfield></entry>
> > +            <entry>
> > +Maximum size in bytes required for data. Value is set by the driver.
> > +           </entry>
> > +          </row>
> > +          <row>
> > +            <entry>__u8</entry>
> > +            <entry><structfield>reserved[24]</structfield></entry>
> > +            <entry>This array is reserved for future extensions.
> > +Drivers and applications must set it to zero.</entry>
> > +          </row>
> > +        </tbody>
> > +      </tgroup>
> > +    </table>
> > +
> > +    <para>
> > +A meta-data device may support <link linkend="rw">read/write</link>
> > +and/or streaming (<link linkend="mmap">memory mapping</link>
> > +or <link linkend="userp">user pointer</link>) I/O.
> 
> Add dma-buf to this as well, or just say "streaming I/O" without listing
> the possibilities. If this is copied-and-pasted, then the same should be
> done in the original.

How about removing the paragraph completely ? This is already addressed in the 
previous section ("Querying Capabilities").

> > +    </para>
> > +
> > +  </section>

[snip]

> > diff --git a/drivers/media/v4l2-core/v4l2-dev.c
> > b/drivers/media/v4l2-core/v4l2-dev.c index 70b559d7ca80..d8cbf11eae4e
> > 100644
> > --- a/drivers/media/v4l2-core/v4l2-dev.c
> > +++ b/drivers/media/v4l2-core/v4l2-dev.c

[snip]

> > @@ -845,6 +859,8 @@ static int video_register_media_controller(struct
> > video_device *vdev, int type)> 
> >   *	%VFL_TYPE_SUBDEV - A subdevice
> >   *
> >   *	%VFL_TYPE_SDR - Software Defined Radio
> > 
> > + *
> > + *	%VFL_TYPE_META - Meta-data (including statistics)
> 
> I would drop the '(including statistics)' part. It feels weird that
> 'statistics' are singled out, it makes the reader wonder what is so special
> about it that it needs to be mentioned explicitly.

Done.

> >   */
> >  
> >  int __video_register_device(struct video_device *vdev, int type, int nr,
> >  
> >  		int warn_if_nr_in_use, struct module *owner)

[snip]

-- 
Regards,

Laurent Pinchart

