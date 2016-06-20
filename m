Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:54848 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753417AbcFTQ5l (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 12:57:41 -0400
Subject: Re: [PATCH v2 3/7] v4l: Clean up raw bayer pixel format definitions
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <1466439608-22890-1-git-send-email-sakari.ailus@linux.intel.com>
 <1466439608-22890-4-git-send-email-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57681FC9.8010505@xs4all.nl>
Date: Mon, 20 Jun 2016 18:54:33 +0200
MIME-Version: 1.0
In-Reply-To: <1466439608-22890-4-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/20/2016 06:20 PM, Sakari Ailus wrote:
> - Explicitly state that the most significant n bits are zeroed on 10 and
>   12 bpp formats.
> - Remove extra comma from the last entry of the format list
> - Add a missing colon before a list
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

	Hans

> ---
>  Documentation/DocBook/media/v4l/pixfmt-srggb10.xml  | 5 +++--
>  Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml | 2 +-
>  Documentation/DocBook/media/v4l/pixfmt-srggb12.xml  | 5 +++--
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
> index f34d03e..cd3f915 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10.xml
> @@ -23,7 +23,7 @@ unused high bits filled with zeros. Each n-pixel row contains n/2 green samples
>  and n/2 blue or red samples, with alternating red and blue rows. Bytes are
>  stored in memory in little endian order. They are conventionally described
>  as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example of one of these
> -formats</para>
> +formats:</para>
>  
>      <example>
>        <title><constant>V4L2_PIX_FMT_SBGGR10</constant> 4 &times; 4
> @@ -31,7 +31,8 @@ pixel image</title>
>  
>        <formalpara>
>  	<title>Byte Order.</title>
> -	<para>Each cell is one byte, high 6 bits in high bytes are 0.
> +	<para>Each cell is one byte, the 6 most significant bits in the high
> +	      bytes are 0.
>  	  <informaltable frame="none">
>  	    <tgroup cols="5" align="center">
>  	      <colspec align="left" colwidth="2*" />
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml
> index 747822b..18bb722 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb10p.xml
> @@ -3,7 +3,7 @@
>  	<refentrytitle>V4L2_PIX_FMT_SRGGB10P ('pRAA'),
>  	 V4L2_PIX_FMT_SGRBG10P ('pgAA'),
>  	 V4L2_PIX_FMT_SGBRG10P ('pGAA'),
> -	 V4L2_PIX_FMT_SBGGR10P ('pBAA'),
> +	 V4L2_PIX_FMT_SBGGR10P ('pBAA')
>  	 </refentrytitle>
>  	&manvol;
>        </refmeta>
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
> index 4394101..2d8efeb 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
> @@ -23,7 +23,7 @@ unused high bits filled with zeros. Each n-pixel row contains n/2 green samples
>  and n/2 blue or red samples, with alternating red and blue rows. Bytes are
>  stored in memory in little endian order. They are conventionally described
>  as GRGR... BGBG..., RGRG... GBGB..., etc. Below is an example of one of these
> -formats</para>
> +formats:</para>
>  
>      <example>
>        <title><constant>V4L2_PIX_FMT_SBGGR12</constant> 4 &times; 4
> @@ -31,7 +31,8 @@ pixel image</title>
>  
>        <formalpara>
>  	<title>Byte Order.</title>
> -	<para>Each cell is one byte, high 4 bits in high bytes are 0.
> +	<para>Each cell is one byte, the 4 most significant bits in the high
> +	      bytes are 0.
>  	  <informaltable frame="none">
>  	    <tgroup cols="5" align="center">
>  	      <colspec align="left" colwidth="2*" />
> 
