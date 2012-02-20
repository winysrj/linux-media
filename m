Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54297 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752205Ab2BTOyQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Feb 2012 09:54:16 -0500
Received: by lagu2 with SMTP id u2so6361605lag.19
        for <linux-media@vger.kernel.org>; Mon, 20 Feb 2012 06:54:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1202201310030.2836@axis700.grange>
References: <1327925653-13310-1-git-send-email-javier.martin@vista-silicon.com>
	<1327925653-13310-4-git-send-email-javier.martin@vista-silicon.com>
	<Pine.LNX.4.64.1202201310030.2836@axis700.grange>
Date: Mon, 20 Feb 2012 15:54:14 +0100
Message-ID: <CACKLOr3or_v5m2b1t_U3r=YmwhWJ0+6iSbwtXQkE8ftO7kghag@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] media i.MX27 camera: handle overflows properly.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 20 February 2012 13:17, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
>> @@ -1302,21 +1305,12 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
>>                       __func__);
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
>> -     if (((status & (3 << 5)) == (3 << 5)) ||
>> +             buf = list_entry(pcdev->active_bufs.next,
>> +                     struct mx2_buffer, queue);
>> +             mx27_camera_frame_done_emma(pcdev,
>> +                                     buf->bufnum, true);
>> +             status &= ~(1 << 7);
>> +     } else if (((status & (3 << 5)) == (3 << 5)) ||
>
> This means, in case of an overflow you don't reset the channels any more?
> Is there a reason for that?

Apparently, while I added the "returning an error frame, and continue
with the next one" part I accidentally removed the "resetting the
buffer" part.

Let me send a v4 version of this patch. I hope to have it ready for tomorrow.

-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
