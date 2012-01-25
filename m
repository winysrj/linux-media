Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:45011 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab2AYPvO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 10:51:14 -0500
Received: by werb13 with SMTP id b13so3900527wer.19
        for <linux-media@vger.kernel.org>; Wed, 25 Jan 2012 07:51:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1201251123290.18778@axis700.grange>
References: <1327059392-29240-1-git-send-email-javier.martin@vista-silicon.com>
	<1327059392-29240-3-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1201251123290.18778@axis700.grange>
Date: Wed, 25 Jan 2012 16:51:13 +0100
Message-ID: <CACKLOr0smPoSMYqS=iS8tx2DoH1V_tjmoNdgFMDrqQeVZMcKHg@mail.gmail.com>
Subject: Re: [PATCH 2/4] media i.MX27 camera: add start_stream and stop_stream callbacks.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de,
	baruch@tkos.co.il
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 25 January 2012 11:26, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> As discussed before, please, merge this patch with
>
> "media i.MX27 camera: properly detect frame loss."

Yes. You can drop that patch already.

> One more cosmetic note:
>
> On Fri, 20 Jan 2012, Javier Martin wrote:
>
>> Add "start_stream" and "stop_stream" callback in order to enable
>> and disable the eMMa-PrP properly and save CPU usage avoiding
>> IRQs when the device is not streaming.
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>>  drivers/media/video/mx2_camera.c |  107 +++++++++++++++++++++++++++-----------
>>  1 files changed, 77 insertions(+), 30 deletions(-)
>>
>> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
>> index 290ac9d..4816da6 100644
>> --- a/drivers/media/video/mx2_camera.c
>> +++ b/drivers/media/video/mx2_camera.c
>> @@ -560,7 +560,6 @@ static void mx2_videobuf_queue(struct vb2_buffer *vb)
>>       struct soc_camera_host *ici =
>>               to_soc_camera_host(icd->parent);
>>       struct mx2_camera_dev *pcdev = ici->priv;
>> -     struct mx2_fmt_cfg *prp = pcdev->emma_prp;
>>       struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
>>       unsigned long flags;
>>
>> @@ -572,29 +571,7 @@ static void mx2_videobuf_queue(struct vb2_buffer *vb)
>>       buf->state = MX2_STATE_QUEUED;
>>       list_add_tail(&buf->queue, &pcdev->capture);
>>
>> -     if (mx27_camera_emma(pcdev)) {
>> -             if (prp->cfg.channel == 1) {
>> -                     writel(PRP_CNTL_CH1EN |
>> -                             PRP_CNTL_CSIEN |
>> -                             prp->cfg.in_fmt |
>> -                             prp->cfg.out_fmt |
>> -                             PRP_CNTL_CH1_LEN |
>> -                             PRP_CNTL_CH1BYP |
>> -                             PRP_CNTL_CH1_TSKIP(0) |
>> -                             PRP_CNTL_IN_TSKIP(0),
>> -                             pcdev->base_emma + PRP_CNTL);
>> -             } else {
>> -                     writel(PRP_CNTL_CH2EN |
>> -                             PRP_CNTL_CSIEN |
>> -                             prp->cfg.in_fmt |
>> -                             prp->cfg.out_fmt |
>> -                             PRP_CNTL_CH2_LEN |
>> -                             PRP_CNTL_CH2_TSKIP(0) |
>> -                             PRP_CNTL_IN_TSKIP(0),
>> -                             pcdev->base_emma + PRP_CNTL);
>> -             }
>> -             goto out;
>> -     } else { /* cpu_is_mx25() */
>> +     if (!mx27_camera_emma(pcdev)) { /* cpu_is_mx25() */
>>               u32 csicr3, dma_inten = 0;
>>
>>               if (pcdev->fb1_active == NULL) {
>> @@ -629,8 +606,6 @@ static void mx2_videobuf_queue(struct vb2_buffer *vb)
>>                       writel(csicr3, pcdev->base_csi + CSICR3);
>>               }
>>       }
>> -
>> -out:
>
> To my taste you're a bit too aggressive on blank lines;-) This also holds
> for the previous patch. Unless you absolutely have to edit your sources in
> a 24-line terminal, keeping those empty lines would be appreciated:-)

OK. I'll try to overcome my anger ^^

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
