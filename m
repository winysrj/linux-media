Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39042 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2A3MHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jan 2012 07:07:48 -0500
Received: by wics10 with SMTP id s10so3330710wic.19
        for <linux-media@vger.kernel.org>; Mon, 30 Jan 2012 04:07:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1201271914580.32661@axis700.grange>
References: <1327579472-31597-1-git-send-email-javier.martin@vista-silicon.com>
	<1327579472-31597-4-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1201271914580.32661@axis700.grange>
Date: Mon, 30 Jan 2012 13:07:46 +0100
Message-ID: <CACKLOr3UPWFTSLGquL6asr_WD8QRcSP79w=OvX9UpkHb82eSvQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] media i.MX27 camera: handle overflows properly.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 27 January 2012 19:16, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> (removed baruch@tkos.co.il - it bounces)
>
> On Thu, 26 Jan 2012, Javier Martin wrote:
>
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>>  Changes since v1:
>>  - Make ifs in irq callback mutually exclusive.
>>  - Add new argument to mx27_camera_frame_done_emma() to handle errors.
>>
>> ---
>>  drivers/media/video/mx2_camera.c |   38 ++++++++++++++++----------------------
>>  1 files changed, 16 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
>> index 71054ab..1759673 100644
>> --- a/drivers/media/video/mx2_camera.c
>> +++ b/drivers/media/video/mx2_camera.c
>> @@ -1213,7 +1213,7 @@ static struct soc_camera_host_ops mx2_soc_camera_host_ops = {
>>  };
>>
>>  static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
>> -             int bufnum)
>> +             int bufnum, bool err)
>>  {
>>       struct mx2_buffer *buf;
>>       struct vb2_buffer *vb;
>> @@ -1262,7 +1262,10 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
>>               list_del_init(&buf->queue);
>>               do_gettimeofday(&vb->v4l2_buf.timestamp);
>>               vb->v4l2_buf.sequence = pcdev->frame_count;
>> -             vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
>> +             if (err)
>> +                     vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
>> +             else
>> +                     vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
>>       }
>>
>>       pcdev->frame_count++;
>> @@ -1297,21 +1300,12 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
>>       struct mx2_buffer *buf;
>>
>>       if (status & (1 << 7)) { /* overflow */
>> -             u32 cntl;
>> -             /*
>> -              * We only disable channel 1 here since this is the only
>> -              * enabled channel
>> -              *
>> -              * FIXME: the correct DMA overflow handling should be resetting
>> -              * the buffer, returning an error frame, and continuing with
>> -              * the next one.
>> -              */
>> -             cntl = readl(pcdev->base_emma + PRP_CNTL);
>> -             writel(cntl & ~(PRP_CNTL_CH1EN | PRP_CNTL_CH2EN),
>> -                    pcdev->base_emma + PRP_CNTL);
>> -             writel(cntl, pcdev->base_emma + PRP_CNTL);
>> -     }
>> -     if ((((status & (3 << 5)) == (3 << 5)) ||
>> +             buf = list_entry(pcdev->active_bufs.next,
>> +                     struct mx2_buffer, queue);
>> +             mx27_camera_frame_done_emma(pcdev,
>> +                                     buf->bufnum, 1);
>
> use "true" for bool variables.
>
>> +             status &= ~(1 << 7);
>> +     } else if ((((status & (3 << 5)) == (3 << 5)) ||
>>               ((status & (3 << 3)) == (3 << 3)))
>>                       && !list_empty(&pcdev->active_bufs)) {
>>               /*
>> @@ -1320,13 +1314,13 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
>>                */
>>               buf = list_entry(pcdev->active_bufs.next,
>>                       struct mx2_buffer, queue);
>> -             mx27_camera_frame_done_emma(pcdev, buf->bufnum);
>> +             mx27_camera_frame_done_emma(pcdev, buf->bufnum, 0);
>
> "false"
>
>>               status &= ~(1 << (6 - buf->bufnum)); /* mark processed */
>> +     } else if ((status & (1 << 6)) || (status & (1 << 4))) {
>> +             mx27_camera_frame_done_emma(pcdev, 0, 0);
>
> "false"
>
>> +     } else if ((status & (1 << 5)) || (status & (1 << 3))) {
>> +             mx27_camera_frame_done_emma(pcdev, 1, 0);
>
> "false"
>
>>       }
>> -     if ((status & (1 << 6)) || (status & (1 << 4)))
>> -             mx27_camera_frame_done_emma(pcdev, 0);
>> -     if ((status & (1 << 5)) || (status & (1 << 3)))
>> -             mx27_camera_frame_done_emma(pcdev, 1);
>>
>>       writel(status, pcdev->base_emma + PRP_INTRSTATUS);
>>

Don't worry, this will be fixed in v3.



-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
