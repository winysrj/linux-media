Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40001 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755595AbcKVKAG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Nov 2016 05:00:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
        mchehab@osg.samsung.com, shuahkh@osg.samsung.com
Subject: Re: [RFC v4 05/21] media: devnode: Rename mdev argument as devnode
Date: Tue, 22 Nov 2016 12:00:23 +0200
Message-ID: <1758068.or2gDFKXbx@avalon>
In-Reply-To: <1478613330-24691-5-git-send-email-sakari.ailus@linux.intel.com>
References: <20161108135438.GO3217@valkosipuli.retiisi.org.uk> <1478613330-24691-1-git-send-email-sakari.ailus@linux.intel.com> <1478613330-24691-5-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 08 Nov 2016 15:55:14 Sakari Ailus wrote:
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
> index bb19c04..a9d543f 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -540,9 +540,9 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
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

