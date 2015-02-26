Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:43548 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735AbbBZPMh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Feb 2015 10:12:37 -0500
Received: by ykp9 with SMTP id 9so4313955ykp.10
        for <linux-media@vger.kernel.org>; Thu, 26 Feb 2015 07:12:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54EE90BF.2030602@redmandi.dyndns.org>
References: <54EE90BF.2030602@redmandi.dyndns.org>
Date: Thu, 26 Feb 2015 10:12:36 -0500
Message-ID: <CALzAhNX=KCnLmcv3iNtCwH2OLSTErytvK1kZpGCbAyQtmt6How@mail.gmail.com>
Subject: Re: [PATCH] [media] saa7164: use an MSI interrupt when available
From: Steven Toth <stoth@kernellabs.com>
To: Brendan McGrath <redmcg@redmandi.dyndns.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I believe the root cause of the crash is due to a DMA/IRQ race condition. It
> most commonly occurs when the saa7164 driver is dealing with more than one
> saa7164 chip (the HVR-2200 and HVR-2250 for example have two - one for each
> tuner). Given MSI avoids DMA/IRQ race conditions - this would explain why
> the patch works as a fix.

Brendan, thanks.

With MSI I've had some people report complete success, others still
have the issues.

In my experience this does help with i2c timeout issues but not
completely in every case. I've also seen it with single card instances
so you descripton above is close - but not quiet accurate in all
cases.

While I'm generally OK with changing the driver behaviour to enable
MSI by default, please add a module option to allow the behaviour to
be disabled, reverting the driver back to existing behaviour.

Once this is done, I'll be happy to Ack it.

Thanks again.

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
