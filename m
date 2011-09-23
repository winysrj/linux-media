Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62934 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab1IWMg4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Sep 2011 08:36:56 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Received: from euspt2 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LRZ009GE71HJ030@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Sep 2011 13:36:53 +0100 (BST)
Received: from [106.116.48.223] by spt2.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LRZ002Y571G6B@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 23 Sep 2011 13:36:53 +0100 (BST)
Date: Fri, 23 Sep 2011 14:36:51 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 2/4] v4l: add documentation for selection API
In-reply-to: <201109230041.27712.laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl, sakari.ailus@iki.fi
Message-id: <4E7C7D63.7070504@samsung.com>
References: <1314793703-32345-1-git-send-email-t.stanislaws@samsung.com>
 <1314793703-32345-3-git-send-email-t.stanislaws@samsung.com>
 <201109230041.27712.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/23/2011 12:41 AM, Laurent Pinchart wrote:

Hi Laurent,
Thank you for the review. It looks that spelling highlighting is not 
enough :).
I discussed some of your comments. There are still some open issues.
> Hi Tomasz,
>
> Thanks for the patch, and sorry for the late reply.
>
> On Wednesday 31 August 2011 14:28:21 Tomasz Stanislawski wrote:
>> This patch adds a documentation for VIDIOC_{G/S}_SELECTION ioctl. Moreover,
>> the patch adds the description of modeling of composing, cropping and
>> scaling features in V4L2. Finally, some examples are presented.
>>
>> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
> The documentation looks very good. Thank you for your great work. Just a couple
> of small comments below, mostly about typo fixes.
>
> [snip]
>
>> diff --git a/Documentation/DocBook/media/v4l/selection-api.xml
>> b/Documentation/DocBook/media/v4l/selection-api.xml new file mode 100644
>> index 0000000..d9fd57d8
>> --- /dev/null
>> +++ b/Documentation/DocBook/media/v4l/selection-api.xml
>> @@ -0,0 +1,278 @@
>> +<section id="selection-api">
>> +
>> +<title>Cropping, composing and scaling</title>
>> +
>> +<para>Some video capture devices can sample a subsection of a picture and
>> +shrink or enlarge it to an image of arbitrary size. Next, the devices can
>> +insert the image into larger one. Some video output devices can crop part of an
>> +input image, scale it up or down and insert it at an arbitrary scan line and
>> +horizontal offset into a video signal. We call these abilities cropping,
>> +scaling and composing.</para>
>> +
>> +<para>On a video<emphasis>capture</emphasis>  device the source is a video
>> +signal, and the cropping target determine the area actually sampled. The sink
>> +is an image stored in a memory buffer.  The composing area specify which part
> s/specify/specifies/
>
>> +of the buffer is actually written by the hardware.</para>
> s/written/written to/
>
>> +<para>On a video<emphasis>output</emphasis>  device the source is an image in a
>> +memory buffer, and the cropping target is a part of an image to shown on a
> s/shown/show/ or s/shown/be shown/
>
>> +display. The sink is the display or the graphics screen. The application may
>> +select the part of display where the image should be displayed. The size and
>> +position of such a window is controlled by compose target.</para>
> s/compose target/the compose target/
>
>> +<para>Rectangles for all cropping and composing targets are defined even if the
>> +device does not support neither cropping nor composing. Their size and position
> s/does not support/supports/ or s/neither cropping nor/cropping or/
>
>> +will be fixed in such a case. If the device does not support scaling then the
>> +cropping and composing rectangles have the same size.</para>
>> +
>> +<section>
>> +<title>Selection targets</title>
>> +
>> +<figure id="sel-targets-capture">
>> +	<title>Cropping and composing targets</title>
>> +	<mediaobject>
>> +	<imageobject>
>> +	<imagedata fileref="selection.png" format="PNG" />
>> +	</imageobject>
>> +	<textobject>
>> +	<phrase>Targets used by a cropping, composing and scaling
>> +            process</phrase>
>> +	</textobject>
>> +	</mediaobject>
>> +</figure>
>> +</section>
>> +
>> +<section>
>> +
>> +<title>Configuration</title>
>> +
>> +<para>Applications can use the<link linkend="vidioc-g-selection">selection
>> +API</link>  to select an area in a video signal or a buffer, and to query for
>> +default settings and hardware limits.</para>
>> +
>> +<para>Video hardware can have various cropping, composing and scaling
>> +limitations. It may only scale up or down, support only discrete scaling
>> +factors, or have different scaling abilities in horizontal and vertical
>> +direction. Also it may not support scaling at all. At the same time the
> s/horizontal and vertical direction/the horizontal and vertical directions/
>
>> +cropping/composing rectangles may have to be aligned, and both the source and
>> +the sink may have arbitrary upper and lower size limits. Therefore, as usual,
>> +drivers are expected to adjust the requested parameters and return the actual
>> +values selected. An application can control the rounding behaviour using<link
>> +linkend="v4l2-sel-flags">  constraint flags</link>.</para>
>> +
>> +<section>
>> +
>> +<title>Configuration of video capture</title>
>> +
>> +<para>See the figure<xref linkend="sel-targets-capture" />  for examples of the
> s/the figure/figure/
>
>> +selection targets available for a video capture device. The targets should be
>> +configured according to the pipeline configuration rules for a capture device.
> Do we have such rules written somewhere ?
The pipeline configuration rules are not a part of V4L2 doc yet. It was 
discussed at IRC meeting.
Do you think that the RFC should be posted in separate patch to V4L2 doc?
>> +It means that the cropping targets must be configured in prior to the composing
>> +targets.</para>
>> +
>> +<para>The range of coordinates of the top left corner, width and height of a
>> +area which can be sampled is given by the<constant>  V4L2_SEL_CROP_BOUNDS
> s/a area which/areas that/
>
>> +</constant>  target. To support a wide range of hardware this specification does
>> +not define an origin or units.</para>
>> +
>> +<para>The top left corner, width and height of the source rectangle, that is
>> +the area actually sampled, is given by<constant>  V4L2_SEL_CROP_ACTIVE
> s/by/by the/
>
>> +</constant>  target. It uses the same coordinate system as<constant>
>> +V4L2_SEL_CROP_BOUNDS</constant>. The active cropping area must lie completely
>> +inside the capture boundaries. The driver may further adjust the requested size
>> +and/or position according to hardware limitations.</para>
>> +
>> +<para>Each capture device has a default source rectangle, given by the
>> +<constant>  V4L2_SEL_CROP_DEFAULT</constant>  target. The center of this
>> +rectangle shall align with the center of the active picture area of the video
>> +signal, and cover what the driver writer considers the complete picture.
>> +Drivers shall reset the crop rectangle to the default when the driver is first
> s/reset the crop rectangle/set the active crop rectangle/
>
>> +loaded, but not later.</para>
>> +
>> +<para>The composing targets refer to a memory buffer. The limits of composing
>> +coordinates are obtained using<constant>  V4L2_SEL_COMPOSE_BOUNDS</constant>.
>> +All coordinates are expressed in pixels. The top/left corner is always point
>> +<constant>  {0,0}</constant>. The width and height is equal to the image size
>> +specified using<constant>  VIDIOC_S_FMT</constant>.</para>
> We support sub-pixel cropping, but not sub-pixel composition. Can you remind me
> of the rationale for that ?
Do you mean that OMAP3 ISP supports cropping with sub-pixel resolution?
I thought that pixels are natural units for images stored in memory buffers.
But I would not be surprised if there was some weird fractal-like format
providing images with infinite resolution. Do you think that the sentence
"All coordinates are expressed in pixel" should be dropped from spec?
>> +<para>The part of a buffer into which the image is inserted by the hardware is
>> +controlled by<constant>  V4L2_SEL_COMPOSE_ACTIVE</constant>  target.  The
> s/by/by the/
>
>> +rectangle's coordinates are also expressed in pixels. The composing rectangle
>> +must lie completely inside bounds rectangle. The driver must adjust the
>> +composing rectangle to fit to the bounding limits. Moreover, the driver can
>> +perform other adjustments according to hardware limitations. The application
>> +can control rounding behaviour using<link linkend="v4l2-sel-flags">  constraint
>> +flags</link>.</para>
>> +
>> +<para>For capture devices the default composing rectangle is queried using
>> +<constant>  V4L2_SEL_COMPOSE_DEFAULT</constant>  and it is always equal to
>> +bounding rectangle.</para>
> If they're always equal, why do we have two different targets ? :-) Maybe "is
> usually identical to" or "is most of the time identical to" would be better ?
Good question. I remember that once Hans has said that there should be
no margins in an image if no selection ioctl was used. Therefore I decided
that default and bounds rectangles should be equal for video capture.
I am interested what is Hans' opinion about proposal of softening this 
requirement.
>> +<para>The part of a buffer that is modified by the hardware is given by
>> +<constant>  V4L2_SEL_COMPOSE_PADDED</constant>. It contains all pixels defined
>> +using<constant>  V4L2_SEL_COMPOSE_ACTIVE</constant>  plus all padding data
>> +modified by hardware during insertion process. All pixel outside this rectangle
> s/All pixel/All pixels/
>
>> +<emphasis>must not</emphasis>  be changed by the hardware. The content of pixels
>> +that lie inside the padded area but outside active area is undefined. The
>> +application can use the padded and active rectangles to detect where the
>> +rubbish pixels are located and remove them if needed.</para>
> How would an application remove them ?
The application may use memset if it recognizes fourcc. The idea of 
padding target was to
provide information about artifacts introduced the hardware. If the 
image is decoded directly
to framebuffer then the application could remove artifacts. We could 
introduce some V4L2
control to inform if the padding are is filled with zeros to avoid 
redundant memset.
What do you think?
>> +
>> +</section>
>> +
>> +<section>
>> +
>> +<title>Configuration of video output</title>
>> +
>> +<para>For output devices targets and ioctls are used accordingly to the video
> s/accordingly/similarly/
>
>> +capture case. The<emphasis>composing</emphasis>  rectangle refer to insertion
> s/refer/refers/ or s/rectangle/rectangles/
>
> s/insertion/the insertion/
>
>> +of an image into a video signal. The cropping rectangles refer to a memory
>> +buffer. The targets are should be configured according to the pipeline
> s/are//
>
>> +configuration rules for a output device. It means that the compose targets must
> s/a output/an output/
>
>> +be configured in prior to cropping targets.</para>
> s/in prior to/before the/
>
>> +
>> +<para>The cropping targets refer to the memory buffer which contains an image
> s/which/that/
>
>> +to be inserted into video signal or graphical screen. The limits of cropping
> s/into/into a/
>
>> +coordinates are obtained using<constant>  V4L2_SEL_CROP_BOUNDS</constant>. All
>> +coordinates are expressed in pixels. The top/left corner is always point
>> +<constant>  {0,0}</constant>. The width and height is equal to the image size
>> +specified using<constant>  VIDIOC_S_FMT</constant>  ioctl.</para>
>> +
>> +<para>The top left corner, width and height of the source rectangle, that is
>> +the area from which pixels are processed by the hardware. The target identifier
>> +is<constant>  V4L2_SEL_CROP_ACTIVE</constant>. Its coordinates are expressed
> s/. The target identifier is/, is given by/
>
>> +in pixels.  The active cropping area must lie completely inside the crop
>> +boundaries and the driver may further adjust the requested size and/or position
>> +according to hardware limitations.</para>
>> +
>> +<para>For output devices the default cropping rectangle is queried using
>> +<constant>  V4L2_SEL_CROP_DEFAULT</constant>  and it is always equal to cropping
>> +bounding rectangle.</para>
> Same, comment maybe "is usually identical to the" or "is most of the time
> identical to the" would be better ?
[as above]
>> +
>> +<para>The part of a video signal or graphics display where the image is
>> +inserted by the hardware is controlled by<constant>  V4L2_SEL_COMPOSE_ACTIVE
> s/by/by the/
>
>> +</constant>  target.  The rectangle's coordinates are expressed driver dependant
> s/expressed/expressed in/
>
>> +units. The only exception are digital outputs where the units are pixels.  The
>> +composing rectangle must lie completely inside bounds rectangle.  The driver
> s/bounds rectangle/the bounds rectangle/
>
>> +must adjust the area to fit to the bounding limits. Moreover, the driver can
>> +perform other adjustments according to hardware limitations.</para>
>> +
>> +<para>The device has a default composing rectangle, given by the<constant>
>> +V4L2_SEL_COMPOSE_DEFAULT</constant>  target. The center of this rectangle shall
>> +align with the center of the active picture area of the video signal, and cover
>> +what the driver writer considers the complete picture.  Drivers shall reset the
> s/reset/set/
>
>> +composing rectangle to the default one when the driver is first loaded.</para>
>> +
>> +<para>The devices may introduce additional content to video signal other then
> s/then/than/
>
>> +an image from memory buffers.  It includes borders around an image. However,
>> +such a padding area is very driver-dependant issue. Driver developers are
> s/ issue// (?)
>
>> +encouraged to keep padding rectangle equal to active one. The padding target
>> +is accessed by<constant>  V4L2_SEL_COMPOSE_PADDED</constant>  identifier.  It
> s/by/by the/
>
>> +must contain all pixels from<constant>  V4L2_SEL_COMPOSE_ACTIVE</constant>
> s/from/from the/
>
>> +target.</para>
>> +
>> +</section>
>> +
>> +<section>
>> +
>> +<title>Scaling control.</title>
>> +
>> +<para>An application can detect if scaling is performed by comparing width and
> s/width/the width/
>
>> +height of rectangles obtained using<constant>  V4L2_SEL_CROP_ACTIVE</constant>
>> +and<constant>  V4L2_SEL_COMPOSE_ACTIVE</constant>  targets. If these are not
>> +equal then the scaling is applied. The application can compute scaling ratios
> s/the scaling/scaling/
>
>> +using these values.</para>
>> +
>> +</section>
>> +
>> +</section>
>> +
>> +<section>
>> +<title>Examples</title>
>> +<example>
>> +	<title>Resetting the cropping parameters</title>
>> +
>> +	<para>(A video capture device is assumed; change<constant>
>> +V4L2_BUF_TYPE_VIDEO_CAPTURE</constant>  for other devices; change target to
>> +<constant>  V4L2_SEL_COMPOSE_*</constant>  family to configure composing
>> +area)</para>
>> +
>> +	<programlisting>
>> +
>> +	&v4l2-selection; sel = {
>> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
>> +		.target = V4L2_SEL_CROP_DEFAULT,
>> +	};
>> +	ret = ioctl(fd,&VIDIOC-G-SELECTION;,&amp;sel);
>> +	if (ret)
>> +		exit(-1);
>> +	sel.target = V4L2_SEL_CROP_ACTIVE;
>> +	ret = ioctl(fd,&VIDIOC-S-SELECTION;,&amp;sel);
>> +	if (ret)
>> +		exit(-1);
>> +
>> +</programlisting>
>> +</example>
>> +
>> +<example>
>> +	<title>Simple downscaling</title>
>> +	<para>Setting a composing area on output of size of<emphasis>  at most
>> +</emphasis>  half of limit placed at a center of a display.</para>
>> +	<programlisting>
>> +
>> +	&v4l2-selection; sel = {
>> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
>> +		.target = V4L2_SEL_COMPOSE_BOUNDS,
>> +	};
>> +	struct v4l2_rect r;
>> +
>> +	ret = ioctl(fd,&VIDIOC-G-SELECTION;,&amp;sel);
>> +	if (ret)
>> +		exit(-1);
>> +	/* setting smaller compose rectangle */
>> +	r.width = sel.r.width / 2;
>> +	r.height = sel.r.height / 2;
>> +	r.left = sel.r.width / 4;
>> +	r.top = sel.r.height / 4;
>> +	sel.r = r;
>> +	sel.target = V4L2_SEL_COMPOSE_ACTIVE;
>> +	sel.flags = V4L2_SEL_SIZE_LE;
>> +	ret = ioctl(fd,&VIDIOC-S-SELECTION;,&amp;sel);
>> +	if (ret)
>> +		exit(-1);
>> +
>> +</programlisting>
>> +</example>
>> +
>> +<example>
>> +	<title>Querying for scaling factors</title>
>> +	<para>A video output device is assumed; change<constant>
>> +V4L2_BUF_TYPE_VIDEO_OUTPUT</constant>  for other devices</para>
>> +	<programlisting>
>> +
>> +	&v4l2-selection; compose = {
>> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
>> +		.target = V4L2_SEL_COMPOSE_ACTIVE,
>> +	};
>> +	&v4l2-selection; crop = {
>> +		.type = V4L2_BUF_TYPE_VIDEO_OUTPUT,
>> +		.target = V4L2_SEL_CROP_ACTIVE,
>> +	};
>> +	double hscale, vscale;
>> +
>> +	ret = ioctl(fd,&VIDIOC-G-SELECTION;,&amp;compose);
>> +	if (ret)
>> +		exit(-1);
>> +	ret = ioctl(fd,&VIDIOC-G-SELECTION;,&amp;crop);
>> +	if (ret)
>> +		exit(-1);
>> +
>> +	/* computing scaling factors */
>> +	hscale = (double)compose.r.width / crop.r.width;
>> +	vscale = (double)compose.r.height / crop.r.height;
>> +
>> +	</programlisting>
>> +</example>
>> +
>> +</section>
>> +
>> +</section>
>> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml
>> b/Documentation/DocBook/media/v4l/v4l2.xml index 0d05e87..54333a5 100644
>> --- a/Documentation/DocBook/media/v4l/v4l2.xml
>> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
>> @@ -493,6 +493,7 @@ and discussions on the V4L mailing list.</revremark>
>>       &sub-g-output;
>>       &sub-g-parm;
>>       &sub-g-priority;
>> +&sub-g-selection;
>>       &sub-g-sliced-vbi-cap;
>>       &sub-g-std;
>>       &sub-g-tuner;
>> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
>> b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml new file mode
>> 100644
>> index 0000000..6d93832
>> --- /dev/null
>> +++ b/Documentation/DocBook/media/v4l/vidioc-g-selection.xml
>> @@ -0,0 +1,281 @@
>> +<refentry id="vidioc-g-selection">
>> +<refmeta>
>> +<refentrytitle>ioctl VIDIOC_G_SELECTION, VIDIOC_S_SELECTION</refentrytitle>
>> +&manvol;
>> +</refmeta>
>> +
>> +<refnamediv>
>> +<refname>VIDIOC_G_SELECTION</refname>
>> +<refname>VIDIOC_S_SELECTION</refname>
>> +<refpurpose>Get or set one of the current selection rectangles</refpurpose>
> s/current // (?)
>
>> +</refnamediv>
>> +
>> +<refsynopsisdiv>
>> +<funcsynopsis>
>> +<funcprototype>
>> +	<funcdef>int<function>ioctl</function></funcdef>
>> +	<paramdef>int<parameter>fd</parameter></paramdef>
>> +	<paramdef>int<parameter>request</parameter></paramdef>
>> +	<paramdef>struct v4l2_selection *<parameter>argp</parameter></paramdef>
>> +</funcprototype>
>> +</funcsynopsis>
>> +</refsynopsisdiv>
>> +
>> +<refsect1>
>> +<title>Arguments</title>
>> +
>> +<variablelist>
>> +<varlistentry>
>> +	<term><parameter>fd</parameter></term>
>> +	<listitem>
>> +	<para>&fd;</para>
>> +	</listitem>
>> +</varlistentry>
>> +<varlistentry>
>> +	<term><parameter>request</parameter></term>
>> +	<listitem>
>> +	<para>VIDIOC_G_SELECTION, VIDIOC_S_SELECTION</para>
>> +	</listitem>
>> +</varlistentry>
>> +<varlistentry>
>> +	<term><parameter>argp</parameter></term>
>> +	<listitem>
>> +	<para></para>
>> +	</listitem>
>> +</varlistentry>
>> +</variablelist>
>> +</refsect1>
>> +
>> +<refsect1>
>> +<title>Description</title>
>> +<para>The ioctls are used to query and configure selection rectangles.</para>
>> +
>> +<para>  To query the cropping (composing) rectangle set<structfield>
>> +v4l2_selection::type</structfield>  to the respective buffer type.  Then set
>> +<structfield>  v4l2_selection::target</structfield>  to value<constant>
>> +V4L2_SEL_CROP_ACTIVE</constant>  (<constant>  V4L2_SEL_COMPOSE_ACTIVE
>> +</constant>).  Please refer to table<xref linkend="v4l2-sel-target" />  or
>> +<xref linkend="selection-api" />  for additional targets.  Fields<structfield>
>> +v4l2_selection::flags</structfield>  and<structfield>  v4l2_selection::reserved
>> +</structfield>  are ignored and they must be filled with zeros.  The driver
>> +fills the rest of structure or returns&EINVAL; if incorrect buffer type or
> s/rest of/rest of the/
> s/incorrect/an incorrect/
>
>> +target was used. If cropping (composing) is not supported then the active
>> +rectangle is not mutable and it is always equal to bounds rectangle. Finally,
> s/to bounds/to the bounds/
>
>> +structure<structfield>  v4l2-selection::r</structfield>  is filled with current
> s/with current/with the current/
>
>> +cropping (composing) coordinates. The coordinates are expressed in
>> +driver-dependant units. The only exception are rectangles for images in raw
> s/dependant/dependent/
>
>> +formats, which coordinates are always expressed in pixels.</para>
> s/which/whose/
>
>> +
>> +<para>  To change the cropping (composing) rectangle set<structfield>
>> +v4l2_selection::type</structfield>  to the respective buffer type.  Then set
>> +<structfield>  v4l2_selection::target</structfield>  to value<constant>
>> +V4L2_SEL_CROP_ACTIVE</constant>  (<constant>  V4L2_SEL_COMPOSE_ACTIVE
>> +</constant>). Please refer to table<xref linkend="v4l2-sel-target" />  or<xref
>> +linkend="selection-api" />  for additional targets.  Set desired active area
>> +into the field<structfield>  v4l2_selection::r</structfield>.  Field
>> +<structfield>  v4l2_selection::reserved</structfield>  is ignored and they must
> s/they must/must/
>
>> +be filled with zeros.  The driver may adjust the rectangle coordinates. An
>> +application may introduce constraints to control rounding behaviour. Set the
>> +field<structfield>  v4l2_selection::flags</structfield>  to one of values:
>> +
>> +<itemizedlist>
>> +<listitem>
>> +<para><constant>0</constant>  - driver is free to adjust size, it is recommended
>> +to choose the crop/compose rectangle as close as possible to the original
>> +one</para>
> The driver can adjust the rectangle size freely and shall choose a crop/compose
> rectangle as close as possible to the requested one.
>
>> +</listitem>
>> +<listitem>
>> +<para><constant>SEL_SIZE_GE</constant>  - driver is not allowed to shrink the
>> +rectangle.  The original rectangle must lay inside the adjusted one</para>
>> +</listitem>
>> +<listitem>
>> +<para><constant>SEL_SIZE_LE</constant>  - drive is not allowed to grow the
> s/drive/driver/
> s/grow/enlarge/
>
>> +rectangle.  The adjusted rectangle must lay inside the original one</para>
>> +</listitem>
>> +<listitem>
>> +<para><constant>SEL_SIZE_GE | SEL_SIZE_LE</constant>  - choose size exactly the
>> +same as in desired rectangle.</para>
>> +</listitem>
>> +</itemizedlist>
>> +
>> +Please refer to<xref linkend="sel-const-adjust" />.
>> +
>> +</para>
>> +
>> +<para>  The driver may have to adjusts the requested dimensions against hardware
>> +limits and other parts as the pipeline, i.e. the bounds given by the
>> +capture/output window or TV display.  If constraints flags have to be violated
>> +at any stage then ERANGE is returned.
> You know that I still think that hints should be hints, and that ERANGE should
> not be returned, right ? :-)
Yes.. :). There are pros and cons for hints, too.
(+) hint can be ignored therefore is easier to implement them in drivers.
It may speed up adoption of the selection api.
(-) It is not possible to prevent hardware from applying the configuration
that is not acceptable by the application. Such an unfortunate operation
could mess up the whole pipeline.

I found two ways  to solve the cons. The new ioctl TRY_SELECTION
should be introduced now or in the future version of selection api.
Second, the pipeline configuration rules may help in this case. An 
application should
configure pipeline according to the rules. The setup of stages before 
the current stage
is guaranteed to not modified. Therefore the unfortunate selection call 
could only
mess up the stages lower in the pipeline.

The constraints idea was OK, until I found that the content of ioctl 
parameters is
not copied to the userspace when the ioctl fails. Therefore the application
receives no feedback other than ERANGE. Moreover I found out that is not
easy to calculate the best-hit rectangle that could be returned. A lot 
of code
must be added to driver to support it.

There is still one more problem with the hints. Examine following scenario.
One tries to setup 20x20 rectangle using SEL_SIZE_LE hint. The ioctl 
succeeds
but the driver returns 32x32. Does it mean?

(A) it is not possible to set a rectangle smaller than 20x20
(B) it is not possible to set a rectangle smaller than 32x32
(C) driver failed to configuration consistent with 20x20 (or smaller) 
rectangle.
       It is not known if such a configuration exists.
       Should the application continue the negotiations?
       Size 16x16 might be good, if the driver did not implement hint 
[ignored them]
       and rounded 20x20 to 32x32.

The solution using constraints was consistent. The ERANGE is returned and
case (A) is valid. If constraints were transformed to hints then we 
should allow to
violate hints only if there is no configuration that satisfy the hints.

What is your opinion about it?

Best regards,
Tomasz Stanislawski

>> The closest possible values of horizontal
>> +and vertical offset and sizes are chosen according to following priority:
>> +
>> +<orderedlist>
>> +<listitem>
>> +<para>Satisfy constraints from<structfield>v4l2_selection::flags</structfield>.</para>
>> +</listitem>
>> +<listitem>
>> +<para>Adjust width, height, left, and top to hardware limits and alignments.</para>
>> +</listitem>
>> +<listitem>
>> +<para>Keep center of adjusted rectangle as close as possible to the original one.</para>
>> +</listitem>
>> +<listitem>
>> +<para>Keep width and height as close as possible to original ones.</para>
>> +</listitem>
>> +<listitem>
>> +<para>Keep horizontal and vertical offset as close as possible to original ones.</para>
>> +</listitem>
>> +</orderedlist>
>> +
>> +On success field<structfield>  v4l2_selection::r</structfield>  contains
> s/field/the field/
>
>> +adjusted rectangle. When the parameters are unsuitable the application may
> s/adjusted/the adjusted/
>
>> +modify the cropping (composing) or image parameters and repeat the cycle until
>> +satisfactory parameters have been negotiated.</para>
>> +
>> +</refsect1>
>> +
>> +<refsect1>
>> +<table frame="none" pgwide="1" id="v4l2-sel-target">
>> +<title>Selection targets.</title>
>> +<tgroup cols="3">
>> +	&cs-def;
>> +	<tbody valign="top">
>> +	<row>
>> +<entry><constant>V4L2_SEL_CROP_ACTIVE</constant></entry>
>> +<entry>0</entry>
>> +<entry>area that is currently cropped by hardware</entry>
>> +	</row>
>> +	<row>
>> +<entry><constant>V4L2_SEL_CROP_DEFAULT</constant></entry>
>> +<entry>1</entry>
>> +<entry>suggested cropping rectangle that covers the "whole picture"</entry>
>> +	</row>
>> +	<row>
>> +<entry><constant>V4L2_SEL_CROP_BOUNDS</constant></entry>
>> +<entry>2</entry>
>> +<entry>limits for the cropping rectangle</entry>
>> +	</row>
>> +	<row>
>> +<entry><constant>V4L2_SEL_COMPOSE_ACTIVE</constant></entry>
>> +<entry>256</entry>
>> +<entry>area to which data are composed by hardware</entry>
>> +	</row>
>> +	<row>
>> +<entry><constant>V4L2_SEL_COMPOSE_DEFAULT</constant></entry>
>> +<entry>257</entry>
>> +<entry>suggested composing rectangle that covers the "whole picture"</entry>
>> +	</row>
>> +	<row>
>> +<entry><constant>V4L2_SEL_COMPOSE_BOUNDS</constant></entry>
>> +<entry>258</entry>
>> +<entry>limits for the composing rectangle</entry>
>> +	</row>
>> +	<row>
>> +<entry><constant>V4L2_SEL_COMPOSE_PADDED</constant></entry>
>> +<entry>259</entry>
>> +<entry>the active area and all padding pixels that are inserted or modified by the hardware</entry>
>> +	</row>
>> +	</tbody>
>> +</tgroup>
>> +</table>
>> +</refsect1>
>> +
>> +<refsect1>
>> +<table frame="none" pgwide="1" id="v4l2-sel-flags">
>> +<title>Selection constraint flags</title>
>> +<tgroup cols="3">
>> +	&cs-def;
>> +	<tbody valign="top">
>> +	<row>
>> +<entry><constant>V4L2_SEL_SIZE_GE</constant></entry>
>> +<entry>0x00000001</entry>
>> +<entry>indicate that adjusted rectangle must contain a rectangle from<structfield>v4l2_selection::r</structfield></entry>
>> +	</row>
>> +	<row>
>> +<entry><constant>V4L2_SEL_SIZE_LE</constant></entry>
>> +<entry>0x00000002</entry>
>> +<entry>indicate that adjusted rectangle must be inside a rectangle from<structfield>v4l2_selection::r</structfield></entry>
>> +	</row>
>> +	</tbody>
>> +</tgroup>
>> +</table>
>> +</refsect1>
>> +
>> +<section>
>> +<figure id="sel-const-adjust">
>> +	<title>Size adjustments with constraint flags.</title>
>> +	<mediaobject>
>> +	<imageobject>
>> +	<imagedata fileref="constraints.png" format="PNG" />
>> +	</imageobject>
>> +	<textobject>
>> +	<phrase>Behaviour of rectangle adjustment for different constraint
>> +            flags.</phrase>
>> +	</textobject>
>> +	</mediaobject>
>> +</figure>
>> +</section>
>> +
>> +<refsect1>
>> +<table pgwide="1" frame="none" id="v4l2-selection">
>> +<title>struct<structname>v4l2_selection</structname></title>
>> +<tgroup cols="3">
>> +	&cs-str;
>> +	<tbody valign="top">
>> +	<row>
>> +	<entry>__u32</entry>
>> +	<entry><structfield>type</structfield></entry>
>> +	<entry>Type of the buffer (from&v4l2-buf-type;)</entry>
>> +	</row>
>> +	<row>
>> +	<entry>__u32</entry>
>> +	<entry><structfield>target</structfield></entry>
>> +<entry>used to select between cropping and composing rectangles</entry>
>> +	</row>
>> +	<row>
>> +	<entry>__u32</entry>
>> +	<entry><structfield>flags</structfield></entry>
>> +<entry>control over coordinates adjustments, refer to<link linkend="v4l2-sel-flags">selection flags</link></entry>
>> +	</row>
>> +	<row>
>> +	<entry>&v4l2-rect;</entry>
>> +	<entry><structfield>r</structfield></entry>
>> +	<entry>selection rectangle</entry>
>> +	</row>
>> +	<row>
>> +	<entry>__u32</entry>
>> +	<entry><structfield>reserved[9]</structfield></entry>
>> +	<entry>Reserved fields for future use, adjust size to 64 bytes</entry>
>> +	</row>
>> +	</tbody>
>> +</tgroup>
>> +</table>
>> +</refsect1>
>> +
>> +<refsect1>
>> +&return-value;
>> +<variablelist>
>> +<varlistentry>
>> +	<term><errorcode>EINVAL</errorcode></term>
>> +	<listitem>
>> +	<para>The buffer<structfield>type</structfield>  or<structfield>target</structfield>
>> +is not supported, or the<structfield>flags</structfield>  is invalid.</para>
> s/is invalid/are invalid/
>
>> +	</listitem>
>> +</varlistentry>
>> +<varlistentry>
>> +	<term><errorcode>ERANGE</errorcode></term>
>> +	<listitem>
>> +	<para>it is not possible to adjust a selection rectangle<structfield>r</structfield>
>> +that satisfy all contraints from<structfield>flags</structfield>.</para>
> s/satisfy/satisfies/
>
>> +	</listitem>
>> +</varlistentry>
>> +<varlistentry>
>> +	<term><errorcode>EBUSY</errorcode></term>
>> +	<listitem>
>> +	<para>it is not possible to apply change of selection rectangle at the moment.
>> +Usually because streaming is in progress.</para>
>> +	</listitem>
>> +</varlistentry>
>> +</variablelist>
>> +</refsect1>
>> +
>> +</refentry>

