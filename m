Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:38281 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751086AbeFDQWb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 4 Jun 2018 12:22:31 -0400
Subject: Re: [PATCHv15 09/35] v4l2-ctrls: v4l2_ctrl_add_handler: add
 from_other_dev
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Alexandre Courbot <acourbot@chromium.org>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
 <20180604114648.26159-10-hverkuil@xs4all.nl>
Message-ID: <3e2c9ea0-bc55-afc3-8a21-53b281c7880d@xs4all.nl>
Date: Mon, 4 Jun 2018 18:22:26 +0200
MIME-Version: 1.0
In-Reply-To: <20180604114648.26159-10-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve or Philipp,

Can one of you verify the imx-media-fim.c patch?

See the description of the change below:

On 06/04/2018 01:46 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Add a 'bool from_other_dev' argument: set to true if the two
> handlers refer to different devices (e.g. it is true when
> inheriting controls from a subdev into a main v4l2 bridge
> driver).
> 
> This will be used later when implementing support for the
> request API since we need to skip such controls.
> 
> TODO: check drivers/staging/media/imx/imx-media-fim.c change.

The basic idea is that while controls for a subdev can be
added ('inherited') to a handler for a another parent subdev or
video device, they should be marked as belonging to another device.

This is needed when the Request API is introduced since the request
should not have two copies of the same control (one belonging to the
subdev, one inherited by e.g. a video device).

However, I am not sure if I need to use true or false in the.
imx_media_fim_add_controls() case. Do the controls added here belong
to the same csi subdev or do they belong to another device?

BTW, with 'belongs to' I mean that that's the device driver that
implements the s_ctrl() call, i.e. actually sets up the hardware.

Regards,

	Hans

> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> ---
>  drivers/media/dvb-frontends/rtl2832_sdr.c     |  5 +-
>  drivers/media/pci/bt8xx/bttv-driver.c         |  2 +-
>  drivers/media/pci/cx23885/cx23885-417.c       |  2 +-
>  drivers/media/pci/cx88/cx88-blackbird.c       |  2 +-
>  drivers/media/pci/cx88/cx88-video.c           |  2 +-
>  drivers/media/pci/saa7134/saa7134-empress.c   |  4 +-
>  drivers/media/pci/saa7134/saa7134-video.c     |  2 +-
>  .../media/platform/exynos4-is/fimc-capture.c  |  2 +-
>  drivers/media/platform/rcar-vin/rcar-core.c   |  2 +-
>  drivers/media/platform/rcar_drif.c            |  2 +-
>  .../media/platform/soc_camera/soc_camera.c    |  3 +-
>  drivers/media/platform/vivid/vivid-ctrls.c    | 46 +++++++++----------
>  drivers/media/usb/cx231xx/cx231xx-417.c       |  2 +-
>  drivers/media/usb/cx231xx/cx231xx-video.c     |  4 +-
>  drivers/media/usb/msi2500/msi2500.c           |  2 +-
>  drivers/media/usb/tm6000/tm6000-video.c       |  2 +-
>  drivers/media/v4l2-core/v4l2-ctrls.c          | 11 +++--
>  drivers/media/v4l2-core/v4l2-device.c         |  3 +-
>  drivers/staging/media/imx/imx-media-dev.c     |  2 +-
>  drivers/staging/media/imx/imx-media-fim.c     |  2 +-
>  include/media/v4l2-ctrls.h                    |  8 +++-
>  21 files changed, 61 insertions(+), 49 deletions(-)
> 

<snip>

> diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
> index 289d775c4820..08799beaea42 100644
> --- a/drivers/staging/media/imx/imx-media-dev.c
> +++ b/drivers/staging/media/imx/imx-media-dev.c
> @@ -391,7 +391,7 @@ static int imx_media_inherit_controls(struct imx_media_dev *imxmd,
>  
>  		ret = v4l2_ctrl_add_handler(vfd->ctrl_handler,
>  					    sd->ctrl_handler,
> -					    NULL);
> +					    NULL, true);
>  		if (ret)
>  			return ret;
>  	}
> diff --git a/drivers/staging/media/imx/imx-media-fim.c b/drivers/staging/media/imx/imx-media-fim.c
> index 6df189135db8..8cf773eef9da 100644
> --- a/drivers/staging/media/imx/imx-media-fim.c
> +++ b/drivers/staging/media/imx/imx-media-fim.c
> @@ -463,7 +463,7 @@ int imx_media_fim_add_controls(struct imx_media_fim *fim)
>  {
>  	/* add the FIM controls to the calling subdev ctrl handler */
>  	return v4l2_ctrl_add_handler(fim->sd->ctrl_handler,
> -				     &fim->ctrl_handler, NULL);
> +				     &fim->ctrl_handler, NULL, false);
>  }
>  EXPORT_SYMBOL_GPL(imx_media_fim_add_controls);
>  
