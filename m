Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:1491 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaF0NfQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 09:35:16 -0400
Message-ID: <53AD72F5.3000903@xs4all.nl>
Date: Fri, 27 Jun 2014 15:34:45 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Shuah Khan <shuah.kh@samsung.com>, gregkh@linuxfoundation.org,
	m.chehab@samsung.com, olebowle@gmx.com, ttmesterr@gmail.com,
	dheitmueller@kernellabs.com, cb.xiong@samsung.com,
	yongjun_wei@trendmicro.com.cn, hans.verkuil@cisco.com,
	prabhakar.csengg@gmail.com, laurent.pinchart@ideasonboard.com,
	sakari.ailus@linux.intel.com, crope@iki.fi,
	wade_farnsworth@mentor.com, ricardo.ribalda@gmail.com
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] media: v4l2-core changes to use tuner token
References: <cover.1403652043.git.shuah.kh@samsung.com> <a73d058a4c04bbcf9716fd41fce844675629f8d9.1403652043.git.shuah.kh@samsung.com>
In-Reply-To: <a73d058a4c04bbcf9716fd41fce844675629f8d9.1403652043.git.shuah.kh@samsung.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On 06/25/2014 01:57 AM, Shuah Khan wrote:
> Add a new field tuner_tkn to struct video_device. Drivers can
> create tuner token using devm_token_create() and initialize
> the tuner_tkn when frontend is registered with the dvb-core.
> This change enables drivers to provide a token devres for tuner
> access control.
>
> Change v4l2-core to lock tuner token for exclusive access to
> tuner function for analog TV function use. When Tuner token is
> present, v4l2_open() calls devm_token_lock() to lock the token.
> If token is busy, -EBUSY is returned to the user-space.
>
> Tuner token is unlocked in error paths in v4l2_open(). This token
> is held as long as the v4l2 device is open and unlocked from
> v4l2_release().
>
> Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
> ---
>   drivers/media/v4l2-core/v4l2-dev.c |   23 ++++++++++++++++++++++-
>   include/media/v4l2-dev.h           |    1 +
>   2 files changed, 23 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index 634d863..8dff809 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -26,6 +26,7 @@
>   #include <linux/kmod.h>
>   #include <linux/slab.h>
>   #include <asm/uaccess.h>
> +#include <linux/token_devres.h>
>
>   #include <media/v4l2-common.h>
>   #include <media/v4l2-device.h>
> @@ -445,6 +446,17 @@ static int v4l2_open(struct inode *inode, struct file *filp)
>   		mutex_unlock(&videodev_lock);
>   		return -ENODEV;
>   	}
> +	/* check if tuner is busy first */
> +	if (vdev->tuner_tkn && vdev->dev_parent) {
> +		ret = devm_token_lock(vdev->dev_parent, vdev->tuner_tkn);
> +		if (ret) {
> +			mutex_unlock(&videodev_lock);
> +			dev_info(vdev->dev_parent, "v4l2: Tuner is busy\n");
> +			return ret;
> +		}

If I understand this correctly, then this will make it impossible to open
the same video node twice since devm_token_lock will return EBUSY the
second time. Ditto for DVB as far as I could tell. That is certainly not
what you want, at least not for V4L.

In V4L2 the rules for tuner ownership are complicated, especially if the
tuner has a radio mode as well, see this presentation (the last two slides):

http://linuxtv.org/downloads/presentations/media_ws_2012_EU/ambiguities2.odp

Regards,

	Hans

> +		dev_info(vdev->dev_parent, "v4l2: Tuner is locked\n");
> +	}
> +
>   	/* and increase the device refcount */
>   	video_get(vdev);
>   	mutex_unlock(&videodev_lock);
> @@ -459,8 +471,13 @@ static int v4l2_open(struct inode *inode, struct file *filp)
>   		printk(KERN_DEBUG "%s: open (%d)\n",
>   			video_device_node_name(vdev), ret);
>   	/* decrease the refcount in case of an error */
> -	if (ret)
> +	if (ret) {
>   		video_put(vdev);
> +		if (vdev->tuner_tkn && vdev->dev_parent) {
> +			devm_token_unlock(vdev->dev_parent, vdev->tuner_tkn);
> +			dev_info(vdev->dev_parent, "v4l2: Tuner is unlocked\n");
> +		}
> +	}
>   	return ret;
>   }
>
> @@ -479,6 +496,10 @@ static int v4l2_release(struct inode *inode, struct file *filp)
>   	/* decrease the refcount unconditionally since the release()
>   	   return value is ignored. */
>   	video_put(vdev);
> +	if (vdev->tuner_tkn && vdev->dev_parent) {
> +		devm_token_unlock(vdev->dev_parent, vdev->tuner_tkn);
> +		dev_info(vdev->dev_parent, "v4l2: Tuner is unlocked\n");
> +	}
>   	return ret;
>   }
>
> diff --git a/include/media/v4l2-dev.h b/include/media/v4l2-dev.h
> index eec6e46..1676349 100644
> --- a/include/media/v4l2-dev.h
> +++ b/include/media/v4l2-dev.h
> @@ -141,6 +141,7 @@ struct video_device
>   	/* serialization lock */
>   	DECLARE_BITMAP(disable_locking, BASE_VIDIOC_PRIVATE);
>   	struct mutex *lock;
> +	char *tuner_tkn;
>   };
>
>   #define media_entity_to_video_device(__e) \
>
