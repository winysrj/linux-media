Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:36352 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbcGOP2w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 11:28:52 -0400
Date: Fri, 15 Jul 2016 12:28:45 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] [media] Documentation: Add HSV format
Message-ID: <20160715122845.7f357277@recife.lan>
In-Reply-To: <1468595816-31272-3-git-send-email-ricardo.ribalda@gmail.com>
References: <1468595816-31272-1-git-send-email-ricardo.ribalda@gmail.com>
	<1468595816-31272-3-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

I'm not seeing patch 1.

Anyway, please send documentation patches against the rst files. They're
at the "docs-next" branch and will be merged upstream on this merge window.

After its merge, we'll drop the DocBook.

Thanks,
Mauro

Em Fri, 15 Jul 2016 17:16:52 +0200
Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> escreveu:

> Describe the HSV formats.
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  .../DocBook/media/v4l/pixfmt-packed-hsv.xml        | 195 +++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml         |  13 ++
>  Documentation/DocBook/media/v4l/v4l2.xml           |   8 +
>  3 files changed, 216 insertions(+)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-packed-hsv.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-hsv.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-hsv.xml
> new file mode 100644
> index 000000000000..3b41d567e32b
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-packed-hsv.xml
> @@ -0,0 +1,195 @@
> +<refentry id="packed-hsv">
> +  <refmeta>
> +    <refentrytitle>Packed HSV formats</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +  <refnamediv>
> +    <refname>Packed HSV formats</refname>
> +    <refpurpose>Packed HSV formats</refpurpose>
> +  </refnamediv>
> +  <refsect1>
> +    <title>Description</title>
> +
> +    <para>The HUE (h) is meassured in degrees, one LSB represents two
> +degrees. The SATURATION (s) and the VALUE (v) are meassured in percentage
> +of the cylinder: 0 being the smallest value and 255 the maximum.</para>
> +    <para>The values are packed in 24 or 32 bit formats. </para>
> +
> +    <table pgwide="1" frame="none">
> +      <title>Packed YUV Image Formats</title>
> +      <tgroup cols="37" align="center">
> +	<colspec colname="id" align="left" />
> +	<colspec colname="fourcc" />
> +	<colspec colname="bit" />
> +
> +	<colspec colnum="4" colname="b07" align="center" />
> +	<colspec colnum="5" colname="b06" align="center" />
> +	<colspec colnum="6" colname="b05" align="center" />
> +	<colspec colnum="7" colname="b04" align="center" />
> +	<colspec colnum="8" colname="b03" align="center" />
> +	<colspec colnum="9" colname="b02" align="center" />
> +	<colspec colnum="10" colname="b01" align="center" />
> +	<colspec colnum="11" colname="b00" align="center" />
> +
> +	<colspec colnum="13" colname="b17" align="center" />
> +	<colspec colnum="14" colname="b16" align="center" />
> +	<colspec colnum="15" colname="b15" align="center" />
> +	<colspec colnum="16" colname="b14" align="center" />
> +	<colspec colnum="17" colname="b13" align="center" />
> +	<colspec colnum="18" colname="b12" align="center" />
> +	<colspec colnum="19" colname="b11" align="center" />
> +	<colspec colnum="20" colname="b10" align="center" />
> +
> +	<colspec colnum="22" colname="b27" align="center" />
> +	<colspec colnum="23" colname="b26" align="center" />
> +	<colspec colnum="24" colname="b25" align="center" />
> +	<colspec colnum="25" colname="b24" align="center" />
> +	<colspec colnum="26" colname="b23" align="center" />
> +	<colspec colnum="27" colname="b22" align="center" />
> +	<colspec colnum="28" colname="b21" align="center" />
> +	<colspec colnum="29" colname="b20" align="center" />
> +
> +	<colspec colnum="31" colname="b37" align="center" />
> +	<colspec colnum="32" colname="b36" align="center" />
> +	<colspec colnum="33" colname="b35" align="center" />
> +	<colspec colnum="34" colname="b34" align="center" />
> +	<colspec colnum="35" colname="b33" align="center" />
> +	<colspec colnum="36" colname="b32" align="center" />
> +	<colspec colnum="37" colname="b31" align="center" />
> +	<colspec colnum="38" colname="b30" align="center" />
> +
> +	<spanspec namest="b07" nameend="b00" spanname="b0" />
> +	<spanspec namest="b17" nameend="b10" spanname="b1" />
> +	<spanspec namest="b27" nameend="b20" spanname="b2" />
> +	<spanspec namest="b37" nameend="b30" spanname="b3" />
> +	<thead>
> +	  <row>
> +	    <entry>Identifier</entry>
> +	    <entry>Code</entry>
> +	    <entry>&nbsp;</entry>
> +	    <entry spanname="b0">Byte&nbsp;0 in memory</entry>
> +	    <entry spanname="b1">Byte&nbsp;1</entry>
> +	    <entry spanname="b2">Byte&nbsp;2</entry>
> +	    <entry spanname="b3">Byte&nbsp;3</entry>
> +	  </row>
> +	  <row>
> +	    <entry>&nbsp;</entry>
> +	    <entry>&nbsp;</entry>
> +	    <entry>Bit</entry>
> +	    <entry>7</entry>
> +	    <entry>6</entry>
> +	    <entry>5</entry>
> +	    <entry>4</entry>
> +	    <entry>3</entry>
> +	    <entry>2</entry>
> +	    <entry>1</entry>
> +	    <entry>0</entry>
> +	    <entry>&nbsp;</entry>
> +	    <entry>7</entry>
> +	    <entry>6</entry>
> +	    <entry>5</entry>
> +	    <entry>4</entry>
> +	    <entry>3</entry>
> +	    <entry>2</entry>
> +	    <entry>1</entry>
> +	    <entry>0</entry>
> +	    <entry>&nbsp;</entry>
> +	    <entry>7</entry>
> +	    <entry>6</entry>
> +	    <entry>5</entry>
> +	    <entry>4</entry>
> +	    <entry>3</entry>
> +	    <entry>2</entry>
> +	    <entry>1</entry>
> +	    <entry>0</entry>
> +	    <entry>&nbsp;</entry>
> +	    <entry>7</entry>
> +	    <entry>6</entry>
> +	    <entry>5</entry>
> +	    <entry>4</entry>
> +	    <entry>3</entry>
> +	    <entry>2</entry>
> +	    <entry>1</entry>
> +	    <entry>0</entry>
> +	  </row>
> +	</thead>
> +	<tbody valign="top">
> +	  <row id="V4L2-PIX-FMT-HSV32">
> +	    <entry><constant>V4L2_PIX_FMT_HSV32</constant></entry>
> +	    <entry>'HSV4'</entry>
> +	    <entry></entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry></entry>
> +	    <entry>h<subscript>7</subscript></entry>
> +	    <entry>h<subscript>6</subscript></entry>
> +	    <entry>h<subscript>5</subscript></entry>
> +	    <entry>h<subscript>4</subscript></entry>
> +	    <entry>h<subscript>3</subscript></entry>
> +	    <entry>h<subscript>2</subscript></entry>
> +	    <entry>h<subscript>1</subscript></entry>
> +	    <entry>h<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>s<subscript>7</subscript></entry>
> +	    <entry>s<subscript>6</subscript></entry>
> +	    <entry>s<subscript>5</subscript></entry>
> +	    <entry>s<subscript>4</subscript></entry>
> +	    <entry>s<subscript>3</subscript></entry>
> +	    <entry>s<subscript>2</subscript></entry>
> +	    <entry>s<subscript>1</subscript></entry>
> +	    <entry>s<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>v<subscript>7</subscript></entry>
> +	    <entry>v<subscript>6</subscript></entry>
> +	    <entry>v<subscript>5</subscript></entry>
> +	    <entry>v<subscript>4</subscript></entry>
> +	    <entry>v<subscript>3</subscript></entry>
> +	    <entry>v<subscript>2</subscript></entry>
> +	    <entry>v<subscript>1</subscript></entry>
> +	    <entry>v<subscript>0</subscript></entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-HSV24">
> +	    <entry><constant>V4L2_PIX_FMT_HSV24</constant></entry>
> +	    <entry>'HSV3'</entry>
> +	    <entry></entry>
> +	    <entry>h<subscript>7</subscript></entry>
> +	    <entry>h<subscript>6</subscript></entry>
> +	    <entry>h<subscript>5</subscript></entry>
> +	    <entry>h<subscript>4</subscript></entry>
> +	    <entry>h<subscript>3</subscript></entry>
> +	    <entry>h<subscript>2</subscript></entry>
> +	    <entry>h<subscript>1</subscript></entry>
> +	    <entry>h<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>s<subscript>7</subscript></entry>
> +	    <entry>s<subscript>6</subscript></entry>
> +	    <entry>s<subscript>5</subscript></entry>
> +	    <entry>s<subscript>4</subscript></entry>
> +	    <entry>s<subscript>3</subscript></entry>
> +	    <entry>s<subscript>2</subscript></entry>
> +	    <entry>s<subscript>1</subscript></entry>
> +	    <entry>s<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>v<subscript>7</subscript></entry>
> +	    <entry>v<subscript>6</subscript></entry>
> +	    <entry>v<subscript>5</subscript></entry>
> +	    <entry>v<subscript>4</subscript></entry>
> +	    <entry>v<subscript>3</subscript></entry>
> +	    <entry>v<subscript>2</subscript></entry>
> +	    <entry>v<subscript>1</subscript></entry>
> +	    <entry>v<subscript>0</subscript></entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +
> +    <para>Bit 7 is the most significant bit.</para>
> +
> +  </refsect1>
> +    </refentry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
> index 5a08aeea4360..7b081a6bdc61 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -1740,6 +1740,19 @@ extended control <constant>V4L2_CID_MPEG_STREAM_TYPE</constant>, see
>      </table>
>    </section>
>  
> +  <section id="hsv-formats">
> +    <title>HSV Formats</title>
> +
> +    <para> These formats store the color information of the image
> +in a geometrical representation. The colors are mapped into a
> +cylinder, where the angle is the HUE, the height is the VALUE
> +and the distance to the center is the SATURATION. This is a very
> +useful format for image segmentation algorithms. </para>
> +
> +    &packed-hsv;
> +
> +  </section>
> +
>    <section id="sdr-formats">
>      <title>SDR Formats</title>
>  
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index 42e626d6c936..f38039b7c338 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -152,6 +152,14 @@ structs, ioctls) must be noted in more detail in the history chapter
>  (compat.xml), along with the possible impact on existing drivers and
>  applications. -->
>        <revision>
> +	<revnumber>4.8</revnumber>
> +	<date>2016-07-15</date>
> +	<authorinitials>rr</authorinitials>
> +	<revremark> Introduce HSV formats.
> +	</revremark>
> +      </revision>
> +
> +      <revision>
>  	<revnumber>4.5</revnumber>
>  	<date>2015-10-29</date>
>  	<authorinitials>rr</authorinitials>


-- 
Thanks,
Mauro
