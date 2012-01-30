Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:45558 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab2A3JOr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jan 2012 04:14:47 -0500
Received: by werb13 with SMTP id b13so3232283wer.19
        for <linux-media@vger.kernel.org>; Mon, 30 Jan 2012 01:14:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1201271643040.32661@axis700.grange>
References: <1327579472-31597-1-git-send-email-javier.martin@vista-silicon.com>
	<1327579472-31597-2-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1201271643040.32661@axis700.grange>
Date: Mon, 30 Jan 2012 10:14:46 +0100
Message-ID: <CACKLOr0F0wsc9zKGoFyCgMgCjzPq4uYe7n-LwpM-ahExYfJVWQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] media i.MX27 camera: add start_stream and
 stop_stream callbacks.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de,
	baruch@tkos.co.il
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 27 January 2012 16:53, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Thu, 26 Jan 2012, Javier Martin wrote:
>
>> Add "start_stream" and "stop_stream" callback in order to enable
>> and disable the eMMa-PrP properly and save CPU usage avoiding
>> IRQs when the device is not streaming. This also makes the driver
>> return 0 as the sequence number of the first frame.
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>>  Merge "media i.MX27 camera: properly detect frame loss"
>>
>> ---
>>  drivers/media/video/mx2_camera.c |  104 +++++++++++++++++++++++++++++---------
>>  1 files changed, 79 insertions(+), 25 deletions(-)
>>
>> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
>> index 898f98f..045c018 100644
>> --- a/drivers/media/video/mx2_camera.c
>> +++ b/drivers/media/video/mx2_camera.c
>> @@ -377,7 +377,7 @@ static int mx2_camera_add_device(struct soc_camera_device *icd)
>>       writel(pcdev->csicr1, pcdev->base_csi + CSICR1);
>>
>>       pcdev->icd = icd;
>> -     pcdev->frame_count = 0;
>> +     pcdev->frame_count = -1;
>>
>>       dev_info(icd->parent, "Camera driver attached to camera %d\n",
>>                icd->devnum);
>> @@ -647,11 +647,83 @@ static void mx2_videobuf_release(struct vb2_buffer *vb)
>>       spin_unlock_irqrestore(&pcdev->lock, flags);
>>  }
>>
>> +static int mx2_start_streaming(struct vb2_queue *q, unsigned int count)
>> +{
>> +     struct soc_camera_device *icd = soc_camera_from_vb2q(q);
>> +     struct soc_camera_host *ici =
>> +             to_soc_camera_host(icd->parent);
>> +     struct mx2_camera_dev *pcdev = ici->priv;
>> +     struct mx2_fmt_cfg *prp = pcdev->emma_prp;
>> +     unsigned long flags;
>> +     int ret = 0;
>> +
>> +     spin_lock_irqsave(&pcdev->lock, flags);
>> +     if (mx27_camera_emma(pcdev)) {
>> +             if (count < 2) {
>> +                     ret = -EINVAL;
>> +                     goto err;
>> +             }
>
> How about:
>
>        if (mx27_camera_emma(pcdev)) {
>                unsigned long flags;
>                if (count < 2)
>                        return -EINVAL;
>
>                spin_lock_irqsave(&pcdev->lock, flags);
>                ...
>                spin_unlock_irqrestore(&pcdev->lock, flags);
>        }
>
>        return 0;

OK, this is definitely cleaner. I'll do it for v3.

> Another point: in v1 of this patch you also removed "goto out" from
> mx2_videobuf_queue(). I understand this is probably unrelated to this
> patch now. Anyway, if you don't find a patch out of your 4 now, where it
> logically would fit, you could either make an additional patch, or I could
> do it myself, if I don't forget:-)

Don't worry,
I'll send a new series including that patch after this one gets merged.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
