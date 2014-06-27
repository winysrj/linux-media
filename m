Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2035 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaF0JeX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 05:34:23 -0400
Message-ID: <53AD3A97.1000800@xs4all.nl>
Date: Fri, 27 Jun 2014 11:34:15 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org
CC: linux-sh@vger.kernel.org
Subject: Re: [PATCH v2 01/23] v4l: Add ARGB and XRGB pixel formats
References: <1403567669-18539-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1403567669-18539-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1403567669-18539-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

On 06/24/2014 01:54 AM, Laurent Pinchart wrote:
> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>
> The existing RGB pixel formats are ill-defined in respect to their alpha
> bits and their meaning is driver dependent. Create new standard ARGB and
> XRGB variants with clearly defined meanings and make the existing
> variants deprecated.
>
> The new pixel formats 4CC values have been selected to match the DRM
> 4CCs for the same in-memory formats.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>   .../DocBook/media/v4l/pixfmt-packed-rgb.xml        | 415 ++++++++++++++++++++-
>   include/uapi/linux/videodev2.h                     |   8 +
>   2 files changed, 403 insertions(+), 20 deletions(-)
>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> index e1c4f8b..5f1602f 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> @@ -130,9 +130,9 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
>   	    <entry>b<subscript>1</subscript></entry>
>   	    <entry>b<subscript>0</subscript></entry>
>   	  </row>
> -	  <row id="V4L2-PIX-FMT-RGB444">
> -	    <entry><constant>V4L2_PIX_FMT_RGB444</constant></entry>
> -	    <entry>'R444'</entry>
> +	  <row id="V4L2-PIX-FMT-ARGB444">
> +	    <entry><constant>V4L2_PIX_FMT_ARGB444</constant></entry>
> +	    <entry>'AR12'</entry>
>   	    <entry></entry>
>   	    <entry>g<subscript>3</subscript></entry>
>   	    <entry>g<subscript>2</subscript></entry>
> @@ -152,9 +152,31 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
>   	    <entry>r<subscript>1</subscript></entry>
>   	    <entry>r<subscript>0</subscript></entry>
>   	  </row>
> -	  <row id="V4L2-PIX-FMT-RGB555">
> -	    <entry><constant>V4L2_PIX_FMT_RGB555</constant></entry>
> -	    <entry>'RGBO'</entry>
> +	  <row id="V4L2-PIX-FMT-XRGB444">
> +	    <entry><constant>V4L2_PIX_FMT_XRGB444</constant></entry>
> +	    <entry>'XR12'</entry>
> +	    <entry></entry>
> +	    <entry>g<subscript>3</subscript></entry>
> +	    <entry>g<subscript>2</subscript></entry>
> +	    <entry>g<subscript>1</subscript></entry>
> +	    <entry>g<subscript>0</subscript></entry>
> +	    <entry>b<subscript>3</subscript></entry>
> +	    <entry>b<subscript>2</subscript></entry>
> +	    <entry>b<subscript>1</subscript></entry>
> +	    <entry>b<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>r<subscript>3</subscript></entry>
> +	    <entry>r<subscript>2</subscript></entry>
> +	    <entry>r<subscript>1</subscript></entry>
> +	    <entry>r<subscript>0</subscript></entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-ARGB555">
> +	    <entry><constant>V4L2_PIX_FMT_ARGB555</constant></entry>
> +	    <entry>'AR15'</entry>
>   	    <entry></entry>
>   	    <entry>g<subscript>2</subscript></entry>
>   	    <entry>g<subscript>1</subscript></entry>
> @@ -174,6 +196,28 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
>   	    <entry>g<subscript>4</subscript></entry>
>   	    <entry>g<subscript>3</subscript></entry>
>   	  </row>
> +	  <row id="V4L2-PIX-FMT-XRGB555">
> +	    <entry><constant>V4L2_PIX_FMT_XRGB555</constant></entry>
> +	    <entry>'XR15'</entry>
> +	    <entry></entry>
> +	    <entry>g<subscript>2</subscript></entry>
> +	    <entry>g<subscript>1</subscript></entry>
> +	    <entry>g<subscript>0</subscript></entry>
> +	    <entry>b<subscript>4</subscript></entry>
> +	    <entry>b<subscript>3</subscript></entry>
> +	    <entry>b<subscript>2</subscript></entry>
> +	    <entry>b<subscript>1</subscript></entry>
> +	    <entry>b<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>-</entry>
> +	    <entry>r<subscript>4</subscript></entry>
> +	    <entry>r<subscript>3</subscript></entry>
> +	    <entry>r<subscript>2</subscript></entry>
> +	    <entry>r<subscript>1</subscript></entry>
> +	    <entry>r<subscript>0</subscript></entry>
> +	    <entry>g<subscript>4</subscript></entry>
> +	    <entry>g<subscript>3</subscript></entry>
> +	  </row>
>   	  <row id="V4L2-PIX-FMT-RGB565">
>   	    <entry><constant>V4L2_PIX_FMT_RGB565</constant></entry>
>   	    <entry>'RGBP'</entry>
> @@ -341,9 +385,9 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
>   	    <entry>b<subscript>1</subscript></entry>
>   	    <entry>b<subscript>0</subscript></entry>
>   	  </row>
> -	  <row id="V4L2-PIX-FMT-BGR32">
> -	    <entry><constant>V4L2_PIX_FMT_BGR32</constant></entry>
> -	    <entry>'BGR4'</entry>
> +	  <row id="V4L2-PIX-FMT-ABGR32">
> +	    <entry><constant>V4L2_PIX_FMT_ABGR32</constant></entry>
> +	    <entry>'AR24'</entry>
>   	    <entry></entry>
>   	    <entry>b<subscript>7</subscript></entry>
>   	    <entry>b<subscript>6</subscript></entry>
> @@ -381,9 +425,49 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
>   	    <entry>a<subscript>1</subscript></entry>
>   	    <entry>a<subscript>0</subscript></entry>
>   	  </row>
> -	  <row id="V4L2-PIX-FMT-RGB32">
> -	    <entry><constant>V4L2_PIX_FMT_RGB32</constant></entry>
> -	    <entry>'RGB4'</entry>
> +	  <row id="V4L2-PIX-FMT-XBGR32">
> +	    <entry><constant>V4L2_PIX_FMT_XBGR32</constant></entry>
> +	    <entry>'XR24'</entry>
> +	    <entry></entry>
> +	    <entry>b<subscript>7</subscript></entry>
> +	    <entry>b<subscript>6</subscript></entry>
> +	    <entry>b<subscript>5</subscript></entry>
> +	    <entry>b<subscript>4</subscript></entry>
> +	    <entry>b<subscript>3</subscript></entry>
> +	    <entry>b<subscript>2</subscript></entry>
> +	    <entry>b<subscript>1</subscript></entry>
> +	    <entry>b<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>g<subscript>7</subscript></entry>
> +	    <entry>g<subscript>6</subscript></entry>
> +	    <entry>g<subscript>5</subscript></entry>
> +	    <entry>g<subscript>4</subscript></entry>
> +	    <entry>g<subscript>3</subscript></entry>
> +	    <entry>g<subscript>2</subscript></entry>
> +	    <entry>g<subscript>1</subscript></entry>
> +	    <entry>g<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>r<subscript>7</subscript></entry>
> +	    <entry>r<subscript>6</subscript></entry>
> +	    <entry>r<subscript>5</subscript></entry>
> +	    <entry>r<subscript>4</subscript></entry>
> +	    <entry>r<subscript>3</subscript></entry>
> +	    <entry>r<subscript>2</subscript></entry>
> +	    <entry>r<subscript>1</subscript></entry>
> +	    <entry>r<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-ARGB32">
> +	    <entry><constant>V4L2_PIX_FMT_ARGB32</constant></entry>
> +	    <entry>'AX24'</entry>
>   	    <entry></entry>
>   	    <entry>a<subscript>7</subscript></entry>
>   	    <entry>a<subscript>6</subscript></entry>
> @@ -421,18 +505,76 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
>   	    <entry>b<subscript>1</subscript></entry>
>   	    <entry>b<subscript>0</subscript></entry>
>   	  </row>
> +	  <row id="V4L2-PIX-FMT-XRGB32">
> +	    <entry><constant>V4L2_PIX_FMT_XRGB32</constant></entry>
> +	    <entry>'BX24'</entry>
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
> +	    <entry>r<subscript>7</subscript></entry>
> +	    <entry>r<subscript>6</subscript></entry>
> +	    <entry>r<subscript>5</subscript></entry>
> +	    <entry>r<subscript>4</subscript></entry>
> +	    <entry>r<subscript>3</subscript></entry>
> +	    <entry>r<subscript>2</subscript></entry>
> +	    <entry>r<subscript>1</subscript></entry>
> +	    <entry>r<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>g<subscript>7</subscript></entry>
> +	    <entry>g<subscript>6</subscript></entry>
> +	    <entry>g<subscript>5</subscript></entry>
> +	    <entry>g<subscript>4</subscript></entry>
> +	    <entry>g<subscript>3</subscript></entry>
> +	    <entry>g<subscript>2</subscript></entry>
> +	    <entry>g<subscript>1</subscript></entry>
> +	    <entry>g<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>b<subscript>7</subscript></entry>
> +	    <entry>b<subscript>6</subscript></entry>
> +	    <entry>b<subscript>5</subscript></entry>
> +	    <entry>b<subscript>4</subscript></entry>
> +	    <entry>b<subscript>3</subscript></entry>
> +	    <entry>b<subscript>2</subscript></entry>
> +	    <entry>b<subscript>1</subscript></entry>
> +	    <entry>b<subscript>0</subscript></entry>
> +	  </row>
>   	</tbody>
>         </tgroup>
>       </table>
>
> -    <para>Bit 7 is the most significant bit. The value of the a = alpha
> -bits is undefined when reading from the driver, ignored when writing
> -to the driver, except when alpha blending has been negotiated for a
> -<link linkend="overlay">Video Overlay</link> or <link linkend="osd">
> -Video Output Overlay</link> or when the alpha component has been configured
> -for a <link linkend="capture">Video Capture</link> by means of <link
> -linkend="v4l2-alpha-component"> <constant>V4L2_CID_ALPHA_COMPONENT
> -</constant> </link> control.</para>
> +    <para>Bit 7 is the most significant bit.</para>
> +
> +    <para>The usage and value of the alpha bits (a) in the ARGB and ABGR formats
> +    (collectively referred to as alpha formats) depend on the device type and
> +    hardware operation. <link linkend="capture">Capture</link> devices
> +    (including capture queues of mem-to-mem devices) fill the alpha component in
> +    memory. When the device outputs an alpha channel the alpha component will
> +    have a meaningful value. Otherwise, when the device doesn't output an alpha
> +    channel but can set the alpha bit to a user-configurable value, the <link
> +    linkend="v4l2-alpha-component"><constant>V4L2_CID_ALPHA_COMPONENT</constant>
> +    </link> control is used to specify that alpha value, and the alpha component
> +    of all pixels will be set to the value specified by that control. Otherwise
> +    a corresponding format without an alpha component (XRGB or XBGR) must be
> +    used instead of an alpha format.</para>
> +
> +    <para><link linkend="output">Output</link> devices (including output queues
> +    of mem-to-mem devices and <link linkend="osd">video output overlay</link>
> +    devices) read the alpha component from memory. When the device processes the
> +    alpha channel the alpha component must be filled with meaningful values by
> +    applications. Otherwise a corresponding format without an alpha component
> +    (XRGB or XBGR) must be used instead of an alpha format.</para>
> +
> +    <para>The XRGB and XBGR formats contain undefined bits (-). Applications,
> +    devices and drivers must ignore those bits, for both <link
> +    linkend="capture">capture</link> and <link linkend="output">output</link>
> +    devices.</para>
>
>       <example>
>         <title><constant>V4L2_PIX_FMT_BGR24</constant> 4 &times; 4 pixel
> @@ -512,6 +654,239 @@ image</title>
>         </formalpara>
>       </example>
>
> +    <para>Formats defined in <xref linkend="rgb-formats-deprecated"/> are
> +    deprecated and must not be used by new drivers. They are documented here for
> +    reference. The meaning of their alpha bits (a) is ill-defined and
> +    interpreted as in either the corresponding ARGB or XRGB format, depending on
> +    the driver.</para>
> +
> +    <table pgwide="1" frame="none" id="rgb-formats-deprecated">
> +      <title>Deprecated Packed RGB Image Formats</title>
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
> +	<tbody>
> +	  <row id="V4L2-PIX-FMT-RGB444">
> +	    <entry><constant>V4L2_PIX_FMT_RGB444</constant></entry>
> +	    <entry>'R444'</entry>
> +	    <entry></entry>
> +	    <entry>g<subscript>3</subscript></entry>
> +	    <entry>g<subscript>2</subscript></entry>
> +	    <entry>g<subscript>1</subscript></entry>
> +	    <entry>g<subscript>0</subscript></entry>
> +	    <entry>b<subscript>3</subscript></entry>
> +	    <entry>b<subscript>2</subscript></entry>
> +	    <entry>b<subscript>1</subscript></entry>
> +	    <entry>b<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>a<subscript>3</subscript></entry>
> +	    <entry>a<subscript>2</subscript></entry>
> +	    <entry>a<subscript>1</subscript></entry>
> +	    <entry>a<subscript>0</subscript></entry>
> +	    <entry>r<subscript>3</subscript></entry>
> +	    <entry>r<subscript>2</subscript></entry>
> +	    <entry>r<subscript>1</subscript></entry>
> +	    <entry>r<subscript>0</subscript></entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-RGB555">
> +	    <entry><constant>V4L2_PIX_FMT_RGB555</constant></entry>
> +	    <entry>'RGBO'</entry>
> +	    <entry></entry>
> +	    <entry>g<subscript>2</subscript></entry>
> +	    <entry>g<subscript>1</subscript></entry>
> +	    <entry>g<subscript>0</subscript></entry>
> +	    <entry>b<subscript>4</subscript></entry>
> +	    <entry>b<subscript>3</subscript></entry>
> +	    <entry>b<subscript>2</subscript></entry>
> +	    <entry>b<subscript>1</subscript></entry>
> +	    <entry>b<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>a</entry>
> +	    <entry>r<subscript>4</subscript></entry>
> +	    <entry>r<subscript>3</subscript></entry>
> +	    <entry>r<subscript>2</subscript></entry>
> +	    <entry>r<subscript>1</subscript></entry>
> +	    <entry>r<subscript>0</subscript></entry>
> +	    <entry>g<subscript>4</subscript></entry>
> +	    <entry>g<subscript>3</subscript></entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-BGR32">
> +	    <entry><constant>V4L2_PIX_FMT_BGR32</constant></entry>
> +	    <entry>'BGR4'</entry>
> +	    <entry></entry>
> +	    <entry>b<subscript>7</subscript></entry>
> +	    <entry>b<subscript>6</subscript></entry>
> +	    <entry>b<subscript>5</subscript></entry>
> +	    <entry>b<subscript>4</subscript></entry>
> +	    <entry>b<subscript>3</subscript></entry>
> +	    <entry>b<subscript>2</subscript></entry>
> +	    <entry>b<subscript>1</subscript></entry>
> +	    <entry>b<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>g<subscript>7</subscript></entry>
> +	    <entry>g<subscript>6</subscript></entry>
> +	    <entry>g<subscript>5</subscript></entry>
> +	    <entry>g<subscript>4</subscript></entry>
> +	    <entry>g<subscript>3</subscript></entry>
> +	    <entry>g<subscript>2</subscript></entry>
> +	    <entry>g<subscript>1</subscript></entry>
> +	    <entry>g<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>r<subscript>7</subscript></entry>
> +	    <entry>r<subscript>6</subscript></entry>
> +	    <entry>r<subscript>5</subscript></entry>
> +	    <entry>r<subscript>4</subscript></entry>
> +	    <entry>r<subscript>3</subscript></entry>
> +	    <entry>r<subscript>2</subscript></entry>
> +	    <entry>r<subscript>1</subscript></entry>
> +	    <entry>r<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>a<subscript>7</subscript></entry>
> +	    <entry>a<subscript>6</subscript></entry>
> +	    <entry>a<subscript>5</subscript></entry>
> +	    <entry>a<subscript>4</subscript></entry>
> +	    <entry>a<subscript>3</subscript></entry>
> +	    <entry>a<subscript>2</subscript></entry>
> +	    <entry>a<subscript>1</subscript></entry>
> +	    <entry>a<subscript>0</subscript></entry>
> +	  </row>
> +	  <row id="V4L2-PIX-FMT-RGB32">
> +	    <entry><constant>V4L2_PIX_FMT_RGB32</constant></entry>
> +	    <entry>'RGB4'</entry>
> +	    <entry></entry>
> +	    <entry>a<subscript>7</subscript></entry>
> +	    <entry>a<subscript>6</subscript></entry>
> +	    <entry>a<subscript>5</subscript></entry>
> +	    <entry>a<subscript>4</subscript></entry>
> +	    <entry>a<subscript>3</subscript></entry>
> +	    <entry>a<subscript>2</subscript></entry>
> +	    <entry>a<subscript>1</subscript></entry>
> +	    <entry>a<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>r<subscript>7</subscript></entry>
> +	    <entry>r<subscript>6</subscript></entry>
> +	    <entry>r<subscript>5</subscript></entry>
> +	    <entry>r<subscript>4</subscript></entry>
> +	    <entry>r<subscript>3</subscript></entry>
> +	    <entry>r<subscript>2</subscript></entry>
> +	    <entry>r<subscript>1</subscript></entry>
> +	    <entry>r<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>g<subscript>7</subscript></entry>
> +	    <entry>g<subscript>6</subscript></entry>
> +	    <entry>g<subscript>5</subscript></entry>
> +	    <entry>g<subscript>4</subscript></entry>
> +	    <entry>g<subscript>3</subscript></entry>
> +	    <entry>g<subscript>2</subscript></entry>
> +	    <entry>g<subscript>1</subscript></entry>
> +	    <entry>g<subscript>0</subscript></entry>
> +	    <entry></entry>
> +	    <entry>b<subscript>7</subscript></entry>
> +	    <entry>b<subscript>6</subscript></entry>
> +	    <entry>b<subscript>5</subscript></entry>
> +	    <entry>b<subscript>4</subscript></entry>
> +	    <entry>b<subscript>3</subscript></entry>
> +	    <entry>b<subscript>2</subscript></entry>
> +	    <entry>b<subscript>1</subscript></entry>
> +	    <entry>b<subscript>0</subscript></entry>
> +	  </row>
> +	</tbody>
> +      </tgroup>
> +    </table>
> +
>       <para>A test utility to determine which RGB formats a driver
>   actually supports is available from the LinuxTV v4l-dvb repository.
>   See &v4l-dvb; for access instructions.</para>
> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
> index 168ff50..0125f4d 100644
> --- a/include/uapi/linux/videodev2.h
> +++ b/include/uapi/linux/videodev2.h
> @@ -294,7 +294,11 @@ struct v4l2_pix_format {
>   /* RGB formats */
>   #define V4L2_PIX_FMT_RGB332  v4l2_fourcc('R', 'G', 'B', '1') /*  8  RGB-3-3-2     */
>   #define V4L2_PIX_FMT_RGB444  v4l2_fourcc('R', '4', '4', '4') /* 16  xxxxrrrr ggggbbbb */
> +#define V4L2_PIX_FMT_ARGB444 v4l2_fourcc('A', 'R', '1', '2') /* 16  aaaarrrr ggggbbbb */
> +#define V4L2_PIX_FMT_XRGB444 v4l2_fourcc('X', 'R', '1', '2') /* 16  xxxxrrrr ggggbbbb */
>   #define V4L2_PIX_FMT_RGB555  v4l2_fourcc('R', 'G', 'B', 'O') /* 16  RGB-5-5-5     */
> +#define V4L2_PIX_FMT_ARGB555 v4l2_fourcc('A', 'R', '1', '5') /* 16  ARGB-1-5-5-5  */
> +#define V4L2_PIX_FMT_XRGB555 v4l2_fourcc('X', 'R', '1', '5') /* 16  XRGB-1-5-5-5  */
>   #define V4L2_PIX_FMT_RGB565  v4l2_fourcc('R', 'G', 'B', 'P') /* 16  RGB-5-6-5     */
>   #define V4L2_PIX_FMT_RGB555X v4l2_fourcc('R', 'G', 'B', 'Q') /* 16  RGB-5-5-5 BE  */
>   #define V4L2_PIX_FMT_RGB565X v4l2_fourcc('R', 'G', 'B', 'R') /* 16  RGB-5-6-5 BE  */
> @@ -302,7 +306,11 @@ struct v4l2_pix_format {
>   #define V4L2_PIX_FMT_BGR24   v4l2_fourcc('B', 'G', 'R', '3') /* 24  BGR-8-8-8     */
>   #define V4L2_PIX_FMT_RGB24   v4l2_fourcc('R', 'G', 'B', '3') /* 24  RGB-8-8-8     */
>   #define V4L2_PIX_FMT_BGR32   v4l2_fourcc('B', 'G', 'R', '4') /* 32  BGR-8-8-8-8   */
> +#define V4L2_PIX_FMT_ABGR32  v4l2_fourcc('A', 'R', '2', '4') /* 32  BGRA-8-8-8-8  */
> +#define V4L2_PIX_FMT_XBGR32  v4l2_fourcc('X', 'R', '2', '4') /* 32  BGRX-8-8-8-8  */
>   #define V4L2_PIX_FMT_RGB32   v4l2_fourcc('R', 'G', 'B', '4') /* 32  RGB-8-8-8-8   */
> +#define V4L2_PIX_FMT_ARGB32  v4l2_fourcc('B', 'A', '2', '4') /* 32  ARGB-8-8-8-8  */
> +#define V4L2_PIX_FMT_XRGB32  v4l2_fourcc('B', 'X', '2', '4') /* 32  XRGB-8-8-8-8  */
>
>   /* Grey formats */
>   #define V4L2_PIX_FMT_GREY    v4l2_fourcc('G', 'R', 'E', 'Y') /*  8  Greyscale     */
>
