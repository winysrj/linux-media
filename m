Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:65338 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab2GNNcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jul 2012 09:32:52 -0400
Received: by gglu4 with SMTP id u4so4285579ggl.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jul 2012 06:32:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341581569-8292-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1341581569-8292-1-git-send-email-laurent.pinchart@ideasonboard.com>
Date: Sat, 14 Jul 2012 15:32:51 +0200
Message-ID: <CAGGh5h18HOB2ra94Tp8chCom2SBVyqwX+d4nzZP6tGgo8jBe4w@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] omap3isp: preview: Add support for non-GRBG Bayer patterns
From: jean-philippe francois <jp.francois@cynove.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/7/6 Laurent Pinchart <laurent.pinchart@ideasonboard.com>:
> Hi everybody,
>
> Here's the second version of the non-GRBG Bayer patterns support for the OMAP3
> ISP preview engine. Compared to v1, the CFA table can be reconfigured at
> runtime, which resulted in several cleanup patches.
>
> The first patch is a v3.5 regression fix, I'll send a separate pull request.
>
> Jean-Philippe, could you please test this patch set on your hardware ? It's
> based on top of the latest linuxtv/staging/for_v3.6 branch.

Hi Laurent,

Sorry for the delay, but I was on vacation last week, and will be next week,
so I won't be able to test anything before  July 23rd.
I will report here when tested.

Regards,
Jean-Philippe François

>
> Laurent Pinchart (6):
>   omap3isp: preview: Fix contrast and brightness handling
>   omap3isp: preview: Remove lens shading compensation support
>   omap3isp: preview: Pass a prev_params pointer to configuration
>     functions
>   omap3isp: preview: Reorder configuration functions
>   omap3isp: preview: Merge gamma correction and gamma bypass
>   omap3isp: preview: Add support for non-GRBG Bayer patterns
>
>  drivers/media/video/omap3isp/isppreview.c |  706 ++++++++++++++---------------
>  drivers/media/video/omap3isp/isppreview.h |    1 +
>  2 files changed, 346 insertions(+), 361 deletions(-)
>
> --
> Regards,
>
> Laurent Pinchart
>
