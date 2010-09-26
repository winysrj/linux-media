Return-path: <mchehab@pedra>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2253 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0IZSZd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Sep 2010 14:25:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFC/PATCH 7/9] v4l: v4l2_subdev userspace format API
Date: Sun, 26 Sep 2010 20:25:20 +0200
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com, g.liakhovetski@gmx.de
References: <1285517612-20230-1-git-send-email-laurent.pinchart@ideasonboard.com> <1285517612-20230-8-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1285517612-20230-8-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009262025.20852.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, September 26, 2010 18:13:30 Laurent Pinchart wrote:
> Add a userspace API to get, set and enumerate the media format on a
> subdev pad.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> Signed-off-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

<snip>

> diff --git a/Documentation/DocBook/v4l/dev-subdev.xml b/Documentation/DocBook/v4l/dev-subdev.xml
> new file mode 100644
> index 0000000..9a691f7
> --- /dev/null
> +++ b/Documentation/DocBook/v4l/dev-subdev.xml
> @@ -0,0 +1,267 @@
> +  <title>Sub-device Interface</title>
> +
> +  <para>The complex nature of V4L2 devices, where hardware is often made of
> +  several integrated circuits that need to interact with each other in a
> +  controlled way, leads to complex V4L2 drivers. The drivers usually reflect
> +  the hardware model in software, and model the different hardware components
> +  as software blocks called sub-devices.</para>
> +
> +  <para>V4L2 sub-devices are usually kernel-only objects. If the V4L2 driver
> +  implements the media device API, they will automatically inherit from media
> +  entities. Applications will be able to enumerate the sub-devices and discover
> +  the hardware topology using the media entities, pads and links enumeration
> +  API.</para>
> +
> +  <para>In addition to make sub-devices discoverable, drivers can also choose
> +  to make them directly configurable by applications. When both the sub-device
> +  driver and the V4L2 device driver support this, sub-devices will feature a
> +  character device node on which ioctls can be called to
> +  <itemizedlist>
> +    <listitem>query, read and write sub-devices controls</listitem>
> +    <listitem>subscribe and unsubscribe to events and retrieve them</listitem>
> +    <listitem>negotiate image formats on individual pads</listitem>
> +  </itemizedlist>
> +  </para>
> +
> +  <para>Sub-device character device nodes, conventionally named
> +  <filename>/dev/v4l-subdev0</filename> to
> +  <filename>/dev/v4l-subdev63</filename>, use major number 81 and minor numbers
> +  between 128 and 191.</para>

Not true. Minor numbers will be assigned on first available basis. Unless the
config option to select fixed minors is selected. I wouldn't document minors here.
It's not the sort of thing anyone will use these days.

> +
> +  <section>
> +    <title>Controls</title>
> +    <para>Most V4L2 controls are implemented by sub-device hardware. Drivers
> +    usually merge all controls and expose them through video device nodes.
> +    Applications can control all sub-devices through a single interface.</para>
> +
> +    <para>Complex devices sometimes implement the same control in different
> +    pieces of hardware. This situation is common in embedded platforms, where
> +    both sensors and image processing hardware implement identical functions,
> +    such as contrast adjustment, white balance or faulty pixels correction. As
> +    the V4L2 controls API doesn't support several identical controls in a single
> +    device, all but one of the identical controls are hidden.</para>
> +
> +    <para>Applications can access those hidden controls through the sub-device
> +    node with the V4L2 control API described in <xref linkend="control" />. The
> +    ioctls behave identically as when issued on V4L2 device nodes, with the
> +    exception that they deal only with controls implemented in the sub-device.
> +    </para>
> +
> +    <para>Depending on the driver, those controls are also exposed through one

s/are also exposed/might also be exposed/

> +    (or several) V4L2 device nodes.</para>
> +  </section>
> +
> +  <section>
> +    <title>Events</title>
> +    <para>V4L2 sub-devices can notify applications of events as described in
> +    <xref linkend="event" />. The API behaves identically as when used on V4L2
> +    device nodes, with the exception that it only deals with events generated by
> +    the sub-device. Depending on the driver, those events can also be reported

s/can/might/

> +    on one (or several) V4L2 device nodes.</para>
> +  </section>
> +
> +  <section id="pad-level-formats">
> +    <title>Pad-level formats</title>
> +
> +    <note>For the purpose of this section, the term
> +    <wordasword>format</wordasword> means the combination of media bus data
> +    format, frame width and frame height.</note>
> +
> +    <para>Image formats are typically negotiated on video capture and output
> +    devices using the <link linkend="crop">cropping and scaling</link> ioctls.
> +    The driver is responsible for configuring every block in the video pipeline
> +    according to the requested format at the pipeline input and/or
> +    output.</para>
> +
> +    <para>For complex devices, such as often found in embedded systems,
> +    identical image sizes at the output of a pipeline can be achieved using
> +    different hardware configurations. One such exemple is shown on
> +    <xref linkend="pipeline-scaling" xrefstyle="template: Figure %n" />, where
> +    image scaling can be performed on both the video sensor and the host image
> +    processing hardware.</para>

I think that it should be made very, very clear that this section is only applicable
to very complex devices and that it is not meant for generic V4L2 applications.

> +
> +    <figure id="pipeline-scaling">
> +      <title>Image format negotation on pipelines</title>
> +      <mediaobject>
> +	<imageobject>
> +	  <imagedata fileref="pipeline.pdf" format="PS" />
> +	</imageobject>
> +	<imageobject>
> +	  <imagedata fileref="pipeline.png" format="PNG" />
> +	</imageobject>
> +	<textobject>
> +	  <phrase>High quality and high speed pipeline configuration</phrase>
> +	</textobject>
> +      </mediaobject>
> +    </figure>
> +
> +    <para>The sensor scaller is usually of less quality than the host scaler,

scaller -> scaler

> +    but scaling on the sensor is required to achieve higher frame rates.
> +    Depending on the use case (quality vs. speed), the pipeline must be
> +    configured differently. Applications need to configure the formats at every
> +    point in the pipeline explictly.</para>

explictly -> explicitly

> +
> +    <para>Drivers that implement the <link linkend="media-controller-intro">media
> +    API</link> can expose pad-level image format configuration to applications.
> +    When they do, applications can use the &VIDIOC-SUBDEV-G-FMT; and
> +    &VIDIOC-SUBDEV-S-FMT; ioctls. to negotiate formats on a per-pad basis.</para>

What has the Media API to do with this, other than that it is needed to discover the
subdev device nodes?

> +    <para>Applications are responsible for configuring coherent parameters on
> +    the whole pipeline and making sure that connected pads have compatible
> +    formats. The pipeline is checked for formats mismatch at &VIDIOC-STREAMON;
> +    time, and an &EPIPE; is then returned if the configuration is
> +    invalid.</para>
> +
> +    <section>
> +      <title>Format negotiation</title>
> +
> +      <para>Acceptable formats on pads can (and usually do) depend on a number
> +      of external parameters, such as formats on other pads, active links, or
> +      even controls. Finding a combination of formats on all pads in a video
> +      pipeline, acceptable to both application and driver, can't rely on formats
> +      enumeration only. A format negotiation mechanism is required.</para>
> +
> +      <para>Central to the format negotiation mechanism are the get/set format
> +      operations. When called with the <structfield>which</structfield> argument
> +      set to <constant>V4L2_SUBDEV_FORMAT_PROBE</constant>, the
> +      &VIDIOC-SUBDEV-G-FMT; and &VIDIOC-SUBDEV-S-FMT; ioctls operate on a set of
> +      formats parameters that are not connected to the hardware configuration.
> +      Modifying those probe formats leaves the device state untouched (this
> +      applies to both the software state stored in the driver and the hardware
> +      state stored in the device itself).</para>
> +
> +      <para>While not kept as part of the device state, probe formats are stored
> +      in the sub-device file handles. A &VIDIOC-SUBDEV-G-FMT; call will return
> +      the last probe format set <emphasis>on the same sub-device file
> +      handle</emphasis>. Several applications probing the same sub-device at the
> +      same time will thus not interact with each other.</para>
> +
> +      <para>To find out whether a particular format is supported by the device,
> +      applications use the &VIDIOC-SUBDEV-S-FMT; ioctl. Drivers verify and, if
> +      needed, mangle the requested <structfield>format</structfield> based on

I'd use 'change' instead of 'mangle'. It's a less frightening word :-)

> +      device requirements and return the possibly modified value. Applications
> +      can then choose to probe for a different format or accept the returned
> +      value and continue.</para>
> +
> +      <para>Formats returned by the driver during a negotiation iteration are
> +      guaranteed to be supported by the device. In particular, drivers guarantee
> +      that a returned format will not be further mangled if passed to an

Ditto.

> +      &VIDIOC-SUBDEV-S-FMT; call as-is (as long as external parameters, such as
> +      formats on other pads or links' configuration are not changed).</para>
> +
> +      <para>Drivers automatically propagate formats inside sub-devices. When a
> +      probe or active format is set on a pad, corresponding formats on other
> +      pads of the same sub-device can be modified by the driver. Drivers are
> +      free to modify formats as required by the device. However, they should
> +      comply with the following rules when possible.

Change the period at the end to a colon.

> +      <itemizedlist>
> +        <listitem>Formats should be propagated from sink pads to source pads.
> +	Modifying a format on a source pad should not modify the format on any
> +	sink pad.</listitem>
> +        <listitem>Sub-devices that scale frames using variable scaling factors
> +	should reset the scale factors to default values when sink pads formats
> +	are modified. If the 1:1 scaling ratio is supported, this means that
> +	source pads formats should be reset to the sink pads formats.</listitem>
> +      </itemizedlist>
> +      </para>
> +
> +      <para>Formats are not propagated across links, as that would involve
> +      propagating them from one sub-device file handle to another. Applications
> +      must then take care to configure both ends of every link explicitly with
> +      compatible formats. Identical formats on the two ends of a link are
> +      guaranteed to be compatible. Drivers are free to accept different formats
> +      matching device requirements as being compatible.</para>
> +
> +      <para><xref linkend="sample-pipeline-config" xrefstyle="template:Table %n"/>
> +      shows a sample configuration sequence for the pipeline described in
> +      <xref linkend="pipeline-scaling" xrefstyle="template:Figure %n"/> (table
> +      columns list entity names and pad numbers).</para>
> +
> +      <table pgwide="0" frame="none" id="sample-pipeline-config">
> +	<title>Sample pipeline configuration</title>
> +	<tgroup cols="3">
> +	  <colspec colname="what"/>
> +	  <colspec colname="sensor-0" />
> +	  <colspec colname="frontend-0" />
> +	  <colspec colname="frontend-1" />
> +	  <colspec colname="scaler-0" />
> +	  <colspec colname="scaler-1" />
> +	  <thead>
> +	    <row>
> +	      <entry></entry>
> +	      <entry>Sensor/0</entry>
> +	      <entry>Frontend/0</entry>
> +	      <entry>Frontend/1</entry>
> +	      <entry>Scaler/0</entry>
> +	      <entry>Scaler/1</entry>
> +	    </row>
> +	  </thead>
> +	  <tbody valign="top">
> +	    <row>
> +	      <entry>Initial state</entry>
> +	      <entry>2048x1536</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	    </row>
> +	    <row>
> +	      <entry>Configure frontend input</entry>
> +	      <entry>2048x1536</entry>
> +	      <entry><emphasis>2048x1536</emphasis></entry>
> +	      <entry><emphasis>2046x1534</emphasis></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	    </row>
> +	    <row>
> +	      <entry>Configure scaler input</entry>
> +	      <entry>2048x1536</entry>
> +	      <entry>2048x1536</entry>
> +	      <entry>2046x1534</entry>
> +	      <entry><emphasis>2046x1534</emphasis></entry>
> +	      <entry><emphasis>2046x1534</emphasis></entry>
> +	    </row>
> +	    <row>
> +	      <entry>Configure scaler output</entry>
> +	      <entry>2048x1536</entry>
> +	      <entry>2048x1536</entry>
> +	      <entry>2046x1534</entry>
> +	      <entry>2046x1534</entry>
> +	      <entry><emphasis>1280x960</emphasis></entry>
> +	    </row>
> +	  </tbody>
> +	</tgroup>
> +      </table>
> +
> +      <para>
> +      <orderedlist>
> +	<listitem>Initial state. The sensor output is set to its native 3MP
> +	resolution. Resolutions on the host frontend and scaler input and output
> +	pads are undefined.</listitem>
> +	<listitem>The application configures the frontend input pad resolution to
> +	2048x1536. The driver propagates the format to the frontend output pad.
> +	Note that the propagated output format can be different, as in this case,
> +	than the input format, as the hardware might need to crop pixels (for
> +	instance when converting a Bayer filter pattern to RGB or YUV).</listitem>
> +	<listitem>The application configures the scaler input pad resolution to
> +	2046x1534 to match the frontend output resolution. The driver propagates
> +	the format to the scaler output pad.</listitem>
> +	<listitem>The application configures the scaler output pad resolution to
> +	1280x960.</listitem>
> +      </orderedlist>
> +      </para>
> +
> +      <para>When satisfied with the probe results, applications can set the
> +      active formats by setting the <structfield>which</structfield> argument to
> +      <constant>V4L2_SUBDEV_FORMAT_PROBE</constant>. Active formats are mangled
> +      exactly as probe formats by drivers. To avoid modifying the hardware
> +      state during format negotiation, applications should negotiate probe
> +      formats first and then modify the active settings using the probe formats
> +      returned during the last negotiation iteration. This guarantees that the
> +      active format will be applied as-is by the driver without being modified.
> +      </para>
> +    </section>
> +
> +  </section>
> +
> +  &sub-subdev-formats;

<snip>

> diff --git a/Documentation/DocBook/v4l/subdev-formats.xml b/Documentation/DocBook/v4l/subdev-formats.xml
> new file mode 100644
> index 0000000..fb3c8b1
> --- /dev/null
> +++ b/Documentation/DocBook/v4l/subdev-formats.xml
> @@ -0,0 +1,1282 @@
> +<section id="v4l2-mbus-format">
> +  <title>Media bus formats</title>
> +
> +  <table pgwide="1" frame="none" id="v4l2-mbus-framefmt">
> +    <title>struct <structname>v4l2_mbus_framefmt</structname></title>
> +    <tgroup cols="3">
> +      &cs-str;
> +      <tbody valign="top">
> +	<row>
> +	  <entry>__u32</entry>
> +	  <entry><structfield>width</structfield></entry>
> +	  <entry>Image width, in pixels.</entry>
> +	</row>
> +	<row>
> +	  <entry>__u32</entry>
> +	  <entry><structfield>height</structfield></entry>
> +	  <entry>Image height, in pixels.</entry>
> +	</row>
> +	<row>
> +	  <entry>__u32</entry>
> +	  <entry><structfield>code</structfield></entry>
> +	  <entry>Format code, see &v4l2-mbus-pixelcode;. for details.</entry>
> +	</row>
> +	<row>
> +	  <entry>enum v4l2_field</entry>
> +	  <entry><structfield>field</structfield></entry>
> +	  <entry>Field order, see <xref linkend="field-order" /> for details.
> +	  </entry>
> +	</row>
> +	<row>
> +	  <entry>enum v4l2_colorspace</entry>
> +	  <entry><structfield>colorspace</structfield></entry>
> +	  <entry>Image colorspace, see <xref linkend="field-order" /> for details.
> +	  </entry>
> +	</row>
> +      </tbody>
> +    </tgroup>
> +  </table>
> +
> +  <section id="v4l2-mbus-pixelcode">
> +    <title>Pixel codes</title>

I'd rename this 'Media Bus Pixel Codes'

BTW: titles are capitalized in English.

> +    <section>

I'd add an introductory paragraph explaining that these codes determine how the
pixels flow over a physical bus and have nothing to do with how they are stored
in memory. That is determined by the pixelformat in struct v4l2_pix_format.

It's an important but non-intuitive difference.

> +      <title>Packet RGB formats</title>
> +
> +      <para>Those formats transfer pixel data as red, green and blue components.
> +      The format code is made of the following information.
> +      <itemizedlist>
> +	<listitem>The red, green and blue components order code, as encoded in a
> +	pixel sample. Possible values are RGB and BGR.</listitem>
> +	<listitem>The number of bits per component, for each component. The values
> +	can be different for all components. Common values are 555 and 565.
> +	</listitem>
> +	<listitem>The number of bus samples per pixel. Pixels that are wider than
> +	the bus width must be transferred in multiple samples. Common values are
> +	1 and 2.</listitem>
> +	<listitem>The bus width.</listitem>
> +	<listitem>For formats where the total number of bits per pixel is smaller
> +	than the number of bus samples per pixel times the bus width, a padding
> +	value stating if the bytes are padded in their most high order bits
> +	(PADHI) or low order bits (PADLO).</listitem>
> +	<listitem>For formats where the number of bus samples per pixel is larger
> +	than 1, an endianness value stating if the pixel is transferred MSB first
> +	(BE) or LSB first (LE).</listitem>
> +      </itemizedlist>
> +      </para>
> +
> +      <para>For instance, a format where pixels are encoded as 5-bits red, 5-bits
> +      green and 5-bit blue values padded on the high bit, transferred as 2 8-bit
> +      samples per pixel with the most significant bits (padding, red and half of
> +      the green value) transferred first will be named
> +      <constant>V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE</constant>.
> +      </para>
> +
> +      <para>The following tables list existing packet RGB formats.</para>
> +
> +      <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-rgb">
> +	<title>RGB formats</title>
> +	<tgroup cols="11">
> +	  <colspec colname="id" align="left" />
> +	  <colspec colname="code" align="center"/>
> +	  <colspec colname="bit" />
> +	  <colspec colnum="4" colname="b07" align="center" />
> +	  <colspec colnum="5" colname="b06" align="center" />
> +	  <colspec colnum="6" colname="b05" align="center" />
> +	  <colspec colnum="7" colname="b04" align="center" />
> +	  <colspec colnum="8" colname="b03" align="center" />
> +	  <colspec colnum="9" colname="b02" align="center" />
> +	  <colspec colnum="10" colname="b01" align="center" />
> +	  <colspec colnum="11" colname="b00" align="center" />
> +	  <spanspec namest="b07" nameend="b00" spanname="b0" />
> +	  <thead>
> +	    <row>
> +	      <entry>Identifier</entry>
> +	      <entry>Code</entry>
> +	      <entry></entry>
> +	      <entry spanname="b0">Data organization</entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>Bit</entry>
> +	      <entry>7</entry>
> +	      <entry>6</entry>
> +	      <entry>5</entry>
> +	      <entry>4</entry>
> +	      <entry>3</entry>
> +	      <entry>2</entry>
> +	      <entry>1</entry>
> +	      <entry>0</entry>
> +	    </row>
> +	  </thead>
> +	  <tbody valign="top">
> +	    <row id="V4L2-MBUS-FMT-RGB555-2X8-PADHI-BE">
> +	      <entry>V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE</entry>
> +	      <entry>7</entry>
> +	      <entry></entry>
> +	      <entry>0</entry>
> +	      <entry>r<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-RGB555-2X8-PADHI-LE">
> +	      <entry>V4L2_MBUS_FMT_RGB555_2X8_PADHI_LE</entry>
> +	      <entry>6</entry>
> +	      <entry></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>0</entry>
> +	      <entry>r<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-RGB565-2X8-BE">
> +	      <entry>V4L2_MBUS_FMT_RGB565_2X8_BE</entry>
> +	      <entry>9</entry>
> +	      <entry></entry>
> +	      <entry>r<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-RGB565-2X8-LE">
> +	      <entry>V4L2_MBUS_FMT_RGB565_2X8_LE</entry>
> +	      <entry>8</entry>
> +	      <entry></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>r<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	    </row>
> +	  </tbody>
> +	</tgroup>
> +      </table>
> +    </section>
> +
> +    <section>
> +      <title>Bayer formats</title>
> +
> +      <para>Those formats transfer pixel data as red, green and blue components.
> +      The format code is made of the following information.
> +      <itemizedlist>
> +	<listitem>The red, green and blue components order code, as encoded in a
> +	pixel sample. The possible values are shown in <xref
> +	linkend="bayer-patterns" />.</listitem>
> +	<listitem>The number of bits per pixel component. All components are
> +	transferred on the same number of bits. Common values are 8, 10 and 12.
> +	</listitem>
> +	<listitem>If the pixel components are DPCM-compressed, a mention of the
> +	DPCM compression and the number of bits per compressed pixel component.
> +	</listitem>
> +	<listitem>The number of bus samples per pixel. Pixels that are wider than
> +	the bus width must be transferred in multiple samples. Common values are
> +	1 and 2.</listitem>
> +	<listitem>The bus width.</listitem>
> +	<listitem>For formats where the total number of bits per pixel is smaller
> +	than the number of bus samples per pixel times the bus width, a padding
> +	value stating if the bytes are padded in their most high order bits
> +	(PADHI) or low order bits (PADLO).</listitem>
> +	<listitem>For formats where the number of bus samples per pixel is larger
> +	than 1, an endianness value stating if the pixel is transferred MSB first
> +	(BE) or LSB first (LE).</listitem>
> +      </itemizedlist>
> +      </para>
> +
> +      <para>For instance, a format with uncompressed 10-bit Bayer components
> +      arranged in a red, green, green, blue pattern transferred as 2 8-bit
> +      samples per pixel with the least significant bits transferred first will
> +      be named <constant>V4L2_MBUS_FMT_SRGGB10_2X8_PADHI_LE</constant>.
> +      </para>
> +
> +      <figure id="bayer-patterns">
> +	<title>Bayer patterns</title>
> +	<mediaobject>
> +	  <imageobject>
> +	    <imagedata fileref="bayer.pdf" format="PS" />
> +	  </imageobject>
> +	  <imageobject>
> +	    <imagedata fileref="bayer.png" format="PNG" />
> +	  </imageobject>
> +	  <textobject>
> +	    <phrase>Bayer filter color patterns</phrase>
> +	  </textobject>
> +	</mediaobject>
> +      </figure>
> +
> +      <para>The following table lists existing packet Bayer formats. The data
> +      organization is given as an example for the first pixel only.</para>
> +
> +      <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-bayer">
> +	<title>Bayer formats</title>
> +	<tgroup cols="15">
> +	  <colspec colname="id" align="left" />
> +	  <colspec colname="code" align="center"/>
> +	  <colspec colname="bit" />
> +	  <colspec colnum="4" colname="b11" align="center" />
> +	  <colspec colnum="5" colname="b10" align="center" />
> +	  <colspec colnum="6" colname="b09" align="center" />
> +	  <colspec colnum="7" colname="b08" align="center" />
> +	  <colspec colnum="8" colname="b07" align="center" />
> +	  <colspec colnum="9" colname="b06" align="center" />
> +	  <colspec colnum="10" colname="b05" align="center" />
> +	  <colspec colnum="11" colname="b04" align="center" />
> +	  <colspec colnum="12" colname="b03" align="center" />
> +	  <colspec colnum="13" colname="b02" align="center" />
> +	  <colspec colnum="14" colname="b01" align="center" />
> +	  <colspec colnum="15" colname="b00" align="center" />
> +	  <spanspec namest="b11" nameend="b00" spanname="b0" />
> +	  <thead>
> +	    <row>
> +	      <entry>Identifier</entry>
> +	      <entry>Code</entry>
> +	      <entry></entry>
> +	      <entry spanname="b0">Data organization</entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>Bit</entry>
> +	      <entry>11</entry>
> +	      <entry>10</entry>
> +	      <entry>9</entry>
> +	      <entry>8</entry>
> +	      <entry>7</entry>
> +	      <entry>6</entry>
> +	      <entry>5</entry>
> +	      <entry>4</entry>
> +	      <entry>3</entry>
> +	      <entry>2</entry>
> +	      <entry>1</entry>
> +	      <entry>0</entry>
> +	    </row>
> +	  </thead>
> +	  <tbody valign="top">
> +	    <row id="V4L2-MBUS-FMT-SBGGR8-1X8">
> +	      <entry>V4L2_MBUS_FMT_SBGGR8_1X8</entry>
> +	      <entry>10</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>b<subscript>7</subscript></entry>
> +	      <entry>b<subscript>6</subscript></entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-SBGGR10-DPCM8-1X8">
> +	      <entry>V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8</entry>
> +	      <entry>30</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>b<subscript>7</subscript></entry>
> +	      <entry>b<subscript>6</subscript></entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-SBGGR10-2X8-PADHI-BE">
> +	      <entry>V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_BE</entry>
> +	      <entry>16</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>b<subscript>9</subscript></entry>
> +	      <entry>b<subscript>8</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>b<subscript>7</subscript></entry>
> +	      <entry>b<subscript>6</subscript></entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-SBGGR10-2X8-PADHI-LE">
> +	      <entry>V4L2_MBUS_FMT_SBGGR10_2X8_PADHI_LE</entry>
> +	      <entry>14</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>b<subscript>7</subscript></entry>
> +	      <entry>b<subscript>6</subscript></entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>b<subscript>9</subscript></entry>
> +	      <entry>b<subscript>8</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-SBGGR10-2X8-PADLO-BE">
> +	      <entry>V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_BE</entry>
> +	      <entry>17</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>b<subscript>9</subscript></entry>
> +	      <entry>b<subscript>8</subscript></entry>
> +	      <entry>b<subscript>7</subscript></entry>
> +	      <entry>b<subscript>6</subscript></entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-SBGGR10-2X8-PADLO-LE">
> +	      <entry>V4L2_MBUS_FMT_SBGGR10_2X8_PADLO_LE</entry>
> +	      <entry>15</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	      <entry>0</entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>b<subscript>9</subscript></entry>
> +	      <entry>b<subscript>8</subscript></entry>
> +	      <entry>b<subscript>7</subscript></entry>
> +	      <entry>b<subscript>6</subscript></entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-SBGGR10-1X10">
> +	      <entry>V4L2_MBUS_FMT_SBGGR10_1X10</entry>
> +	      <entry>11</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>b<subscript>9</subscript></entry>
> +	      <entry>b<subscript>8</subscript></entry>
> +	      <entry>b<subscript>7</subscript></entry>
> +	      <entry>b<subscript>6</subscript></entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-SBGGR12-1X12">
> +	      <entry>V4L2_MBUS_FMT_SBGGR12_1X12</entry>
> +	      <entry>19</entry>
> +	      <entry></entry>
> +	      <entry>b<subscript>11</subscript></entry>
> +	      <entry>b<subscript>10</subscript></entry>
> +	      <entry>b<subscript>9</subscript></entry>
> +	      <entry>b<subscript>8</subscript></entry>
> +	      <entry>b<subscript>7</subscript></entry>
> +	      <entry>b<subscript>6</subscript></entry>
> +	      <entry>b<subscript>5</subscript></entry>
> +	      <entry>b<subscript>4</subscript></entry>
> +	      <entry>b<subscript>3</subscript></entry>
> +	      <entry>b<subscript>2</subscript></entry>
> +	      <entry>b<subscript>1</subscript></entry>
> +	      <entry>b<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-SGBRG10-DPCM8-1X8">
> +	      <entry>V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8</entry>
> +	      <entry>32</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>g<subscript>7</subscript></entry>
> +	      <entry>g<subscript>6</subscript></entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-SGBRG10-1X10">
> +	      <entry>V4L2_MBUS_FMT_SGBRG10_1X10</entry>
> +	      <entry>31</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>g<subscript>9</subscript></entry>
> +	      <entry>g<subscript>8</subscript></entry>
> +	      <entry>g<subscript>7</subscript></entry>
> +	      <entry>g<subscript>6</subscript></entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-SGRBG8-1X8">
> +	      <entry>V4L2_MBUS_FMT_SGRBG8_1X8</entry>
> +	      <entry>18</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>g<subscript>7</subscript></entry>
> +	      <entry>g<subscript>6</subscript></entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-SGRBG10-DPCM8-1X8">
> +	      <entry>V4L2_MBUS_FMT_SGRBG10_DPCM8_1X8</entry>
> +	      <entry>29</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>g<subscript>7</subscript></entry>
> +	      <entry>g<subscript>6</subscript></entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-SGRBG10-1X10">
> +	      <entry>V4L2_MBUS_FMT_SGRBG10_1X10</entry>
> +	      <entry>28</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>g<subscript>9</subscript></entry>
> +	      <entry>g<subscript>8</subscript></entry>
> +	      <entry>g<subscript>7</subscript></entry>
> +	      <entry>g<subscript>6</subscript></entry>
> +	      <entry>g<subscript>5</subscript></entry>
> +	      <entry>g<subscript>4</subscript></entry>
> +	      <entry>g<subscript>3</subscript></entry>
> +	      <entry>g<subscript>2</subscript></entry>
> +	      <entry>g<subscript>1</subscript></entry>
> +	      <entry>g<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-SRGGB10-DPCM8-1X8">
> +	      <entry>V4L2_MBUS_FMT_SRGGB10_DPCM8_1X8</entry>
> +	      <entry>34</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>r<subscript>7</subscript></entry>
> +	      <entry>r<subscript>6</subscript></entry>
> +	      <entry>r<subscript>5</subscript></entry>
> +	      <entry>r<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-SRGGB10-1X10">
> +	      <entry>V4L2_MBUS_FMT_SRGGB10_1X10</entry>
> +	      <entry>33</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>r<subscript>9</subscript></entry>
> +	      <entry>r<subscript>8</subscript></entry>
> +	      <entry>r<subscript>7</subscript></entry>
> +	      <entry>r<subscript>6</subscript></entry>
> +	      <entry>r<subscript>5</subscript></entry>
> +	      <entry>r<subscript>4</subscript></entry>
> +	      <entry>r<subscript>3</subscript></entry>
> +	      <entry>r<subscript>2</subscript></entry>
> +	      <entry>r<subscript>1</subscript></entry>
> +	      <entry>r<subscript>0</subscript></entry>
> +	    </row>
> +	  </tbody>
> +	</tgroup>
> +      </table>
> +    </section>
> +
> +    <section>
> +      <title>Packed YUV formats</title>
> +
> +      <para>Those data formats transfer pixel data as (possibly downsampled) Y, U
> +      and V components. The format code is made of the following information.
> +      <itemizedlist>
> +	<listitem>The Y, U and V components order code, as transferred on the
> +	bus. Possible values are YUYV, UYVY, YVYU and VYUY.</listitem>
> +	<listitem>The number of bits per pixel component. All components are
> +	transferred on the same number of bits. Common values are 8, 10 and 12.
> +	</listitem>
> +	<listitem>The number of bus samples per pixel. Pixels that are wider than
> +	the bus width must be transferred in multiple samples. Common values are
> +	1, 1.5 (encoded as 1_5) and 2.</listitem>
> +	<listitem>The bus width. When the bus width is larger than the number of
> +	bits per pixel component, several components are packed in a single bus
> +	sample. The components are ordered as specified by the order code, with
> +	components on the left of the code transferred in the high order bits.
> +	Common values are 8 and 16.
> +	</listitem>
> +      </itemizedlist>
> +      </para>
> +
> +      <para>For instance, a format where pixels are encoded as 8-bit YUV values
> +      downsampled to 4:2:2 and transferred as 2 8-bit bus samples per pixel in the
> +      U, Y, V, Y order will be named <constant>V4L2_MBUS_FMT_UYVY8_2X8</constant>.
> +      </para>
> +
> +      <para>The following table lisst existing packet YUV formats.</para>
> +
> +      <table pgwide="0" frame="none" id="v4l2-mbus-pixelcode-yuv8">
> +	<title>YUV formats</title>
> +	<tgroup cols="19">
> +	  <colspec colname="id" align="left" />
> +	  <colspec colname="code" align="center"/>
> +	  <colspec colname="bit" />
> +	  <colspec colnum="4" colname="b15" align="center" />
> +	  <colspec colnum="5" colname="b14" align="center" />
> +	  <colspec colnum="6" colname="b13" align="center" />
> +	  <colspec colnum="7" colname="b12" align="center" />
> +	  <colspec colnum="8" colname="b11" align="center" />
> +	  <colspec colnum="9" colname="b10" align="center" />
> +	  <colspec colnum="10" colname="b09" align="center" />
> +	  <colspec colnum="11" colname="b08" align="center" />
> +	  <colspec colnum="12" colname="b07" align="center" />
> +	  <colspec colnum="13" colname="b06" align="center" />
> +	  <colspec colnum="14" colname="b05" align="center" />
> +	  <colspec colnum="15" colname="b04" align="center" />
> +	  <colspec colnum="16" colname="b03" align="center" />
> +	  <colspec colnum="17" colname="b02" align="center" />
> +	  <colspec colnum="18" colname="b01" align="center" />
> +	  <colspec colnum="19" colname="b00" align="center" />
> +	  <spanspec namest="b15" nameend="b00" spanname="b0" />
> +	  <thead>
> +	    <row>
> +	      <entry>Identifier</entry>
> +	      <entry>Code</entry>
> +	      <entry></entry>
> +	      <entry spanname="b0">Data organization</entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>Bit</entry>
> +	      <entry>15</entry>
> +	      <entry>14</entry>
> +	      <entry>13</entry>
> +	      <entry>12</entry>
> +	      <entry>11</entry>
> +	      <entry>10</entry>
> +	      <entry>9</entry>
> +	      <entry>8</entry>
> +	      <entry>7</entry>
> +	      <entry>6</entry>
> +	      <entry>5</entry>
> +	      <entry>4</entry>
> +	      <entry>3</entry>
> +	      <entry>2</entry>
> +	      <entry>1</entry>
> +	      <entry>0</entry>
> +	    </row>
> +	  </thead>
> +	  <tbody valign="top">
> +	    <row id="V4L2-MBUS-FMT-GREY8-1X8">
> +	      <entry>V4L2_MBUS_FMT_GREY8_1X8</entry>
> +	      <entry>12</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-YUYV8-2X8">
> +	      <entry>V4L2_MBUS_FMT_YUYV8_2X8</entry>
> +	      <entry>2</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>u<subscript>7</subscript></entry>
> +	      <entry>u<subscript>6</subscript></entry>
> +	      <entry>u<subscript>5</subscript></entry>
> +	      <entry>u<subscript>4</subscript></entry>
> +	      <entry>u<subscript>3</subscript></entry>
> +	      <entry>u<subscript>2</subscript></entry>
> +	      <entry>u<subscript>1</subscript></entry>
> +	      <entry>u<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>v<subscript>7</subscript></entry>
> +	      <entry>v<subscript>6</subscript></entry>
> +	      <entry>v<subscript>5</subscript></entry>
> +	      <entry>v<subscript>4</subscript></entry>
> +	      <entry>v<subscript>3</subscript></entry>
> +	      <entry>v<subscript>2</subscript></entry>
> +	      <entry>v<subscript>1</subscript></entry>
> +	      <entry>v<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-UYVY8-2X8">
> +	      <entry>V4L2_MBUS_FMT_UYVY8_2X8</entry>
> +	      <entry>4</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>u<subscript>7</subscript></entry>
> +	      <entry>u<subscript>6</subscript></entry>
> +	      <entry>u<subscript>5</subscript></entry>
> +	      <entry>u<subscript>4</subscript></entry>
> +	      <entry>u<subscript>3</subscript></entry>
> +	      <entry>u<subscript>2</subscript></entry>
> +	      <entry>u<subscript>1</subscript></entry>
> +	      <entry>u<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>v<subscript>7</subscript></entry>
> +	      <entry>v<subscript>6</subscript></entry>
> +	      <entry>v<subscript>5</subscript></entry>
> +	      <entry>v<subscript>4</subscript></entry>
> +	      <entry>v<subscript>3</subscript></entry>
> +	      <entry>v<subscript>2</subscript></entry>
> +	      <entry>v<subscript>1</subscript></entry>
> +	      <entry>v<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-YVYU8-2X8">
> +	      <entry>V4L2_MBUS_FMT_YVYU8_2X8</entry>
> +	      <entry>3</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>v<subscript>7</subscript></entry>
> +	      <entry>v<subscript>6</subscript></entry>
> +	      <entry>v<subscript>5</subscript></entry>
> +	      <entry>v<subscript>4</subscript></entry>
> +	      <entry>v<subscript>3</subscript></entry>
> +	      <entry>v<subscript>2</subscript></entry>
> +	      <entry>v<subscript>1</subscript></entry>
> +	      <entry>v<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>u<subscript>7</subscript></entry>
> +	      <entry>u<subscript>6</subscript></entry>
> +	      <entry>u<subscript>5</subscript></entry>
> +	      <entry>u<subscript>4</subscript></entry>
> +	      <entry>u<subscript>3</subscript></entry>
> +	      <entry>u<subscript>2</subscript></entry>
> +	      <entry>u<subscript>1</subscript></entry>
> +	      <entry>u<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-VYUY8-2X8">
> +	      <entry>V4L2_MBUS_FMT_VYUY8_2X8</entry>
> +	      <entry>5</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>v<subscript>7</subscript></entry>
> +	      <entry>v<subscript>6</subscript></entry>
> +	      <entry>v<subscript>5</subscript></entry>
> +	      <entry>v<subscript>4</subscript></entry>
> +	      <entry>v<subscript>3</subscript></entry>
> +	      <entry>v<subscript>2</subscript></entry>
> +	      <entry>v<subscript>1</subscript></entry>
> +	      <entry>v<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>u<subscript>7</subscript></entry>
> +	      <entry>u<subscript>6</subscript></entry>
> +	      <entry>u<subscript>5</subscript></entry>
> +	      <entry>u<subscript>4</subscript></entry>
> +	      <entry>u<subscript>3</subscript></entry>
> +	      <entry>u<subscript>2</subscript></entry>
> +	      <entry>u<subscript>1</subscript></entry>
> +	      <entry>u<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-Y10-1X10">
> +	      <entry>V4L2_MBUS_FMT_Y10_1X10</entry>
> +	      <entry>13</entry>
> +	      <entry></entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>-</entry>
> +	      <entry>y<subscript>9</subscript></entry>
> +	      <entry>y<subscript>8</subscript></entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-YUYV8-1X16">
> +	      <entry>V4L2_MBUS_FMT_YUYV8_1X16</entry>
> +	      <entry>24</entry>
> +	      <entry></entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	      <entry>u<subscript>7</subscript></entry>
> +	      <entry>u<subscript>6</subscript></entry>
> +	      <entry>u<subscript>5</subscript></entry>
> +	      <entry>u<subscript>4</subscript></entry>
> +	      <entry>u<subscript>3</subscript></entry>
> +	      <entry>u<subscript>2</subscript></entry>
> +	      <entry>u<subscript>1</subscript></entry>
> +	      <entry>u<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	      <entry>v<subscript>7</subscript></entry>
> +	      <entry>v<subscript>6</subscript></entry>
> +	      <entry>v<subscript>5</subscript></entry>
> +	      <entry>v<subscript>4</subscript></entry>
> +	      <entry>v<subscript>3</subscript></entry>
> +	      <entry>v<subscript>2</subscript></entry>
> +	      <entry>v<subscript>1</subscript></entry>
> +	      <entry>v<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-UYVY8-1X16">
> +	      <entry>V4L2_MBUS_FMT_UYVY8_1X16</entry>
> +	      <entry>25</entry>
> +	      <entry></entry>
> +	      <entry>u<subscript>7</subscript></entry>
> +	      <entry>u<subscript>6</subscript></entry>
> +	      <entry>u<subscript>5</subscript></entry>
> +	      <entry>u<subscript>4</subscript></entry>
> +	      <entry>u<subscript>3</subscript></entry>
> +	      <entry>u<subscript>2</subscript></entry>
> +	      <entry>u<subscript>1</subscript></entry>
> +	      <entry>u<subscript>0</subscript></entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>v<subscript>7</subscript></entry>
> +	      <entry>v<subscript>6</subscript></entry>
> +	      <entry>v<subscript>5</subscript></entry>
> +	      <entry>v<subscript>4</subscript></entry>
> +	      <entry>v<subscript>3</subscript></entry>
> +	      <entry>v<subscript>2</subscript></entry>
> +	      <entry>v<subscript>1</subscript></entry>
> +	      <entry>v<subscript>0</subscript></entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-YVYU8-1X16">
> +	      <entry>V4L2_MBUS_FMT_YVYU8_1X16</entry>
> +	      <entry>26</entry>
> +	      <entry></entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	      <entry>v<subscript>7</subscript></entry>
> +	      <entry>v<subscript>6</subscript></entry>
> +	      <entry>v<subscript>5</subscript></entry>
> +	      <entry>v<subscript>4</subscript></entry>
> +	      <entry>v<subscript>3</subscript></entry>
> +	      <entry>v<subscript>2</subscript></entry>
> +	      <entry>v<subscript>1</subscript></entry>
> +	      <entry>v<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	      <entry>u<subscript>7</subscript></entry>
> +	      <entry>u<subscript>6</subscript></entry>
> +	      <entry>u<subscript>5</subscript></entry>
> +	      <entry>u<subscript>4</subscript></entry>
> +	      <entry>u<subscript>3</subscript></entry>
> +	      <entry>u<subscript>2</subscript></entry>
> +	      <entry>u<subscript>1</subscript></entry>
> +	      <entry>u<subscript>0</subscript></entry>
> +	    </row>
> +	    <row id="V4L2-MBUS-FMT-VYUY8-1X16">
> +	      <entry>V4L2_MBUS_FMT_VYUY8_1X16</entry>
> +	      <entry>27</entry>
> +	      <entry></entry>
> +	      <entry>v<subscript>7</subscript></entry>
> +	      <entry>v<subscript>6</subscript></entry>
> +	      <entry>v<subscript>5</subscript></entry>
> +	      <entry>v<subscript>4</subscript></entry>
> +	      <entry>v<subscript>3</subscript></entry>
> +	      <entry>v<subscript>2</subscript></entry>
> +	      <entry>v<subscript>1</subscript></entry>
> +	      <entry>v<subscript>0</subscript></entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	    </row>
> +	    <row>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry></entry>
> +	      <entry>u<subscript>7</subscript></entry>
> +	      <entry>u<subscript>6</subscript></entry>
> +	      <entry>u<subscript>5</subscript></entry>
> +	      <entry>u<subscript>4</subscript></entry>
> +	      <entry>u<subscript>3</subscript></entry>
> +	      <entry>u<subscript>2</subscript></entry>
> +	      <entry>u<subscript>1</subscript></entry>
> +	      <entry>u<subscript>0</subscript></entry>
> +	      <entry>y<subscript>7</subscript></entry>
> +	      <entry>y<subscript>6</subscript></entry>
> +	      <entry>y<subscript>5</subscript></entry>
> +	      <entry>y<subscript>4</subscript></entry>
> +	      <entry>y<subscript>3</subscript></entry>
> +	      <entry>y<subscript>2</subscript></entry>
> +	      <entry>y<subscript>1</subscript></entry>
> +	      <entry>y<subscript>0</subscript></entry>
> +	    </row>
> +	  </tbody>
> +	</tgroup>
> +      </table>
> +    </section>
> +  </section>
> +</section>
> diff --git a/Documentation/DocBook/v4l/v4l2.xml b/Documentation/DocBook/v4l/v4l2.xml
> index 7c3c098..3a59b82 100644
> --- a/Documentation/DocBook/v4l/v4l2.xml
> +++ b/Documentation/DocBook/v4l/v4l2.xml
> @@ -402,6 +402,7 @@ and discussions on the V4L mailing list.</revremark>
>      <section id="radio"> &sub-dev-radio; </section>
>      <section id="rds"> &sub-dev-rds; </section>
>      <section id="event"> &sub-dev-event; </section>
> +    <section id="subdev"> &sub-dev-subdev; </section>
>    </chapter>
>  
>    <chapter id="driver">
> @@ -469,6 +470,9 @@ and discussions on the V4L mailing list.</revremark>
>      &sub-reqbufs;
>      &sub-s-hw-freq-seek;
>      &sub-streamon;
> +    &sub-subdev-enum-frame-size;
> +    &sub-subdev-enum-mbus-code;
> +    &sub-subdev-g-fmt;
>      &sub-subscribe-event;
>      <!-- End of ioctls. -->
>      &sub-mmap;
> diff --git a/Documentation/DocBook/v4l/vidioc-streamon.xml b/Documentation/DocBook/v4l/vidioc-streamon.xml
> index e42bff1..75ed39b 100644
> --- a/Documentation/DocBook/v4l/vidioc-streamon.xml
> +++ b/Documentation/DocBook/v4l/vidioc-streamon.xml
> @@ -93,6 +93,15 @@ synchronize with other events.</para>
>  been allocated (memory mapping) or enqueued (output) yet.</para>
>  	</listitem>
>        </varlistentry>
> +      <varlistentry>
> +	<term><errorcode>EPIPE</errorcode></term>
> +	<listitem>
> +	  <para>The driver implements <link
> +	  linkend="pad-level-formats">pad-level format configuration</link> and
> +	  the pipeline configuration is invalid.

This raises a question with me: how do I know that pad-level format configuration
is possible? Is there a capability or some test that I can perform to check this?

> +	  </para>
> +	</listitem>
> +      </varlistentry>
>      </variablelist>
>    </refsect1>
>  </refentry>
> diff --git a/Documentation/DocBook/v4l/vidioc-subdev-enum-frame-size.xml b/Documentation/DocBook/v4l/vidioc-subdev-enum-frame-size.xml
> new file mode 100644
> index 0000000..0fc0d99
> --- /dev/null
> +++ b/Documentation/DocBook/v4l/vidioc-subdev-enum-frame-size.xml
> @@ -0,0 +1,148 @@
> +<refentry id="vidioc-subdev-enum-frame-size">
> +  <refmeta>
> +    <refentrytitle>ioctl VIDIOC_SUBDEV_ENUM_FRAME_SIZE</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +
> +  <refnamediv>
> +    <refname>VIDIOC_SUBDEV_ENUM_FRAME_SIZE</refname>
> +    <refpurpose>Enumerate media bus frame sizes</refpurpose>
> +  </refnamediv>
> +
> +  <refsynopsisdiv>
> +    <funcsynopsis>
> +      <funcprototype>
> +	<funcdef>int <function>ioctl</function></funcdef>
> +	<paramdef>int <parameter>fd</parameter></paramdef>
> +	<paramdef>int <parameter>request</parameter></paramdef>
> +	<paramdef>struct v4l2_subdev_frame_size_enum *
> +	<parameter>argp</parameter></paramdef>
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
> +	  <para>VIDIOC_SUBDEV_ENUM_FRAME_SIZE</para>
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
> +    <para>This ioctl allows applications to enumerate all frame sizes
> +    supported by a sub-device on the given pad for the given media bus format.
> +    Supported formats can be retrieved with the &VIDIOC-SUBDEV-ENUM-MBUS-CODE;
> +    ioctl.</para>
> +
> +    <para>To enumerate frame sizes applications initialize the
> +    <structfield>pad</structfield>, <structfield>code</structfield> and
> +    <structfield>index</structfield> fields of the
> +    &v4l2-subdev-mbus-code-enum; and call the
> +    <constant>VIDIOC_SUBDEV_ENUM_FRAME_SIZE</constant> ioctl with a pointer to
> +    the structure. Drivers fill the minimum and maximum frame sizes or return
> +    an &EINVAL; if one of the input parameters is invalid.</para>
> +
> +    <para>Sub-devices that only support discrete frame sizes (such as most
> +    sensors) will return one or more frame sizes with identical minimum and
> +    maximum values.</para>
> +
> +    <para>Not all possible sizes in given [minimum, maximum] ranges need to be
> +    supported. For instance, a scaler that uses a fixed-point scaling ratio
> +    might not be able to produce every frame size between the minimum and
> +    maximum values. Applications must use the &VIDIOC-SUBDEV-S-FMT; ioctl to
> +    probe the sub-device for an exact supported frame size.</para>
> +
> +    <para>Available frame sizes may depend on the current probe formats at other
> +    pads of the sub-device, as well as on the current active links and the
> +    current values of V4L2 controls. See &VIDIOC-SUBDEV-G-FMT; for more
> +    information about probe formats.</para>
> +
> +    <table pgwide="1" frame="none" id="v4l2-subdev-frame-size-enum">
> +      <title>struct <structname>v4l2_subdev_frame_size_enum</structname></title>
> +      <tgroup cols="3">
> +	&cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>index</structfield></entry>
> +	    <entry>Number of the format in the enumeration, set by the
> +	    application.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>pad</structfield></entry>
> +	    <entry>Pad number as reported by the media controller API.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>code</structfield></entry>
> +	    <entry>The media bus format code, as defined in
> +	    <xref linkend="v4l2-mbus-format" />.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>min_width</structfield></entry>
> +	    <entry>Minimum frame width, in pixels.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>max_width</structfield></entry>
> +	    <entry>Maximum frame width, in pixels.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>min_height</structfield></entry>
> +	    <entry>Minimum frame height, in pixels.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>max_height</structfield></entry>
> +	    <entry>Maximum frame height, in pixels.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved</structfield>[9]</entry>
> +	    <entry>Reserved for future extensions. Applications and drivers must
> +	    set the array to zero.</entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +  </refsect1>
> +
> +  <refsect1>
> +    &return-value;
> +
> +    <variablelist>
> +      <varlistentry>
> +	<term><errorcode>EINVAL</errorcode></term>
> +	<listitem>
> +	  <para>The &v4l2-subdev-frame-size-enum; <structfield>pad</structfield>
> +	  references a non-existing pad, the <structfield>code</structfield> is
> +	  invalid for the given pad or the <structfield>index</structfield>
> +	  field is out of bounds.</para>
> +	</listitem>
> +      </varlistentry>
> +    </variablelist>
> +  </refsect1>
> +</refentry>
> diff --git a/Documentation/DocBook/v4l/vidioc-subdev-enum-mbus-code.xml b/Documentation/DocBook/v4l/vidioc-subdev-enum-mbus-code.xml
> new file mode 100644
> index 0000000..f8bfa5f
> --- /dev/null
> +++ b/Documentation/DocBook/v4l/vidioc-subdev-enum-mbus-code.xml
> @@ -0,0 +1,113 @@
> +<refentry id="vidioc-subdev-enum-mbus-code">
> +  <refmeta>
> +    <refentrytitle>ioctl VIDIOC_SUBDEV_ENUM_MBUS_CODE</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +
> +  <refnamediv>
> +    <refname>VIDIOC_SUBDEV_ENUM_MBUS_CODE</refname>
> +    <refpurpose>Enumerate media bus formats</refpurpose>
> +  </refnamediv>
> +
> +  <refsynopsisdiv>
> +    <funcsynopsis>
> +      <funcprototype>
> +	<funcdef>int <function>ioctl</function></funcdef>
> +	<paramdef>int <parameter>fd</parameter></paramdef>
> +	<paramdef>int <parameter>request</parameter></paramdef>
> +	<paramdef>struct v4l2_subdev_mbus_code_enum *
> +	<parameter>argp</parameter></paramdef>
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
> +	  <para>VIDIOC_SUBDEV_ENUM_MBUS_CODE</para>
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
> +    <para>To enumerate media bus formats available at a given sub-device pad
> +    applications initialize the <structfield>pad</structfield> and
> +    <structfield>index</structfield> fields of &v4l2-subdev-mbus-code-enum; and
> +    call the <constant>VIDIOC_SUBDEV_ENUM_MBUS_CODE</constant> ioctl with a
> +    pointer to this structure. Drivers fill the rest of the structure or return
> +    an &EINVAL; if either the <structfield>pad</structfield> or
> +    <structfield>index</structfield> are invalid. All media bus formats are
> +    enumerable by beginning at index zero and incrementing by one until
> +    <errorcode>EINVAL</errorcode> is returned.</para>
> +
> +    <para>Available media bus formats may depend on the current probe formats
> +    at other pads of the sub-device, as well as on the current active links. See
> +    &VIDIOC-SUBDEV-G-FMT; for more information about the probe formats.</para>
> +
> +    <table pgwide="1" frame="none" id="v4l2-subdev-mbus-code-enum">
> +      <title>struct <structname>v4l2_subdev_mbus_code_enum</structname></title>
> +      <tgroup cols="3">
> +	&cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>pad</structfield></entry>
> +	    <entry>Pad number as reported by the media controller API.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>index</structfield></entry>
> +	    <entry>Number of the format in the enumeration, set by the
> +	    application.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>code</structfield></entry>
> +	    <entry>The media bus format code, as defined in
> +	    <xref linkend="v4l2-mbus-format" />.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved</structfield>[5]</entry>
> +	    <entry>Reserved for future extensions. Applications and drivers must
> +	    set the array to zero.</entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +  </refsect1>
> +
> +  <refsect1>
> +    &return-value;
> +
> +    <variablelist>
> +      <varlistentry>
> +	<term><errorcode>EINVAL</errorcode></term>
> +	<listitem>
> +	  <para>The &v4l2-subdev-mbus-code-enum; <structfield>pad</structfield>
> +	  references a non-existing pad, or the <structfield>index</structfield>
> +	  field is out of bounds.</para>
> +	</listitem>
> +      </varlistentry>
> +    </variablelist>
> +  </refsect1>
> +</refentry>
> diff --git a/Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml b/Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml
> new file mode 100644
> index 0000000..32efbed
> --- /dev/null
> +++ b/Documentation/DocBook/v4l/vidioc-subdev-g-fmt.xml
> @@ -0,0 +1,168 @@
> +<refentry id="vidioc-subdev-g-fmt">
> +  <refmeta>
> +    <refentrytitle>ioctl VIDIOC_SUBDEV_G_FMT, VIDIOC_SUBDEV_S_FMT</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +
> +  <refnamediv>
> +    <refname>VIDIOC_SUBDEV_G_FMT</refname>
> +    <refname>VIDIOC_SUBDEV_S_FMT</refname>
> +    <refpurpose>Get or set the data format on a subdev pad</refpurpose>
> +  </refnamediv>
> +
> +  <refsynopsisdiv>
> +    <funcsynopsis>
> +      <funcprototype>
> +	<funcdef>int <function>ioctl</function></funcdef>
> +	<paramdef>int <parameter>fd</parameter></paramdef>
> +	<paramdef>int <parameter>request</parameter></paramdef>
> +	<paramdef>struct v4l2_subdev_format *<parameter>argp</parameter>
> +	</paramdef>
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
> +	  <para>VIDIOC_SUBDEV_G_FMT, VIDIOC_SUBDEV_S_FMT</para>
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
> +    <para>These ioctls are used to negotiate the frame format at specific
> +    subdev pads in the image pipeline.</para>
> +
> +    <para>To retrieve the current format applications set the
> +    <structfield>pad</structfield> field of a &v4l2-subdev-format; to the
> +    desired pad number as reported by the media API and the
> +    <structfield>which</structfield> field to
> +    <constant>V4L2_SUBDEV_FORMAT_ACTIVE</constant>. When they call the
> +    <constant>VIDIOC_SUBDEV_G_FMT</constant> ioctl with a pointer to this
> +    structure the driver fills the members of the <structfield>format</structfield>
> +    field.</para>
> +
> +    <para>To change the current format applications set both the
> +    <structfield>pad</structfield> and <structfield>which</structfield> fields
> +    and all members of the <structfield>format</structfield> field. When they
> +    call the <constant>VIDIOC_SUBDEV_S_FMT</constant> ioctl with a pointer to this
> +    structure the driver verifies the requested format, adjusts it based on the
> +    hardware capabilities and configures the device. Upon return the
> +    &v4l2-subdev-format; contains the current format as would be returned by a
> +    <constant>VIDIOC_SUBDEV_G_FMT</constant> call.</para>
> +
> +    <para>Applications can probe the device capabilities by setting the
> +    <structfield>which</structfield> to
> +    <constant>V4L2_SUBDEV_FORMAT_PROBE</constant>. When set, probe formats are
> +    not applied to the device by the driver, but are mangled exactly as active
> +    formats and stored in the sub-device file handle. Two applications probing
> +    the same sub-device would thus not interact with each other.</para>
> +
> +    <para>For instance, to try a format at the output pad of a sub-device,
> +    applications would first set the probe format at the sub-device input with
> +    the <constant>VIDIOC_SUBDEV_S_FMT</constant> ioctl. They would then either
> +    retrieve the default format at the output pad with the
> +    <constant>VIDIOC_SUBDEV_G_FMT</constant> ioctl, or set the desired output
> +    pad format with the <constant>VIDIOC_SUBDEV_S_FMT</constant> ioctl and check
> +    the returned value.</para>
> +
> +    <para>Probe formats do not depend on active formats, but can depend on the
> +    current links configuration or sub-device controls value. For instance, a
> +    low-pass noise filter might crop pixels at the frame boundaries, modifying
> +    its output frame size.</para>
> +
> +    <para>Drivers must not return an error solely because the requested format
> +    doesn't match the device capabilities. They must instead modify the format
> +    to match what the hardware can provide. The modified format should be as
> +    close as possible to the original request.</para>
> +
> +    <table pgwide="1" frame="none" id="v4l2-subdev-format">
> +      <title>struct <structname>v4l2_subdev_format</structname></title>
> +      <tgroup cols="3">
> +        &cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>pad</structfield></entry>
> +	    <entry>Pad number as reported by the media controller API.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>which</structfield></entry>
> +	    <entry>Format to modified, from &v4l2-subdev-format-whence;.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>&v4l2-mbus-framefmt;</entry>
> +	    <entry><structfield>format</structfield></entry>
> +	    <entry>Definition of an image format, see <xref
> +	    linkend="v4l2-mbus-framefmt" /> for details.</entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +
> +    <table pgwide="1" frame="none" id="v4l2-subdev-format-whence">
> +      <title>enum <structname>v4l2_subdev_format_whence</structname></title>
> +      <tgroup cols="3">
> +        &cs-def;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>V4L2_SUBDEV_FORMAT_PROBE</entry>
> +	    <entry>0</entry>
> +	    <entry>Probe formats, used for probing device capabilities.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>V4L2_SUBDEV_FORMAT_ACTIVE</entry>
> +	    <entry>1</entry>
> +	    <entry>Active formats, applied to the hardware.</entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +  </refsect1>
> +
> +  <refsect1>
> +    &return-value;
> +
> +    <variablelist>
> +      <varlistentry>
> +	<term><errorcode>EBUSY</errorcode></term>
> +	<listitem>
> +	  <para>The format can't be changed because the pad is currently busy.
> +	  This can be caused, for instance, by an active video stream on the
> +	  pad. The ioctl must not be retried without performing another action
> +	  to fix the problem first. Only returned by
> +	  <constant>VIDIOC_SUBDEV_S_FMT</constant></para>
> +	</listitem>
> +      </varlistentry>
> +      <varlistentry>
> +	<term><errorcode>EINVAL</errorcode></term>
> +	<listitem>
> +	  <para>The &v4l2-subdev-format; <structfield>pad</structfield>
> +	  references a non-existing pad, or the <structfield>which</structfield>
> +	  field references a non-existing format.</para>
> +	</listitem>
> +      </varlistentry>
> +    </variablelist>
> +  </refsect1>
> +</refentry>
> diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
> index d2891c1..380d2f2 100644
> --- a/drivers/media/video/v4l2-subdev.c
> +++ b/drivers/media/video/v4l2-subdev.c
> @@ -133,6 +133,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  	struct video_device *vdev = video_devdata(file);
>  	struct v4l2_subdev *sd = vdev_to_v4l2_subdev(vdev);
>  	struct v4l2_fh *vfh = file->private_data;
> +	struct v4l2_subdev_fh *subdev_fh = to_v4l2_subdev_fh(vfh);
>  
>  	switch (cmd) {
>  	case VIDIOC_QUERYCTRL:
> @@ -168,6 +169,56 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
>  	case VIDIOC_UNSUBSCRIBE_EVENT:
>  		return v4l2_subdev_call(sd, core, unsubscribe_event, vfh, arg);
>  
> +	case VIDIOC_SUBDEV_G_FMT: {
> +		struct v4l2_subdev_format *format = arg;
> +
> +		if (format->which != V4L2_SUBDEV_FORMAT_PROBE &&
> +		    format->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> +			return -EINVAL;
> +
> +		if (format->pad >= sd->entity.num_pads)
> +			return -EINVAL;
> +
> +		return v4l2_subdev_call(sd, pad, get_fmt, subdev_fh,
> +					format->pad, &format->format,
> +					format->which);
> +	}
> +
> +	case VIDIOC_SUBDEV_S_FMT: {
> +		struct v4l2_subdev_format *format = arg;
> +
> +		if (format->which != V4L2_SUBDEV_FORMAT_PROBE &&
> +		    format->which != V4L2_SUBDEV_FORMAT_ACTIVE)
> +			return -EINVAL;
> +
> +		if (format->pad >= sd->entity.num_pads)
> +			return -EINVAL;
> +
> +		return v4l2_subdev_call(sd, pad, set_fmt, subdev_fh,
> +					format->pad, &format->format,
> +					format->which);
> +	}
> +
> +	case VIDIOC_SUBDEV_ENUM_MBUS_CODE: {
> +		struct v4l2_subdev_mbus_code_enum *code = arg;
> +
> +		if (code->pad >= sd->entity.num_pads)
> +			return -EINVAL;
> +
> +		return v4l2_subdev_call(sd, pad, enum_mbus_code, subdev_fh,
> +					code);
> +	}
> +
> +	case VIDIOC_SUBDEV_ENUM_FRAME_SIZE: {
> +		struct v4l2_subdev_frame_size_enum *fse = arg;
> +
> +		if (fse->pad >= sd->entity.num_pads)
> +			return -EINVAL;
> +
> +		return v4l2_subdev_call(sd, pad, enum_frame_size, subdev_fh,
> +					fse);
> +	}
> +
>  	default:
>  		return -ENOIOCTLCMD;
>  	}
> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
> index 38127c2..c0cc1c3 100644
> --- a/include/linux/Kbuild
> +++ b/include/linux/Kbuild
> @@ -370,6 +370,7 @@ header-y += usbdevice_fs.h
>  header-y += utime.h
>  header-y += utsname.h
>  header-y += v4l2-mediabus.h
> +header-y += v4l2-subdev.h
>  header-y += veth.h
>  header-y += vhost.h
>  header-y += videodev.h
> diff --git a/include/linux/v4l2-subdev.h b/include/linux/v4l2-subdev.h
> new file mode 100644
> index 0000000..623d063
> --- /dev/null
> +++ b/include/linux/v4l2-subdev.h
> @@ -0,0 +1,90 @@
> +/*
> + * V4L2 subdev userspace API
> + *
> + * Copyright (C) 2010 Nokia Corporation
> + *
> + * Contacts: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> + *	     Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#ifndef __LINUX_V4L2_SUBDEV_H
> +#define __LINUX_V4L2_SUBDEV_H
> +
> +#include <linux/ioctl.h>
> +#include <linux/types.h>
> +#include <linux/v4l2-mediabus.h>
> +
> +/**
> + * enum v4l2_subdev_format_whence - Media bus format type
> + * @V4L2_SUBDEV_FORMAT_PROBE: probe format, for negotiation only
> + * @V4L2_SUBDEV_FORMAT_ACTIVE: active format, applied to the device
> + */
> +enum v4l2_subdev_format_whence {
> +	V4L2_SUBDEV_FORMAT_PROBE = 0,
> +	V4L2_SUBDEV_FORMAT_ACTIVE = 1,
> +};
> +
> +/**
> + * struct v4l2_subdev_format - Pad-level media bus format
> + * @which: format type (from enum v4l2_subdev_format_whence)
> + * @pad: pad number, as reported by the media API
> + * @format: media bus format (format code and frame size)
> + */
> +struct v4l2_subdev_format {
> +	__u32 which;
> +	__u32 pad;
> +	struct v4l2_mbus_framefmt format;
> +	__u32 reserved[9];
> +};
> +
> +/**
> + * struct v4l2_subdev_mbus_code_enum - Media bus format enumeration
> + * @pad: pad number, as reported by the media API
> + * @index: format index during enumeration
> + * @code: format code (from enum v4l2_mbus_pixelcode)
> + */
> +struct v4l2_subdev_mbus_code_enum {
> +	__u32 pad;
> +	__u32 index;
> +	__u32 code;
> +	__u32 reserved[5];
> +};
> +
> +/**
> + * struct v4l2_subdev_frame_size_enum - Media bus format enumeration
> + * @pad: pad number, as reported by the media API
> + * @index: format index during enumeration
> + * @code: format code (from enum v4l2_mbus_pixelcode)
> + */
> +struct v4l2_subdev_frame_size_enum {
> +	__u32 index;
> +	__u32 pad;
> +	__u32 code;
> +	__u32 min_width;
> +	__u32 max_width;
> +	__u32 min_height;
> +	__u32 max_height;
> +	__u32 reserved[9];
> +};

Is there a reason why struct v4l2_frmsize_discrete and v4l2_frmsize_stepwise are not
reused here? Given the absence of step_width/height fields in the struct can I
assume a step of 1?

> +
> +#define VIDIOC_SUBDEV_G_FMT	_IOWR('V',  4, struct v4l2_subdev_format)
> +#define VIDIOC_SUBDEV_S_FMT	_IOWR('V',  5, struct v4l2_subdev_format)
> +#define VIDIOC_SUBDEV_ENUM_MBUS_CODE \
> +			_IOWR('V',  2, struct v4l2_subdev_mbus_code_enum)
> +#define VIDIOC_SUBDEV_ENUM_FRAME_SIZE \
> +			_IOWR('V', 74, struct v4l2_subdev_frame_size_enum)

The ioctl numbering is a bit scary. We want to be able to reuse V4L2 ioctls
with subdevs where appropriate. But then we need to enumerate the subdev ioctls
using a different character to avoid potential conflicts. E.g. 'S' instead of 'V'.

> +
> +#endif
> diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
> index 8a278c2..bbbe4bf 100644
> --- a/include/media/v4l2-subdev.h
> +++ b/include/media/v4l2-subdev.h
> @@ -21,6 +21,7 @@
>  #ifndef _V4L2_SUBDEV_H
>  #define _V4L2_SUBDEV_H
>  
> +#include <linux/v4l2-subdev.h>
>  #include <media/media-entity.h>
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-dev.h>
> @@ -419,12 +420,12 @@ struct v4l2_subdev_ir_ops {
>  				struct v4l2_subdev_ir_parameters *params);
>  };
>  
> -enum v4l2_subdev_format_whence {
> -	V4L2_SUBDEV_FORMAT_PROBE = 0,
> -	V4L2_SUBDEV_FORMAT_ACTIVE = 1,
> -};
> -
>  struct v4l2_subdev_pad_ops {
> +	int (*enum_mbus_code)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
> +			      struct v4l2_subdev_mbus_code_enum *code);
> +	int (*enum_frame_size)(struct v4l2_subdev *sd,
> +			       struct v4l2_subdev_fh *fh,
> +			       struct v4l2_subdev_frame_size_enum *fse);
>  	int (*get_fmt)(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
>  		       unsigned int pad, struct v4l2_mbus_framefmt *fmt,

Aren't pads u16 or something like that?

>  		       enum v4l2_subdev_format_whence which);
> 

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
