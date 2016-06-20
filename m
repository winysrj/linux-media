Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:35274 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753524AbcFTQ7F (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2016 12:59:05 -0400
Subject: Re: [PATCH v2 2/7] v4l: Fix number of zeroed high order bits in
 12-bit raw format defs
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <1466439608-22890-1-git-send-email-sakari.ailus@linux.intel.com>
 <1466439608-22890-3-git-send-email-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57681FAB.6010201@xs4all.nl>
Date: Mon, 20 Jun 2016 18:54:03 +0200
MIME-Version: 1.0
In-Reply-To: <1466439608-22890-3-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/20/2016 06:20 PM, Sakari Ailus wrote:
> The number of high order bits in samples was documented to be 6 for 12-bit
> data. This is clearly wrong, fix it.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

	Hans

> ---
>  Documentation/DocBook/media/v4l/pixfmt-srggb12.xml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml b/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
> index 0c8e4ad..4394101 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt-srggb12.xml
> @@ -31,7 +31,7 @@ pixel image</title>
>  
>        <formalpara>
>  	<title>Byte Order.</title>
> -	<para>Each cell is one byte, high 6 bits in high bytes are 0.
> +	<para>Each cell is one byte, high 4 bits in high bytes are 0.
>  	  <informaltable frame="none">
>  	    <tgroup cols="5" align="center">
>  	      <colspec align="left" colwidth="2*" />
> 
