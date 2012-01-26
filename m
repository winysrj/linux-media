Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48787 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047Ab2AZLp1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jan 2012 06:45:27 -0500
Received: by wgbed3 with SMTP id ed3so530791wgb.1
        for <linux-media@vger.kernel.org>; Thu, 26 Jan 2012 03:45:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1201251314230.18778@axis700.grange>
References: <1327059392-29240-1-git-send-email-javier.martin@vista-silicon.com>
	<1327059392-29240-5-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1201251314230.18778@axis700.grange>
Date: Thu, 26 Jan 2012 12:45:25 +0100
Message-ID: <CACKLOr37mU0sj_MZ+iW2v2nrBY_6WP5Z6AKD6PtfY9XV18jCkQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] media i.MX27 camera: handle overflows properly.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de,
	baruch@tkos.co.il
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 25 January 2012 13:17, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> On Fri, 20 Jan 2012, Javier Martin wrote:
>
>>
>> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
>> ---
>>  drivers/media/video/mx2_camera.c |   23 +++++++++--------------
>>  1 files changed, 9 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
>> index e0c5dd4..cdc614f 100644
>> --- a/drivers/media/video/mx2_camera.c
>> +++ b/drivers/media/video/mx2_camera.c
>> @@ -1274,7 +1274,10 @@ static void mx27_camera_frame_done_emma(struct mx2_camera_dev *pcdev,
>>               buf->state = state;
>>               do_gettimeofday(&vb->v4l2_buf.timestamp);
>>               vb->v4l2_buf.sequence = pcdev->frame_count;
>> -             vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
>> +             if (state == MX2_STATE_ERROR)
>> +                     vb2_buffer_done(vb, VB2_BUF_STATE_ERROR);
>> +             else
>> +                     vb2_buffer_done(vb, VB2_BUF_STATE_DONE);
>>       }
>>
>>       pcdev->frame_count++;
>> @@ -1309,19 +1312,11 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
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
>> +             buf = list_entry(pcdev->active_bufs.next,
>> +                     struct mx2_buffer, queue);
>> +             mx27_camera_frame_done_emma(pcdev,
>> +                                     buf->bufnum, MX2_STATE_ERROR);
>> +             status &= ~(1 << 7);
>>       }
>>       if ((((status & (3 << 5)) == (3 << 5)) ||
>
> Does it make sense continuing processing here, if an error occurred? To me
> all the four "if" statements in this function seem mutually-exclusive and
> should be handled by a
>
>        if () {
>        } else if () {
>        ...
> chain.
>
>>               ((status & (3 << 3)) == (3 << 3)))

Yes, as you point out, everything is mutually exclusive.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
