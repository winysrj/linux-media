Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab2B1LBG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Feb 2012 06:01:06 -0500
Message-ID: <4F4CB3ED.3080509@redhat.com>
Date: Tue, 28 Feb 2012 08:01:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 4/6] V4L2 spec: document the new V4L2 DV timings
 ioctls.
References: <1328263566-21620-1-git-send-email-hverkuil@xs4all.nl> <fdc4106fec26b04be848f3e0147bc635691d8f87.1328262332.git.hans.verkuil@cisco.com>
In-Reply-To: <fdc4106fec26b04be848f3e0147bc635691d8f87.1328262332.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 03-02-2012 08:06, Hans Verkuil escreveu:
> From: Hans Verkuil <hans.verkuil@cisco.com>

The comments for patch 1 apply here. So, I won't repeat myself ;) There's just one
minor comment below.

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/DocBook/media/v4l/v4l2.xml           |    3 +
>  .../DocBook/media/v4l/vidioc-dv-timings-cap.xml    |  205 ++++++++++++++++++++
>  .../DocBook/media/v4l/vidioc-enum-dv-timings.xml   |  113 +++++++++++
>  .../DocBook/media/v4l/vidioc-g-dv-timings.xml      |  120 +++++++++++-
>  .../DocBook/media/v4l/vidioc-query-dv-timings.xml  |   98 ++++++++++
>  5 files changed, 531 insertions(+), 8 deletions(-)
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
>  create mode 100644 Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index dce3fef..8bc2ccd 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -481,10 +481,12 @@ and discussions on the V4L mailing list.</revremark>
>      &sub-dbg-g-chip-ident;
>      &sub-dbg-g-register;
>      &sub-dqevent;
> +    &sub-dv-timings-cap;
>      &sub-encoder-cmd;
>      &sub-enumaudio;
>      &sub-enumaudioout;
>      &sub-enum-dv-presets;
> +    &sub-enum-dv-timings;
>      &sub-enum-fmt;
>      &sub-enum-framesizes;
>      &sub-enum-frameintervals;
> @@ -519,6 +521,7 @@ and discussions on the V4L mailing list.</revremark>
>      &sub-querycap;
>      &sub-queryctrl;
>      &sub-query-dv-preset;
> +    &sub-query-dv-timings;
>      &sub-querystd;
>      &sub-prepare-buf;
>      &sub-reqbufs;
> diff --git a/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
> new file mode 100644
> index 0000000..0477de1
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/vidioc-dv-timings-cap.xml
> @@ -0,0 +1,205 @@
> +<refentry id="vidioc-dv-timings-cap">
> +  <refmeta>
> +    <refentrytitle>ioctl VIDIOC_DV_TIMINGS_CAP</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +
> +  <refnamediv>
> +    <refname>VIDIOC_DV_TIMINGS_CAP</refname>
> +    <refpurpose>The capabilities of the Digital Video receiver/transmitter</refpurpose>
> +  </refnamediv>
> +
> +  <refsynopsisdiv>
> +    <funcsynopsis>
> +      <funcprototype>
> +	<funcdef>int <function>ioctl</function></funcdef>
> +	<paramdef>int <parameter>fd</parameter></paramdef>
> +	<paramdef>int <parameter>request</parameter></paramdef>
> +	<paramdef>struct v4l2_dv_timings_cap *<parameter>argp</parameter></paramdef>
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
> +	  <para>VIDIOC_DV_TIMINGS_CAP</para>
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
> +    <para>To query the available timings, applications initialize the
> +<structfield>index</structfield> field and zero the reserved array of &v4l2-dv-timings-cap;
> +and call the <constant>VIDIOC_DV_TIMINGS_CAP</constant> ioctl with a pointer to this
> +structure. Drivers fill the rest of the structure or return an
> +&EINVAL; when the index is out of bounds. To enumerate all supported DV timings,
> +applications shall begin at index zero, incrementing by one until the
> +driver returns <errorcode>EINVAL</errorcode>. Note that drivers may enumerate a
> +different set of DV timings after switching the video input or
> +output.</para>
> +
> +    <table pgwide="1" frame="none" id="v4l2-bt-timings-cap">
> +      <title>struct <structname>v4l2_bt_timings_cap</structname></title>
> +      <tgroup cols="3">
> +	&cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>min_width</structfield></entry>
> +	    <entry>Minimum width of the active video in pixels.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>max_width</structfield></entry>
> +	    <entry>Maximum width of the active video in pixels.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>min_height</structfield></entry>
> +	    <entry>Minimum height of the active video in lines.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>max_height</structfield></entry>
> +	    <entry>Maximum height of the active video in lines.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u64</entry>
> +	    <entry><structfield>min_pixelclock</structfield></entry>
> +	    <entry>Minimum pixelclock frequency in Hz.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u64</entry>
> +	    <entry><structfield>max_pixelclock</structfield></entry>
> +	    <entry>Maximum pixelclock frequency in Hz.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>standards</structfield></entry>
> +	    <entry>The video standard(s) supported by the hardware.
> +	    See <xref linkend="dv-bt-standards"/> for a list of standards.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>capabilities</structfield></entry>
> +	    <entry>Several flags giving more information about the capabilities.
> +	    See <xref linkend="dv-bt-cap-capabilities"/> for a description of the flags.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved</structfield>[16]</entry>
> +	    <entry></entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +
> +    <table pgwide="1" frame="none" id="v4l2-dv-timings-cap">
> +      <title>struct <structname>v4l2_dv_timings_cap</structname></title>
> +      <tgroup cols="4">
> +	&cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>type</structfield></entry>
> +	    <entry>Type of DV timings as listed in <xref linkend="dv-timing-types"/>.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved</structfield>[3]</entry>
> +	    <entry>Reserved for future extensions. Drivers must set the array to zero.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>union</entry>
> +	    <entry><structfield></structfield></entry>
> +	    <entry></entry>
> +	  </row>
> +	  <row>
> +	    <entry></entry>
> +	    <entry>&v4l2-bt-timings-cap;</entry>
> +	    <entry><structfield>bt</structfield></entry>
> +	    <entry>BT.656/1120 timings capabilities of the hardware.</entry>
> +	  </row>
> +	  <row>
> +	    <entry></entry>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>raw_data</structfield>[32]</entry>
> +	    <entry></entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +
> +    <table pgwide="1" frame="none" id="dv-bt-cap-capabilities">
> +      <title>DV BT Timing capabilities</title>
> +      <tgroup cols="2">
> +	&cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>Flag</entry>
> +	    <entry>Description</entry>
> +	  </row>
> +	  <row>
> +	    <entry></entry>
> +	    <entry></entry>
> +	  </row>
> +	  <row>
> +	    <entry>V4L2_DV_BT_CAP_INTERLACED</entry>
> +	    <entry>Interlaced formats are supported.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry>V4L2_DV_BT_CAP_PROGRESSIVE</entry>
> +	    <entry>Progressive formats are supported.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry>V4L2_DV_BT_CAP_REDUCED_BLANKING</entry>
> +	    <entry>CVT/GTF specific: the timings can make use of reduced blanking (CVT)
> +or the 'Secondary GTF' curve (GTF).
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry>V4L2_DV_BT_CAP_CUSTOM</entry>
> +	    <entry>Can support non-standard timings, i.e. timings not belonging to the
> +standards set in the <structfield>standards</structfield> field.
> +	    </entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +  </refsect1>
> +
> +  <refsect1>
> +    &return-value;
> +  </refsect1>
> +</refentry>
> +
> +<!--
> +Local Variables:
> +mode: sgml
> +sgml-parent-document: "v4l2.sgml"
> +indent-tabs-mode: nil
> +End:
> +-->
> diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
> new file mode 100644
> index 0000000..edd6964
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/vidioc-enum-dv-timings.xml
> @@ -0,0 +1,113 @@
> +<refentry id="vidioc-enum-dv-timings">
> +  <refmeta>
> +    <refentrytitle>ioctl VIDIOC_ENUM_DV_TIMINGS</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +
> +  <refnamediv>
> +    <refname>VIDIOC_ENUM_DV_TIMINGS</refname>
> +    <refpurpose>Enumerate supported Digital Video timings</refpurpose>
> +  </refnamediv>
> +
> +  <refsynopsisdiv>
> +    <funcsynopsis>
> +      <funcprototype>
> +	<funcdef>int <function>ioctl</function></funcdef>
> +	<paramdef>int <parameter>fd</parameter></paramdef>
> +	<paramdef>int <parameter>request</parameter></paramdef>
> +	<paramdef>struct v4l2_enum_dv_timings *<parameter>argp</parameter></paramdef>
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
> +	  <para>VIDIOC_ENUM_DV_TIMINGS</para>
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
> +    <para>While some DV receivers or transmitters support a wide range of timings, others
> +support only a limited number of timings. With this ioctl applications can enumerate a list
> +of known supported timings. Call &VIDIOC-DV-TIMINGS-CAP; to check if it also supports other
> +standards or even custom timings that are not in this list.</para>
> +
> +    <para>To query the available timings, applications initialize the
> +<structfield>index</structfield> field and zero the reserved array of &v4l2-enum-dv-timings;
> +and call the <constant>VIDIOC_ENUM_DV_TIMINGS</constant> ioctl with a pointer to this
> +structure. Drivers fill the rest of the structure or return an
> +&EINVAL; when the index is out of bounds. To enumerate all supported DV timings,
> +applications shall begin at index zero, incrementing by one until the
> +driver returns <errorcode>EINVAL</errorcode>. Note that drivers may enumerate a
> +different set of DV timings after switching the video input or
> +output.</para>
> +
> +    <table pgwide="1" frame="none" id="v4l2-enum-dv-timings">
> +      <title>struct <structname>v4l2_enum_dv_timings</structname></title>
> +      <tgroup cols="3">
> +	&cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>index</structfield></entry>
> +	    <entry>Number of the DV timings, set by the
> +application.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>reserved</structfield>[3]</entry>
> +	    <entry>Reserved for future extensions. Drivers must set the array to zero.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>&v4l2-dv-timings;</entry>
> +	    <entry><structfield>timings</structfield></entry>
> +	    <entry>The timings.</entry>
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
> +	  <para>The &v4l2-enum-dv-timings; <structfield>index</structfield>
> +is out of bounds.</para>
> +	</listitem>
> +      </varlistentry>
> +    </variablelist>
> +  </refsect1>
> +</refentry>
> +


> +<!--
> +Local Variables:
> +mode: sgml
> +sgml-parent-document: "v4l2.sgml"
> +indent-tabs-mode: nil
> +End:
> +-->

Don't insert editor-specific parameters at the file! That violates CodingStyle.


> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
> index 4a8648a..bffd26c 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-dv-timings.xml
> @@ -83,12 +83,13 @@ or the timing values are not correct, the driver returns &EINVAL;.</para>
>  	  <row>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>width</structfield></entry>
> -	    <entry>Width of the active video in pixels</entry>
> +	    <entry>Width of the active video in pixels.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>height</structfield></entry>
> -	    <entry>Height of the active video in lines</entry>
> +	    <entry>Height of the active video frame in lines. So for interlaced formats the
> +	    height of the active video in each field is <structfield>height</structfield>/2.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
> @@ -125,32 +126,52 @@ bit 0 (V4L2_DV_VSYNC_POS_POL) is for vertical sync polarity and bit 1 (V4L2_DV_H
>  	  <row>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>vfrontporch</structfield></entry>
> -	    <entry>Vertical front porch in lines</entry>
> +	    <entry>Vertical front porch in lines. For interlaced formats this refers to the
> +	    odd field (aka field 1).</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>vsync</structfield></entry>
> -	    <entry>Vertical sync length in lines</entry>
> +	    <entry>Vertical sync length in lines. For interlaced formats this refers to the
> +	    odd field (aka field 1).</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>vbackporch</structfield></entry>
> -	    <entry>Vertical back porch in lines</entry>
> +	    <entry>Vertical back porch in lines. For interlaced formats this refers to the
> +	    odd field (aka field 1).</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>il_vfrontporch</structfield></entry>
> -	    <entry>Vertical front porch in lines for bottom field of interlaced field formats</entry>
> +	    <entry>Vertical front porch in lines for the even field (aka field 2) of
> +	    interlaced field formats.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>il_vsync</structfield></entry>
> -	    <entry>Vertical sync length in lines for bottom field of interlaced field formats</entry>
> +	    <entry>Vertical sync length in lines for the even field (aka field 2) of
> +	    interlaced field formats.</entry>
>  	  </row>
>  	  <row>
>  	    <entry>__u32</entry>
>  	    <entry><structfield>il_vbackporch</structfield></entry>
> -	    <entry>Vertical back porch in lines for bottom field of interlaced field formats</entry>
> +	    <entry>Vertical back porch in lines for the even field (aka field 2) of
> +	    interlaced field formats.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>standards</structfield></entry>
> +	    <entry>The video standard(s) this format belongs to. This will be filled in by
> +	    the driver. Applications must set this to 0. See <xref linkend="dv-bt-standards"/>
> +	    for a list of standards.</entry>
> +	  </row>
> +	  <row>
> +	    <entry>__u32</entry>
> +	    <entry><structfield>flags</structfield></entry>
> +	    <entry>Several flags giving more information about the format.
> +	    See <xref linkend="dv-bt-flags"/> for a description of the flags.
> +	    </entry>
>  	  </row>
>  	</tbody>
>        </tgroup>
> @@ -211,6 +232,89 @@ bit 0 (V4L2_DV_VSYNC_POS_POL) is for vertical sync polarity and bit 1 (V4L2_DV_H
>  	</tbody>
>        </tgroup>
>      </table>
> +    <table pgwide="1" frame="none" id="dv-bt-standards">
> +      <title>DV BT Timing standards</title>
> +      <tgroup cols="2">
> +	&cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>Timing standard</entry>
> +	    <entry>Description</entry>
> +	  </row>
> +	  <row>
> +	    <entry></entry>
> +	    <entry></entry>
> +	  </row>
> +	  <row>
> +	    <entry>V4L2_DV_BT_STD_CEA861</entry>
> +	    <entry>The timings follow the CEA-861 Digital TV Profile standard</entry>
> +	  </row>
> +	  <row>
> +	    <entry>V4L2_DV_BT_STD_DMT</entry>
> +	    <entry>The timings follow the VESA Discrete Monitor Timings standard</entry>
> +	  </row>
> +	  <row>
> +	    <entry>V4L2_DV_BT_STD_CVT</entry>
> +	    <entry>The timings follow the VESA Coordinated Video Timings standard</entry>
> +	  </row>
> +	  <row>
> +	    <entry>V4L2_DV_BT_STD_GTF</entry>
> +	    <entry>The timings follow the VESA Generalized Timings Formula standard</entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +    <table pgwide="1" frame="none" id="dv-bt-flags">
> +      <title>DV BT Timing flags</title>
> +      <tgroup cols="2">
> +	&cs-str;
> +	<tbody valign="top">
> +	  <row>
> +	    <entry>Flag</entry>
> +	    <entry>Description</entry>
> +	  </row>
> +	  <row>
> +	    <entry></entry>
> +	    <entry></entry>
> +	  </row>
> +	  <row>
> +	    <entry>V4L2_DV_FL_REDUCED_BLANKING</entry>
> +	    <entry>CVT/GTF specific: the timings use reduced blanking (CVT) or the 'Secondary
> +GTF' curve (GTF). In both cases the horizontal and/or vertical blanking
> +intervals are reduced, allowing a higher resolution over the same
> +bandwidth. This is a read-only flag, applications must not set this.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry>V4L2_DV_FL_NTSC_COMPATIBLE</entry>
> +	    <entry>CEA-861 specific: set for CEA-861 formats with a framerate of a multiple
> +of six. These formats can be optionally played at 1 / 1.001 speed to
> +be compatible with the normal NTSC framerate of 29.97 frames per second.
> +This is a read-only flag, applications must not set this.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry>V4L2_DV_FL_DIVIDE_CLOCK_BY_1_001</entry>
> +	    <entry>CEA-861 specific: only valid for video transmitters, the flag is cleared
> +by receivers. It is also only valid for formats with the V4L2_DV_FL_NTSC_COMPATIBLE flag
> +set, for other formats the flag will be cleared by the driver.
> +
> +If the application sets this flag, then the pixelclock used to set up the transmitter is
> +divided by 1.001 to make it compatible with NTSC framerates. If the transmitter
> +can't generate such frequencies, then the flag will also be cleared.
> +	    </entry>
> +	  </row>
> +	  <row>
> +	    <entry>V4L2_DV_FL_HALF_LINE</entry>
> +	    <entry>Specific to interlaced formats: if set, then field 1 (aka the odd field)
> +is really one half-line longer and field 2 (aka the even field) is really one half-line
> +shorter, so each field has exactly the same number of half-lines. Whether half-lines can be
> +detected or used depends on the hardware.
> +	    </entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
>    </refsect1>
>    <refsect1>
>      &return-value;
> diff --git a/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml b/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
> new file mode 100644
> index 0000000..9d7ac43
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/vidioc-query-dv-timings.xml
> @@ -0,0 +1,98 @@
> +<refentry id="vidioc-query-dv-timings">
> +  <refmeta>
> +    <refentrytitle>ioctl VIDIOC_QUERY_DV_TIMINGS</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +
> +  <refnamediv>
> +    <refname>VIDIOC_QUERY_DV_TIMINGS</refname>
> +    <refpurpose>Sense the DV preset received by the current
> +input</refpurpose>
> +  </refnamediv>
> +
> +  <refsynopsisdiv>
> +    <funcsynopsis>
> +      <funcprototype>
> +	<funcdef>int <function>ioctl</function></funcdef>
> +	<paramdef>int <parameter>fd</parameter></paramdef>
> +	<paramdef>int <parameter>request</parameter></paramdef>
> +	<paramdef>struct v4l2_dv_timings *<parameter>argp</parameter></paramdef>
> +      </funcprototype>
> +    </funcsynopsis>
> +  </refsynopsisdiv>
> +
> +  <refsect1>
> +    <title>Arguments</title>
> +
> +    <variablelist>
> +	<varlistentry>
> +	<term><parameter>fd</parameter></term>
> +	<listitem>
> +	  <para>&fd;</para>
> +	</listitem>
> +      </varlistentry>
> +      <varlistentry>
> +	<term><parameter>request</parameter></term>
> +	<listitem>
> +	  <para>VIDIOC_QUERY_DV_TIMINGS</para>
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
> +    <para>The hardware may be able to detect the current DV timings
> +automatically, similar to sensing the video standard. To do so, applications
> +call <constant>VIDIOC_QUERY_DV_TIMINGS</constant> with a pointer to a
> +&v4l2-dv-timings;. Once the hardware detects the timings, it will fill in the
> +timings structure.
> +
> +If the timings could not be detected because there was no signal, then
> +<errorcode>ENOLINK</errorcode> is returned. If a signal was detected, but
> +it was unstable and the receiver could not lock to the signal, then
> +<errorcode>ENOLCK</errorcode> is returned. If the receiver could lock to the signal,
> +but the format is unsupported (e.g. because the pixelclock is out of range
> +of the hardware capabilities), then the driver fills in whatever timings it
> +could find and returns <errorcode>ERANGE</errorcode>. In that case the application
> +can call &VIDIOC-DV-TIMINGS-CAP; to compare the found timings with the hardware's
> +capabilities in order to give more precise feedback to the user.
> +</para>
> +  </refsect1>
> +
> +  <refsect1>
> +    &return-value;
> +
> +    <variablelist>
> +      <varlistentry>
> +	<term><errorcode>ENOLINK</errorcode></term>
> +	<listitem>
> +	  <para>No timings could be detected because no signal was found.
> +</para>
> +	</listitem>
> +      </varlistentry>
> +      <varlistentry>
> +	<term><errorcode>ENOLCK</errorcode></term>
> +	<listitem>
> +	  <para>The signal was unstable and the hardware could not lock on to it.
> +</para>
> +	</listitem>
> +      </varlistentry>
> +      <varlistentry>
> +	<term><errorcode>ERANGE</errorcode></term>
> +	<listitem>
> +	  <para>Timings were found, but they are out of range of the hardware
> +capabilities.
> +</para>
> +	</listitem>
> +      </varlistentry>
> +    </variablelist>
> +  </refsect1>
> +</refentry>

