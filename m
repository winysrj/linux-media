Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:55278 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbbBZUc6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 15:32:58 -0500
Received: by mail-qg0-f45.google.com with SMTP id h3so10762750qgf.4
        for <linux-media@vger.kernel.org>; Thu, 26 Feb 2015 12:32:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALzAhNX=KCnLmcv3iNtCwH2OLSTErytvK1kZpGCbAyQtmt6How@mail.gmail.com>
References: <54EE90BF.2030602@redmandi.dyndns.org> <CALzAhNX=KCnLmcv3iNtCwH2OLSTErytvK1kZpGCbAyQtmt6How@mail.gmail.com>
From: Kyle Sanderson <kyle.leet@gmail.com>
Date: Thu, 26 Feb 2015 12:32:37 -0800
Message-ID: <CACsaVZJ2aP9JAjRZxKv7vrsLce_r0BowfGCBd6c-XLe8PJsS9g@mail.gmail.com>
Subject: Re: [PATCH] [media] saa7164: use an MSI interrupt when available
To: stoth@linuxtv.org
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The patch allows the card to support using both internal tuners
without crashing out. I've been recording significantly since the
23rd, it just works now in comparison to constant maintenance.

I am under the impression it was against the spec to have a PCI-E card
without MSI support. Wouldn't the fallback code as well work in this
regard?

Tested-by: Kyle Sanderson <kyle.leet@gmail.com>

Thanks a ton for the patch,
Kyle.

On Thu, Feb 26, 2015 at 7:12 AM, Steven Toth <stoth@kernellabs.com> wrote:
>> I believe the root cause of the crash is due to a DMA/IRQ race condition. It
>> most commonly occurs when the saa7164 driver is dealing with more than one
>> saa7164 chip (the HVR-2200 and HVR-2250 for example have two - one for each
>> tuner). Given MSI avoids DMA/IRQ race conditions - this would explain why
>> the patch works as a fix.
>
> Brendan, thanks.
>
> With MSI I've had some people report complete success, others still
> have the issues.
>
> In my experience this does help with i2c timeout issues but not
> completely in every case. I've also seen it with single card instances
> so you descripton above is close - but not quiet accurate in all
> cases.
>
> While I'm generally OK with changing the driver behaviour to enable
> MSI by default, please add a module option to allow the behaviour to
> be disabled, reverting the driver back to existing behaviour.
>
> Once this is done, I'll be happy to Ack it.
>
> Thanks again.
>
> - Steve
>
> --
> Steven Toth - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
