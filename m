Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61293 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633Ab2KYXVy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 18:21:54 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so10245917oag.19
        for <linux-media@vger.kernel.org>; Sun, 25 Nov 2012 15:21:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50A6C086.50208@gmail.com>
References: <1353017115-11492-1-git-send-email-sylvester.nawrocki@gmail.com>
	<1353017115-11492-2-git-send-email-sylvester.nawrocki@gmail.com>
	<CALW4P+JQUcywagZAe5qHRifsSwAnKoDccmhpQ=TSWvxcS-6CqA@mail.gmail.com>
	<CALW4P+KBd8fxCX8qSuZGYPx8pYj6LhEZfCurzuKuZzApe7Z7Aw@mail.gmail.com>
	<50A6C086.50208@gmail.com>
Date: Mon, 26 Nov 2012 02:21:54 +0300
Message-ID: <CALW4P+JiUYJHxycJnt+QJukvYU4YcHdS8JjGDSAASEZ5t8eYbw@mail.gmail.com>
Subject: Re: [PATCH RFC v3 1/3] V4L: Add driver for S3C244X/S3C64XX SoC series
 camera interface
From: Alexey Klimov <klimov.linux@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-media@vger.kernel.org, dron0gus@gmail.com,
	tomasz.figa@gmail.com, oselas@community.pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Sat, Nov 17, 2012 at 2:39 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi Alexey,
>
>
> On 11/16/2012 03:10 PM, Alexey Klimov wrote:
>>>>
>>>> +static int s3c_camif_hw_init(struct camif_dev *camif, struct camif_vp
>>>> *vp)
>>>> +{
>>>> +       unsigned int ip_rev = camif->variant->ip_revision;
>>>> +       unsigned long flags;
>>>> +
>>>> +       if (camif->sensor.sd == NULL || vp->out_fmt == NULL)
>>>> +               return -EINVAL;
>>>> +
>>>> +       spin_lock_irqsave(&camif->slock, flags);
>>>> +
>>>> +       if (ip_rev == S3C244X_CAMIF_IP_REV)
>>>> +               camif_hw_clear_fifo_overflow(vp);
>>>> +       camif_hw_set_camera_bus(camif);
>>>> +       camif_hw_set_source_format(camif);
>>>> +       camif_hw_set_camera_crop(camif);
>>>> +       camif_hw_set_test_pattern(camif, camif->test_pattern->val);
>>>> +       if (ip_rev == S3C6410_CAMIF_IP_REV)
>>>> +               camif_hw_set_input_path(vp);
>>>> +       camif_cfg_video_path(vp);
>>>> +       vp->state&= ~ST_VP_CONFIG;
>>>>
>>>> +
>>>> +       spin_unlock_irqrestore(&camif->slock, flags);
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +/*
>>>> + * Initialize the video path, only up from the scaler stage. The camera
>>>> + * input interface set up is skipped. This is useful to enable one of
>>>> the
>>>> + * video paths when the other is already running.
>>>> + */
>>>> +static int s3c_camif_hw_vp_init(struct camif_dev *camif, struct
>>>> camif_vp
>>>> *vp)
>>>> +{
>>>> +       unsigned int ip_rev = camif->variant->ip_revision;
>>>> +       unsigned long flags;
>>>> +
>>>> +       if (vp->out_fmt == NULL)
>>>> +               return -EINVAL;
>>>> +
>>>> +       spin_lock_irqsave(&camif->slock, flags);
>>>> +       camif_prepare_dma_offset(vp);
>>>> +       if (ip_rev == S3C244X_CAMIF_IP_REV)
>>>> +               camif_hw_clear_fifo_overflow(vp);
>>>> +       camif_cfg_video_path(vp);
>>>> +       if (ip_rev == S3C6410_CAMIF_IP_REV)
>>>> +               camif_hw_set_effect(vp, false);
>>>> +       vp->state&= ~ST_VP_CONFIG;
>>>>
>>>> +
>>>> +       spin_unlock_irqrestore(&camif->slock, flags);
>>>> +       return 0;
>>>> +}
>
> ...
>>>>
>>>> +/*
>>>> + * Reinitialize the driver so it is ready to start streaming again.
>>>> + * Return any buffers to vb2, perform CAMIF software reset and
>>>> + * turn off streaming at the data pipeline (sensor) if required.
>>>> + */
>>>> +static int camif_reinitialize(struct camif_vp *vp)
>>>> +{
>>>> +       struct camif_dev *camif = vp->camif;
>>>> +       struct camif_buffer *buf;
>>>> +       unsigned long flags;
>>>> +       bool streaming;
>>>> +
>>>> +       spin_lock_irqsave(&camif->slock, flags);
>>>> +       streaming = vp->state&  ST_VP_SENSOR_STREAMING;
>>>> +
>>>> +       vp->state&= ~(ST_VP_PENDING | ST_VP_RUNNING | ST_VP_OFF |
>>>>
>>>> +                      ST_VP_ABORTING | ST_VP_STREAMING |
>>>> +                      ST_VP_SENSOR_STREAMING | ST_VP_LASTIRQ);
>>>> +
>>>> +       /* Release unused buffers */
>>>> +       while (!list_empty(&vp->pending_buf_q)) {
>>>> +               buf = camif_pending_queue_pop(vp);
>>>> +               vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>>>> +       }
>>>> +
>>>> +       while (!list_empty(&vp->active_buf_q)) {
>>>> +               buf = camif_active_queue_pop(vp);
>>>> +               vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
>>>> +       }
>>>> +
>>>> +       spin_unlock_irqrestore(&camif->slock, flags);
>>>> +
>>>> +       if (!streaming)
>>>> +               return 0;
>>>> +
>>>> +       return sensor_set_streaming(camif, 0);
>>>> +}
>
> ...
>
>>>> +static int start_streaming(struct vb2_queue *vq, unsigned int count)
>>>> +{
>>>> +       struct camif_vp *vp = vb2_get_drv_priv(vq);
>>>> +       struct camif_dev *camif = vp->camif;
>>>> +       unsigned long flags;
>>>> +       int ret;
>>>> +
>>>> +       /*
>>>> +        * We assume the codec capture path is always activated
>>>> +        * first, before the preview path starts streaming.
>>>> +        * This is required to avoid internal FIFO overflow and
>>>> +        * a need for CAMIF software reset.
>>>> +        */
>>>> +       spin_lock_irqsave(&camif->slock, flags);
>>
>>
>> Here.
>>
>>>>
>>>> +
>>>> +       if (camif->stream_count == 0) {
>>>> +               camif_hw_reset(camif);
>>>> +               spin_unlock_irqrestore(&camif->slock, flags);
>>>> +               ret = s3c_camif_hw_init(camif, vp);
>>>> +       } else {
>>>> +               spin_unlock_irqrestore(&camif->slock, flags);
>>>> +               ret = s3c_camif_hw_vp_init(camif, vp);
>>>> +       }
>>>> +
>>>> +       if (ret<  0) {
>>>> +               camif_reinitialize(vp);
>>>> +               return ret;
>>>> +       }
>>>> +
>>>> +       spin_lock_irqsave(&camif->slock, flags);
>>
>>
>> Could you please check this function? Is it ok that you have double
>> spin_lock_irqsave()? I don't know may be it's okay. Also when you call
>> camif_reinitialize() you didn't call spin_unlock_irqrestore() before and
>> inside camif_reinitialize() you will also call spin_lock_irqsave()..
>
>
> Certainly with nested spinlock locking this code would have been useless.
> I suppose this is what you mean by "double spin_lock_irqsave()". Since
> it is known to work there must be spin_unlock_irqrestore() somewhere,
> before the second spin_lock_irqsave() above. Just look around with more
> focus ;)

You are right. I'm very sorry, i need to be more focus :)

-- 
Best regards, Klimov Alexey
