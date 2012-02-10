Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:48388 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754262Ab2BJIBw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Feb 2012 03:01:52 -0500
Received: by lagu2 with SMTP id u2so2149719lag.19
        for <linux-media@vger.kernel.org>; Fri, 10 Feb 2012 00:01:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1202092328450.18719@axis700.grange>
References: <1328609682-18014-1-git-send-email-javier.martin@vista-silicon.com>
	<CACKLOr0ioy2rxKY7PUBDCBPaQG0FUv0Drt-GNgBnNmFDt05T-w@mail.gmail.com>
	<Pine.LNX.4.64.1202092328450.18719@axis700.grange>
Date: Fri, 10 Feb 2012 09:01:50 +0100
Message-ID: <CACKLOr0p_ggtftXu1G1VbG7g+ZBvD4H707NY4o8-tAz6kP5epw@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] media i.MX27 camera: improve discard buffer handling.
From: javier Martin <javier.martin@vista-silicon.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 9 February 2012 23:36, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Hi Javier
>
> On Thu, 9 Feb 2012, javier Martin wrote:
>
>> Hi Guennadi,
>> I understand you are probably quite busy right now but it would be
>> great if you could ack this patch. The sooner you merge it the sooner
>> I will start working on the cleanup series. I've got some time on my
>> hands now.
>
> Yes, I can take this version, at the same time, I have a couple of
> comments, that you might find useful to address in a clean-up patch;-) Or
> just leave them as they are...


Of course,
I'm the most interested person on this driver being as better as possible.

> [anip]
>
>
>> > @@ -1274,6 +1298,15 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
>> >        struct mx2_camera_dev *pcdev = data;
>> >        unsigned int status = readl(pcdev->base_emma + PRP_INTRSTATUS);
>> >        struct mx2_buffer *buf;
>> > +       unsigned long flags;
>> > +
>> > +       spin_lock_irqsave(&pcdev->lock, flags);
>
> It wasn't an accident, that I wrote "spin_lock()" - without the "_irqsave"
> part. You are in an ISR here, and this is the only IRQ, that your driver
> has to protect against, so, here, I think, you don't have to block other
> IRQs.

Ok,
>> > +
>> > +       if (list_empty(&pcdev->active_bufs)) {
>> > +               dev_warn(pcdev->dev, "%s: called while active list is empty\n",
>> > +                       __func__);
>> > +               goto irq_ok;
>
> This means, you return IRQ_HANDLED here without even checking whether any
> of your status bits are actually set. So, if you get an interrupt here
> with an empty list, it might indeed be the case of a shared IRQ, in which
> case you'd have to return IRQ_NONE.

Got it.

>> > +       }
>> >
>> >        if (status & (1 << 7)) { /* overflow */
>> >                u32 cntl;
>
> As I said - we can keep this version, but maybe you'll like to improve at
> least the latter of the above two snippets.

I'd rather you merge this as it is, because it really fixes a driver
which is currently buggy. I'll send a clean up series adressing the
following issues next week:
1. Eliminate the unwanted "goto".
2. Use list_first_entry() macro.
3. Use spin_lock() in ISR.
4. Return IRQ_NONE if list is empty and no status bit is set.
5. Integrate discard buffers in a more efficient way.

Regards.
-- 
Javier Martin
Vista Silicon S.L.
CDTUC - FASE C - Oficina S-345
Avda de los Castros s/n
39005- Santander. Cantabria. Spain
+34 942 25 32 60
www.vista-silicon.com
