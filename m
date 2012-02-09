Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:50500 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2BIWg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Feb 2012 17:36:57 -0500
Date: Thu, 9 Feb 2012 23:36:49 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, s.hauer@pengutronix.de
Subject: Re: [PATCH v4 3/4] media i.MX27 camera: improve discard buffer
 handling.
In-Reply-To: <CACKLOr0ioy2rxKY7PUBDCBPaQG0FUv0Drt-GNgBnNmFDt05T-w@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1202092328450.18719@axis700.grange>
References: <1328609682-18014-1-git-send-email-javier.martin@vista-silicon.com>
 <CACKLOr0ioy2rxKY7PUBDCBPaQG0FUv0Drt-GNgBnNmFDt05T-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier

On Thu, 9 Feb 2012, javier Martin wrote:

> Hi Guennadi,
> I understand you are probably quite busy right now but it would be
> great if you could ack this patch. The sooner you merge it the sooner
> I will start working on the cleanup series. I've got some time on my
> hands now.

Yes, I can take this version, at the same time, I have a couple of 
comments, that you might find useful to address in a clean-up patch;-) Or 
just leave them as they are...

[anip]


> > @@ -1274,6 +1298,15 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
> >        struct mx2_camera_dev *pcdev = data;
> >        unsigned int status = readl(pcdev->base_emma + PRP_INTRSTATUS);
> >        struct mx2_buffer *buf;
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&pcdev->lock, flags);

It wasn't an accident, that I wrote "spin_lock()" - without the "_irqsave" 
part. You are in an ISR here, and this is the only IRQ, that your driver 
has to protect against, so, here, I think, you don't have to block other 
IRQs.

> > +
> > +       if (list_empty(&pcdev->active_bufs)) {
> > +               dev_warn(pcdev->dev, "%s: called while active list is empty\n",
> > +                       __func__);
> > +               goto irq_ok;

This means, you return IRQ_HANDLED here without even checking whether any 
of your status bits are actually set. So, if you get an interrupt here 
with an empty list, it might indeed be the case of a shared IRQ, in which 
case you'd have to return IRQ_NONE.

> > +       }
> >
> >        if (status & (1 << 7)) { /* overflow */
> >                u32 cntl;

As I said - we can keep this version, but maybe you'll like to improve at 
least the latter of the above two snippets.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
