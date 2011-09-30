Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52082 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab1I3Qwq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 12:52:46 -0400
Message-ID: <4E85F3C1.4070509@redhat.com>
Date: Fri, 30 Sep 2011 13:52:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi
Subject: Re: [PATCH 3/5] doc: v4l: add documentation for selection API
References: <1317306161-23696-1-git-send-email-t.stanislaws@samsung.com> <1317306161-23696-4-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1317306161-23696-4-git-send-email-t.stanislaws@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 29-09-2011 11:22, Tomasz Stanislawski escreveu:
> This patch adds a documentation for VIDIOC_{G/S}_SELECTION ioctl. Moreover, the
> patch adds the description of modeling of composing, cropping and scaling
> features in V4L2. Finally, some examples are presented.

Doesn't work:

 $ make htmldocs
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//v4l2.xml
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//media-entities.tmpl
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//media-indices.tmpl
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//videodev2.h.xml
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//audio.h.xml
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//ca.h.xml
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//frontend.h.xml
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//net.h.xml
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//dmx.h.xml
  GEN     /home/v4l/v4l/patchwork/Documentation/DocBook//video.h.xml
  DOCPROC Documentation/DocBook/media_api.xml
  HTML    Documentation/DocBook/media_api.html
/home/v4l/v4l/patchwork/Documentation/DocBook/selection-api.xml:232: parser error : Entity 'v4l2-selection' not defined
<structname> &v4l2-selection; </structname> provides a lot of place for future
                             ^
/home/v4l/v4l/patchwork/Documentation/DocBook/selection-api.xml:250: parser error : Entity 'v4l2-selection' not defined
	&v4l2-selection; sel = {
	                ^
/home/v4l/v4l/patchwork/Documentation/DocBook/selection-api.xml:254: parser error : Entity 'VIDIOC-G-SELECTION' not defined
	ret = ioctl(fd, &VIDIOC-G-SELECTION;, &amp;sel);
	                                    ^
/home/v4l/v4l/patchwork/Documentation/DocBook/selection-api.xml:258: parser error : Entity 'VIDIOC-S-SELECTION' not defined
	ret = ioctl(fd, &VIDIOC-S-SELECTION;, &amp;sel);
	                                    ^
/home/v4l/v4l/patchwork/Documentation/DocBook/selection-api.xml:271: parser error : Entity 'v4l2-selection' not defined
	&v4l2-selection; sel = {
	                ^
/home/v4l/v4l/patchwork/Documentation/DocBook/selection-api.xml:277: parser error : Entity 'VIDIOC-G-SELECTION' not defined
	ret = ioctl(fd, &VIDIOC-G-SELECTION;, &amp;sel);
	                                    ^
/home/v4l/v4l/patchwork/Documentation/DocBook/selection-api.xml:288: parser error : Entity 'VIDIOC-S-SELECTION' not defined
	ret = ioctl(fd, &VIDIOC-S-SELECTION;, &amp;sel);
	                                    ^
/home/v4l/v4l/patchwork/Documentation/DocBook/selection-api.xml:301: parser error : Entity 'v4l2-selection' not defined
	&v4l2-selection; compose = {
	                ^
/home/v4l/v4l/patchwork/Documentation/DocBook/selection-api.xml:305: parser error : Entity 'v4l2-selection' not defined
	&v4l2-selection; crop = {
	                ^
/home/v4l/v4l/patchwork/Documentation/DocBook/selection-api.xml:311: parser error : Entity 'VIDIOC-G-SELECTION' not defined
	ret = ioctl(fd, &VIDIOC-G-SELECTION;, &amp;compose);
	                                    ^
/home/v4l/v4l/patchwork/Documentation/DocBook/selection-api.xml:314: parser error : Entity 'VIDIOC-G-SELECTION' not defined
	ret = ioctl(fd, &VIDIOC-G-SELECTION;, &amp;crop);
	                                    ^
/home/v4l/v4l/patchwork/Documentation/DocBook/selection-api.xml:328: parser error : chunk is not well balanced

^
/home/v4l/v4l/patchwork/Documentation/DocBook/common.xml:1171: parser error : Failure to process entity sub-selection-api
  &sub-selection-api;
                     ^
/home/v4l/v4l/patchwork/Documentation/DocBook/common.xml:1171: parser error : Entity 'sub-selection-api' not defined
  &sub-selection-api;
                     ^
/home/v4l/v4l/patchwork/Documentation/DocBook/v4l2.xml:423: parser error : Failure to process entity sub-common
    &sub-common;
                ^
/home/v4l/v4l/patchwork/Documentation/DocBook/v4l2.xml:423: parser error : Entity 'sub-common' not defined
    &sub-common;
                ^



> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/media/v4l/common.xml         |    2 +
>  Documentation/DocBook/media/v4l/compat.xml         |    9 +
>  Documentation/DocBook/media/v4l/selection-api.xml  |  327 ++++++++++++++++++++
>  Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
>  .../DocBook/media/v4l/vidioc-g-selection.xml       |  303 ++++++++++++++++++
>  5 files changed, 642 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/selection-api.xml
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-g-selection.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
> index a86f7a0..9c8db86 100644
> --- a/Documentation/DocBook/media/v4l/common.xml
> +++ b/Documentation/DocBook/media/v4l/common.xml
> @@ -1168,6 +1168,8 @@ dheight = format.fmt.pix.height;
>      </section>
>    </section>
>  
> +  &sub-selection-api;
> +
>    <section id="streaming-par">
>      <title>Streaming Parameters</title>
>  
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index 91410b6..7c430ca 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2376,6 +2376,12 @@ that used it. It was originally scheduled for removal in 2.6.35.
>          <listitem>
>  	  <para>V4L2_CTRL_FLAG_VOLATILE was added to signal volatile controls to userspace.</para>
>          </listitem>
> +        <listitem>
> +	  <para>Add selection API for extended control over cropping and
> +composing. Does not affect the compatibility of current drivers and
> +applications.  See <link linkend="selection-api"> selection API </link> for
> +details.</para>
> +        </listitem>
>        </orderedlist>
>      </section>
>  
> @@ -2486,6 +2492,9 @@ ioctls.</para>
>          <listitem>
>  	  <para>Flash API. <xref linkend="flash-controls" /></para>
>          </listitem>
> +        <listitem>
> +	  <para>Selection API. <xref linkend="selection-api" /></para>
> +        </listitem>
>        </itemizedlist>
>      </section>
>  
> diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
> new file mode 100644
> index 0000000..3b6dfe0
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/selection-api.xml
> @@ -0,0 +1,327 @@
> +<section id="selection-api">
> +
> +  <title>Experimental API for cropping, composing and scaling</title>
> +
> +      <note>
> +	<title>Experimental</title>
> +
> +	<para>This is an <link linkend="experimental">experimental</link>
> +interface and may change in the future.</para>
> +      </note>
> +
> +  <section>
> +    <title>Introduction</title>
> +
> +<para>Some video capture devices can sample a subsection of a picture and
> +shrink or enlarge it to an image of arbitrary size. Next, the devices can
> +insert the image into larger one. Some video output devices can crop part of an
> +input image, scale it up or down and insert it at an arbitrary scan line and
> +horizontal offset into a video signal. We call these abilities cropping,
> +scaling and composing.</para>
> +
> +<para>On a video <emphasis>capture</emphasis> device the source is a video
> +signal, and the cropping target determine the area actually sampled. The sink
> +is an image stored in a memory buffer.  The composing area specifies which part
> +of the buffer is actually written to by the hardware. </para>
> +
> +<para>On a video <emphasis>output</emphasis> device the source is an image in a
> +memory buffer, and the cropping target is a part of an image to be shown on a
> +display. The sink is the display or the graphics screen. The application may
> +select the part of display where the image should be displayed. The size and
> +position of such a window is controlled by the compose target.</para>
> +
> +<para>Rectangles for all cropping and composing targets are defined even if the
> +device does supports neither cropping nor composing. Their size and position
> +will be fixed in such a case. If the device does not support scaling then the
> +cropping and composing rectangles have the same size.</para>
> +
> +  </section>
> +
> +    <section>
> +      <title>Selection targets</title>
> +
> +      <figure id="sel-targets-capture">
> +	<title>Cropping and composing targets</title>
> +	<mediaobject>
> +	  <imageobject>
> +	    <imagedata fileref="selection.png" format="PNG" />
> +	  </imageobject>
> +	  <textobject>
> +	    <phrase>Targets used by a cropping, composing and scaling
> +            process</phrase>
> +	  </textobject>
> +	</mediaobject>
> +      </figure>
> +    </section>
> +
> +  <section>
> +
> +  <title>Configuration</title>
> +
> +<para>Applications can use the <link linkend="vidioc-g-selection">selection
> +API</link> to select an area in a video signal or a buffer, and to query for
> +default settings and hardware limits.</para>
> +
> +<para>Video hardware can have various cropping, composing and scaling
> +limitations. It may only scale up or down, support only discrete scaling
> +factors, or have different scaling abilities in the horizontal and vertical
> +directions. Also it may not support scaling at all. At the same time the
> +cropping/composing rectangles may have to be aligned, and both the source and
> +the sink may have arbitrary upper and lower size limits. Therefore, as usual,
> +drivers are expected to adjust the requested parameters and return the actual
> +values selected. An application can control the rounding behaviour using <link
> +linkend="v4l2-sel-flags"> constraint flags </link>.</para>
> +
> +   <section>
> +
> +   <title>Configuration of video capture</title>
> +
> +<para>See figure <xref linkend="sel-targets-capture" /> for examples of the
> +selection targets available for a video capture device.  It is recommended to
> +configure the cropping targets before to the composing targets.</para>
> +
> +<para>The range of coordinates of the top left corner, width and height of
> +areas that can be sampled is given by the <constant> V4L2_SEL_CROP_BOUNDS
> +</constant> target. It is recommended for the driver developers to put the
> +top/left corner at position <constant> (0,0) </constant>.  The rectangle's
> +coordinates are expressed in driver dependant units, although the coordinate
> +system guarantees that if sizes of the active cropping and the active composing
> +rectangles are equal then no scaling is performed.  </para>
> +
> +<para>The top left corner, width and height of the source rectangle, that is
> +the area actually sampled, is given by the <constant> V4L2_SEL_CROP_ACTIVE
> +</constant> target. It uses the same coordinate system as <constant>
> +V4L2_SEL_CROP_BOUNDS </constant>. The active cropping area must lie completely
> +inside the capture boundaries. The driver may further adjust the requested size
> +and/or position according to hardware limitations.</para>
> +
> +<para>Each capture device has a default source rectangle, given by the
> +<constant> V4L2_SEL_CROP_DEFAULT </constant> target. This rectangle shall over
> +what the driver writer considers the complete picture.  Drivers shall set the
> +active crop rectangle to the default when the driver is first loaded, but not
> +later.</para>
> +
> +<para>The composing targets refer to a memory buffer. The limits of composing
> +coordinates are obtained using <constant> V4L2_SEL_COMPOSE_BOUNDS </constant>.
> +All coordinates are expressed in natural unit for given formats. Pixels are
> +highly recommended.  The rectangle's top/left corner must be located at
> +position <constant> (0,0) </constant>. The width and height are equal to the
> +image size set by <constant> VIDIOC_S_FMT </constant>.</para>
> +
> +<para>The part of a buffer into which the image is inserted by the hardware is
> +controlled by the <constant> V4L2_SEL_COMPOSE_ACTIVE </constant> target.  The
> +rectangle's coordinates are also expressed in the same coordinate system as the
> +bounds rectangle. The composing rectangle must lie completely inside bounds
> +rectangle. The driver must adjust the composing rectangle to fit to the
> +bounding limits. Moreover, the driver can perform other adjustments according
> +to hardware limitations. The application can control rounding behaviour using
> +<link linkend="v4l2-sel-flags"> constraint flags </link>.</para>
> +
> +<para>For capture devices the default composing rectangle is queried using
> +<constant> V4L2_SEL_COMPOSE_DEFAULT </constant>. It is usually equal to the
> +bounding rectangle.</para>
> +
> +<para>The part of a buffer that is modified by the hardware is given by
> +<constant> V4L2_SEL_COMPOSE_PADDED </constant>. It contains all pixels defined
> +using <constant> V4L2_SEL_COMPOSE_ACTIVE </constant> plus all padding data
> +modified by hardware during insertion process. All pixels outside this rectangle
> +<emphasis>must not</emphasis> be changed by the hardware. The content of pixels
> +that lie inside the padded area but outside active area is undefined. The
> +application can use the padded and active rectangles to detect where the
> +rubbish pixels are located and remove them if needed.</para>
> +
> +   </section>
> +
> +   <section>
> +
> +   <title>Configuration of video output</title>
> +
> +<para>For output devices targets and ioctls are used similarly to the video
> +capture case. The <emphasis> composing </emphasis> rectangle refers to the
> +insertion of an image into a video signal. The cropping rectangles refer to a
> +memory buffer. It is recommended to configure the composing targets before to
> +the cropping targets.</para>
> +
> +<para>The cropping targets refer to the memory buffer that contains an image to
> +be inserted into a video signal or graphical screen. The limits of cropping
> +coordinates are obtained using <constant> V4L2_SEL_CROP_BOUNDS </constant>. All
> +coordinates are expressed in natural units for a given format. Pixels are
> +highly recommended.  The top/left corner is always point <constant> (0,0)
> +</constant>.  The width and height is equal to the image size specified using
> +<constant> VIDIOC_S_FMT </constant> ioctl.</para>
> +
> +<para>The top left corner, width and height of the source rectangle, that is
> +the area from which image date are processed by the hardware, is given by the
> +<constant> V4L2_SEL_CROP_ACTIVE </constant>. Its coordinates are expressed in
> +in the same coordinate system as the bounds rectangle. The active cropping area
> +must lie completely inside the crop boundaries and the driver may further
> +adjust the requested size and/or position according to hardware
> +limitations.</para>
> +
> +<para>For output devices the default cropping rectangle is queried using
> +<constant> V4L2_SEL_CROP_DEFAULT </constant>. It is usually equal to the
> +bounding rectangle.</para>
> +
> +<para>The part of a video signal or graphics display where the image is
> +inserted by the hardware is controlled by <constant> V4L2_SEL_COMPOSE_ACTIVE
> +</constant> target.  The rectangle's coordinates are expressed in driver
> +dependant units. The only exception are digital outputs where the units are
> +pixels. For other types of devices, the coordinate system guarantees that if
> +sizes of the active cropping and the active composing rectangles are equal then
> +no scaling is performed.  The composing rectangle must lie completely inside
> +the bounds rectangle.  The driver must adjust the area to fit to the bounding
> +limits.  Moreover, the driver can perform other adjustments according to
> +hardware limitations. </para>
> +
> +<para>The device has a default composing rectangle, given by the <constant>
> +V4L2_SEL_COMPOSE_DEFAULT </constant> target. This rectangle shall cover what
> +the driver writer considers the complete picture. It is recommended for the
> +driver developers to put the top/left corner at position <constant> (0,0)
> +</constant>. Drivers shall set the active composing rectangle to the default
> +one when the driver is first loaded.</para>
> +
> +<para>The devices may introduce additional content to video signal other than
> +an image from memory buffers.  It includes borders around an image. However,
> +such a padded area is driver-dependent feature not covered by this document.
> +Driver developers are encouraged to keep padded rectangle equal to active one.
> +The padded target is accessed by the <constant> V4L2_SEL_COMPOSE_PADDED
> +</constant> identifier.  It must contain all pixels from the <constant>
> +V4L2_SEL_COMPOSE_ACTIVE </constant> target.</para>
> +
> +   </section>
> +
> +   <section>
> +
> +     <title>Scaling control.</title>
> +
> +<para>An application can detect if scaling is performed by comparing the width
> +and the height of rectangles obtained using <constant> V4L2_SEL_CROP_ACTIVE
> +</constant> and <constant> V4L2_SEL_COMPOSE_ACTIVE </constant> targets. If
> +these are not equal then the scaling is applied. The application can compute
> +the scaling ratios using these values.</para>
> +
> +   </section>
> +
> +  </section>
> +
> +  <section>
> +
> +    <title>Comparison with old cropping API.</title>
> +
> +<para>The selection API was introduced to cope with deficiencies of previous
> +<link linkend="crop"> API </link>, that was designed to control simple capture
> +devices. Later the cropping API was adopted by video output drivers. The ioctls
> +are used to select a part of the display were the video signal is inserted. It
> +should be considered as an API abuse because the described operation is
> +actually the composing.  The selection API makes a clear distinction between
> +composing and cropping operations by setting the appropriate targets.  The V4L2
> +API lacks any support for composing to and cropping from an image inside a
> +memory buffer.  The application could configure a capture device to fill only a
> +part of an image by abusing V4L2 API.  Cropping a smaller image from a larger
> +one is achieved by setting the field <structfield>
> +&v4l2-pix-format;::bytesperline </structfield>.  Introducing an image offsets
> +could be done by modifying field <structfield> &v4l2-buffer;::m:userptr
> +</structfield> before calling <constant> VIDIOC_QBUF </constant>. Those
> +operations should be avoided because they are not portable (endianness), and do
> +not work for macroblock and Bayer formats and mmap buffers.  The selection API
> +deals with configuration of buffer cropping/composing in a clear, intuitive and
> +portable way.  Next, with the selection API the concepts of the padded target
> +and constraints flags are introduced.  Finally, <structname> &v4l2-crop;
> +</structname> and <structname> &v4l2-cropcap; </structname> have no reserved
> +fields. Therefore there is no way to extend their functionality.  The new
> +<structname> &v4l2-selection; </structname> provides a lot of place for future
> +extensions.  Driver developers are encouraged to implement only selection API.
> +The former cropping API would be simulated using the new one. </para>
> +
> +  </section>
> +
> +   <section>
> +      <title>Examples</title>
> +      <example>
> +	<title>Resetting the cropping parameters</title>
> +
> +	<para>(A video capture device is assumed; change <constant>
> +V4L2_BUF_TYPE_VIDEO_CAPTURE </constant> for other devices; change target to
> +<constant> V4L2_SEL_COMPOSE_* </constant> family to configure composing
> +area)</para>
> +
> +	<programlisting>
> +
> +	&v4l2-selection; sel = {
> +		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
> +		.target = V4L2_SEL_CROP_DEFAULT,
> +	};
> +	ret = ioctl(fd, &VIDIOC-G-SELECTION;, &amp;sel);
> +	if (ret)
> +		exit(-1);
> +	sel.target = V4L2_SEL_CROP_ACTIVE;
> +	ret = ioctl(fd, &VIDIOC-S-SELECTION;, &amp;sel);
> +	if (ret)
> +		exit(-1);
> +
> +        </programlisting>
> +      </example>
> +
> +      <example>
> +	<title>Simple downscaling</title>
> +	<para>Setting a composing area on output of size of <emphasis> at most
> +</emphasis> half of limit placed at a center of a display.</para>
> +	<programlisting>
> +
> +	&v4l2-selection; sel = {
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
> +		.target = V4L2_SEL_COMPOSE_BOUNDS,
> +	};
> +	struct v4l2_rect r;
> +
> +	ret = ioctl(fd, &VIDIOC-G-SELECTION;, &amp;sel);
> +	if (ret)
> +		exit(-1);
> +	/* setting smaller compose rectangle */
> +	r.width = sel.r.width / 2;
> +	r.height = sel.r.height / 2;
> +	r.left = sel.r.width / 4;
> +	r.top = sel.r.height / 4;
> +	sel.r = r;
> +	sel.target = V4L2_SEL_COMPOSE_ACTIVE;
> +	sel.flags = V4L2_SEL_SIZE_LE;
> +	ret = ioctl(fd, &VIDIOC-S-SELECTION;, &amp;sel);
> +	if (ret)
> +		exit(-1);
> +
> +        </programlisting>
> +      </example>
> +
> +      <example>
> +	<title>Querying for scaling factors</title>
> +	<para>A video output device is assumed; change <constant>
> +V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> for other devices</para>
> +	<programlisting>
> +
> +	&v4l2-selection; compose = {
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
> +		.target = V4L2_SEL_COMPOSE_ACTIVE,
> +	};
> +	&v4l2-selection; crop = {
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
> +		.target = V4L2_SEL_CROP_ACTIVE,
> +	};
> +	double hscale, vscale;
> +
> +	ret = ioctl(fd, &VIDIOC-G-SELECTION;, &amp;compose);
> +	if (ret)
> +		exit(-1);
> +	ret = ioctl(fd, &VIDIOC-G-SELECTION;, &amp;crop);
> +	if (ret)
> +		exit(-1);
> +
> +	/* computing scaling factors */
> +	hscale = (double)compose.r.width / crop.r.width;
> +	vscale = (double)compose.r.height / crop.r.height;
> +
> +	</programlisting>
> +      </example>
> +
> +   </section>
> +
> +</section>
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index 40132c2..7f1b710 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -500,6 +500,7 @@ and discussions on the V4L mailing list.</revremark>
>      &sub-g-output;
>      &sub-g-parm;
>      &sub-g-priority;
> +    &sub-g-selection;
>      &sub-g-sliced-vbi-cap;
>      &sub-g-std;
>      &sub-g-tuner;
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
> new file mode 100644
> index 0000000..e0ef3e7
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
> @@ -0,0 +1,303 @@
> +<refentry id="vidioc-g-selection">
> +
> +  <refmeta>
> +    <refentrytitle>ioctl VIDIOC_G_SELECTION, VIDIOC_S_SELECTION</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +
> +  <refnamediv>
> +    <refname>VIDIOC_G_SELECTION</refname>
> +    <refname>VIDIOC_S_SELECTION</refname>
> +    <refpurpose>Get or set one of the selection rectangles</refpurpose>
> +  </refnamediv>
> +
> +  <refsynopsisdiv>
> +    <funcsynopsis>
> +      <funcprototype>
> +	<funcdef>int <function>ioctl</function></funcdef>
> +	<paramdef>int <parameter>fd</parameter></paramdef>
> +	<paramdef>int <parameter>request</parameter></paramdef>
> +	<paramdef>struct v4l2_selection *<parameter>argp</parameter></paramdef>
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
> +	  <para>VIDIOC_G_SELECTION, VIDIOC_S_SELECTION</para>
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
> +    <note>
> +      <title>Experimental</title>
> +      <para>This is an <link linkend="experimental"> experimental </link>
> +      interface and may change in the future.</para>
> +    </note>
> +
> +    <para>The ioctls are used to query and configure selection rectangles.</para>
> +
> +<para> To query the cropping (composing) rectangle set <structfield>
> +&v4l2-selection;::type </structfield> to the respective buffer type.  Do not
> +use multiplanar buffers.  Use <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE
> +</constant> instead of <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
> +</constant>.  Use <constant> V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> instead of
> +<constant> V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE </constant>.  The next step is
> +setting <structfield> &v4l2-selection;::target </structfield> to value
> +<constant> V4L2_SEL_CROP_ACTIVE </constant> (<constant> V4L2_SEL_COMPOSE_ACTIVE
> +</constant>).  Please refer to table <xref linkend="v4l2-sel-target" /> or
> +<xref linkend="selection-api" /> for additional targets.  Fields <structfield>
> +&v4l2-selection;::flags </structfield> and <structfield>
> +&v4l2-selection;::reserved </structfield> are ignored and they must be filled
> +with zeros.  The driver fills the rest of the structure or returns &EINVAL; if
> +incorrect buffer type or target was used. If cropping (composing) is not
> +supported then the active rectangle is not mutable and it is always equal to
> +the bounds rectangle.  Finally, structure <structfield> &v4l2-selection;::r
> +</structfield> is filled with the current cropping (composing) coordinates. The
> +coordinates are expressed in driver-dependent units. The only exception are
> +rectangles for images in raw formats, whose coordinates are always expressed in
> +pixels.  </para>
> +
> +<para> To change the cropping (composing) rectangle set <structfield>
> +&v4l2-selection;::type </structfield> to the respective buffer type.  Do not
> +use multiplanar buffers.  Use <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE
> +</constant> instead of <constant> V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE
> +</constant>.  Use <constant> V4L2_BUF_TYPE_VIDEO_OUTPUT </constant> instead of
> +<constant> V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE </constant>.  The next step is
> +setting <structfield> &v4l2-selection;::target </structfield> to value
> +<constant> V4L2_SEL_CROP_ACTIVE </constant> (<constant> V4L2_SEL_COMPOSE_ACTIVE
> +</constant>). Please refer to table <xref linkend="v4l2-sel-target" /> or <xref
> +linkend="selection-api" /> for additional targets.  Set desired active area
> +into the field <structfield> &v4l2-selection;::r </structfield>.  Field
> +<structfield> &v4l2-selection;::reserved </structfield> is ignored and must be
> +filled with zeros.  The driver may adjust the rectangle coordinates. An
> +application may introduce constraints to control rounding behaviour. Set the
> +field <structfield> &v4l2-selection;::flags </structfield> to one of values:
> +
> +<itemizedlist>
> +  <listitem>
> +<para><constant>0</constant> - The driver can adjust the rectangle size freely
> +and shall choose a crop/compose rectangle as close as possible to the requested
> +one.</para>
> +  </listitem>
> +  <listitem>
> +<para><constant>V4L2_SEL_SIZE_GE</constant> - The driver is not allowed to
> +shrink the rectangle.  The original rectangle must lay inside the adjusted
> +one.</para>
> +  </listitem>
> +  <listitem>
> +<para><constant>V4L2_SEL_SIZE_LE</constant> - The driver is not allowed to
> +enlarge the rectangle.  The adjusted rectangle must lay inside the original
> +one.</para>
> +  </listitem>
> +  <listitem>
> +<para><constant>V4L2_SEL_SIZE_GE | V4L2_SEL_SIZE_LE</constant> - The driver
> +must choose the size exactly the same as in the requested rectangle.</para>
> +  </listitem>
> +</itemizedlist>
> +
> +Please refer to <xref linkend="sel-const-adjust" />.
> +
> +</para>
> +
> +<para> The driver may have to adjusts the requested dimensions against hardware
> +limits and other parts as the pipeline, i.e. the bounds given by the
> +capture/output window or TV display. The closest possible values of horizontal
> +and vertical offset and sizes are chosen according to following priority:
> +
> +<orderedlist>
> +  <listitem>
> +    <para>Satisfy constraints from <structfield>&v4l2-selection;::flags</structfield>.</para>
> +  </listitem>
> +  <listitem>
> +    <para>Adjust width, height, left, and top to hardware limits and alignments.</para>
> +  </listitem>
> +  <listitem>
> +    <para>Keep center of adjusted rectangle as close as possible to the original one.</para>
> +  </listitem>
> +  <listitem>
> +    <para>Keep width and height as close as possible to original ones.</para>
> +  </listitem>
> +  <listitem>
> +    <para>Keep horizontal and vertical offset as close as possible to original ones.</para>
> +  </listitem>
> +</orderedlist>
> +
> +On success the field <structfield> &v4l2-selection;::r </structfield> contains
> +the adjusted rectangle. When the parameters are unsuitable the application may
> +modify the cropping (composing) or image parameters and repeat the cycle until
> +satisfactory parameters have been negotiated. If constraints flags have to be
> +violated at then ERANGE is returned. The error indicates that <emphasis> there
> +exist no rectangle </emphasis> that satisfies the constraints.</para>
> +
> +  </refsect1>
> +
> +  <refsect1>
> +    <table frame="none" pgwide="1" id="v4l2-sel-target">
> +      <title>Selection targets.</title>
> +      <tgroup cols="3">
> +	&cs-def;
> +	<tbody valign="top">
> +	  <row>
> +            <entry><constant>V4L2_SEL_CROP_ACTIVE</constant></entry>
> +            <entry>0</entry>
> +            <entry>area that is currently cropped by hardware</entry>
> +	  </row>
> +	  <row>
> +            <entry><constant>V4L2_SEL_CROP_DEFAULT</constant></entry>
> +            <entry>1</entry>
> +            <entry>suggested cropping rectangle that covers the "whole picture"</entry>
> +	  </row>
> +	  <row>
> +            <entry><constant>V4L2_SEL_CROP_BOUNDS</constant></entry>
> +            <entry>2</entry>
> +            <entry>limits for the cropping rectangle</entry>
> +	  </row>
> +	  <row>
> +            <entry><constant>V4L2_SEL_COMPOSE_ACTIVE</constant></entry>
> +            <entry>256</entry>
> +            <entry>area to which data are composed by hardware</entry>
> +	  </row>
> +	  <row>
> +            <entry><constant>V4L2_SEL_COMPOSE_DEFAULT</constant></entry>
> +            <entry>257</entry>
> +            <entry>suggested composing rectangle that covers the "whole picture"</entry>
> +	  </row>
> +	  <row>
> +            <entry><constant>V4L2_SEL_COMPOSE_BOUNDS</constant></entry>
> +            <entry>258</entry>
> +            <entry>limits for the composing rectangle</entry>
> +	  </row>
> +	  <row>
> +            <entry><constant>V4L2_SEL_COMPOSE_PADDED</constant></entry>
> +            <entry>259</entry>
> +            <entry>the active area and all padding pixels that are inserted or modified by the hardware</entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +  </refsect1>
> +
> +  <refsect1>
> +    <table frame="none" pgwide="1" id="v4l2-sel-flags">
> +      <title>Selection constraint flags</title>
> +      <tgroup cols="3">
> +	&cs-def;
> +	<tbody valign="top">
> +	  <row>
> +            <entry><constant>V4L2_SEL_SIZE_GE</constant></entry>
> +            <entry>0x00000001</entry>
> +            <entry>indicate that adjusted rectangle must contain a rectangle from <structfield>&v4l2-selection;::r</structfield></entry>
> +	  </row>
> +	  <row>
> +            <entry><constant>V4L2_SEL_SIZE_LE</constant></entry>
> +            <entry>0x00000002</entry>
> +            <entry>indicate that adjusted rectangle must be inside a rectangle from <structfield>&v4l2-selection;::r</structfield></entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +  </refsect1>
> +
> +    <section>
> +      <figure id="sel-const-adjust">
> +	<title>Size adjustments with constraint flags.</title>
> +	<mediaobject>
> +	  <imageobject>
> +	    <imagedata fileref="constraints.png" format="PNG" />
> +	  </imageobject>
> +	  <textobject>
> +	    <phrase>Behaviour of rectangle adjustment for different constraint
> +            flags.</phrase>
> +	  </textobject>
> +	</mediaobject>
> +      </figure>
> +    </section>
> +
> +  <refsect1>
> +    <table pgwide="1" frame="none" id="v4l2-selection">
> +      <title>struct <structname>v4l2_selection</structname></title>
> +      <tgroup cols="3">
> +	&cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>type</structfield></entry>
> +	    <entry>Type of the buffer (from &v4l2-buf-type;)</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>target</structfield></entry>
> +            <entry>used to select between <link linkend="v4l2-sel-target"> cropping and composing rectangles </link></entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>flags</structfield></entry>
> +            <entry>control over coordinates adjustments, refer to <link linkend="v4l2-sel-flags">selection flags</link></entry>
> +	  </row>
> +	  <row>
> +	    <entry>&v4l2-rect;</entry>
> +	    <entry><structfield>r</structfield></entry>
> +	    <entry>selection rectangle</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved[9]</structfield></entry>
> +	    <entry>Reserved fields for future use</entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +  </refsect1>
> +
> +  <refsect1>
> +    &return-value;
> +    <variablelist>
> +      <varlistentry>
> +	<term><errorcode>EINVAL</errorcode></term>
> +	<listitem>
> +	  <para>The buffer <structfield> &v4l2-selection;::type </structfield>
> +or <structfield> &v4l2-selection;::target </structfield> is not supported, or
> +the <structfield> &v4l2-selection;::flags </structfield> are invalid.</para>
> +	</listitem>
> +      </varlistentry>
> +      <varlistentry>
> +	<term><errorcode>ERANGE</errorcode></term>
> +	<listitem>
> +	  <para>it is not possible to adjust a rectangle <structfield>
> +&v4l2-selection;::r </structfield> that satisfies all contraints from
> +<structfield> &v4l2-selection;::flags </structfield>.</para>
> +	</listitem>
> +      </varlistentry>
> +      <varlistentry>
> +	<term><errorcode>EBUSY</errorcode></term>
> +	<listitem>
> +	  <para>it is not possible to apply change of selection rectangle at the moment.
> +Usually because streaming is in progress.</para>
> +	</listitem>
> +      </varlistentry>
> +    </variablelist>
> +  </refsect1>
> +
> +</refentry>

