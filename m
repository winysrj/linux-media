Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1136 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbZGBS5O (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jul 2009 14:57:14 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: m-karicheri2@ti.com
Subject: Re: [PATCH 1/11 - v3] vpfe capture bridge driver for DM355 and DM6446
Date: Thu, 2 Jul 2009 20:57:06 +0200
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
References: <1246554351-6191-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1246554351-6191-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907022057.06123.hverkuil@xs4all.nl>
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 02 July 2009 19:05:51 m-karicheri2@ti.com wrote:
> From: Muralidharan Karicheri <m-karicheri2@ti.com>
> 
> Re-sending to add description for VPFE_CMD_S_CCDC_RAW_PARAMS and
> updating debug prints with \n and fixing an error coder ENOMEM
> 
> VPFE Capture bridge driver
> 
> This is version, v3 of vpfe capture bridge driver for doing video
> capture on DM355 and DM6446 evms. The ccdc hw modules register with the
> driver and are used for configuring the CCD Controller for a specific
> decoder interface. The driver also registers the sub devices required
> for a specific evm. More than one sub devices can be registered.
> This allows driver to switch dynamically to capture video from
> any sub device that is registered. Currently only one sub device
> (tvp5146) is supported. But in future this driver is expected
> to do capture from sensor devices such as Micron's MT9T001,MT9T031
> and MT9P031 etc. The driver currently supports MMAP based IO.
> 
> Following are the updates based on review comments:-
> 	1) clean up of setting bus parameters in ccdc
> 	2) removed v4l2_routing structure type
> 	3) module authors, description changes 
> 	4) pixel aspect constants removed
> 
> Reviewed by: Hans Verkuil <hverkuil@xs4all.nl>
> Reviewed by: Laurent Pinchart <laurent.pinchart@skynet.be>
> Reviewed by: Alexey Klimov <klimov.linux@gmail.com>
> 
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Applies to v4l-dvb repository
> 
>  drivers/media/video/davinci/vpfe_capture.c | 2136 ++++++++++++++++++++++++++++
>  include/media/davinci/vpfe_capture.h       |  194 +++
>  include/media/davinci/vpfe_types.h         |   51 +
>  3 files changed, 2381 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/media/video/davinci/vpfe_capture.c
>  create mode 100644 include/media/davinci/vpfe_capture.h
>  create mode 100644 include/media/davinci/vpfe_types.h
> 
> diff --git a/drivers/media/video/davinci/vpfe_capture.c b/drivers/media/video/davinci/vpfe_capture.c

<snip>

> +/**
> + * VPFE_CMD_S_CCDC_RAW_PARAMS - Driver private IOCTL to set raw capture params
> + * This ioctl is used to configure the ccdc module such as defect pixel
> + * correction, color space conversion, culling etc. in raw capture mode.
> + * TODO: This is to be split into multiple ioctls and also explore the
> + * possibility of extending the v4l2 api to include them
> + **/
> +#define VPFE_CMD_S_CCDC_RAW_PARAMS _IOW('V', BASE_VIDIOC_PRIVATE + 1, \
> +					void *)
> +#endif				/* _DAVINCI_VPFE_H */

I've only one request: can you add something along the lines of:

"This is an experimental ioctl that will change in future kernels.
Use with care."

And at the top add: "EXPERIMENTAL IOCTL"

That way it is unambiguous that this will change. And it definitely has
to change! On the other hand I can imagine that it is useful to have this
available to experiment with. We have made experimental APIs before, so
there is a precedent for this, as long as it is very clearly marked as
experimental.

In fact, it would be even better if there is a KERN_WARNING message issued
mentioning the experimental status of this ioctl whenever it is used.

If you can do this asap, then I'll merge everything tomorrow morning and
make a new pull request for this.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
