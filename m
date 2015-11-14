Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:36730 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751067AbbKNNuq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Nov 2015 08:50:46 -0500
Subject: Re: [PATCH] v4l: Add YUV 4:2:2 and YUV 4:4:4 tri-planar
 non-contiguous formats
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
References: <1447507593-15016-1-git-send-email-laurent.pinchart@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56473C30.2090903@xs4all.nl>
Date: Sat, 14 Nov 2015 14:50:40 +0100
MIME-Version: 1.0
In-Reply-To: <1447507593-15016-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/14/2015 02:26 PM, Laurent Pinchart wrote:
> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> The formats use three planes through the multiplanar API, allowing for
> non-contiguous planes in memory.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml | 159 +++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt-yuv444m.xml | 171 +++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt-yvu422m.xml | 159 +++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt-yvu444m.xml | 171 +++++++++++++++++++++
>  Documentation/DocBook/media/v4l/pixfmt.xml         |   4 +
>  drivers/media/v4l2-core/v4l2-ioctl.c               |   4 +
>  include/uapi/linux/videodev2.h                     |   4 +
>  7 files changed, 672 insertions(+)
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yuv444m.xml
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yvu422m.xml
>  create mode 100644 Documentation/DocBook/media/v4l/pixfmt-yvu444m.xml
> 
> Hello,
> 
> The driver using those formats should follow in the not too distant future,
> but I'd appreciate getting feedback on the definitions already.

Looks good, but I would combine yuv422m and yvu422m, and do the same for the 444m
variants. It's overkill to split this up.

> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml b/Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml
> new file mode 100644
> index 000000000000..f4d8d74e7f74
> --- /dev/null
> +++ b/Documentation/DocBook/media/v4l/pixfmt-yuv422m.xml
> @@ -0,0 +1,159 @@
> +    <refentry id="V4L2-PIX-FMT-YUV422M">
> +      <refmeta>
> +	<refentrytitle>V4L2_PIX_FMT_YUV422M ('YM16')</refentrytitle>
> +	&manvol;
> +      </refmeta>
> +      <refnamediv>
> +	<refname> <constant>V4L2_PIX_FMT_YUV422M</constant></refname>
> +	<refpurpose>Planar formats with &frac12; horizontal resolution, also
> +	known as YUV 4:2:2</refpurpose>
> +      </refnamediv>
> +
> +      <refsect1>
> +	<title>Description</title>
> +
> +	<para>This is a multi-planar format, as opposed to a packed format.
> +The three components are separated into three sub- images or planes.

No space needed after 'sub-'.

Regards,

	Hans
