Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:38747 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752611AbcE0Miw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 May 2016 08:38:52 -0400
Subject: Re: [PATCH v2 2/8] [media] Add signed 16-bit pixel format
To: Nick Dyer <nick.dyer@itdev.co.uk>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
References: <1462381638-7818-1-git-send-email-nick.dyer@itdev.co.uk>
 <1462381638-7818-3-git-send-email-nick.dyer@itdev.co.uk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Benson Leung <bleung@chromium.org>,
	Alan Bowens <Alan.Bowens@atmel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Chris Healy <cphealy@gmail.com>,
	Henrik Rydberg <rydberg@bitmath.org>,
	Andrew Duggan <aduggan@synaptics.com>,
	James Chen <james.chen@emc.com.tw>,
	Dudley Du <dudl@cypress.com>,
	Andrew de los Reyes <adlr@chromium.org>,
	sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
	Florian Echtler <floe@butterbrot.org>, mchehab@osg.samsung.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57483FD1.9080704@xs4all.nl>
Date: Fri, 27 May 2016 14:38:41 +0200
MIME-Version: 1.0
In-Reply-To: <1462381638-7818-3-git-send-email-nick.dyer@itdev.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/04/2016 07:07 PM, Nick Dyer wrote:
> This will be used for output of raw touch data.
> 
> Signed-off-by: Nick Dyer <nick.dyer@itdev.co.uk>
> ---
>  Documentation/DocBook/media/v4l/pixfmt-ys16.xml | 79 +++++++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml      |  1 +
>  drivers/media/v4l2-core/v4l2-ioctl.c            |  1 +
>  include/uapi/linux/videodev2.h                  |  1 +
>  4 files changed, 82 insertions(+)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-ys16.xml
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-ys16.xml b/Documentation/DocBook/media/v4l/pixfmt-ys16.xml
> new file mode 100644
> index 0000000..f92d65e
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-ys16.xml
> @@ -0,0 +1,79 @@
> +<refentry id="V4L2-PIX-FMT-YS16">
> +  <refmeta>
> +    <refentrytitle>V4L2_PIX_FMT_YS16 ('YS16')</refentrytitle>
> +    &manvol;
> +  </refmeta>
> +  <refnamediv>
> +    <refname><constant>V4L2_PIX_FMT_YS16</constant></refname>
> +    <refpurpose>Grey-scale image</refpurpose>
> +  </refnamediv>
> +  <refsect1>
> +    <title>Description</title>
> +
> +    <para>This is a signed grey-scale image with a depth of 16 bits per
> +pixel. The most significant byte is stored at higher memory addresses
> +(little-endian).</para>

I'm not sure this should be described in terms of grey-scale, since negative
values make no sense for that. How are these values supposed to be interpreted
if you want to display them? -32768 == black and 32767 is white?

Regards,

	Hans

> +
> +    <example>
> +      <title><constant>V4L2_PIX_FMT_YS16</constant> 4 &times; 4
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
> +		  <entry>Y'<subscript>00low</subscript></entry>
> +		  <entry>Y'<subscript>00high</subscript></entry>
> +		  <entry>Y'<subscript>01low</subscript></entry>
> +		  <entry>Y'<subscript>01high</subscript></entry>
> +		  <entry>Y'<subscript>02low</subscript></entry>
> +		  <entry>Y'<subscript>02high</subscript></entry>
> +		  <entry>Y'<subscript>03low</subscript></entry>
> +		  <entry>Y'<subscript>03high</subscript></entry>
> +		</row>
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;8:</entry>
> +		  <entry>Y'<subscript>10low</subscript></entry>
> +		  <entry>Y'<subscript>10high</subscript></entry>
> +		  <entry>Y'<subscript>11low</subscript></entry>
> +		  <entry>Y'<subscript>11high</subscript></entry>
> +		  <entry>Y'<subscript>12low</subscript></entry>
> +		  <entry>Y'<subscript>12high</subscript></entry>
> +		  <entry>Y'<subscript>13low</subscript></entry>
> +		  <entry>Y'<subscript>13high</subscript></entry>
> +		</row>
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;16:</entry>
> +		  <entry>Y'<subscript>20low</subscript></entry>
> +		  <entry>Y'<subscript>20high</subscript></entry>
> +		  <entry>Y'<subscript>21low</subscript></entry>
> +		  <entry>Y'<subscript>21high</subscript></entry>
> +		  <entry>Y'<subscript>22low</subscript></entry>
> +		  <entry>Y'<subscript>22high</subscript></entry>
> +		  <entry>Y'<subscript>23low</subscript></entry>
> +		  <entry>Y'<subscript>23high</subscript></entry>
> +		</row>
> +		<row>
> +		  <entry>start&nbsp;+&nbsp;24:</entry>
> +		  <entry>Y'<subscript>30low</subscript></entry>
> +		  <entry>Y'<subscript>30high</subscript></entry>
> +		  <entry>Y'<subscript>31low</subscript></entry>
> +		  <entry>Y'<subscript>31high</subscript></entry>
> +		  <entry>Y'<subscript>32low</subscript></entry>
> +		  <entry>Y'<subscript>32high</subscript></entry>
> +		  <entry>Y'<subscript>33low</subscript></entry>
> +		  <entry>Y'<subscript>33high</subscript></entry>
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
> index d871245..6f7aa0e 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -1619,6 +1619,7 @@ information.</para>
>      &sub-y12;
>      &sub-y10b;
>      &sub-y16;
> +    &sub-ys16;
>      &sub-y16-be;
>      &sub-uv8;
>      &sub-yuyv;
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 8a018c6..c7dabaa 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -1154,6 +1154,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
>  	case V4L2_PIX_FMT_Y10:		descr = "10-bit Greyscale"; break;
>  	case V4L2_PIX_FMT_Y12:		descr = "12-bit Greyscale"; break;
>  	case V4L2_PIX_FMT_Y16:		descr = "16-bit Greyscale"; break;
> +	case V4L2_PIX_FMT_YS16:		descr = "16-bit Greyscale (Signed)"; break;
>  	case V4L2_PIX_FMT_Y16_BE:	descr = "16-bit Greyscale BE"; break;
>  	case V4L2_PIX_FMT_Y10BPACK:	descr = "10-bit Greyscale (Packed)"; break;
>  	case V4L2_PIX_FMT_PAL8:		descr = "8-bit Palette"; break;
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 14cd5eb..ab577dd 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -496,6 +496,7 @@ struct v4l2_pix_format {
>  #define V4L2_PIX_FMT_Y12     v4l2_fourcc('Y', '1', '2', ' ') /* 12  Greyscale     */
>  #define V4L2_PIX_FMT_Y16     v4l2_fourcc('Y', '1', '6', ' ') /* 16  Greyscale     */
>  #define V4L2_PIX_FMT_Y16_BE  v4l2_fourcc_be('Y', '1', '6', ' ') /* 16  Greyscale BE  */
> +#define V4L2_PIX_FMT_YS16    v4l2_fourcc('Y', 'S', '1', '6') /* signed 16-bit Greyscale */
>  
>  /* Grey bit-packed formats */
>  #define V4L2_PIX_FMT_Y10BPACK    v4l2_fourcc('Y', '1', '0', 'B') /* 10  Greyscale bit-packed */
> 
