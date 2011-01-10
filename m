Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3677 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1AJLKU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 06:10:20 -0500
Message-ID: <170992c8af3a0dc3eefac487554e7ca6.squirrel@webmail.xs4all.nl>
In-Reply-To: <201101101208.00917.laurent.pinchart@ideasonboard.com>
References: <201101101208.00917.laurent.pinchart@ideasonboard.com>
Date: Mon, 10 Jan 2011 12:10:18 +0100
Subject: Re: [GIT PULL FOR 2.6.38] Control framework fixes
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Cc: "Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

> Hi Mauro,
>
> The following changes since commit
> 0a97a683049d83deaf636d18316358065417d87b:
>
>   [media] cpia2: convert .ioctl to .unlocked_ioctl (2011-01-06 11:34:41
> -0200)
>
> are available in the git repository at:
>   git://linuxtv.org/pinchartl/media.git ctrl-framework
>
> Could you please include them in the next pull request for 2.6.38 ? The
> second
> one is a bug fix and has been reviewed by Hans.

For both patches:

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>

>
> Laurent Pinchart (2):
>       v4l: Include linux/videodev2.h in media/v4l2-ctrls.h
>       v4l: Fix a use-before-set in the control framework
>
>  drivers/media/video/v4l2-ctrls.c |    2 +-
>  include/media/v4l2-ctrls.h       |    1 +
>  2 files changed, 2 insertions(+), 1 deletions(-)
>
> --
> Regards,
>
> Laurent Pinchart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Hans Verkuil - video4linux developer - sponsored by Cisco

