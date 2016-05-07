Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:43498 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092AbcEGM66 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 May 2016 08:58:58 -0400
Date: Sat, 7 May 2016 09:58:51 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: hans.verkuil@cisco.com, chehabrafael@gmail.com,
	javier@osg.samsung.com, inki.dae@samsung.com,
	jh1009.sung@samsung.com, sakari.ailus@linux.intel.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] media: v4l2-mc add v4l_change_media_source() to
 invoke change_source
Message-ID: <20160507095851.37a4fb19@recife.lan>
In-Reply-To: <1457633868-4861-1-git-send-email-shuahkh@osg.samsung.com>
References: <1457633868-4861-1-git-send-email-shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 10 Mar 2016 11:17:48 -0700
Shuah Khan <shuahkh@osg.samsung.com> escreveu:

> Add a common routine to invoke media device change_source handler.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>

Shuah,

I'm marking this series of patches as superseded at patchwork, as I
intend that you'll be submitting it somewhere in the future,
together with a new version of the snd-usb-audio MC support (when ready
for upstream merge), and if this is still needed.

Regards,
Mauro

> ---
> 
> Changes since v1:
> - Fixed !CONFIG_MEDIA_CONTROLLER compile error for v4l_change_media_source()
> 
>  drivers/media/v4l2-core/v4l2-mc.c | 14 ++++++++++++++
>  include/media/v4l2-mc.h           | 25 ++++++++++++++++++++++++-
>  2 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
> index ae661ac..478b2768 100644
> --- a/drivers/media/v4l2-core/v4l2-mc.c
> +++ b/drivers/media/v4l2-core/v4l2-mc.c
> @@ -217,6 +217,20 @@ void v4l_disable_media_source(struct video_device *vdev)
>  }
>  EXPORT_SYMBOL_GPL(v4l_disable_media_source);
>  
> +int v4l_change_media_source(struct video_device *vdev)
> +{
> +	struct media_device *mdev = vdev->entity.graph_obj.mdev;
> +	int ret;
> +
> +	if (!mdev || !mdev->change_source)
> +		return 0;
> +	ret = mdev->change_source(&vdev->entity, &vdev->pipe);
> +	if (ret)
> +		return -EBUSY;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(v4l_change_media_source);
> +
>  int v4l_vb2q_enable_media_source(struct vb2_queue *q)
>  {
>  	struct v4l2_fh *fh = q->owner;
> diff --git a/include/media/v4l2-mc.h b/include/media/v4l2-mc.h
> index 98a938a..50b9348 100644
> --- a/include/media/v4l2-mc.h
> +++ b/include/media/v4l2-mc.h
> @@ -154,8 +154,26 @@ int v4l_enable_media_source(struct video_device *vdev);
>   */
>  void v4l_disable_media_source(struct video_device *vdev);
>  
> +/**
> + * v4l_change_media_source() -	Hold media source for exclusive use
> + *				if free
> + *
> + * @vdev:	pointer to struct video_device
> + *
> + * This interface calls change_source handler to change
> + * the current source it is holding. The change_source
> + * disables the current source and starts pipeline to
> + * the new source. This interface should be used when
> + * user changes source using s_input handler to keep
> + * the previously granted permission for exclusive use
> + * with a new input source.
> + *
> + * Return: returns zero on success or a negative error code.
> + */
> +int v4l_change_media_source(struct video_device *vdev);
> +
>  /*
> - * v4l_vb2q_enable_media_tuner -  Hold media source for exclusive use
> + * v4l_vb2q_enable_media_source - Hold media source for exclusive use
>   *				  if free.
>   * @q - pointer to struct vb2_queue
>   *
> @@ -219,6 +237,11 @@ static inline int v4l_enable_media_source(struct video_device *vdev)
>  	return 0;
>  }
>  
> +static inline int v4l_change_media_source(struct video_device *vdev)
> +{
> +	return 0;
> +}
> +
>  static inline void v4l_disable_media_source(struct video_device *vdev)
>  {
>  }


-- 
Thanks,
Mauro
