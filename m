Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:41664 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdEBOqz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 10:46:55 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Petr Cvek <petr.cvek@tul.cz>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] [media] pxa_camera: Add (un)subscribe_event ioctl
References: <cover.1493612057.git.petr.cvek@tul.cz>
        <0c2bf711-dbdf-f384-fc6f-4e7f5ed964b1@tul.cz>
Date: Tue, 02 May 2017 16:46:52 +0200
In-Reply-To: <0c2bf711-dbdf-f384-fc6f-4e7f5ed964b1@tul.cz> (Petr Cvek's
        message of "Mon, 1 May 2017 06:21:29 +0200")
Message-ID: <87wp9zz57n.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Petr Cvek <petr.cvek@tul.cz> writes:

> The v4l2-compliance complains about nonexistent vidioc_subscribe_event
> and vidioc_unsubscribe_event calls. Add them to fix the complaints.
>
> Signed-off-by: Petr Cvek <petr.cvek@tul.cz>
Don't know on that one, let others on the mailing list comment, I'm not familiar
with the event interface of v4l2.

Cheers.

--
Robert

> ---
>  drivers/media/platform/pxa_camera.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
> index f71e7e0a652b..79fd7269d1e6 100644
> --- a/drivers/media/platform/pxa_camera.c
> +++ b/drivers/media/platform/pxa_camera.c
> @@ -37,7 +37,9 @@
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-clk.h>
>  #include <media/v4l2-common.h>
> +#include <media/v4l2-ctrls.h>
>  #include <media/v4l2-device.h>
> +#include <media/v4l2-event.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-of.h>
>  
> @@ -2089,6 +2091,8 @@ static const struct v4l2_ioctl_ops pxa_camera_ioctl_ops = {
>  	.vidioc_g_register		= pxac_vidioc_g_register,
>  	.vidioc_s_register		= pxac_vidioc_s_register,
>  #endif
> +	.vidioc_subscribe_event		= v4l2_ctrl_subscribe_event,
> +	.vidioc_unsubscribe_event	= v4l2_event_unsubscribe,
>  };
>  
>  static struct v4l2_clk_ops pxa_camera_mclk_ops = {
