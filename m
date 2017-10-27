Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:50269 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752205AbdJ0Iw3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 27 Oct 2017 04:52:29 -0400
Received: by mail-wm0-f66.google.com with SMTP id s66so2063479wmf.5
        for <linux-media@vger.kernel.org>; Fri, 27 Oct 2017 01:52:29 -0700 (PDT)
Subject: Re: [PATCH 07/13] media: soc_camera pad-aware driver initialisation
To: William Towle <william.towle@codethink.co.uk>,
        linux-media@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <1437654103-26409-1-git-send-email-william.towle@codethink.co.uk>
 <1437654103-26409-8-git-send-email-william.towle@codethink.co.uk>
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <abf6792b-a43b-ed80-6d07-fff7f42fdf2a@cogentembedded.com>
Date: Fri, 27 Oct 2017 10:52:18 +0200
MIME-Version: 1.0
In-Reply-To: <1437654103-26409-8-git-send-email-william.towle@codethink.co.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello!

On 7/23/2015 2:21 PM, William Towle wrote:

> Add detection of source pad number for drivers aware of the media
> controller API, so that the combination of soc_camera and rcar_vin
> can create device nodes to support modern drivers such as adv7604.c
> (for HDMI on Lager) and the converted adv7180.c (for composite)
> underneath.
> 
> Building rcar_vin gains a dependency on CONFIG_MEDIA_CONTROLLER, in
> line with requirements for building the drivers associated with it.
> 
> Signed-off-by: William Towle <william.towle@codethink.co.uk>
> Signed-off-by: Rob Taylor <rob.taylor@codethink.co.uk>
> ---
>   drivers/media/platform/soc_camera/Kconfig      |    1 +
>   drivers/media/platform/soc_camera/rcar_vin.c   |    1 +

    This driver no longer exists. What did you base on?

>   drivers/media/platform/soc_camera/soc_camera.c |   36 ++++++++++++++++++++++++
>   include/media/soc_camera.h                     |    1 +
>   4 files changed, 39 insertions(+)
[...]
> @@ -1310,8 +1313,33 @@ static int soc_camera_probe_finish(struct soc_camera_device *icd)
>   		return ret;
>   	}
>   
> +	icd->src_pad_idx = 0;
> +#if defined(CONFIG_MEDIA_CONTROLLER)
>   	/* At this point client .probe() should have run already */
> +	ret = media_entity_init(&icd->vdev->entity, 1, &pad, 0);
> +	if (ret < 0) {
> +		goto eusrfmt;
> +	} else {
> +		int pad_idx;
> +
> +		for (pad_idx = 0; pad_idx < sd->entity.num_pads; pad_idx++)
> +			if (sd->entity.pads[pad_idx].flags
> +					== MEDIA_PAD_FL_SOURCE)

    Please leave == on the previous line...

[...]

MBR, Sergei
