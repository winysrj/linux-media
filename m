Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3653 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab1I0JVL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Sep 2011 05:21:11 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 2/4] v4l: add documentation for selection API
Date: Tue, 27 Sep 2011 11:20:29 +0200
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi
References: <1314793703-32345-1-git-send-email-t.stanislaws@samsung.com> <1314793703-32345-3-git-send-email-t.stanislaws@samsung.com>
In-Reply-To: <1314793703-32345-3-git-send-email-t.stanislaws@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109271120.29606.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, August 31, 2011 14:28:21 Tomasz Stanislawski wrote:
> This patch adds a documentation for VIDIOC_{G/S}_SELECTION ioctl. Moreover, the
> patch adds the description of modeling of composing, cropping and scaling
> features in V4L2. Finally, some examples are presented.
> 
> Signed-off-by: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  Documentation/DocBook/media/constraints.png.b64    |  134 +
>  Documentation/DocBook/media/selection.png.b64      | 2937 ++++++++++++++++++++
>  Documentation/DocBook/media/v4l/common.xml         |    4 +-
>  Documentation/DocBook/media/v4l/selection-api.xml  |  278 ++
>  Documentation/DocBook/media/v4l/v4l2.xml           |    1 +
>  .../DocBook/media/v4l/vidioc-g-selection.xml       |  281 ++
>  6 files changed, 3634 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/DocBook/media/constraints.png.b64
>  create mode 100644 Documentation/DocBook/media/selection.png.b64
>  create mode 100644 Documentation/DocBook/media/v4l/selection-api.xml
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-g-selection.xml
> 
> diff --git a/Documentation/DocBook/media/constraints.png.b64 b/Documentation/DocBook/media/constraints.png.b64
> new file mode 100644
> index 0000000..1e5a136
> --- /dev/null
> +++ b/Documentation/DocBook/media/constraints.png.b64

For future reference: please put binary files in a separate patch. That makes
it easier to review the non-binary parts.

> diff --git a/Documentation/DocBook/media/v4l/common.xml b/Documentation/DocBook/media/v4l/common.xml
> index a86f7a0..9c41c32 100644
> --- a/Documentation/DocBook/media/v4l/common.xml
> +++ b/Documentation/DocBook/media/v4l/common.xml
> @@ -856,8 +856,10 @@ conversion routine or library for integration into applications.</para>
>  
>    &sub-planar-apis;
>  
> +  &sub-selection-api;
> +
>    <section id="crop">
> -    <title>Image Cropping, Insertion and Scaling</title>
> +    <title>Deprecated API for image cropping, insertion and scaling</title>

I wouldn't call this deprecated. It's part of the API and we will just keep on
supporting this.

I would instead refer to the new section on the selection API.

>  
>      <para>Some video capture devices can sample a subsection of the
>  picture and shrink or enlarge it to an image of arbitrary size. We
> diff --git a/Documentation/DocBook/media/v4l/selection-api.xml b/Documentation/DocBook/media/v4l/selection-api.xml
> new file mode 100644
> index 0000000..d9fd57d8
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/selection-api.xml
> @@ -0,0 +1,278 @@
> +<section id="selection-api">
> +
> +  <title>Cropping, composing and scaling</title>
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
> +is an image stored in a memory buffer.  The composing area specify which part
> +of the buffer is actually written by the hardware. </para>
> +
> +<para>On a video <emphasis>output</emphasis> device the source is an image in a
> +memory buffer, and the cropping target is a part of an image to shown on a
> +display. The sink is the display or the graphics screen. The application may
> +select the part of display where the image should be displayed. The size and
> +position of such a window is controlled by compose target.</para>
> +
> +<para>Rectangles for all cropping and composing targets are defined even if the
> +device does not support neither cropping nor composing. Their size and position
> +will be fixed in such a case. If the device does not support scaling then the
> +cropping and composing rectangles have the same size.</para>
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
> +factors, or have different scaling abilities in horizontal and vertical
> +direction. Also it may not support scaling at all. At the same time the
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
> +<para>See the figure <xref linkend="sel-targets-capture" /> for examples of the
> +selection targets available for a video capture device. The targets should be
> +configured according to the pipeline configuration rules for a capture device.
> +It means that the cropping targets must be configured in prior to the composing
> +targets.</para>
> +
> +<para>The range of coordinates of the top left corner, width and height of a
> +area which can be sampled is given by the <constant> V4L2_SEL_CROP_BOUNDS
> +</constant> target. To support a wide range of hardware this specification does
> +not define an origin or units.</para>

I know this phrase is present in the crop API, but I've never liked it. It makes
life very hard for applications if the units aren't in pixels. The main reason
the crop API was written in that way was for analog video receivers: while analog
TV has discrete lines, in the horizontal direction there really isn't a clear
'pixel' concept. However, I've always thought that was a bogus argument since
after sampling you end up with pixels anyway.

In my opinion the selection API should deal with pixels only. The main driver
where this might cause problems is bttv. I'm not sure how the selection vs crop
API translation would work there. It might be best to just keep the current crop
implementation in bttv and make a separate selection implementation. I'm pretty
sure the bttv driver actually does/can do sub-pixel cropping.

With respect to the origin: I think I would put the top-left corner of the
default crop rectangle at (0, 0). Strictly speaking it shouldn't matter where
the origin is, but it seems to me that that's a logical choice.

> +<para>The top left corner, width and height of the source rectangle, that is
> +the area actually sampled, is given by <constant> V4L2_SEL_CROP_ACTIVE
> +</constant> target. It uses the same coordinate system as <constant>
> +V4L2_SEL_CROP_BOUNDS </constant>. The active cropping area must lie completely
> +inside the capture boundaries. The driver may further adjust the requested size
> +and/or position according to hardware limitations.</para>
> +
> +<para>Each capture device has a default source rectangle, given by the
> +<constant> V4L2_SEL_CROP_DEFAULT </constant> target. The center of this
> +rectangle shall align with the center of the active picture area of the video
> +signal, and cover what the driver writer considers the complete picture.
> +Drivers shall reset the crop rectangle to the default when the driver is first
> +loaded, but not later.</para>
> +
> +<para>The composing targets refer to a memory buffer. The limits of composing
> +coordinates are obtained using <constant> V4L2_SEL_COMPOSE_BOUNDS </constant>.
> +All coordinates are expressed in pixels. The top/left corner is always point
> +<constant> {0,0} </constant>. The width and height is equal to the image size
> +specified using <constant> VIDIOC_S_FMT </constant>.</para>
> +
> +<para>The part of a buffer into which the image is inserted by the hardware is
> +controlled by <constant> V4L2_SEL_COMPOSE_ACTIVE </constant> target.  The
> +rectangle's coordinates are also expressed in pixels. The composing rectangle
> +must lie completely inside bounds rectangle. The driver must adjust the
> +composing rectangle to fit to the bounding limits. Moreover, the driver can
> +perform other adjustments according to hardware limitations. The application
> +can control rounding behaviour using <link linkend="v4l2-sel-flags"> constraint
> +flags </link>.</para>
> +
> +<para>For capture devices the default composing rectangle is queried using
> +<constant> V4L2_SEL_COMPOSE_DEFAULT </constant> and it is always equal to
> +bounding rectangle.</para>
> +
> +<para>The part of a buffer that is modified by the hardware is given by
> +<constant> V4L2_SEL_COMPOSE_PADDED </constant>. It contains all pixels defined
> +using <constant> V4L2_SEL_COMPOSE_ACTIVE </constant> plus all padding data
> +modified by hardware during insertion process. All pixel outside this rectangle
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
> +<para>For output devices targets and ioctls are used accordingly to the video
> +capture case. The <emphasis>composing</emphasis> rectangle refer to insertion
> +of an image into a video signal. The cropping rectangles refer to a memory
> +buffer. The targets are should be configured according to the pipeline
> +configuration rules for a output device. It means that the compose targets must
> +be configured in prior to cropping targets.</para>
> +
> +<para>The cropping targets refer to the memory buffer which contains an image
> +to be inserted into video signal or graphical screen. The limits of cropping
> +coordinates are obtained using <constant> V4L2_SEL_CROP_BOUNDS </constant>. All
> +coordinates are expressed in pixels. The top/left corner is always point
> +<constant> {0,0} </constant>. The width and height is equal to the image size
> +specified using <constant> VIDIOC_S_FMT </constant> ioctl.</para>
> +
> +<para>The top left corner, width and height of the source rectangle, that is
> +the area from which pixels are processed by the hardware. The target identifier
> +is <constant> V4L2_SEL_CROP_ACTIVE </constant>. Its coordinates are expressed
> +in pixels.  The active cropping area must lie completely inside the crop
> +boundaries and the driver may further adjust the requested size and/or position
> +according to hardware limitations.</para>
> +
> +<para>For output devices the default cropping rectangle is queried using
> +<constant> V4L2_SEL_CROP_DEFAULT </constant> and it is always equal to cropping
> +bounding rectangle.</para>
> +
> +<para>The part of a video signal or graphics display where the image is
> +inserted by the hardware is controlled by <constant> V4L2_SEL_COMPOSE_ACTIVE
> +</constant> target.  The rectangle's coordinates are expressed driver dependant
> +units. The only exception are digital outputs where the units are pixels.

Same as before: I would always use pixels as units.

> The
> +composing rectangle must lie completely inside bounds rectangle.  The driver
> +must adjust the area to fit to the bounding limits. Moreover, the driver can
> +perform other adjustments according to hardware limitations. </para>
> +
> +<para>The device has a default composing rectangle, given by the <constant>
> +V4L2_SEL_COMPOSE_DEFAULT </constant> target. The center of this rectangle shall
> +align with the center of the active picture area of the video signal, and cover
> +what the driver writer considers the complete picture.

I would remove the 'align with the center of the active picture area' part.
I think the second part of that sentence is sufficient.

In addition, just like with capture, I would suggest that the origin of the default
compose rectangle is set to (0, 0).

> Drivers shall reset the
> +composing rectangle to the default one when the driver is first loaded.</para>
> +
> +<para>The devices may introduce additional content to video signal other then
> +an image from memory buffers.  It includes borders around an image. However,
> +such a padding area is very driver-dependant issue. Driver developers are
> +encouraged to keep padding rectangle equal to active one.  The padding target
> +is accessed by <constant> V4L2_SEL_COMPOSE_PADDED </constant> identifier.  It
> +must contain all pixels from <constant> V4L2_SEL_COMPOSE_ACTIVE </constant>
> +target.</para>
> +
> +    </section>
> +
> +    <section>
> +
> +      <title>Scaling control.</title>
> +
> +<para>An application can detect if scaling is performed by comparing width and
> +height of rectangles obtained using <constant> V4L2_SEL_CROP_ACTIVE </constant>
> +and <constant> V4L2_SEL_COMPOSE_ACTIVE </constant> targets. If these are not
> +equal then the scaling is applied. The application can compute scaling ratios
> +using these values.</para>
> +
> +    </section>
> +
> +   </section>
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
> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
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
> index 0d05e87..54333a5 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -493,6 +493,7 @@ and discussions on the V4L mailing list.</revremark>
>      &sub-g-output;
>      &sub-g-parm;
>      &sub-g-priority;
> +    &sub-g-selection;
>      &sub-g-sliced-vbi-cap;
>      &sub-g-std;
>      &sub-g-tuner;
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
> new file mode 100644
> index 0000000..6d93832
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
> @@ -0,0 +1,281 @@
> +<refentry id="vidioc-g-selection">
> +  <refmeta>
> +    <refentrytitle>ioctl VIDIOC_G_SELECTION, VIDIOC_S_SELECTION</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +
> +  <refnamediv>
> +    <refname>VIDIOC_G_SELECTION</refname>
> +    <refname>VIDIOC_S_SELECTION</refname>
> +    <refpurpose>Get or set one of the current selection rectangles</refpurpose>
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
> +    <para>The ioctls are used to query and configure selection rectangles.</para>
> +
> +<para> To query the cropping (composing) rectangle set <structfield>
> +v4l2_selection::type </structfield> to the respective buffer type.  Then set
> +<structfield> v4l2_selection::target </structfield> to value <constant>
> +V4L2_SEL_CROP_ACTIVE </constant> (<constant> V4L2_SEL_COMPOSE_ACTIVE
> +</constant>).  Please refer to table <xref linkend="v4l2-sel-target" /> or
> +<xref linkend="selection-api" /> for additional targets.  Fields <structfield>
> +v4l2_selection::flags </structfield> and <structfield> v4l2_selection::reserved
> +</structfield> are ignored and they must be filled with zeros.  The driver
> +fills the rest of structure or returns &EINVAL; if incorrect buffer type or
> +target was used. If cropping (composing) is not supported then the active
> +rectangle is not mutable and it is always equal to bounds rectangle.  Finally,
> +structure <structfield> v4l2-selection::r </structfield> is filled with current
> +cropping (composing) coordinates. The coordinates are expressed in
> +driver-dependant units. The only exception are rectangles for images in raw
> +formats, which coordinates are always expressed in pixels.  </para>
> +
> +<para> To change the cropping (composing) rectangle set <structfield>
> +v4l2_selection::type </structfield> to the respective buffer type.  Then set
> +<structfield> v4l2_selection::target </structfield> to value <constant>
> +V4L2_SEL_CROP_ACTIVE </constant> (<constant> V4L2_SEL_COMPOSE_ACTIVE
> +</constant>). Please refer to table <xref linkend="v4l2-sel-target" /> or <xref
> +linkend="selection-api" /> for additional targets.  Set desired active area
> +into the field <structfield> v4l2_selection::r </structfield>.  Field
> +<structfield> v4l2_selection::reserved </structfield> is ignored and they must
> +be filled with zeros.  The driver may adjust the rectangle coordinates. An
> +application may introduce constraints to control rounding behaviour. Set the
> +field <structfield> v4l2_selection::flags </structfield> to one of values:
> +
> +<itemizedlist>
> +  <listitem>
> +<para><constant>0</constant> - driver is free to adjust size, it is recommended
> +to choose the crop/compose rectangle as close as possible to the original
> +one</para>
> +  </listitem>
> +  <listitem>
> +<para><constant>SEL_SIZE_GE</constant> - driver is not allowed to shrink the
> +rectangle.  The original rectangle must lay inside the adjusted one</para>
> +  </listitem>
> +  <listitem>
> +<para><constant>SEL_SIZE_LE</constant> - drive is not allowed to grow the
> +rectangle.  The adjusted rectangle must lay inside the original one</para>
> +  </listitem>
> +  <listitem>
> +<para><constant>SEL_SIZE_GE | SEL_SIZE_LE</constant> - choose size exactly the
> +same as in desired rectangle.</para>
> +  </listitem>
> +</itemizedlist>
> +
> +Please refer to <xref linkend="sel-const-adjust" />.
> +
> +</para>
> +
> +<para> The driver may have to adjusts the requested dimensions against hardware
> +limits and other parts as the pipeline, i.e. the bounds given by the
> +capture/output window or TV display.  If constraints flags have to be violated
> +at any stage then ERANGE is returned. The closest possible values of horizontal
> +and vertical offset and sizes are chosen according to following priority:
> +
> +<orderedlist>
> +  <listitem>
> +    <para>Satisfy constraints from <structfield>v4l2_selection::flags</structfield>.</para>
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
> +On success field <structfield> v4l2_selection::r </structfield> contains
> +adjusted rectangle. When the parameters are unsuitable the application may
> +modify the cropping (composing) or image parameters and repeat the cycle until
> +satisfactory parameters have been negotiated.  </para>
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
> +            <entry>indicate that adjusted rectangle must contain a rectangle from <structfield>v4l2_selection::r</structfield></entry>
> +	  </row>
> +	  <row>
> +            <entry><constant>V4L2_SEL_SIZE_LE</constant></entry>
> +            <entry>0x00000002</entry>
> +            <entry>indicate that adjusted rectangle must be inside a rectangle from <structfield>v4l2_selection::r</structfield></entry>
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
> +            <entry>used to select between cropping and composing rectangles</entry>
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
> +	    <entry>Reserved fields for future use, adjust size to 64 bytes</entry>

I would remove the 'adjust size' part. It's not relevant here.

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
> +	  <para>The buffer <structfield>type</structfield> or <structfield>target</structfield>
> +is not supported, or the <structfield>flags</structfield> is invalid.</para>
> +	</listitem>
> +      </varlistentry>
> +      <varlistentry>
> +	<term><errorcode>ERANGE</errorcode></term>
> +	<listitem>
> +	  <para>it is not possible to adjust a selection rectangle <structfield>r</structfield>
> +that satisfy all contraints from <structfield>flags</structfield>.</para>
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
> 

BTW, I think it might be a good idea to do one more post of this patch series.
There have been several reviews after your git pull request, so I think it's
just a bit too early to have this merged. One more round is probably enough.

Regards,

	Hans
