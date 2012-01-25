Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:40240 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab2AYPcA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 10:32:00 -0500
Received: by werb13 with SMTP id b13so3884052wer.19
        for <linux-media@vger.kernel.org>; Wed, 25 Jan 2012 07:31:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1201241819240.27814@axis700.grange>
References: <1327059392-29240-1-git-send-email-javier.martin@vista-silicon.com>
	<1327059392-29240-2-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1201241819240.27814@axis700.grange>
Date: Wed, 25 Jan 2012 16:31:58 +0100
Message-ID: <CACKLOr0Sv_0w6rPt7_xXWPKXoZskDz-+DHVVummZZ_8Kf8g9hw@mail.gmail.com>
Subject: Re: [PATCH 1/4] media i.MX27 camera: migrate driver to videobuf2
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>, baruch@tkos.co.il
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,
thank you for your review.

>>       u32                     frame_count;
>> +     struct vb2_alloc_ctx    *alloc_ctx;
>> +};
>> +
>> +enum mx2_buffer_state {
>> +     MX2_STATE_NEEDS_INIT = 0,
>> +     MX2_STATE_PREPARED   = 1,
>> +     MX2_STATE_QUEUED     = 2,
>> +     MX2_STATE_ACTIVE     = 3,
>> +     MX2_STATE_DONE       = 4,
>> +     MX2_STATE_ERROR      = 5,
>> +     MX2_STATE_IDLE       = 6,
>
> Are the numerical values important? If not - please, drop. And actually,
> you don't need most of these states, I wouldn't be surprised, if you
> didn't need them at all. You might want to revise them in a future patch.

Yes, you are right, I might have been too cautious here. I will make
mx27 not to depend on these states and will try to reduce them.
However, those ones used by mx25 I can't eliminate since I don't have
the possibility to test it.

> [snip]
>
>> @@ -467,59 +479,47 @@ static irqreturn_t mx25_camera_irq(int irq_csi, void *data)
>>  /*
>>   *  Videobuf operations
>>   */
>> -static int mx2_videobuf_setup(struct videobuf_queue *vq, unsigned int *count,
>> -                           unsigned int *size)
>> +static int mx2_videobuf_setup(struct vb2_queue *vq,
>> +                     const struct v4l2_format *fmt,
>> +                     unsigned int *count, unsigned int *num_planes,
>> +                     unsigned int sizes[], void *alloc_ctxs[])
>>  {
>> -     struct soc_camera_device *icd = vq->priv_data;
>> +     struct soc_camera_device *icd = soc_camera_from_vb2q(vq);
>> +     struct soc_camera_host *ici = to_soc_camera_host(icd->parent);
>> +     struct mx2_camera_dev *pcdev = ici->priv;
>>       int bytes_per_line = soc_mbus_bytes_per_line(icd->user_width,
>>                       icd->current_fmt->host_fmt);
>
> You choose not to support VIDIOC_CREATE_BUFS? You have to at least return
> an error if fmt != NULL. Or consider supporting it - look at mx3_camera.c
> or sh_mobile_ceu_camera.c (btw, atmel-isi.c has to be fixed with this
> respect too). If you decide to support it, you'll also have to drop
> .buf_prepare() (see, e.g., 07f92448045a23d27dbc3ece3abcb6bafc618d43)

I'm a bit tight on schedule and would prefer just returning NULL by
now and add this in a further patch if you are so kind.

> [snip]
>
>> @@ -529,46 +529,34 @@ static int mx2_videobuf_prepare(struct videobuf_queue *vq,
>>        * This can be useful if you want to see if we actually fill
>>        * the buffer with something
>>        */
>> -     memset((void *)vb->baddr, 0xaa, vb->bsize);
>> +     memset((void *)vb2_plane_vaddr(vb, 0),
>> +            0xaa, vb2_get_plane_payload(vb, 0));
>>  #endif
>>
>> -     if (buf->code   != icd->current_fmt->code ||
>> -         vb->width   != icd->user_width ||
>> -         vb->height  != icd->user_height ||
>> -         vb->field   != field) {
>> +     if (buf->code   != icd->current_fmt->code) {
>>               buf->code       = icd->current_fmt->code;
>> -             vb->width       = icd->user_width;
>> -             vb->height      = icd->user_height;
>> -             vb->field       = field;
>> -             vb->state       = VIDEOBUF_NEEDS_INIT;
>> +             buf->state      = MX2_STATE_NEEDS_INIT;
>
> This looks broken or most likely redundant to me. The check for a changed
> code was there to reallocate the buffer, doesn't seem to make much sense
> now.

Yes, this will definitely go away and will take MX2_STATE_NEEDS_INIT with it.

> [snip]
>
>> @@ -686,10 +673,10 @@ static void mx2_videobuf_release(struct videobuf_queue *vq,
>>        * types.
>>        */
>>       spin_lock_irqsave(&pcdev->lock, flags);
>> -     if (vb->state == VIDEOBUF_QUEUED) {
>> -             list_del(&vb->queue);
>> -             vb->state = VIDEOBUF_ERROR;
>> -     } else if (cpu_is_mx25() && vb->state == VIDEOBUF_ACTIVE) {
>> +     if (buf->state == MX2_STATE_QUEUED || buf->state == MX2_STATE_ACTIVE) {
>> +             list_del_init(&buf->queue);
>> +             buf->state = MX2_STATE_NEEDS_INIT;
>> +     } else if (cpu_is_mx25() && buf->state == MX2_STATE_ACTIVE) {
>
> This doesn't look right. You already have " || buf->state ==
> MX2_STATE_ACTIVE" above, so, this latter condition is never entered?

Yeah, I'm probably breaking m25 support here. This will be fixed in
the following version of my patches.

Regards.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
