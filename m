Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:53755 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab2FGJT3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2012 05:19:29 -0400
Date: Thu, 7 Jun 2012 11:19:27 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH for v3.5] V4L2 spec fix
In-Reply-To: <201206062348.46728.hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1206071118300.21581@axis700.grange>
References: <201206062348.46728.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the patch, Hans

On Wed, 6 Jun 2012, Hans Verkuil wrote:

> Two small docbook fixes:
> 
> - prepare-buf was not positioned in alphabetical order, moved to the right place.
> - the format field in create_bufs had the wrong type in the documentation
> 
> Regards,
> 
> 	Hans
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi

> 
> diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
> index 015c561..008c2d7 100644
> --- a/Documentation/DocBook/media/v4l/v4l2.xml
> +++ b/Documentation/DocBook/media/v4l/v4l2.xml
> @@ -560,6 +560,7 @@ and discussions on the V4L mailing list.</revremark>
>      &sub-g-tuner;
>      &sub-log-status;
>      &sub-overlay;
> +    &sub-prepare-buf;
>      &sub-qbuf;
>      &sub-querybuf;
>      &sub-querycap;
> @@ -567,7 +568,6 @@ and discussions on the V4L mailing list.</revremark>
>      &sub-query-dv-preset;
>      &sub-query-dv-timings;
>      &sub-querystd;
> -    &sub-prepare-buf;
>      &sub-reqbufs;
>      &sub-s-hw-freq-seek;
>      &sub-streamon;
> diff --git a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> index 765549f..6cd2bc3 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-create-bufs.xml
> @@ -108,7 +108,7 @@ information.</para>
>  /></entry>
>  	  </row>
>  	  <row>
> -	    <entry>__u32</entry>
> +	    <entry>struct&nbsp;v4l2_format</entry>
>  	    <entry><structfield>format</structfield></entry>
>  	    <entry>Filled in by the application, preserved by the driver.
>  	    See <xref linkend="v4l2-format" />.</entry>
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
