Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3148 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbaGUVnY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 17:43:24 -0400
Message-ID: <53CD8974.20109@xs4all.nl>
Date: Mon, 21 Jul 2014 23:43:16 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: Clarify RGB666 pixel format definition
References: <1405975150-9256-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1405975150-9256-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/21/2014 10:39 PM, Laurent Pinchart wrote:
> The RGB666 pixel format doesn't include an alpha channel. Document it as
> such.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  .../DocBook/media/v4l/pixfmt-packed-rgb.xml          | 20 ++++++--------------
>  1 file changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> index 32feac9..c47692a 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> @@ -330,20 +330,12 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
>  	    <entry></entry>
>  	    <entry>r<subscript>1</subscript></entry>
>  	    <entry>r<subscript>0</subscript></entry>
> -	    <entry></entry>
> -	    <entry></entry>
> -	    <entry></entry>
> -	    <entry></entry>
> -	    <entry></entry>
> -	    <entry></entry>
> -	    <entry></entry>
> -	    <entry></entry>
> -	    <entry></entry>
> -	    <entry></entry>
> -	    <entry></entry>
> -	    <entry></entry>
> -	    <entry></entry>
> -	    <entry></entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>
> +	    <entry>-</entry>

Just to clarify: BGR666 is a three byte format, not a four byte format?

If so, then:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

>  	  </row>
>  	  <row id="V4L2-PIX-FMT-BGR24">
>  	    <entry><constant>V4L2_PIX_FMT_BGR24</constant></entry>
> 

