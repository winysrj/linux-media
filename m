Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55706 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933283Ab3CYWEU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 18:04:20 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andreas Bombe <aeb@debian.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [media-ctl PATCH] Add missing stdlib.h and ctype.h includes
Date: Mon, 25 Mar 2013 23:05:07 +0100
Message-ID: <1566926.cSFf0o3dIQ@avalon>
In-Reply-To: <20130218001244.GA7932@amos.fritz.box>
References: <20130218001244.GA7932@amos.fritz.box>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andreas,

Thanks for the patch, and sorry for the late reply.

On Monday 18 February 2013 01:12:44 Andreas Bombe wrote:
> src/mediactl.c needs ctype.h for its use of isspace().
> 
> src/v4l2subdev.c needs stdlib.h for strtoul() and ctype.h for isspace()
> and isupper().
> 
> Signed-off-by: Andreas Bombe <aeb@debian.org>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and pushed to the repository.

> ---
>  src/mediactl.c   |    1 +
>  src/v4l2subdev.c |    2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/src/mediactl.c b/src/mediactl.c
> index 46562de..c2f985a 100644
> --- a/src/mediactl.c
> +++ b/src/mediactl.c
> @@ -29,6 +29,7 @@
>  #include <stdbool.h>
>  #include <stdio.h>
>  #include <stdlib.h>
> +#include <ctype.h>
>  #include <string.h>
>  #include <fcntl.h>
>  #include <errno.h>
> diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
> index d0c37f3..87d7eb7 100644
> --- a/src/v4l2subdev.c
> +++ b/src/v4l2subdev.c
> @@ -26,6 +26,8 @@
>  #include <errno.h>
>  #include <fcntl.h>
>  #include <stdbool.h>
> +#include <stdlib.h>
> +#include <ctype.h>
>  #include <stdio.h>
>  #include <string.h>
>  #include <unistd.h>
-- 
Regards,

Laurent Pinchart

