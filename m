Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:53148 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754505AbaKNI3u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 03:29:50 -0500
Message-ID: <5465BD6F.8030208@xs4all.nl>
Date: Fri, 14 Nov 2014 09:29:35 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] v4l: Clean up sub-device format documentation
References: <1415487872-27500-1-git-send-email-sakari.ailus@iki.fi> <1415487872-27500-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1415487872-27500-2-git-send-email-sakari.ailus@iki.fi>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Two small notes...

On 11/09/2014 12:04 AM, Sakari Ailus wrote:
> The sub-device format documentation documented scaling configuration through
> formats. Instead the compose selection rectangle is elsewhere documented to
> be used for the purpose. Remove scaling related part of the documentation.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  Documentation/DocBook/media/v4l/dev-subdev.xml |  108 ++++++++++++++----------
>  1 file changed, 62 insertions(+), 46 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/dev-subdev.xml b/Documentation/DocBook/media/v4l/dev-subdev.xml
> index d15aaf8..dbf9965 100644
> --- a/Documentation/DocBook/media/v4l/dev-subdev.xml
> +++ b/Documentation/DocBook/media/v4l/dev-subdev.xml
> @@ -195,53 +195,59 @@
>  	<title>Sample Pipeline Configuration</title>
>  	<tgroup cols="3">
>  	  <colspec colname="what"/>
> -	  <colspec colname="sensor-0" />
> -	  <colspec colname="frontend-0" />
> -	  <colspec colname="frontend-1" />
> -	  <colspec colname="scaler-0" />
> -	  <colspec colname="scaler-1" />
> +	  <colspec colname="sensor-0 format" />
> +	  <colspec colname="frontend-0 format" />
> +	  <colspec colname="frontend-1 format" />
> +	  <colspec colname="scaler-0 format" />
> +	  <colspec colname="scaler-0 compose" />
> +	  <colspec colname="scaler-1 format" />
>  	  <thead>
>  	    <row>
>  	      <entry></entry>
> -	      <entry>Sensor/0</entry>
> -	      <entry>Frontend/0</entry>
> -	      <entry>Frontend/1</entry>
> -	      <entry>Scaler/0</entry>
> -	      <entry>Scaler/1</entry>
> +	      <entry>Sensor/0 format</entry>
> +	      <entry>Frontend/0 format</entry>
> +	      <entry>Frontend/1 format</entry>
> +	      <entry>Scaler/0 format</entry>
> +	      <entry>Scaler/0 compose selection rectangle</entry>
> +	      <entry>Scaler/1 format</entry>
>  	    </row>
>  	  </thead>
>  	  <tbody valign="top">
>  	    <row>
>  	      <entry>Initial state</entry>
> -	      <entry>2048x1536</entry>
> -	      <entry>-</entry>
> -	      <entry>-</entry>
> -	      <entry>-</entry>
> -	      <entry>-</entry>
> +	      <entry>2048x1536/SGRBG8_1X8</entry>
> +	      <entry>(default)</entry>
> +	      <entry>(default)</entry>
> +	      <entry>(default)</entry>
> +	      <entry>(default)</entry>
> +	      <entry>(default)</entry>
>  	    </row>
>  	    <row>
> -	      <entry>Configure frontend input</entry>
> -	      <entry>2048x1536</entry>
> -	      <entry><emphasis>2048x1536</emphasis></entry>
> -	      <entry><emphasis>2046x1534</emphasis></entry>
> -	      <entry>-</entry>
> -	      <entry>-</entry>
> +	      <entry>Configure frontend sink format</entry>
> +	      <entry>2048x1536/SGRBG8_1X8</entry>
> +	      <entry><emphasis>2048x1536/SGRBG8_1X8</emphasis></entry>
> +	      <entry><emphasis>2046x1534/SGRBG8_1X8</emphasis></entry>
> +	      <entry>(default)</entry>
> +	      <entry>(default)</entry>
> +	      <entry>(default)</entry>
>  	    </row>
>  	    <row>
> -	      <entry>Configure scaler input</entry>
> -	      <entry>2048x1536</entry>
> -	      <entry>2048x1536</entry>
> -	      <entry>2046x1534</entry>
> -	      <entry><emphasis>2046x1534</emphasis></entry>
> -	      <entry><emphasis>2046x1534</emphasis></entry>
> +	      <entry>Configure scaler sink format</entry>
> +	      <entry>2048x1536/SGRBG8_1X8</entry>
> +	      <entry>2048x1536/SGRBG8_1X8</entry>
> +	      <entry>2046x1534/SGRBG8_1X8</entry>
> +	      <entry><emphasis>2046x1534/SGRBG8_1X8</emphasis></entry>
> +	      <entry><emphasis>0,0/2046x1534</emphasis></entry>
> +	      <entry><emphasis>2046x1534/SGRBG8_1X8</emphasis></entry>
>  	    </row>
>  	    <row>
> -	      <entry>Configure scaler output</entry>
> -	      <entry>2048x1536</entry>
> -	      <entry>2048x1536</entry>
> -	      <entry>2046x1534</entry>
> -	      <entry>2046x1534</entry>
> -	      <entry><emphasis>1280x960</emphasis></entry>
> +	      <entry>Configure scaler sink compose selection</entry>
> +	      <entry>2048x1536/SGRBG8_1X8</entry>
> +	      <entry>2048x1536/SGRBG8_1X8</entry>
> +	      <entry>2046x1534/SGRBG8_1X8</entry>
> +	      <entry>2046x1534/SGRBG8_1X8</entry>
> +	      <entry><emphasis>0,0/1280x960</emphasis></entry>
> +	      <entry><emphasis>1280x960/SGRBG8_1X8</emphasis></entry>
>  	    </row>
>  	  </tbody>
>  	</tgroup>
> @@ -249,19 +255,29 @@
>  
>        <para>
>        <orderedlist>
> -	<listitem><para>Initial state. The sensor output is set to its native 3MP
> -	resolution. Resolutions on the host frontend and scaler input and output
> -	pads are undefined.</para></listitem>
> -	<listitem><para>The application configures the frontend input pad resolution to
> -	2048x1536. The driver propagates the format to the frontend output pad.
> -	Note that the propagated output format can be different, as in this case,
> -	than the input format, as the hardware might need to crop pixels (for
> -	instance when converting a Bayer filter pattern to RGB or YUV).

Does this Bayer filter note no longer apply?

> </para></listitem>
> -	<listitem><para>The application configures the scaler input pad resolution to
> -	2046x1534 to match the frontend output resolution. The driver propagates
> -	the format to the scaler output pad.</para></listitem>
> -	<listitem><para>The application configures the scaler output pad resolution to
> -	1280x960.</para></listitem>
> +	<listitem><para>Initial state. The sensor source pad format is
> +	set to its native 3MP size and V4L2_MBUS_FMT_SGRBG8_1X8
> +	media bus code. Formats on the host frontend and scaler sink
> +	and source pads have the default values, as well as the
> +	compose rectangle on the scaler's sind pad.</para></listitem>

sind -> sink

> +
> +	<listitem><para>The application configures the frontend sink
> +	pad format's size to 2048x1536 and its media bus code to
> +	V4L2_MBUS_FMT_SGRBG_1X8. The driver propagates the format to
> +	the frontend source pad.</para></listitem>
> +
> +	<listitem><para>The application configures the scaler sink pad
> +	format's size to 2046x1534 and the media bus code to
> +	V4L2_MBUS_FMT_SGRBG_1X8 to match the frontend source size and
> +	media bus code. The media bus code on the sink pad is set to
> +	V4L2_MBUS_FMT_SGRBG_1X8. The driver propagates the size to the
> +	compose selection rectangle on the scaler's sink pad, and the
> +	format to the scaler source pad.</para></listitem>
> +
> +	<listitem><para>The application configures the compose
> +	selection rectangle of the scaler's sink pad and scaler source
> +	pad format's size to 1280x960.</para></listitem>
> +
>        </orderedlist>
>        </para>
>  
> 

Regards,

	Hans
