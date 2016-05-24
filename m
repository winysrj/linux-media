Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34548 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755088AbcEXP3F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2016 11:29:05 -0400
Date: Tue, 24 May 2016 18:28:32 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH/RFC v2 1/4] v4l: Add metadata buffer type and format
Message-ID: <20160524152831.GF26360@valkosipuli.retiisi.org.uk>
References: <1463012283-3078-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1463012283-3078-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <5742D6CC.8040909@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5742D6CC.8040909@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, May 23, 2016 at 12:09:16PM +0200, Hans Verkuil wrote:
> On 05/12/2016 02:18 AM, Laurent Pinchart wrote:
> > The metadata buffer type is used to transfer metadata between userspace
> > and kernelspace through a V4L2 buffers queue. It comes with a new
> > metadata capture capability and format description.
> 
> Thanks for the patch! I have some comments/suggestions below:
> 
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> > ---
> >  Documentation/DocBook/media/v4l/dev-meta.xml  | 93 +++++++++++++++++++++++++++
> >  Documentation/DocBook/media/v4l/v4l2.xml      |  1 +
> >  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 19 ++++++
> >  drivers/media/v4l2-core/v4l2-dev.c            | 16 +++--
> >  drivers/media/v4l2-core/v4l2-ioctl.c          | 34 ++++++++++
> >  drivers/media/v4l2-core/videobuf2-v4l2.c      |  3 +
> >  include/media/v4l2-ioctl.h                    |  8 +++
> >  include/uapi/linux/videodev2.h                | 14 ++++
> >  8 files changed, 182 insertions(+), 6 deletions(-)
> >  create mode 100644 Documentation/DocBook/media/v4l/dev-meta.xml
> > 
> > diff --git a/Documentation/DocBook/media/v4l/dev-meta.xml b/Documentation/DocBook/media/v4l/dev-meta.xml
> > new file mode 100644
> > index 000000000000..9b5b1fba2007
> > --- /dev/null
> > +++ b/Documentation/DocBook/media/v4l/dev-meta.xml
> > @@ -0,0 +1,93 @@
> > +  <title>Metadata Interface</title>
> > +
> > +  <note>
> > +    <title>Experimental</title>
> > +    <para>This is an <link linkend="experimental"> experimental </link>
> 
> No space before/after 'experimental'. It will look ugly in the docbook (I tried
> it :-) ).
> 
> > +    interface and may change in the future.</para>
> > +  </note>
> > +
> > +  <para>
> > +Metadata refers to any non-image data that supplements video frames with
> > +additional information. This may include statistics computed over the image
> > +or frame capture parameters supplied by the image source. This interface is
> > +intended for transfer of metadata to userspace and control of that operation.
> 
> I think it can also be in the other direction. I'm thinking of metadata needed
> by codecs. I'm not sure if it should be mentioned that this is not supported at
> the moment and that the ML should be contacted for more info if someone wants this.

Good point.

> 
> > +  </para>
> > +
> > +  <para>
> > +The metadata interface is implemented on video capture devices. The device can
> 
> s/on/for/?
> 
> > +be dedicated to metadata or can implement both video and metadata capture as
> > +specified in its reported capabilities.
> > +  </para>
> > +
> > +  <section>
> > +    <title>Querying Capabilities</title>
> > +
> > +    <para>
> > +Devices supporting the metadata interface set the
> > +<constant>V4L2_CAP_META_CAPTURE</constant> flag in the
> > +<structfield>capabilities</structfield> field of &v4l2-capability;
> > +returned by the &VIDIOC-QUERYCAP; ioctl. That flag means the device can capture
> > +metadata to memory.
> > +    </para>
> 
> I know this is a copy and paste from the other interface descriptions, but it
> is rather outdated. I would write this instead:
> 
>  <para>
> Device nodes supporting the metadata interface set the
> <constant>V4L2_CAP_META_CAPTURE</constant> flag in the
> <structfield>device_caps</structfield> field of &v4l2-capability;
> returned by the &VIDIOC-QUERYCAP; ioctl. That flag means the device node can capture
> metadata to memory.
>  </para>
> 
> Any driver using this will be recent and always have a valid device_caps field
> (which, as you know, didn't exist in old kernels).
> 
> I find the capabilities field fairly useless in most cases due to the fact that
> it contains the capabilities of all device nodes created by the device driver.
> 
> > +    <para>
> > +At least one of the read/write or streaming I/O methods must be supported.
> > +    </para>
> > +  </section>
> > +
> > +  <section>
> > +    <title>Data Format Negotiation</title>
> > +
> > +    <para>
> > +The metadata device uses the <link linkend="format">format</link> ioctls to
> > +select the capture format. The metadata buffer content format is bound to that
> > +selectable format. In addition to the basic
> > +<link linkend="format">format</link> ioctls, the &VIDIOC-ENUM-FMT; ioctl
> > +must be supported as well.
> > +    </para>
> > +
> > +    <para>
> > +To use the <link linkend="format">format</link> ioctls applications set the
> > +<structfield>type</structfield> field of a &v4l2-format; to
> > +<constant>V4L2_BUF_TYPE_META_CAPTURE</constant> and use the &v4l2-meta-format;
> > +<structfield>meta</structfield> member of the <structfield>fmt</structfield>
> > +union as needed per the desired operation.
> > +Currently there are two fields, <structfield>dataformat</structfield> and
> > +<structfield>buffersize</structfield>, of struct &v4l2-meta-format; that are
> > +used. Content of the <structfield>dataformat</structfield> is the V4L2 FourCC
> > +code of the data format. The <structfield>buffersize</structfield> field is the
> > +maximum buffer size in bytes required for data transfer, set by the driver in
> > +order to inform applications.
> 
> Should it be mentioned here that changing the video format might change
> the buffersize? In case the buffersize is always a multiple of the width?

Isn't that the case in general, as with pixel formats? buffersize could also
be something else than a multiple of width (there's no width for metadata
formats) due to e.g. padding required by hardware.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
