Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44138 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751445AbdB1Nng (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Feb 2017 08:43:36 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 6/6] media: devnode: Rename mdev argument as devnode
Date: Tue, 28 Feb 2017 15:42:56 +0200
Message-ID: <2123535.DU85XbeNND@avalon>
In-Reply-To: <1487604142-27610-7-git-send-email-sakari.ailus@linux.intel.com>
References: <1487604142-27610-1-git-send-email-sakari.ailus@linux.intel.com> <1487604142-27610-7-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 20 Feb 2017 17:22:22 Sakari Ailus wrote:
> Historically, mdev argument name was being used on both struct
> media_device and struct media_devnode. Recently most occurrences of mdev
> referring to struct media_devnode were replaced by devnode, which makes
> more sense. Fix the last remaining occurrence.
> 
> Fixes: 163f1e93e9950 ("[media] media-devnode: fix namespace mess")
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/media-device.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index c51e2e5..fce91b5 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -537,9 +537,9 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
>   * Registration/unregistration
>   */
> 
> -static void media_device_release(struct media_devnode *mdev)
> +static void media_device_release(struct media_devnode *devnode)
>  {
> -	dev_dbg(mdev->parent, "Media device released\n");
> +	dev_dbg(devnode->parent, "Media device released\n");
>  }
> 
>  /**

-- 
Regards,

Laurent Pinchart
