Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1262 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab3HSHPg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Aug 2013 03:15:36 -0400
Message-ID: <5211C608.60201@xs4all.nl>
Date: Mon, 19 Aug 2013 09:15:20 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
CC: linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] s5p-tv: Include missing v4l2-dv-timings.h header file
References: <1376856050-30538-1-git-send-email-s.nawrocki@samsung.com>
In-Reply-To: <1376856050-30538-1-git-send-email-s.nawrocki@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/18/2013 10:00 PM, Sylwester Nawrocki wrote:
> Include the v4l2-dv-timings.h header file which in the s5p-tv driver which
> was supposed to be updated in commit 2576415846bcbad3c0a6885fc44f95083710
> "[media] v4l2: move dv-timings related code to v4l2-dv-timings.c"
> 
> This fixes following build error:
> 
> drivers/media/platform/s5p-tv/hdmi_drv.c: In function ‘hdmi_s_dv_timings’:
> drivers/media/platform/s5p-tv/hdmi_drv.c:628:3: error: implicit declaration of function ‘v4l_match_dv_timings’
> 
> Cc: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

My apologies for missing this one.

Regards,

	Hans

> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> ---
>  drivers/media/platform/s5p-tv/hdmi_drv.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
> index 1b34c36..f9af2c2 100644
> --- a/drivers/media/platform/s5p-tv/hdmi_drv.c
> +++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
> @@ -37,6 +37,7 @@
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-device.h>
> +#include <media/v4l2-dv-timings.h>
>  
>  #include "regs-hdmi.h"
>  
> 

