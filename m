Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18027 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaENPEa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 May 2014 11:04:30 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5K009Z5KJCTP20@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 14 May 2014 16:04:25 +0100 (BST)
Message-id: <537385F9.2030809@samsung.com>
Date: Wed, 14 May 2014 17:04:25 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Kamil Debski <k.debski@samsung.com>, linux-media@vger.kernel.org
Cc: arun.kk@samsung.com
Subject: Re: [PATCH] v4l: Fix documentation of V4L2_PIX_FMT_H264_MVC and VP8
 pixel formats
References: <1400077869-17573-1-git-send-email-k.debski@samsung.com>
In-reply-to: <1400077869-17573-1-git-send-email-k.debski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/05/14 16:31, Kamil Debski wrote:
> The 'Code' column in the documentation should provide the real fourcc
> code that is used. Changed the documentation to provide the fourcc
> defined in videodev2.h
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>  Documentation/DocBook/media/v4l/pixfmt.xml |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
> index ea514d6..91dcbc8 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -772,7 +772,7 @@ extended control <constant>V4L2_CID_MPEG_STREAM_TYPE</constant>, see
>  	  </row>
>  	  <row id="V4L2-PIX-FMT-H264-MVC">
>  		<entry><constant>V4L2_PIX_FMT_H264_MVC</constant></entry>
> -		<entry>'MVC'</entry>
> +		<entry>'M264'</entry>
>  		<entry>H264 MVC video elementary stream.</entry>
>  	  </row>
>  	  <row id="V4L2-PIX-FMT-H263">
> @@ -812,7 +812,7 @@ extended control <constant>V4L2_CID_MPEG_STREAM_TYPE</constant>, see
>  	  </row>
>  	  <row id="V4L2-PIX-FMT-VP8">
>  		<entry><constant>V4L2_PIX_FMT_VP8</constant></entry>
> -		<entry>'VP8'</entry>
> +		<entry>'VP80'</entry>
>  		<entry>VP8 video elementary stream.</entry>
>  	  </row>
>  	</tbody>
