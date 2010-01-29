Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab0A2QJw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jan 2010 11:09:52 -0500
Message-ID: <4B63083C.5020909@redhat.com>
Date: Fri, 29 Jan 2010 14:09:32 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] uvcvideo: check minimum border of control
References: <4B5F60B0.7090709@freemail.hu>
In-Reply-To: <4B5F60B0.7090709@freemail.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Németh Márton wrote:
> Check also the minimum border of a value before setting it
> to a control value.
> 
> See also http://bugzilla.kernel.org/show_bug.cgi?id=12824 .

Patch didn't apply. Had you generated against our -git tree?
	http://git.linuxtv.org/v4l-dvb.git

Cheers,
Mauro.

> 
> Signed-off-by: Márton Németh <nm127@freemail.hu>
> ---
>  drivers/media/video/uvc/uvc_ctrl.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -1068,6 +1068,8 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
>  				    uvc_ctrl_data(ctrl, UVC_CTRL_DATA_RES));
> 
>  		xctrl->value = min + (xctrl->value - min + step/2) / step * step;
> +		if (xctrl->value < min)
> +			xctrl->value = min;
>  		if (xctrl->value > max)
>  			xctrl->value = max;
>  		value = xctrl->value;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

