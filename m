Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4470 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab2ICLyW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Sep 2012 07:54:22 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/1] v4l: Remove experimental tag from certain API elements
Date: Mon, 3 Sep 2012 13:54:09 +0200
Cc: linux-media@vger.kernel.org
References: <1346568345-13916-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1346568345-13916-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209031354.09124.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun September 2 2012 08:45:45 Sakari Ailus wrote:
> Remove experimantal tag from the following API elements:
> 
> V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY buffer type.
> V4L2_CAP_VIDEO_OUTPUT_OVERLAY capability flag.
> VIDIOC_ENUM_FRAMESIZES IOCTL.
> VIDIOC_G_ENC_INDEX IOCTL.
> VIDIOC_ENCODER_CMD and VIDIOC_TRY_ENCODER_CMD IOCTLs.
> VIDIOC_DECODER_CMD and VIDIOC_TRY_DECODER_CMD IOCTLs.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Thanks! I'm adding this to my new api branch that will contain more patches
relating to the API ambiguities topic from the workshop.

Regards,

	Hans

> ---
> VIDIOC_ENUM_FRAMEINTERVALS is already no longer experimental.
> 
>  Documentation/DocBook/media/v4l/compat.xml         |   23 --------------------
>  Documentation/DocBook/media/v4l/dev-osd.xml        |    7 ------
>  Documentation/DocBook/media/v4l/io.xml             |    3 +-
>  .../DocBook/media/v4l/vidioc-decoder-cmd.xml       |    7 ------
>  .../DocBook/media/v4l/vidioc-encoder-cmd.xml       |    7 ------
>  .../DocBook/media/v4l/vidioc-enum-framesizes.xml   |    7 ------
>  .../DocBook/media/v4l/vidioc-g-enc-index.xml       |    7 ------
>  7 files changed, 1 insertions(+), 60 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/compat.xml b/Documentation/DocBook/media/v4l/compat.xml
> index 98e8d08..578135e 100644
> --- a/Documentation/DocBook/media/v4l/compat.xml
> +++ b/Documentation/DocBook/media/v4l/compat.xml
> @@ -2555,29 +2555,6 @@ and may change in the future.</para>
>  	  <para>Video Output Overlay (OSD) Interface, <xref
>  	    linkend="osd" />.</para>
>          </listitem>
> -	<listitem>
> -	  <para><constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY</constant>,
> -	&v4l2-buf-type;, <xref linkend="v4l2-buf-type" />.</para>
> -        </listitem>
> -        <listitem>
> -	  <para><constant>V4L2_CAP_VIDEO_OUTPUT_OVERLAY</constant>,
> -&VIDIOC-QUERYCAP; ioctl, <xref linkend="device-capabilities" />.</para>
> -        </listitem>
> -        <listitem>
> -	  <para>&VIDIOC-ENUM-FRAMESIZES; and
> -&VIDIOC-ENUM-FRAMEINTERVALS; ioctls.</para>
> -        </listitem>
> -        <listitem>
> -	  <para>&VIDIOC-G-ENC-INDEX; ioctl.</para>
> -        </listitem>
> -        <listitem>
> -	  <para>&VIDIOC-ENCODER-CMD; and &VIDIOC-TRY-ENCODER-CMD;
> -ioctls.</para>
> -        </listitem>
> -        <listitem>
> -	  <para>&VIDIOC-DECODER-CMD; and &VIDIOC-TRY-DECODER-CMD;
> -ioctls.</para>
> -        </listitem>
>          <listitem>
>  	  <para>&VIDIOC-DBG-G-REGISTER; and &VIDIOC-DBG-S-REGISTER;
>  ioctls.</para>
> diff --git a/Documentation/DocBook/media/v4l/dev-osd.xml b/Documentation/DocBook/media/v4l/dev-osd.xml
> index 479d943..dd91d61 100644
> --- a/Documentation/DocBook/media/v4l/dev-osd.xml
> +++ b/Documentation/DocBook/media/v4l/dev-osd.xml
> @@ -1,13 +1,6 @@
>    <title>Video Output Overlay Interface</title>
>    <subtitle>Also known as On-Screen Display (OSD)</subtitle>
>  
> -  <note>
> -    <title>Experimental</title>
> -
> -    <para>This is an <link linkend="experimental">experimental</link>
> -interface and may change in the future.</para>
> -  </note>
> -
>    <para>Some video output devices can overlay a framebuffer image onto
>  the outgoing video signal. Applications can set up such an overlay
>  using this interface, which borrows structures and ioctls of the <link
> diff --git a/Documentation/DocBook/media/v4l/io.xml b/Documentation/DocBook/media/v4l/io.xml
> index 1885cc0..2512649 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -827,8 +827,7 @@ should set this to 0.</entry>
>  	    <entry><constant>V4L2_BUF_TYPE_VIDEO_OUTPUT_OVERLAY</constant></entry>
>  	    <entry>8</entry>
>  	    <entry>Buffer for video output overlay (OSD), see <xref
> -		linkend="osd" />. Status: <link
> -linkend="experimental">Experimental</link>.</entry>
> +		linkend="osd" />.</entry>
>  	  </row>
>  	  <row>
>  	    <entry><constant>V4L2_BUF_TYPE_PRIVATE</constant></entry>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
> index 74b87f6..9215627 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-decoder-cmd.xml
> @@ -49,13 +49,6 @@
>    <refsect1>
>      <title>Description</title>
>  
> -    <note>
> -      <title>Experimental</title>
> -
> -      <para>This is an <link linkend="experimental">experimental</link>
> -interface and may change in the future.</para>
> -    </note>
> -
>      <para>These ioctls control an audio/video (usually MPEG-) decoder.
>  <constant>VIDIOC_DECODER_CMD</constant> sends a command to the
>  decoder, <constant>VIDIOC_TRY_DECODER_CMD</constant> can be used to
> diff --git a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
> index f431b3b..0619ca5 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-encoder-cmd.xml
> @@ -49,13 +49,6 @@
>    <refsect1>
>      <title>Description</title>
>  
> -    <note>
> -      <title>Experimental</title>
> -
> -      <para>This is an <link linkend="experimental">experimental</link>
> -interface and may change in the future.</para>
> -    </note>
> -
>      <para>These ioctls control an audio/video (usually MPEG-) encoder.
>  <constant>VIDIOC_ENCODER_CMD</constant> sends a command to the
>  encoder, <constant>VIDIOC_TRY_ENCODER_CMD</constant> can be used to
> diff --git a/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml b/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
> index f77a13f..a78454b 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-enum-framesizes.xml
> @@ -50,13 +50,6 @@ and pixel format and receives a frame width and height.</para>
>    <refsect1>
>      <title>Description</title>
>  
> -    <note>
> -      <title>Experimental</title>
> -
> -      <para>This is an <link linkend="experimental">experimental</link>
> -interface and may change in the future.</para>
> -    </note>
> -
>      <para>This ioctl allows applications to enumerate all frame sizes
>  (&ie; width and height in pixels) that the device supports for the
>  given pixel format.</para>
> diff --git a/Documentation/DocBook/media/v4l/vidioc-g-enc-index.xml b/Documentation/DocBook/media/v4l/vidioc-g-enc-index.xml
> index 2aef02c..be25029 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-g-enc-index.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-g-enc-index.xml
> @@ -48,13 +48,6 @@
>    <refsect1>
>      <title>Description</title>
>  
> -    <note>
> -      <title>Experimental</title>
> -
> -      <para>This is an <link linkend="experimental">experimental</link>
> -interface and may change in the future.</para>
> -    </note>
> -
>      <para>The <constant>VIDIOC_G_ENC_INDEX</constant> ioctl provides
>  meta data about a compressed video stream the same or another
>  application currently reads from the driver, which is useful for
> 
