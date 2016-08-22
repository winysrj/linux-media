Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:46474 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751640AbcHVL5T (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 07:57:19 -0400
Subject: Re: [RFC v2 05/17] media: devnode: Rename mdev argument as devnode
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
References: <1471602228-30722-1-git-send-email-sakari.ailus@linux.intel.com>
 <1471602228-30722-6-git-send-email-sakari.ailus@linux.intel.com>
Cc: m.chehab@osg.samsung.com, shuahkh@osg.samsung.com,
        laurent.pinchart@ideasonboard.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e40e04a5-4816-c143-ba2f-4d11a254541f@xs4all.nl>
Date: Mon, 22 Aug 2016 13:57:13 +0200
MIME-Version: 1.0
In-Reply-To: <1471602228-30722-6-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/19/2016 12:23 PM, Sakari Ailus wrote:
> Historically, mdev argument name was being used on both struct
> media_device and struct media_devnode. Recently most occurrences of mdev
> referring to struct media_devnode were replaced by devnode, which makes
> more sense. Fix the last remaining occurrence.
> 
> Fixes: 163f1e93e9950 ("[media] media-devnode: fix namespace mess")
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/media-device.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 8bdc316..a431775 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -542,9 +542,9 @@ static DEVICE_ATTR(model, S_IRUGO, show_model, NULL);
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
> 
