Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752556Ab2LUTMt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Dec 2012 14:12:49 -0500
Date: Fri, 21 Dec 2012 17:12:25 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PULL] video_visstrim staging/ov7670_for_v3.7
Message-ID: <20121221171225.6bce4504@redhat.com>
In-Reply-To: <1351527301-17855-1-git-send-email-javier.martin@vista-silicon.com>
References: <1351527301-17855-1-git-send-email-javier.martin@vista-silicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 29 Oct 2012 17:15:01 +0100
Javier Martin <javier.martin@vista-silicon.com> escreveu:

> Hi Mauro,
> since there was some confusion regarding my two last series
> for the ov7670 I've decided to send this pull request to 
> make things more clear and avoid merging order issues.

Thanks but you forgot to ad your SOB on the patches there. For example:
	https://github.com/jmartinc/video_visstrim/commit/923befe62c190dfcab66d3402b450d8f26ad98cf

Could you please sign them?

Thanks!
Mauro



> 
> It should apply properly in your current tree.
> 
> The following changes since commit 1534e55974c7e2f57623457c0f6b4108c6ef4776:
> 
>   media: coda: Add Philipp's patches. (2012-09-24 17:30:53 +0200)
> 
> are available in the git repository at:
> 
>   https://github.com/jmartinc/video_visstrim.git staging/ov7670_for_v3.7 
> 
> for you to fetch changes up to 5a594e1b96d3363aedf74d9bd37a2d669beab0bc:
> 
>   ov7670: remove legacy ctrl callbacks. (2012-09-28 13:18:23 +0200)
> 
> ----------------------------------------------------------------
> Javier Martin (9):
>       media: ov7670: add support for ov7675.
>       media: ov7670: make try_fmt() consistent with 'min_height' and 'min_width'.
>       media: ov7670: calculate framerate properly for ov7675.
>       media: ov7670: add possibility to bypass pll for ov7675.
>       media: ov7670: Add possibility to disable pixclk during hblank.
>       ov7670: use the control framework
>       mcam-core: implement the control framework.
>       via-camera: implement the control framework.
>       ov7670: remove legacy ctrl callbacks.
> 
>  drivers/media/i2c/ov7670.c                      |  587 +++++++++++++----------
>  drivers/media/platform/marvell-ccic/mcam-core.c |   54 +--
>  drivers/media/platform/marvell-ccic/mcam-core.h |    2 +
>  drivers/media/platform/via-camera.c             |   60 +--
>  include/media/ov7670.h                          |    2 +
>  5 files changed, 369 insertions(+), 336 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
