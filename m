Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:55342 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756666AbcK2JWj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 Nov 2016 04:22:39 -0500
Date: Tue, 29 Nov 2016 11:22:31 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: mchehab@kernel.org, mkrufky@linuxtv.org, klock.android@gmail.com,
        elfring@users.sourceforge.net, max@duempel.org,
        hans.verkuil@cisco.com, javier@osg.samsung.com,
        chehabrafael@gmail.com, sakari.ailus@linux.intel.com,
        laurent.pinchart+renesas@ideasonboard.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] media: protect enable and disable source handler
 checks and calls
Message-ID: <20161129092230.GL16630@valkosipuli.retiisi.org.uk>
References: <cover.1480384155.git.shuahkh@osg.samsung.com>
 <54975937478803ef4883e9caecb8af0ef282e35c.1480384155.git.shuahkh@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54975937478803ef4883e9caecb8af0ef282e35c.1480384155.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

On Mon, Nov 28, 2016 at 07:15:14PM -0700, Shuah Khan wrote:
> Protect enable and disable source handler checks and calls from dvb-core
> and v4l2-core. Hold graph_mutex to check if enable and disable source
> handlers are present and invoke them while holding the mutex. This change
> ensures these handlers will not be removed while they are being checked
> and invoked.
> 
> au08282 enable and disable source handlers are changed to not hold the
> graph_mutex.
> 
> Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
> ---
>  drivers/media/dvb-core/dvb_frontend.c  | 24 ++++++++++++++++++------
>  drivers/media/usb/au0828/au0828-core.c | 17 +++++------------
>  drivers/media/v4l2-core/v4l2-mc.c      | 26 ++++++++++++++++++--------
>  3 files changed, 41 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index 01511e5..2f09c7e 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -2527,9 +2527,13 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
>  		fepriv->voltage = -1;
>  
>  #ifdef CONFIG_MEDIA_CONTROLLER_DVB
> -		if (fe->dvb->mdev && fe->dvb->mdev->enable_source) {
> -			ret = fe->dvb->mdev->enable_source(dvbdev->entity,
> +		if (fe->dvb->mdev) {
> +			mutex_lock(&fe->dvb->mdev->graph_mutex);
> +			if (fe->dvb->mdev->enable_source)
> +				ret = fe->dvb->mdev->enable_source(
> +							   dvbdev->entity,
>  							   &fepriv->pipe);
> +			mutex_unlock(&fe->dvb->mdev->graph_mutex);

You have to make sure the media device actually will stay aronud while it is
being accessed. In this case, when dvb_frontend_open() runs, it will proceed
to access the media device without knowing whether it's going to stay around
or not. Without doing so, it may well be in the process of being removed by
au0828_unregister_media_device() at the same time.

The approach I took in my patchset was that the device that requires the
media device will acquire a reference to it, this way the media device will
stick around as long as other data structures have references to it. The
current set did not yet implement this to dvb devices but I can add that.
Then there's no even a need for the frontend driver to acquire the graph
lock just to call the enable_source() callback.

>  			if (ret) {
>  				dev_err(fe->dvb->device,
>  					"Tuner is busy. Error %d\n", ret);
> @@ -2553,8 +2557,12 @@ static int dvb_frontend_open(struct inode *inode, struct file *file)
>  
>  err3:
>  #ifdef CONFIG_MEDIA_CONTROLLER_DVB
> -	if (fe->dvb->mdev && fe->dvb->mdev->disable_source)
> -		fe->dvb->mdev->disable_source(dvbdev->entity);
> +	if (fe->dvb->mdev) {
> +		mutex_lock(&fe->dvb->mdev->graph_mutex);
> +		if (fe->dvb->mdev->disable_source)
> +			fe->dvb->mdev->disable_source(dvbdev->entity);
> +		mutex_unlock(&fe->dvb->mdev->graph_mutex);
> +	}
>  err2:
>  #endif
>  	dvb_generic_release(inode, file);
> @@ -2586,8 +2594,12 @@ static int dvb_frontend_release(struct inode *inode, struct file *file)
>  	if (dvbdev->users == -1) {
>  		wake_up(&fepriv->wait_queue);
>  #ifdef CONFIG_MEDIA_CONTROLLER_DVB
> -		if (fe->dvb->mdev && fe->dvb->mdev->disable_source)
> -			fe->dvb->mdev->disable_source(dvbdev->entity);
> +		if (fe->dvb->mdev) {
> +			mutex_lock(&fe->dvb->mdev->graph_mutex);
> +			if (fe->dvb->mdev->disable_source)
> +				fe->dvb->mdev->disable_source(dvbdev->entity);
> +			mutex_unlock(&fe->dvb->mdev->graph_mutex);
> +		}
>  #endif
>  		if (fe->exit != DVB_FE_NO_EXIT)
>  			wake_up(&dvbdev->wait_queue);
> diff --git a/drivers/media/usb/au0828/au0828-core.c b/drivers/media/usb/au0828/au0828-core.c
> index a1f696a..bfd6482 100644
> --- a/drivers/media/usb/au0828/au0828-core.c
> +++ b/drivers/media/usb/au0828/au0828-core.c
> @@ -280,6 +280,7 @@ static void au0828_media_graph_notify(struct media_entity *new,
>  	}
>  }
>  
> +/* Callers should hold graph_mutex */
>  static int au0828_enable_source(struct media_entity *entity,
>  				struct media_pipeline *pipe)
>  {
> @@ -293,8 +294,6 @@ static int au0828_enable_source(struct media_entity *entity,
>  	if (!mdev)
>  		return -ENODEV;
>  
> -	mutex_lock(&mdev->graph_mutex);
> -
>  	dev = mdev->source_priv;
>  
>  	/*
> @@ -421,12 +420,12 @@ static int au0828_enable_source(struct media_entity *entity,
>  		 dev->active_source->name, dev->active_sink->name,
>  		 dev->active_link_owner->name, ret);
>  end:
> -	mutex_unlock(&mdev->graph_mutex);
>  	pr_debug("au0828_enable_source() end %s %d %d\n",
>  		 entity->name, entity->function, ret);
>  	return ret;
>  }
>  
> +/* Callers should hold graph_mutex */
>  static void au0828_disable_source(struct media_entity *entity)
>  {
>  	int ret = 0;
> @@ -436,13 +435,10 @@ static void au0828_disable_source(struct media_entity *entity)
>  	if (!mdev)
>  		return;
>  
> -	mutex_lock(&mdev->graph_mutex);
>  	dev = mdev->source_priv;
>  
> -	if (!dev->active_link) {
> -		ret = -ENODEV;
> -		goto end;
> -	}
> +	if (!dev->active_link)
> +		return;
>  
>  	/* link is active - stop pipeline from source (tuner) */
>  	if (dev->active_link->sink->entity == dev->active_sink &&
> @@ -452,7 +448,7 @@ static void au0828_disable_source(struct media_entity *entity)
>  		 * has active pipeline
>  		*/
>  		if (dev->active_link_owner != entity)
> -			goto end;
> +			return;
>  		__media_entity_pipeline_stop(entity);
>  		ret = __media_entity_setup_link(dev->active_link, 0);
>  		if (ret)
> @@ -467,9 +463,6 @@ static void au0828_disable_source(struct media_entity *entity)
>  		dev->active_source = NULL;
>  		dev->active_sink = NULL;
>  	}
> -
> -end:
> -	mutex_unlock(&mdev->graph_mutex);
>  }
>  #endif
>  
> diff --git a/drivers/media/v4l2-core/v4l2-mc.c b/drivers/media/v4l2-core/v4l2-mc.c
> index 8bef433..b169d24 100644
> --- a/drivers/media/v4l2-core/v4l2-mc.c
> +++ b/drivers/media/v4l2-core/v4l2-mc.c
> @@ -198,14 +198,20 @@ EXPORT_SYMBOL_GPL(v4l2_mc_create_media_graph);
>  int v4l_enable_media_source(struct video_device *vdev)
>  {
>  	struct media_device *mdev = vdev->entity.graph_obj.mdev;
> -	int ret;
> +	int ret = 0, err;
>  
> -	if (!mdev || !mdev->enable_source)
> +	if (!mdev)
>  		return 0;
> -	ret = mdev->enable_source(&vdev->entity, &vdev->pipe);
> -	if (ret)
> -		return -EBUSY;
> -	return 0;
> +
> +	mutex_lock(&mdev->graph_mutex);
> +	if (!mdev->enable_source)
> +		goto end;
> +	err = mdev->enable_source(&vdev->entity, &vdev->pipe);
> +	if (err)
> +		ret = -EBUSY;
> +end:
> +	mutex_unlock(&mdev->graph_mutex);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(v4l_enable_media_source);
>  
> @@ -213,8 +219,12 @@ void v4l_disable_media_source(struct video_device *vdev)
>  {
>  	struct media_device *mdev = vdev->entity.graph_obj.mdev;
>  
> -	if (mdev && mdev->disable_source)
> -		mdev->disable_source(&vdev->entity);
> +	if (mdev) {
> +		mutex_lock(&mdev->graph_mutex);
> +		if (mdev->disable_source)
> +			mdev->disable_source(&vdev->entity);
> +		mutex_unlock(&mdev->graph_mutex);
> +	}
>  }
>  EXPORT_SYMBOL_GPL(v4l_disable_media_source);
>  

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
