Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2579 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469Ab3AKLX3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Jan 2013 06:23:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] DocBook: media: struct v4l2_capability card field is a UTF-8 string
Date: Fri, 11 Jan 2013 12:23:23 +0100
Cc: linux-media@vger.kernel.org
References: <1357590624-28567-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1357590624-28567-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301111223.23285.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon January 7 2013 21:30:24 Laurent Pinchart wrote:
> The struct v4l2_capability card field stores the device name. That name
> can be hardcoded in drivers, or be retrieved directly from the device.
> The later is very common with USB devices. As several devices already
> report names that include non-ASCII characters, update the field
> description to use UTF-8.
>

I missed this patch on Monday, but better late than never:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  .../DocBook/media/v4l/vidioc-querycap.xml          |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/vidioc-querycap.xml b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> index 4c70215..d5a3c97 100644
> --- a/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> +++ b/Documentation/DocBook/media/v4l/vidioc-querycap.xml
> @@ -76,7 +76,7 @@ make sure the strings are properly NUL-terminated.</para></entry>
>  	  <row>
>  	    <entry>__u8</entry>
>  	    <entry><structfield>card</structfield>[32]</entry>
> -	    <entry>Name of the device, a NUL-terminated ASCII string.
> +	    <entry>Name of the device, a NUL-terminated UTF-8 string.
>  For example: "Yoyodyne TV/FM". One driver may support different brands
>  or models of video hardware. This information is intended for users,
>  for example in a menu of available devices. Since multiple TV cards of
> 
