Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:43066 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab2KPWjI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Nov 2012 17:39:08 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so1259969eaa.19
        for <linux-media@vger.kernel.org>; Fri, 16 Nov 2012 14:39:05 -0800 (PST)
Message-ID: <50A6C086.50208@gmail.com>
Date: Fri, 16 Nov 2012 23:39:02 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Alexey Klimov <klimov.linux@gmail.com>
CC: linux-media@vger.kernel.org, dron0gus@gmail.com,
	tomasz.figa@gmail.com, oselas@community.pengutronix.de
Subject: Re: [PATCH RFC v3 1/3] V4L: Add driver for S3C244X/S3C64XX SoC series
 camera interface
References: <1353017115-11492-1-git-send-email-sylvester.nawrocki@gmail.com> <1353017115-11492-2-git-send-email-sylvester.nawrocki@gmail.com> <CALW4P+JQUcywagZAe5qHRifsSwAnKoDccmhpQ=TSWvxcS-6CqA@mail.gmail.com> <CALW4P+KBd8fxCX8qSuZGYPx8pYj6LhEZfCurzuKuZzApe7Z7Aw@mail.gmail.com>
In-Reply-To: <CALW4P+KBd8fxCX8qSuZGYPx8pYj6LhEZfCurzuKuZzApe7Z7Aw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alexey,

On 11/16/2012 03:10 PM, Alexey Klimov wrote:
>>> +static int s3c_camif_hw_init(struct camif_dev *camif, struct camif_vp
>>> *vp)
>>> +{
>>> +       unsigned int ip_rev = camif->variant->ip_revision;
>>> +       unsigned long flags;
>>> +
>>> +       if (camif->sensor.sd == NULL || vp->out_fmt == NULL)
>>> +               return -EINVAL;
>>> +
>>> +       spin_lock_irqsave(&camif->slock, flags);
>>> +
>>> +       if (ip_rev == S3C244X_CAMIF_IP_REV)
>>> +               camif_hw_clear_fifo_overflow(vp);
>>> +       camif_hw_set_camera_bus(camif);
>>> +       camif_hw_set_source_format(camif);
>>> +       camif_hw_set_camera_crop(camif);
>>> +       camif_hw_set_test_pattern(camif, camif->test_pattern->val);
>>> +       if (ip_rev == S3C6410_CAMIF_IP_REV)
>>> +               camif_hw_set_input_path(vp);
>>> +       camif_cfg_video_path(vp);
>>> +       vp->state&= ~ST_VP_CONFIG;
>>> +
>>> +       spin_unlock_irqrestore(&camif->slock, flags);
>>> +       return 0;
>>> +}
>>> +
>>> +/*
>>> + * Initialize the video path, only up from the scaler stage. The camera
>>> + * input interface set up is skipped. This is useful to enable one of
>>> the
>>> + * video paths when the other is already running.
>>> + */
>>> +static int s3c_camif_hw_vp_init(struct camif_dev *camif, struct camif_vp
>>> *vp)
>>> +{
>>> +       unsigned int ip_rev = camif->variant->ip_revision;
>>> +       unsigned long flags;
>>> +
>>> +       if (vp->out_fmt == NULL)
>>> +               return -EINVAL;
>>> +
>>> +       spin_lock_irqsave(&camif->slock, flags);
>>> +       camif_prepare_dma_offset(vp);
>>> +       if (ip_rev == S3C244X_CAMIF_IP_REV)
>>> +               camif_hw_clear_fifo_overflow(vp);
>>> +       camif_cfg_video_path(vp);
>>> +       if (ip_rev == S3C6410_CAMIF_IP_REV)
>>> +               camif_hw_set_effect(vp, false);
>>> +       vp->state&= ~ST_VP_CONFIG;
>>> +
>>> +       spin_unlock_irqrestore(&camif->slock, flags);
>>> +       return 0;
>>> +}
...
>>> +/*
>>> + * Reinitialize the driver so it is ready to start streaming again.
>>> + * Return any buffers to vb2, perform CAMIF software reset and
>>> + * turn off streaming at the data pipeline (sensor) if required.
>>> + */
>>> +static int camif_reinitialize(struct camif_vp *vp)
>>> +{
>>> +       struct camif_dev *camif = vp->camif;
>>> +       struct camif_buffer *buf;
>>> +       unsigned long flags;
>>> +       bool streaming;
>>> +
>>> +       spin_lock_irqsave(&camif->slock, flags);
>>> +       streaming = vp->state&  ST_VP_SENSOR_STREAMING;
>>> +
>>> +       vp->state&= ~(ST_VP_PENDING | ST_VP_RUNNING | ST_VP_OFF |
>>> +                      ST_VP_ABORTING | ST_VP_STREAMING |
>>> +                      ST_VP_SENSOR_STREAMING | ST_VP_LASTIRQ);
>>> +
>>> +       /* Release unused buffers */
>>> +       while (!list_empty(&vp->pending_buf_q)) {
>>> +               buf = camif_pending_queue_pop(vp);
>>> +               vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>>> +       }
>>> +
>>> +       while (!list_empty(&vp->active_buf_q)) {
>>> +               buf = camif_active_queue_pop(vp);
>>> +               vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>>> +       }
>>> +
>>> +       spin_unlock_irqrestore(&camif->slock, flags);
>>> +
>>> +       if (!streaming)
>>> +               return 0;
>>> +
>>> +       return sensor_set_streaming(camif, 0);
>>> +}
...
>>> +static int start_streaming(struct vb2_queue *vq, unsigned int count)
>>> +{
>>> +       struct camif_vp *vp = vb2_get_drv_priv(vq);
>>> +       struct camif_dev *camif = vp->camif;
>>> +       unsigned long flags;
>>> +       int ret;
>>> +
>>> +       /*
>>> +        * We assume the codec capture path is always activated
>>> +        * first, before the preview path starts streaming.
>>> +        * This is required to avoid internal FIFO overflow and
>>> +        * a need for CAMIF software reset.
>>> +        */
>>> +       spin_lock_irqsave(&camif->slock, flags);
>
> Here.
>
>>>
>>> +
>>> +       if (camif->stream_count == 0) {
>>> +               camif_hw_reset(camif);
>>> +               spin_unlock_irqrestore(&camif->slock, flags);
>>> +               ret = s3c_camif_hw_init(camif, vp);
>>> +       } else {
>>> +               spin_unlock_irqrestore(&camif->slock, flags);
>>> +               ret = s3c_camif_hw_vp_init(camif, vp);
>>> +       }
>>> +
>>> +       if (ret<  0) {
>>> +               camif_reinitialize(vp);
>>> +               return ret;
>>> +       }
>>> +
>>> +       spin_lock_irqsave(&camif->slock, flags);
>
> Could you please check this function? Is it ok that you have double
> spin_lock_irqsave()? I don't know may be it's okay. Also when you call
> camif_reinitialize() you didn't call spin_unlock_irqrestore() before and
> inside camif_reinitialize() you will also call spin_lock_irqsave()..

Certainly with nested spinlock locking this code would have been useless.
I suppose this is what you mean by "double spin_lock_irqsave()". Since
it is known to work there must be spin_unlock_irqrestore() somewhere,
before the second spin_lock_irqsave() above. Just look around with more
focus ;)

Nevertheless, it looks locking can be removed from functions
s3c_camif_hw_init() and s3c_camif_vp_init(), those are called only from
one place, where in addition the spinlock is already held. I'm going
to squash following patch into that one:

----8<------
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c 
b/drivers/media/platform/s3c-camif/camif-capture.c
index c2ecdcc..6401fdb 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -43,7 +43,7 @@
  static int debug;
  module_param(debug, int, 0644);

-/* Locking: called with vp->camif->slock held */
+/* Locking: called with vp->camif->slock spinlock held */
  static void camif_cfg_video_path(struct camif_vp *vp)
  {
  	WARN_ON(s3c_camif_get_scaler_config(vp, &vp->scaler));
@@ -64,16 +64,14 @@ static void camif_prepare_dma_offset(struct camif_vp 
*vp)
  		 f->dma_offset.initial, f->dma_offset.line);
  }

+/* Locking: called with camif->slock spinlock held */
  static int s3c_camif_hw_init(struct camif_dev *camif, struct camif_vp *vp)
  {
  	const struct s3c_camif_variant *variant = camif->variant;
-	unsigned long flags;

  	if (camif->sensor.sd == NULL || vp->out_fmt == NULL)
  		return -EINVAL;

-	spin_lock_irqsave(&camif->slock, flags);
-
  	if (variant->ip_revision == S3C244X_CAMIF_IP_REV)
  		camif_hw_clear_fifo_overflow(vp);
  	camif_hw_set_camera_bus(camif);
@@ -88,7 +86,6 @@ static int s3c_camif_hw_init(struct camif_dev *camif, 
struct camif_vp *vp)
  	camif_cfg_video_path(vp);
  	vp->state &= ~ST_VP_CONFIG;

-	spin_unlock_irqrestore(&camif->slock, flags);
  	return 0;
  }

@@ -96,23 +93,20 @@ static int s3c_camif_hw_init(struct camif_dev 
*camif, struct camif_vp *vp)
   * Initialize the video path, only up from the scaler stage. The camera
   * input interface set up is skipped. This is useful to enable one of the
   * video paths when the other is already running.
+ * Locking: called with camif->slock spinlock held.
   */
  static int s3c_camif_hw_vp_init(struct camif_dev *camif, struct 
camif_vp *vp)
  {
  	unsigned int ip_rev = camif->variant->ip_revision;
-	unsigned long flags;

  	if (vp->out_fmt == NULL)
  		return -EINVAL;

-	spin_lock_irqsave(&camif->slock, flags);
  	camif_prepare_dma_offset(vp);
  	if (ip_rev == S3C244X_CAMIF_IP_REV)
  		camif_hw_clear_fifo_overflow(vp);
  	camif_cfg_video_path(vp);
  	vp->state &= ~ST_VP_CONFIG;
-
-	spin_unlock_irqrestore(&camif->slock, flags);
  	return 0;
  }

@@ -401,12 +395,11 @@ static int start_streaming(struct vb2_queue *vq, 
unsigned int count)

  	if (camif->stream_count == 0) {
  		camif_hw_reset(camif);
-		spin_unlock_irqrestore(&camif->slock, flags);
  		ret = s3c_camif_hw_init(camif, vp);
  	} else {
-		spin_unlock_irqrestore(&camif->slock, flags);
  		ret = s3c_camif_hw_vp_init(camif, vp);
  	}
+	spin_unlock_irqrestore(&camif->slock, flags);

  	if (ret < 0) {
  		camif_reinitialize(vp);
@@ -437,8 +430,8 @@ static int start_streaming(struct vb2_queue *vq, 
unsigned int count)
  			return ret;
  		}
  	}
-	spin_unlock_irqrestore(&camif->slock, flags);

+	spin_unlock_irqrestore(&camif->slock, flags);
  	return 0;
  }
---->8------


Thank you.


--
Regards,
Sylwester
