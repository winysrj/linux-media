Return-path: <linux-media-owner@vger.kernel.org>
Received: from ams-iport-3.cisco.com ([144.254.224.146]:46609 "EHLO
	ams-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3HIMei (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Aug 2013 08:34:38 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] v4l: Fix colorspace conversion error in sample code
Date: Fri, 9 Aug 2013 14:34:08 +0200
Cc: linux-media@vger.kernel.org
References: <1375974070-2392-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1375974070-2392-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201308091434.08529.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu 8 August 2013 17:01:10 Laurent Pinchart wrote:
> The sample code erroneously scales the y1, pb and pr variables from the
> [0.0 .. 1.0] and [-0.5 .. 0.5] ranges to [0 .. 255] and [-128 .. 127].
> Fix it.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  Documentation/DocBook/media/v4l/pixfmt.xml | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/DocBook/media/v4l/pixfmt.xml b/Documentation/DocBook/media/v4l/pixfmt.xml
> index 99b8d2a..4babd4d 100644
> --- a/Documentation/DocBook/media/v4l/pixfmt.xml
> +++ b/Documentation/DocBook/media/v4l/pixfmt.xml
> @@ -391,9 +391,9 @@ clamp (double x)
>  	else               return r;
>  }
>  
> -y1 = (255 / 219.0) * (Y1 - 16);
> -pb = (255 / 224.0) * (Cb - 128);
> -pr = (255 / 224.0) * (Cr - 128);
> +y1 = (Y1 - 16) / 219.0;
> +pb = (Cb - 128) / 224.0;
> +pr = (Cr - 128) / 224.0;
>  
>  r = 1.0 * y1 + 0     * pb + 1.402 * pr;
>  g = 1.0 * y1 - 0.344 * pb - 0.714 * pr;
> 
