Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52084 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab2KVTLD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 14:11:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: There's no __unsigned
Date: Thu, 22 Nov 2012 11:54:57 +0100
Message-ID: <3181206.PqETckngkk@avalon>
In-Reply-To: <1353099104-1364-1-git-send-email-sakari.ailus@iki.fi>
References: <1353099104-1364-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 16 November 2012 22:51:44 Sakari Ailus wrote:
> Correct a typo. v4l2_plane.m.userptr is unsigned long, not __unsigned long.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  Documentation/DocBook/media/v4l/io.xml |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/io.xml
> b/Documentation/DocBook/media/v4l/io.xml index bcd1c8f7..1565f31 100644
> --- a/Documentation/DocBook/media/v4l/io.xml
> +++ b/Documentation/DocBook/media/v4l/io.xml
> @@ -736,7 +736,7 @@ should set this to 0.</entry>
>  	  </row>
>  	  <row>
>  	    <entry></entry>
> -	    <entry>__unsigned long</entry>
> +	    <entry>unsigned long</entry>
>  	    <entry><structfield>userptr</structfield></entry>
>  	    <entry>When the memory type in the containing &v4l2-buffer; is
>  	      <constant>V4L2_MEMORY_USERPTR</constant>, this is a userspace
-- 
Regards,

Laurent Pinchart

