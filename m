Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271Ab2GaUA7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 16:00:59 -0400
Message-ID: <5018396F.90103@redhat.com>
Date: Tue, 31 Jul 2012 17:00:47 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Ilyes Gouta <ilyes.gouta@gmail.com>
CC: linux-media@vger.kernel.org, Ilyes Gouta <ilyes.gouta@st.com>
Subject: Re: [RESEND,media] v4l2: define V4L2_PIX_FMT_NV16M and V4L2_PIX_FMT_NV24M
 pixel formats
References: <1343763638-7571-1-git-send-email-ilyes.gouta@gmail.com>
In-Reply-To: <1343763638-7571-1-git-send-email-ilyes.gouta@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ilyes,

Em 31-07-2012 16:40, Ilyes Gouta escreveu:
> Define the two new V4L2_PIX_FMT_NV16M (4:2:2 two-buffers) and V4L2_PIX_FMT_NV24M (4:4:4 two-buffers)
> pixel formats, the non-contiguous variants of the existing V4L2_PIX_FMT_NV16 and V4L2_PIX_FMT_NV24 formats.
> 
> Existing h/w IPs, such as decoders, operate on such separate luma and chroma buffers.

We only add new stuff at API when a driver is using, in order to avoid overriding the
Kernel with unused stuff. So, please submit this patch when you're ready to submit
the driver that is using it.

Also, in the particular case of newer pixel formats, it may make sense to submit
a patch to v4l-utils, if the new format(s) is(are) the only one(s) available for
userspace to retrieve the data.

Thanks,
Mauro

> 
> Signed-off-by: Ilyes Gouta <ilyes.gouta@gmail.com>
> ---
>  Documentation/DocBook/media/v4l/pixfmt-nv16m.xml | 166 +++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt-nv24m.xml | 182 +++++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml       |   2 +
>  include/linux/videodev2.h                        |   2 +
>  4 files changed, 352 insertions(+)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-nv24m.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml b/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
> new file mode 100644
> index 0000000..76e48bf
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-nv16m.xml
> @@ -0,0 +1,166 @@
> +    <refentry id="V4L2-PIX-FMT-NV16M">
> +      <refmeta>
> +     <refentrytitle>V4L2_PIX_FMT_NV16M ('NM16')</refentrytitle>
> +	&manvol;
> +      </refmeta>
> +      <refnamediv>
> +     <refname> <constant>V4L2_PIX_FMT_NV16M</constant></refname>
> +     <refpurpose>Variation of <constant>V4L2_PIX_FMT_NV16</constant> with planes
> +	  non contiguous in memory. </refpurpose>
> +      </refnamediv>
> +      <refsect1>
> +	<title>Description</title>
> +
> +     <para>This is a multi-planar, two-plane version of the YUV 4:2:2 format.
> +The three components are separated into two sub-images or planes.
> +<constant>V4L2_PIX_FMT_NV16M</constant> differs from <constant>V4L2_PIX_FMT_NV16
> +</constant> in that the two planes are non-contiguous in memory, i.e. the chroma
> +plane do not necessarily immediately follows the luma plane.
> +The luminance data occupies the first plane. The Y plane has one byte per pixel.
> +In the second plane there is a chrominance data with alternating chroma samples.
> +The CbCr plane has the same width and height, in bytes, as the Y plane (and of the image).
> +Each CbCr pair belongs to two pixels. For example,
> +Cb<subscript>0</subscript>/Cr<subscript>0</subscript> belongs to
> +Y<subscript>00</subscript>, Y'<subscript>01</subscript>. </para>
> +
> +     <para><constant>V4L2_PIX_FMT_NV16M</constant> is intended to be
> +used only in drivers and applications that support the multi-planar API,
> +described in <xref linkend="planar-apis"/>. </para>
> +
> +	<para>If the Y plane has pad bytes after each row, then the
> +CbCr plane has as many pad bytes after its rows.</para>
> +
> +	<example>
> +       <title><constant>V4L2_PIX_FMT_NV16M</constant> 4 &times; 4 pixel image</title>
> +
> +	  <formalpara>
> +	    <title>Byte Order.</title>
> +	    <para>Each cell is one byte.
> +		<informaltable frame="none">
> +		<tgroup cols="5" align="center">
> +		  <colspec align="left" colwidth="2*" />
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry>start0&nbsp;+&nbsp;0:</entry>
> +		      <entry>Y'<subscript>00</subscript></entry>
> +		      <entry>Y'<subscript>01</subscript></entry>
> +		      <entry>Y'<subscript>02</subscript></entry>
> +		      <entry>Y'<subscript>03</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start0&nbsp;+&nbsp;4:</entry>
> +		      <entry>Y'<subscript>10</subscript></entry>
> +		      <entry>Y'<subscript>11</subscript></entry>
> +		      <entry>Y'<subscript>12</subscript></entry>
> +		      <entry>Y'<subscript>13</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start0&nbsp;+&nbsp;8:</entry>
> +		      <entry>Y'<subscript>20</subscript></entry>
> +		      <entry>Y'<subscript>21</subscript></entry>
> +		      <entry>Y'<subscript>22</subscript></entry>
> +		      <entry>Y'<subscript>23</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start0&nbsp;+&nbsp;12:</entry>
> +		      <entry>Y'<subscript>30</subscript></entry>
> +		      <entry>Y'<subscript>31</subscript></entry>
> +		      <entry>Y'<subscript>32</subscript></entry>
> +		      <entry>Y'<subscript>33</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start1&nbsp;+&nbsp;0:</entry>
> +		      <entry>Cb<subscript>00</subscript></entry>
> +		      <entry>Cr<subscript>00</subscript></entry>
> +		      <entry>Cb<subscript>01</subscript></entry>
> +		      <entry>Cr<subscript>01</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start1&nbsp;+&nbsp;4:</entry>
> +		      <entry>Cb<subscript>10</subscript></entry>
> +		      <entry>Cr<subscript>10</subscript></entry>
> +		      <entry>Cb<subscript>11</subscript></entry>
> +		      <entry>Cr<subscript>11</subscript></entry>
> +		    </row>
> +              <row>
> +                <entry>start1&nbsp;+&nbsp;8:</entry>
> +                <entry>Cb<subscript>20</subscript></entry>
> +                <entry>Cr<subscript>20</subscript></entry>
> +                <entry>Cb<subscript>21</subscript></entry>
> +                <entry>Cr<subscript>21</subscript></entry>
> +              </row>
> +              <row>
> +                <entry>start1&nbsp;+&nbsp;12:</entry>
> +                <entry>Cb<subscript>30</subscript></entry>
> +                <entry>Cr<subscript>30</subscript></entry>
> +                <entry>Cb<subscript>31</subscript></entry>
> +                <entry>Cr<subscript>31</subscript></entry>
> +              </row>
> +		  </tbody>
> +		</tgroup>
> +		</informaltable>
> +	      </para>
> +	  </formalpara>
> +
> +	  <formalpara>
> +	    <title>Color Sample Location.</title>
> +	    <para>
> +		<informaltable frame="none">
> +		<tgroup cols="7" align="center">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry></entry>
> +		      <entry>0</entry><entry></entry><entry>1</entry><entry></entry>
> +		      <entry>2</entry><entry></entry><entry>3</entry>
> +		    </row>
> +		    <row>
> +		      <entry>0</entry>
> +		      <entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
> +		      <entry>Y</entry><entry></entry><entry>Y</entry>
> +		    </row>
> +		    <row>
> +		      <entry></entry>
> +		      <entry></entry><entry>C</entry><entry></entry><entry></entry>
> +		      <entry></entry><entry>C</entry><entry></entry>
> +		    </row>
> +		    <row>
> +		      <entry>1</entry>
> +		      <entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
> +		      <entry>Y</entry><entry></entry><entry>Y</entry>
> +		    </row>
> +              <row>
> +                <entry></entry>
> +                <entry></entry><entry>C</entry><entry></entry><entry></entry>
> +                <entry></entry><entry>C</entry><entry></entry>
> +              </row>
> +		    <row>
> +		      <entry>2</entry>
> +		      <entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
> +		      <entry>Y</entry><entry></entry><entry>Y</entry>
> +		    </row>
> +		    <row>
> +		      <entry></entry>
> +		      <entry></entry><entry>C</entry><entry></entry><entry></entry>
> +		      <entry></entry><entry>C</entry><entry></entry>
> +		    </row>
> +		    <row>
> +		      <entry>3</entry>
> +		      <entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
> +		      <entry>Y</entry><entry></entry><entry>Y</entry>
> +		    </row>
> +              <row>
> +                <entry></entry>
> +                <entry></entry><entry>C</entry><entry></entry><entry></entry>
> +                <entry></entry><entry>C</entry><entry></entry>
> +              </row>
> +		  </tbody>
> +		</tgroup>
> +		</informaltable>
> +	      </para>
> +	  </formalpara>
> +	</example>
> +      </refsect1>
> +    </refentry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-nv24m.xml b/Documentation/DocBook/media/v4l/pixfmt-nv24m.xml
> new file mode 100644
> index 0000000..51b06d1
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-nv24m.xml
> @@ -0,0 +1,182 @@
> +    <refentry id="V4L2-PIX-FMT-NV24M">
> +      <refmeta>
> +     <refentrytitle>V4L2_PIX_FMT_NV24M ('NM24')</refentrytitle>
> +	&manvol;
> +      </refmeta>
> +      <refnamediv>
> +     <refname> <constant>V4L2_PIX_FMT_NV24M</constant></refname>
> +     <refpurpose>Variation of <constant>V4L2_PIX_FMT_NV24</constant> with planes
> +	  non contiguous in memory. </refpurpose>
> +      </refnamediv>
> +      <refsect1>
> +	<title>Description</title>
> +
> +     <para>This is a multi-planar, two-plane version of the YUV 4:4:4 format.
> +The three components are separated into two sub-images or planes.
> +<constant>V4L2_PIX_FMT_NV24M</constant> differs from <constant>V4L2_PIX_FMT_NV24
> +</constant> in that the two planes are non-contiguous in memory, i.e. the chroma
> +plane do not necessarily immediately follows the luma plane.
> +The luminance data occupies the first plane. The Y plane has one byte per pixel.
> +In the second plane there is a chrominance data with alternating chroma samples.
> +The CbCr plane has the double of the width (in bytes) and the same height of the
> +Y plane. Each CbCr pair belongs to one pixel. For example,
> +Cb<subscript>0</subscript>/Cr<subscript>0</subscript> belongs to
> +Y'<subscript>00</subscript>. </para>
> +
> +     <para><constant>V4L2_PIX_FMT_NV24M</constant> is intended to be
> +used only in drivers and applications that support the multi-planar API,
> +described in <xref linkend="planar-apis"/>. </para>
> +
> +	<para>If the Y plane has pad bytes after each row, then the
> +CbCr plane has as many pad bytes after its rows.</para>
> +
> +	<example>
> +       <title><constant>V4L2_PIX_FMT_NV24M</constant> 4 &times; 4 pixel image</title>
> +
> +	  <formalpara>
> +	    <title>Byte Order.</title>
> +	    <para>Each cell is one byte.
> +		<informaltable frame="none">
> +		<tgroup cols="5" align="center">
> +		  <colspec align="left" colwidth="2*" />
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry>start0&nbsp;+&nbsp;0:</entry>
> +		      <entry>Y'<subscript>00</subscript></entry>
> +		      <entry>Y'<subscript>01</subscript></entry>
> +		      <entry>Y'<subscript>02</subscript></entry>
> +		      <entry>Y'<subscript>03</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start0&nbsp;+&nbsp;4:</entry>
> +		      <entry>Y'<subscript>10</subscript></entry>
> +		      <entry>Y'<subscript>11</subscript></entry>
> +		      <entry>Y'<subscript>12</subscript></entry>
> +		      <entry>Y'<subscript>13</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start0&nbsp;+&nbsp;8:</entry>
> +		      <entry>Y'<subscript>20</subscript></entry>
> +		      <entry>Y'<subscript>21</subscript></entry>
> +		      <entry>Y'<subscript>22</subscript></entry>
> +		      <entry>Y'<subscript>23</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start0&nbsp;+&nbsp;12:</entry>
> +		      <entry>Y'<subscript>30</subscript></entry>
> +		      <entry>Y'<subscript>31</subscript></entry>
> +		      <entry>Y'<subscript>32</subscript></entry>
> +		      <entry>Y'<subscript>33</subscript></entry>
> +		    </row>
> +		    <row>
> +		      <entry></entry>
> +		    </row>
> +		    <row>
> +		      <entry>start1&nbsp;+&nbsp;0:</entry>
> +		      <entry>Cb<subscript>00</subscript></entry>
> +		      <entry>Cr<subscript>00</subscript></entry>
> +		      <entry>Cb<subscript>01</subscript></entry>
> +		      <entry>Cr<subscript>01</subscript></entry>
> +                <entry>Cb<subscript>02</subscript></entry>
> +                <entry>Cr<subscript>02</subscript></entry>
> +                <entry>Cb<subscript>03</subscript></entry>
> +                <entry>Cr<subscript>03</subscript></entry>
> +		    </row>
> +		    <row>
> +                <entry>start1&nbsp;+&nbsp;8:</entry>
> +		      <entry>Cb<subscript>10</subscript></entry>
> +		      <entry>Cr<subscript>10</subscript></entry>
> +		      <entry>Cb<subscript>11</subscript></entry>
> +		      <entry>Cr<subscript>11</subscript></entry>
> +                <entry>Cb<subscript>12</subscript></entry>
> +                <entry>Cr<subscript>12</subscript></entry>
> +                <entry>Cb<subscript>13</subscript></entry>
> +                <entry>Cr<subscript>13</subscript></entry>
> +		    </row>
> +              <row>
> +                <entry>start1&nbsp;+&nbsp;16:</entry>
> +                <entry>Cb<subscript>20</subscript></entry>
> +                <entry>Cr<subscript>20</subscript></entry>
> +                <entry>Cb<subscript>21</subscript></entry>
> +                <entry>Cr<subscript>21</subscript></entry>
> +                <entry>Cb<subscript>22</subscript></entry>
> +                <entry>Cr<subscript>22</subscript></entry>
> +                <entry>Cb<subscript>23</subscript></entry>
> +                <entry>Cr<subscript>23</subscript></entry>
> +              </row>
> +              <row>
> +                <entry>start1&nbsp;+&nbsp;24:</entry>
> +                <entry>Cb<subscript>30</subscript></entry>
> +                <entry>Cr<subscript>30</subscript></entry>
> +                <entry>Cb<subscript>31</subscript></entry>
> +                <entry>Cr<subscript>31</subscript></entry>
> +                <entry>Cb<subscript>32</subscript></entry>
> +                <entry>Cr<subscript>32</subscript></entry>
> +                <entry>Cb<subscript>33</subscript></entry>
> +                <entry>Cr<subscript>33</subscript></entry>
> +              </row>
> +		  </tbody>
> +		</tgroup>
> +		</informaltable>
> +	      </para>
> +	  </formalpara>
> +
> +	  <formalpara>
> +	    <title>Color Sample Location.</title>
> +	    <para>
> +		<informaltable frame="none">
> +		<tgroup cols="7" align="center">
> +		  <tbody valign="top">
> +		    <row>
> +		      <entry></entry>
> +		      <entry>0</entry><entry></entry><entry>1</entry><entry></entry>
> +		      <entry>2</entry><entry></entry><entry>3</entry>
> +		    </row>
> +		    <row>
> +		      <entry>0</entry>
> +		      <entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
> +		      <entry>Y</entry><entry></entry><entry>Y</entry>
> +		    </row>
> +		    <row>
> +		      <entry></entry>
> +                <entry>C</entry><entry></entry><entry>C</entry><entry></entry>
> +                <entry>C</entry><entry></entry><entry>C</entry>
> +		    </row>
> +		    <row>
> +		      <entry>1</entry>
> +		      <entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
> +		      <entry>Y</entry><entry></entry><entry>Y</entry>
> +		    </row>
> +              <row>
> +                <entry></entry>
> +                <entry>C</entry><entry></entry><entry>C</entry><entry></entry>
> +                <entry>C</entry><entry></entry><entry>C</entry>
> +              </row>
> +		    <row>
> +		      <entry>2</entry>
> +		      <entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
> +		      <entry>Y</entry><entry></entry><entry>Y</entry>
> +		    </row>
> +              <row>
> +                <entry></entry>
> +                <entry>C</entry><entry></entry><entry>C</entry><entry></entry>
> +                <entry>C</entry><entry></entry><entry>C</entry>
> +              </row>
> +		    <row>
> +		      <entry>3</entry>
> +		      <entry>Y</entry><entry></entry><entry>Y</entry><entry></entry>
> +		      <entry>Y</entry><entry></entry><entry>Y</entry>
> +              </row>
> +              <row>
> +                <entry></entry>
> +                <entry>C</entry><entry></entry><entry>C</entry><entry></entry>
> +                <entry>C</entry><entry></entry><entry>C</entry>
> +              </row>
> +		  </tbody>
> +		</tgroup>
> +		</informaltable>
> +	      </para>
> +	  </formalpara>
> +	</example>
> +      </refsect1>
> +    </refentry>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
> index e58934c..24e33db 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -713,6 +713,8 @@ information.</para>
>      &sub-yuv411p;
>      &sub-nv12;
>      &sub-nv12m;
> +    &sub-nv16m;
> +    &sub-nv24m;
>      &sub-nv12mt;
>      &sub-nv16;
>      &sub-nv24;
> diff --git a/include/linux/videodev2.h b/include/linux/videodev2.h
> index 5d78910..618bf50 100644
> --- a/include/linux/videodev2.h
> +++ b/include/linux/videodev2.h
> @@ -360,6 +360,8 @@ struct v4l2_pix_format {
>  
>  /* two non contiguous planes - one Y, one Cr + Cb interleaved  */
>  #define V4L2_PIX_FMT_NV12M   v4l2_fourcc('N', 'M', '1', '2') /* 12  Y/CbCr 4:2:0  */
> +#define V4L2_PIX_FMT_NV16M   v4l2_fourcc('N', 'M', '1', '6') /* 16  Y/CbCr 4:2:2  */
> +#define V4L2_PIX_FMT_NV24M   v4l2_fourcc('N', 'M', '2', '4') /* 24  Y/CbCr 4:4:4  */
>  #define V4L2_PIX_FMT_NV12MT  v4l2_fourcc('T', 'M', '1', '2') /* 12  Y/CbCr 4:2:0 64x32 macroblocks */
>  
>  /* three non contiguous planes - Y, Cb, Cr */
> 

