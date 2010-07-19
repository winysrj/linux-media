Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:45015 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab0GSHpD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Jul 2010 03:45:03 -0400
Subject: Re: [PATCH v4 2/5] MFD: WL1273 FM Radio: MFD driver for the FM
 radio.
From: m7aalton <matti.j.aaltonen@nokia.com>
Reply-To: matti.j.aaltonen@nokia.com
To: ext Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	Valentin Eduardo <eduardo.valentin@nokia.com>
In-Reply-To: <4C329631.1040901@redhat.com>
References: <1275647663-20650-1-git-send-email-matti.j.aaltonen@nokia.com>
	 <1275647663-20650-2-git-send-email-matti.j.aaltonen@nokia.com>
	 <1275647663-20650-3-git-send-email-matti.j.aaltonen@nokia.com>
	 <4C329631.1040901@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 10:43:42 +0300
Message-ID: <1279525422.15203.3.camel@masi.mnp.nokia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello and

thanks for the comments Mauro... One quick comment:

On Tue, 2010-07-06 at 04:34 +0200, ext Mauro Carvalho Chehab wrote:
> > +                     core->rx_frequency =
> > +                             bands[core->band].bottom_frequency +
> > +                             freq * 50;
> > +
> > +                     /*
> > +                      *  The driver works better with this msleep,
> > +                      *  the documentation doesn't mention it.
> > +                      */
> > +                     msleep(10);
> 
> 
> msleep on an irq handler? You shouldn't be doing it! You're not allowed to sleep
> during IRQ time. Kernel can panic here. You'll probably need to defer work and
> handle it outside irq time.


This is not the IRQ handler, this is the irq thread function.

> > +
> > +             r = request_threaded_irq(client->irq, NULL,
> > +                                      wl1273_fm_irq_thread_handler,
> > +                                      IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
> > +                                      "wl1273-fm", core);


B.R.
Matti A.


