Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:10308 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbaCMOb3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Mar 2014 10:31:29 -0400
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N2D0058IPOGRM70@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 13 Mar 2014 10:31:28 -0400 (EDT)
Date: Thu, 13 Mar 2014 11:31:23 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv1 PATCH 5/5] DocBook media: clarify v4l2_pix_format and
 v4l2_pix_format_mplane fields
Message-id: <20140313113123.3326b0e4@samsung.com>
In-reply-to: <1394202384-5762-6-git-send-email-hverkuil@xs4all.nl>
References: <1394202384-5762-1-git-send-email-hverkuil@xs4all.nl>
 <1394202384-5762-6-git-send-email-hverkuil@xs4all.nl>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri,  7 Mar 2014 15:26:24 +0100
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Be more specific with regards to how some of these fields are interpreted.
> In particular height vs field and which fields can be set by the application.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  Documentation/DocBook/media/v4l/pixfmt.xml | 33 +++++++++++++++++++++++-------
>  1 file changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
> index f586d34..7b0b098 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -25,7 +25,18 @@ capturing and output, for overlay frame buffer formats see also
>  	<row>
>  	  <entry>__u32</entry>
>  	  <entry><structfield>height</structfield></entry>
> -	  <entry>Image height in pixels.</entry>
> +	  <entry>Image height in pixels. If <structfield>field</structfield> is
> +	  one of <constant>V4L2_FIELD_TOP</constant>, <constant>V4L2_FIELD_BOTTOM</constant>
> +	  or <constant>V4L2_FIELD_ALTERNATE</constant> then height refers to the
> +	  number of lines in the field, otherwise it refers to the number of
> +	  lines in the frame (which is twice the field height for interlaced
> +	  formats). In case of conflicts between the <structfield>height</structfield>
> +	  value and the <structfield>field</structfield> value, the
> +	  <structfield>height</structfield> shall be the deciding factor.
> +	  So if <structfield>height</structfield> is set to 480 for an NTSC-M
> +	  standard, and <structfield>field</structfield> is set to
> +	  <constant>V4L2_FIELD_TOP</constant>, then <structfield>field</structfield>
> +	  shall be adjusted to &eg; <constant>V4L2_FIELD_INTERLACED</constant>.</entry>

This seems to be a description of a hack. I think we should better discuss
the meanings for V4L2_FIELD on some next mini-summit, as this seem to be
very confusing. I'm not even sure if applications use it properly, as
some drivers never implemented it right.

>  	</row>
>  	<row>
>  	  <entry spanname="hspan">Applications set these fields to
> @@ -54,7 +65,11 @@ linkend="reserved-formats" /></entry>
>  can request to capture or output only the top or bottom field, or both
>  fields interlaced or sequentially stored in one buffer or alternating
>  in separate buffers. Drivers return the actual field order selected.
> -For details see <xref linkend="field-order" />.</entry>
> +In case of conflicts between the <structfield>height</structfield> and
> +<structfield>field</structfield> values, the <structfield>height</structfield>
> +value will be the deciding factor. See also the description of
> +<structfield>height</structfield> above.
> +For more details on fields see <xref linkend="field-order" />.</entry>
>  	</row>
>  	<row>
>  	  <entry>__u32</entry>
> @@ -81,7 +96,10 @@ plane and is divided by the same factor as the
>  example the Cb and Cr planes of a YUV 4:2:0 image have half as many
>  padding bytes following each line as the Y plane. To avoid ambiguities
>  drivers must return a <structfield>bytesperline</structfield> value
> -rounded up to a multiple of the scale factor.</para></entry>
> +rounded up to a multiple of the scale factor.</para>
> +<para>For compressed formats the <structfield>bytesperline</structfield>
> +value makes no sense. Applications and drivers must set this to 0 in
> +that case.</para></entry>
>  	</row>
>  	<row>
>  	  <entry>__u32</entry>
> @@ -97,7 +115,8 @@ hold an image.</entry>
>  	  <entry>&v4l2-colorspace;</entry>
>  	  <entry><structfield>colorspace</structfield></entry>
>  	  <entry>This information supplements the
> -<structfield>pixelformat</structfield> and must be set by the driver,
> +<structfield>pixelformat</structfield> and must be set by the driver for
> +capture streams and by the application for output streams,
>  see <xref linkend="colorspaces" />.</entry>
>  	</row>
>  	<row>
> @@ -135,7 +154,7 @@ set this field to zero.</entry>
>            <entry>__u16</entry>
>            <entry><structfield>bytesperline</structfield></entry>
>            <entry>Distance in bytes between the leftmost pixels in two adjacent
> -            lines.</entry>
> +            lines. See &v4l2-pix-format;.</entry>
>          </row>
>          <row>
>            <entry>__u16</entry>
> @@ -154,12 +173,12 @@ set this field to zero.</entry>
>          <row>
>            <entry>__u32</entry>
>            <entry><structfield>width</structfield></entry>
> -          <entry>Image width in pixels.</entry>
> +          <entry>Image width in pixels. See &v4l2-pix-format;.</entry>
>          </row>
>          <row>
>            <entry>__u32</entry>
>            <entry><structfield>height</structfield></entry>
> -          <entry>Image height in pixels.</entry>
> +          <entry>Image height in pixels. See &v4l2-pix-format;.</entry>
>          </row>
>          <row>
>            <entry>__u32</entry>


-- 

Regards,
Mauro
