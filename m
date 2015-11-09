Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45240 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbbKIU4D (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2015 15:56:03 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Junsu Shin <jjunes0@gmail.com>
Cc: mchehab@osg.samsung.com, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, sakari.ailus@linux.intel.com,
	mahfouz.saif.elyazal@gmail.com, boris.brezillon@free-electrons.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: media: davinci_vpfe: Fix over 80 characters coding style issue
Date: Mon, 09 Nov 2015 22:56:14 +0200
Message-ID: <43865783.PsqqNIiBss@avalon>
In-Reply-To: <1439242859-12268-1-git-send-email-jjunes0@gmail.com>
References: <1439242859-12268-1-git-send-email-jjunes0@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Junsu,

Thank you for the patch.

On Monday 10 August 2015 16:40:59 Junsu Shin wrote:
> This is a patch to the dm365_ipipe.c that fixes over 80 characters warning
> detected.

It's a bit ironic to submit a patch fixing a 80 characters limit issue and 
having a commit message that is larger than 72 characters per line :-)

Anyway, I've wrapped the commit message to 72 columns and applied the patch to 
my tree.

> Signed-off-by: Junsu Shin <jjunes0@gmail.com>
> ---
>  drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c index 1bbb90c..a474adf
> 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> @@ -1536,8 +1536,9 @@ ipipe_get_format(struct v4l2_subdev *sd, struct
> v4l2_subdev_pad_config *cfg, * @fse: pointer to v4l2_subdev_frame_size_enum
> structure.
>   */
>  static int
> -ipipe_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config
> *cfg, -			  struct v4l2_subdev_frame_size_enum *fse)
> +ipipe_enum_frame_size(struct v4l2_subdev *sd,
> +		       struct v4l2_subdev_pad_config *cfg,
> +		       struct v4l2_subdev_frame_size_enum *fse)
>  {
>  	struct vpfe_ipipe_device *ipipe = v4l2_get_subdevdata(sd);
>  	struct v4l2_mbus_framefmt format;

-- 
Regards,

Laurent Pinchart

