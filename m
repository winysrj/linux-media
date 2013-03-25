Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55703 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022Ab3CYWD7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 18:03:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andreas Bombe <aeb@debian.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [media-ctl PATCH] configure.ac: Respect CPPFLAGS from environment
Date: Mon, 25 Mar 2013 23:04:46 +0100
Message-ID: <1466207.TFbi0fXivb@avalon>
In-Reply-To: <20130218001002.GA7885@amos.fritz.box>
References: <20130218001002.GA7885@amos.fritz.box>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

Thanks for the patch, and sorry for the late reply.

On Monday 18 February 2013 01:10:02 Andreas Bombe wrote:
> Signed-off-by: Andreas Bombe <aeb@debian.org>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and pushed to the repository.

> ---
>  configure.ac |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 98459d4..a749794 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -48,7 +48,7 @@ AC_ARG_WITH(kernel-headers,
>       esac],
>      [KERNEL_HEADERS_DIR="/usr/src/kernel-headers"])
> 
> -CPPFLAGS="-I$KERNEL_HEADERS_DIR/include"
> +CPPFLAGS="$CPPFLAGS -I$KERNEL_HEADERS_DIR/include"
> 
>  # Checks for header files.
>  AC_CHECK_HEADERS([linux/media.h \
-- 
Regards,

Laurent Pinchart

