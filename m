Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46476
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751464AbdHHKRg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 06:17:36 -0400
Date: Tue, 8 Aug 2017 07:17:26 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] v4l2-tpg: fix the SMPTE-2084 transfer function
Message-ID: <20170808071726.488b0585@vento.lan>
In-Reply-To: <0b1447e4-edaf-05a6-0cac-b969ff3ccb28@xs4all.nl>
References: <0b1447e4-edaf-05a6-0cac-b969ff3ccb28@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 26 Jul 2017 20:45:55 +0200
Hans Verkuil <hverkuil@xs4all.nl> escreveu:

> The SMPTE-2084 transfer functions maps to the luminance range of 0-10000 cd/m^2.
> Other transfer functions use the traditional range of 0-100 cd/m^2.
> 
> I didn't take this into account so the luminance was off by a factor of 100.
> 
> Since qv4l2 made the same mistake in reverse I never noticed this until I tested with
> actual SMPTE-2084 video.
> 
> This patch also includes the v4l2-tpg-colors.h relative to this directory when
> building the gen-colors utility, otherwise it would fail. This was needed to regenerate
> the tables.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
> diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c
> index 9bcbd318489b..ac86cbe08440 100644
> --- a/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c
> +++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-colors.c
> @@ -36,7 +36,11 @@
>    */
> 
>   #include <linux/videodev2.h>
> +#ifdef COMPILE_APP
> +#include "../../../../include/media/v4l2-tpg-colors.h"
> +#else
>   #include <media/v4l2-tpg-colors.h>
> +#endif
> 
>   /* sRGB colors with range [0-255] */
>   const struct color tpg_colors[TPG_COLOR_MAX] = {

The above sucks. We shouldn't be adding hacks at the Kernel tree due
to userspace.

In particular, this one is evil, as it assumes a particular location
of the header inside libv4l.

Instead of this ugly hack, you could just add an extra line at the
"sync-with-kernel" target at v4l-utils Makefile with:

	sed 's,<media/v4l2-tpg-colors.h>,"../../../../include/media/v4l2-tpg-colors.h",' -i ./utils/common/v4l2-tpg-colors.c

Thanks,
Mauro
