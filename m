Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:50362 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756852AbcAMKZa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jan 2016 05:25:30 -0500
Date: Wed, 13 Jan 2016 12:24:54 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Aviv Greenberg <avivgr@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] V4L: add Y12I, Y8I and Z16 pixel format documentation
Message-ID: <20160113102453.GJ576@valkosipuli.retiisi.org.uk>
References: <Pine.LNX.4.64.1512151732080.18335@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1512151732080.18335@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

A few comments below.

On Tue, Dec 15, 2015 at 05:46:08PM +0100, Guennadi Liakhovetski wrote:
> Add documentation for 3 formats, used by RealSense cameras like R200.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  Documentation/DocBook/media/v4l/pixfmt-y12i.xml | 49 +++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt-y8i.xml  | 80 +++++++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt-z16.xml  | 79 ++++++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml      | 10 ++++
>  4 files changed, 218 insertions(+)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-y12i.xml
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-y8i.xml
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-z16.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-y12i.xml b/Documentation/DocBook/media/v4l/pixfmt-y12i.xml
> new file mode 100644
> index 0000000..443598d
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-y12i.xml
> @@ -0,0 +1,49 @@
> +<refentry id="V4L2-PIX-FMT-Y12I">
> +  <refmeta>
> +    <refentrytitle>V4L2_PIX_FMT_Y12I ('Y12I ')</refentrytitle>

Extra space after 4cc.                        ^

> +    &manvol;
> +  </refmeta>
> +  <refnamediv>
> +    <refname><constant>V4L2_PIX_FMT_Y12I</constant></refname>
> +    <refpurpose>Interleaved grey-scale image, e.g. from a stereo-pair</refpurpose>
> +  </refnamediv>
> +  <refsect1>
> +    <title>Description</title>
> +
> +    <para>This is a grey-scale image with a depth of 12 bits per pixel, but with
> +pixels from 2 sources interleaved and bit-packed. Each pixel is stored in a
> +24-bit word. E.g. data, stored by a R200 RealSense camera on a little-endian
> +machine can be deinterlaced using</para>

I think we should precisely define the format, either big or little. Is the
endianness of the format affected by the machine endianness? (I'd guess no,
but that's just a guess.)

I wonder if the format should convey the information which one is right and
which one is left, e.g. by adding "LR" to the name.

No need to mention RealSense specifically IMO.

> +
> +<para>
> +<programlisting>
> +__u8 *buf;
> +left0 = 0xfff &amp; *(__u16 *)buf;
> +rirhgt0 = *(__u16 *)(buf + 1) >> 4;

"right"

> +</programlisting>
> +</para>
> +
> +    <example>
> +      <title><constant>V4L2_PIX_FMT_Y12I</constant> 2 pixel data stream taking 3 bytes</title>
> +
> +      <formalpara>
> +	<title>Bit-packed representation</title>
> +	<para>pixels cross the byte boundary and have a ratio of 3 bytes for each
> +          interleaved pixel.
> +	  <informaltable frame="all">
> +	    <tgroup cols="3" align="center">
> +	      <colspec align="left" colwidth="2*" />
> +	      <tbody valign="top">
> +		<row>
> +		  <entry>Y'<subscript>0left[7:0]</subscript></entry>
> +		  <entry>Y'<subscript>0right[3:0]</subscript>Y'<subscript>0left[11:8]</subscript></entry>
> +		  <entry>Y'<subscript>0right[11:4]</subscript></entry>
> +		</row>
> +	      </tbody>
> +	    </tgroup>
> +	  </informaltable>
> +	</para>
> +      </formalpara>
> +    </example>
> +  </refsect1>
> +</refentry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-y8i.xml b/Documentation/DocBook/media/v4l/pixfmt-y8i.xml
> new file mode 100644
> index 0000000..99f389d
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-y8i.xml
> @@ -0,0 +1,80 @@
> +<refentry id="V4L2-PIX-FMT-Y8I">
> +  <refmeta>
> +    <refentrytitle>V4L2_PIX_FMT_Y8I ('Y8I ')</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +  <refnamediv>
> +    <refname><constant>V4L2_PIX_FMT_Y8I</constant></refname>
> +    <refpurpose>Interleaved grey-scale image, e.g. from a stereo-pair</refpurpose>
> +  </refnamediv>
> +  <refsect1>
> +    <title>Description</title>
> +
> +    <para>This is a grey-scale image with a depth of 8 bits per pixel, but with
> +pixels from 2 sources interleaved. Each pixel is stored in a 16-bit word. E.g.
> +the R200 RealSense camera stores pixel from the left sensor in lower and from
> +the right sensor in the higher 8 bits.</para>
> +
> +    <example>
> +      <title><constant>V4L2_PIX_FMT_Y8I</constant> 4 &times; 4
> +pixel image</title>
> +
> +      <formalpara>
> +	<title>Byte Order.</title>
> +	<para>Each cell is one byte.
> +	  <informaltable frame="none">
> +	    <tgroup cols="9" align="center">
> +	      <colspec align="left" colwidth="2*" />
> +	      <tbody valign="top">
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;0:</entry>
> +		  <entry>Y'<subscript>00left</subscript></entry>
> +		  <entry>Y'<subscript>00right</subscript></entry>
> +		  <entry>Y'<subscript>01left</subscript></entry>
> +		  <entry>Y'<subscript>01right</subscript></entry>
> +		  <entry>Y'<subscript>02left</subscript></entry>
> +		  <entry>Y'<subscript>02right</subscript></entry>
> +		  <entry>Y'<subscript>03left</subscript></entry>
> +		  <entry>Y'<subscript>03right</subscript></entry>
> +		</row>
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;8:</entry>
> +		  <entry>Y'<subscript>10left</subscript></entry>
> +		  <entry>Y'<subscript>10right</subscript></entry>
> +		  <entry>Y'<subscript>11left</subscript></entry>
> +		  <entry>Y'<subscript>11right</subscript></entry>
> +		  <entry>Y'<subscript>12left</subscript></entry>
> +		  <entry>Y'<subscript>12right</subscript></entry>
> +		  <entry>Y'<subscript>13left</subscript></entry>
> +		  <entry>Y'<subscript>13right</subscript></entry>
> +		</row>
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;16:</entry>
> +		  <entry>Y'<subscript>20left</subscript></entry>
> +		  <entry>Y'<subscript>20right</subscript></entry>
> +		  <entry>Y'<subscript>21left</subscript></entry>
> +		  <entry>Y'<subscript>21right</subscript></entry>
> +		  <entry>Y'<subscript>22left</subscript></entry>
> +		  <entry>Y'<subscript>22right</subscript></entry>
> +		  <entry>Y'<subscript>23left</subscript></entry>
> +		  <entry>Y'<subscript>23right</subscript></entry>
> +		</row>
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;24:</entry>
> +		  <entry>Y'<subscript>30left</subscript></entry>
> +		  <entry>Y'<subscript>30right</subscript></entry>
> +		  <entry>Y'<subscript>31left</subscript></entry>
> +		  <entry>Y'<subscript>31right</subscript></entry>
> +		  <entry>Y'<subscript>32left</subscript></entry>
> +		  <entry>Y'<subscript>32right</subscript></entry>
> +		  <entry>Y'<subscript>33left</subscript></entry>
> +		  <entry>Y'<subscript>33right</subscript></entry>
> +		</row>
> +	      </tbody>
> +	    </tgroup>
> +	  </informaltable>
> +	</para>
> +      </formalpara>
> +    </example>
> +  </refsect1>
> +</refentry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-z16.xml b/Documentation/DocBook/media/v4l/pixfmt-z16.xml
> new file mode 100644
> index 0000000..fac3c68
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-z16.xml
> @@ -0,0 +1,79 @@
> +<refentry id="V4L2-PIX-FMT-Z16">
> +  <refmeta>
> +    <refentrytitle>V4L2_PIX_FMT_Z16 ('Z16 ')</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +  <refnamediv>
> +    <refname><constant>V4L2_PIX_FMT_Z16</constant></refname>
> +    <refpurpose>Interleaved grey-scale image, e.g. from a stereo-pair</refpurpose>
> +  </refnamediv>
> +  <refsect1>
> +    <title>Description</title>
> +
> +    <para>This is a 16-bit format, representing depth data. Each pixel is a
> +distance in mm to the respective point in the image coordinates. Each pixel is
> +stored in a 16-bit word in the little endian byte order.</para>

The format itself looks quite generic but the unit might be specific to the
device. It'd sound silly to add a new format if just the unit is different.

How about re-purpose the colourspace field for depth formats and
add a flag telling the colour space field contains the unit and the unit
prefix. Not something to have in this patch nor patchset though: controls
should gain that as well.

> +
> +    <example>
> +      <title><constant>V4L2_PIX_FMT_Z16</constant> 4 &times; 4
> +pixel image</title>
> +
> +      <formalpara>

I'm not sure there are strict rules for indenting DocBook in kernel, but
this looks a bit funny. Two is being used elsewhere, this is -1.

> +	<title>Byte Order.</title>
> +	<para>Each cell is one byte.
> +	  <informaltable frame="none">
> +	    <tgroup cols="9" align="center">
> +	      <colspec align="left" colwidth="2*" />
> +	      <tbody valign="top">
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;0:</entry>
> +		  <entry>Z<subscript>00low</subscript></entry>
> +		  <entry>Z<subscript>00high</subscript></entry>
> +		  <entry>Z<subscript>01low</subscript></entry>
> +		  <entry>Z<subscript>01high</subscript></entry>
> +		  <entry>Z<subscript>02low</subscript></entry>
> +		  <entry>Z<subscript>02high</subscript></entry>
> +		  <entry>Z<subscript>03low</subscript></entry>
> +		  <entry>Z<subscript>03high</subscript></entry>
> +		</row>
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;8:</entry>
> +		  <entry>Z<subscript>10low</subscript></entry>
> +		  <entry>Z<subscript>10high</subscript></entry>
> +		  <entry>Z<subscript>11low</subscript></entry>
> +		  <entry>Z<subscript>11high</subscript></entry>
> +		  <entry>Z<subscript>12low</subscript></entry>
> +		  <entry>Z<subscript>12high</subscript></entry>
> +		  <entry>Z<subscript>13low</subscript></entry>
> +		  <entry>Z<subscript>13high</subscript></entry>
> +		</row>
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;16:</entry>
> +		  <entry>Z<subscript>20low</subscript></entry>
> +		  <entry>Z<subscript>20high</subscript></entry>
> +		  <entry>Z<subscript>21low</subscript></entry>
> +		  <entry>Z<subscript>21high</subscript></entry>
> +		  <entry>Z<subscript>22low</subscript></entry>
> +		  <entry>Z<subscript>22high</subscript></entry>
> +		  <entry>Z<subscript>23low</subscript></entry>
> +		  <entry>Z<subscript>23high</subscript></entry>
> +		</row>
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;24:</entry>
> +		  <entry>Z<subscript>30low</subscript></entry>
> +		  <entry>Z<subscript>30high</subscript></entry>
> +		  <entry>Z<subscript>31low</subscript></entry>
> +		  <entry>Z<subscript>31high</subscript></entry>
> +		  <entry>Z<subscript>32low</subscript></entry>
> +		  <entry>Z<subscript>32high</subscript></entry>
> +		  <entry>Z<subscript>33low</subscript></entry>
> +		  <entry>Z<subscript>33high</subscript></entry>
> +		</row>
> +	      </tbody>
> +	    </tgroup>
> +	  </informaltable>
> +	</para>
> +      </formalpara>
> +    </example>
> +  </refsect1>
> +</refentry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
> index d871245..9924732 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -1620,6 +1620,8 @@ information.</para>
>      &sub-y10b;
>      &sub-y16;
>      &sub-y16-be;
> +    &sub-y8i;
> +    &sub-y12i;
>      &sub-uv8;
>      &sub-yuyv;
>      &sub-uyvy;
> @@ -1641,6 +1643,14 @@ information.</para>
>      &sub-m420;
>    </section>
>  
> +  <section id="depth-formats">
> +    <title>Depth Formats</title>
> +    <para>Depth data provides distance to points, mapped onto the image plane
> +    </para>
> +
> +    &sub-z16;
> +  </section>
> +
>    <section>
>      <title>Compressed Formats</title>
>  

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
