Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3634 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaGUWpO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jul 2014 18:45:14 -0400
Message-ID: <53CD97F1.8070206@xs4all.nl>
Date: Tue, 22 Jul 2014 00:45:05 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: Fix ARGB32 fourcc value in the documentation
References: <1405982482-11456-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1405982482-11456-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/22/2014 12:41 AM, Laurent Pinchart wrote:
> The ARGB32 pixel format's fourcc value is defined to 'BA24' in the
> videodev2.h header, but documented as 'AX24'. Fix the documentation.
> 
> Reported-by: Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Reported-by or Acked-by? :-)

Anyway:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> index 32feac9..4209542 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt-packed-rgb.xml
> @@ -489,7 +489,7 @@ colorspace <constant>V4L2_COLORSPACE_SRGB</constant>.</para>
>  	  </row>
>  	  <row id="V4L2-PIX-FMT-ARGB32">
>  	    <entry><constant>V4L2_PIX_FMT_ARGB32</constant></entry>
> -	    <entry>'AX24'</entry>
> +	    <entry>'BA24'</entry>
>  	    <entry></entry>
>  	    <entry>a<subscript>7</subscript></entry>
>  	    <entry>a<subscript>6</subscript></entry>
> 

