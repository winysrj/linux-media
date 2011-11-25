Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab1KYKxy (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Nov 2011 05:53:54 -0500
Message-ID: <4ECF73C0.6090904@redhat.com>
Date: Fri, 25 Nov 2011 08:53:52 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 2/3] vivi: set device_caps.
References: <1321956322-25084-1-git-send-email-hverkuil@xs4all.nl> <bd80eb41a795b4fac63dff9005b10835e4aa8b17.1321956058.git.hans.verkuil@cisco.com>
In-Reply-To: <bd80eb41a795b4fac63dff9005b10835e4aa8b17.1321956058.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 22-11-2011 08:05, Hans Verkuil escreveu:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/vivi.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
> index 7d754fb..84ea88d 100644
> --- a/drivers/media/video/vivi.c
> +++ b/drivers/media/video/vivi.c
> @@ -819,8 +819,9 @@ static int vidioc_querycap(struct file *file, void  *priv,
>  	strcpy(cap->driver, "vivi");
>  	strcpy(cap->card, "vivi");
>  	strlcpy(cap->bus_info, dev->v4l2_dev.name, sizeof(cap->bus_info));
> -	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING | \
> -			    V4L2_CAP_READWRITE;
> +	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
> +			    V4L2_CAP_READWRITE | V4L2_CAP_DEVICE_CAPS;
> +	cap->device_caps = cap->capabilities;

Hmm... should V4L2_CAP_DEVICE_CAPS be present at both device_caps and capabilities?

IMHO, the better would be to do:

	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
			    V4L2_CAP_READWRITE | V4L2_CAP_DEVICE_CAPS;
	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;

Btw, this ambiguity should also be solved at the V4L2 spec.

Regards,
Mauro
