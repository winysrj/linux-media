Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36749 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbbHGEpO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Aug 2015 00:45:14 -0400
Date: Fri, 7 Aug 2015 10:15:05 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Junsu Shin <jjunes0@gmail.com>
Cc: mchehab@osg.samsung.com, gregkh@linuxfoundation.org,
	devel@driverdev.osuosl.org, boris.brezillon@free-electrons.com,
	linux-kernel@vger.kernel.org, prabhakar.csengg@gmail.com,
	hans.verkuil@cisco.com, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] Staging: media: davinci_vpfe: fix over 80 characters
 coding style issue.
Message-ID: <20150807044505.GB3537@sudip-pc>
References: <1438916154-5840-1-git-send-email-jjunes0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1438916154-5840-1-git-send-email-jjunes0@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 06, 2015 at 09:55:54PM -0500, Junsu Shin wrote:
>  This is a patch to the dm365_ipipe.c that fixes over 80 characters warning detected by checkpatch.pl.
>  Signed-off-by: Junsu Shin <jjunes0@gmail.com>
please do not use whitespace before Signed-off-by: line.
> 
> ---
>  drivers/staging/media/davinci_vpfe/dm365_ipipe.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> index 1bbb90c..57cd274 100644
> --- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> +++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
> @@ -1536,8 +1536,9 @@ ipipe_get_format(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
>   * @fse: pointer to v4l2_subdev_frame_size_enum structure.
>   */
>  static int
> -ipipe_enum_frame_size(struct v4l2_subdev *sd, struct v4l2_subdev_pad_config *cfg,
> -			  struct v4l2_subdev_frame_size_enum *fse)
> +ipipe_enum_frame_size(struct v4l2_subdev *sd,
> +			struct v4l2_subdev_pad_config *cfg,
> +			struct v4l2_subdev_frame_size_enum *fse)
since you are modifying this line, please fix up the indention also.

regards
sudip
