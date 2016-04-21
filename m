Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59274 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751650AbcDUVs3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2016 17:48:29 -0400
Date: Fri, 22 Apr 2016 00:48:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH/RFC 1/2] v4l: Add meta-data video device type
Message-ID: <20160421214823.GD32125@valkosipuli.retiisi.org.uk>
References: <1461199227-22506-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1461199227-22506-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <20160421084426.GA32125@valkosipuli.retiisi.org.uk>
 <2327439.DCv8pRv1AH@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2327439.DCv8pRv1AH@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Heippa!

On Thu, Apr 21, 2016 at 10:24:48PM +0300, Laurent Pinchart wrote:
> Hi Sakari,
> 
> Thank you for the review.
> 
> On Thursday 21 Apr 2016 11:44:26 Sakari Ailus wrote:
> > On Thu, Apr 21, 2016 at 03:40:26AM +0300, Laurent Pinchart wrote:
> > > The meta-data video device is used to transfer meta-data between
> > > userspace and kernelspace through a V4L2 buffers queue. It comes with a
> > > new meta-data capture capability, buffer type and format description.
> > > 
> > > Signed-off-by: Laurent Pinchart
> > > <laurent.pinchart+renesas@ideasonboard.com>
> > > ---
> > > 
> > >  Documentation/DocBook/media/v4l/dev-meta.xml  | 100 +++++++++++++++++++++
> > >  Documentation/DocBook/media/v4l/v4l2.xml      |   1 +
> > >  drivers/media/v4l2-core/v4l2-compat-ioctl32.c |  19 +++++
> > >  drivers/media/v4l2-core/v4l2-dev.c            |  21 +++++-
> > >  drivers/media/v4l2-core/v4l2-ioctl.c          |  39 ++++++++++
> > >  drivers/media/v4l2-core/videobuf2-v4l2.c      |   3 +
> > >  include/media/v4l2-dev.h                      |   3 +-
> > >  include/media/v4l2-ioctl.h                    |   8 +++
> > >  include/uapi/linux/media.h                    |   2 +
> > >  include/uapi/linux/videodev2.h                |  14 ++++
> > >  10 files changed, 208 insertions(+), 2 deletions(-)
> > >  create mode 100644 Documentation/DocBook/media/v4l/dev-meta.xml
> > > 
> > > diff --git a/Documentation/DocBook/media/v4l/dev-meta.xml
> > > b/Documentation/DocBook/media/v4l/dev-meta.xml new file mode 100644
> > > index 000000000000..ddc685186015
> > > --- /dev/null
> > > +++ b/Documentation/DocBook/media/v4l/dev-meta.xml
> > > @@ -0,0 +1,100 @@
> > > +  <title>Meta-Data Interface</title>
> > 
> > I propose:
> > 
> > s/-/ /
> 
> How about metadata ? That's the spelling used by wikipedia

Fine for me.

> 
> > > +
> > > +  <note>
> > > +    <title>Experimental</title>
> > > +    <para>This is an <link linkend="experimental"> experimental </link>
> > > +    interface and may change in the future.</para>
> > > +  </note>
> > > +
> > > +  <para>
> > > +Meta-data refers to any non-image data that supplements video frames with
> > > +additional information. This may include statistics computed over the
> > > image +or frame capture parameters supplied by the image source. This
> > > interface is +intended for transfer of meta-data to userspace and control
> > > of that operation.
> >
> > Ditto.
> > 
> > > +  </para>
> > > +
> > > +  <para>
> > > +Meta-data devices are accessed through character device special files
> > > named +<filename>/dev/v4l-meta0</filename> to
> > > <filename>/dev/v4l-meta255</filename> +with major number 81 and
> > > dynamically allocated minor numbers 0 to 255.
> >
> > Where does 255 come from? At least in kernel the minor number space has got
> > 20 bits, not 8. Not that I prefer having that many meta data nodes, but
> > still that's a possibility.
> 
> We have
> 
> #define VIDEO_NUM_DEVICES       256
> 
> in drivers/media/v4l2-core/v4l2-dev.c. If you want to take care of the code 
> I'll update the documentation :-)

I think we could just omit telling how many there are. That's not really a
part of the API.

> 
> > > +  </para>
> > > +
> > > +  <section>
> > > +    <title>Querying Capabilities</title>
> > > +
> > > +    <para>
> > > +Devices supporting the meta-data interface set the
> > > +<constant>V4L2_CAP_META_CAPTURE</constant> flag in the
> > > +<structfield>capabilities</structfield> field of &v4l2-capability;
> > > +returned by the &VIDIOC-QUERYCAP; ioctl. That flag means the device can
> > > capture +meta-data to memory.
> > > +    </para>
> > > +    <para>
> > > +At least one of the read/write, streaming or asynchronous I/O methods
> > > must
> > > +be supported.
> > > +    </para>
> > > +  </section>
> > > +
> > > +  <section>
> > > +    <title>Data Format Negotiation</title>
> > > +
> > > +    <para>
> > > +The meta-data device uses the <link linkend="format">format</link> ioctls
> > > to +select the capture format. The meta-data buffer content format is
> > > bound to that +selectable format. In addition to the basic
> > > +<link linkend="format">format</link> ioctls, the &VIDIOC-ENUM-FMT; ioctl
> > > +must be supported as well.
> > > +    </para>
> > > +
> > > +    <para>
> > > +To use the <link linkend="format">format</link> ioctls applications set
> > > the +<structfield>type</structfield> field of a &v4l2-format; to
> > > +<constant>V4L2_BUF_TYPE_META_CAPTURE</constant> and use the
> > > &v4l2-meta-format; +<structfield>meta</structfield> member of the
> > > <structfield>fmt</structfield> +union as needed per the desired
> > > operation.
> > > +Currently there are two fields, <structfield>pixelformat</structfield>
> > > and
> > > +<structfield>buffersize</structfield>, of struct &v4l2-meta-format; that
> > > are +used. Content of the <structfield>pixelformat</structfield> is the
> > > V4L2 FourCC +code of the data format. The
> > > <structfield>buffersize</structfield> field is the +maximum buffer size
> > > in bytes required for data transfer, set by the driver in +order to
> > > inform applications.
> > > +    </para>
> > > +
> > > +    <table pgwide="1" frame="none" id="v4l2-meta-format">
> > > +      <title>struct <structname>v4l2_meta_format</structname></title>
> > > +      <tgroup cols="3">
> > > +        &cs-str;
> > > +        <tbody valign="top">
> > > +          <row>
> > > +            <entry>__u32</entry>
> > > +            <entry><structfield>pixelformat</structfield></entry>
> > > +            <entry>
> > > +The data format or type of compression, set by the application. This is a
> > > +little endian <link linkend="v4l2-fourcc">four character code</link>.
> > > +V4L2 defines meta-data formats in <xref linkend="meta-formats" />.
> > > +           </entry>
> > > +          </row>
> > > +          <row>
> > > +            <entry>__u32</entry>
> > > +            <entry><structfield>buffersize</structfield></entry>
> > > +            <entry>
> > > +Maximum size in bytes required for data. Value is set by the driver.
> > > +           </entry>
> > > +          </row>
> > > +          <row>
> > > +            <entry>__u8</entry>
> > > +            <entry><structfield>reserved[24]</structfield></entry>
> > > +            <entry>This array is reserved for future extensions.
> > > +Drivers and applications must set it to zero.</entry>
> > 
> > 200 bytes is reserved for this struct in all IOCTLs. How about using closer
> > to that amount? 24 bytes of reserved space isn't much. Albeit you could
> > argue that this struct could be changed later on as it does not affect IOCTL
> > argument size.
> 
> Should we just get rid of the reserved field then ?

I'd prefer having a second opinion on this. Hans, Mauro?

> 
> > > +          </row>
> > > +        </tbody>
> > > +      </tgroup>
> > > +    </table>
> > > +
> > > +    <para>
> > > +A meta-data device may support <link linkend="rw">read/write</link>
> > > +and/or streaming (<link linkend="mmap">memory mapping</link>
> > > +or <link linkend="userp">user pointer</link>) I/O.
> > > +    </para>
> > > +
> > > +  </section>
> 
> [snip]
> 
> > > diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > > b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c index
> > > bacecbd68a6d..da2d836e8887 100644
> > > --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > > +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> > > @@ -161,6 +161,20 @@ static inline int put_v4l2_sdr_format(struct
> > > v4l2_sdr_format *kp, struct v4l2_sd> 
> > >  	return 0;
> > >  
> > >  }
> > > 
> > > +static inline int get_v4l2_meta_format(struct v4l2_meta_format *kp,
> > > struct v4l2_meta_format __user *up)
> >
> > I think I'd wrap this. Same below.
> 
> I've followed the existing coding style of the file, I'm fine with wrapping 
> the lines if you think that's better.

Up to you.

> 
> > > +{
> > > +	if (copy_from_user(kp, up, sizeof(struct v4l2_meta_format)))
> > > +		return -EFAULT;
> > > +	return 0;
> > > +}
> > > +
> > > +static inline int put_v4l2_meta_format(struct v4l2_meta_format *kp,
> > > struct v4l2_meta_format __user *up) +{
> > > +	if (copy_to_user(up, kp, sizeof(struct v4l2_meta_format)))
> > > +		return -EFAULT;
> > > +	return 0;
> > > +}
> > > +
> > >  struct v4l2_format32 {
> > >  	__u32	type;	/* enum v4l2_buf_type */
> > >  	union {
> 
> [snip]
> 
> > > diff --git a/include/uapi/linux/videodev2.h
> > > b/include/uapi/linux/videodev2.h index e895975c5b0e..5035295a0138 100644
> > > --- a/include/uapi/linux/videodev2.h
> > > +++ b/include/uapi/linux/videodev2.h
> 
> [snip]
> 
> > > @@ -2007,6 +2009,17 @@ struct v4l2_sdr_format {
> > >  } __attribute__ ((packed));
> > >  
> > >  /**
> > > + * struct v4l2_meta_format - meta-data format definition
> > 
> > An empty line here would be nice.
> 
> The kerneldoc style doesn't add an empty line after the first, and the 
> kerneldoc blocks in this file don't either.

Now that I look at the documentation in that file, you're mostly right.
Indeed, most of the Kerneldoc comments don't have that empty line while some
do. I think it's cleaner that way. Up to you.

> 
> > > + * @pixelformat:	little endian four character code (fourcc)
> > > + * @buffersize:		maximum size in bytes required for data
> > > + */
> > > +struct v4l2_meta_format {
> > > +	__u32				pixelformat;
> > > +	__u32				buffersize;
> > > +	__u8				reserved[24];
> > > +} __attribute__ ((packed));
> > > +
> > > +/**
> > >   * struct v4l2_format - stream data format
> > >   * @type:	enum v4l2_buf_type; type of the data stream
> > >   * @pix:	definition of an image format
> 
> [snip]

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
