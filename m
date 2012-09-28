Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3118 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab2I1OP7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Sep 2012 10:15:59 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Albert Wang <twang13@marvell.com>
Subject: Re: [PATCH 2/4] [media] marvell-ccic: core: add soc camera support on marvell-ccic mcam-core
Date: Fri, 28 Sep 2012 16:15:49 +0200
Cc: corbet@lwn.net, g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
References: <1348840040-21390-1-git-send-email-twang13@marvell.com>
In-Reply-To: <1348840040-21390-1-git-send-email-twang13@marvell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201209281615.49420.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri September 28 2012 15:47:20 Albert Wang wrote:
> From: Libin Yang <lbyang@marvell.com>
> 
> This patch adds the support of Soc Camera on marvell-ccic mcam-core.
> The Soc Camera mode does not compatible with current mode.
> Only one mode can be used at one time.
> 
> To use Soc Camera, CONFIG_VIDEO_MMP_SOC_CAMERA should be defined.
> What's more, the platform driver should support Soc camera at the same time.
> 
> Also add MIPI interface and dual CCICs support in Soc Camera mode.
> 
> Signed-off-by: Albert Wang <twang13@marvell.com>
> Signed-off-by: Libin Yang <lbyang@marvell.com>
> ---
>  drivers/media/platform/marvell-ccic/mcam-core.c | 1034 ++++++++++++++++++++++----
>  drivers/media/platform/marvell-ccic/mcam-core.h |  126 +++-
>  2 files changed, 997 insertions(+), 163 deletions(-)
> 
> diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
> index ce2b7b4..4adb1ca 100755
> --- a/drivers/media/platform/marvell-ccic/mcam-core.c
> +++ b/drivers/media/platform/marvell-ccic/mcam-core.c

...

> +static int mcam_camera_querycap(struct soc_camera_host *ici,
> +			struct v4l2_capability *cap)
> +{
> +	struct v4l2_dbg_chip_ident id;
> +	struct mcam_camera *mcam = ici->priv;
> +	struct soc_camera_device *icd = mcam->icd;
> +	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
> +	int ret = 0;
> +
> +	cap->version = KERNEL_VERSION(0, 0, 5);

Don't fill in version. It's set to the kernel version automatically.

> +	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;

Please also set cap->device_caps. See the spec.

> +	ret = v4l2_subdev_call(sd, core, g_chip_ident, &id);

Yuck. Don't abuse this. g_chip_ident is for debugging purposes only.

> +	if (ret < 0) {
> +		cam_err(mcam, "%s %d\n", __func__, __LINE__);
> +		return ret;
> +	}
> +
> +	strcpy(cap->card, mcam->card_name);
> +	strncpy(cap->driver, (const char *)&(id.ident), 4);

No, the name of the driver is the name of this module: marvell_ccic.
It's *not* the name of the sensor driver.

> +
> +	return 0;
> +}

Regards,

	Hans
