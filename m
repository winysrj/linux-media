Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:24859 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756697Ab2COJz3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 05:55:29 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M0X003TS7KEHA60@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 09:55:26 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X00K807KB8H@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 09:55:24 +0000 (GMT)
Date: Thu, 15 Mar 2012 10:55:25 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH v5 09/35] v4l: Add subdev selections documentation
In-reply-to: <1331051596-8261-9-git-send-email-sakari.ailus@iki.fi>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	dacohen@gmail.com, snjw23@gmail.com,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com,
	hverkuil@xs4all.nl, teturtia@gmail.com, pradeep.sawlani@gmail.com
Message-id: <4F61BC8D.7060900@samsung.com>
References: <20120306163239.GN1075@valkosipuli.localdomain>
 <1331051596-8261-9-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On 03/06/2012 05:32 PM, Sakari Ailus wrote:
> Add documentation for V4L2 subdev selection API. This changes also
> experimental V4L2 subdev API so that scaling now works through selection API
> only.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/DocBook/media/Makefile               |    4 +-
>  Documentation/DocBook/media/v4l/compat.xml         |    9 +
>  Documentation/DocBook/media/v4l/dev-subdev.xml     |  202 +++++++++++++++--
>  Documentation/DocBook/media/v4l/v4l2.xml           |   17 ++-
>  .../media/v4l/vidioc-subdev-g-selection.xml        |  228 ++++++++++++++++++++
>  5 files changed, 433 insertions(+), 27 deletions(-)
>  cre
ate mode 100644 Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml

[snip]

> diff --git a/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
> new file mode 100644
> index 0000000..9164b85
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/vidioc-subdev-g-selection.xml
> @@ -0,0 +1,228 @@
> +<refentry id="vidioc-subdev-g-selection">
> +  <refmeta>
> +    <refentrytitle>ioctl VIDIOC_SUBDEV_G_SELECTION, VIDIOC_SUBDEV_S_SELECTION</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +
> +  <refnamediv>
> +    <refname>VIDIOC_SUBDEV_G_SELECTION</refname>
> +    <refname>VIDIOC_SUBDEV_S_SELECTION</refname>
> +    <refpurpose>Get or set selection rectangles on a subdev pad</refpurpose>
> +  </refnamediv>
> +
> +  <refsynopsisdiv>
> +    <funcsynopsis>
> +      <funcprototype>
> +	<funcdef>int <function>ioctl</function></funcdef>
> +	<paramdef>int <parameter>fd</parameter></paramdef>
> +	<paramdef>int <parameter>request</parameter></paramdef>
> +	<paramdef>struct v4l2_subdev_selection *<parameter>argp</parameter></paramdef>
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
> +	  <para>VIDIOC_SUBDEV_G_SELECTION, VIDIOC_SUBDEV_S_SELECTION</para>
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
> +      <para>This is an <link linkend="experimental">experimental</link>
> +      interface and may change in the future.</para>
> +    </note>
> +
> +    <para>The selections are used to configure various image
> +    processing functionality performed by the subdevs which affect the
> +    image size. This currently includes cropping, scaling and
> +    composition.</para>
> +
> +    <para>The selection API replaces <link
> +    linkend="vidioc-subdev-g-crop">the old subdev crop API</link>. All
> +    the function of the crop API, and more, are supported by the
> +    selections API.</para>
> +
> +    <para>See <xref linkend="subdev"></xref> for
> +    more information on how each selection target affects the image
> +    processing pipeline inside the subdevice.</para>
> +
> +    <section>
> +      <title>Types of selection targets</title>
> +
> +      <para>There are two types of selection targets: active and bounds.
> +      The ACTIVE targets are the targets which configure the hardware.
> +      The BOUNDS target will return a rectangle that contain all
> +      possible ACTIVE rectangles.</para>
> +    </section>
> +
> +    <section>
> +      <title>Discovering supported features</title>
> +
> +      <para>To discover which targets are supported, the user can
> +      perform <constant>VIDIOC_SUBDEV_G_SELECTION</constant> on them.
> +      Any unsupported target will return
> +      <constant>EINVAL</constant>.</para>
> +    </section>
> +
> +    <table pgwide="1" frame="none" id="v4l2-subdev-selection-targets">
> +      <title>V4L2 subdev selection targets</title>
> +      <tgroup cols="3">
> +        &cs-def;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry><constant>V4L2_SUBDEV_SEL_TGT_CROP_ACTIVE</constant></entry>
> +	    <entry>0x0000</entry>
> +	    <entry>Active crop. Defines the cropping
> +	    performed by the processing step.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_SUBDEV_SEL_TGT_CROP_BOUNDS</constant></entry>
> +	    <entry>0x0002</entry>
> +	    <entry>Bounds of the crop rectangle.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTIVE</constant></entry>
> +	    <entry>0x0100</entry>
> +	    <entry>Active compose rectangle. Used to configure scaling
> +	    on sink pads and composition on source pads.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS</constant></entry>
> +	    <entry>0x0102</entry>
> +	    <entry>Bounds of the compose rectangle.</entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +
> +    <table pgwide="1" frame="none" id="v4l2-subdev-selection-flags">
> +      <title>V4L2 subdev selection flags</title>
> +      <tgroup cols="3">
> +        &cs-def;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry><constant>V4L2_SUBDEV_SEL_FLAG_SIZE_GE</constant></entry>
> +	    <entry>(1 &lt;&lt; 0)</entry> <entry>Suggest the driver it
> +	    should choose greater or equal rectangle (in size) than
> +	    was requested. Albeit the driver may choose a lesser size,
> +	    it will only do so due to hardware limitations. Without
> +	    this flag (and
> +	    <constant>V4L2_SUBDEV_SEL_FLAG_SIZE_LE</constant>) the
> +	    behaviour is to choose the closest possible
> +	    rectangle.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_SUBDEV_SEL_FLAG_SIZE_LE</constant></entry>
> +	    <entry>(1 &lt;&lt; 1)</entry> <entry>Suggest the driver it
> +	    should choose lesser or equal rectangle (in size) than was
> +	    requested. Albeit the driver may choose a greater size, it
> +	    will only do so due to hardware limitations.</entry>
> +	  </row>
> +	  <row>
> +	    <entry><constant>V4L2_SUBDEV_SEL_FLAG_KEEP_CONFIG</constant></entry>
> +	    <entry>(1 &lt;&lt; 2)</entry>
> +	    <entry>The configuration should not be propagated to any
> +	    further processing steps. If this flag is not given, the
> +	    configuration is propagated inside the subdevice to all
> +	    further processing steps.</entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +
> +    <table pgwide="1" frame="none" id="v4l2-subdev-selection">
> +      <title>struct <structname>v4l2_subdev_selection</structname></title>
> +      <tgroup cols="3">
> +        &cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>which</structfield></entry>
> +	    <entry>Active or try selection, from
> +	    &v4l2-subdev-format-whence;.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>pad</structfield></entry>
> +	    <entry>Pad number as reported by the media framework.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>target</structfield></entry>
> +	    <entry>Target selection rectangle. See
> +	    <xref linkend="v4l2-subdev-selection-targets">.</xref>.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>flags</structfield></entry>
> +	    <entry>Flags. See
> +	    <xref linkend="v4l2-subdev-selection-flags">.</xref></entry>
> +	  </row>
> +	  <row>
> +	    <entry>&v4l2-rect;</entry>
> +	    <entry><structfield>rect</structfield></entry>
> +	    <entry>Crop rectangle boundaries, in pixels.</entry>

Shouldn't it be "Selection rectangle, in pixels." ?

> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved</structfield>[8]</entry>
> +	    <entry>Reserved for future extensions. Applications and drivers must
> +	    set the array to zero.</entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +
> +  </refsect1>

--

Regards,
Sylwester

-- 
Sylwester Nawrocki
실베스터 나브로츠키
Samsung Poland R&D Center
